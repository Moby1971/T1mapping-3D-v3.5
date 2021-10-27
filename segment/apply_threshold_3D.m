function mask = apply_threshold_3D(input,th)

% creates a binary image from input_image, based on treshold = th

input(input < th) = 0;
input(input >= th) = 1; 

mask = input;

end