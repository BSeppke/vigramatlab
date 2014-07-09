function sharpened_image = simplesharpening(image, sharpening_factor)
    
    shape = size(image);
    h = shape(1);
    w = shape(2);
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    sharpened_image = zeros(h,w,b,'single');
    
    for i=1:b
        sharpened_image(:,:,i) = simplesharpening_band(image(:,:,i), sharpening_factor);
    end
    
end

function sharpenend_image_band = simplesharpening_band(image_band, sharpening_factor)

    shape = size(image_band);
    h = shape(1);
    w = shape(2);
   
    ptr = libpointer('singlePtr',image_band');
    
    sharpenend_image_band = zeros(w,h,'single');
    sharpened_ptr = libpointer('singlePtr',sharpenend_image_band);
    
    result = calllib('libvigra_c','vigra_simplesharpening_c', ptr, sharpened_ptr, w,h, single(sharpening_factor));
    
    switch result
        case 0
            sharpenend_image_band = sharpened_ptr.Value';
        case 1
            error('Error in vigramatlab.filters.simplesharpening: Simple sharpening failed!')
    end
end