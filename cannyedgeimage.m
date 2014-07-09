function edge_image = cannyedgeimage(image, scale, gradient_treshold, mark)
    
    shape = size(image);
    h = shape(1);
    w = shape(2);
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    edge_image = zeros(h,w,b,'single');
    
    for i=1:b
        edge_image(:,:,i) = cannyedgeimage_band(image(:,:,i), scale, gradient_treshold, mark);
    end
    
end

function edge_image_band = cannyedgeimage_band(image_band, scale, gradient_treshold, mark)
    
    shape = size(image_band);
    h = shape(1);
    w = shape(2);
   
    ptr = libpointer('singlePtr',image_band');
    
    edge_image_band = zeros(w,h,'single');
    edge_ptr = libpointer('singlePtr',edge_image_band);
    
    result = calllib('libvigra_c','vigra_cannyedgeimage_c', ptr, edge_ptr, w,h, single(scale), single(gradient_treshold), single(mark));
    
    switch result
        case 0
            edge_image_band = edge_ptr.Value';
        case 1
            error('Error in vigramatlab.segmentation.cannyedgeimage: Computation of Canny Edge image failed!')
    end
end