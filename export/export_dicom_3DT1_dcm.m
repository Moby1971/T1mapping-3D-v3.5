function export_dicom_3DT1_dcm(dcmdir,directory,m0map,t1map,parameters)


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



% ------------------------
% Export the T1 map images
% ------------------------


% Create T1 map folder if not exist, and delete folder content
dir1 = base_header.PatientID;
dir2 = 'DICOM';
dir3 = strcat(num2str(base_header.SeriesNumber),'T1');
dir4 = '1';
folder_name = strcat(directory,filesep,dir1,filesep,dir2,filesep,dir3,filesep,dir4);
if (~exist(folder_name, 'dir')); mkdir(fullfile(directory, dir1,dir2,dir3,dir4)); end
delete([folder_name,filesep,'*']);


% Export

cnt = 1;

for j = 1:nr_frames         % for all temporal positions
    
    for i = 1:dimz          % for all slices
        
        % Generate new dicom header from existing header
        dcm_header = generate_dicomheader_3DT1_dcm(base_header,parameters,dimx,dimy,i,j,cnt);
        
        % Filename
        fn = ['000000',num2str(cnt)];
        fn = fn(size(fn,2)-5:size(fn,2));
        fname = [folder_name,filesep,fn,'.dcm'];
        
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



% Create M0 map folder if not exist, and delete folder content
dir1 = base_header.PatientID;
dir2 = 'DICOM';
dir3 = strcat(num2str(base_header.SeriesNumber),'M0');
dir4 = '1';
folder_name = strcat(directory,filesep,dir1,filesep,dir2,filesep,dir3,filesep,dir4);
if (~exist(folder_name, 'dir')); mkdir(fullfile(directory, dir1,dir2,dir3,dir4)); end
delete([folder_name,filesep,'*']);


% Export

while max(m0map(:))>65535
   m0map = m0map/2; 
end

cnt = 1;

for j = 1:nr_frames         % for all temporal positions
    
    for i = 1:dimz          % for all slices
        
        % Generate new dicom header from existing header
        dcm_header = generate_dicomheader_3DT1_dcm(base_header,parameters,dimx,dimy,i,j,cnt);
        
        % Filename
        fn = ['000000',num2str(cnt)];
        fn = fn(size(fn,2)-5:size(fn,2));
        fname = [folder_name,filesep,fn,'.dcm'];
        
        % M0 map
        image = rot90(squeeze(cast(round(m0map(j,:,:,i)),'uint16')));
        
        % Write the Dicom file
        dicomwrite(image, fname, dcm_header);
        
        cnt = cnt + 1;
        
    end
    
end




end