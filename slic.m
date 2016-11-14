function labeled_image = slic(image, seedDistance, intensityScaling, iterations)
    switch nargin
        case 3
            iterations = 40;
        case 2
            iterations = 40;
            intensityScaling = 20.0;
        case 1
            iterations = 40;
            intensityScaling = 20.0;
            seedDistance = 15;
    end

    shape = size(image);
    h = shape(1);
    w = shape(2);
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end


    if( b == 3)
        labeled_image = zeros(h,w,1,'single');
        labeled_image(:,:,1) = slic_rgb(image(:,:,1), image(:,:,2), image(:,:,3), seedDistance, intensityScaling, iterations);
    else
        labeled_image = zeros(h,w,b,'single');
        for i=1:b
            labeled_image(:,:,i) = slic_band(image(:,:,i), seedDistance, intensityScaling, iterations);
        end
    end
end

function labeled_image_band = slic_band(image_band, seedDistance, intensityScaling, iterations)
    switch nargin
        case 3
            iterations = 40;
        case 2
            iterations = 40;
            intensityScaling = 20.0;
        case 1
            iterations = 40;
            intensityScaling = 20.0;
            seedDistance = 15;
    end

    shape = size(image_band);
    h = shape(1);
    w = shape(2);
   
    ptr = libpointer('singlePtr',image_band');
    
    labeled_image_band = zeros(w,h,'single');
    label_ptr = libpointer('singlePtr',labeled_image_band);
    
    result = calllib('libvigra_c','vigra_slic_gray_c', ptr, label_ptr, w,h, seedDistance, intensityScaling, iterations);
    
    if ( result == -1 )
        error('Error in vigramatlab.segmentation.slic_gray: SLIC segmentation of image failed!')
    else
        labeled_image_band = label_ptr.Value';
    end
end

function labeled_image_band = slic_rgb(image_band_r, image_band_g, image_band_b, seedDistance, intensityScaling, iterations)
    switch nargin
        case 3
            iterations = 40;
        case 2
            iterations = 40;
            intensityScaling = 20.0;
        case 1
            iterations = 40;
            intensityScaling = 20.0;
            seedDistance = 15;
    end
    
    shape = size(image_band_r);
    h = shape(1);
    w = shape(2);
   
    ptr_r = libpointer('singlePtr',image_band_r');
    ptr_g = libpointer('singlePtr',image_band_g');
    ptr_b = libpointer('singlePtr',image_band_b');
    
    labeled_image_band = zeros(w,h,'single');
    label_ptr = libpointer('singlePtr',labeled_image_band);
    
    result = calllib('libvigra_c','vigra_slic_rgb_c', ptr_r, ptr_g, ptr_b, label_ptr, w,h, seedDistance, intensityScaling, iterations);
    
    if ( result == -1 )
        error('Error in vigramatlab.segmentation.slic_rgb: SLIC segmentation of image failed!')
    else
        labeled_image_band = label_ptr.Value';
    end
end
