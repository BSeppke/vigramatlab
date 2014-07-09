function  delete_splineimageview(siv_image)
    
    shape = size(siv_image);
    b = shape(1);
       
    for i=1:b
        assert(strcmp(siv_image(i).name, 'vigramatlab_SIV'), 'Error in vigramatlab.splineimageview.delete: Wrong structure given!')
        delete_splineimageview_band(siv_image(i).address, uint8(siv_image(i).degree));
        
        siv_image(i).name = 'freed pointer';
        siv_image(i).degree = 0;
        siv_image(i).address = 0;
    end
end

function delete_splineimageview_band(siv_address, degree)

    if (degree > 0 && degree < 6)
        if(siv_address > 0)
            function_name = ['vigra_delete_splineimageview', num2str(degree), '_by_address_c'];
            calllib('libvigra_c',function_name, siv_address);
        else
           error('Error in vigramatlab.splineimageview.delete: Cannot free null-pointer!')
        end
    else
        error('Error in vigramatlab.splineimageview.delete: Degree has to be within [1, .., 5]')
    end
end