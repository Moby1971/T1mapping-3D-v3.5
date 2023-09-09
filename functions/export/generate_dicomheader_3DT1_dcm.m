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


