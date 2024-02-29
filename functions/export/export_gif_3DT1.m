function export_gif_3DT1(app,parameters,gifExportBase,t1map,m0map,tag,T1MapScale,t1cmap,aspect)


% Exports 3D t1maps and m0maps to animated gif

[nr_frames,dimx,dimy,dimz] = size(t1map);

% increase the size of the matrix to make the exported images bigger

numrows = 4*dimx;
numcols = 4*round(dimy*aspect);
delay_time = 5/dimz;  % show all gifs in 2 seconds


% Create new directory
ready = false;
cnt = 1;
while ~ready
    gifExportPath = strcat(gifExportBase,tag,'T1',filesep,num2str(cnt),filesep);
    if ~exist(gifExportPath, 'dir')
        mkdir(gifExportPath);
        ready = true;
    end
    cnt = cnt + 1;
end

app.TextMessage(strcat("GIF export folder = ",gifExportPath," ..."));

% Export the T1 maps to gifs

for idc = 1:nr_frames
    
    for idx = 1:dimz
        
        % because the color maps are arrays of size 256
        % the T1-map needs to be mapped onto the range of [0, 255] and cast in an
        % unsigned integer 8 for gif export
        image = uint8(round((255/T1MapScale)*imresize(squeeze(t1map(idc,:,:,idx)),[numrows numcols]))); %#ok<*RESZM> 
        
        if isfield(parameters, 'PHASE_ORIENTATION')
            if parameters.PHASE_ORIENTATION
                image = rot90(image,-1);
            end
        end
        
        if idx == 1
            imwrite(rot90(image),t1cmap,strcat(gifExportPath,filesep,'T1map_frame_',num2str(idc),'_',tag,'.gif'),'DelayTime',delay_time,'LoopCount',inf);
        else
            imwrite(rot90(image),t1cmap,strcat(gifExportPath,filesep,'T1map_frame_',num2str(idc),'_',tag,'.gif'),'WriteMode','append','DelayTime',delay_time);
        end
    end
    
end


% Export the M0 maps to GIF

for idc = 1:nr_frames
    
    for idx = 1:dimz
        
        % determine a convenient scale to display M0 maps (same as in the app)
        m0scale = round(2*mean(nonzeros(squeeze(m0map(idc,:,:,idx)))));
        m0scale(isnan(m0scale)) = 100;
        
        % automatic grayscale mapping is used for the gif export
        % the m0map therefore needs to be mapped onto the range of [0 255]
        image = uint8(round((255/m0scale)*imresize(squeeze(m0map(idc,:,:,idx)),[numrows numcols])));
        
        if isfield(parameters, 'PHASE_ORIENTATION')
            if parameters.PHASE_ORIENTATION
                image = rot90(image,-1);
            end
        end
        
        if idx == 1
            imwrite(rot90(image),strcat(gifExportPath,filesep,'M0map_frame_',num2str(idc),'_',tag,'.gif'),'DelayTime',delay_time,'LoopCount',inf);
        else
            imwrite(rot90(image),strcat(gifExportPath,filesep,'M0map_frame_',num2str(idc),'_',tag,'.gif'),'WriteMode','append','DelayTime',delay_time);
        end
    end
    
end


% Export GUI to png
app.RawImagesTabGroup.SelectedTab = app.RawimagesTab;
exportapp(app.T1mappUIFigure,strcat(gifExportPath,filesep,"T1mapping.png"));


end