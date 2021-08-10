function export_dicom_3DT1(directory,~,t1map,parameters,tag)


% create folder if not exist, and clear
folder_name = [directory,[filesep,'T1map-DICOM-',tag]];
if (~exist(folder_name, 'dir')); mkdir(folder_name); end
delete([folder_name,filesep,'*']);


% Phase orientation orientation correction
if isfield(parameters, 'PHASE_ORIENTATION')
    if parameters.PHASE_ORIENTATION == 1
        t1map = permute(t1map,[2 3 4 1]);
        t1map = permute(rot90(permute(t1map,[2 1 3 4]),1),[2 1 3 4]);
        t1map = permute(t1map,[4 1 2 3]);
    end
end


% Size of the T1 map
[nr_frames,dimx,dimy,dimz] = size(t1map);



% ------------------------
% Export the dicom images
% ------------------------

dcmid = dicomuid;   % unique identifier
dcmid = dcmid(1:50);

cnt = 1;

for j = 1:nr_frames             % for all frames / temporal positions
    
    for i = 1:dimz              % for all slices
        
        % Generate dicom header from scratch
        dcm_header = generate_dicomheader_3DT1(parameters,dimx,dimy,i,j,dcmid,cnt);
        fn = ['0000',num2str(cnt)];
        fn = fn(size(fn,2)-4:size(fn,2));
        
        % Dicom filename
        fname = [directory,filesep,'T1map-DICOM-',tag,filesep,fn,'.dcm'];
        
        % T1 images
        image = rot90(squeeze(cast(round(t1map(j,:,:,i)),'uint16')));
        
        % Write the dicom file
        dicomwrite(image, fname, dcm_header);
        
        cnt = cnt + 1;
        
    end
    
end




end