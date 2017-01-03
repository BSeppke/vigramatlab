function region_stats = extractfeatures(image, label_image, max_label)
    if(nargin < 3)
        max_label = max(max(label_image));
    end

    shape = size(image);
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    label_b = 1;
    label_shape = size(label_image);

    if ( length(label_shape) == 3 )
        label_b = label_shape(3);
    end

    if( b == 3 && label_b == 1)
        region_stats = extractfeatures_rgb(image(:,:,1), image(:,:,2), image(:,:,3), label_image(:,:), max_label);
    else
        region_stats = zeros(max(max_label)+1,11,b,'single');
        for i=1:b
            region_stats(1:max_label(:,:,i)+1,:,i) = extractfeatures_band(image(:,:,i), label_image(:,:,i), max_label(:,:,i));
        end
    end
end

function region_stats_band = extractfeatures_band(image_band, label_band, max_label)
    if(nargin < 3)
        max_label = max(label_image);
    end

    shape = size(image_band);
    h = shape(1);
    w = shape(2);
   
    ptr = libpointer('singlePtr',image_band');
    label_ptr = libpointer('singlePtr',label_band');
    
    region_stats_band = zeros(max_label+1,11,'single');
    region_stats_ptr = libpointer('singlePtr',region_stats_band');
    
    result = calllib('libvigra_c','vigra_extractfeatures_gray_c', ptr, label_ptr, region_stats_ptr, w,h, max_label);
    
    if ( result == -1 )
        error('Error in vigramatlab.segmentation.extractfeatures_gray: Derivation of region statistics failed!')
    else
        region_stats_band = region_stats_ptr.Value';
    end
end

function region_stats_band = extractfeatures_rgb(image_band_r, image_band_g, image_band_b, label_band, max_label)
    if(nargin < 3)
        max_label = max(label_image);
    end
    
    shape = size(image_band_r);
    h = shape(1);
    w = shape(2);
   
    ptr_r = libpointer('singlePtr',image_band_r');
    ptr_g = libpointer('singlePtr',image_band_g');
    ptr_b = libpointer('singlePtr',image_band_b');
    
    label_ptr = libpointer('singlePtr',label_band');
    
    region_stats_band = zeros(max_label+1,19,'single');
    region_stats_ptr = libpointer('singlePtr',region_stats_band');
    
    result = calllib('libvigra_c','vigra_extractfeatures_rgb_c', ptr_r, ptr_g, ptr_b, label_ptr, region_stats_ptr, w,h, max_label);
    
    if ( result == -1 )
        error('Error in vigramatlab.segmentation.extractfeatures_rgb:  Derivation of region statistics failed!')
    else
        region_stats_band = region_stats_ptr.Value';
    end
end
