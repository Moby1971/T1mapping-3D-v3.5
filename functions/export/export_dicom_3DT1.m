function export_dicom_3DT1(app,directory)


m0map = app.imageM0;
t1map = app.imageT1;
parameters = app.parameters;
tag = parameters.tag;


% Phase orientation orientation correction
if isfield(parameters, 'PHASE_ORIENTATION')
    if parameters.PHASE_ORIENTATION == 1
        t1map = permute(t1map,[2 3 4 1]);
        t1map = permute(rot90(permute(t1map,[2 1 3 4]),1),[2 1 3 4]);
        t1map = permute(t1map,[4 1 2 3]);

        m0map = permute(m0map,[2 3 4 1]);
        m0map = permute(rot90(permute(m0map,[2 1 3 4]),1),[2 1 3 4]);
        m0map = permute(m0map,[4 1 2 3]);
    end
end

% Date and time
parameters.datetime = datetime(parameters.date,'InputFormat','dd-MMM-yyyy HH:mm:ss');

% Size of the M0 and T1 maps
[nr_frames,dimx,dimy,dimz] = size(t1map);


% ------------------------
% Export T1 map images
% ------------------------


% Create new directory
ready = false;
cnt = 1;
while ~ready
    folderName = strcat(directory,tag,'T1',filesep,num2str(cnt),filesep);
    if ~exist(folderName, 'dir')
        mkdir(folderName);
        ready = true;
    end
    cnt = cnt + 1;
end

app.TextMessage(strcat("DICOM export folder = ",folderName," ..."));

dir41 = 'T1';
dir42 = 'R2';

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







% Export
dcmid = dicomuid;   % unique identifier
dcmid = dcmid(1:50);
seriesInstanceID = dicomuid;

cnt = 1;

for j = 1:nr_frames             % for all frames / temporal positions

    for i = 1:dimz              % for all slices

        % Generate dicom header from scratch
        dcmHeader = generate_dicomheader_3DT1(parameters,dimx,dimy,i,j,dcmid,cnt);
        dcmHeader.ProtocolName = 'T1-map';
        dcmHeader.SequenceName = 'T1-map';
        fn = strcat('0000',num2str(cnt));
        fn = fn(size(fn,2)-4:size(fn,2));

        % Dicom filename
        fname = strcat(output_directory1,filesep,fn,'.dcm');

        % T1 images
        image = rot90(squeeze(cast(round(t1map(j,:,:,i)),'uint16')));

        % Write the dicom file
        dicomwrite(image, fname, dcmHeader);

        cnt = cnt + 1;

    end

end




% ------------------------
% Export M0 map images
% ------------------------


% Scale
while max(m0map(:))>65535
    m0map = m0map/2;
end

% Export

dcmid = dicomuid;   % unique identifier
dcmid = dcmid(1:50);
seriesInstanceID = dicomuid;

parameters.datetime = parameters.datetime + minutes(10);

cnt = 1;

for j = 1:nr_frames             % for all frames / temporal positions

    for i = 1:dimz              % for all slices

        % Generate dicom header from scratch
        dcmHeader = generate_dicomheader_3DT1(parameters,dimx,dimy,i,j,dcmid,cnt);
        dcmHeader.ProtocolName = 'M0-map';
        dcmHeader.SequenceName = 'M0-map';
        fn = strcat('0000',num2str(cnt));
        fn = fn(size(fn,2)-4:size(fn,2));

        % Dicom filename
        fname = strcat(output_directory2,filesep,fn,'.dcm');

        % M0 images
        image = rot90(squeeze(cast(round(m0map(j,:,:,i)),'uint16')));

        % Write the dicom file
        dicomwrite(image, fname, dcmHeader);

        cnt = cnt + 1;

    end

end



    function dicom_header = generate_dicomheader_3DT1(parameters,dimx,dimy,i,j,dcmid,cnt)

        %
        % GENERATES DICOM HEADER FOR EXPORT IF NO DICOM INFORMATION IS AVAILABLE
        %
        % parameters = parameters from MRD file
        % i = current slice number
        % J = current frame / tempooral position
        % dimy = y dimension (phase encoding, views)
        % dimx = x dimension (readout, samples)
        %

        % Study name
        if length(parameters.filename) > 9
            studyname = str2num(parameters.filename(end-9:end-6)); %#ok<ST2NM>
        else
            studyname = 111;
        end


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

        % Estimated acquistion time
        acq_dur = parameters.NO_ECHOES * parameters.NO_VIEWS * parameters.NO_VIEWS_2 * parameters.tr * parameters.NO_AVERAGES/1000;   % acquisition time in seconds

        % Filename
        fn = ['0000',num2str(i)];
        fn = fn(size(fn,2)-4:size(fn,2));
        fname = ['T1map_',fn,'.dcm'];

        % Date
        dt = parameters.datetime;
        year = num2str(dt.Year);
        month = ['0',num2str(dt.Month)]; month = month(end-1:end);
        day = ['0',num2str(dt.Day)]; day = day(end-1:end);
        date = [year,month,day];

        % Time
        hour = ['0',num2str(dt.Hour)]; hour = hour(end-1:end);
        minute = ['0',num2str(dt.Minute)]; minute = minute(end-1:end);
        seconds = ['0',num2str(dt.Second)]; seconds = seconds(end-1:end);
        time = [hour,minute,seconds];

        % Dicom tags
        dcmhead.Filename = fname;
        dcmhead.FileModDate = parameters.date;
        dcmhead.FileSize = dimy*dimx*2;
        dcmhead.Format = 'DICOM';
        dcmhead.FormatVersion = 3;
        dcmhead.Width = dimy;
        dcmhead.Height = dimx;
        dcmhead.BitDepth = 15;
        dcmhead.ColorType = 'grayscale';
        dcmhead.FileMetaInformationGroupLength = 178;
        dcmhead.FileMetaInformationVersion = uint8([0, 1])';
        dcmhead.MediaStorageSOPClassUID = '1.2.840.10008.5.1.4.1.1.4';
        dcmhead.TransferSyntaxUID = '1.2.840.10008.1.2.1';
        dcmhead.ImplementationClassUID = '1.2.826.0.9717382.3.0.3.6.0';
        dcmhead.ImplementationVersionName = 'OFFIS_DCMTK_360';
        dcmhead.SpecificCharacterSet = 'ISO_IR 100';
        dcmhead.ImageType = 'DERIVED\RELAXATION\';
        dcmhead.SOPClassUID = '1.2.840.10008.5.1.4.1.1.4';
        dcmhead.StudyDate = date;
        dcmhead.SeriesDate = date;
        dcmhead.AcquisitionDate = date;
        dcmhead.StudyTime = time;
        dcmhead.SeriesTime = time;
        dcmhead.AcquisitionTime = time;
        dcmhead.ContentTime = time;
        dcmhead.Modality = 'MR';
        dcmhead.Manufacturer = 'MR Solutions Ltd';
        dcmhead.InstitutionName = 'Amsterdam UMC';
        dcmhead.InstitutionAddress = 'Amsterdam, Netherlands';
        dcmhead.ReferringPhysicianName.FamilyName = 'Amsterdam UMC preclinical MRI';
        dcmhead.ReferringPhysicianName.GivenName = '';
        dcmhead.ReferringPhysicianName.MiddleName = '';
        dcmhead.ReferringPhysicianName.NamePrefix = '';
        dcmhead.ReferringPhysicianName.NameSuffix = '';
        dcmhead.StationName = 'MRI Scanner';
        dcmhead.StudyDescription = 'Parameter Mapping';
        dcmhead.SeriesDescription = '';
        dcmhead.InstitutionalDepartmentName = 'Amsterdam UMC preclinical MRI';
        dcmhead.PhysicianOfRecord.FamilyName = 'Amsterdam UMC preclinical MRI';
        dcmhead.PhysicianOfRecord.GivenName = '';
        dcmhead.PhysicianOfRecord.MiddleName = '';
        dcmhead.PhysicianOfRecord.NamePrefix = '';
        dcmhead.PhysicianOfRecord.NameSuffix = '';
        dcmhead.PerformingPhysicianName.FamilyName = 'Amsterdam UMC preclinical MRI';
        dcmhead.PerformingPhysicianName.GivenName = '';
        dcmhead.PerformingPhysicianName.MiddleName = '';
        dcmhead.PerformingPhysicianName.NamePrefix = '';
        dcmhead.PerformingPhysicianName.NameSuffix = '';
        dcmhead.PhysicianReadingStudy.FamilyName = 'Amsterdam UMC preclinical MRI';
        dcmhead.PhysicianReadingStudy.GivenName = '';
        dcmhead.PhysicianReadingStudy.MiddleName = '';
        dcmhead.PhysicianReadingStudy.NamePrefix = '';
        dcmhead.PhysicianReadingStudy.NameSuffix = '';
        dcmhead.OperatorName.FamilyName = 'manager';
        dcmhead.AdmittingDiagnosesDescription = '';
        dcmhead.ManufacturerModelName = 'MRS7024';
        dcmhead.ReferencedSOPClassUID = '';
        dcmhead.ReferencedSOPInstanceUID = '';
        dcmhead.ReferencedFrameNumber = [];
        dcmhead.DerivationDescription = '';
        dcmhead.FrameType = '';
        dcmhead.PatientName.FamilyName = 'Amsterdam UMC preclinical MRI';
        dcmhead.PatientID = tag;
        dcmhead.PatientBirthDate = date;
        dcmhead.PatientBirthTime = '';
        dcmhead.PatientSex = 'F';
        dcmhead.OtherPatientID = '';
        dcmhead.OtherPatientName.FamilyName = 'Amsterdam UMC preclinical MRI';
        dcmhead.OtherPatientName.GivenName = '';
        dcmhead.OtherPatientName.MiddleName = '';
        dcmhead.OtherPatientName.NamePrefix = '';
        dcmhead.OtherPatientName.NameSuffix = '';
        dcmhead.PatientAge = '1';
        dcmhead.PatientSize = [];
        dcmhead.PatientWeight = 0.0300;
        dcmhead.Occupation = '';
        dcmhead.AdditionalPatientHistory = '';
        dcmhead.PatientComments = '';
        dcmhead.BodyPartExamined = '';
        dcmhead.SequenceName = parameters.PPL;
        dcmhead.SliceThickness = parameters.SLICE_THICKNESS;
        dcmhead.KVP = 0;
        dcmhead.RepetitionTime = parameters.tr;
        dcmhead.EchoTime = parameters.te;
        dcmhead.InversionTime = 0;
        dcmhead.NumberOfAverages = parameters.NO_AVERAGES;
        dcmhead.ImagedNucleus = '1H';
        dcmhead.MagneticFieldStrength = 7;
        dcmhead.SpacingBetweenSlices = parameters.SLICE_SEPARATION/parameters.SLICE_INTERLEAVE;
        dcmhead.EchoTrainLength = 1;
        dcmhead.DeviceSerialNumber = '0034';
        dcmhead.PlateID = '';
        dcmhead.SoftwareVersion = '1.0.0.0';
        dcmhead.ProtocolName = '';
        dcmhead.SpatialResolution = [];
        dcmhead.TriggerTime = (j-1)*parameters.frametime;
        dcmhead.DistanceSourceToDetector = [];
        dcmhead.DistanceSourceToPatient = [];
        dcmhead.FieldofViewDimensions = [FOVx FOVy parameters.SLICE_THICKNESS];
        dcmhead.ExposureTime = [];
        dcmhead.XrayTubeCurrent = [];
        dcmhead.Exposure = [];
        dcmhead.ExposureInuAs = [];
        dcmhead.FilterType = '';
        dcmhead.GeneratorPower = [];
        dcmhead.CollimatorGridName = '';
        dcmhead.FocalSpot = [];
        dcmhead.DateOfLastCalibration = '';
        dcmhead.TimeOfLastCalibration = '';
        dcmhead.PlateType = '';
        dcmhead.PhosphorType = '';
        dcmhead.AcquisitionMatrix = uint16([dimy 0 0 dimx])';
        dcmhead.FlipAngle = parameters.alpha;
        dcmhead.AcquisitionDeviceProcessingDescription = '';
        dcmhead.CassetteOrientation = 'PORTRAIT';
        dcmhead.CassetteSize = '25CMX25CM';
        dcmhead.ExposuresOnPlate = 0;
        dcmhead.RelativeXrayExposure = [];
        dcmhead.AcquisitionComments = '';
        dcmhead.PatientPosition = 'HFS';
        dcmhead.Sensitivity = [];
        dcmhead.FieldOfViewOrigin = [];
        dcmhead.FieldOfViewRotation = [];
        dcmhead.AcquisitionDuration = acq_dur;
        dcmhead.StudyInstanceUID = dcmid(1:18);
        dcmhead.SeriesInstanceUID = seriesInstanceID;
        dcmhead.StudyID = '01';
        dcmhead.SeriesNumber = studyname;
        dcmhead.AcquisitionNumber = 1;
        dcmhead.InstanceNumber = cnt;
        dcmhead.ImagePositionPatient = [-(FOVx/2) -FOVy/2 (i-round(parameters.NO_SLICES/2))*(parameters.SLICE_SEPARATION/parameters.SLICE_INTERLEAVE)]';
        dcmhead.ImageOrientationPatient = [1.0, 0.0, 0.0, 0.0, 1.0, 0.0]';
        dcmhead.FrameOfReferenceUID = '';
        dcmhead.TemporalPositionIdentifier = j;
        dcmhead.NumberOfTemporalPositions = parameters.NO_ECHOES;
        dcmhead.TemporalResolution = parameters.frametime;
        dcmhead.ImagesInAcquisition = parameters.NO_SLICES*parameters.NO_ECHOES;
        dcmhead.SliceLocation = (i-round(parameters.NO_SLICES/2))*(parameters.SLICE_SEPARATION/parameters.SLICE_INTERLEAVE);
        dcmhead.ImageComments = '';
        dcmhead.TemporalPositionIndex = uint32([]);
        dcmhead.SamplesPerPixel = 1;
        dcmhead.PhotometricInterpretation = 'MONOCHROME2';
        dcmhead.PlanarConfiguration = 0;
        dcmhead.Rows = dimy;
        dcmhead.Columns = dimx;
        dcmhead.PixelSpacing = [pixely pixelx]';
        dcmhead.PixelAspectRatio = 1;
        dcmhead.BitsAllocated = 16;
        dcmhead.BitsStored = 15;
        dcmhead.HighBit = 14;
        dcmhead.PixelRepresentation = 0;
        dcmhead.PixelPaddingValue = 0;
        dcmhead.RescaleIntercept = 0;
        dcmhead.RescaleSlope = 1;
        dcmhead.HeartRate = 0;
        dcmhead.NumberOfSlices = parameters.NO_SLICES;
        dcmhead.CardiacNumberOfImages = 1;
        dcmhead.MRAcquisitionType = '3D';
        dcmhead.ScanOptions = 'CG';
        dcmhead.BodyPartExamined = '';

        dicom_header = dcmhead;


    end





end