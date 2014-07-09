function rotated_image = rotateimage(image, angle, resample_mode)
    
    shape = size(image);
    h = shape(1);
    w = shape(2);
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    rotated_image = zeros(h,w,b,'single');
    
    for i=1:b
        rotated_image(:,:,i) = rotateimage_band(image(:,:,i), angle, resample_mode);
    end
    
end

function rotated_image_band = rotateimage_band(image_band, angle, resample_mode)
 
    shape = size(image_band);
    h = shape(1);
    w = shape(2);
   
    ptr = libpointer('singlePtr',image_band');
    
    rotated_image_band = zeros(w,h,'single');
    rotated_ptr = libpointer('singlePtr',rotated_image_band);
    
    result = calllib('libvigra_c','vigra_rotateimage_c', ptr, rotated_ptr, w,h, single(angle), uint8(resample_mode));
    
    switch result
        case 0
            rotated_image_band = rotated_ptr.Value';
        case 1
            error('Error in vigramatlab.imgproc:rotateimage: Rotation of image failed!')
        case 2
            error('Error in vigramatlab.imgproc:rotateimage: Resample mode must be in {0,1,2,3,4}!')
    end
end