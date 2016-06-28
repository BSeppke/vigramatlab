function padded_image = paddimage(image, left, upper, right, lower)
    
    shape = size(image);
    h = shape(1);
    w = shape(2);
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    new_width = right + w + left;
    new_height = lower + h + upper;
    
    padded_image = zeros(new_height,new_width,b,'single');
    
    for i=1:b
        padded_image(:,:,i) = paddimage_band(image(:,:,i), left, upper, right, lower);
    end
    
end

function padded_band = paddimage_band(image_band, left, upper, right, lower)

    shape = size(image_band);
    h = shape(1);
    w = shape(2);
    
    new_width = right + w + left;
    new_height = lower + h + upper;
   
    ptr = libpointer('singlePtr',image_band');
    
    padded_band = zeros(new_width,new_height,'single');
    resized_ptr = libpointer('singlePtr',padded_band);
    
    result = calllib('libvigra_c','vigra_paddimage_c', ptr, resized_ptr, w,h, left, upper, right, lower);
    
    switch result
        case 0
            padded_band = resized_ptr.Value';
        case 1
            error('Error in vigramatlab.imgproc:paddimage: Subimage extraction failed!')
        case 2
            error('Error in vigramatlab.imgproc:paddimage: Constraints not fullfilled: left & right >= 0, upper & lower >= 0')
    end
end