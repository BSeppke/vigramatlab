function result = saveimage( image, filename )

	result = 1;
    
    shape = size(image);
    w = shape(1);
    h = shape(2);
    b = 1;
    
    sshape = size(shape);
    
    if ( sshape(2) == 3 )
        b = shape(3);
    end
    
    if( b == 1 )
        ptr = libpointer('singlePtr',image);
        result = calllib('libvigra_c','vigra_exportgrayimage_c', ptr, w,h, filename);
    elseif( b == 3 )
        img_r = image(:,:,1);
        img_g = image(:,:,2);
        img_b = image(:,:,3);

        r_ptr = libpointer('singlePtr',img_r);
        g_ptr = libpointer('singlePtr',img_g);
        b_ptr = libpointer('singlePtr',img_b);

        result = calllib('libvigra_c','vigra_exportrgbimage_c', r_ptr, g_ptr, b_ptr, w,h, filename);
    elseif( b == 4 )
        img_r = image(:,:,1);
        img_g = image(:,:,2);
        img_b = image(:,:,3);
        img_a = image(:,:,4);

        r_ptr = libpointer('singlePtr',img_r);
        g_ptr = libpointer('singlePtr',img_g);
        b_ptr = libpointer('singlePtr',img_b);
        a_ptr = libpointer('singlePtr',img_a);

        result = calllib('libvigra_c','vigra_exportrgbaimage_c', r_ptr, g_ptr, b_ptr, a_ptr, w,h, filename);
    else       
        error('vigramatlab.impex.saveimage: Image cannot be saved by vigra! Image numBands must be 1, 3 or 4')
    end
end
