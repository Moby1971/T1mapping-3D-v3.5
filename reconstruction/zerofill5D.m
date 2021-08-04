function output = zerofill5D(app,input)

[~, ~, dimx, dimy, dimz] = size(input);

if (2^nextpow2(dimx) ~= dimx) || (2^nextpow2(dimy) ~= dimy) || (2^nextpow2(dimz) ~= dimz)
    
    kspace = bart(app,'fft -i 28',input);
    
    new_dimx = power(2,nextpow2(dimx));
    new_dimy = power(2,nextpow2(dimy));
    new_dimz = power(2,nextpow2(dimz));
    
    kspace = bart(app,['resize -c 2 ',num2str(new_dimx),' 3 ',num2str(new_dimy),' 4 ',num2str(new_dimz)],kspace);
    
    output = abs(bart(app,'fft 28',kspace));
    
else
    
    output = input;
    
end

end

