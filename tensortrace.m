function trace = tensortrace(image_xx, image_xy, image_yy)
    
    shape = size(image_xx);
    w = shape(1);  
    h = shape(2); 
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    trace = zeros(w,h,b,'single');
    
    for i=1:b
        trace(:,:,i) = tensortrace_band(image_xx(:,:,i), image_xy(:,:,i), image_yy(:,:,i));
    end    
end

function image_band_trace = tensortrace_band(image_band_xx, image_band_xy, image_band_yy)

    shape = size(image_band_xx);
    w = shape(1);  
    h = shape(2); 
   
    xx_ptr = libpointer('singlePtr',image_band_xx');
    xy_ptr = libpointer('singlePtr',image_band_xy');
    yy_ptr = libpointer('singlePtr',image_band_yy');
    
    image_band_trace = zeros(w,h,'single');
    trace_ptr = libpointer('singlePtr',image_band_trace);
    
    result = calllib('libvigra_c','vigra_tensortrace_c', xx_ptr, xy_ptr, yy_ptr, trace_ptr, w,h);
    
    switch result
        case 0
            image_band_trace = trace_ptr.Value;
        case 1
            error('Error in vigramatlab.filters.tensortrace: Computation of Tensor trace failed!')
    end        
end