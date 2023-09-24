function importMRDfile(app, mrdfile)


% MRD file selected
mrdfile = strcat(app.mrdImportPath, mrdfile);


% Load the data
app.TextMessage('Reading MRD file ...');
[~, fName, ~] = fileparts(mrdfile);
if contains(fName,'retro') || contains(fName,'p2roud')
    [data,~,app.parameters] = Get_mrd_3D4(mrdfile,'seq','seq');
    if isfield(app.parameters,'pe2_centric_on')
        if app.parameters.pe2_centric_on
            [data,~,app.parameters] = Get_mrd_3D4(mrdfile,'seq','cen');
        end
    end
else
    [data,~,app.parameters] = Get_mrd_3D4(mrdfile,'seq','cen');
    if isfield(app.parameters,'pe2_centric_on')
        if ~app.parameters.pe2_centric_on
            [data,~,app.parameters] = Get_mrd_3D4(mrdfile,'seq','seq');
        end
    end
end


% Check that number of flip angles > 2
if isfield(app.parameters,'VFA_size')
    if app.parameters.VFA_size > 2

        if isfield(app.parameters,'NO_VIEWS_2')
            if app.parameters.NO_VIEWS_2 > 1

                % 3D Data

                % Check for multiple echo times
                if isfield(app.parameters,'NO_ECHOES')
                    if app.parameters.NO_ECHOES == 1
                        data1 = permute(data,[1 5 2 3 4]);
                    else
                        data1 = data;
                    end
                else
                    app.parameters.NO_ECHOES = 1;
                    data1 = permute(data,[1 5 2 3 4]);
                end

                % 3D fft the data
                app.TextMessage('3D Fast Fourier Transform ...');
                images = zeros(size(data1));
                for flipAngle = 1:app.parameters.VFA_size
                    for echo = 1:app.parameters.NO_ECHOES
                        images(flipAngle,echo,:,:,:) = abs(fft3reco(squeeze(data1(flipAngle,echo,:,:,:))));
                    end
                end

            else

                % 2D data

                % Check for multiple echo times
                if isfield(app.parameters,'NO_ECHOES')
                    data1 = permute(data,[1 5 3 2 4]);
                else
                    app.parameters.NO_ECHOES = 1;
                    data1 = permute(data,[1 5 3 2 4]);
                end

                % 2D fft the data
                app.TextMessage('2D Fast Fourier Transform ...');
                images = zeros(size(data1));
                for flipAngle = 1:app.parameters.VFA_size
                    for echo = 1:app.parameters.NO_ECHOES
                        for slice = 1:app.parameters.NO_SLICES
                            images(flipAngle,echo,:,slice,:) = abs(fft2reco(squeeze(data1(flipAngle,echo,:,slice,:))));
                        end
                    end
                end
                images = flip(flip(images,3),5);

                % Corrected slice thickness
                app.parameters.SLICE_THICKNESS = (app.parameters.SLICE_THICKNESS + app.parameters.SLICE_SEPARATION)*app.parameters.NO_SLICES;

            end
        end


        % Sort according to flip angles
        app.TextMessage('Sorting the data in ascending flip-angle order ...');
        app.image5D = zeros(size(images));
        [app.flipAngles, index] = sort(app.parameters.VFA_angles(1:app.parameters.VFA_size));
        app.flipAngles = app.flipAngles(1:size(images,1));
        for i=1:size(images,1)
            for j=1:app.parameters.NO_ECHOES
                app.image5D(i,j,:,:,:) = images(index(i),j,:,:,:);
            end
        end


        % Data = (flipangles, echoes, dimx, dimy, dimz)
        app.image5D = flip(permute(app.image5D,[1,2,5,3,4]),3);

        if contains(fName,'retro')
            app.image5D = flip(app.image5D,3);
        end


        % Normalize to convenient range
        app.image5D = round(32767*app.image5D/max(app.image5D(:)));


        % Sequence file name
        if ~isfield(app.parameters,'PPL')
            app.parameters.PPL = " ";
        end
        [~,app.parameters.tag,~] = fileparts(mrdfile);
        if ismac
            app.parameters.PPL = replace(app.parameters.PPL,'\','/');
        end
        [~,name,ext] = fileparts(app.parameters.PPL);
        app.parameters.PPL = strcat(name,ext);


        % Ready
        app.validDataFileFlag = true;
        app.validRecoFlag = true;
        app.TextMessage('Data import ready ...');

    else

        % Number of flip angles < 3
        app.TextMessage('ERROR: Number of flip-angles should be at least 3 ...');

    end 
end




end