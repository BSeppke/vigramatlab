function [filtered_xx, filtered_xy, filtered_yy] = hourglassfilter(image_xx, image_xy, image_yy, sigma, rho)
    
    shape = size(image_xx);
    h = shape(1);
    w = shape(2);
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    if (nargout < 3)
        error('Error in vigramatlab.filters.hourglassfilter: Please provide 3 arrays for filtered tensor results!')
    else
        filtered_xx = zeros(h,w,b,'single');
        filtered_xy = zeros(h,w,b,'single');
        filtered_yy  = zeros(h,w,b,'single');
        for i=1:b
            [filtered_xx(:,:,i), filtered_xy(:,:,i), filtered_yy(:,:,i)] = hourglassfilter_band(image_xx(:,:,i), image_xy(:,:,i), image_yy(:,:,i), sigma, rho);
        end
    end    
end

function [image_band_filtered_xx, image_band_filtered_xy, image_band_filtered_yy] = hourglassfilter_band(image_band_xx, image_band_xy, image_band_yy, sigma, rho)

    shape = size(image_band_xx);
    h = shape(1);
    w = shape(2);
   
    xx_ptr = libpointer('singlePtr',image_band_xx');
    xy_ptr = libpointer('singlePtr',image_band_xy');
    yy_ptr = libpointer('singlePtr',image_band_yy');
    
    image_band_filtered_xx = zeros(w,h,'single');
    f_xx_ptr = libpointer('singlePtr',image_band_filtered_xx);
    
    image_band_filtered_xy = zeros(w,h,'single');
    f_xy_ptr = libpointer('singlePtr',image_band_filtered_xy);
    
    image_band_filtered_yy = zeros(w,h,'single');
    f_yy_ptr = libpointer('singlePtr',image_band_filtered_yy);
    
    result = calllib('libvigra_c','vigra_hourglassfilter_c', xx_ptr, xy_ptr, yy_ptr, f_xx_ptr,f_xy_ptr, f_yy_ptr, w,h, single(sigma), single(rho));
    
    switch result
        case 0
            image_band_filtered_xx = f_xy_ptr.Value';
            image_band_filtered_xy = f_xx_ptr.Value';
            image_band_filtered_yy = f_yy_ptr.Value';
        case 1
            error('Error in vigramatlab.filters.hourglassfilter: Computation of Hourglass Filter for Tensor failed!')
    end        
end