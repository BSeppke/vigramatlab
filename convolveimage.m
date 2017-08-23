function convolved_image = convolveimage(image, matrix, border_treatment)
    
    narginchk(2, 3)
    
    if nargin < 3
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
    
    for i=1:b
        convolved_image(:,:,i) = convolveimage_band(image(:,:,i), double(matrix), border_treatment);
    end
end

function convolved_image_band = convolveimage_band(image_band, matrix, border_treatment)
    
    narginchk(2, 3)
    
    if nargin < 3
       border_treatment = 3;
    end
    
    shape = size(image_band);
    w = shape(1);  
    h = shape(2); 
   
    k_shape = size(matrix);
    k_w = k_shape(1);
    k_h = k_shape(2);
  
    ptr = libpointer('singlePtr',image_band);
    
    ptr_mat = libpointer('doublePtr',matrix);
    
    convolved_image_band = zeros(w,h,'single');
    convolved_ptr = libpointer('singlePtr',convolved_image_band);
    
    result = calllib('libvigra_c','vigra_convolveimage_c', ptr, ptr_mat, convolved_ptr, w,h, k_w, k_h, border_treatment);
    
    switch result
        case 0
            convolved_image_band = convolved_ptr.Value;
        case 1
            error('Error in vigramatlab.filters.convolveimage: Convolution failed!')
        case 2
            error('Error in vigramatlab.filters.convolveimage: Kernels must be of odd size!')
        case 3
            error('Error in vigramatlab.filters.convolveimage: Border mode must be within [0, ..., 5]!')
    end
end
