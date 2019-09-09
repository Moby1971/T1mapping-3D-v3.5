classdef T2map_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        T2mapUIFigure              matlab.ui.Figure
        DashboardPanel             matlab.ui.container.Panel
        LoadMRDfileButton          matlab.ui.control.Button
        Lamp1                      matlab.ui.control.Lamp
        RecoButton                 matlab.ui.control.Button
        Lamp2                      matlab.ui.control.Lamp
        ThresholdButton            matlab.ui.control.Button
        Lamp4                      matlab.ui.control.Lamp
        FitButton                  matlab.ui.control.Button
        Lamp5                      matlab.ui.control.Lamp
        FitProgressGauge           matlab.ui.control.LinearGauge
        Lamp6                      matlab.ui.control.Lamp
        ExitButton                 matlab.ui.control.Button
        ExportDicomButton          matlab.ui.control.Button
        FitrangePanel              matlab.ui.container.Panel
        FirstsliceLabel            matlab.ui.control.Label
        FirstSliceEditField        matlab.ui.control.NumericEditField
        LastsliceLabel             matlab.ui.control.Label
        LastSliceEditField         matlab.ui.control.NumericEditField
        FitProgressLabel           matlab.ui.control.Label
        Lamp7                      matlab.ui.control.Lamp
        ExportGifButton            matlab.ui.control.Button
        AbortFitButton             matlab.ui.control.Button
        RegistrationButton         matlab.ui.control.Button
        Lamp3                      matlab.ui.control.Lamp
        RegProgressGauge           matlab.ui.control.LinearGauge
        RegProgressLabel           matlab.ui.control.Label
        DmultisliceT2mappingLabel  matlab.ui.control.Label
        RawImageDataPanel          matlab.ui.container.Panel
        ImageLabel                 matlab.ui.control.Label
        ImageselectorPanel         matlab.ui.container.Panel
        SlicesSlider               matlab.ui.control.Slider
        EchoesSlider               matlab.ui.control.Slider
        SliceEditFieldLabel        matlab.ui.control.Label
        SlicesEditField            matlab.ui.control.NumericEditField
        EchoEditFieldLabel         matlab.ui.control.Label
        EchoesEditField            matlab.ui.control.NumericEditField
        SegmentationPanel          matlab.ui.container.Panel
        ThresholdSlider            matlab.ui.control.Slider
        ErodeButton                matlab.ui.control.Button
        DilateButton               matlab.ui.control.Button
        CloseButton                matlab.ui.control.Button
        OpenButton                 matlab.ui.control.Button
        ThresholdEditFieldLabel    matlab.ui.control.Label
        ThresholdEditField         matlab.ui.control.NumericEditField
        ImageIntensityPanel        matlab.ui.container.Panel
        ScaleSliderLabel           matlab.ui.control.Label
        ScaleSlider                matlab.ui.control.Slider
        SquareBackground1          matlab.ui.control.Image
        RawDataFig                 matlab.ui.control.UIAxes
        SequenceParametersPanel    matlab.ui.container.Panel
        TRmsEditFieldLabel         matlab.ui.control.Label
        TRViewField                matlab.ui.control.NumericEditField
        TEmsEditFieldLabel         matlab.ui.control.Label
        TEViewField                matlab.ui.control.NumericEditField
        dimxEditFieldLabel         matlab.ui.control.Label
        dimxViewField              matlab.ui.control.NumericEditField
        dimyEditFieldLabel         matlab.ui.control.Label
        dimyViewField              matlab.ui.control.NumericEditField
        SlicesEditFieldLabel       matlab.ui.control.Label
        SlicesViewField            matlab.ui.control.NumericEditField
        EchoesLabel                matlab.ui.control.Label
        EchoesViewField            matlab.ui.control.NumericEditField
        FOVmmEditFieldLabel        matlab.ui.control.Label
        FOVViewField               matlab.ui.control.NumericEditField
        SlicethicknessmmLabel      matlab.ui.control.Label
        SLTViewField               matlab.ui.control.NumericEditField
        AspectratioLabel           matlab.ui.control.Label
        AspectRatioViewField       matlab.ui.control.NumericEditField
        DatafileEditFieldLabel     matlab.ui.control.Label
        DatafileEditField          matlab.ui.control.EditField
        FitResultsPanel            matlab.ui.container.Panel
        T2MapLabel                 matlab.ui.control.Label
        M0MapLabel                 matlab.ui.control.Label
        ImageSelectorPanel         matlab.ui.container.Panel
        T2MapSlicesSlider          matlab.ui.control.Slider
        SliceEditField_2Label      matlab.ui.control.Label
        T2MapSlicesEditField       matlab.ui.control.NumericEditField
        ColorMapButtonGroup        matlab.ui.container.ButtonGroup
        grayButton                 matlab.ui.control.RadioButton
        autumnButton               matlab.ui.control.RadioButton
        winterButton               matlab.ui.control.RadioButton
        parulaButton               matlab.ui.control.RadioButton
        hotButton                  matlab.ui.control.RadioButton
        T2ScaleEditField           matlab.ui.control.NumericEditField
        T2ScaleMaxLabel            matlab.ui.control.Label
        T2ScaleAutoButton          matlab.ui.control.Button
        SquareBackground2          matlab.ui.control.Image
        T2MapFig                   matlab.ui.control.UIAxes
        SquareBackground3          matlab.ui.control.Image
        M0MapFig                   matlab.ui.control.UIAxes
        Version11Aug2019GustavStrijkersAmsterdamUMCLabel  matlab.ui.control.Label
        TulpLogo                   matlab.ui.control.Image
    end

    
    
    %% --------------------------------------------------------------------------------------
    %
    %   T2 mapping tool
    %   MEMS data
    %
    %   Gustav Strijkers
    %   Amsterdam UMC
    %   August 2019
    %
    %
    %
    %   Version 1.0
    %   - intial version
    %
    %   Version 1.1
    %   - Bug fixes
    %   - Added image registration option
    %
    %
    %
    %% --------------------------------------------------------------------------------------
    
    
    
    
    properties (Access = public)
        
        bart_detected               % BART available true or false
        mrd_import_path             % Dicom import path
        dicom_export_path           % Dicom export path
        gif_export_path             % gif export path
        datafile                    % raw data file
        data                        % raw k-space data
        dimensions                  % image dimensions
        parameters                  % image paramters
        ne                          % number of echoes
        dimx                        % nr points readout
        dimy                        % nt points phase encoding
        fov                         % field of view
        aspectratio                 % field of view ratio
        sl                          % slice thickness
        ns                          % number of slices
        tr                          % repetition time
        te                          % echo time / spacing
        tes                         % all echo times
        images                      % reconstructed raw images (ne, ns, dimx, dimy)
        threshold                   % segmentation threshold (ns,1)
        mask                        % binary image with segmentation (ns, dimx, dimy)
        scalefactor                 % image intensity scale factor
        t2map                       % resulting t2map (ns, dimx, dimy)
        t2cmap                      % T2 color mapping
        m0map                       % resulting m0map (ns, dimx, dimy)
        abortfit                    % abort fit false or true
        tag                         % file tag for export of dicom files
        
    end
    
    
    methods (Access = private)
        
        
        function PlotRawImages(app)
        % Displays the mask in the raw image data
            
            cla(app.RawDataFig);
            hold(app.RawDataFig,'on');
            
            % Define the colormap
            % Since it is not possible to have 2 colormaps in 1 figure, the
            % colormap is split in a grayscale part [0 1] and a red-color overlay part [1 2]
            cmap1 = 1.5*app.scalefactor*[linspace(0,1,128)',linspace(0,1,128)',linspace(0,1,128)'];
            cmap2 = [linspace(0,1,128)', zeros(128,2)];
            cmap = [cmap1;cmap2];
            cmap(cmap > 1) = 1;
                        
            % Background anatomy image
            scale = max(squeeze(app.images(1,app.SlicesEditField.Value,:)));
            app.RawDataFig.Position = [22,70,325,325];
            [dx,dy] = size(squeeze(app.images(app.EchoesEditField.Value,app.SlicesEditField.Value,:,:)));
            xlim(app.RawDataFig,[1,dx]);
            ylim(app.RawDataFig,[1,dy]);
            background = imshow(squeeze(app.images(app.EchoesEditField.Value,app.SlicesEditField.Value,:,:))/scale,[0,2],'Colormap',cmap,'InitialMagnification','fit','Parent',app.RawDataFig);
            
            % Overlay image with the mask
            overlay = imshow(squeeze(2-app.mask(app.SlicesEditField.Value,:,:)),[0 2],'Colormap',cmap,'InitialMagnification','fit','Parent',app.RawDataFig);
            alpha = squeeze(0.7-0.7*app.mask(app.SlicesEditField.Value,:,:));
            set(overlay,'AlphaData',alpha);
            
            % Image aspect ratio
            daspect(app.RawDataFig,[app.AspectRatioViewField.Value 1 1]);
            
            hold(app.RawDataFig,'off');
            drawnow;
            
            % Set some limits now
            
            app.ThresholdEditField.Limits = [0 max(app.images(1,app.SlicesEditField.Value,:))];
            app.ThresholdEditField.Value = app.threshold(app.SlicesEditField.Value);                                                                       
            app.ThresholdSlider.Limits = [0 max(app.images(1,app.SlicesEditField.Value,:))];
            app.ThresholdSlider.Value = app.threshold(app.SlicesEditField.Value);
                        
        end % PlotRawImages
        
        
        
        function PlotT2map(app)
        % Plots the T2 map for the current slice
            
            cla(app.T2MapFig);
            hold(app.T2MapFig,'on');
            hold(app.M0MapFig,'on');
            
            % Plot the T2 map
            app.T2MapFig.Position = [20,383,325,325];
            [dx,dy] = size(squeeze(app.t2map(app.T2MapSlicesEditField.Value,:,:)));
            xlim(app.T2MapFig,[1,dx]);
            ylim(app.T2MapFig,[1,dy]);
            imshow(squeeze(app.t2map(app.T2MapSlicesEditField.Value,:,:)),[0 app.T2ScaleEditField.Value],'Colormap',app.t2cmap,'InitialMagnification','fit','Parent',app.T2MapFig);
            daspect(app.T2MapFig,[app.AspectRatioViewField.Value 1 1]);
            colorbar(app.T2MapFig,'east','Ticks',[]);
            
            % Estimate a suitable scale for the M0 map
            m0scale = round(2*mean(nonzeros(squeeze(app.m0map(app.T2MapSlicesEditField.Value,:)))));
            if isnan(m0scale) m0scale = 100; end
            
            % Plot the M0 map
            app.M0MapFig.Position = [20,24,325,325];
            [dx,dy] = size(squeeze(app.m0map(app.T2MapSlicesEditField.Value,:,:)));
            xlim(app.M0MapFig,[1,dx]);
            ylim(app.M0MapFig,[1,dy]);
            imshow(squeeze(app.m0map(app.T2MapSlicesEditField.Value,:,:)),[0 m0scale],'InitialMagnification','fit','Parent',app.M0MapFig);
            daspect(app.M0MapFig,[app.AspectRatioViewField.Value 1 1]);
            
            hold(app.T2MapFig,'off');
            hold(app.M0MapFig,'off');
            drawnow;
            
        end % PlotT2map
        
        
        
        function SetParameters(app)
        % Sets global parameters    
            
            % sequence parameters
            app.ne = app.parameters.NO_ECHOES;
            app.dimx = app.parameters.NO_SAMPLES;
            app.dimy = app.parameters.NO_VIEWS;
            app.fov = app.parameters.FOV;
            app.ns = app.parameters.NO_SLICES;
            app.tr = app.parameters.tr;
            app.te = app.parameters.te;
            app.sl = app.parameters.SLICE_THICKNESS;
            app.tes = app.te * linspace(1,app.ne,app.ne)'; % echo times
            
            % show parameters & set limits
            app.TRViewField.Value = app.tr;
            app.TEViewField.Value = app.te;
            app.EchoesViewField.Value = app.ne;
            app.dimxViewField.Value = app.dimx;
            app.dimyViewField.Value = app.dimy;
            app.SlicesViewField.Value = app.ns;
            app.SlicesEditField.Limits = [1, app.ns];
            app.SlicesSlider.Limits = [1, app.ns];
            app.T2MapSlicesEditField.Limits = [1, app.ns];
            app.T2MapSlicesSlider.Limits = [1, app.ns];
            app.EchoesViewField.Value = app.ne;
            app.EchoesEditField.Limits = [1, app.ne];
            app.EchoesSlider.Limits = [1, app.ne];
            app.SLTViewField.Value = app.sl;
            app.FOVViewField.Value = app.fov;
            app.AspectRatioViewField.Value = app.parameters.SMX/app.parameters.SMY;
            app.t2cmap = gray; 
            app.FirstSliceEditField.Value = 1;
            app.LastSliceEditField.Value = app.ns;
            app.FirstSliceEditField.Limits = [1 app.ns];
            app.LastSliceEditField.Limits = [1 app.ns];
            app.abortfit = false;
            
            % other parameters
            app.scalefactor = 1;
            app.ScaleSlider.Value = app.scalefactor;
            [~,app.tag,~] = fileparts(app.datafile);
            
            % define empty m0 and t2map
            app.m0map = zeros(app.ns,app.dimx,app.dimy);
            app.t2map = zeros(app.ns,app.dimx,app.dimy);
            
            % define mask initially with ones
            app.mask = ones(app.ns,app.dimx,app.dimy);
            
            % reset treshold values
            app.threshold = zeros(1,app.ns);
            
        end % SetParameters
    
    
    end % methods
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function StartupFcn(app)
            
            % main window noname
            app.T2mapUIFigure.Name = '';
            
            % start the parallel pool if it is not running already
            p = gcp('nocreate');
            if isempty(p) 
                parpool; 
            end
            
            % empty file import and export paths
            app.mrd_import_path = '';
            app.dicom_export_path = '';
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
            
            % disable unnecessary warnings
            warning off;
            
            % set buttons
            app.Lamp1.Color = 'Red';
            app.Lamp2.Color = 'Red';
            app.Lamp3.Color = 'Red';
            app.Lamp4.Color = 'Red';
            app.Lamp5.Color = 'Red';
            app.Lamp6.Color = 'Red';
            app.Lamp7.Color = 'Red';
            
            app.LoadMRDfileButton.Enable = 'on';
            app.RecoButton.Enable = 'off';
            app.ThresholdButton.Enable = 'off';
            app.RegistrationButton.Enable = 'off';
            app.FitButton.Enable = 'off';
            app.ExportDicomButton.Enable = 'off';
            app.ExportGifButton.Enable = 'off';
            app.ExitButton.Enable = 'on';
            
            app.FirstSliceEditField.Enable = 'off';
            app.LastSliceEditField.Enable = 'off';
            app.AbortFitButton.Enable = 'off';
            app.SlicesEditField.Enable = 'off';
            app.SlicesSlider.Enable = 'off';
            app.EchoesEditField.Enable = 'off';
            app.EchoesSlider.Enable = 'off';
            app.ScaleSlider.Enable = 'off';
            app.ThresholdEditField.Enable = 'off';
            app.ThresholdSlider.Enable = 'off';
            app.ErodeButton.Enable = 'off';
            app.DilateButton.Enable = 'off';
            app.CloseButton.Enable = 'off';
            app.OpenButton.Enable = 'off';
            app.T2MapSlicesEditField.Enable = 'off';
            app.T2MapSlicesSlider.Enable = 'off';
            app.T2ScaleEditField.Enable = 'off';
            app.T2ScaleAutoButton.Enable = 'off';
            app.grayButton.Enable = 'off';
            app.autumnButton.Enable = 'off';
            app.winterButton.Enable = 'off';
            app.parulaButton.Enable = 'off';
            app.hotButton.Enable = 'off';
            
            drawnow;
        
        end

        % Button pushed function: LoadMRDfileButton
        function LoadMRDfileButtonPushed(app, event)
            
        % Load the T2 data file
        
            % Indicate busy
            app.Lamp1.Color = 'Yellow';
            app.Lamp2.Color = 'Red';
            app.Lamp3.Color = 'Red';
            app.Lamp4.Color = 'Red';
            app.Lamp5.Color = 'Red';
            app.Lamp6.Color = 'Red';
            app.Lamp7.Color = 'Red';
            
            app.LoadMRDfileButton.Enable = 'off';
            app.RecoButton.Enable = 'off';
            app.RegistrationButton.Enable = 'off';
            app.ThresholdButton.Enable = 'off';
            app.FitButton.Enable = 'off';
            app.ExportDicomButton.Enable = 'off';
            app.ExportGifButton.Enable = 'off';
            app.ExitButton.Enable = 'off';
            
            app.FirstSliceEditField.Enable = 'off';
            app.LastSliceEditField.Enable = 'off';
            app.AbortFitButton.Enable = 'off';
            app.SlicesEditField.Enable = 'off';
            app.SlicesSlider.Enable = 'off';
            app.EchoesEditField.Enable = 'off';
            app.EchoesSlider.Enable = 'off';
            app.ScaleSlider.Enable = 'off';
            app.ThresholdEditField.Enable = 'off';
            app.ThresholdSlider.Enable = 'off';
            app.ErodeButton.Enable = 'off';
            app.DilateButton.Enable = 'off';
            app.CloseButton.Enable = 'off';
            app.OpenButton.Enable = 'off';
            app.T2MapSlicesEditField.Enable = 'off';
            app.T2MapSlicesSlider.Enable = 'off';
            app.T2ScaleEditField.Enable = 'off';
            app.T2ScaleAutoButton.Enable = 'off';
            app.grayButton.Enable = 'off';
            app.autumnButton.Enable = 'off';
            app.winterButton.Enable = 'off';
            app.parulaButton.Enable = 'off';
            app.hotButton.Enable = 'off';
            
            drawnow;
        
            % Select a MRD file
            app.T2mapUIFigure.Visible = 'off';
            [mrdfile,app.mrd_import_path] = uigetfile([app.mrd_import_path,'*.MRD']);
            app.T2mapUIFigure.Visible = 'on';
            
            validfile = false;
            
            if ischar(mrdfile)
                % MRD file selected
                app.datafile = [app.mrd_import_path,mrdfile];
                
                % Load the data
                [app.data,app.dimensions,app.parameters] = Get_mrd_3D4(app.datafile,'seq','cen');
                
                % valid file
                if app.parameters.NO_ECHOES > 1
                    validfile = true;
                    app.DatafileEditField.Value = mrdfile;
                    SetParameters(app);
                end
            end
                
            if validfile
                % reset buttons
                app.Lamp1.Color = 'Green';
                app.Lamp2.Color = 'Red';
                app.Lamp3.Color = 'Red';
                app.Lamp4.Color = 'Red';
                app.Lamp5.Color = 'Red';
                app.Lamp6.Color = 'Red';
                app.Lamp7.Color = 'Red';
                
                app.LoadMRDfileButton.Enable = 'on';
                app.RecoButton.Enable = 'on';
                app.RegistrationButton.Enable = 'off';
                app.ThresholdButton.Enable = 'off';
                app.FitButton.Enable = 'off';
                app.ExportDicomButton.Enable = 'off';
                app.ExportGifButton.Enable = 'off';
                app.ExitButton.Enable = 'on';
                  
                drawnow;
            else                
                % not a valid MRD file with navigator
                f = app.T2mapUIFigure;
                uialert(f,'Please select a valid MRD file','Error');
                app.mrd_import_path = '';
                app.LoadMRDfileButton.Enable = 'on';
                app.Lamp1.Color = 'Red';
            end
            
        end

        % Button pushed function: RecoButton
        function RecoButtonPushed(app, event)
            
                % Indicate busy
                app.Lamp1.Color = 'Green';
                app.Lamp2.Color = 'Yellow';
                app.Lamp3.Color = 'Red';
                app.Lamp4.Color = 'Red';
                app.Lamp5.Color = 'Red';
                app.Lamp6.Color = 'Red';
                app.Lamp7.Color = 'Red';
                
                app.LoadMRDfileButton.Enable = 'off';
                app.RecoButton.Enable = 'off';
                app.RegistrationButton.Enable = 'off';
                app.ThresholdButton.Enable = 'off';
                app.FitButton.Enable = 'off';
                app.ExportDicomButton.Enable = 'off';
                app.ExportGifButton.Enable = 'off';
                app.ExitButton.Enable = 'off';
                    
                app.FirstSliceEditField.Enable = 'off';
                app.LastSliceEditField.Enable = 'off';
                app.AbortFitButton.Enable = 'off';
                app.SlicesEditField.Enable = 'off';
                app.SlicesSlider.Enable = 'off';
                app.EchoesEditField.Enable = 'off';
                app.EchoesSlider.Enable = 'off';
                app.ScaleSlider.Enable = 'off';
                app.ThresholdEditField.Enable = 'off';
                app.ThresholdSlider.Enable = 'off';
                app.ErodeButton.Enable = 'off';
                app.DilateButton.Enable = 'off';
                app.CloseButton.Enable = 'off';
                app.OpenButton.Enable = 'off';
                app.T2MapSlicesEditField.Enable = 'off';
                app.T2MapSlicesSlider.Enable = 'off';
                app.T2ScaleEditField.Enable = 'off';
                app.T2ScaleAutoButton.Enable = 'off';
                app.grayButton.Enable = 'off';
                app.autumnButton.Enable = 'off';
                app.winterButton.Enable = 'off';
                app.parulaButton.Enable = 'off';
                app.hotButton.Enable = 'off';
                
                drawnow;
        
                % reset some parameters
                app.scalefactor = 1;
                app.ScaleSlider.Value = app.scalefactor; 
                app.SlicesEditField.Value = 1;
                app.SlicesSlider.Value = 1;
                app.EchoesEditField.Value = 1;
                app.EchoesSlider.Value = 1;
                app.ThresholdEditField.Value = 1;
                app.ThresholdSlider.Value = 1;
                app.T2MapSlicesEditField.Value = 1;
                app.T2MapSlicesSlider.Value = 1;
                
                % reset m0 and t2map
                app.m0map = zeros(app.ns,app.dimx,app.dimy);
                app.t2map = zeros(app.ns,app.dimx,app.dimy);
                
                % reconstruct the raw image data
                if app.bart_detected 
                    % reco with bart toolbox
                    % no real advantage of using Bart toolbox here, but
                    % maybe in the future with undersampling k-space
                    app.images = reco_t2(app.data,app.dimx,app.dimy,app.ns,app.ne);
                else
                    % reco with matlab fft
                    for i=1:app.ne
                        for j=1:app.ns
                            app.images(i,j,:,:) = rot90((abs(fft2reco(squeeze(app.data(i,j,:,:))))),2);
                        end
                    end
                end
                
                % normalize to convenient range
                app.images = round(16384*app.images/max(app.images(:)));
                
                % Show the image
                PlotRawImages(app);
                PlotT2map(app);
                
                % Reset buttons
                app.Lamp1.Color = 'Green';
                app.Lamp2.Color = 'Green';
                app.Lamp3.Color = 'Red';
                app.Lamp4.Color = 'Red';
                app.Lamp5.Color = 'Red';
                app.Lamp6.Color = 'Red';
                app.Lamp7.Color = 'Red';
                
                app.LoadMRDfileButton.Enable = 'on';
                app.RecoButton.Enable = 'on';
                app.RegistrationButton.Enable = 'on';
                app.ThresholdButton.Enable = 'on';
                app.FitButton.Enable = 'off';
                app.ExportDicomButton.Enable = 'off';
                app.ExportGifButton.Enable = 'off';
                app.ExitButton.Enable = 'on';
                    
                app.SlicesEditField.Enable = 'on';
                app.SlicesSlider.Enable = 'on';
                app.EchoesEditField.Enable = 'on';
                app.EchoesSlider.Enable = 'on';
                app.ScaleSlider.Enable = 'on';
                
                drawnow;
                
        end

        % Value changed function: EchoesEditField, SlicesEditField
        function SlicesEditFieldValueChanged(app, event)
            
            % Adjust the slider
            app.SlicesSlider.Value = app.SlicesEditField.Value;
            app.EchoesSlider.Value = app.EchoesEditField.Value;
        
            % Plot the raw image 
            PlotRawImages(app);
            
        end

        % Value changed function: SlicesSlider
        function SlicesSliderValueChanged(app, event)
            
            % Adjust the slices edit field value
            app.SlicesEditField.Value = round(app.SlicesSlider.Value);
            
            % Continue with the changed slices edit field callback
            SlicesEditFieldValueChanged(app, event)
            
        end

        % Value changed function: EchoesSlider
        function EchoesSliderValueChanged(app, event)
            
            % Adjust the echoes edit field value
            app.EchoesEditField.Value = round(app.EchoesSlider.Value);
            
            % Continue with the changed slices / echoes edit field callback
            SlicesEditFieldValueChanged(app, event)
            
        end

        % Value changed function: ScaleSlider
        function ScaleSliderValueChanged(app, event)
            
                % change the image intensity scale
                app.scalefactor = app.ScaleSlider.Value;
            
                % replot the images
                PlotRawImages(app)
            
        end

        % Button pushed function: RegistrationButton
        function RegistrationButtonPushed(app, event)
            
            % Indicate busy
            app.Lamp1.Color = 'Green';
            app.Lamp2.Color = 'Green';
            app.Lamp3.Color = 'Yellow';
            app.Lamp4.Color = 'Red';
            app.Lamp5.Color = 'Red';
            app.Lamp6.Color = 'Red';
            app.Lamp7.Color = 'Red';
            
            app.LoadMRDfileButton.Enable = 'off';
            app.RecoButton.Enable = 'off';
            app.RegistrationButton.Enable = 'off';
            app.ThresholdButton.Enable = 'off';
            app.FitButton.Enable = 'off';
            app.ExportDicomButton.Enable = 'off';
            app.ExportGifButton.Enable = 'off';
            app.ExitButton.Enable = 'off';
            
            app.FirstSliceEditField.Enable = 'off';
            app.LastSliceEditField.Enable = 'off';
            app.AbortFitButton.Enable = 'off';
            app.SlicesEditField.Enable = 'off';
            app.SlicesSlider.Enable = 'off';
            app.EchoesEditField.Enable = 'off';
            app.EchoesSlider.Enable = 'off';
            app.ScaleSlider.Enable = 'off';
            app.ThresholdEditField.Enable = 'off';
            app.ThresholdSlider.Enable = 'off';
            app.ErodeButton.Enable = 'off';
            app.DilateButton.Enable = 'off';
            app.CloseButton.Enable = 'off';
            app.OpenButton.Enable = 'off';
            app.T2MapSlicesEditField.Enable = 'off';
            app.T2MapSlicesSlider.Enable = 'off';
            app.T2ScaleEditField.Enable = 'off';
            app.T2ScaleAutoButton.Enable = 'off';
            app.grayButton.Enable = 'off';
            app.autumnButton.Enable = 'off';
            app.winterButton.Enable = 'off';
            app.parulaButton.Enable = 'off';
            app.hotButton.Enable = 'off';
            
            drawnow;
        
            % Initialize progress gauge
            app.RegProgressGauge.Value = 0;
            
            % Register all slices to 1st echo time image
            app.images = register_images(app,app.images);
            
            % replot the images
            PlotRawImages(app);
            
            % Reset buttons
            app.Lamp1.Color = 'Green';
            app.Lamp2.Color = 'Green';
            app.Lamp3.Color = 'Green';
            app.Lamp4.Color = 'Red';
            app.Lamp5.Color = 'Red';
            app.Lamp6.Color = 'Red';
            app.Lamp7.Color = 'Red';
            
            app.LoadMRDfileButton.Enable = 'on';
            app.RecoButton.Enable = 'on';
            app.RegistrationButton.Enable = 'on';
            app.ThresholdButton.Enable = 'on';
            app.FitButton.Enable = 'off';
            app.ExportDicomButton.Enable = 'off';
            app.ExportGifButton.Enable = 'off';
            app.ExitButton.Enable = 'on';
            
            app.FirstSliceEditField.Enable = 'on';
            app.LastSliceEditField.Enable = 'on';
            app.AbortFitButton.Enable = 'on';
            app.SlicesEditField.Enable = 'on';
            app.SlicesSlider.Enable = 'on';
            app.EchoesEditField.Enable = 'on';
            app.EchoesSlider.Enable = 'on';
            app.ScaleSlider.Enable = 'on';
            app.ThresholdEditField.Enable = 'on';
            app.ThresholdSlider.Enable = 'on';
            app.ErodeButton.Enable = 'on';
            app.DilateButton.Enable = 'on';
            app.CloseButton.Enable = 'on';
            app.OpenButton.Enable = 'on';
            
            drawnow;
               
        end

        % Button pushed function: ThresholdButton
        function ThresholdButtonPushed(app, event)
            
            % Indicate busy
            app.Lamp1.Color = 'Green';
            app.Lamp2.Color = 'Green';
            app.Lamp4.Color = 'Yellow';
            app.Lamp5.Color = 'Red';
            app.Lamp6.Color = 'Red';
            app.Lamp7.Color = 'Red';
            
            app.LoadMRDfileButton.Enable = 'off';
            app.RecoButton.Enable = 'off';
            app.RegistrationButton.Enable = 'off';
            app.ThresholdButton.Enable = 'off';
            app.FitButton.Enable = 'off';
            app.ExportDicomButton.Enable = 'off';
            app.ExportGifButton.Enable = 'off';
            app.ExitButton.Enable = 'off';
            
            app.FirstSliceEditField.Enable = 'off';
            app.LastSliceEditField.Enable = 'off';
            app.AbortFitButton.Enable = 'off';
            app.SlicesEditField.Enable = 'off';
            app.SlicesSlider.Enable = 'off';
            app.EchoesEditField.Enable = 'off';
            app.EchoesSlider.Enable = 'off';
            app.ScaleSlider.Enable = 'off';
            app.ThresholdEditField.Enable = 'off';
            app.ThresholdSlider.Enable = 'off';
            app.ErodeButton.Enable = 'off';
            app.DilateButton.Enable = 'off';
            app.CloseButton.Enable = 'off';
            app.OpenButton.Enable = 'off';
            app.T2MapSlicesEditField.Enable = 'off';
            app.T2MapSlicesSlider.Enable = 'off';
            app.T2ScaleEditField.Enable = 'off';
            app.T2ScaleAutoButton.Enable = 'off';
            app.grayButton.Enable = 'off';
            app.autumnButton.Enable = 'off';
            app.winterButton.Enable = 'off';
            app.parulaButton.Enable = 'off';
            app.hotButton.Enable = 'off';
            
            drawnow;
        
            % Determine automatic threshold using the Otsu method for each slice
            for i=1:app.ns
                app.threshold(i) = graythresh(mat2gray(app.images(1,i,:,:))) * max(squeeze(app.images(1,i,:)));
            end
            
            % Set the automatic mask for all slices
            for i=1:app.ns
                app.mask(i,:,:) = apply_threshold_t2(squeeze(app.images(1,i,:,:)),app.threshold(i));
            end
            
            % Display the threshold value for the current slice
            app.ThresholdEditField.Value = app.threshold(app.SlicesEditField.Value);
            
            % Display the mask in the image
            PlotRawImages(app);
            
            % Reset buttons
            app.Lamp1.Color = 'Green';
            app.Lamp2.Color = 'Green';
            app.Lamp4.Color = 'Green';
            app.Lamp5.Color = 'Red';
            app.Lamp6.Color = 'Red';
            app.Lamp7.Color = 'Red';
            
            app.LoadMRDfileButton.Enable = 'on';
            app.RecoButton.Enable = 'on';
            app.RegistrationButton.Enable = 'on';
            app.ThresholdButton.Enable = 'on';
            app.FitButton.Enable = 'on';
            app.ExportDicomButton.Enable = 'off';
            app.ExportGifButton.Enable = 'off';
            app.ExitButton.Enable = 'on';
            
            app.FirstSliceEditField.Enable = 'on';
            app.LastSliceEditField.Enable = 'on';
            app.AbortFitButton.Enable = 'on';
            app.SlicesEditField.Enable = 'on';
            app.SlicesSlider.Enable = 'on';
            app.EchoesEditField.Enable = 'on';
            app.EchoesSlider.Enable = 'on';
            app.ScaleSlider.Enable = 'on';
            app.ThresholdEditField.Enable = 'on';
            app.ThresholdSlider.Enable = 'on';
            app.ErodeButton.Enable = 'on';
            app.DilateButton.Enable = 'on';
            app.CloseButton.Enable = 'on';
            app.OpenButton.Enable = 'on';
            
            drawnow;
            
        end

        % Value changed function: ThresholdEditField
        function ThresholdEditFieldValueChanged(app, event)
            
                % Get the current slice
                cslice = app.SlicesEditField.Value;
        
                % Change the value of the threshold for this slice and update the slider
                app.threshold(cslice) = app.ThresholdEditField.Value;
                app.ThresholdSlider.Value = app.ThresholdEditField.Value;
                
                % Apply the new threshold
                app.mask(cslice,:,:) = apply_threshold_t2(squeeze(app.images(1,cslice,:,:)),app.threshold(cslice));
                
                % Display the result;
                PlotRawImages(app)
                
        end

        % Value changed function: ThresholdSlider
        function ThresholdSliderValueChanged(app, event)
            
                % Threshold slider changed
                % Adjust Threshold and call threshold change button
                app.ThresholdEditField.Value = app.ThresholdSlider.Value;
                ThresholdEditFieldValueChanged(app, event);
            
        end

        % Button pushed function: ErodeButton
        function ErodeButtonPushed(app, event)
            
            % Morphological erosion on current slice
            app.mask(app.SlicesEditField.Value,:,:) = 1-imerode(1-squeeze(app.mask(app.SlicesEditField.Value,:,:)),[0 1 0; 1 1 1; 0 1 0]);
            
            % Display the result;
            PlotRawImages(app);
        
        end

        % Button pushed function: DilateButton
        function DilateButtonPushed(app, event)
        
            % Morphological dilation on current slice
            app.mask(app.SlicesEditField.Value,:,:) = 1-imdilate(1-squeeze(app.mask(app.SlicesEditField.Value,:,:)),[0 1 0; 1 1 1; 0 1 0]);
            
            % Display the result;
            PlotRawImages(app);
            
        end

        % Button pushed function: CloseButton
        function CloseButtonPushed(app, event)
            
            % Morphological dilation on current slice
            app.mask(app.SlicesEditField.Value,:,:) = 1-imclose(1-squeeze(app.mask(app.SlicesEditField.Value,:,:)),[0 1 0; 1 1 1; 0 1 0]);
            
            % Display the result;
            PlotRawImages(app);
            
        end

        % Button pushed function: OpenButton
        function OpenButtonPushed(app, event)
            
            % Morphological dilation on current slice
            app.mask(app.SlicesEditField.Value,:,:) = 1-imopen(1-squeeze(app.mask(app.SlicesEditField.Value,:,:)),[0 1 0; 1 1 1; 0 1 0]);
            
            % Display the result;
            PlotRawImages(app);
            
        end

        % Button pushed function: FitButton
        function FitButtonPushed(app, event)
            
            % Indicate busy
            app.Lamp1.Color = 'Green';
            app.Lamp2.Color = 'Green';
            app.Lamp4.Color = 'Green';
            app.Lamp5.Color = 'Yellow';
            app.Lamp6.Color = 'Red';
            app.Lamp7.Color = 'Red';
            
            app.LoadMRDfileButton.Enable = 'off';
            app.RecoButton.Enable = 'off';
            app.RegistrationButton.Enable = 'off';
            app.ThresholdButton.Enable = 'off';
            app.FitButton.Enable = 'off';
            app.ExportDicomButton.Enable = 'off';
            app.ExportGifButton.Enable = 'off';
            app.ExitButton.Enable = 'off';
            
            app.FirstSliceEditField.Enable = 'off';
            app.LastSliceEditField.Enable = 'off';
            app.AbortFitButton.Enable = 'on';
            app.SlicesEditField.Enable = 'on';
            app.SlicesSlider.Enable = 'on';
            app.EchoesEditField.Enable = 'on';
            app.EchoesSlider.Enable = 'on';
            app.ScaleSlider.Enable = 'on';
            app.ThresholdEditField.Enable = 'off';
            app.ThresholdSlider.Enable = 'off';
            app.ErodeButton.Enable = 'off';
            app.DilateButton.Enable = 'off';
            app.CloseButton.Enable = 'off';
            app.OpenButton.Enable = 'off';
            app.T2MapSlicesEditField.Enable = 'on';
            app.T2MapSlicesSlider.Enable = 'on';
            app.T2ScaleEditField.Enable = 'on';
            app.T2ScaleAutoButton.Enable = 'on';
            app.grayButton.Enable = 'on';
            app.autumnButton.Enable = 'on';
            app.winterButton.Enable = 'on';
            app.parulaButton.Enable = 'on';
            app.hotButton.Enable = 'on';
            
            drawnow;
            
            app.abortfit = false;
            
            % for selected slices
            for i=app.FirstSliceEditField.Value:app.LastSliceEditField.Value   
                
                % for all y-coordinates
                for k=1:app.dimy
                    
                    % Stop if abort button is pressed
                    if app.abortfit == true 
                        break; 
                    end
                    
                    % do the fit for all coordinates, parallel accelerated
                    [app.m0map(i,:,k),app.t2map(i,:,k)] = dotheT2fit_xdim(squeeze(app.images(:,i,:,k)), squeeze(app.mask(i,:,k)), app.tes);
                    
                    % Update progress Gauge
                    if mod(k,8)==0
                        app.FitProgressGauge.Value = round(100*((i-app.FirstSliceEditField.Value)*app.dimy+k)/((app.LastSliceEditField.Value-app.FirstSliceEditField.Value+1)*app.dimy));
                        drawnow;
                    end
                    
                    % Plot the slice and T2-map
                    if mod(k,32)==0
                        
                        % Plot Raw images current slice
                        PlotRawImages(app);
                        
                        % Plot T2 map thus far with auto scale
                        % Auto-scale = 2 x mean of the T2 values in the image
                        scale = round(2*mean(nonzeros(squeeze(app.t2map(app.T2MapSlicesEditField.Value,:)))));
                        if isnan(scale) scale = 100; end
                        app.T2ScaleEditField.Value = scale;
                        PlotT2map(app);
                        
                    end
                    
                end
                
            end
            
            % Reset buttons
            app.Lamp1.Color = 'Green';
            app.Lamp2.Color = 'Green';
            app.Lamp4.Color = 'Green';
            app.Lamp5.Color = 'Green';
            app.Lamp6.Color = 'Red';
            app.Lamp7.Color = 'Red';
            
            app.LoadMRDfileButton.Enable = 'on';
            app.RecoButton.Enable = 'on';
            app.RegistrationButton.Enable = 'on';
            app.ThresholdButton.Enable = 'on';
            app.FitButton.Enable = 'on';
            app.ExportDicomButton.Enable = 'on';
            app.ExportGifButton.Enable = 'on';
            app.ExitButton.Enable = 'on';
            
            app.FirstSliceEditField.Enable = 'on';
            app.LastSliceEditField.Enable = 'on';
            app.AbortFitButton.Enable = 'on';
            app.SlicesEditField.Enable = 'on';
            app.SlicesSlider.Enable = 'on';
            app.EchoesEditField.Enable = 'on';
            app.EchoesSlider.Enable = 'on';
            app.ScaleSlider.Enable = 'on';
            app.ThresholdEditField.Enable = 'on';
            app.ThresholdSlider.Enable = 'on';
            app.ErodeButton.Enable = 'on';
            app.DilateButton.Enable = 'on';
            app.CloseButton.Enable = 'on';
            app.OpenButton.Enable = 'on';
            app.T2MapSlicesEditField.Enable = 'on';
            app.T2MapSlicesSlider.Enable = 'on';
            app.T2ScaleEditField.Enable = 'on';
            app.T2ScaleAutoButton.Enable = 'on';
            app.grayButton.Enable = 'on';
            app.autumnButton.Enable = 'on';
            app.winterButton.Enable = 'on';
            app.parulaButton.Enable = 'on';
            app.hotButton.Enable = 'on';
            
            drawnow;
         
        end

        % Button pushed function: AbortFitButton
        function AbortFitButtonPushed(app, event)
            
            app.abortfit = true; 
        
        end

        % Value changed function: FirstSliceEditField, 
        % LastSliceEditField
        function FirstSliceEditFieldValueChanged(app, event)
            
            if app.FirstSliceEditField.Value > app.LastSliceEditField.Value
                app.LastSliceEditField.Value = app.FirstSliceEditField.Value;
            end
            
        end

        % Value changed function: T2MapSlicesEditField
        function T2MapSlicesEditFieldValueChanged(app, event)
            
            % Plot the T2-map for the new slice
            PlotT2map(app);
            
        end

        % Value changed function: T2MapSlicesSlider
        function T2MapSlicesSliderValueChanged(app, event)
            
                % Change the Slice nr value according to the slider
                app.T2MapSlicesEditField.Value = round(app.T2MapSlicesSlider.Value);
            
                % Continue as if T2 map slice value was changed
                T2MapSlicesEditFieldValueChanged(app, event);
            
        end

        % Value changed function: T2ScaleEditField
        function T2ScaleEditFieldValueChanged(app, event)
            
                % Plot the T2 map with the new scale
                PlotT2map(app);
            
        end

        % Button pushed function: T2ScaleAutoButton
        function T2ScaleAutoButtonPushed(app, event)
            
            % Estimate a suitable scale for the T2 map
            % Auto-scale = 2 x mean of the T2 values in the image
            scale = round(2*mean(nonzeros(squeeze(app.t2map(app.T2MapSlicesEditField.Value,:))))); 
            if isnan(scale) scale = 100; end
            app.T2ScaleEditField.Value = scale;
            
            % Plot the map
            PlotT2map(app);
            
        end

        % Selection changed function: ColorMapButtonGroup
        function ColorMapButtonGroupSelectionChanged2(app, event)
            
            if app.grayButton.Value == 1 
                app.t2cmap = gray; 
            end
            
            if app.autumnButton.Value == 1
                app.t2cmap = autumn; 
            end
            
            if app.winterButton.Value == 1
                app.t2cmap = winter; 
            end
            
            if app.parulaButton.Value == 1
                app.t2cmap = parula; 
            end
            
            if app.hotButton.Value == 1
                app.t2cmap = hot; 
            end
            
            % Background should always be black
            app.t2cmap(1,:) = [0 0 0];
            
            % Plot the T2 map with the new colormap
            PlotT2map(app);
            
        end

        % Button pushed function: ExportDicomButton
        function ExportDicomButtonPushed(app, event)
            
            % Indicate busy
            app.Lamp6.Color = 'Yellow';
            
            app.LoadMRDfileButton.Enable = 'off';
            app.RecoButton.Enable = 'off';
            app.RegistrationButton.Enable = 'off';
            app.ThresholdButton.Enable = 'off';
            app.FitButton.Enable = 'off';
            app.ExportDicomButton.Enable = 'off';
            app.ExportGifButton.Enable = 'off';
            app.ExitButton.Enable = 'off';
            
            app.FirstSliceEditField.Enable = 'off';
            app.LastSliceEditField.Enable = 'off';
            app.AbortFitButton.Enable = 'off';
            app.SlicesEditField.Enable = 'off';
            app.SlicesSlider.Enable = 'off';
            app.EchoesEditField.Enable = 'off';
            app.EchoesSlider.Enable = 'off';
            app.ScaleSlider.Enable = 'off';
            app.ThresholdEditField.Enable = 'off';
            app.ThresholdSlider.Enable = 'off';
            app.ErodeButton.Enable = 'off';
            app.DilateButton.Enable = 'off';
            app.CloseButton.Enable = 'off';
            app.OpenButton.Enable = 'off';
            app.T2MapSlicesEditField.Enable = 'off';
            app.T2MapSlicesSlider.Enable = 'off';
            app.T2ScaleEditField.Enable = 'off';
            app.T2ScaleAutoButton.Enable = 'off';
            app.grayButton.Enable = 'off';
            app.autumnButton.Enable = 'off';
            app.winterButton.Enable = 'off';
            app.parulaButton.Enable = 'off';
            app.hotButton.Enable = 'off';
            
            drawnow;
        
            % Ask for dicom export directory
            app.T2mapUIFigure.Visible = 'off';
            app.dicom_export_path = uigetdir(app.dicom_export_path,'Dicom export path'); 
            app.T2mapUIFigure.Visible = 'on';
            drawnow;
            
            % Check if directory exists
            ready = true;
            if ~ischar(app.dicom_export_path)     % user cancel
                ready = false;
                app.dicom_export_path = '';
            else
                [~, Attrib] = fileattrib(app.dicom_export_path);
                if ~any(Attrib.UserWrite)       % check if directory is writable
                    ready = false;
                end
            end
            
            % Export to dicom if directory is valid and can be written
            if ready
                export_dicom_t2(app.dicom_export_path,app.m0map,app.t2map,app.parameters,app.tag);
                app.Lamp6.Color = 'Green';
            else
                f = app.T2mapUIFigure;
                uialert(f,'Not a valid directory','Error');   
                app.Lamp6.Color = 'Red';
            end
            
            % Reset buttons
            app.LoadMRDfileButton.Enable = 'on';
            app.RecoButton.Enable = 'on';
            app.RegistrationButton.Enable = 'on';
            app.ThresholdButton.Enable = 'on';
            app.FitButton.Enable = 'on';
            app.ExportDicomButton.Enable = 'on';
            app.ExportGifButton.Enable = 'on';
            app.ExitButton.Enable = 'on';
            
            app.FirstSliceEditField.Enable = 'on';
            app.LastSliceEditField.Enable = 'on';
            app.AbortFitButton.Enable = 'on';
            app.SlicesEditField.Enable = 'on';
            app.SlicesSlider.Enable = 'on';
            app.EchoesEditField.Enable = 'on';
            app.EchoesSlider.Enable = 'on';
            app.ScaleSlider.Enable = 'on';
            app.ThresholdEditField.Enable = 'on';
            app.ThresholdSlider.Enable = 'on';
            app.ErodeButton.Enable = 'on';
            app.DilateButton.Enable = 'on';
            app.CloseButton.Enable = 'on';
            app.OpenButton.Enable = 'on';
            app.T2MapSlicesEditField.Enable = 'on';
            app.T2MapSlicesSlider.Enable = 'on';
            app.T2ScaleEditField.Enable = 'on';
            app.T2ScaleAutoButton.Enable = 'on';
            app.grayButton.Enable = 'on';
            app.autumnButton.Enable = 'on';
            app.winterButton.Enable = 'on';
            app.parulaButton.Enable = 'on';
            app.hotButton.Enable = 'on';
            
            drawnow;
        
        end

        % Button pushed function: ExportGifButton
        function ExportGifButtonPushed(app, event)
            
            % Indicate busy
            app.Lamp7.Color = 'Green';
        
            app.LoadMRDfileButton.Enable = 'off';
            app.RecoButton.Enable = 'off';
            app.RegistrationButton.Enable = 'off';
            app.ThresholdButton.Enable = 'off';
            app.FitButton.Enable = 'off';
            app.ExportDicomButton.Enable = 'off';
            app.ExportGifButton.Enable = 'off';
            app.ExitButton.Enable = 'off';
             
            app.FirstSliceEditField.Enable = 'off';
            app.LastSliceEditField.Enable = 'off';
            app.AbortFitButton.Enable = 'off';
            app.SlicesEditField.Enable = 'off';
            app.SlicesSlider.Enable = 'off';
            app.EchoesEditField.Enable = 'off';
            app.EchoesSlider.Enable = 'off';
            app.ScaleSlider.Enable = 'off';
            app.ThresholdEditField.Enable = 'off';
            app.ThresholdSlider.Enable = 'off';
            app.ErodeButton.Enable = 'off';
            app.DilateButton.Enable = 'off';
            app.CloseButton.Enable = 'off';
            app.OpenButton.Enable = 'off';
            app.T2MapSlicesEditField.Enable = 'off';
            app.T2MapSlicesSlider.Enable = 'off';
            app.T2ScaleEditField.Enable = 'off';
            app.T2ScaleAutoButton.Enable = 'off';
            app.grayButton.Enable = 'off';
            app.autumnButton.Enable = 'off';
            app.winterButton.Enable = 'off';
            app.parulaButton.Enable = 'off';
            app.hotButton.Enable = 'off';
            
            drawnow;        
            
            % Ask for directory
            app.T2mapUIFigure.Visible = 'off';
            app.gif_export_path = uigetdir(app.gif_export_path,'GIF export path');
            app.T2mapUIFigure.Visible = 'on';
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
                export_gif_t2(app.gif_export_path,app.t2map,app.m0map,app.tag,app.T2ScaleEditField.Value,app.t2cmap,app.AspectRatioViewField.Value);
                app.Lamp7.Color = 'Green';
            else
                f = app.T2mapUIFigure;
                uialert(f,'Not a valid directory','Error');
                app.Lamp7.Color = 'Red';
            end
            
            % Reset remaining buttons
            
            app.LoadMRDfileButton.Enable = 'on';
            app.RecoButton.Enable = 'on';
            app.RegistrationButton.Enable = 'on';
            app.ThresholdButton.Enable = 'on';
            app.FitButton.Enable = 'on';
            app.ExportDicomButton.Enable = 'on';
            app.ExportGifButton.Enable = 'on';
            app.ExitButton.Enable = 'on';
            
            app.FirstSliceEditField.Enable = 'on';
            app.LastSliceEditField.Enable = 'on';
            app.AbortFitButton.Enable = 'on';
            app.SlicesEditField.Enable = 'on';
            app.SlicesSlider.Enable = 'on';
            app.EchoesEditField.Enable = 'on';
            app.EchoesSlider.Enable = 'on';
            app.ScaleSlider.Enable = 'on';
            app.ThresholdEditField.Enable = 'on';
            app.ThresholdSlider.Enable = 'on';
            app.ErodeButton.Enable = 'on';
            app.DilateButton.Enable = 'on';
            app.CloseButton.Enable = 'on';
            app.OpenButton.Enable = 'on';
            app.T2MapSlicesEditField.Enable = 'on';
            app.T2MapSlicesSlider.Enable = 'on';
            app.T2ScaleEditField.Enable = 'on';
            app.T2ScaleAutoButton.Enable = 'on';
            app.grayButton.Enable = 'on';
            app.autumnButton.Enable = 'on';
            app.winterButton.Enable = 'on';
            app.parulaButton.Enable = 'on';
            app.hotButton.Enable = 'on';
            
            drawnow;
        
        end

        % Button pushed function: ExitButton
        function ExitButtonPushed(app, event)
            
            % Exit
            app.delete;
        
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create T2mapUIFigure and hide until all components are created
            app.T2mapUIFigure = uifigure('Visible', 'off');
            app.T2mapUIFigure.Color = [0.9412 0.9412 0.9412];
            app.T2mapUIFigure.Position = [100 100 1380 875];
            app.T2mapUIFigure.Name = 'UI Figure';

            % Create DashboardPanel
            app.DashboardPanel = uipanel(app.T2mapUIFigure);
            app.DashboardPanel.ForegroundColor = [0 0.4471 0.7412];
            app.DashboardPanel.TitlePosition = 'centertop';
            app.DashboardPanel.Title = 'Dashboard';
            app.DashboardPanel.FontWeight = 'bold';
            app.DashboardPanel.FontSize = 15;
            app.DashboardPanel.Position = [34 40 234 763];

            % Create LoadMRDfileButton
            app.LoadMRDfileButton = uibutton(app.DashboardPanel, 'push');
            app.LoadMRDfileButton.ButtonPushedFcn = createCallbackFcn(app, @LoadMRDfileButtonPushed, true);
            app.LoadMRDfileButton.BackgroundColor = [0.8 0.8 0.8];
            app.LoadMRDfileButton.Position = [19 697 100 22];
            app.LoadMRDfileButton.Text = 'Load MRD';

            % Create Lamp1
            app.Lamp1 = uilamp(app.DashboardPanel);
            app.Lamp1.Position = [147 698 20 20];
            app.Lamp1.Color = [1 0 0];

            % Create RecoButton
            app.RecoButton = uibutton(app.DashboardPanel, 'push');
            app.RecoButton.ButtonPushedFcn = createCallbackFcn(app, @RecoButtonPushed, true);
            app.RecoButton.BackgroundColor = [0.8 0.8 0.8];
            app.RecoButton.Position = [19 635 100 22];
            app.RecoButton.Text = 'Reco';

            % Create Lamp2
            app.Lamp2 = uilamp(app.DashboardPanel);
            app.Lamp2.Position = [147 636 20 20];
            app.Lamp2.Color = [1 0 0];

            % Create ThresholdButton
            app.ThresholdButton = uibutton(app.DashboardPanel, 'push');
            app.ThresholdButton.ButtonPushedFcn = createCallbackFcn(app, @ThresholdButtonPushed, true);
            app.ThresholdButton.BackgroundColor = [0.8 0.8 0.8];
            app.ThresholdButton.Position = [19 446 100 22];
            app.ThresholdButton.Text = 'Threshold';

            % Create Lamp4
            app.Lamp4 = uilamp(app.DashboardPanel);
            app.Lamp4.Position = [147 447 20 20];
            app.Lamp4.Color = [1 0 0];

            % Create FitButton
            app.FitButton = uibutton(app.DashboardPanel, 'push');
            app.FitButton.ButtonPushedFcn = createCallbackFcn(app, @FitButtonPushed, true);
            app.FitButton.BackgroundColor = [0.8 0.8 0.8];
            app.FitButton.Position = [19 220 100 22];
            app.FitButton.Text = 'Fit';

            % Create Lamp5
            app.Lamp5 = uilamp(app.DashboardPanel);
            app.Lamp5.Position = [147 221 20 20];
            app.Lamp5.Color = [1 0 0];

            % Create FitProgressGauge
            app.FitProgressGauge = uigauge(app.DashboardPanel, 'linear');
            app.FitProgressGauge.MajorTicks = [0 25 50 75 100];
            app.FitProgressGauge.Orientation = 'vertical';
            app.FitProgressGauge.Position = [184 284 38 113];

            % Create Lamp6
            app.Lamp6 = uilamp(app.DashboardPanel);
            app.Lamp6.Position = [147 139 20 20];
            app.Lamp6.Color = [1 0 0];

            % Create ExitButton
            app.ExitButton = uibutton(app.DashboardPanel, 'push');
            app.ExitButton.ButtonPushedFcn = createCallbackFcn(app, @ExitButtonPushed, true);
            app.ExitButton.BackgroundColor = [0.8 0.8 0.8];
            app.ExitButton.Position = [19 21 100 22];
            app.ExitButton.Text = 'Exit';

            % Create ExportDicomButton
            app.ExportDicomButton = uibutton(app.DashboardPanel, 'push');
            app.ExportDicomButton.ButtonPushedFcn = createCallbackFcn(app, @ExportDicomButtonPushed, true);
            app.ExportDicomButton.BackgroundColor = [0.8 0.8 0.8];
            app.ExportDicomButton.Position = [19 138 100 22];
            app.ExportDicomButton.Text = 'Export Dicom';

            % Create FitrangePanel
            app.FitrangePanel = uipanel(app.DashboardPanel);
            app.FitrangePanel.ForegroundColor = [0 0.4471 0.7412];
            app.FitrangePanel.Title = 'Fit range';
            app.FitrangePanel.Position = [17 284 150 113];

            % Create FirstsliceLabel
            app.FirstsliceLabel = uilabel(app.FitrangePanel);
            app.FirstsliceLabel.HorizontalAlignment = 'right';
            app.FirstsliceLabel.Position = [7 53 56 22];
            app.FirstsliceLabel.Text = 'First slice';

            % Create FirstSliceEditField
            app.FirstSliceEditField = uieditfield(app.FitrangePanel, 'numeric');
            app.FirstSliceEditField.Limits = [1 200];
            app.FirstSliceEditField.ValueChangedFcn = createCallbackFcn(app, @FirstSliceEditFieldValueChanged, true);
            app.FirstSliceEditField.Position = [78 53 35 22];
            app.FirstSliceEditField.Value = 1;

            % Create LastsliceLabel
            app.LastsliceLabel = uilabel(app.FitrangePanel);
            app.LastsliceLabel.HorizontalAlignment = 'right';
            app.LastsliceLabel.Position = [7 21 56 22];
            app.LastsliceLabel.Text = 'Last slice';

            % Create LastSliceEditField
            app.LastSliceEditField = uieditfield(app.FitrangePanel, 'numeric');
            app.LastSliceEditField.Limits = [1 200];
            app.LastSliceEditField.ValueChangedFcn = createCallbackFcn(app, @FirstSliceEditFieldValueChanged, true);
            app.LastSliceEditField.Position = [78 21 35 22];
            app.LastSliceEditField.Value = 1;

            % Create FitProgressLabel
            app.FitProgressLabel = uilabel(app.DashboardPanel);
            app.FitProgressLabel.HorizontalAlignment = 'center';
            app.FitProgressLabel.FontColor = [0 0.4471 0.7412];
            app.FitProgressLabel.Position = [177 400 53 22];
            app.FitProgressLabel.Text = 'Progress';

            % Create Lamp7
            app.Lamp7 = uilamp(app.DashboardPanel);
            app.Lamp7.Position = [147 94 20 20];
            app.Lamp7.Color = [1 0 0];

            % Create ExportGifButton
            app.ExportGifButton = uibutton(app.DashboardPanel, 'push');
            app.ExportGifButton.ButtonPushedFcn = createCallbackFcn(app, @ExportGifButtonPushed, true);
            app.ExportGifButton.BackgroundColor = [0.8 0.8 0.8];
            app.ExportGifButton.Position = [19 93 100 22];
            app.ExportGifButton.Text = 'Export Gif';

            % Create AbortFitButton
            app.AbortFitButton = uibutton(app.DashboardPanel, 'push');
            app.AbortFitButton.ButtonPushedFcn = createCallbackFcn(app, @AbortFitButtonPushed, true);
            app.AbortFitButton.FontSize = 11;
            app.AbortFitButton.Position = [181 220 46 22];
            app.AbortFitButton.Text = 'Abort';

            % Create RegistrationButton
            app.RegistrationButton = uibutton(app.DashboardPanel, 'push');
            app.RegistrationButton.ButtonPushedFcn = createCallbackFcn(app, @RegistrationButtonPushed, true);
            app.RegistrationButton.BackgroundColor = [0.8 0.8 0.8];
            app.RegistrationButton.Position = [19 541 100 22];
            app.RegistrationButton.Text = 'Registration';

            % Create Lamp3
            app.Lamp3 = uilamp(app.DashboardPanel);
            app.Lamp3.Position = [147 542 20 20];
            app.Lamp3.Color = [1 0 0];

            % Create RegProgressGauge
            app.RegProgressGauge = uigauge(app.DashboardPanel, 'linear');
            app.RegProgressGauge.MajorTicks = [0 25 50 75 100];
            app.RegProgressGauge.Orientation = 'vertical';
            app.RegProgressGauge.Position = [184 496 38 113];

            % Create RegProgressLabel
            app.RegProgressLabel = uilabel(app.DashboardPanel);
            app.RegProgressLabel.HorizontalAlignment = 'center';
            app.RegProgressLabel.FontColor = [0 0.4471 0.7412];
            app.RegProgressLabel.Position = [177 611 53 22];
            app.RegProgressLabel.Text = 'Progress';

            % Create DmultisliceT2mappingLabel
            app.DmultisliceT2mappingLabel = uilabel(app.T2mapUIFigure);
            app.DmultisliceT2mappingLabel.HorizontalAlignment = 'center';
            app.DmultisliceT2mappingLabel.FontSize = 30;
            app.DmultisliceT2mappingLabel.FontWeight = 'bold';
            app.DmultisliceT2mappingLabel.FontColor = [0 0.4471 0.7412];
            app.DmultisliceT2mappingLabel.Position = [499 823 381 40];
            app.DmultisliceT2mappingLabel.Text = '2D multi slice T2 mapping';

            % Create RawImageDataPanel
            app.RawImageDataPanel = uipanel(app.T2mapUIFigure);
            app.RawImageDataPanel.ForegroundColor = [0 0.4471 0.7412];
            app.RawImageDataPanel.TitlePosition = 'centertop';
            app.RawImageDataPanel.Title = 'Raw Image Data';
            app.RawImageDataPanel.FontWeight = 'bold';
            app.RawImageDataPanel.FontSize = 15;
            app.RawImageDataPanel.Position = [286 353 525 450];

            % Create ImageLabel
            app.ImageLabel = uilabel(app.RawImageDataPanel);
            app.ImageLabel.FontWeight = 'bold';
            app.ImageLabel.Position = [165 404 41 22];
            app.ImageLabel.Text = 'Image';

            % Create ImageselectorPanel
            app.ImageselectorPanel = uipanel(app.RawImageDataPanel);
            app.ImageselectorPanel.ForegroundColor = [0 0.4471 0.7412];
            app.ImageselectorPanel.Title = 'Image selector';
            app.ImageselectorPanel.Position = [367 263 147 143];

            % Create SlicesSlider
            app.SlicesSlider = uislider(app.ImageselectorPanel);
            app.SlicesSlider.Limits = [1 200];
            app.SlicesSlider.MajorTicks = [];
            app.SlicesSlider.ValueChangedFcn = createCallbackFcn(app, @SlicesSliderValueChanged, true);
            app.SlicesSlider.MinorTicks = [];
            app.SlicesSlider.Position = [29 74 97 3];
            app.SlicesSlider.Value = 1;

            % Create EchoesSlider
            app.EchoesSlider = uislider(app.ImageselectorPanel);
            app.EchoesSlider.Limits = [1 200];
            app.EchoesSlider.MajorTicks = [];
            app.EchoesSlider.ValueChangedFcn = createCallbackFcn(app, @EchoesSliderValueChanged, true);
            app.EchoesSlider.MinorTicks = [];
            app.EchoesSlider.Position = [30 15 97 3];
            app.EchoesSlider.Value = 1;

            % Create SliceEditFieldLabel
            app.SliceEditFieldLabel = uilabel(app.ImageselectorPanel);
            app.SliceEditFieldLabel.HorizontalAlignment = 'right';
            app.SliceEditFieldLabel.Position = [29 87 31 22];
            app.SliceEditFieldLabel.Text = 'Slice';

            % Create SlicesEditField
            app.SlicesEditField = uieditfield(app.ImageselectorPanel, 'numeric');
            app.SlicesEditField.Limits = [1 Inf];
            app.SlicesEditField.ValueDisplayFormat = '%.0f';
            app.SlicesEditField.ValueChangedFcn = createCallbackFcn(app, @SlicesEditFieldValueChanged, true);
            app.SlicesEditField.Position = [75 87 42 22];
            app.SlicesEditField.Value = 1;

            % Create EchoEditFieldLabel
            app.EchoEditFieldLabel = uilabel(app.ImageselectorPanel);
            app.EchoEditFieldLabel.HorizontalAlignment = 'right';
            app.EchoEditFieldLabel.Position = [28 29 33 22];
            app.EchoEditFieldLabel.Text = 'Echo';

            % Create EchoesEditField
            app.EchoesEditField = uieditfield(app.ImageselectorPanel, 'numeric');
            app.EchoesEditField.Limits = [1 Inf];
            app.EchoesEditField.ValueDisplayFormat = '%.0f';
            app.EchoesEditField.ValueChangedFcn = createCallbackFcn(app, @SlicesEditFieldValueChanged, true);
            app.EchoesEditField.Position = [76 29 42 22];
            app.EchoesEditField.Value = 1;

            % Create SegmentationPanel
            app.SegmentationPanel = uipanel(app.RawImageDataPanel);
            app.SegmentationPanel.ForegroundColor = [0 0.4471 0.7412];
            app.SegmentationPanel.Title = 'Segmentation';
            app.SegmentationPanel.Position = [367 10 147 146];

            % Create ThresholdSlider
            app.ThresholdSlider = uislider(app.SegmentationPanel);
            app.ThresholdSlider.Limits = [1 16384];
            app.ThresholdSlider.MajorTicks = [];
            app.ThresholdSlider.ValueChangedFcn = createCallbackFcn(app, @ThresholdSliderValueChanged, true);
            app.ThresholdSlider.MinorTicks = [];
            app.ThresholdSlider.Position = [26 82 97 3];
            app.ThresholdSlider.Value = 1;

            % Create ErodeButton
            app.ErodeButton = uibutton(app.SegmentationPanel, 'push');
            app.ErodeButton.ButtonPushedFcn = createCallbackFcn(app, @ErodeButtonPushed, true);
            app.ErodeButton.FontSize = 11;
            app.ErodeButton.Position = [13 43 56 22];
            app.ErodeButton.Text = 'Erode';

            % Create DilateButton
            app.DilateButton = uibutton(app.SegmentationPanel, 'push');
            app.DilateButton.ButtonPushedFcn = createCallbackFcn(app, @DilateButtonPushed, true);
            app.DilateButton.FontSize = 11;
            app.DilateButton.Position = [77 43 56 22];
            app.DilateButton.Text = 'Dilate';

            % Create CloseButton
            app.CloseButton = uibutton(app.SegmentationPanel, 'push');
            app.CloseButton.ButtonPushedFcn = createCallbackFcn(app, @CloseButtonPushed, true);
            app.CloseButton.FontSize = 11;
            app.CloseButton.Position = [13 11 56 22];
            app.CloseButton.Text = 'Close';

            % Create OpenButton
            app.OpenButton = uibutton(app.SegmentationPanel, 'push');
            app.OpenButton.ButtonPushedFcn = createCallbackFcn(app, @OpenButtonPushed, true);
            app.OpenButton.FontSize = 11;
            app.OpenButton.Position = [77 11 56 22];
            app.OpenButton.Text = 'Open';

            % Create ThresholdEditFieldLabel
            app.ThresholdEditFieldLabel = uilabel(app.SegmentationPanel);
            app.ThresholdEditFieldLabel.HorizontalAlignment = 'right';
            app.ThresholdEditFieldLabel.Position = [7 96 59 22];
            app.ThresholdEditFieldLabel.Text = 'Threshold';

            % Create ThresholdEditField
            app.ThresholdEditField = uieditfield(app.SegmentationPanel, 'numeric');
            app.ThresholdEditField.Limits = [0 Inf];
            app.ThresholdEditField.ValueDisplayFormat = '%.0f';
            app.ThresholdEditField.ValueChangedFcn = createCallbackFcn(app, @ThresholdEditFieldValueChanged, true);
            app.ThresholdEditField.Position = [81 96 59 22];

            % Create ImageIntensityPanel
            app.ImageIntensityPanel = uipanel(app.RawImageDataPanel);
            app.ImageIntensityPanel.ForegroundColor = [0 0.4471 0.7412];
            app.ImageIntensityPanel.Title = 'Image Intensity';
            app.ImageIntensityPanel.Position = [367 173 147 73];

            % Create ScaleSliderLabel
            app.ScaleSliderLabel = uilabel(app.ImageIntensityPanel);
            app.ScaleSliderLabel.HorizontalAlignment = 'right';
            app.ScaleSliderLabel.Position = [13 17 35 22];
            app.ScaleSliderLabel.Text = 'Scale';

            % Create ScaleSlider
            app.ScaleSlider = uislider(app.ImageIntensityPanel);
            app.ScaleSlider.Limits = [0 2];
            app.ScaleSlider.MajorTicks = [0 1 2];
            app.ScaleSlider.MajorTickLabels = {'0', '1', '2'};
            app.ScaleSlider.ValueChangedFcn = createCallbackFcn(app, @ScaleSliderValueChanged, true);
            app.ScaleSlider.FontSize = 10;
            app.ScaleSlider.Position = [63 36 49 3];
            app.ScaleSlider.Value = 0.01;

            % Create SquareBackground1
            app.SquareBackground1 = uiimage(app.RawImageDataPanel);
            app.SquareBackground1.Position = [10 60 345 345];
            app.SquareBackground1.ImageSource = 'square.png';

            % Create RawDataFig
            app.RawDataFig = uiaxes(app.RawImageDataPanel);
            title(app.RawDataFig, '')
            xlabel(app.RawDataFig, '')
            ylabel(app.RawDataFig, '')
            app.RawDataFig.PlotBoxAspectRatio = [1 1 1];
            app.RawDataFig.FontSize = 1;
            app.RawDataFig.MinorGridLineStyle = 'none';
            app.RawDataFig.Box = 'on';
            app.RawDataFig.XColor = [0.8 0.8 0.8];
            app.RawDataFig.XTick = [];
            app.RawDataFig.YColor = [0.8 0.8 0.8];
            app.RawDataFig.YTick = [];
            app.RawDataFig.Color = [0.902 0.902 0.902];
            app.RawDataFig.BackgroundColor = [0.9412 0.9412 0.9412];
            app.RawDataFig.Position = [20 70 325 325];

            % Create SequenceParametersPanel
            app.SequenceParametersPanel = uipanel(app.T2mapUIFigure);
            app.SequenceParametersPanel.ForegroundColor = [0 0.4471 0.7412];
            app.SequenceParametersPanel.TitlePosition = 'centertop';
            app.SequenceParametersPanel.Title = 'Sequence Parameters';
            app.SequenceParametersPanel.FontWeight = 'bold';
            app.SequenceParametersPanel.FontSize = 15;
            app.SequenceParametersPanel.Position = [286 40 525 298];

            % Create TRmsEditFieldLabel
            app.TRmsEditFieldLabel = uilabel(app.SequenceParametersPanel);
            app.TRmsEditFieldLabel.HorizontalAlignment = 'right';
            app.TRmsEditFieldLabel.Position = [33 177 46 22];
            app.TRmsEditFieldLabel.Text = 'TR (ms)';

            % Create TRViewField
            app.TRViewField = uieditfield(app.SequenceParametersPanel, 'numeric');
            app.TRViewField.Limits = [0 Inf];
            app.TRViewField.Editable = 'off';
            app.TRViewField.Position = [94 177 100 22];

            % Create TEmsEditFieldLabel
            app.TEmsEditFieldLabel = uilabel(app.SequenceParametersPanel);
            app.TEmsEditFieldLabel.HorizontalAlignment = 'right';
            app.TEmsEditFieldLabel.Position = [33 146 46 22];
            app.TEmsEditFieldLabel.Text = 'TE (ms)';

            % Create TEViewField
            app.TEViewField = uieditfield(app.SequenceParametersPanel, 'numeric');
            app.TEViewField.Limits = [0 Inf];
            app.TEViewField.Editable = 'off';
            app.TEViewField.Position = [94 146 100 22];

            % Create dimxEditFieldLabel
            app.dimxEditFieldLabel = uilabel(app.SequenceParametersPanel);
            app.dimxEditFieldLabel.HorizontalAlignment = 'right';
            app.dimxEditFieldLabel.Position = [47 84 32 22];
            app.dimxEditFieldLabel.Text = 'dimx';

            % Create dimxViewField
            app.dimxViewField = uieditfield(app.SequenceParametersPanel, 'numeric');
            app.dimxViewField.Limits = [0 Inf];
            app.dimxViewField.ValueDisplayFormat = '%.0f';
            app.dimxViewField.Editable = 'off';
            app.dimxViewField.Position = [94 84 100 22];

            % Create dimyEditFieldLabel
            app.dimyEditFieldLabel = uilabel(app.SequenceParametersPanel);
            app.dimyEditFieldLabel.HorizontalAlignment = 'right';
            app.dimyEditFieldLabel.Position = [47 53 32 22];
            app.dimyEditFieldLabel.Text = 'dimy';

            % Create dimyViewField
            app.dimyViewField = uieditfield(app.SequenceParametersPanel, 'numeric');
            app.dimyViewField.Limits = [0 Inf];
            app.dimyViewField.ValueDisplayFormat = '%.0f';
            app.dimyViewField.Editable = 'off';
            app.dimyViewField.Position = [94 53 100 22];

            % Create SlicesEditFieldLabel
            app.SlicesEditFieldLabel = uilabel(app.SequenceParametersPanel);
            app.SlicesEditFieldLabel.HorizontalAlignment = 'right';
            app.SlicesEditFieldLabel.Position = [42 22 37 22];
            app.SlicesEditFieldLabel.Text = 'Slices';

            % Create SlicesViewField
            app.SlicesViewField = uieditfield(app.SequenceParametersPanel, 'numeric');
            app.SlicesViewField.Limits = [0 Inf];
            app.SlicesViewField.ValueDisplayFormat = '%.0f';
            app.SlicesViewField.Editable = 'off';
            app.SlicesViewField.Position = [94 22 100 22];

            % Create EchoesLabel
            app.EchoesLabel = uilabel(app.SequenceParametersPanel);
            app.EchoesLabel.HorizontalAlignment = 'right';
            app.EchoesLabel.Position = [34 115 45 22];
            app.EchoesLabel.Text = 'Echoes';

            % Create EchoesViewField
            app.EchoesViewField = uieditfield(app.SequenceParametersPanel, 'numeric');
            app.EchoesViewField.Limits = [0 Inf];
            app.EchoesViewField.Editable = 'off';
            app.EchoesViewField.Position = [94 115 100 22];

            % Create FOVmmEditFieldLabel
            app.FOVmmEditFieldLabel = uilabel(app.SequenceParametersPanel);
            app.FOVmmEditFieldLabel.HorizontalAlignment = 'right';
            app.FOVmmEditFieldLabel.Position = [304 177 59 22];
            app.FOVmmEditFieldLabel.Text = 'FOV (mm)';

            % Create FOVViewField
            app.FOVViewField = uieditfield(app.SequenceParametersPanel, 'numeric');
            app.FOVViewField.Limits = [0 Inf];
            app.FOVViewField.Editable = 'off';
            app.FOVViewField.Position = [378 177 100 22];

            % Create SlicethicknessmmLabel
            app.SlicethicknessmmLabel = uilabel(app.SequenceParametersPanel);
            app.SlicethicknessmmLabel.HorizontalAlignment = 'right';
            app.SlicethicknessmmLabel.Position = [247 146 116 22];
            app.SlicethicknessmmLabel.Text = 'Slice thickness (mm)';

            % Create SLTViewField
            app.SLTViewField = uieditfield(app.SequenceParametersPanel, 'numeric');
            app.SLTViewField.Limits = [0 Inf];
            app.SLTViewField.Editable = 'off';
            app.SLTViewField.Position = [378 146 100 22];

            % Create AspectratioLabel
            app.AspectratioLabel = uilabel(app.SequenceParametersPanel);
            app.AspectratioLabel.HorizontalAlignment = 'right';
            app.AspectratioLabel.Position = [293 115 70 22];
            app.AspectratioLabel.Text = 'Aspect ratio';

            % Create AspectRatioViewField
            app.AspectRatioViewField = uieditfield(app.SequenceParametersPanel, 'numeric');
            app.AspectRatioViewField.Limits = [0.25 4];
            app.AspectRatioViewField.ValueDisplayFormat = '%.1f';
            app.AspectRatioViewField.Editable = 'off';
            app.AspectRatioViewField.Position = [378 115 100 22];
            app.AspectRatioViewField.Value = 1;

            % Create DatafileEditFieldLabel
            app.DatafileEditFieldLabel = uilabel(app.SequenceParametersPanel);
            app.DatafileEditFieldLabel.HorizontalAlignment = 'right';
            app.DatafileEditFieldLabel.Position = [33 227 46 22];
            app.DatafileEditFieldLabel.Text = 'Datafile';

            % Create DatafileEditField
            app.DatafileEditField = uieditfield(app.SequenceParametersPanel, 'text');
            app.DatafileEditField.Editable = 'off';
            app.DatafileEditField.Position = [94 227 192 22];

            % Create FitResultsPanel
            app.FitResultsPanel = uipanel(app.T2mapUIFigure);
            app.FitResultsPanel.ForegroundColor = [0 0.4471 0.7412];
            app.FitResultsPanel.TitlePosition = 'centertop';
            app.FitResultsPanel.Title = 'Fit Results';
            app.FitResultsPanel.FontWeight = 'bold';
            app.FitResultsPanel.FontSize = 15;
            app.FitResultsPanel.Position = [829 40 525 763];

            % Create T2MapLabel
            app.T2MapLabel = uilabel(app.FitResultsPanel);
            app.T2MapLabel.FontWeight = 'bold';
            app.T2MapLabel.Position = [159 717 48 22];
            app.T2MapLabel.Text = 'T2 map';

            % Create M0MapLabel
            app.M0MapLabel = uilabel(app.FitResultsPanel);
            app.M0MapLabel.FontWeight = 'bold';
            app.M0MapLabel.Position = [159 350 51 22];
            app.M0MapLabel.Text = 'M0 map';

            % Create ImageSelectorPanel
            app.ImageSelectorPanel = uipanel(app.FitResultsPanel);
            app.ImageSelectorPanel.ForegroundColor = [0 0.4471 0.7412];
            app.ImageSelectorPanel.Title = 'Image Selector';
            app.ImageSelectorPanel.Position = [365 595 147 123];

            % Create T2MapSlicesSlider
            app.T2MapSlicesSlider = uislider(app.ImageSelectorPanel);
            app.T2MapSlicesSlider.Limits = [1 200];
            app.T2MapSlicesSlider.MajorTicks = [];
            app.T2MapSlicesSlider.ValueChangedFcn = createCallbackFcn(app, @T2MapSlicesSliderValueChanged, true);
            app.T2MapSlicesSlider.MinorTicks = [];
            app.T2MapSlicesSlider.Position = [30 55 97 3];
            app.T2MapSlicesSlider.Value = 1;

            % Create SliceEditField_2Label
            app.SliceEditField_2Label = uilabel(app.ImageSelectorPanel);
            app.SliceEditField_2Label.HorizontalAlignment = 'right';
            app.SliceEditField_2Label.Position = [30 68 31 22];
            app.SliceEditField_2Label.Text = 'Slice';

            % Create T2MapSlicesEditField
            app.T2MapSlicesEditField = uieditfield(app.ImageSelectorPanel, 'numeric');
            app.T2MapSlicesEditField.Limits = [1 Inf];
            app.T2MapSlicesEditField.ValueDisplayFormat = '%.0f';
            app.T2MapSlicesEditField.ValueChangedFcn = createCallbackFcn(app, @T2MapSlicesEditFieldValueChanged, true);
            app.T2MapSlicesEditField.Position = [76 68 42 22];
            app.T2MapSlicesEditField.Value = 1;

            % Create ColorMapButtonGroup
            app.ColorMapButtonGroup = uibuttongroup(app.FitResultsPanel);
            app.ColorMapButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @ColorMapButtonGroupSelectionChanged2, true);
            app.ColorMapButtonGroup.ForegroundColor = [0 0.4471 0.7412];
            app.ColorMapButtonGroup.Title = 'Color Map';
            app.ColorMapButtonGroup.Position = [366 419 147 159];

            % Create grayButton
            app.grayButton = uiradiobutton(app.ColorMapButtonGroup);
            app.grayButton.Text = 'gray';
            app.grayButton.Position = [75 108 45 22];
            app.grayButton.Value = true;

            % Create autumnButton
            app.autumnButton = uiradiobutton(app.ColorMapButtonGroup);
            app.autumnButton.Text = 'autumn';
            app.autumnButton.Position = [75 84 62 22];

            % Create winterButton
            app.winterButton = uiradiobutton(app.ColorMapButtonGroup);
            app.winterButton.Text = 'winter';
            app.winterButton.Position = [75 61 55 22];

            % Create parulaButton
            app.parulaButton = uiradiobutton(app.ColorMapButtonGroup);
            app.parulaButton.Text = 'parula';
            app.parulaButton.Position = [75 38 55 22];

            % Create hotButton
            app.hotButton = uiradiobutton(app.ColorMapButtonGroup);
            app.hotButton.Text = 'hot';
            app.hotButton.Position = [75 15 39 22];

            % Create T2ScaleEditField
            app.T2ScaleEditField = uieditfield(app.ColorMapButtonGroup, 'numeric');
            app.T2ScaleEditField.Limits = [1 1000];
            app.T2ScaleEditField.ValueChangedFcn = createCallbackFcn(app, @T2ScaleEditFieldValueChanged, true);
            app.T2ScaleEditField.HorizontalAlignment = 'center';
            app.T2ScaleEditField.Position = [10 84 37 22];
            app.T2ScaleEditField.Value = 1;

            % Create T2ScaleMaxLabel
            app.T2ScaleMaxLabel = uilabel(app.ColorMapButtonGroup);
            app.T2ScaleMaxLabel.HorizontalAlignment = 'center';
            app.T2ScaleMaxLabel.Position = [15 108 29 22];
            app.T2ScaleMaxLabel.Text = 'Max';

            % Create T2ScaleAutoButton
            app.T2ScaleAutoButton = uibutton(app.ColorMapButtonGroup, 'push');
            app.T2ScaleAutoButton.ButtonPushedFcn = createCallbackFcn(app, @T2ScaleAutoButtonPushed, true);
            app.T2ScaleAutoButton.FontSize = 11;
            app.T2ScaleAutoButton.Position = [10 54 37 22];
            app.T2ScaleAutoButton.Text = 'Auto';

            % Create SquareBackground2
            app.SquareBackground2 = uiimage(app.FitResultsPanel);
            app.SquareBackground2.Position = [12 373 345 345];
            app.SquareBackground2.ImageSource = 'square.png';

            % Create T2MapFig
            app.T2MapFig = uiaxes(app.FitResultsPanel);
            title(app.T2MapFig, '')
            xlabel(app.T2MapFig, '')
            ylabel(app.T2MapFig, '')
            app.T2MapFig.PlotBoxAspectRatio = [1 1 1];
            app.T2MapFig.FontSize = 1;
            app.T2MapFig.ClippingStyle = 'rectangle';
            app.T2MapFig.MinorGridLineStyle = 'none';
            app.T2MapFig.Box = 'on';
            app.T2MapFig.BoxStyle = 'full';
            app.T2MapFig.XColor = [0.8 0.8 0.8];
            app.T2MapFig.XTick = [];
            app.T2MapFig.YColor = [0.8 0.8 0.8];
            app.T2MapFig.YTick = [];
            app.T2MapFig.Color = [0.902 0.902 0.902];
            app.T2MapFig.Position = [20 383 325 325];

            % Create SquareBackground3
            app.SquareBackground3 = uiimage(app.FitResultsPanel);
            app.SquareBackground3.Position = [12 6 345 345];
            app.SquareBackground3.ImageSource = 'square.png';

            % Create M0MapFig
            app.M0MapFig = uiaxes(app.FitResultsPanel);
            title(app.M0MapFig, '')
            xlabel(app.M0MapFig, '')
            ylabel(app.M0MapFig, '')
            app.M0MapFig.PlotBoxAspectRatio = [1 1 1];
            app.M0MapFig.FontSize = 1;
            app.M0MapFig.MinorGridLineStyle = 'none';
            app.M0MapFig.Box = 'on';
            app.M0MapFig.XColor = [0.8 0.8 0.8];
            app.M0MapFig.XTick = [];
            app.M0MapFig.YColor = [0.8 0.8 0.8];
            app.M0MapFig.YTick = [];
            app.M0MapFig.Color = [0.902 0.902 0.902];
            app.M0MapFig.Position = [20 16 325 325];

            % Create Version11Aug2019GustavStrijkersAmsterdamUMCLabel
            app.Version11Aug2019GustavStrijkersAmsterdamUMCLabel = uilabel(app.T2mapUIFigure);
            app.Version11Aug2019GustavStrijkersAmsterdamUMCLabel.FontSize = 15;
            app.Version11Aug2019GustavStrijkersAmsterdamUMCLabel.FontColor = [0 0.4471 0.7412];
            app.Version11Aug2019GustavStrijkersAmsterdamUMCLabel.Position = [922 9 398 22];
            app.Version11Aug2019GustavStrijkersAmsterdamUMCLabel.Text = 'Version 1.1, Aug 2019, Gustav Strijkers, Amsterdam UMC';

            % Create TulpLogo
            app.TulpLogo = uiimage(app.T2mapUIFigure);
            app.TulpLogo.Position = [1313 5 46 30];
            app.TulpLogo.ImageSource = 'AmsterdamUMC.gif';

            % Show the figure after all components are created
            app.T2mapUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = T2map_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.T2mapUIFigure)

            % Execute the startup function
            runStartupFcn(app, @StartupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.T2mapUIFigure)
        end
    end
end