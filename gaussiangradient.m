function [x_gradient, y_gradient] = gaussiangradient(image, sigma)
    
    shape = size(image);
    w = shape(1);  
    h = shape(2); 
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    x_gradient = zeros(w,h,b,'single');
    
    if (nargout ==1)
        for i=1:b
           x_gradient(:,:,i) = gaussiangradient_band(image(:,:,i), sigma);
        end
    else
        y_gradient = zeros(w,h,b,'single');
        for i=1:b
            [x_gradient(:,:,i), y_gradient(:,:,i)] = gaussiangradient_band(image(:,:,i), sigma);
        end
    end    
end

function [x_gradient, y_gradient] = gaussiangradient_band(image_band, sigma)

    shape = size(image_band);
    w = shape(1);  
    h = shape(2); 
   
    ptr = libpointer('singlePtr',image_band);
    
    x_gradient = zeros(w,h,'single');
    x_ptr = libpointer('singlePtr',x_gradient);
    
    if (nargout == 1)
        result = calllib('libvigra_c','vigra_gaussiangradientmagnitude_c', ptr, x_ptr, w,h, single(sigma));
            
        switch result
            case 0
                x_gradient = x_ptr.Value;
            case 1
               error('Error in vigramatlab.filters.gaussiangradientmagnitude: Gaussian gradient magnitude failed!')
        end
    else
        y_gradient = zeros(w,h,'single');
        y_ptr = libpointer('singlePtr',y_gradient);
    
        result = calllib('libvigra_c','vigra_gaussiangradient_c', ptr, x_ptr, y_ptr, w,h, single(sigma));
        
        switch result
            case 0
                x_gradient = x_ptr.Value;
                y_gradient = y_ptr.Value;
            case 1
               error('Error in vigramatlab.filters.gaussiangradient: Gaussian gradient failed!')
        end        
    end
end