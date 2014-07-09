function [image_xx, image_xy, image_yy] = hessianmatrixofgaussian(image, scale)
    
    shape = size(image);
    h = shape(1);
    w = shape(2);
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    if (nargout < 3)
        error('Error in vigramatlab.filters.hessianmatrixofgaussian: Please provide 3 arrays for I_xx, I_xy and I_yy results!')
    else
        image_xx = zeros(h,w,b,'single');
        image_xy = zeros(h,w,b,'single');
        image_yy = zeros(h,w,b,'single');
        for i=1:b
            [image_xx(:,:,i), image_xy(:,:,i), image_yy(:,:,i)] = hessianmatrixofgaussian_band(image(:,:,i), scale);
        end
    end    
end

function [image_band_xx, image_band_xy, image_band_yy] = hessianmatrixofgaussian_band(image_band, scale)

    shape = size(image_band);
    h = shape(1);
    w = shape(2);
   
    ptr = libpointer('singlePtr',image_band');
    
    image_band_xx = zeros(w,h,'single');
    xx_ptr = libpointer('singlePtr',image_band_xx);
    
    image_band_xy = zeros(w,h,'single');
    xy_ptr = libpointer('singlePtr',image_band_xy);
    
    image_band_yy = zeros(w,h,'single');
    yy_ptr = libpointer('singlePtr',image_band_yy);
    
    result = calllib('libvigra_c','vigra_hessianmatrixofgaussian_c', ptr, xx_ptr, xy_ptr, yy_ptr, w,h, single(scale));
    
    switch result
        case 0
            image_band_xx = xx_ptr.Value';
            image_band_xy = xy_ptr.Value';
            image_band_yy = yy_ptr.Value';
        case 1
            error('Error in vigramatlab.filters.hessianmatrixofgaussian: Hessian matrix of gaussian failed!')
    end        
end