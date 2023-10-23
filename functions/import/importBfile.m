function err = importBfile(app, mrdFiles)

try
    
    err = 0;
    app.mrdImportPath = fileparts(mrdFiles{1});
    today = datetime;
    numFiles = length(mrdFiles);

    if numFiles < 3
        ME = MException('importBfile:invalidfile','Not enough data files ...');
        throw(ME);
    end

    for fn = 1:numFiles

        % Read the methods file
        [importPath,~] = fileparts([mrdFiles{fn},filesep]);
        methodFile = [importPath,filesep,'method'];
        if ~isfile(methodFile)
            ME = MException('importBfile:invalidfile','Method files does not exist ...');
            throw(ME);
        end
        info{fn} = jCampRead(methodFile); %#ok<*AGROW>

        % Slices
        pars{fn}.NO_SLICES = info{fn}.pvm.spackarrnslices;
        pars{fn}.SLICE_THICKNESS = str2num(info{fn}.pvm.slicethick);
        pars{fn}.SLICE_SEPARATION = info{fn}.pvm.spackarrslicegap;
        pars{fn}.SLICE_INTERLEAVE = 1;

        % Matrix in readout direction
        pars{fn}.NO_SAMPLES = double(info{fn}.pvm.matrix(1));

        % Matrix in phase encoding direction
        pars{fn}.NO_VIEWS = double(info{fn}.pvm.matrix(2));

        % Phase encoding orientation
        pars{fn}.PHASE_ORIENTATION = 1;
        pm1{fn} = -1;
        pm2{fn} = -1;

        % Determine how to flip the data for different orientations
        if isfield(info{fn}.pvm,'spackarrreadorient')
            if strcmp(info{fn}.pvm.spackarrreadorient(1:3),'L_R')
                pars{fn}.PHASE_ORIENTATION = 0;
                flr{fn} =  0;
                pm1{fn} = +1;
                pm2{fn} = -1;
            end
            if strcmp(info{fn}.pvm.spackarrreadorient(1:3),'A_P')
                pars{fn}.PHASE_ORIENTATION = 0;
                flr{fn} =  0;
                pm1{fn} = -1;
                pm2{fn} = -1;
            end
            if strcmp(info{fn}.pvm.spackarrreadorient(1:3),'H_F')
                pars{fn}.PHASE_ORIENTATION = 1;
                flr{fn} =  0;
                pm1{fn} = -1;
                pm2{fn} = -1;
            end
        end

        % Matrix in 2nd phase encoding direction
        pars{fn}.NO_VIEWS_2 = double(info{fn}.pvm.matrix(2));
        pars{fn}.pe2_centric_on = 0;

        % FOV
        pars{fn}.FOV = double(info{fn}.pvm.fov(1));
        pars{fn}.FOV2 = double(info{fn}.pvm.fov(2));
        pars{fn}.FOVf = round(8*(pars{fn}.FOV2/pars{fn}.FOV)*(pars{fn}.NO_SAMPLES/pars{fn}.NO_VIEWS));

        % Sequence parameters
        pars{fn}.tr = str2num(info{fn}.pvm.repetitiontime);
        pars{fn}.echotimes = str2num(info{fn}.pvm.echotime);

        pars{fn}.te = pars{fn}.echotimes(1);
        pars{fn}.NO_ECHOES = str2num(info{fn}.pvm.nmovieframes); % Movie frames in echoes
        pars{fn}.alpha = 2; % ?????
        pars{fn}.NO_AVERAGES = str2num(info{fn}.pvm.naverages);
        pars{fn}.tr_extra_us = 0;
        pars{fn}.ti = str2num(info{fn}.TimeForMovieFrames);  %% serves as frametime

        % Other parameters
        pars{fn}.date = today;
        pars{fn}.nucleus = '1H';
        pars{fn}.filename = 'Proton';
        pars{fn}.field_strength = info{fn}.pvm.frqwork(1)/42.58;
        pars{fn}.imagingFrequency = info{fn}.pvm.frqwork(1);
        pars{fn}.filename = 111;
        pars{fn}.pe1_order = 2;
        pars{fn}.radial_on = 0;
        pars{fn}.slice_nav = 0;
        pars{fn}.scanner = 'b-type';
        pars{fn}.filename = '111';
        pars{fn}.PPL = info{fn}.Method;
        pars{fn}.tag = 'btype';

        % Number of receiver coils
        pars{fn}.nr_coils = str2num(info{fn}.pvm.encnreceivers);

        % Assuming only 1 dynamic
        pars{fn}.EXPERIMENT_ARRAY = 1;

    end

    % Check whether files have same meta data
    for fn = 1:numFiles
        if ~isequal(pars{1},pars{fn})
            ME = MException('importBfile:invalidfile','Meta data do not match ...');
            throw(ME);
        end
    end

    % Flip angles
    for fn = 1:numFiles
        [importPath,~] = fileparts([mrdFiles{fn},filesep]);
        flist = dir([importPath,filesep,'pdata',filesep,'1',filesep,'dicom',filesep,'*.dcm']);
        if isempty(flist)
            ME = MException('importBfile:invalidfile','Dicom file not found ...');
            throw(ME);
        end
        dcminfo = dicominfo([flist(1).folder,filesep,flist(1).name]);
        fa(fn) = dcminfo.SharedFunctionalGroupsSequence.Item_1.MRTimingAndRelatedParametersSequence.Item_1.FlipAngle;
    end
    pars{1}.VFA_angles = fa;
    pars{1}.VFA_size = numFiles;

    % Return the paramters to the app
    app.parameters = pars{1};

    % Read the 2d-seq data, x y flip-angle echos slices
    for fn = 1:numFiles
        try
            [importPath,~] = fileparts([mrdFiles{fn},filesep]);
            [img{fn},hdr{fn}] = read2dseq([importPath,filesep,'pdata',filesep,'1',filesep]);
            % Image = image * scl_slope + scl_inter;
            img{fn} = abs(img{fn})*hdr{fn}.scl_slope + hdr{fn}.scl_inter;
        catch
            ME = MException('importBfile:invalidfile','Error reading 2dseq file ...');
            throw(ME);
        end
    end

    % Fill the image matrix
    images = zeros(numFiles,size(img{1},4),size(img{1},1),size(img{1},2),size(img{1},5));
    for fn = 1:numFiles
        % Data in the app = (flipangles, echoes, dimx, dimy, dimz)
        images(fn,:,:,:,:) = flip(permute(img{fn}(:,:,1,:,:),[3,4,1,2,5]),4);
    end

    % Sort according to flip angles
    app.TextMessage('Sorting the data in ascending flip-angle order ...');
    app.image5D = zeros(size(images));
    [app.flipAngles, index] = sort(app.parameters.VFA_angles(1:app.parameters.VFA_size));
    app.flipAngles = app.flipAngles(1:size(images,1));
    for i = 1:size(images,1)
        for j = 1:app.parameters.NO_ECHOES
            app.image5D(i,j,:,:,:) = images(index(i),j,:,:,:);
        end
    end

    % Normalize to convenient range
    app.image5D = round(32767*app.image5D/max(app.image5D(:)));

    % Ready
    app.validDataFileFlag = true;
    app.validRecoFlag = true;
    app.TextMessage('Data import ready ...');


catch ME

    err = 1;
    app.validDataFileFlag = false;
    app.validRecoFlag = false;
    app.TextMessage(ME.message);

end




%--------------------------------------------------------
%
% Functions
%
%--------------------------------------------------------

    function struct = jCampRead(filename) %#ok<STOUT>

        % Open file read-only big-endian
        fid = fopen(filename,'r','b');
        skipLine = 0;

        % Loop through separate lines
        if fid~=-1

            while 1

                if skipLine
                    line = nextLine;
                    skipLine = 0;
                else
                    line = fgetl(fid);
                end

                % Testing the text lines
                while length(line) < 2
                    line = fgetl(fid);
                end

                % Parameters and optional size of parameter are on lines starting with '##'
                if line(1:2) == '##' %#ok<*BDSCA>

                    % Parameter extracting and formatting
                    % Read parameter name
                    paramName = fliplr(strtok(fliplr(strtok(line,'=')),'#'));

                    % Check for illegal parameter names starting with '$' and correct (Matlab does not accepts variable names starting with $)
                    if paramName(1) == '$'
                        paramName = paramName(2:length(paramName));
                        % Check if EOF, if true return
                    elseif paramName(1:3) == 'END'
                        break
                    end

                    % Parameter value formatting
                    paramValue = fliplr(strtok(fliplr(line),'='));

                    % Check if parameter values are in a matrix and read the next line
                    if paramValue(1) == '('

                        paramValueSize = str2num(fliplr(strtok(fliplr(strtok(paramValue,')')),'('))); %#ok<*ST2NM>

                        % Create an empty matrix with size 'paramvaluesize' check if only one dimension
                        if ~isempty(paramValueSize)

                            if size(paramValueSize,2) == 1
                                paramValueSize = [paramValueSize,1];
                            end

                            % Read the next line
                            nextLine = fgetl(fid);

                            % See whether next line contains a character array
                            if nextLine(1) == '<'
                                paramValue = fliplr(strtok(fliplr(strtok(nextLine,'>')),'<')); %#ok<*NASGU>
                            elseif strcmp(nextLine(1),'L') || strcmp(nextLine(1),'A') || strcmp(nextLine(1),'H')
                                paramValue = nextLine;
                            else

                                % Check if matrix has more then one dimension
                                if paramValueSize(2) ~= 1

                                    paramValueLong = str2num(nextLine);
                                    while (length(paramValueLong)<(paramValueSize(1)*paramValueSize(2))) & (nextLine(1:2) ~= '##') %#ok<*AND2>
                                        nextLine = fgetl(fid);
                                        paramValueLong = [paramValueLong str2num(nextLine)];
                                    end

                                    if (length(paramValueLong) == (paramValueSize(1)*paramValueSize(2))) & (~isempty(paramValueLong))
                                        paramValue=reshape(paramValueLong,paramValueSize(1),paramValueSize(2));
                                    else
                                        paramValue = paramValueLong;
                                    end

                                    if length(nextLine) > 1
                                        if (nextLine(1:2) ~= '##')
                                            skipLine = 1;
                                        end
                                    end

                                else

                                    % If only 1 dimension just assign whole line to paramvalue
                                    try
                                        paramValue = str2num(nextLine);
                                        if ~isempty(str2num(nextLine))
                                            while length(paramValue)<paramValueSize(1)
                                                line = fgetl(fid);
                                                paramValue = [paramValue str2num(line)];
                                            end
                                        end
                                    catch
                                    end

                                end

                            end

                        else
                            paramValue = '';
                        end

                    end

                    % Add paramvalue to structure.paramname
                    if isempty(findstr(paramName,'_'))
                        eval(['struct.' paramName '= paramValue;']); %#ok<*EVLDOT>
                    else
                        try
                            eval(['struct.' lower(paramName(1:findstr(paramName,'_')-1)) '.' lower(paramName(findstr(paramName,'_')+1:length(paramName))) '= paramValue;']);
                        catch
                            eval(['struct.' lower(paramName(1:findstr(paramName,'_')-1)) '.' datestr(str2num(paramName(findstr(paramName,'_')+1:findstr(paramName,'_')+2)),9) ...
                                paramName(findstr(paramName,'_')+2:length(paramName)) '= paramValue;']); %#ok<DATST,*FSTR>
                        end
                    end

                elseif line(1:2) == '$$'
                    % The two $$ lines are not parsed for now
                end

            end

            % Close file
            fclose(fid);

        end

    end % jCampRead


    function [img,hdr] = read2dseq(path2dseq)

        % function [ img , hdr ] = read_2dseq(path2dseq)
        %
        % This function reads image data in the Bruker format and return it into
        % an array where each pixel is in double format. Also, it output the
        % spatial resolution (nom_resol) in mm.
        %

        if nargin < 1
            path2dseq  = uigetdir('Select the directory containing the targeted 2dseq');
        end
        % tic
        % fprintf('Reading from %s',path2dseq)
        if exist([path2dseq,'/2dseq'],'file')
            imagefile = [path2dseq,'/2dseq'];
        else
            error('2dseq does not exist!')
        end
        if exist([path2dseq,'/../../method'],'file')
            methodfile = [path2dseq,'/../../method'];
        else
            error('method does not exist!')
        end
        if exist([path2dseq,'/../../acqp'],'file')
            acqpfile = [path2dseq,'/../../acqp'];
        else
            error('acqp does not exist!')
        end
        if exist([path2dseq,'/reco'],'file')
            recofile = [path2dseq,'/reco'];
        else
            error('reco does not exist!')
        end
        if exist([path2dseq,'/visu_pars'],'file')
            visu_parsfile = [path2dseq,'/visu_pars'];
        else
            error('visu_pars does not exist!')
        end
        %%%%%%%%%%%%%% Parameter Reading %%%%%%%%%%%%%%
        % Default JACMP-DX Header
        % ##TITLE=Parameter List
        % ##JCAMPDX=4.24
        % ##DATATYPE=Parameter Values
        % ##ORIGIN=Bruker BioSpin MRI GmbH
        % ##OWNER=
        % fprintf('.')
        fp = fopen(methodfile,'r');
        method = fread(fp,[1 inf],'*char');
        [idx_sta,idx_end] = regexp(method,'##\$\w*=');
        fclose(fp);
        for idx = 1:length(idx_sta)
            switch method(idx_sta(idx)+3:idx_end(idx)-1)
                case 'Method' %string: Measuring method
                    Method = method(idx_end(idx)+1:idx_end(idx)+find_newline(method,idx_end(idx))-1);
                case 'PVM_NAverages' %integer: Number of times the signal is accumulated prior to the storage on disk and the reconstruction.
                    hdr.NAverages = str2double(method(idx_end(idx)+1:idx_end(idx)+find_newline(method,idx_end(idx))-1));
                case 'PVM_NRepetitions' %integer: Number of repetitions (executions) of the experiment.
                    NRepetitions = str2double(method(idx_end(idx)+1:idx_end(idx)+find_newline(method,idx_end(idx))-1));
                case 'PVM_RepetitionTime' %(ms)
                    RepetitionTime = str2double(method(idx_end(idx)+1:idx_end(idx)+find_newline(method,idx_end(idx))-1));
                case 'PVM_SPackArrReadOrient' %array of strings: Read gradient orientation in the slice package ( L_R / A_P / H_F)
                    SPackArrReadOrient = method(idx_end(idx)+find_newline(method,idx_end(idx))+1:idx_end(idx)+find_newline(method,idx_end(idx))+3);
                case 'PVM_SPackArrSliceOrient' %array of strings: General orientation of each slice package (axial, sagittal, coronal)
                    SPackArrSliceOrient = sscanf(method(idx_end(idx)+find_newline(method,idx_end(idx))+1:idx_end(idx)+find_newline(method,idx_end(idx))+8),'%s');
                case 'PVM_ObjOrderScheme' %string: Selects the order in which the slices are excited in a multislice experiment. (Interlaced, Reverse_sequential, Sequential)
                    ObjOrderScheme = method(idx_end(idx)+1:idx_end(idx)+find_newline(method,idx_end(idx))-1);
                case 'FairMode' %string: Type of FAIR experiment (SELECTIVE, NONSELECTIVE, INTERLEAVED, INTERLEAVED2)
                    FairMode = method(idx_end(idx)+1:idx_end(idx)+find_newline(method,idx_end(idx))-1);
                case 'FairTIR_NExp' %integer: Number of different TIR values repeated with each inversion mode (selective and non-selective).
                    FairTIR_NExp = str2double(method(idx_end(idx)+1:idx_end(idx)+find_newline(method,idx_end(idx))-1));
                case 'CASL_AcqOrder' %string: (Interleaved, Dynamic)
                    CASL_AcqOrder = method(idx_end(idx)+1:idx_end(idx)+find_newline(method,idx_end(idx))-1);
                case 'CASL_LabelImages'
                    CASL_LabelImages = str2double(method(idx_end(idx)+1:idx_end(idx)+find_newline(method,idx_end(idx))-1));
                case 'CASL_ControlImages'
                    CASL_ControlImages = str2double(method(idx_end(idx)+1:idx_end(idx)+find_newline(method,idx_end(idx))-1));
                case 'MPRAGE_Selection' %string: (MP1RAGE, MP2RAGE, MP3RAGE)
                    MPRAGE_Selection = method(idx_end(idx)+1:idx_end(idx)+find_newline(method,idx_end(idx))-1);
                case 'PVM_DwNDiffDir' %integer
                    DwNDiffDir = str2double(method(idx_end(idx)+1:idx_end(idx)+find_newline(method,idx_end(idx))-1));
                case 'PVM_ScanTime' %integer
                    ScanTime = str2double(method(idx_end(idx)+1:idx_end(idx)+find_newline(method,idx_end(idx))-1));
            end
        end
        % fprintf('.')
        fp = fopen( acqpfile, 'r' );
        acqp = fread(fp,[1 inf],'*char');
        [idx_sta,idx_end] = regexp(acqp,'##\$\w*=');
        fclose(fp);
        for idx = 1:length(idx_sta)
            switch acqp(idx_sta(idx)+3:idx_end(idx)-1)
                case 'ACQ_n_echo_images' %integer: It contains the number of images per slice within the slice loop in 2dseq, typically the number of echo-images.
                    NEchoes = str2double(acqp(idx_end(idx)+1:idx_end(idx)+find_newline(acqp,idx_end(idx))-1));
                case 'ACQ_CalibratedRG' %array of number: Linear reciever gain 0.25-203
                    hdr.CalibratedRG = sscanf(acqp(idx_end(idx)+find_newline(acqp,idx_end(idx))+1:idx_end(idx)+find_newline(acqp,idx_end(idx))+6*16),'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f',[1 16]);
            end
        end
        % fprintf('.')
        fp = fopen(recofile,'r');
        reco = fread(fp,[1 inf],'*char');
        [idx_sta,idx_end] = regexp(reco,'##\$\w*=');
        fclose(fp);
        for idx = 1:length(idx_sta)
            switch reco(idx_sta(idx)+3:idx_end(idx)-1)
                case 'RecoCombineMode' %string. either SumOfSquares, AddImages, or ShuffleImages
                    CombineMode = reco(idx_end(idx)+1:idx_end(idx)+find_newline(reco,idx_end(idx))-1);
                case 'RecoNumInputChan' %the parameter describes the structure of the input data. When RecoNumInputChan > 1, reconstruction assumes, that the raw data file consists of RecoNumInputChan blocks of size RECO_inp_size[0] forming the first dimension of the data file.
                    NumInputChan = str2double(reco(idx_end(idx)+1:idx_end(idx)+find_newline(reco,idx_end(idx))-1));
                case 'RECO_image_type' %string
                    image_type = reco(idx_end(idx)+1:idx_end(idx)+find_newline(reco,idx_end(idx))-1);
                case 'RecoScaleChan' % array of numbers
                    hdr.RecoScaleChan = sscanf(reco(idx_end(idx)+find_newline(reco,idx_end(idx))+1:idx_end(idx)+find_newline(reco,idx_end(idx))+9*16),'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f',[1 16]);
                case 'RecoPhaseChan' % array of numbers
                    hdr.RecoPhaseChan = sscanf(reco(idx_end(idx)+find_newline(reco,idx_end(idx))+1:idx_end(idx)+find_newline(reco,idx_end(idx))+8*16),'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f',[1 16]);
            end
        end
        % fprintf('.')
        fp = fopen( visu_parsfile, 'r' );
        visu_pars = fread(fp,[1 inf],'*char');
        [idx_sta,idx_end] = regexp(visu_pars,'##\$\w*=');
        fclose(fp);
        for idx = 1:length(idx_sta)
            switch visu_pars(idx_sta(idx)+3:idx_end(idx)-1)
                case 'VisuCoreDim'
                    VisuCoreDim = str2double(visu_pars(idx_end(idx)+1:idx_end(idx)+find_newline(visu_pars,idx_end(idx))-1));
                case 'VisuCoreSize'
                    VisuCoreSize = sscanf(visu_pars(idx_end(idx)+find_newline(visu_pars,idx_end(idx))+1:idx_end(idx)+find_newline(visu_pars,idx_end(idx))+5*3),'%d %d %d',3);
                case 'VisuCoreExtent'
                    VisuCoreExtent = sscanf(visu_pars(idx_end(idx)+find_newline(visu_pars,idx_end(idx))+1:idx_end(idx)+find_newline(visu_pars,idx_end(idx))+19*3),'%f %f %f',3);
                case 'VisuCoreOrientation'
                    VisuCoreOrientation = (sscanf(visu_pars(idx_end(idx)+find_newline(visu_pars,idx_end(idx))+1:idx_end(idx)+find_newline(visu_pars,idx_end(idx))+19*9),'%f %f %f %f %f %f %f %f %f',[3 3]))';
                case 'VisuCorePosition'
                    VisuCorePosition = sscanf(visu_pars(idx_end(idx)+find_newline(visu_pars,idx_end(idx))+1:idx_end(idx)+find_newline(visu_pars,idx_end(idx))+19*3),'%f %f %f',3);
                case 'VisuCoreDataOffs'
                    hdr.scl_inter = sscanf(visu_pars(idx_end(idx)+find_newline(visu_pars,idx_end(idx))+1:idx_end(idx)+find_newline(visu_pars,idx_end(idx))+19*1),'%f',1);
                case 'VisuCoreDataSlope'
                    hdr.scl_slope = (sscanf(visu_pars(idx_end(idx)+find_newline(visu_pars,idx_end(idx))+1:idx_end(idx)+find_newline(visu_pars,idx_end(idx))+19*1),'%f',1));
                case 'VisuCoreWordType'
                    VisuCoreWordType = visu_pars(idx_end(idx)+1:idx_end(idx)+find_newline(visu_pars,idx_end(idx))-1);
                case 'VisuCoreSlicePacksSlices'
                    VisuCoreSlicePacksSlices = sscanf(visu_pars(idx_end(idx)+find_newline(visu_pars,idx_end(idx))+1:idx_end(idx)+find_newline(visu_pars,idx_end(idx))+13*3),'(%d,%d) ',[2 3]);
                    VisuCoreSlicePacksSlices = sum(VisuCoreSlicePacksSlices(2,:));
                case 'VisuCoreSlicePacksSliceDist'
                    VisuCoreSlicePacksSliceDist = sscanf(visu_pars(idx_end(idx)+find_newline(visu_pars,idx_end(idx))+1:idx_end(idx)+find_newline(visu_pars,idx_end(idx))+19*1),'%f',1);
                case 'VisuSubjectPosition'
                    hdr.VisuSubjectPosition = visu_pars(idx_end(idx)+1:idx_end(idx)+find_newline(visu_pars,idx_end(idx))-1);
            end
        end
        %%%%%%%%%%%%%% Raw Data Reading %%%%%%%%%%%%%%
        switch VisuCoreWordType
            case '_32BIT_SGN_INT'
                precision = 'int32';
                hdr.datatype = 8;
                hdr.bitpix = 32;
            case '_16BIT_SGN_INT'
                precision = 'int16';
                hdr.datatype = 4;
                hdr.bitpix = 16;
            case '_8BIT_UNSGN_INT'
                precision = 'uint8';
                hdr.datatype = 2;
                hdr.bitpix = 8;
            case '_32BIT_FLOAT'
                precision = 'single';
                hdr.datatype = 16;
                hdr.bitpix = 32;
        end
        %PV loops
        %   dim1 dim2 dim3 Echo Slice Cycle Repetition Channel Complex
        switch VisuCoreDim
            case 2
                hdr.size(1:2) = VisuCoreSize(1:2);
                hdr.size(3) = VisuCoreSlicePacksSlices;
                hdr.dim(1:2) = VisuCoreExtent(1:2)./VisuCoreSize(1:2);
                hdr.dim(3) = VisuCoreSlicePacksSliceDist;
                VisuCoreSize(3) = 1;
            case 3
                hdr.size = VisuCoreSize;
                hdr.dim(1:3) = VisuCoreExtent./VisuCoreSize;
                VisuCoreSlicePacksSlices = 1;
            otherwise
                error('Data is not 2D or 3D format!')
        end
        if ~exist('NEchoes','var') || strcmp(Method,'<Bruker:FieldMap>')
            NEchoes = 1;
        end
        if exist('MPRAGE_Selection','var')
            Cycle = sscanf(MPRAGE_Selection,'MP%dRAGE');
        elseif exist('DwNDiffDir','var')
            Cycle = DwNDiffDir;
        elseif  exist('FairMode','var') && strcmp(FairMode,'INTERLEAVED')
            Cycle = FairTIR_NExp+1;
        elseif (exist('CASL_AcqOrder','var') && strcmp(CASL_AcqOrder,'INTERLEAVED'))
            Cycle = CASL_LabelImages+CASL_ControlImages;
        elseif (strcmp(Method,'<Bruker:FieldMap>') && strcmp(CombineMode,'ShuffleImages')) || strcmp(Method,'<User:rpAFI>')
            Cycle = 2;
        else
            Cycle = 1;
        end
        if ~strcmp(CombineMode,'ShuffleImages')
            NumInputChan = 1;
        end
        if ~exist('NRepetitions','var')
            NRepetitions = 1;
        end
        % fprintf('.')
        mem_img = memmapfile(imagefile,'Format',{precision,[VisuCoreSize(1),VisuCoreSize(2),VisuCoreSize(3),NEchoes,VisuCoreSlicePacksSlices,Cycle,NRepetitions,NumInputChan],'raw'});
        if strcmp(image_type,'COMPLEX_IMAGE')
            img = complex(mem_img.Data(1).raw,mem_img.Data(2).raw);
            hdr.datatype = 32; %Requiring data to convert to single (float32)
            hdr.bitpix = 64;
        else
            img = mem_img.Data.raw;
        end
        % Writing headers
        hdr.method = Method;
        hdr.ReadOrient = SPackArrReadOrient;
        hdr.SliceOrient = SPackArrSliceOrient;
        hdr.ObjOrderScheme = ObjOrderScheme;
        hdr.ScanTime = ScanTime;
        hdr.RepetitionTime = RepetitionTime;
        hdr.VisuCoreOrientation = VisuCoreOrientation;
        hdr.VisuCorePosition = VisuCorePosition;
        hdr.VisuCoreDim = VisuCoreDim;
        % fprintf('read_2dseq finished in %5.2f sec\n',toc);
        % fprintf('done\n');

    end



    function idx_out = find_newline(str,idx_in)
        % Find newline after certain index
        idx_out = 1;
        while str(idx_in+idx_out) ~= char(10) %#ok<CHARTEN>
            idx_out = idx_out+1;
        end

    end






end % ImportBfile