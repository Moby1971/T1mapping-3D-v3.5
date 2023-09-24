function [T1out,M0out] = fitT1despot(input,mask,fa,tr,B1map,B1flag)


% Performs the T1 map fitting for 1 slice



% Dimensions
[nrfa,dimx,dimy] = size(input);
T1map = zeros(dimx,dimy);
M0map = zeros(dimx,dimy);
inputx = zeros(dimx,dimy,nrfa);
inputy = zeros(dimx,dimy,nrfa);
b1 = zeros(dimx,dimy);
b2 = zeros(dimx,dimy);


% Flip angles
fa = fa'*pi/180;

% Despot T1 linearization
if B1flag
    for i = 1:nrfa
        inputx(:,:,i) = squeeze(input(i,:,:))./tan(fa(i)./B1map(:,:));
        inputy(:,:,i) = squeeze(input(i,:,:))./sin(fa(i)./B1map(:,:));
    end
else
    for i = 1:nrfa
        inputx(:,:,i) = input(i,:,:)/tan(fa(i));
        inputy(:,:,i) = input(i,:,:)/sin(fa(i));
    end
end


parfor j=1:dimx
     % for all x-coordinates
 
     for k=1:dimy
         % for all y-coordinates
         
         if mask(j,k) == 1
             % only fit when mask value indicates valid data point
             
             % pixel value as function of alpha
             y = squeeze(inputy(j,k,:));
             x = [ones(nrfa,1),squeeze(inputx(j,k,:))];
             
             % do the linear regression
             b = x\y;
             
             % save the results
             b1(j,k) = b(1);
             b2(j,k) = b(2);
             
         end
         
     end
     
end


% Make the maps
T1map(:,:)=-tr./log(b2(:,:));
M0map(:,:)=b1(:,:)./(1-b2(:,:));

% Some reasonable criteria
T1map = abs(T1map);
M0map = abs(M0map);
T1map(T1map<0) = 0;
T1map(T1map>8000) = 0;
M0map(M0map<0) = 0;

% Remove M0 outliers
m0mean = mean(nonzeros(M0map(:)));
M0map(M0map>5*m0mean) = 0;

% Return the results
T1out = T1map;
M0out = M0map;    

end