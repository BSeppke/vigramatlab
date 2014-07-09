function result = saveimage( image, filename )

	result = 1;
    
    shape = size(image);
    h = shape(1);
    w = shape(2);
    b = 1;
    
    sshape = size(shape);
    
    if ( sshape(2) == 3 )
        b = shape(3);
    end
    
    if( b == 1 )
        ptr = libpointer('singlePtr',image');
        result = calllib('libvigra_c','vigra_exportgrayimage_c', ptr , w,h, filename);
    end
    if( b == 3 )
        img_r = image(:,:,1)';
        img_g = image(:,:,2)';
        img_b = image(:,:,3)';

        r_ptr = libpointer('singlePtr',img_r);
        g_ptr = libpointer('singlePtr',img_g);
        b_ptr = libpointer('singlePtr',img_b);

        result = calllib('libvigra_c','vigra_exportrgbimage_c', r_ptr ,g_ptr, b_ptr, w,h, filename);
    end
end
