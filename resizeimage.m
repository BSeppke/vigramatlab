function resized_image = resizeimage(image, new_width, new_height, resample_mode)
    
    shape = size(image);
    w = shape(1);  
    h = shape(2); 
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    resized_image = zeros(new_width,new_height,b,'single');
    
    for i=1:b
        resized_image(:,:,i) = resizeimage_band(image(:,:,i), new_width, new_height, resample_mode);
    end
    
end

function resized_image_band = resizeimage_band(image_band, new_width, new_height, resample_mode)

    shape = size(image_band);
    w = shape(1);  
    h = shape(2); 
   
    ptr = libpointer('singlePtr',image_band);
    
    resized_image_band = zeros(new_width,new_height,'single');
    resized_ptr = libpointer('singlePtr',resized_image_band);
    
    result = calllib('libvigra_c','vigra_resizeimage_c', ptr, resized_ptr, w,h, new_width, new_height, uint8(resample_mode));
    
    switch result
        case 0
            resized_image_band = resized_ptr.Value;
        case 1
            error('Error in vigramatlab.imgproc:resizeimage: Resize of image failed!')
        case 2
            error('Error in vigramatlab.imgproc:resizeimage: Resample mode must be in {0,1,2,3,4}!')
    end
end