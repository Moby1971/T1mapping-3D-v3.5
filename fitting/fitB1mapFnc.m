function B1map = fitB1mapFnc(image4D,flipangles)

[nfa, dimx, dimy, dimz ] = size(image4D);

% Smooth the images with a moving average
fs = 12;
ker = ones(fs,fs,fs)/(fs^3);
smootherimage = ones(size(image4D));
for i = 1:nfa
    smootherimage(i,:,:,:) = convn(squeeze(image4D(i,:,:,:)),ker,'same');
end

% Fit the minimum for every pixel
x = flipangles;
m = zeros(dimx, dimy, dimz);
parfor i = 1:dimx
    for j = 1:dimy
        for k = 1:dimz
            y = squeeze(smootherimage(:,i,j,k))';
            p = polyfit(x,y,2);
            m(i,j,k) = -p(2)/(2*p(1));
        end
    end
end

B1map = m/180;

end