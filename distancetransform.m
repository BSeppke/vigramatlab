function distance_image = distancetransform(image, background_label, distance_metric)
    
    shape = size(image);
    h = shape(1);
    w = shape(2);
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    distance_image = zeros(h,w,b,'single');
    
    for i=1:b
        distance_image(:,:,i) = distancetransform_band(image(:,:,i), background_label, distance_metric);
    end
    
end

function distance_image_band = distancetransform_band(image_band, background_label, distance_metric)
    
    shape = size(image_band);
    h = shape(1);
    w = shape(2);
   
    ptr = libpointer('singlePtr',image_band');
    
    distance_image_band = zeros(w,h,'single');
    distance_ptr = libpointer('singlePtr',distance_image_band);
    
    result = calllib('libvigra_c','vigra_distancetransform_c', ptr, distance_ptr, w,h, single(background_label), uint8(distance_metric));
    
    switch result
        case 0
            distance_image_band = distance_ptr.Value';
        case 1
            error('Error in vigramatlab.imgproc:distancetransform: Distance transform of image failed!')
        case 2
            error('Error in vigramatlab.imgproc:distancetransform: Metric must be in {0, 1, 2}!')
    end
end