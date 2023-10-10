function registerImages(app)

% Registration of multi-echo images
app.TextMessage('Image registration ...');

imagesIn = app.image5D;         % All images
maxIdx = app.maxIndx;           % FA index of the image with the highest intensity, target image for registration

[nrFlipAngles,nrFrames,~,~,nrSlices] = size(imagesIn);


% For progress gauge
totalNumberOfSteps = nrFlipAngles*nrFrames*nrSlices-1;
step = 0;

try

    % Temp directory for storing registration files
    if ispc
        outputDir = 'C:\tmp\';
        if ~exist(outputDir, 'dir')
            mkdir(outputDir);
        end
    else
        outputDir = [];
    end

    [~,elastix_version] = system('elastix --version');
    app.TextMessage(elastix_version);

    switch app.RegistrationDropDown.Value
        case 'Translation'
            fileName = 'regParsTrans.txt';
        case 'Rigid'
            fileName = 'regParsRigid.txt';
        case 'Affine'
            fileName = 'regParsAffine.txt';
        case 'B-Spline'
            fileName = 'regParsBSpline.txt';
    end
    [regParDir , ~] = fileparts(which(fileName));
    regParFile = strcat(regParDir,filesep,fileName);

    elapsedTime = 0;
 
    slice = 0;

    while slice<nrSlices && ~app.abortRegFlag

        slice = slice + 1;

        frame = 0;

        while frame < nrFrames && ~app.abortRegFlag

            frame = frame + 1;

            flipAngle = 0;

            while flipAngle < nrFlipAngles && ~app.abortRegFlag

                tic;

                flipAngle = flipAngle + 1;

                % Fixed and moving image
                image0 = squeeze(imagesIn(maxIdx,frame,:,:,slice)); % register to FA with max intensity
                image1 = squeeze(imagesIn(flipAngle,frame,:,:,slice));

                % Register
                image2 = elastix(image1,image0,outputDir,regParFile);

                % New registered image
                imagesIn(flipAngle,frame,:,:,slice) = image2;

                % Progress gauge
                app.RegistrationProgressGauge.Value = round(100*step/totalNumberOfSteps);
                step = step + 1;
                drawnow;

                % Update the timing indicator
                elapsedTime = elapsedTime + toc;
                estimatedTotalTime = elapsedTime * totalNumberOfSteps / step;
                timeRemaining = estimatedTotalTime * (totalNumberOfSteps - step + 1) / totalNumberOfSteps;
                timeRemaining(timeRemaining<0) = 0;
                app.EstimatedRegTimeViewField.Value = strcat(datestr(seconds(timeRemaining),'MM:SS')," min:sec"); %#ok<*DATST>
                drawnow;

            end

        end

    end


catch ME

    app.TextMessage(ME.message)

    % Matlab

    app.TextMessage('Elastix failed, registering images using Matlab ...');

    [optimizer, metric] = imregconfig('multimodal');

    switch app.RegistrationDropDown.Value
        case 'Translation'
            method = 'translation';
        case 'Rigid'
            method = 'rigid';
        case 'Affine'
            method = 'similarity';
        case 'B-Spline'
            method = 'affine';
    end

    elapsedTime = 0;
  
    slice = 0;

    while slice<nrSlices && ~app.abortRegFlag

        slice = slice + 1;

        frame = 0;

        while frame < nrFrames  && ~app.abortRegFlag

            frame = frame + 1;

            flipAngle = 0;

            while flipAngle < nrFlipAngles && ~app.abortRegFlag

                tic;

                flipAngle = flipAngle + 1;

                % Fixed and moving image
                image0 = squeeze(imagesIn(maxIdx,frame,:,:,slice));  % register to FA with max intensity 
                image1 = squeeze(imagesIn(flipAngle,frame,:,:,slice));

                % Threshold
                threshold = graythresh(mat2gray(image0)) * max(image0(:));
                image0(image0 < threshold) = 0;
                image1(image0 < threshold) = 0;

                % Register
                image2 = imregister(image1,image0,method,optimizer, metric,'DisplayOptimization',0);

                % New registered image
                imagesIn(flipAngle,frame,:,:,slice) = image2;

                % Progress gauge
                app.RegistrationProgressGauge.Value = round(100*step/totalNumberOfSteps);
                step = step + 1;
                drawnow;

                % Update the timing indicator
                elapsedTime = elapsedTime + toc;
                estimatedTotalTime = elapsedTime * totalNumberOfSteps / step;
                timeRemaining = estimatedTotalTime * (totalNumberOfSteps - step + 1) / totalNumberOfSteps;
                timeRemaining(timeRemaining<0) = 0;
                app.EstimatedRegTimeViewField.Value = strcat(datestr(seconds(timeRemaining),'MM:SS')," min:sec"); %#ok<*DATST>
                drawnow;

            end

        end

    end

end


% Renormalize
imagesIn = 32767*imagesIn/max(imagesIn(:));

app.image5D = imagesIn;

app.EstimatedRegTimeViewField.Value = 'Finished ...';

end