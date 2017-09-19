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
        region_stats = zeros(22, max(max_label)+1, b, 'single');
        for i=1:b
            region_stats(:, 1:max_label(:,:,i)+1, i) = extractfeatures_band(image(:,:,i), label_image(:,:,i), max_label(:,:,i));
        end
    end
end

%  The following features will be extracted for each region of each band:
%  
%   | Index         | Feature                                |
%   | ------------- | -------------------------------------- |
%   |  0            | region_size                            |
%   |  1,  2        | upperleft-x and y-coord                |
%   |  3,  4        | lowerright-x and y-coord               |
%   |  5,  6        | mean-x and y-coord                     |
%   |  7            | min grey value                         |
%   |  8            | max grey value                         |
%   |  9            | mean grey value                        |
%   | 10            | std.dev. grey value                    |
%   | 11, 12        | major ev: x and y-coord                |
%   | 13, 14        | minor ev: x and y-coord                |
%   | 15            | major ew                               |
%   | 16            | minor ew                               |
%   | 17, 18        | grey value weighted mean-x and y-coord |
%   | 19            | perimeter (region contour length)      |
%   | 20            | skewness                               |
%   | 21            | kurtosis                               |
function region_stats_band = extractfeatures_band(image_band, label_band, max_label)
    if(nargin < 3)
        max_label = max(label_image);
    end

    shape = size(image_band);
    w = shape(1);  
    h = shape(2); 
   
    ptr = libpointer('singlePtr',image_band);
    label_ptr = libpointer('singlePtr',label_band);
    
    region_stats_band = zeros(22, max_label+1, 'single');
    region_stats_ptr = libpointer('singlePtr',region_stats_band);
    
    result = calllib('libvigra_c','vigra_extractfeatures_gray_c', ptr, label_ptr, region_stats_ptr, w,h, max_label);
    
    if ( result == -1 )
        error('Error in vigramatlab.segmentation.extractfeatures_gray: Derivation of region statistics failed!')
    else
        region_stats_band = region_stats_ptr.Value;
    end
end

%  The following features will be extracted for each rgb-region:
%  
%   | Index         | Feature                              |
%   | ------------- | ------------------------------------ |
%   |  0            | region_size                          |
%   |  1,  2        | upperleft-x and y-coord              |
%   |  3,  4        | lowerright-x and y-coord             |
%   |  5,  6        | mean-x and y-coord                   |
%   |  7,  8,  9    | min red,green,blue value             |
%   | 10, 11, 12    | max red,green,blue value             |
%   | 13, 14, 15    | mean red,green,blue value            |
%   | 16, 17, 18    | std.dev. red,green,blue value        |
%   | 19, 20        | major ev: x and y-coord              |
%   | 21, 22        | minor ev: x and y-coord              |
%   | 23            | major ew                             |
%   | 24            | minor ew                             |
%   | 25, 26        | luminace weighted mean-x and y-coord |
%   |               | L = 0.3*R + 0.59*G + 0.11*B          |
%   | 27            | perimeter (region contour length)    |
%   | 28, 29, 30    | skewness (red, green, blue)          |
%   | 31, 32, 33    | kurtosis (red, green, blue)          |
function region_stats_rgb = extractfeatures_rgb(image_band_r, image_band_g, image_band_b, label_band, max_label)
    if(nargin < 3)
        max_label = max(label_image);
    end
    
    shape = size(image_band_r);
    w = shape(1);  
    h = shape(2); 
   
    ptr_r = libpointer('singlePtr',image_band_r);
    ptr_g = libpointer('singlePtr',image_band_g);
    ptr_b = libpointer('singlePtr',image_band_b);
    
    label_ptr = libpointer('singlePtr',label_band');
    
    region_stats_rgb = zeros(34, max_label+1, 'single');
    region_stats_ptr = libpointer('singlePtr',region_stats_rgb);
    
    result = calllib('libvigra_c','vigra_extractfeatures_rgb_c', ptr_r, ptr_g, ptr_b, label_ptr, region_stats_ptr, w,h, max_label);
    
    if ( result == -1 )
        error('Error in vigramatlab.segmentation.extractfeatures_rgb:  Derivation of region statistics failed!')
    else
        region_stats_rgb = region_stats_ptr.Value;
    end
end
