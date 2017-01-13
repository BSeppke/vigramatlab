function filtered_image = shockfilter(image, sigma, rho, upwind_factor_h, iterations)
    
    shape = size(image);
    w = shape(1);  
    h = shape(2); 
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    filtered_image = zeros(w,h,b,'single');
    
    for i=1:b
        filtered_image(:,:,i) = shockfilter_band(image(:,:,i), sigma, rho, upwind_factor_h, iterations);
    end
    
end

function filtered_image_band = shockfilter_band(image_band, sigma, rho, upwind_factor_h, iterations)

    shape = size(image_band);
    w = shape(1);  
    h = shape(2); 
   
    ptr = libpointer('singlePtr',image_band);
    
    filtered_image_band = zeros(w,h,'single');
    filtered_ptr = libpointer('singlePtr',filtered_image_band);
    
    result = calllib('libvigra_c','vigra_shockfilter_c', ptr, filtered_ptr, w,h, single(sigma), single(rho), single(upwind_factor_h), iterations);
    
    switch result
        case 0
            filtered_image_band = filtered_ptr.Value;
        case 1
            error('Error in vigramatlab.filters.shockfilter: Shock filtering failed!');
        case 2
            error('Error in vigramatlab.filters.shockfilter: Iteration must be > 0!');
    end
end