function reflected_image = reflectimage(image, reflect_mode)
    
    shape = size(image);
    h = shape(1);
    w = shape(2);
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    reflected_image = zeros(h,w,b,'single');
    
    for i=1:b
        reflected_image(:,:,i) = reflectimage_band(image(:,:,i), reflect_mode);
    end
    
end

function reflected_image_band = reflectimage_band(image_band, reflect_mode)

    shape = size(image_band);
    h = shape(1);
    w = shape(2);
   
    ptr = libpointer('singlePtr',image_band');
    
    reflected_image_band = zeros(w,h,'single');
    reflected_ptr = libpointer('singlePtr',reflected_image_band);
    
    result = calllib('libvigra_c','vigra_reflectimage_c', ptr, reflected_ptr, w,h, uint8(reflect_mode));
    
    switch result
        case 0
            reflected_image_band = reflected_ptr.Value';
        case 1
            error('Error in vigramatlab.imgproc:reflectimage: Reflection of image failed!')
        case 2
            error('Error in vigramatlab.imgproc:reflectimage: Reflection mode must be in {1 (= horizontal), 2 (= vertical), 3 (=both)}!')
    end
end