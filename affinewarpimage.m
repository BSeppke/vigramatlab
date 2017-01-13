function transformed_image = affinewarpimage(image, affineMat, resample_mode)
    
    shape = size(image);
    w = shape(1);
    h = shape(2);
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    transformed_image = zeros(w,h,b,'single');
    
    for i=1:b
        transformed_image(:,:,i) = affinewarpimage_band(image(:,:,i), affineMat, resample_mode);
    end
    
end

function transformed_image_band = affinewarpimage_band(image_band, affineMat, resample_mode)

    shape = size(image_band);
    w = shape(1);
    h = shape(2);
   
    ptr = libpointer('singlePtr',image_band);
    
    doubleMat = double(affineMat);
    ptrMat = libpointer('doublePtr',doubleMat);
    
    transformed_image_band = zeros(w,h,'single');
    transformed_ptr = libpointer('singlePtr',transformed_image_band);
    
    result = calllib('libvigra_c','vigra_affinewarpimage_c', ptr, ptrMat, transformed_ptr, w,h, uint8(resample_mode));
    
    switch result
        case 0
            transformed_image_band = transformed_ptr.Value;
        case 1
            error('Error in vigramatlab.imgproc:affinewarpimage: Affine Transformation of image failed!')
        case 2
            error('Error in vigramatlab.imgproc:affinewarpimage: Resample mode must be in {0,1,2,3,4}!')
    end
end
