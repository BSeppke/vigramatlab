function dilated_image = dilateimage(image, radius)
    
    shape = size(image);
    w = shape(1);  
    h = shape(2); 
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    dilated_image = zeros(w,h,b,'single');
    
    for i=1:b
        dilated_image(:,:,i) = dilateimage_band(image(:,:,i), radius);
    end
    
end

function dilated_image_band = dilateimage_band(image_band, radius)
    
    shape = size(image_band);
    w = shape(1);  
    h = shape(2); 
   
    ptr = libpointer('singlePtr',image_band);
    
    dilated_image_band = zeros(w,h,'single');
    dilated_ptr = libpointer('singlePtr',dilated_image_band);
    
    result = calllib('libvigra_c','vigra_dilateimage_c', ptr, dilated_ptr, w,h, single(radius));
    
    switch result
        case 0
            dilated_image_band = dilated_ptr.Value;
        case 1
            error('Error in vigramatlab.morphology.dilateimage: Dilation of image failed!')
    end
end