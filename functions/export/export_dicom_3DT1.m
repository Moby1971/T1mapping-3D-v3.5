function export_dicom_3DT1(directory,m0map,t1map,parameters,tag)



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


% Create folder if not exist, and clear
folder_name = strcat(directory,filesep,'T1map-DICOM-',tag);
if ~exist(folder_name, 'dir')
    mkdir(folder_name); 
end
delete(strcat(folder_name,filesep,'*'));



% Export
dcmid = dicomuid;   % unique identifier
dcmid = dcmid(1:50);

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
        fname = strcat(directory,filesep,'T1map-DICOM-',tag,filesep,fn,'.dcm');
        
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

% Create folder if not exist, and clear
folder_name = strcat(directory,filesep,'M0map-DICOM-',tag);
if ~exist(folder_name, 'dir')
    mkdir(folder_name); 
end
delete(strcat(folder_name,filesep,'*'));

% Scale
while max(m0map(:))>65535
   m0map = m0map/2; 
end

% Export

dcmid = dicomuid;   % unique identifier
dcmid = dcmid(1:50);

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
        fname = strcat(directory,filesep,'M0map-DICOM-',tag,filesep,fn,'.dcm');
        
        % M0 images
        image = rot90(squeeze(cast(round(m0map(j,:,:,i)),'uint16')));
        
        % Write the dicom file
        dicomwrite(image, fname, dcmHeader);
        
        cnt = cnt + 1;
        
    end
    
end


end