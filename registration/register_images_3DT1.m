function images_out = register_images_3DT1(app,images_in,maxidx)


nr_flipangles = size(images_in,1);
nr_frames = size(images_in,2);

[optimizer, metric] = imregconfig('multimodal');


for j = 1:nr_frames
    
    image0 = squeeze(images_in(maxidx,j,:,:,:));
    
    for i = 1:nr_flipangles
        
        if i ~= maxidx
            
            image1 = squeeze(images_in(i,j,:,:,:));
            
            [image2] = imregister(image1,image0,'similarity',optimizer, metric,'DisplayOptimization',0);
            
            images_in(i,j,:,:,:) = image2;
            
        end
        
        app.RegistrationProgressGauge.Value = round(100*((j-1)*nr_flipangles+i)/(nr_flipangles*nr_frames));
        drawnow;

    end
    
end


images_out = images_in;

end