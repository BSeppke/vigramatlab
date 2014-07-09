function [ew_maj, ew_min, edgeness] = tensortoedgecorner(image_xx, image_xy, image_yy)
    
    shape = size(image_xx);
    h = shape(1);
    w = shape(2);
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    if (nargout < 3)
        error('Error in vigramatlab.filters.tensortoedgecorner: Please provide 3 arrays for maj. ew, min. ew and edgeness results!')
    else
        ew_maj = zeros(h,w,b,'single');
        ew_min = zeros(h,w,b,'single');
        edgeness  = zeros(h,w,b,'single');
        for i=1:b
            [ew_maj(:,:,i), ew_min(:,:,i), edgeness(:,:,i)] = tensortoedgecorner_band(image_xx(:,:,i), image_xy(:,:,i), image_yy(:,:,i));
        end
    end    
end

function [image_band_ew_maj, image_band_ew_min, image_band_edgeness] = tensortoedgecorner_band(image_band_xx, image_band_xy, image_band_yy)

    shape = size(image_band_xx);
    h = shape(1);
    w = shape(2);
   
    xx_ptr = libpointer('singlePtr',image_band_xx');
    xy_ptr = libpointer('singlePtr',image_band_xy');
    yy_ptr = libpointer('singlePtr',image_band_yy');
    
    image_band_ew_maj = zeros(w,h,'single');
    min_ptr = libpointer('singlePtr',image_band_ew_maj);
    
    image_band_ew_min = zeros(w,h,'single');
    maj_ptr = libpointer('singlePtr',image_band_ew_min);
    
    image_band_edgeness = zeros(w,h,'single');
    edge_ptr = libpointer('singlePtr',image_band_edgeness);
    
    result = calllib('libvigra_c','vigra_tensortoedgecorner_c', xx_ptr, xy_ptr, yy_ptr, min_ptr,maj_ptr, edge_ptr, w,h);
    
    switch result
        case 0
            image_band_ew_maj = maj_ptr.Value';
            image_band_ew_min = min_ptr.Value';
            image_band_edgeness  = edge_ptr.Value';
        case 1
            error('Error in vigramatlab.filters.tensortoedgecorner: Computation of Eigen/Corner Representation for Tensor failed!')
    end        
end