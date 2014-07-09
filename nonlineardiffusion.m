function smoothed_image = nonlineardiffusion(image, edge_treshold, scale)
    
    shape = size(image);
    h = shape(1);
    w = shape(2);
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    smoothed_image = zeros(h,w,b,'single');
    
    for i=1:b
        smoothed_image(:,:,i) = nonlineardiffusion_band(image(:,:,i),edge_treshold, scale);
    end
    
end

function smoothed_image_band = nonlineardiffusion_band(image_band, edge_threshold, scale)

    shape = size(image_band);
    h = shape(1);
    w = shape(2);
   
    ptr = libpointer('singlePtr',image_band');
    
    smoothed_image_band = zeros(w,h,'single');
    smooth_ptr = libpointer('singlePtr',smoothed_image_band);
    
    result = calllib('libvigra_c','vigra_nonlineardiffusion_c', ptr, smooth_ptr, w,h, single(edge_threshold), single(scale));
    
    switch result
        case 0
            smoothed_image_band = smooth_ptr.Value';
        case 1
            error('Error in vigramatlab.filters.nonlineardiffusion: Nonlinear Diffusion failed!')
    end
end