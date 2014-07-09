function  value = splineimageview_value(siv_image, x, y)
    
    shape = size(siv_image);
    b = shape(2);
    
    value = zeros(b,1,'single');
    
    for i=1:b
        assert(strcmp(siv_image(i).name, 'vigramatlab_SIV'), 'Error in vigramatlab.splineimageview.value: Wrong structure given!')
        value(i) = splineimageview_value_band(siv_image(i).address, uint8(siv_image(i).degree), x, y);
    end
end

function band_value = splineimageview_value_band(siv_address, degree, x, y)
    
    if (degree > 0 && degree < 6)
        if(siv_address > 0)
            function_name = ['vigra_splineimageview', num2str(degree), '_accessor_by_address_c'];
            band_value = calllib('libvigra_c',function_name, siv_address, double(x), double(y));
        else
           error('Error in vigramatlab.splineimageview.value: Cannot access null-pointer!')
        end
    else
        error('Error in vigramatlab.splineimageview.value: Degree has to be within [1, .., 5]')
    end
end