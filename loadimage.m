function image = loadimage( filename )

    w = calllib('libvigra_c','vigra_imagewidth_c', filename);
    h = calllib('libvigra_c','vigra_imageheight_c',filename);
    b = calllib('libvigra_c','vigra_imagenumbands_c',filename);
    
    if( b == 1 )
        image = zeros(w,h,'single');
        ptr = libpointer('singlePtr',image);

        result = calllib('libvigra_c','vigra_importgrayimage_c', ptr , w,h,filename);
        
        switch result
            case 0
                image = ptr.Value;
            case 1
                error('vigramatlab.impex.loadgraybimage: Image cannot be loaded by vigra!')
            case 2
                error('vigramatlab.impex.loadgrayimage: Image is not grayscale!')
            case 3
                error('vigramatlab.impex.loadgrayimage: Sizes do not match!')
        end
    elseif( b == 3 )
        img_r = zeros(w,h,'single');
        img_g = zeros(w,h,'single');
        img_b = zeros(w,h,'single');

        r_ptr = libpointer('singlePtr',img_r);
        g_ptr = libpointer('singlePtr',img_g);
        b_ptr = libpointer('singlePtr',img_b);

        result = calllib('libvigra_c','vigra_importrgbimage_c', r_ptr ,g_ptr, b_ptr, w,h,filename);

        switch result
            case 0
                image = zeros(w,h,3, 'single');
                image(:,:,1) = r_ptr.Value;
                image(:,:,2) = g_ptr.Value;
                image(:,:,3) = b_ptr.Value;
            case 1
                error('vigramatlab.impex.loadrgbimage: Image cannot be loaded by vigra!')
            case 2
                error('vigramatlab.impex.loadrgbimage: Image is not rgb!')
            case 3
                error('vigramatlab.impex.loadrgbimage: Sizes do not match!')
        end
    elseif( b == 4 )
        img_r = zeros(w,h,'single');
        img_g = zeros(w,h,'single');
        img_b = zeros(w,h,'single');
        img_a = zeros(w,h,'single');

        r_ptr = libpointer('singlePtr',img_r);
        g_ptr = libpointer('singlePtr',img_g);
        b_ptr = libpointer('singlePtr',img_b);
        a_ptr = libpointer('singlePtr',img_a);

        result = calllib('libvigra_c','vigra_importrgbaimage_c', r_ptr ,g_ptr, b_ptr, a_ptr, w,h,filename);

        switch result
            case 0
                image = zeros(w,h,4, 'single');
                image(:,:,1) = r_ptr.Value;
                image(:,:,2) = g_ptr.Value;
                image(:,:,3) = b_ptr.Value;
                image(:,:,4) = a_ptr.Value;
            case 1
                error('vigramatlab.impex.loadrgbaimage: Image cannot be loaded by vigra!')
            case 2
                error('vigramatlab.impex.loadrgbaimage: Image is not rgb!')
            case 3
                error('vigramatlab.impex.loadrgbaimage: Sizes do not match!')
        end
    else
        error('vigramatlab.impex.loadimage: Image cannot be loaded by vigra! Image numBands must be 1, 3 or 4')
    end
end
