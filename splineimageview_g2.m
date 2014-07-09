function  value = splineimageview_g2(siv_image, x, y, x_order, y_order)
    
    shape = size(siv_image);
    b = shape(2);
    
    value = zeros(b,1,'single');
    
    for i=1:b
        assert(strcmp(siv_image(i).name, 'vigramatlab_SIV'), 'Error in vigramatlab.splineimageview.g2: Wrong structure given!')
        value(i) = splineimageview_g2_band(siv_image(i).address, uint8(siv_image(i).degree), x, y, x_order, y_order);
    end
end

function band_value = splineimageview_g2_band(siv_address, degree, x, y,  x_order, y_order)
    
    if (degree > 0 && degree < 6) 
        if(siv_address > 0)
            
            function_name = ['vigra_splineimageview', num2str(degree), derivative_function_name(x_order,y_order),'_by_address_c'];
            band_value = calllib('libvigra_c',function_name, siv_address, double(x), double(y));
        else
           error('Error in vigramatlab.splineimageview.g2: Cannot access null-pointer!')
        end
    else
        error('Error in vigramatlab.splineimageview.g2: Degree has to be within [1, .., 5]')
    end
end

function function_string = derivative_function_name(x_order, y_order)

    assert( (x_order+y_order >= 0) && (x_order+y_order < 3), 'Error in vigramatlab.splineimageview.g2: wrong derviative degrees (0 <= x+y_order <= 3)')

    function_string = '_g2';
    
    if x_order == 1
        function_string = [function_string,'x'];
    elseif x_order == 2
        function_string = [function_string,'xx'];
    end
    
    if y_order == 1
        function_string = [function_string,'y'];
    elseif y_order == 2
        function_string = [function_string,'yy'];
    end    
end
