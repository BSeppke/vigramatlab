function medianfiltered_image = medianfilter(image, window_width, window_height)
    
    shape = size(image);
    h = shape(1);
    w = shape(2);
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    medianfiltered_image = zeros(h,w,b,'single');
    
    for i=1:b
        medianfiltered_image(:,:,i) = medianfilter_band(image(:,:,i), window_width, window_height);
    end
    
end

function medianfiltered_band = medianfilter_band(image_band, window_width, window_height)

    shape = size(image_band);
    h = shape(1);
    w = shape(2);
   
    ptr = libpointer('singlePtr',image_band');
    
    medianfiltered_band = zeros(h,w,'single');
    filtered_ptr = libpointer('singlePtr',medianfiltered_band);
    
    result = calllib('libvigra_c','vigra_medianfilter_c', ptr, filtered_ptr, w,h, window_width, window_height);
    
    switch result
        case 0
            medianfiltered_band = filtered_ptr.Value';
        case 1
            error('Error in vigramatlab.imgproc:medianfilter: Median filtering failed!')
    end
end