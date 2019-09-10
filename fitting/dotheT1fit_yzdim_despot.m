function [T1out,M0out] = dotheT1fit_yzdim_despot(input,mask,fa,tr)

% performs the T2 map fitting for 1 slice

[~,dimy,dimz] = size(input);
T1map = zeros(dimy,dimz,1);
M0map = zeros(dimy,dimz,1);

% flip angles
fa = fa'*pi/180;
lfa = length(fa);


for j=1:dimy
    % for all y-coordinates
    parfor k=1:dimz
        % for all z-coordinates
        
        if mask(j,k) == 1
            % only fit when mask value indicates valid data point
            
            % pixel value as function of alpha
            y = (squeeze(input(:,j,k))./sin(fa));
            x = [ones(lfa,1),squeeze(input(:,j,k))./tan(fa)];
            
            % do the linear regression
            b = x\y;
            
            % make the maps
            T1map(j,k)=-tr/log(b(2));
            M0map(j,k)=b(1)/(1-b(2));
            
        end
        
    end
    
end

T1out = T1map;
M0out = M0map;    

end