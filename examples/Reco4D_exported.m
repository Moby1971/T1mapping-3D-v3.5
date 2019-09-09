classdef Reco4D_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        Reco4DUIFigure                 matlab.ui.Figure
        DashboardPanel                 matlab.ui.container.Panel
        ImportdataPanel                matlab.ui.container.Panel
        MRSolutionsCheckBox            matlab.ui.control.CheckBox
        BrukerCheckBox                 matlab.ui.control.CheckBox
        Lamp1                          matlab.ui.control.Lamp
        LoadDataButton                 matlab.ui.control.Button
        FLASH_CSLabel                  matlab.ui.control.Label
        FLASH_PROUDLabel               matlab.ui.control.Label
        ReconstructionPanel            matlab.ui.container.Panel
        ReconstructButton              matlab.ui.control.Button
        Lamp3                          matlab.ui.control.Lamp
        SortkspaceButton               matlab.ui.control.Button
        Lamp2                          matlab.ui.control.Lamp
        timeframesEditFieldLabel       matlab.ui.control.Label
        TimeFramesEditField            matlab.ui.control.NumericEditField
        TVEditFieldLabel               matlab.ui.control.Label
        TVEditField                    matlab.ui.control.NumericEditField
        WaveletEditFieldLabel          matlab.ui.control.Label
        WaveletEditField               matlab.ui.control.NumericEditField
        SortProgressViewField          matlab.ui.control.NumericEditField
        ExportdataPanel                matlab.ui.container.Panel
        ExportDicomButton              matlab.ui.control.Button
        ExportGifButton                matlab.ui.control.Button
        Lamp4                          matlab.ui.control.Lamp
        Lamp6                          matlab.ui.control.Lamp
        ExportNIFTIButton              matlab.ui.control.Button
        Lamp5                          matlab.ui.control.Lamp
        ExportProgressViewField        matlab.ui.control.NumericEditField
        Panel                          matlab.ui.container.Panel
        ExitButton                     matlab.ui.control.Button
        Label                          matlab.ui.control.Label
        Label_2                        matlab.ui.control.Label
        KspaceImageDataPanel           matlab.ui.container.Panel
        kspaceselectionPanel           matlab.ui.container.Panel
        orientationLabel_2             matlab.ui.control.Label
        KspaceOrientationSpinner       matlab.ui.control.Spinner
        KspaceDim1EditField            matlab.ui.control.NumericEditField
        KspaceDim1Slider               matlab.ui.control.Slider
        KspaceDim2EditField            matlab.ui.control.NumericEditField
        KspaceDim2Slider               matlab.ui.control.Slider
        KspaceDim1Label                matlab.ui.control.Label
        KspaceDim2Label                matlab.ui.control.Label
        ButtonGroup                    matlab.ui.container.ButtonGroup
        fillingButton                  matlab.ui.control.RadioButton
        averagesButton                 matlab.ui.control.RadioButton
        kvaluesButton                  matlab.ui.control.RadioButton
        KyLabel                        matlab.ui.control.Label
        KxLabel                        matlab.ui.control.Label
        KspaceFig                      matlab.ui.control.UIAxes
        AcquisitionparametersPanel     matlab.ui.container.Panel
        MatrixYViewField               matlab.ui.control.NumericEditField
        MatrixZViewField               matlab.ui.control.NumericEditField
        FOVYViewField                  matlab.ui.control.NumericEditField
        FOVZViewField                  matlab.ui.control.NumericEditField
        FOV1HViewFieldLabel            matlab.ui.control.Label
        FOVXViewField                  matlab.ui.control.NumericEditField
        MatrixEditField_2Label         matlab.ui.control.Label
        MatrixXViewField               matlab.ui.control.NumericEditField
        TRLabel                        matlab.ui.control.Label
        TRViewField                    matlab.ui.control.NumericEditField
        TELabel                        matlab.ui.control.Label
        TEViewField                    matlab.ui.control.NumericEditField
        alphaLabel                     matlab.ui.control.Label
        AlphaViewField                 matlab.ui.control.NumericEditField
        repsLabel                      matlab.ui.control.Label
        NrRepsViewField                matlab.ui.control.NumericEditField
        kpointsLabel                   matlab.ui.control.Label
        KlinesViewField                matlab.ui.control.NumericEditField
        kpointsrepLabel                matlab.ui.control.Label
        KlinesRepViewField             matlab.ui.control.NumericEditField
        kpointsframeLabel              matlab.ui.control.Label
        KlinesFrameViewField           matlab.ui.control.NumericEditField
        kspacefillingLabel             matlab.ui.control.Label
        FillingViewField               matlab.ui.control.NumericEditField
        AcquisitiontimeEditFieldLabel  matlab.ui.control.Label
        AcquisitionTimeViewField       matlab.ui.control.EditField
        SequenceEditFieldLabel         matlab.ui.control.Label
        SequenceViewField              matlab.ui.control.EditField
        VersionLabel                   matlab.ui.control.Label
        ReconstructionsPanel           matlab.ui.container.Panel
        StaticPanel                    matlab.ui.container.Panel
        ImageFig                       matlab.ui.control.UIAxes
        imageselectionPanel            matlab.ui.container.Panel
        orientationLabel               matlab.ui.control.Label
        IOrientationSpinner            matlab.ui.control.Spinner
        IDim1EditField                 matlab.ui.control.NumericEditField
        IDim1Slider                    matlab.ui.control.Slider
        IDim2EditField                 matlab.ui.control.NumericEditField
        IDim2Slider                    matlab.ui.control.Slider
        dim1Label                      matlab.ui.control.Label
        dim2Label                      matlab.ui.control.Label
        YLabel                         matlab.ui.control.Label
        MoviePanel                     matlab.ui.container.Panel
        MovieFig                       matlab.ui.control.UIAxes
        moviecontrolsPanel             matlab.ui.container.Panel
        MDimEditField                  matlab.ui.control.NumericEditField
        MDimSlider                     matlab.ui.control.Slider
        MDimLabel                      matlab.ui.control.Label
        orientationLabel_3             matlab.ui.control.Label
        MOrientationSpinner            matlab.ui.control.Spinner
        PlayButton                     matlab.ui.control.Button
        StopButton                     matlab.ui.control.Button
        MXLabel                        matlab.ui.control.Label
        MYLabel                        matlab.ui.control.Label
        XLabel                         matlab.ui.control.Label
        TitlePanel                     matlab.ui.control.Label
        AmsterdamUMCImage              matlab.ui.control.Image
        MessagesPanel                  matlab.ui.container.Panel
        MessageBox                     matlab.ui.control.TextArea
    end

 
    
    %% ---------------------------------------------------------
    %
    % 4D data reconstructor 
    %
    % Gustav Strijkers
    % g.j.strijkers@amsterdamumc.nl
    %
    % Version 1.0
    %
    % - first version
    %
    %
    %
    %
    %
    %
    %
    %% -----------------------------------------------------------
    
    
    
    
    
    properties (Access = private)
        
        data_import_path            % data import path
        nifti_export_path           % nifti export path
        dicom_export_path           % Dicom export path
        gif_export_path             % gif export path
        bart_detected               % Bart available true or false
        valid_datafile              % valid file loaded true or false
        valid_sort                  % valid sorted data file true or false
        valid_reco                  % valid reconstruction true or false
        valid_movie                 % valid movie data available true or false
        run_movie                   % movie is running true or false
        
        tag                         % Dicom export tag
        data                        % Raw data
        kspace                      % Unsorted k-space data
        ky                          % k-space trajectory, y dim
        kz                          % k-space trajectory, z dim
        skspace                     % Sorted k-space data
        nsaspace                    % Number of averages per k-space point
        kfilling                    % k-space filling pattern
        image4D                     % reconstructed 4D image
        seqpar                      % Sequence parameters structure
        
        image_orient                % image orientation
        kspace_orient_label         % kspace orientation label 
        image_orient_label          % image orientation label 
        
    end
    
   
    
    methods (Access = private)
        
        function SetLights(app,code)
           
            if ~strcmp(code{1},'Null') app.Lamp1.Color = code{1}; end
            if ~strcmp(code{2},'Null') app.Lamp2.Color = code{2}; end
            if ~strcmp(code{3},'Null') app.Lamp3.Color = code{3}; end
            if ~strcmp(code{4},'Null') app.Lamp4.Color = code{4}; end
            if ~strcmp(code{5},'Null') app.Lamp5.Color = code{5}; end
            if ~strcmp(code{6},'Null') app.Lamp6.Color = code{6}; end
            drawnow;
    
        end
        
        
        function result = GetLights(app)
           
            result{1} = app.Lamp1.Color;
            result{2} = app.Lamp2.Color;
            result{3} = app.Lamp3.Color;
            result{4} = app.Lamp4.Color;
            result{5} = app.Lamp5.Color;
            result{6} = app.Lamp6.Color;
            
        end
        
        
        function SetButtons(app,code)
            
            if ~strcmp(code{1},'Null') app.LoadDataButton.Enable = code{1}; end
            if ~strcmp(code{2},'Null') app.SortkspaceButton.Enable = code{2}; end
            if ~strcmp(code{3},'Null') app.ReconstructButton.Enable = code{3}; end
            if ~strcmp(code{4},'Null') app.ExportDicomButton.Enable = code{4}; end
            if ~strcmp(code{5},'Null') app.ExportNIFTIButton.Enable = code{5}; end
            if ~strcmp(code{6},'Null') app.ExportGifButton.Enable = code{6}; end
            if ~strcmp(code{7},'Null') app.ExitButton.Enable = code{7}; end
            drawnow;
            
        end
        
        
        function result = GetButtons(app)
            
            result{1} = app.LoadDataButton.Enable;
            result{2} = app.SortkspaceButton.Enable;
            result{3} = app.ReconstructButton.Enable;
            result{4} = app.ExportDicomButton.Enable;
            result{5} = app.ExportNIFTIButton.Enable;
            result{6} = app.ExportGifButton.Enable;
            result{7} = app.ExitButton.Enable;
            
        end
        
        
        
        function SetParametersFcn(app)
            
            % Common parameters
            
            % time, kx, ky, kz
            app.image_orient = [1 2 3 4; 1 3 2 4 ; 1 4 2 3 ; 3 4 1 2 ; 2 4 1 3 ; 2 3 1 4];
            app.kspace_orient_label = ["Ky" "Kz" "Time" "Kx"; "Kx" "Kz" "Time" "Ky" ; "Kx" "Ky" "Time" "Kz" ; "Time" "Kx" "Ky" "Kz" ; "Time" "Ky" "Kx" "Kz" ; "Time" "Kz" "Kx" "Ky"];
            app.image_orient_label = ["Y" "Z" "Time" "X"; "X" "Z" "Time" "Y" ; "X" "Y" "Time" "Z" ; "Time" "X" "Y" "Z" ; "Time" "Y" "X" "Z" ; "Time" "Z" "X" "Y"];        
            
            % acquisition parameters
            app.MatrixXViewField.Value = app.seqpar.matrix(1);
            app.MatrixYViewField.Value = app.seqpar.matrix(2);
            app.MatrixZViewField.Value = app.seqpar.matrix(3);
            app.FOVXViewField.Value = app.seqpar.FOV3D(1);
            app.FOVYViewField.Value = app.seqpar.FOV3D(2);
            app.FOVZViewField.Value = app.seqpar.FOV3D(3);
            app.TRViewField.Value = app.seqpar.tr;
            app.TEViewField.Value = app.seqpar.te;
            app.AlphaViewField.Value = app.seqpar.alpha;
            app.NrRepsViewField.Value = app.seqpar.NO_REPETITIONS;
            app.KlinesViewField.Value = length(app.kspace);
            app.KlinesRepViewField.Value = round(length(app.kspace)/app.seqpar.NO_REPETITIONS);
            app.KlinesFrameViewField.Value = round(length(app.kspace)/app.TimeFramesEditField.Value);
            app.AcquisitionTimeViewField.Value = app.seqpar.acqtime;
            app.SequenceViewField.Value = app.seqpar.PPL;
            
            app.run_movie = false;
            
            
        end % SetParametersFcn
     
        
        
        function PlotKspaceDataFig(app)
            
            cla(app.KspaceFig);
            hold(app.KspaceFig,'on');
            
            if app.valid_datafile
                
                % Select the data
                if app.fillingButton.Value == 1 im = app.kfilling; cmap = summer; end
                if app.averagesButton.Value == 1 im = app.nsaspace; cmap = parula; end
                if app.kvaluesButton.Value == 1 im = abs(app.skspace); cmap = gray; end
                
                % Select which slice to show
                im = permute(im,app.image_orient(app.KspaceOrientationSpinner.Value,:));
                im = permute(im(app.KspaceDim1EditField.Value,app.KspaceDim2EditField.Value,:,:),[3,4,1,2]);
                
                % Label the orientations
                app.KxLabel.Text = app.kspace_orient_label(app.KspaceOrientationSpinner.Value,1);
                app.KyLabel.Text = app.kspace_orient_label(app.KspaceOrientationSpinner.Value,2);
                app.KspaceDim1Label.Text = app.kspace_orient_label(app.KspaceOrientationSpinner.Value,3);
                app.KspaceDim2Label.Text = app.kspace_orient_label(app.KspaceOrientationSpinner.Value,4);
                
                % Plot the image in the k-space images panel
                app.KspaceFig.Position = [31,44,230,230];
                xlim(app.KspaceFig,[0, size(im,1) + 1]);
                ylim(app.KspaceFig,[0, size(im,2) + 1]);
                imshow(rot90(im),[0 max(im(:))],'ColorMap',cmap,'InitialMagnification','fit','Parent',app.KspaceFig);
                
            end
             
            hold(app.KspaceFig,'off');
            drawnow;
            
        end % PlotKspaceDataFig
        
       
        
        function PlotImageFig(app)
            
            cla(app.ImageFig);
            hold(app.ImageFig,'on');
            
            if app.valid_reco
                
                % Select the data
                im = app.image4D;
                
                % Estimate a suitable scale
                scale = 8*round(mean(nonzeros(im(:))));
                if isnan(scale) scale = 100; end
                
                % Select which slice to show
                im = permute(im,app.image_orient(app.IOrientationSpinner.Value,:));
                im = permute(im(app.IDim1EditField.Value,app.IDim2EditField.Value,:,:),[3,4,1,2]);
                
                % Label the orientations
                app.XLabel.Text = app.image_orient_label(app.IOrientationSpinner.Value,1);
                app.YLabel.Text = app.image_orient_label(app.IOrientationSpinner.Value,2);
                app.dim1Label.Text = app.image_orient_label(app.IOrientationSpinner.Value,3);
                app.dim2Label.Text = app.image_orient_label(app.IOrientationSpinner.Value,4);
                
                % Image aspect ratio
                aratio = CalcAspectratioFnc(app,app.XLabel.Text,app.YLabel.Text,size(im,1),size(im,2));
                daspect(app.ImageFig,[aratio 1 1]);
                
                % Plot the image in the k-space images panel
                app.ImageFig.Position = [64,8,300,300];
                xlim(app.ImageFig,[0, size(im,1) + 1]);
                ylim(app.ImageFig,[0, size(im,2) + 1]);
                imshow(rot90(im),[0 scale],'InitialMagnification','fit','Parent',app.ImageFig);
                
            end
             
            hold(app.ImageFig,'off');
            drawnow;
            
        end % PlotKspaceDataFig
        
        
        
        function PlotMovieFig(app)
            
            cla(app.MovieFig);
            hold(app.MovieFig,'on');
            
            if app.valid_movie
                
                % Select the data
                im0 = app.image4D;
                
                % Estimate a suitable scale
                scale = 8*round(mean(nonzeros(im0(:))));
                if isnan(scale) scale = 100; end
                
                counter = 1;
                
                while 1
                    
                    % Select which slice to show
                    im = permute(im0,app.image_orient(app.MOrientationSpinner.Value,:));
                    im = squeeze(im(counter,app.MDimEditField.Value,:,:));
                    
                    % Label the orientations
                    app.MXLabel.Text = app.image_orient_label(app.MOrientationSpinner.Value,1);
                    app.MYLabel.Text = app.image_orient_label(app.MOrientationSpinner.Value,2);
                    app.MDimLabel.Text = app.image_orient_label(app.MOrientationSpinner.Value,4);
                    
                    % Image aspect ratio
                    aratio = CalcAspectratioFnc(app,app.MXLabel.Text,app.MYLabel.Text,size(im,1),size(im,2));
                    daspect(app.MovieFig,[aratio 1 1]);
                    
                    % Set the axies
                    app.MovieFig.Position = [64,28,300,300];
                    xlim(app.MovieFig,[0, size(im,1) + 1]);
                    ylim(app.MovieFig,[0, size(im,2) + 1]);
                    
                    imshow(rot90(im),[0 scale],'InitialMagnification','fit','Parent',app.MovieFig);
                    drawnow;
                    
                    counter = counter + 1;
                    if counter > app.TimeFramesEditField.Value
                        counter = 1;
                    end
                    
                    if app.run_movie == false % loop runs 1 time if false
                        break; 
                    end
                    
                end
                
            end
             
            hold(app.MovieFig,'off');
            drawnow;
            
        end % PlotKspaceDataFig
        
        
        
        function result = CalcAspectratioFnc(app,dim1label,dim2label,sizex,sizey)
        
            if strcmp(dim1label,'X') L1 = app.seqpar.FOV3D(1); end
            if strcmp(dim1label,'Y') L1 = app.seqpar.FOV3D(2); end    
            if strcmp(dim1label,'Z') L1 = app.seqpar.FOV3D(3); end
            if strcmp(dim1label,'Time') L1 = 0.25*app.TimeFramesEditField.Value; end
            if strcmp(dim2label,'X') L2 = app.seqpar.FOV3D(1); end
            if strcmp(dim2label,'Y') L2 = app.seqpar.FOV3D(2); end    
            if strcmp(dim2label,'Z') L2 = app.seqpar.FOV3D(3); end 
            if strcmp(dim2label,'Time') L2 = 0.25*app.TimeFramesEditField.Value; end
             
            result = (L2/L1)*(sizex/sizey);
            
        end % Aspectratio
        
        
        
    end
    
    
    
    methods (Access = public)
  
        
        function TextMessage(app, message)
            
            % Text messages in the app
            app.MessageBox.Value = [message ; app.MessageBox.Value];
            drawnow;
            
        end % TextMessage
        
        
        function ShowFitProgress(app, progress)
            
            % Update the progress bar
            app.ProgressGauge.Value = progress;
            
        end % ShowFitProgress
  
        
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
              
            % empty file import and export paths
            app.data_import_path = '';
            app.dicom_export_path = '';
            app.nifti_export_path = ''; 
            app.gif_export_path = '';
            
            % add the bart path to the environment variable if available
            app.bart_detected = false;
            if isfile('bartpath.txt')
                app.bart_detected = true;    
                setenv('TOOLBOX_PATH', fileread('bartpath.txt'));
            end
            
            % add subfolders to search path
            if (~isdeployed)
                addpath(genpath(pwd));
            end
            
            % suppress unneccesary warnings
            warning off;
                    
        end

        % Value changed function: MRSolutionsCheckBox
        function MRSolutionsCheckBoxValueChanged(app, event)
            
            % set data format to MR Solutions
            app.BrukerCheckBox.Value = 0;
            app.MRSolutionsCheckBox.Value = 1;
            
        end

        % Value changed function: BrukerCheckBox
        function BrukerCheckBoxValueChanged(app, event)
            
            % set data format to Bruker
            app.BrukerCheckBox.Value = 1;
            app.MRSolutionsCheckBox.Value = 0;
            
        end

        % Button pushed function: LoadDataButton
        function LoadDataButtonPushed(app, event)
            
            % Indicate busy
            SetLights(app,{'Yellow','Null','Null','Null','Null','Null'});
            SetButtons(app,{'off','off','off','off','off','off','off'});
            
            app.valid_datafile = false;
            app.valid_sort = false;
            
            if app.BrukerCheckBox.Value == 1
                
                % Read bruker data, select a FID file
                app.Reco4DUIFigure.Visible = 'off';
                [datafile,app.data_import_path] = uigetfile([app.data_import_path,'*.*'],'Select an FID file');
                app.Reco4DUIFigure.Visible = 'on';
                
                if strcmp(datafile,'fid')
                    
                    app.valid_datafile = true;
                    
                    % Read the Bruker data
                    app.TextMessage('Reading Bruker data ...');
                    info = jcampread([app.data_import_path,'acqp']);
                    fileID = fopen([app.data_import_path,'fid']);
                    app.data = fread(fileID,'int32');
                    fclose(fileID);
                    
                    % Bruker-specific sequence parameters
                    app.TextMessage('Reading sequence parameters ...');
                    app.seqpar.matrix = info.acq.size./[2 1 1];  % x y z
                    app.seqpar.FOV3D = info.acq.fov*10;
                    app.seqpar.filename = 'Proton';
                    app.seqpar.tr = info.acq.repetition_time;
                    app.seqpar.te = info.acq.echo_time;
                    app.seqpar.alpha = str2num(info.acq.flip_angle);
                    app.seqpar.NO_ECHOES = 1;
                    app.seqpar.NO_AVERAGES = str2num(info.NA);
                    app.seqpar.NO_REPETITIONS = str2num(info.NR);
                    app.seqpar.date = datetime;
                    app.seqpar.nucleus = '1H';
                    app.seqpar.PPL = info.acq.method;
                    app.seqpar.field_strength = str2num(info.BF1)/42.58;
                    app.seqpar.filename = 111;
                    
                    % unsorted complex k-space data
                    app.TextMessage('Constructing complex k-space data ...');
                    kreal = app.data(1:2:end);
                    kim = app.data(2:2:end);
                    app.kspace = kreal + 1j*kim;
                  
                    % total acq time in hrs:min:sec
                    at = seconds(length(app.kspace)*app.seqpar.tr*0.001/app.seqpar.matrix(1));
                    at.Format = 'hh:mm:ss';
                    app.seqpar.acqtime = datestr(at,'HH:MM:SS');
                    
                    % k-space trajectory
                    app.TextMessage('Defining k-space trajectory ...');
                    dimy = app.seqpar.matrix(2);
                    dimz = app.seqpar.matrix(3);
                    ky1rep = round(info.acq.spatial_phase_1 * (dimy-1)/2 + dimy/2);
                    kz1rep = round(info.acq.spatial_phase_2 * (dimz-1)/2 + dimz/2);
                    app.ky=[]; for i=1:app.seqpar.NO_REPETITIONS app.ky = [app.ky, ky1rep]; end
                    app.kz=[]; for i=1:app.seqpar.NO_REPETITIONS app.kz = [app.kz, kz1rep]; end
                    
                end
                
            else        
                
                % MR Solutions data not implemented yet
                
            end
            
            % Report on valid/invalid file selection
            if app.valid_datafile
                
                % Set the buttons for valid file
                SetLights(app,{'Green','Null','Null','Null','Null','Null'});
                SetButtons(app,{'on','on','off','off','off','off','on'});
                
                % Set other parameters
                SetParametersFcn(app);
          
            else                
                
                % Not a valid data file 
                uialert(app.Reco4DUIFigure,'Please select a valid data file','Error');
                app.data_import_path = '';
                
                % Set the buttons for invalid data file 
                SetLights(app,{'Red','Null','Null','Null','Null','Null'});
                SetButtons(app,{'on','off','off','off','off','off','on'});
                
            end
        
        end

        % Value changed function: KspaceDim1EditField
        function KspaceDim1EditFieldValueChanged(app, event)
            
            if app.valid_sort
                app.KspaceDim1Slider.Value = app.KspaceDim1EditField.Value;         % adjust slider according to edit field
                PlotKspaceDataFig(app);                                                 % plot the k-space
            end
            
        end

        % Value changed function: KspaceDim1Slider
        function KspaceDim1SliderValueChanged(app, event)
            
            if app.valid_sort
                app.KspaceDim1EditField.Value = round(app.KspaceDim1Slider.Value);
                PlotKspaceDataFig(app);
            end

        end

        % Value changed function: KspaceDim2EditField
        function KspaceDim2EditFieldValueChanged(app, event)
            
            if app.valid_sort
                app.KspaceDim2Slider.Value = app.KspaceDim2EditField.Value;
                PlotKspaceDataFig(app);
            end
            
        end

        % Value changed function: KspaceDim2Slider
        function KspaceDim2SliderValueChanged(app, event)
            
            if app.valid_sort
                app.KspaceDim2EditField.Value = round(app.KspaceDim2Slider.Value);
                PlotKspaceDataFig(app);
            end
            
        end

        % Value changed function: KspaceOrientationSpinner
        function KspaceOrientationSpinnerValueChanged(app, event)
            
            if app.valid_sort
                
                % reset the limits to the appropriate bounds
                app.KspaceDim1EditField.Value = 1;
                app.KspaceDim1Slider.Value = 1;
                app.KspaceDim2EditField.Value = 1;
                app.KspaceDim2Slider.Value = 1;
                
                if size(app.skspace,app.image_orient(app.KspaceOrientationSpinner.Value,1)) > 1
                    app.KspaceDim1EditField.Limits = [1 size(app.skspace,app.image_orient(app.KspaceOrientationSpinner.Value,1))];
                    app.KspaceDim1Slider.Limits = [1 size(app.skspace,app.image_orient(app.KspaceOrientationSpinner.Value,1))];
                    app.KspaceDim1EditField.Value = round(size(app.skspace,app.image_orient(app.KspaceOrientationSpinner.Value,1))/2);
                    app.KspaceDim1Slider.Value = round(size(app.skspace,app.image_orient(app.KspaceOrientationSpinner.Value,1))/2);
                    app.KspaceDim1EditField.Enable = 'on';
                    app.KspaceDim1Slider.Enable = 'on';
                else
                    app.KspaceDim1EditField.Enable = 'off';
                    app.KspaceDim1Slider.Enable = 'off';
                end
                
                if size(app.skspace,app.image_orient(app.KspaceOrientationSpinner.Value,2)) > 1
                    app.KspaceDim2EditField.Limits = [1 size(app.skspace,app.image_orient(app.KspaceOrientationSpinner.Value,2))];
                    app.KspaceDim2Slider.Limits = [1 size(app.skspace,app.image_orient(app.KspaceOrientationSpinner.Value,2))];
                    app.KspaceDim2EditField.Value = round(size(app.skspace,app.image_orient(app.KspaceOrientationSpinner.Value,2))/2);
                    app.KspaceDim2Slider.Value = round(size(app.skspace,app.image_orient(app.KspaceOrientationSpinner.Value,2))/2);
                    app.KspaceDim2EditField.Enable = 'on';
                    app.KspaceDim2Slider.Enable = 'on';
                else
                    app.KspaceDim2EditField.Enable = 'off';
                    app.KspaceDim2Slider.Enable = 'off';
                end
                
                % plot the k-space
                PlotKspaceDataFig(app);
                
            end

        end

        % Selection changed function: ButtonGroup
        function ButtonGroupSelectionChanged(app, event)
         
            if app.valid_sort
                PlotKspaceDataFig(app);
            end
            
        end

        % Value changed function: TimeFramesEditField
        function TimeFramesEditFieldValueChanged(app, event)
            
            app.KlinesFrameViewField.Value = round(length(app.kspace)/app.TimeFramesEditField.Value);
            
            % Set the buttons for valid file
            SetLights(app,{'Green','Red','Red','Red','Red','Red'});
            SetButtons(app,{'on','on','off','off','off','off','on'});

        end

        % Button pushed function: SortkspaceButton
        function SortkspaceButtonPushed(app, event)
            
            % Indicate busy
            SetLights(app,{'Null','Yellow','Null','Null','Null','Null'});
            SetButtons(app,{'off','off','off','off','off','off','off'});
        
            % sort
            app.SortProgressViewField.Value = 0;
            [app.skspace,app.nsaspace,app.kfilling] = sortkspace(app,app.kspace,app.seqpar.matrix,app.ky,app.kz,app.seqpar.NO_REPETITIONS,app.TimeFramesEditField.Value);
            app.valid_sort = true;
            
            % plot the k-space
            KspaceOrientationSpinnerValueChanged(app, event);
            PlotKspaceDataFig(app);
            
            % show percentage k-space filling
            app.FillingViewField.Value = round(100*sum(app.kfilling(:)==1)/(app.TimeFramesEditField.Value*app.seqpar.matrix(1)*app.seqpar.matrix(2)*app.seqpar.matrix(3)));
            
            % Reset buttons
            SetLights(app,{'Null','Green','Null','Null','Null','Null'});
            SetButtons(app,{'on','on','on','off','off','off','on'});
            
        end

        % Button pushed function: ReconstructButton
        function ReconstructButtonPushed(app, event)
        
            % Indicate busy
            SetLights(app,{'Null','Null','Yellow','Red','Red','Red'});
            SetButtons(app,{'off','off','off','off','off','off','off'});
        
            % do the reconstruction
            if app.bart_detected == true
                app.image4D = reco4D(app,app.skspace,app.nsaspace,app.TVEditField.Value,app.WaveletEditField.Value);
                app.valid_reco = true;
                if size(app.image4D,1)>1 app.valid_movie = true; end
            else
                app.TextMessage('FATAL ERROR: BART toolbox not available ...');
                app.TextMessage('Reconstruction not possible ...');
                app.valid_reco = false;
                app.valid_movie = false;
            end
            
            % plot the images and show the movie
            IOrientationSpinnerValueChanged(app, event);
            PlotImageFig(app);
            MOrientationSpinnerValueChanged(app, event);
            app.run_movie = false;
            PlotMovieFig(app);
                        
            % Reset buttons
            SetLights(app,{'Null','Null','Green','Null','Null','Null'});
            SetButtons(app,{'on','on','on','on','on','on','on'});
        
        end

        % Value changed function: IDim1EditField
        function IDim1EditFieldValueChanged(app, event)
            
            if app.valid_reco
                app.IDim1Slider = app.IDim1EditField.Value;
                PlotImageFig(app);
            end
            
        end

        % Value changed function: IDim1Slider
        function IDim1SliderValueChanged(app, event)
            
            if app.valid_reco
                app.IDim1EditField.Value = round(app.IDim1Slider.Value);
                PlotImageFig(app);
            end
            
        end

        % Value changed function: IDim2EditField
        function IDim2EditFieldValueChanged(app, event)
            
            if app.valid_reco
                app.IDim2Slider = app.IDim2EditField.Value;
                PlotImageFig(app);
            end
            
        end

        % Value changed function: IDim2Slider
        function IDim2SliderValueChanged(app, event)
            
            if app.valid_reco
                app.IDim2EditField.Value = round(app.IDim2Slider.Value);
                PlotImageFig(app);
            end
            
        end

        % Value changed function: IOrientationSpinner
        function IOrientationSpinnerValueChanged(app, event)
             
            if app.valid_reco
                
                % reset the limits to the appropriate bounds
                app.IDim1EditField.Value = 1;
                app.IDim1Slider.Value = 1;
                app.IDim2EditField.Value = 1;
                app.IDim2Slider.Value = 1;
                
                if size(app.image4D,app.image_orient(app.IOrientationSpinner.Value,1)) > 1
                    app.IDim1EditField.Limits = [1 size(app.image4D,app.image_orient(app.IOrientationSpinner.Value,1))];
                    app.IDim1Slider.Limits = [1 size(app.image4D,app.image_orient(app.IOrientationSpinner.Value,1))];
                    app.IDim1EditField.Value = round(size(app.image4D,app.image_orient(app.IOrientationSpinner.Value,1))/2);
                    app.IDim1Slider.Value = round(size(app.image4D,app.image_orient(app.IOrientationSpinner.Value,1))/2);
                    app.IDim1EditField.Enable = 'on';
                    app.IDim1Slider.Enable = 'on';
                else
                    app.IDim1EditField.Enable = 'off';
                    app.IDim1Slider.Enable = 'off';
                end
                
                if size(app.image4D,app.image_orient(app.IOrientationSpinner.Value,2)) > 1
                    app.IDim2EditField.Limits = [1 size(app.image4D,app.image_orient(app.IOrientationSpinner.Value,2))];
                    app.IDim2Slider.Limits = [1 size(app.image4D,app.image_orient(app.IOrientationSpinner.Value,2))];
                    app.IDim2EditField.Value = round(size(app.image4D,app.image_orient(app.IOrientationSpinner.Value,2))/2);
                    app.IDim2Slider.Value = round(size(app.image4D,app.image_orient(app.IOrientationSpinner.Value,2))/2);
                    app.IDim2EditField.Enable = 'on';
                    app.IDim2Slider.Enable = 'on';
                else
                    app.IDim2EditField.Enable = 'off';
                    app.IDim2Slider.Enable = 'off';
                end
                
                % plot the k-space
                PlotImageFig(app);
                
             end
            
        end

        % Value changed function: MDimEditField
        function MDimEditFieldValueChanged(app, event)
            
            if app.valid_movie
                
                app.MDimSlider.Value = app.MDimEditField.Value;
                
                % if the movie is not running, show the static frame
                if ~app.run_movie
                    PlotMovieFig(app);
                end
                
            end
            
        end

        % Value changed function: MDimSlider
        function MDimSliderValueChanged(app, event)
            
            if app.valid_movie
                
                app.MDimEditField.Value = round(app.MDimSlider.Value);
                
                % if the movie is not running, show the static frame
                if ~app.run_movie
                    PlotMovieFig(app);
                end
                
            end
            
        end

        % Value changed function: MOrientationSpinner
        function MOrientationSpinnerValueChanged(app, event)
            
            if app.valid_movie
                
                % reset the limits to the appropriate bounds
                app.MDimEditField.Value = 1;
                app.MDimSlider.Value = 1;
                
                app.MDimEditField.Limits = [1 size(app.image4D,app.image_orient(app.MOrientationSpinner.Value,2))];
                app.MDimSlider.Limits = [1 size(app.image4D,app.image_orient(app.MOrientationSpinner.Value,2))];
                app.MDimEditField.Value = round(size(app.image4D,app.image_orient(app.MOrientationSpinner.Value,2))/2);
                app.MDimSlider.Value = round(size(app.image4D,app.image_orient(app.MOrientationSpinner.Value,2))/2);
                
                % if the movie is not running, show the static frame
                if ~app.run_movie
                    PlotMovieFig(app);
                end
                
            
            end
            
        end

        % Button pushed function: PlayButton
        function PlayButtonPushed(app, event)
            
            if app.valid_movie
                
                SetButtons(app,{'Null','Null','Null','Null','Null','Null','off'});
                app.run_movie = true;
                PlotMovieFig(app);
                
            end
           
        end

        % Button pushed function: StopButton
        function StopButtonPushed(app, event)
            
            app.run_movie = false;
            SetButtons(app,{'Null','Null','Null','Null','Null','Null','on'});
        
        end

        % Button pushed function: ExportDicomButton
        function ExportDicomButtonPushed(app, event)
            
           % Indicate busy
            SetLights(app,{'Null','Null','Null','Yellow','Null','Null'});
            SetButtons(app,{'off','off','off','off','off','off','off'});
            
            % Ask for directory
            app.Reco4DUIFigure.Visible = 'off';
            app.dicom_export_path = uigetdir(app.dicom_export_path,'DICOM export path');
            app.Reco4DUIFigure.Visible = 'on';
            drawnow;
            
            % Check if directory exists
            ready = true;
            if ~ischar(app.dicom_export_path)   % user cancel
                ready = false;
                app.dicom_export_path = '';
            else
                [~, Attrib] = fileattrib(app.dicom_export_path);
                if ~any(Attrib.UserWrite)   % check if directory is writable
                    ready = false;
                end
            end
            
            % Some parameters
            app.seqpar.SLICE_SEPARATION = app.seqpar.FOV3D(1)/app.seqpar.matrix(1);
            app.seqpar.SLICE_THICKNESS = app.seqpar.FOV3D(1)/app.seqpar.matrix(1);
            app.seqpar.SLICE_INTERLEAVE = 1;
            app.seqpar.SMX = app.seqpar.FOV3D(2)/app.seqpar.matrix(2);
            app.seqpar.SMY = app.seqpar.FOV3D(3)/app.seqpar.matrix(3);
            app.seqpar.FOV = app.seqpar.FOV3D(2);
            app.seqpar.NO_SLICES = app.seqpar.matrix(1);
            app.seqpar.NO_VIEWS = app.seqpar.matrix(2);
            app.seqpar.NO_VIEWS2 = app.seqpar.matrix(3);
            app.seqpar.timeperframe = (length(app.kspace)*app.seqpar.tr*0.001/app.seqpar.matrix(1))/app.TimeFramesEditField.Value;
            app.seqpar.nr_frames = app.TimeFramesEditField.Value;
            
            % Export to DICOM
            if ready
                
                % normalize to suitable range
                im = round(32767 * app.image4D / max(app.image4D(:)));
                
                app.ExportProgressViewField.Value = 0;
                drawnow;
                
                app.TextMessage('Exporting to DICOM files ...');
                
                % export
                export_dicom_4D(app,app.dicom_export_path,im,app.seqpar,'4D');
                
                app.TextMessage('DICOM export finished ...');
                
                % Reset buttons
                SetLights(app,{'Null','Null','Null','Green','Null','Null'});
                SetButtons(app,{'on','on','on','on','on','on','on'});
                
            else
                
                f = app.Reco4DUIFigure;
                uialert(f,'Not a valid directory','Error');
                
                % Reset buttons
                SetLights(app,{'Null','Null','Null','Red','Null','Null'});
                SetButtons(app,{'on','on','on','on','on','on','on'});
                
            end
                 
        end

        % Button pushed function: ExportNIFTIButton
        function ExportNIFTIButtonPushed(app, event)
            
            % Indicate busy
            SetLights(app,{'Null','Null','Null','Null','Yellow','Null'});
            SetButtons(app,{'off','off','off','off','off','off','off'});
            
            % Ask for directory
            app.Reco4DUIFigure.Visible = 'off';
            app.nifti_export_path = uigetdir(app.nifti_export_path,'DICOM export path');
            app.Reco4DUIFigure.Visible = 'on';
            drawnow;
            
            % Check if directory exists
            ready = true;
            if ~ischar(app.nifti_export_path)   % user cancel
                ready = false;
                app.nifti_export_path = '';
            else
                [~, Attrib] = fileattrib(app.nifti_export_path);
                if ~any(Attrib.UserWrite)   % check if directory is writable
                    ready = false;
                end
            end
            
            % Export to NIFTI
            if ready
                
                app.TextMessage('Exporting to NIFTI ...');
                
                % Normalize images and determine dimensions
                im = round(32767 * app.image4D / max(app.image4D(:)));
                [nrframes,dimx,dimy,dimz] = size(im);
                im = permute(im,[2,3,4,1]);
                app.seqpar.timeperframe = (length(app.kspace)*app.seqpar.tr*0.001/app.seqpar.matrix(1))/app.TimeFramesEditField.Value;               
                
                % Set some parameters
                load('niftiinfo.mat');
                info.Filemoddate = datestr(datetime);
                info.Filesize = dimx*dimy*dimz*nrframes*32;
                info.ImageSize = [dimx dimy dimz nrframes];
                info.PixelDimensions = [app.seqpar.FOV3D(1)/dimx app.seqpar.FOV3D(2)/dimy app.seqpar.FOV3D(3)/dimz app.seqpar.timeperframe];
                info.raw.dim = [dimx dimy dimz nrframes 1 1 1 1];
                info.raw.pixdim = [app.seqpar.FOV3D(1)/dimx app.seqpar.FOV3D(2)/dimy app.seqpar.FOV3D(3)/dimz app.seqpar.timeperframe 0 0 0 0];
                info.Version = 1;
                
                % Export NIFTI
                niftiwrite(im,[app.nifti_export_path,'/im4D.nii'],info);
                
                app.TextMessage('NIFTI export finished ...');
                
                % Reset buttons
                SetLights(app,{'Null','Null','Null','Null','Green','Null'});
                SetButtons(app,{'on','on','on','on','on','on','on'});
                
            else
                
                f = app.Reco4DUIFigure;
                uialert(f,'Not a valid directory','Error');
                
                % Reset buttons
                SetLights(app,{'Null','Null','Null','Null','Red','Null'});
                SetButtons(app,{'on','on','on','on','on','on','on'});
                
            end
          
        end

        % Button pushed function: ExportGifButton
        function ExportGifButtonPushed(app, event)
            
            % Indicate busy
            SetLights(app,{'Null','Null','Null','Null','Null','Yellow'});
            SetButtons(app,{'off','off','off','off','off','off','off'});
        
            % Ask for directory
            app.Reco4DUIFigure.Visible = 'off';
            app.gif_export_path = uigetdir(app.gif_export_path,'GIF export path');
            app.Reco4DUIFigure.Visible = 'on';
            drawnow;
            
            % Check if directory exists
            ready = true;
            if ~ischar(app.gif_export_path)   % user cancel
                ready = false;
                app.gif_export_path = '';
            else
                [~, Attrib] = fileattrib(app.gif_export_path);
                if ~any(Attrib.UserWrite)   % check if directory is writable
                    ready = false;
                end
            end
            
            % Export to animated gif
            if ready
                
                if app.valid_movie
                
                    app.TextMessage('Exporting to GIF ...');
                    
                    % select movie
                    im = permute(app.image4D,app.image_orient(app.MOrientationSpinner.Value,:));
                    im = squeeze(im(:,app.MDimEditField.Value,:,:));
                                
                    % export gif
                    export_gif_4D(app.gif_export_path,im);
                    
                    app.TextMessage('GIF export finished ...');
                
                end
                
                % Reset buttons
                SetLights(app,{'Null','Null','Null','Null','Null','Green'});
                SetButtons(app,{'on','on','on','on','on','on','on'});
                
            else
                
                f = app.Reco4DUIFigure;
                uialert(f,'Not a valid directory','Error');
                SetLights(app,{'Null','Null','Null','Null','Null','Red'});
                SetButtons(app,{'on','on','on','on','on','on','on'});
                
            end
            
        end

        % Button pushed function: ExitButton
        function ExitButtonPushed(app, event)
            
            % Exit
            app.delete;
        
        end

        % Value changed function: TVEditField, WaveletEditField
        function TVEditFieldValueChanged(app, event)
            
            % Set the buttons for valid file
            SetLights(app,{'Green','Green','Red','Red','Red','Red'});
            SetButtons(app,{'on','on','on','off','off','off','on'});
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create Reco4DUIFigure and hide until all components are created
            app.Reco4DUIFigure = uifigure('Visible', 'off');
            app.Reco4DUIFigure.AutoResizeChildren = 'off';
            app.Reco4DUIFigure.Position = [100 100 1377 875];
            app.Reco4DUIFigure.Resize = 'off';

            % Create DashboardPanel
            app.DashboardPanel = uipanel(app.Reco4DUIFigure);
            app.DashboardPanel.AutoResizeChildren = 'off';
            app.DashboardPanel.ForegroundColor = [0 0.4471 0.7412];
            app.DashboardPanel.TitlePosition = 'centertop';
            app.DashboardPanel.Title = 'Dashboard';
            app.DashboardPanel.FontWeight = 'bold';
            app.DashboardPanel.FontSize = 15;
            app.DashboardPanel.Position = [33 41 223 759];

            % Create ImportdataPanel
            app.ImportdataPanel = uipanel(app.DashboardPanel);
            app.ImportdataPanel.AutoResizeChildren = 'off';
            app.ImportdataPanel.ForegroundColor = [0 0.4471 0.7412];
            app.ImportdataPanel.TitlePosition = 'centertop';
            app.ImportdataPanel.Title = 'Import data';
            app.ImportdataPanel.Position = [10 575 204 148];

            % Create MRSolutionsCheckBox
            app.MRSolutionsCheckBox = uicheckbox(app.ImportdataPanel);
            app.MRSolutionsCheckBox.ValueChangedFcn = createCallbackFcn(app, @MRSolutionsCheckBoxValueChanged, true);
            app.MRSolutionsCheckBox.Text = 'MR Solutions';
            app.MRSolutionsCheckBox.Position = [9 93 94 22];

            % Create BrukerCheckBox
            app.BrukerCheckBox = uicheckbox(app.ImportdataPanel);
            app.BrukerCheckBox.ValueChangedFcn = createCallbackFcn(app, @BrukerCheckBoxValueChanged, true);
            app.BrukerCheckBox.Text = 'Bruker';
            app.BrukerCheckBox.Position = [123 93 58 22];
            app.BrukerCheckBox.Value = true;

            % Create Lamp1
            app.Lamp1 = uilamp(app.ImportdataPanel);
            app.Lamp1.Position = [121 24 20 20];
            app.Lamp1.Color = [1 0 0];

            % Create LoadDataButton
            app.LoadDataButton = uibutton(app.ImportdataPanel, 'push');
            app.LoadDataButton.ButtonPushedFcn = createCallbackFcn(app, @LoadDataButtonPushed, true);
            app.LoadDataButton.BackgroundColor = [0.8 0.8 0.8];
            app.LoadDataButton.Position = [9 23 100 22];
            app.LoadDataButton.Text = 'Load data';

            % Create FLASH_CSLabel
            app.FLASH_CSLabel = uilabel(app.ImportdataPanel);
            app.FLASH_CSLabel.Position = [122 65 66 22];
            app.FLASH_CSLabel.Text = 'FLASH_CS';

            % Create FLASH_PROUDLabel
            app.FLASH_PROUDLabel = uilabel(app.ImportdataPanel);
            app.FLASH_PROUDLabel.Position = [9 65 92 22];
            app.FLASH_PROUDLabel.Text = 'FLASH_PROUD';

            % Create ReconstructionPanel
            app.ReconstructionPanel = uipanel(app.DashboardPanel);
            app.ReconstructionPanel.AutoResizeChildren = 'off';
            app.ReconstructionPanel.ForegroundColor = [0 0.4471 0.7412];
            app.ReconstructionPanel.TitlePosition = 'centertop';
            app.ReconstructionPanel.Title = 'Reconstruction';
            app.ReconstructionPanel.Position = [10 326 204 228];

            % Create ReconstructButton
            app.ReconstructButton = uibutton(app.ReconstructionPanel, 'push');
            app.ReconstructButton.ButtonPushedFcn = createCallbackFcn(app, @ReconstructButtonPushed, true);
            app.ReconstructButton.BackgroundColor = [0.8 0.8 0.8];
            app.ReconstructButton.Enable = 'off';
            app.ReconstructButton.Position = [9 15 100 22];
            app.ReconstructButton.Text = 'Reconstruct';

            % Create Lamp3
            app.Lamp3 = uilamp(app.ReconstructionPanel);
            app.Lamp3.Position = [121 16 20 20];
            app.Lamp3.Color = [1 0 0];

            % Create SortkspaceButton
            app.SortkspaceButton = uibutton(app.ReconstructionPanel, 'push');
            app.SortkspaceButton.ButtonPushedFcn = createCallbackFcn(app, @SortkspaceButtonPushed, true);
            app.SortkspaceButton.BackgroundColor = [0.8 0.8 0.8];
            app.SortkspaceButton.Enable = 'off';
            app.SortkspaceButton.Position = [9 132 100 22];
            app.SortkspaceButton.Text = 'Sort k-space';

            % Create Lamp2
            app.Lamp2 = uilamp(app.ReconstructionPanel);
            app.Lamp2.Position = [121 133 20 20];
            app.Lamp2.Color = [1 0 0];

            % Create timeframesEditFieldLabel
            app.timeframesEditFieldLabel = uilabel(app.ReconstructionPanel);
            app.timeframesEditFieldLabel.HorizontalAlignment = 'right';
            app.timeframesEditFieldLabel.Position = [9 167 79 22];
            app.timeframesEditFieldLabel.Text = '# time frames';

            % Create TimeFramesEditField
            app.TimeFramesEditField = uieditfield(app.ReconstructionPanel, 'numeric');
            app.TimeFramesEditField.Limits = [1 200];
            app.TimeFramesEditField.ValueDisplayFormat = '%.0f';
            app.TimeFramesEditField.ValueChangedFcn = createCallbackFcn(app, @TimeFramesEditFieldValueChanged, true);
            app.TimeFramesEditField.Position = [108 167 45 22];
            app.TimeFramesEditField.Value = 1;

            % Create TVEditFieldLabel
            app.TVEditFieldLabel = uilabel(app.ReconstructionPanel);
            app.TVEditFieldLabel.HorizontalAlignment = 'right';
            app.TVEditFieldLabel.Position = [63 79 25 22];
            app.TVEditFieldLabel.Text = 'TV';

            % Create TVEditField
            app.TVEditField = uieditfield(app.ReconstructionPanel, 'numeric');
            app.TVEditField.ValueChangedFcn = createCallbackFcn(app, @TVEditFieldValueChanged, true);
            app.TVEditField.Position = [108 79 45 22];
            app.TVEditField.Value = 0.1;

            % Create WaveletEditFieldLabel
            app.WaveletEditFieldLabel = uilabel(app.ReconstructionPanel);
            app.WaveletEditFieldLabel.HorizontalAlignment = 'right';
            app.WaveletEditFieldLabel.Position = [40 52 48 22];
            app.WaveletEditFieldLabel.Text = 'Wavelet';

            % Create WaveletEditField
            app.WaveletEditField = uieditfield(app.ReconstructionPanel, 'numeric');
            app.WaveletEditField.ValueChangedFcn = createCallbackFcn(app, @TVEditFieldValueChanged, true);
            app.WaveletEditField.Position = [108 52 45 22];
            app.WaveletEditField.Value = 0.01;

            % Create SortProgressViewField
            app.SortProgressViewField = uieditfield(app.ReconstructionPanel, 'numeric');
            app.SortProgressViewField.Limits = [0 100];
            app.SortProgressViewField.ValueDisplayFormat = '%.0f';
            app.SortProgressViewField.Editable = 'off';
            app.SortProgressViewField.BackgroundColor = [0.9412 0.9412 0.9412];
            app.SortProgressViewField.Position = [152 132 32 22];

            % Create ExportdataPanel
            app.ExportdataPanel = uipanel(app.DashboardPanel);
            app.ExportdataPanel.AutoResizeChildren = 'off';
            app.ExportdataPanel.ForegroundColor = [0 0.4471 0.7412];
            app.ExportdataPanel.TitlePosition = 'centertop';
            app.ExportdataPanel.Title = 'Export data';
            app.ExportdataPanel.Position = [10 80 204 225];

            % Create ExportDicomButton
            app.ExportDicomButton = uibutton(app.ExportdataPanel, 'push');
            app.ExportDicomButton.ButtonPushedFcn = createCallbackFcn(app, @ExportDicomButtonPushed, true);
            app.ExportDicomButton.BackgroundColor = [0.8 0.8 0.8];
            app.ExportDicomButton.Enable = 'off';
            app.ExportDicomButton.Position = [9 158 100 22];
            app.ExportDicomButton.Text = 'Export Dicom';

            % Create ExportGifButton
            app.ExportGifButton = uibutton(app.ExportdataPanel, 'push');
            app.ExportGifButton.ButtonPushedFcn = createCallbackFcn(app, @ExportGifButtonPushed, true);
            app.ExportGifButton.BackgroundColor = [0.8 0.8 0.8];
            app.ExportGifButton.Enable = 'off';
            app.ExportGifButton.Position = [9 39 100 22];
            app.ExportGifButton.Text = 'Export Gif';

            % Create Lamp4
            app.Lamp4 = uilamp(app.ExportdataPanel);
            app.Lamp4.Position = [121 159 20 20];
            app.Lamp4.Color = [1 0 0];

            % Create Lamp6
            app.Lamp6 = uilamp(app.ExportdataPanel);
            app.Lamp6.Position = [121 40 20 20];
            app.Lamp6.Color = [1 0 0];

            % Create ExportNIFTIButton
            app.ExportNIFTIButton = uibutton(app.ExportdataPanel, 'push');
            app.ExportNIFTIButton.ButtonPushedFcn = createCallbackFcn(app, @ExportNIFTIButtonPushed, true);
            app.ExportNIFTIButton.BackgroundColor = [0.8 0.8 0.8];
            app.ExportNIFTIButton.Enable = 'off';
            app.ExportNIFTIButton.Position = [9 98 100 22];
            app.ExportNIFTIButton.Text = 'Export NIFTI';

            % Create Lamp5
            app.Lamp5 = uilamp(app.ExportdataPanel);
            app.Lamp5.Position = [121 99 20 20];
            app.Lamp5.Color = [1 0 0];

            % Create ExportProgressViewField
            app.ExportProgressViewField = uieditfield(app.ExportdataPanel, 'numeric');
            app.ExportProgressViewField.Limits = [0 100];
            app.ExportProgressViewField.ValueDisplayFormat = '%.0f';
            app.ExportProgressViewField.Editable = 'off';
            app.ExportProgressViewField.BackgroundColor = [0.9412 0.9412 0.9412];
            app.ExportProgressViewField.Position = [152 158 32 22];

            % Create Panel
            app.Panel = uipanel(app.DashboardPanel);
            app.Panel.AutoResizeChildren = 'off';
            app.Panel.Position = [11 17 203 46];

            % Create ExitButton
            app.ExitButton = uibutton(app.Panel, 'push');
            app.ExitButton.ButtonPushedFcn = createCallbackFcn(app, @ExitButtonPushed, true);
            app.ExitButton.BackgroundColor = [0.8 0.8 0.8];
            app.ExitButton.Position = [8 12 100 22];
            app.ExitButton.Text = 'Exit';

            % Create Label
            app.Label = uilabel(app.DashboardPanel);
            app.Label.Position = [198 238 25 22];
            app.Label.Text = '%';

            % Create Label_2
            app.Label_2 = uilabel(app.DashboardPanel);
            app.Label_2.Position = [197 457 25 22];
            app.Label_2.Text = '%';

            % Create KspaceImageDataPanel
            app.KspaceImageDataPanel = uipanel(app.Reco4DUIFigure);
            app.KspaceImageDataPanel.AutoResizeChildren = 'off';
            app.KspaceImageDataPanel.ForegroundColor = [0 0.4471 0.7412];
            app.KspaceImageDataPanel.TitlePosition = 'centertop';
            app.KspaceImageDataPanel.Title = 'Raw k-space data';
            app.KspaceImageDataPanel.FontWeight = 'bold';
            app.KspaceImageDataPanel.FontSize = 15;
            app.KspaceImageDataPanel.Position = [281 475 433 325];

            % Create kspaceselectionPanel
            app.kspaceselectionPanel = uipanel(app.KspaceImageDataPanel);
            app.kspaceselectionPanel.AutoResizeChildren = 'off';
            app.kspaceselectionPanel.ForegroundColor = [0 0.4471 0.7412];
            app.kspaceselectionPanel.TitlePosition = 'centertop';
            app.kspaceselectionPanel.Title = 'k-space selection';
            app.kspaceselectionPanel.Position = [278 9 139 265];

            % Create orientationLabel_2
            app.orientationLabel_2 = uilabel(app.kspaceselectionPanel);
            app.orientationLabel_2.HorizontalAlignment = 'right';
            app.orientationLabel_2.Position = [11 92 62 22];
            app.orientationLabel_2.Text = 'orientation';

            % Create KspaceOrientationSpinner
            app.KspaceOrientationSpinner = uispinner(app.kspaceselectionPanel);
            app.KspaceOrientationSpinner.Limits = [1 6];
            app.KspaceOrientationSpinner.ValueChangedFcn = createCallbackFcn(app, @KspaceOrientationSpinnerValueChanged, true);
            app.KspaceOrientationSpinner.HorizontalAlignment = 'center';
            app.KspaceOrientationSpinner.Position = [82 92 47 22];
            app.KspaceOrientationSpinner.Value = 1;

            % Create KspaceDim1EditField
            app.KspaceDim1EditField = uieditfield(app.kspaceselectionPanel, 'numeric');
            app.KspaceDim1EditField.Limits = [1 32];
            app.KspaceDim1EditField.ValueDisplayFormat = '%.0f';
            app.KspaceDim1EditField.ValueChangedFcn = createCallbackFcn(app, @KspaceDim1EditFieldValueChanged, true);
            app.KspaceDim1EditField.Position = [70 205 37 22];
            app.KspaceDim1EditField.Value = 1;

            % Create KspaceDim1Slider
            app.KspaceDim1Slider = uislider(app.kspaceselectionPanel);
            app.KspaceDim1Slider.Limits = [1 32];
            app.KspaceDim1Slider.MajorTicks = [];
            app.KspaceDim1Slider.ValueChangedFcn = createCallbackFcn(app, @KspaceDim1SliderValueChanged, true);
            app.KspaceDim1Slider.MinorTicks = [];
            app.KspaceDim1Slider.Position = [33 187 77 3];
            app.KspaceDim1Slider.Value = 1;

            % Create KspaceDim2EditField
            app.KspaceDim2EditField = uieditfield(app.kspaceselectionPanel, 'numeric');
            app.KspaceDim2EditField.Limits = [1 32];
            app.KspaceDim2EditField.ValueDisplayFormat = '%.0f';
            app.KspaceDim2EditField.ValueChangedFcn = createCallbackFcn(app, @KspaceDim2EditFieldValueChanged, true);
            app.KspaceDim2EditField.Position = [70 151 37 22];
            app.KspaceDim2EditField.Value = 1;

            % Create KspaceDim2Slider
            app.KspaceDim2Slider = uislider(app.kspaceselectionPanel);
            app.KspaceDim2Slider.Limits = [1 32];
            app.KspaceDim2Slider.MajorTicks = [];
            app.KspaceDim2Slider.ValueChangedFcn = createCallbackFcn(app, @KspaceDim2SliderValueChanged, true);
            app.KspaceDim2Slider.MinorTicks = [];
            app.KspaceDim2Slider.Position = [33 134 77 3];
            app.KspaceDim2Slider.Value = 1;

            % Create KspaceDim1Label
            app.KspaceDim1Label = uilabel(app.kspaceselectionPanel);
            app.KspaceDim1Label.Position = [26 205 36 22];
            app.KspaceDim1Label.Text = 'dim   ';

            % Create KspaceDim2Label
            app.KspaceDim2Label = uilabel(app.kspaceselectionPanel);
            app.KspaceDim2Label.Position = [26 151 39 22];
            app.KspaceDim2Label.Text = 'dim    ';

            % Create ButtonGroup
            app.ButtonGroup = uibuttongroup(app.kspaceselectionPanel);
            app.ButtonGroup.AutoResizeChildren = 'off';
            app.ButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @ButtonGroupSelectionChanged, true);
            app.ButtonGroup.BorderType = 'none';
            app.ButtonGroup.Position = [26 3 100 74];

            % Create fillingButton
            app.fillingButton = uiradiobutton(app.ButtonGroup);
            app.fillingButton.Text = 'filling';
            app.fillingButton.Position = [11 48 50 22];
            app.fillingButton.Value = true;

            % Create averagesButton
            app.averagesButton = uiradiobutton(app.ButtonGroup);
            app.averagesButton.Text = 'averages';
            app.averagesButton.Position = [11 26 71 22];

            % Create kvaluesButton
            app.kvaluesButton = uiradiobutton(app.ButtonGroup);
            app.kvaluesButton.Text = '| k-values |';
            app.kvaluesButton.Position = [11 4 79 22];

            % Create KyLabel
            app.KyLabel = uilabel(app.KspaceImageDataPanel);
            app.KyLabel.HorizontalAlignment = 'center';
            app.KyLabel.FontWeight = 'bold';
            app.KyLabel.Position = [6 148 25 22];
            app.KyLabel.Text = 'Ky';

            % Create KxLabel
            app.KxLabel = uilabel(app.KspaceImageDataPanel);
            app.KxLabel.HorizontalAlignment = 'center';
            app.KxLabel.FontWeight = 'bold';
            app.KxLabel.Position = [128.5 22 34 22];
            app.KxLabel.Text = '  Kx  ';

            % Create KspaceFig
            app.KspaceFig = uiaxes(app.KspaceImageDataPanel);
            title(app.KspaceFig, '')
            xlabel(app.KspaceFig, '')
            ylabel(app.KspaceFig, '')
            app.KspaceFig.FontSize = 1;
            app.KspaceFig.GridColor = [0.502 0.502 0.502];
            app.KspaceFig.MinorGridColor = [0.651 0.651 0.651];
            app.KspaceFig.Box = 'on';
            app.KspaceFig.XColor = [0.8 0.8 0.8];
            app.KspaceFig.XTick = [];
            app.KspaceFig.YColor = [0.8 0.8 0.8];
            app.KspaceFig.YTick = [];
            app.KspaceFig.Color = [0.902 0.902 0.902];
            app.KspaceFig.TitleFontWeight = 'normal';
            app.KspaceFig.Position = [31 44 230 230];

            % Create AcquisitionparametersPanel
            app.AcquisitionparametersPanel = uipanel(app.Reco4DUIFigure);
            app.AcquisitionparametersPanel.AutoResizeChildren = 'off';
            app.AcquisitionparametersPanel.ForegroundColor = [0 0.4471 0.7412];
            app.AcquisitionparametersPanel.TitlePosition = 'centertop';
            app.AcquisitionparametersPanel.Title = 'Acquisition parameters';
            app.AcquisitionparametersPanel.FontWeight = 'bold';
            app.AcquisitionparametersPanel.FontSize = 15;
            app.AcquisitionparametersPanel.Position = [281 186 433 275];

            % Create MatrixYViewField
            app.MatrixYViewField = uieditfield(app.AcquisitionparametersPanel, 'numeric');
            app.MatrixYViewField.Editable = 'off';
            app.MatrixYViewField.HorizontalAlignment = 'center';
            app.MatrixYViewField.Position = [120 186 40 22];

            % Create MatrixZViewField
            app.MatrixZViewField = uieditfield(app.AcquisitionparametersPanel, 'numeric');
            app.MatrixZViewField.Editable = 'off';
            app.MatrixZViewField.HorizontalAlignment = 'center';
            app.MatrixZViewField.Position = [166 186 40 22];

            % Create FOVYViewField
            app.FOVYViewField = uieditfield(app.AcquisitionparametersPanel, 'numeric');
            app.FOVYViewField.Editable = 'off';
            app.FOVYViewField.HorizontalAlignment = 'center';
            app.FOVYViewField.Position = [120 153 40 22];

            % Create FOVZViewField
            app.FOVZViewField = uieditfield(app.AcquisitionparametersPanel, 'numeric');
            app.FOVZViewField.Editable = 'off';
            app.FOVZViewField.HorizontalAlignment = 'center';
            app.FOVZViewField.Position = [166 153 40 22];

            % Create FOV1HViewFieldLabel
            app.FOV1HViewFieldLabel = uilabel(app.AcquisitionparametersPanel);
            app.FOV1HViewFieldLabel.HorizontalAlignment = 'right';
            app.FOV1HViewFieldLabel.Position = [36 153 29 22];
            app.FOV1HViewFieldLabel.Text = 'FOV';

            % Create FOVXViewField
            app.FOVXViewField = uieditfield(app.AcquisitionparametersPanel, 'numeric');
            app.FOVXViewField.Editable = 'off';
            app.FOVXViewField.HorizontalAlignment = 'center';
            app.FOVXViewField.Position = [74 153 40 22];

            % Create MatrixEditField_2Label
            app.MatrixEditField_2Label = uilabel(app.AcquisitionparametersPanel);
            app.MatrixEditField_2Label.HorizontalAlignment = 'right';
            app.MatrixEditField_2Label.Position = [26 186 39 22];
            app.MatrixEditField_2Label.Text = 'Matrix';

            % Create MatrixXViewField
            app.MatrixXViewField = uieditfield(app.AcquisitionparametersPanel, 'numeric');
            app.MatrixXViewField.Editable = 'off';
            app.MatrixXViewField.HorizontalAlignment = 'center';
            app.MatrixXViewField.Position = [74 186 40 22];

            % Create TRLabel
            app.TRLabel = uilabel(app.AcquisitionparametersPanel);
            app.TRLabel.HorizontalAlignment = 'right';
            app.TRLabel.Position = [40 120 25 22];
            app.TRLabel.Text = 'TR';

            % Create TRViewField
            app.TRViewField = uieditfield(app.AcquisitionparametersPanel, 'numeric');
            app.TRViewField.Limits = [0 Inf];
            app.TRViewField.RoundFractionalValues = 'on';
            app.TRViewField.Editable = 'off';
            app.TRViewField.HorizontalAlignment = 'center';
            app.TRViewField.Position = [74 120 40 22];
            app.TRViewField.Value = 1;

            % Create TELabel
            app.TELabel = uilabel(app.AcquisitionparametersPanel);
            app.TELabel.HorizontalAlignment = 'right';
            app.TELabel.Position = [40 86 25 22];
            app.TELabel.Text = 'TE';

            % Create TEViewField
            app.TEViewField = uieditfield(app.AcquisitionparametersPanel, 'numeric');
            app.TEViewField.Limits = [0 Inf];
            app.TEViewField.RoundFractionalValues = 'on';
            app.TEViewField.Editable = 'off';
            app.TEViewField.HorizontalAlignment = 'center';
            app.TEViewField.Position = [74 86 40 22];
            app.TEViewField.Value = 1;

            % Create alphaLabel
            app.alphaLabel = uilabel(app.AcquisitionparametersPanel);
            app.alphaLabel.HorizontalAlignment = 'right';
            app.alphaLabel.Position = [30 52 35 22];
            app.alphaLabel.Text = 'alpha';

            % Create AlphaViewField
            app.AlphaViewField = uieditfield(app.AcquisitionparametersPanel, 'numeric');
            app.AlphaViewField.Limits = [1 360];
            app.AlphaViewField.RoundFractionalValues = 'on';
            app.AlphaViewField.Editable = 'off';
            app.AlphaViewField.HorizontalAlignment = 'center';
            app.AlphaViewField.Position = [74 52 40 22];
            app.AlphaViewField.Value = 1;

            % Create repsLabel
            app.repsLabel = uilabel(app.AcquisitionparametersPanel);
            app.repsLabel.HorizontalAlignment = 'right';
            app.repsLabel.Position = [26 18 39 22];
            app.repsLabel.Text = '# reps';

            % Create NrRepsViewField
            app.NrRepsViewField = uieditfield(app.AcquisitionparametersPanel, 'numeric');
            app.NrRepsViewField.Limits = [1 360];
            app.NrRepsViewField.RoundFractionalValues = 'on';
            app.NrRepsViewField.Editable = 'off';
            app.NrRepsViewField.HorizontalAlignment = 'center';
            app.NrRepsViewField.Position = [74 18 40 22];
            app.NrRepsViewField.Value = 1;

            % Create kpointsLabel
            app.kpointsLabel = uilabel(app.AcquisitionparametersPanel);
            app.kpointsLabel.HorizontalAlignment = 'right';
            app.kpointsLabel.Position = [267 217 60 22];
            app.kpointsLabel.Text = '# k-points';

            % Create KlinesViewField
            app.KlinesViewField = uieditfield(app.AcquisitionparametersPanel, 'numeric');
            app.KlinesViewField.Limits = [1 Inf];
            app.KlinesViewField.RoundFractionalValues = 'on';
            app.KlinesViewField.ValueDisplayFormat = '%.0f';
            app.KlinesViewField.Editable = 'off';
            app.KlinesViewField.Position = [336 217 75 22];
            app.KlinesViewField.Value = 1;

            % Create kpointsrepLabel
            app.kpointsrepLabel = uilabel(app.AcquisitionparametersPanel);
            app.kpointsrepLabel.HorizontalAlignment = 'right';
            app.kpointsrepLabel.Position = [256 183 71 22];
            app.kpointsrepLabel.Text = 'k-points/rep';

            % Create KlinesRepViewField
            app.KlinesRepViewField = uieditfield(app.AcquisitionparametersPanel, 'numeric');
            app.KlinesRepViewField.Limits = [1 Inf];
            app.KlinesRepViewField.RoundFractionalValues = 'on';
            app.KlinesRepViewField.ValueDisplayFormat = '%.0f';
            app.KlinesRepViewField.Editable = 'off';
            app.KlinesRepViewField.Position = [336 183 75 22];
            app.KlinesRepViewField.Value = 1;

            % Create kpointsframeLabel
            app.kpointsframeLabel = uilabel(app.AcquisitionparametersPanel);
            app.kpointsframeLabel.HorizontalAlignment = 'right';
            app.kpointsframeLabel.Position = [243 150 84 22];
            app.kpointsframeLabel.Text = 'k-points/frame';

            % Create KlinesFrameViewField
            app.KlinesFrameViewField = uieditfield(app.AcquisitionparametersPanel, 'numeric');
            app.KlinesFrameViewField.Limits = [1 Inf];
            app.KlinesFrameViewField.RoundFractionalValues = 'on';
            app.KlinesFrameViewField.ValueDisplayFormat = '%.0f';
            app.KlinesFrameViewField.Editable = 'off';
            app.KlinesFrameViewField.Position = [336 150 75 22];
            app.KlinesFrameViewField.Value = 1;

            % Create kspacefillingLabel
            app.kspacefillingLabel = uilabel(app.AcquisitionparametersPanel);
            app.kspacefillingLabel.HorizontalAlignment = 'right';
            app.kspacefillingLabel.Position = [226 117 101 22];
            app.kspacefillingLabel.Text = 'k-space filling (%)';

            % Create FillingViewField
            app.FillingViewField = uieditfield(app.AcquisitionparametersPanel, 'numeric');
            app.FillingViewField.Limits = [0 100];
            app.FillingViewField.RoundFractionalValues = 'on';
            app.FillingViewField.ValueDisplayFormat = '%.0f';
            app.FillingViewField.Editable = 'off';
            app.FillingViewField.Position = [336 117 75 22];
            app.FillingViewField.Value = 100;

            % Create AcquisitiontimeEditFieldLabel
            app.AcquisitiontimeEditFieldLabel = uilabel(app.AcquisitionparametersPanel);
            app.AcquisitiontimeEditFieldLabel.HorizontalAlignment = 'right';
            app.AcquisitiontimeEditFieldLabel.Position = [236 84 91 22];
            app.AcquisitiontimeEditFieldLabel.Text = 'Acquisition time';

            % Create AcquisitionTimeViewField
            app.AcquisitionTimeViewField = uieditfield(app.AcquisitionparametersPanel, 'text');
            app.AcquisitionTimeViewField.Editable = 'off';
            app.AcquisitionTimeViewField.HorizontalAlignment = 'right';
            app.AcquisitionTimeViewField.Position = [336 84 75 22];

            % Create SequenceEditFieldLabel
            app.SequenceEditFieldLabel = uilabel(app.AcquisitionparametersPanel);
            app.SequenceEditFieldLabel.HorizontalAlignment = 'right';
            app.SequenceEditFieldLabel.Position = [7 217 60 22];
            app.SequenceEditFieldLabel.Text = 'Sequence';

            % Create SequenceViewField
            app.SequenceViewField = uieditfield(app.AcquisitionparametersPanel, 'text');
            app.SequenceViewField.Editable = 'off';
            app.SequenceViewField.Position = [74 217 132 22];

            % Create VersionLabel
            app.VersionLabel = uilabel(app.Reco4DUIFigure);
            app.VersionLabel.HorizontalAlignment = 'right';
            app.VersionLabel.FontSize = 15;
            app.VersionLabel.FontColor = [0 0.4471 0.7412];
            app.VersionLabel.Position = [950 10 403 22];
            app.VersionLabel.Text = 'Amsterdam UMC, Gustav Strijkers, Sept 2019, Version 1.0';

            % Create ReconstructionsPanel
            app.ReconstructionsPanel = uipanel(app.Reco4DUIFigure);
            app.ReconstructionsPanel.AutoResizeChildren = 'off';
            app.ReconstructionsPanel.ForegroundColor = [0 0.4471 0.7412];
            app.ReconstructionsPanel.TitlePosition = 'centertop';
            app.ReconstructionsPanel.Title = 'Reconstructions';
            app.ReconstructionsPanel.FontWeight = 'bold';
            app.ReconstructionsPanel.FontSize = 15;
            app.ReconstructionsPanel.Position = [734 41 619 759];

            % Create StaticPanel
            app.StaticPanel = uipanel(app.ReconstructionsPanel);
            app.StaticPanel.AutoResizeChildren = 'off';
            app.StaticPanel.ForegroundColor = [0 0.4471 0.7412];
            app.StaticPanel.BorderType = 'none';
            app.StaticPanel.TitlePosition = 'centertop';
            app.StaticPanel.Title = 'Static';
            app.StaticPanel.Position = [18 389 584 334];

            % Create ImageFig
            app.ImageFig = uiaxes(app.StaticPanel);
            title(app.ImageFig, '')
            xlabel(app.ImageFig, '')
            ylabel(app.ImageFig, '')
            app.ImageFig.FontSize = 1;
            app.ImageFig.GridColor = [0.502 0.502 0.502];
            app.ImageFig.MinorGridColor = [0.651 0.651 0.651];
            app.ImageFig.Box = 'on';
            app.ImageFig.XColor = [0.8 0.8 0.8];
            app.ImageFig.XTick = [];
            app.ImageFig.YColor = [0.8 0.8 0.8];
            app.ImageFig.YTick = [];
            app.ImageFig.Color = [0.902 0.902 0.902];
            app.ImageFig.TitleFontWeight = 'normal';
            app.ImageFig.Position = [64 8 300 300];

            % Create imageselectionPanel
            app.imageselectionPanel = uipanel(app.StaticPanel);
            app.imageselectionPanel.AutoResizeChildren = 'off';
            app.imageselectionPanel.ForegroundColor = [0 0.4471 0.7412];
            app.imageselectionPanel.TitlePosition = 'centertop';
            app.imageselectionPanel.Title = 'image selection';
            app.imageselectionPanel.Position = [409 63 139 224];

            % Create orientationLabel
            app.orientationLabel = uilabel(app.imageselectionPanel);
            app.orientationLabel.HorizontalAlignment = 'right';
            app.orientationLabel.Position = [14 52 62 22];
            app.orientationLabel.Text = 'orientation';

            % Create IOrientationSpinner
            app.IOrientationSpinner = uispinner(app.imageselectionPanel);
            app.IOrientationSpinner.Limits = [1 6];
            app.IOrientationSpinner.ValueChangedFcn = createCallbackFcn(app, @IOrientationSpinnerValueChanged, true);
            app.IOrientationSpinner.HorizontalAlignment = 'center';
            app.IOrientationSpinner.Position = [85 52 47 22];
            app.IOrientationSpinner.Value = 1;

            % Create IDim1EditField
            app.IDim1EditField = uieditfield(app.imageselectionPanel, 'numeric');
            app.IDim1EditField.Limits = [1 32];
            app.IDim1EditField.ValueDisplayFormat = '%.0f';
            app.IDim1EditField.ValueChangedFcn = createCallbackFcn(app, @IDim1EditFieldValueChanged, true);
            app.IDim1EditField.Position = [70 164 37 22];
            app.IDim1EditField.Value = 1;

            % Create IDim1Slider
            app.IDim1Slider = uislider(app.imageselectionPanel);
            app.IDim1Slider.Limits = [1 32];
            app.IDim1Slider.MajorTicks = [];
            app.IDim1Slider.ValueChangedFcn = createCallbackFcn(app, @IDim1SliderValueChanged, true);
            app.IDim1Slider.MinorTicks = [];
            app.IDim1Slider.Position = [33 146 77 3];
            app.IDim1Slider.Value = 1;

            % Create IDim2EditField
            app.IDim2EditField = uieditfield(app.imageselectionPanel, 'numeric');
            app.IDim2EditField.Limits = [1 32];
            app.IDim2EditField.ValueDisplayFormat = '%.0f';
            app.IDim2EditField.ValueChangedFcn = createCallbackFcn(app, @IDim2EditFieldValueChanged, true);
            app.IDim2EditField.Position = [75 111 37 22];
            app.IDim2EditField.Value = 1;

            % Create IDim2Slider
            app.IDim2Slider = uislider(app.imageselectionPanel);
            app.IDim2Slider.Limits = [1 32];
            app.IDim2Slider.MajorTicks = [];
            app.IDim2Slider.ValueChangedFcn = createCallbackFcn(app, @IDim2SliderValueChanged, true);
            app.IDim2Slider.MinorTicks = [];
            app.IDim2Slider.Position = [33 93 77 3];
            app.IDim2Slider.Value = 1;

            % Create dim1Label
            app.dim1Label = uilabel(app.imageselectionPanel);
            app.dim1Label.Position = [28 164 39 22];
            app.dim1Label.Text = 'dim    ';

            % Create dim2Label
            app.dim2Label = uilabel(app.imageselectionPanel);
            app.dim2Label.Position = [28 110 39 22];
            app.dim2Label.Text = 'dim    ';

            % Create YLabel
            app.YLabel = uilabel(app.StaticPanel);
            app.YLabel.HorizontalAlignment = 'center';
            app.YLabel.FontWeight = 'bold';
            app.YLabel.Position = [30 146 25 22];
            app.YLabel.Text = 'Y';

            % Create MoviePanel
            app.MoviePanel = uipanel(app.ReconstructionsPanel);
            app.MoviePanel.AutoResizeChildren = 'off';
            app.MoviePanel.ForegroundColor = [0 0.4471 0.7412];
            app.MoviePanel.BorderType = 'none';
            app.MoviePanel.TitlePosition = 'centertop';
            app.MoviePanel.Title = 'Movie';
            app.MoviePanel.Position = [18 8 584 354];

            % Create MovieFig
            app.MovieFig = uiaxes(app.MoviePanel);
            title(app.MovieFig, '')
            xlabel(app.MovieFig, '')
            ylabel(app.MovieFig, '')
            app.MovieFig.FontSize = 1;
            app.MovieFig.GridColor = [0.502 0.502 0.502];
            app.MovieFig.MinorGridColor = [0.651 0.651 0.651];
            app.MovieFig.Box = 'on';
            app.MovieFig.XColor = [0.8 0.8 0.8];
            app.MovieFig.XTick = [];
            app.MovieFig.YColor = [0.8 0.8 0.8];
            app.MovieFig.YTick = [];
            app.MovieFig.Color = [0.902 0.902 0.902];
            app.MovieFig.TitleFontWeight = 'normal';
            app.MovieFig.Position = [64 28 300 300];

            % Create moviecontrolsPanel
            app.moviecontrolsPanel = uipanel(app.MoviePanel);
            app.moviecontrolsPanel.AutoResizeChildren = 'off';
            app.moviecontrolsPanel.ForegroundColor = [0 0.4471 0.7412];
            app.moviecontrolsPanel.TitlePosition = 'centertop';
            app.moviecontrolsPanel.Title = 'movie controls';
            app.moviecontrolsPanel.Position = [409 69 139 237];

            % Create MDimEditField
            app.MDimEditField = uieditfield(app.moviecontrolsPanel, 'numeric');
            app.MDimEditField.Limits = [1 32];
            app.MDimEditField.ValueDisplayFormat = '%.0f';
            app.MDimEditField.ValueChangedFcn = createCallbackFcn(app, @MDimEditFieldValueChanged, true);
            app.MDimEditField.Position = [67 176 37 22];
            app.MDimEditField.Value = 1;

            % Create MDimSlider
            app.MDimSlider = uislider(app.moviecontrolsPanel);
            app.MDimSlider.Limits = [1 32];
            app.MDimSlider.MajorTicks = [];
            app.MDimSlider.ValueChangedFcn = createCallbackFcn(app, @MDimSliderValueChanged, true);
            app.MDimSlider.MinorTicks = [];
            app.MDimSlider.Position = [30 158 77 3];
            app.MDimSlider.Value = 1;

            % Create MDimLabel
            app.MDimLabel = uilabel(app.moviecontrolsPanel);
            app.MDimLabel.Position = [25 176 39 22];
            app.MDimLabel.Text = 'dim    ';

            % Create orientationLabel_3
            app.orientationLabel_3 = uilabel(app.moviecontrolsPanel);
            app.orientationLabel_3.HorizontalAlignment = 'right';
            app.orientationLabel_3.Position = [10 115 62 22];
            app.orientationLabel_3.Text = 'orientation';

            % Create MOrientationSpinner
            app.MOrientationSpinner = uispinner(app.moviecontrolsPanel);
            app.MOrientationSpinner.Limits = [1 3];
            app.MOrientationSpinner.ValueChangedFcn = createCallbackFcn(app, @MOrientationSpinnerValueChanged, true);
            app.MOrientationSpinner.HorizontalAlignment = 'center';
            app.MOrientationSpinner.Position = [81 115 47 22];
            app.MOrientationSpinner.Value = 1;

            % Create PlayButton
            app.PlayButton = uibutton(app.moviecontrolsPanel, 'push');
            app.PlayButton.ButtonPushedFcn = createCallbackFcn(app, @PlayButtonPushed, true);
            app.PlayButton.Position = [19 62 100 22];
            app.PlayButton.Text = 'Play';

            % Create StopButton
            app.StopButton = uibutton(app.moviecontrolsPanel, 'push');
            app.StopButton.ButtonPushedFcn = createCallbackFcn(app, @StopButtonPushed, true);
            app.StopButton.Position = [20 27 100 22];
            app.StopButton.Text = 'Stop';

            % Create MXLabel
            app.MXLabel = uilabel(app.MoviePanel);
            app.MXLabel.HorizontalAlignment = 'center';
            app.MXLabel.FontWeight = 'bold';
            app.MXLabel.Position = [197 10 34 22];
            app.MXLabel.Text = '   X   ';

            % Create MYLabel
            app.MYLabel = uilabel(app.MoviePanel);
            app.MYLabel.HorizontalAlignment = 'center';
            app.MYLabel.FontWeight = 'bold';
            app.MYLabel.Position = [30 167 25 22];
            app.MYLabel.Text = 'Y';

            % Create XLabel
            app.XLabel = uilabel(app.ReconstructionsPanel);
            app.XLabel.HorizontalAlignment = 'center';
            app.XLabel.FontWeight = 'bold';
            app.XLabel.Position = [214 378 34 22];
            app.XLabel.Text = '   X   ';

            % Create TitlePanel
            app.TitlePanel = uilabel(app.Reco4DUIFigure);
            app.TitlePanel.HorizontalAlignment = 'center';
            app.TitlePanel.FontSize = 26;
            app.TitlePanel.FontWeight = 'bold';
            app.TitlePanel.FontColor = [0 0.4471 0.7412];
            app.TitlePanel.Position = [552 822 276 34];
            app.TitlePanel.Text = '4D MRI reconstructor';

            % Create AmsterdamUMCImage
            app.AmsterdamUMCImage = uiimage(app.Reco4DUIFigure);
            app.AmsterdamUMCImage.Position = [1298 812 63 54];
            app.AmsterdamUMCImage.ImageSource = 'AmsterdamUMC.gif';

            % Create MessagesPanel
            app.MessagesPanel = uipanel(app.Reco4DUIFigure);
            app.MessagesPanel.AutoResizeChildren = 'off';
            app.MessagesPanel.ForegroundColor = [0 0.4471 0.7412];
            app.MessagesPanel.TitlePosition = 'centertop';
            app.MessagesPanel.Title = 'Messages';
            app.MessagesPanel.FontWeight = 'bold';
            app.MessagesPanel.FontSize = 15;
            app.MessagesPanel.Position = [281 41 433 133];

            % Create MessageBox
            app.MessageBox = uitextarea(app.MessagesPanel);
            app.MessageBox.Editable = 'off';
            app.MessageBox.FontColor = [0.502 0.502 0.502];
            app.MessageBox.Position = [16 8 400 94];

            % Show the figure after all components are created
            app.Reco4DUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Reco4D_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.Reco4DUIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.Reco4DUIFigure)
        end
    end
end