function smoothed_image = gaussiansmoothing(image, sigma)
    
    shape = size(image);
    w = shape(1);  
    h = shape(2); 
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    smoothed_image = zeros(w,h,b,'single');
    
    for i=1:b
        smoothed_image(:,:,i) = gaussiansmoothing_band(image(:,:,i), sigma);
    end
    
end

function smoothed_image_band = gaussiansmoothing_band(image_band, sigma)

    shape = size(image_band);
    w = shape(1);  
    h = shape(2); 
   
    ptr = libpointer('singlePtr',image_band);
    
    smoothed_image_band = zeros(w,h,'single');
    smooth_ptr = libpointer('singlePtr',smoothed_image_band);
    
    result = calllib('libvigra_c','vigra_gaussiansmoothing_c', ptr, smooth_ptr, w,h, single(sigma));
    
    switch result
        case 0
            smoothed_image_band = smooth_ptr.Value;
        case 1
            error('Error in vigramatlab.filters.gaussiansmoothing: Gaussian smoothing failed!')
    end
end