function export_gif_3DT1(app,gifexportpath,t1map,m0map,tag,T1MapScale,t1cmap,aspect)


% Exports 3D t1maps and m0maps to animated gif

[nr_frames,dimx,dimy,nr_images] = size(t1map);


% increase the size of the matrix to make the exported images bigger

numrows = 4*dimx;
numcols = 4*round(dimy/aspect);
delay_time = 5/nr_images;  % show all gifs in 2 seconds


% Export the T1 maps to gifs

for idc = 1:nr_frames
    
    app.TextMessage(strcat('GIF export T1-map frame',{' '},num2str(idc)));
    
    for idx = 1:nr_images
        
        % because the color maps are arrays of size 256
        % the T1-map needs to be mapped onto the range of [0, 255] and cast in an
        % unsigned integer 8 for gif export
        image = uint8(round((255/T1MapScale)*resizem(squeeze(t1map(idc,:,:,idx)),[numrows numcols])));
        
        if idx == 1
            imwrite(rot90(image),t1cmap,[gifexportpath,filesep,'T1map_frame_',num2str(idc),'_',tag,'.gif'],'DelayTime',delay_time,'LoopCount',inf);
        else
            imwrite(rot90(image),t1cmap,[gifexportpath,filesep,'T1map_frame_',num2str(idc),'_',tag,'.gif'],'WriteMode','append','DelayTime',delay_time);
        end
    end
    
end


% Export the M0 maps to GIF

for idc = 1:nr_frames
    
    app.TextMessage(strcat('GIF export M0-map frame',{' '},num2str(idc)));
    
    for idx = 1:nr_images
        
        % determine a convenient scale to display M0 maps (same as in the app)
        m0scale = round(2*mean(nonzeros(squeeze(m0map(idc,:,:,idx)))));
        if isnan(m0scale) m0scale = 100; end
        
        % automatic grayscale mapping is used for the gif export
        % the m0map therefore needs to be mapped onto the range of [0 255]
        image = uint8(round((255/m0scale)*resizem(squeeze(m0map(idc,:,:,idx)),[numrows numcols])));
        
        if idx == 1
            imwrite(rot90(image),[gifexportpath,filesep,'M0map_frame_',num2str(idc),'_',tag,'.gif'],'DelayTime',delay_time,'LoopCount',inf);
        else
            imwrite(rot90(image),[gifexportpath,filesep,'M0map_frame_',num2str(idc),'_',tag,'.gif'],'WriteMode','append','DelayTime',delay_time);
        end
    end
    
end



end