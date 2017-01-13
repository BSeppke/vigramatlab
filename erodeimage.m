function eroded_image = erodeimage(image, radius)
    
    shape = size(image);
    w = shape(1);  
    h = shape(2); 
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    eroded_image = zeros(w,h,b,'single');
    
    for i=1:b
        eroded_image(:,:,i) = erodeimage_band(image(:,:,i), radius);
    end
    
end

function eroded_image_band = erodeimage_band(image_band, radius)
    
    shape = size(image_band);
    w = shape(1);  
    h = shape(2); 
   
    ptr = libpointer('singlePtr',image_band);
    
    eroded_image_band = zeros(w,h,'single');
    eroded_ptr = libpointer('singlePtr',eroded_image_band);
    
    result = calllib('libvigra_c','vigra_erodeimage_c', ptr, eroded_ptr, w,h, single(radius));
    
    switch result
        case 0
            eroded_image_band = eroded_ptr.Value;
        case 1
            error('Error in vigramatlab.morphology.erodeimage: Erosion of image failed!')
    end
end