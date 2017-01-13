function correlation_image = fastcrosscorrelation(image, mask)
    
    shape = size(image);
    w = shape(1);  
    h = shape(2); 
        
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    correlation_image = zeros(w,h,b,'single');
    
    for i=1:b
        correlation_image(:,:,i) = fastcrosscorrelation_band(image(:,:,i), mask(:,:,i));
    end
    
end

function correlation_band = fastcrosscorrelation_band(image_band, mask_band)

    shape = size(image_band);
    w = shape(1);  
    h = shape(2); 
   
    mask_shape = size(mask_band);
    mask_h = mask_shape(1);
    mask_w = mask_shape(2);
    
    ptr = libpointer('singlePtr',image_band);
    mask_ptr = libpointer('singlePtr',mask_band');
    
    correlation_band = zeros(w,h,'single');
    correlation_ptr = libpointer('singlePtr',correlation_band);
    
    result = calllib('libvigra_c','vigra_fastcrosscorrelation_c', ptr, mask_ptr, correlation_ptr, w,h,  mask_w, mask_h);
    
    switch result
        case 0
            correlation_band = correlation_ptr.Value;
        case 1
            error('Error in vigramatlab.imgproc:fastcrosscorrelation: Fast cross-correlation failed!')
        case 2
            error('Error in vigramatlab.imgproc:fastcrosscorrelation: Mask needs to be of odd size!')
    end
end