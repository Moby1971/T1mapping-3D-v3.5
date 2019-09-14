function images_out = register_images_3DT1(app,images_in,maxidx)


nfa = size(images_in,1);

[optimizer, metric] = imregconfig('multimodal');

image0 = squeeze(images_in(maxidx,:,:,:));

for i = 1:nfa
        
    if i ~= maxidx
        
        image1 = squeeze(images_in(i,:,:,:));
        
        [image2] = imregister(image1,image0,'similarity',optimizer, metric,'DisplayOptimization',0);
        
        images_in(i,:,:,:) = image2;
        
        app.RegistrationProgressGauge.Value = round(100*i/nfa);
        drawnow;
        
    end
    
end

images_out = images_in;

end