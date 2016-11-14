function convolved_image = convolveimage(image, h_or_complete_matrix, v_matrix)

    narginchk(2, 3)

    shape = size(image);
    h = shape(1);
    w = shape(2);
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
        
    convolved_image = zeros(h,w,b,'single');
    
    if(nargin == 2)
        for i=1:b
            convolved_image(:,:,i) = convolveimage_band(image(:,:,i), double(h_or_complete_matrix));
        end
    elseif(nargin == 3)
        k1_shape = size(h_or_complete_matrix);
        k1_h = k1_shape(1);
        
        k2_shape = size(v_matrix);
        k2_w = k2_shape(2);
        
        if(k1_h == 1 && k2_w ==1)
            for i=1:b
                convolved_image(:,:,i) = separableconvolveimage_band(image(:,:,i), double(h_or_complete_matrix), double(v_matrix));
            end
        else
            error('Error in vigramatlab.filters.convolveimage: Separated kernels are not fitting properly!')
        end
    else
        error('Error in vigramatlab.filters.convolveimage: Please call with one or two (separated) kernels!')
    end
end

function convolved_image_band = convolveimage_band(image_band, matrix)

    shape = size(image_band);
    h = shape(1);
    w = shape(2);
   
    k_shape = size(matrix);
    k_h = k_shape(1);
    k_w = k_shape(2);
  
    ptr = libpointer('singlePtr',image_band');
    
    ptr_mat = libpointer('doublePtr',matrix');
    
    convolved_image_band = zeros(w,h,'single');
    convolved_ptr = libpointer('singlePtr',convolved_image_band);
    
    result = calllib('libvigra_c','vigra_convolveimage_c', ptr, ptr_mat, convolved_ptr, w,h, k_w, k_h);
    
    switch result
        case 0
            convolved_image_band = convolved_ptr.Value';
        case 1
            error('Error in vigramatlab.filters.convolveimage: Convolution failed!')
    end
end

function convolved_image_band = separableconvolveimage_band(image_band, h_matrix, v_matrix)
    
    shape = size(image_band);
    h = shape(1);
    w = shape(2);
   
    k1_shape = size(h_matrix);
    k1_w = k1_shape(2); %x-kernel length
    
    k2_shape = size(v_matrix);
    k2_h = k2_shape(1); %y-kernel length
    
    ptr = libpointer('singlePtr',image_band');
    
    ptr_h = libpointer('doublePtr',h_matrix');
    ptr_v = libpointer('doublePtr',v_matrix');
    
    convolved_image_band = zeros(w,h,'single');
    convolved_ptr = libpointer('singlePtr',convolved_image_band);
    
    result = calllib('libvigra_c','vigra_separableconvolveimage_c', ptr, ptr_h, ptr_v, convolved_ptr, w,h, k1_w, k2_h);
    
    switch result
        case 0
            convolved_image_band = convolved_ptr.Value';
        case 1
            error('Error in vigramatlab.filters.separableconvolveimage: Separable convolution failed!')
    end
end
