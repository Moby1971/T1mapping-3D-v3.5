function output = zerofill4D(input)

[nrframes, dimx, dimy, dimz] = size(input);

kspace = bart('fft -i 14',input);

new_dimx = power(2,nextpow2(dimx));
new_dimy = power(2,nextpow2(dimy));
new_dimz = power(2,nextpow2(dimz));

kspace = bart(['resize -c 1 ',num2str(new_dimx),' 2 ',num2str(new_dimy),' 3 ',num2str(new_dimz)],kspace);

output = abs(bart('fft 14',kspace));


end

