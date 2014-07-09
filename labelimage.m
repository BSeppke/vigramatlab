function labeled_image = labelimage(image)

    shape = size(image);
    h = shape(1);
    w = shape(2);
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    labeled_image = zeros(h,w,b,'single');
    
    for i=1:b
        labeled_image(:,:,i) = labelimage_band(image(:,:,i));
    end
    
end

function labeled_image_band = labelimage_band(image_band)
    
    shape = size(image_band);
    h = shape(1);
    w = shape(2);
   
    ptr = libpointer('singlePtr',image_band');
    
    labeled_image_band = zeros(w,h,'single');
    label_ptr = libpointer('singlePtr',labeled_image_band);
    
    result = calllib('libvigra_c','vigra_labelimage_c', ptr, label_ptr, w,h);
    
    if ( result == -1 )
        error('Error in vigramatlab.segmentation.labelimage: Labeling of image failed!')
    else
        labeled_image_band = label_ptr.Value';
    end
end