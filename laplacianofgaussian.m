function log_image = laplacianofgaussian(image, scale)
    
    shape = size(image);
    w = shape(1);  
    h = shape(2); 
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    log_image = zeros(w,h,b,'single');
    
    for i=1:b
        log_image(:,:,i) = laplacianofgaussian_band(image(:,:,i), scale);
    end
    
end

function log_image_band = laplacianofgaussian_band(image_band, scale)

    shape = size(image_band);
    w = shape(1);  
    h = shape(2); 
   
    ptr = libpointer('singlePtr',image_band);
    
    log_image_band = zeros(w,h,'single');
    log_ptr = libpointer('singlePtr',log_image_band);
    
    result = calllib('libvigra_c','vigra_laplacianofgaussian_c', ptr, log_ptr, w,h, single(scale));
    
    switch result
        case 0
            log_image_band = log_ptr.Value;
        case 1
            error('Error in vigramatlab.filters.laplacianofgaussian: Laplacian of Gaussian failed!')
    end
end