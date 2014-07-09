function crack_edge_image = regionimagetocrackedgeimage(image, mark)
    
    shape = size(image);
    h = shape(1);
    w = shape(2);
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    crack_edge_image = zeros(2*h-1,2*w-1,b,'single');
    
    for i=1:b
        crack_edge_image(:,:,i) = regionimagetocrackedgeimage_band(image(:,:,i), mark);
    end
    
end

function crack_edge_image_band = regionimagetocrackedgeimage_band(image_band, mark)
    
    shape = size(image_band);
    h = shape(1);
    w = shape(2);
   
    ptr = libpointer('singlePtr',image_band');
    
    crack_edge_image_band = zeros(2*w-1,2*h-1,'single');
    crack_edge_ptr = libpointer('singlePtr',crack_edge_image_band);
    
    result = calllib('libvigra_c','vigra_regionimagetocrackedgeimage_c', ptr, crack_edge_ptr, w,h, single(mark));
    
    if ( result == -1 )
        error('Error in vigramatlab.segmentation.regionimagetocrackedgeimage: Creation of CrackEdge image failed!')
    else
        crack_edge_image_band = crack_edge_ptr.Value';
    end
end