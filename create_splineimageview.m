function siv_image = create_splineimageview(image, degree)
    
    shape = size(image);
    w = shape(1);  
    h = shape(2); 
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    for i=1:b
        siv_image(i) = struct('name', 'vigramatlab_SIV', 'degree', degree, 'address', create_splineimageview_band(image(:,:,i), uint8(degree)));
    end
    
end

function siv_address = create_splineimageview_band(image_band, degree)
    
    shape = size(image_band);
    w = shape(1);  
    h = shape(2); 
   
    ptr = libpointer('singlePtr',image_band);
    
    if (degree > 0 && degree < 6)
        function_name = ['vigra_create_splineimageview', num2str(degree), '_address_c'];
        siv_address = calllib('libvigra_c',function_name, ptr, w,h);
    else
        error('Error in vigramatlab.splineimageview.create: Degree has to be within [1, .., 5]')
    end
end