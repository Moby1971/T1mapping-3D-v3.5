function fitT1(app)

app.TextMessage('Fitting T1 ...');

[~,nrFrames,~,~,nrSlices] = size(app.image5D);


% Progress gauge parameters
totalNumberOfSteps = nrFrames*nrSlices;
app.FitProgressGauge.Value = 0;
app.abortFitFlag = false;


% Timing parameters
app.EstimatedFitTimeViewField.Value = 'Calculating ...';
elapsedTime = 0;


cnt = 1;

slice = 0;

while slice < nrSlices && ~app.abortFitFlag

    slice = slice + 1;

    frame = 0;

    while frame < nrFrames && ~app.abortFitFlag

        frame = frame + 1;

        tic;

        % Fit function
        [app.imageT1(frame,:,:,slice),app.imageM0(frame,:,:,slice)] = fitT1despot(squeeze(app.image5D(:,frame,:,:,slice)), ...
            squeeze(app.mask(frame,:,:,slice)), app.flipAngles, app.parameters.tr, squeeze(app.imageB1(:,:,slice)), app.B1MapCheckBox.Value);

        % Update the fit progress gauge
        app.FitProgressGauge.Value = round(100*(cnt/totalNumberOfSteps));
        
        % Update the timing indicator
        elapsedTime = elapsedTime + toc;
        estimatedtotaltime = elapsedTime * totalNumberOfSteps / cnt;
        timeRemaining = estimatedtotaltime * (totalNumberOfSteps - cnt) / totalNumberOfSteps;
        timeRemaining(timeRemaining<0) = 0;
        app.EstimatedFitTimeViewField.Value = strcat(datestr(seconds(timeRemaining),'MM:SS')," min:sec"); %#ok<*DATST>
        drawnow;

        cnt = cnt+1;

    end

end

app.TextMessage('Finished ... ');
app.EstimatedFitTimeViewField.Value = 'Finished ...';

app.validFitFlag = true;

end
