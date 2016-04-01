function cropped_image = subimage(image, left, upper, right, lower)
    
    shape = size(image);
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    new_width = right-left;
    new_height = lower-upper;
    
    cropped_image = zeros(new_height,new_width,b,'single');
    
    for i=1:b
        cropped_image(:,:,i) = subimage_band(image(:,:,i), left, upper, right, lower);
    end
    
end

function cropped_band = subimage_band(image_band, left, upper, right, lower)

    shape = size(image_band);
    h = shape(1);
    w = shape(2);
    
    new_width = right-left;
    new_height = lower-upper;
   
    ptr = libpointer('singlePtr',image_band');
    
    cropped_band = zeros(new_width,new_height,'single');
    resized_ptr = libpointer('singlePtr',cropped_band);
    
    result = calllib('libvigra_c','vigra_subimage_c', ptr, resized_ptr, w,h, left, upper, right, lower);
    
    switch result
        case 0
            cropped_band = resized_ptr.Value';
        case 1
            error('Error in vigramatlab.imgproc:subimage: Subimage extraction failed!')
        case 2
            error('Error in vigramatlab.imgproc:subimage: Constraints not fullfilled: left < right, upper < lower, right - left <= width, lower - upper <= height!')
    end
end