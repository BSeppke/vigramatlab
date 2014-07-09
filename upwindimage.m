function upwinded_image = upwindimage(image, radius)
    
    shape = size(image);
    h = shape(1);
    w = shape(2);
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    upwinded_image = zeros(h,w,b,'single');
    
    for i=1:b
        upwinded_image(:,:,i) = upwindimage_band(image(:,:,i), radius);
    end
    
end

function upwinded_image_band = upwindimage_band(image_band, radius)

    shape = size(image_band);
    h = shape(1);
    w = shape(2);
   
    ptr = libpointer('singlePtr',image_band');
    
    upwinded_image_band = zeros(w,h,'single');
    upwinded_ptr = libpointer('singlePtr',upwinded_image_band);
    
    result = calllib('libvigra_c','vigraext_upwindimage_c', ptr, upwinded_ptr, w,h, single(radius));
    
    switch result
        case 0
            upwinded_image_band = upwinded_ptr.Value';
        case 1
            error('Error in vigramatlab.morphology.upwindimage: Upwinding of image failed!')
    end
end