function convolved_image = separableconvolveimage(image, h_matrix, v_matrix, border_treatment)
    
    narginchk(3, 4)
    
    if nargin < 4
       border_treatment = 3;
    end
    
    shape = size(image);
    w = shape(1);  
    h = shape(2); 
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
        
    convolved_image = zeros(w,h,b,'single');
   
    k1_shape = size(h_matrix);
    k1_h = k1_shape(2);
        
    k2_shape = size(v_matrix);
    k2_w = k2_shape(1);
        
    if(k1_h == 1 && k2_w ==1)
        for i=1:b
            convolved_image(:,:,i) = separableconvolveimage_band(image(:,:,i), double(h_matrix), double(v_matrix), border_treatment);
        end
    else
        error('Error in vigramatlab.filters.separableconvolveimage: Separated kernels are not fitting properly!')
    end
end

function convolved_image_band = separableconvolveimage_band(image_band, h_matrix, v_matrix, border_treatment)
    
    narginchk(3, 4)
    
    if nargin < 4
       border_treatment = 3;
    end
    
    shape = size(image_band);
    w = shape(1);  
    h = shape(2); 
   
    k1_shape = size(h_matrix);
    k1_w = k1_shape(1); %x-kernel length
    
    k2_shape = size(v_matrix);
    k2_h = k2_shape(2); %y-kernel length
    
    ptr = libpointer('singlePtr',image_band);
    
    ptr_h = libpointer('doublePtr',h_matrix);
    ptr_v = libpointer('doublePtr',v_matrix);
    
    convolved_image_band = zeros(w,h,'single');
    convolved_ptr = libpointer('singlePtr',convolved_image_band);
    
    result = calllib('libvigra_c','vigra_separableconvolveimage_c', ptr, ptr_h, ptr_v, convolved_ptr, w,h, k1_w, k2_h, border_treatment);
    
    switch result
        case 0
            convolved_image_band = convolved_ptr.Value;
        case 1
            error('Error in vigramatlab.filters.separableconvolveimage: Separable convolution failed!')
        case 2
            error('Error in vigramatlab.filters.separableconvolveimage: Kernels must be of odd size!')
        case 3
            error('Error in vigramatlab.filters.separableconvolveimage: Border mode must be within [0, ..., 5]!')
    end
end
