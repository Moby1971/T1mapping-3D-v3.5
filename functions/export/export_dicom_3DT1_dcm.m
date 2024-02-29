function export_dicom_3DT1_dcm(app, dcmdir)

directory = app.dicomExportPath;
m0map = app.imageM0;
t1map = app.imageT1;
parameters = app.parameters;
tag = app.parameters.tag;


% Phase orientation correction
if isfield(parameters, 'PHASE_ORIENTATION')
    if parameters.PHASE_ORIENTATION == 1
        t1map = permute(t1map,[2 3 4 1]);
        t1map = permute(rot90(permute(t1map,[2 1 3 4]),1),[2 1 3 4]);
        t1map = permute(t1map,[4 1 2 3]);
    end
end


% T1 and M0 map dimensions
[nr_frames,dimx,dimy,dimz] = size(t1map);


% Reading in the DICOM header information
listing = dir(fullfile(dcmdir, '*.dcm'));
dcmfilename = [listing(1).folder,filesep,listing(1).name];
base_header = dicominfo(dcmfilename);


% Create new directory
ready = false;
cnt = 1;
while ~ready
    folderName = strcat(directory,filesep,'DICOM',filesep,tag,'T1',filesep,num2str(cnt),filesep);
    if ~exist(folderName, 'dir')
        mkdir(folderName);
        ready = true;
    end
    cnt = cnt + 1;
end

app.TextMessage(strcat("DICOM export folder = ",folderName," ..."));

dir41 = 'T1';
dir42 = 'M0';

output_directory1 = strcat(folderName,dir41);
if ~exist(output_directory1, 'dir') 
    mkdir(output_directory1); 
end
delete(strcat(output_directory1,filesep,'*'));

output_directory2 = strcat(folderName,dir42);
if ~exist(output_directory2, 'dir')
    mkdir(output_directory2); 
end
delete(strcat(output_directory2,filesep,'*'));




% ------------------------
% Export the T1 map images
% ------------------------

% Export
seriesInstanceID = dicomuid;

cnt = 1;

for j = 1:nr_frames         % for all temporal positions

    for i = 1:dimz          % for all slices

        % Generate new dicom header from existing header
        dcm_header = generate_dicomheader_3DT1_dcm(base_header,parameters,dimx,dimy,i,j,cnt);
        dcm_header.ProtocolName = 'T1-map';
        dcm_header.SequenceName = 'T1-map';
        dcm_header.seriesInstanceUID = seriesInstanceID;

        % Filename
        fn = ['000000',num2str(cnt)];
        fn = fn(size(fn,2)-5:size(fn,2));
        fname = strcat(output_directory1,filesep,fn,'.dcm');

        % T1 map
        image = rot90(squeeze(cast(round(t1map(j,:,:,i)),'uint16')));

        % Write the Dicom file
        dicomwrite(image, fname, dcm_header);

        cnt = cnt + 1;

    end

end




% ------------------------
% Export the M0 map images
% ------------------------

while max(m0map(:))>65535
    m0map = m0map/2;
end

seriesInstanceID = dicomuid;

cnt = 1;

for j = 1:nr_frames         % for all temporal positions

    for i = 1:dimz          % for all slices

        % Generate new dicom header from existing header
        dcm_header = generate_dicomheader_3DT1_dcm(base_header,parameters,dimx,dimy,i,j,cnt);
        dcm_header.ProtocolName = 'M0-map';
        dcm_header.SequenceName = 'M0-map';
        dcm_header.seriesInstanceUID = seriesInstanceID;

        % Filename
        fn = ['000000',num2str(cnt)];
        fn = fn(size(fn,2)-5:size(fn,2));
        fname = strcat(output_directory2,filesep,fn,'.dcm');

        % M0 map
        image = rot90(squeeze(cast(round(m0map(j,:,:,i)),'uint16')));

        % Write the Dicom file
        dicomwrite(image, fname, dcm_header);

        cnt = cnt + 1;

    end

end





    function dicom_header = generate_dicomheader_3DT1_dcm(dcmhead,parameters,dimx,dimy,i,j,cnt)

        %
        % GENERATES DICOM HEADER FOR EXPORT BASED ON AVAILABLE DICOM HEADER
        %
        % parameters = parameters from MRD file
        % i = current slice number
        % J = current frame / tempooral position
        % dimy = y dimension (phase encoding, views)
        % dimx = x dimension (readout, samples)
        %


        % Phase orientation FOV dimensions correction
        if isfield(parameters, 'PHASE_ORIENTATION')
            if parameters.PHASE_ORIENTATION == 1
                FOVx = parameters.FOV3D(2);
                FOVy = parameters.FOV3D(1);
            else
                FOVx = parameters.FOV3D(1);
                FOVy = parameters.FOV3D(2);

            end
        end
        pixelx = FOVx/dimx;
        pixely = FOVy/dimy;

        % Filename
        fname = ['000000',num2str(cnt)];
        fname = fname(size(fname,2)-5:size(fname,2));

        % Date
        dt = datetime(parameters.date,'InputFormat','dd-MMM-yyyy HH:mm:ss');
        year = num2str(dt.Year);
        month = ['0',num2str(dt.Month)]; month = month(end-1:end);
        day = ['0',num2str(dt.Day)]; day = day(end-1:end);
        date = [year,month,day];

        % Replaced dicom tags
        dcmhead.Filename = fname;
        dcmhead.FileModDate = date;
        dcmhead.FileSize = dimy*dimx*2;
        dcmhead.Width = dimy;
        dcmhead.Height = dimx;
        dcmhead.BitDepth = 15;
        dcmhead.InstitutionName = 'Amsterdam UMC';
        dcmhead.ReferringPhysicianName.FamilyName = 'AMC preclinical MRI';
        dcmhead.InstitutionalDepartmentName = 'Amsterdam UMC preclinical MRI';
        dcmhead.PhysicianOfRecord.FamilyName = 'Amsterdam UMC preclinical MRI';
        dcmhead.PerformingPhysicianName.FamilyName = 'Amsterdam UMC preclinical MRI';
        dcmhead.PhysicianReadingStudy.FamilyName = 'Amsterdam UMC preclinical MRI';
        dcmhead.OperatorName.FamilyName = 'manager';
        dcmhead.ManufacturerModelName = 'MRS7024';
        dcmhead.ReferencedFrameNumber = [];
        dcmhead.NumberOfAverages = parameters.NO_AVERAGES;
        dcmhead.InversionTime = 0;
        dcmhead.ImagedNucleus = '1H';
        dcmhead.MagneticFieldStrength = 7;
        dcmhead.SpacingBetweenSlices = parameters.SLICE_SEPARATION/parameters.SLICE_INTERLEAVE;
        dcmhead.SliceThickness = parameters.SLICE_THICKNESS;
        dcmhead.FieldofViewDimensions = [FOVx FOVy parameters.SLICE_THICKNESS];
        dcmhead.EchoTrainLength = 1;
        dcmhead.NumberOfTemporalPositions = parameters.NO_ECHOES;
        dcmhead.TemporalResolution = parameters.frametime;
        dcmhead.ImagesInAcquisition = parameters.NO_SLICES;
        dcmhead.SliceLocation = (i-round(parameters.NO_SLICES/2))*(parameters.SLICE_SEPARATION/parameters.SLICE_INTERLEAVE);
        dcmhead.TriggerTime = (j-1)*parameters.frametime;    % frame time (ms)
        dcmhead.AcquisitionMatrix = uint16([dimx 0 0 dimy])';
        dcmhead.AcquisitionDeviceProcessingDescription = '';
        dcmhead.InstanceNumber = cnt;                   % instance number
        dcmhead.TemporalPositionIdentifier = j;         % frame number
        dcmhead.NumberOfTemporalPositions = parameters.NO_ECHOES;
        dcmhead.ImagesInAcquisition = parameters.NO_ECHOES*parameters.NO_SLICES;
        dcmhead.TemporalPositionIndex = j;
        dcmhead.Rows = dimy;
        dcmhead.Columns = dimx;
        dcmhead.PixelSpacing = [pixely pixelx]';
        dcmhead.PixelAspectRatio = [1 pixely/pixelx]';
        dcmhead.BitsAllocated = 16;
        dcmhead.BitsStored = 15;
        dcmhead.HighBit = 14;
        dcmhead.PixelRepresentation = 0;
        dcmhead.PixelPaddingValue = 0;
        dcmhead.RescaleIntercept = 0;
        dcmhead.RescaleSlope = 1;
        dcmhead.NumberOfSlices = parameters.NO_SLICES;

        dicom_header = dcmhead;

    end



end