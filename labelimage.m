function labeled_image = labelimage(image, varargin)
    eight_connectivity = 1;
    if nargin > 1, eight_connectivity = varargin{1};end

    shape = size(image);
    w = shape(1);  
    h = shape(2); 
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    labeled_image = zeros(w,h,b,'single');
    
    for i=1:b
        if(nargin > 2)
            %Call with background handling
            labeled_image(:,:,i) = labelimage_band(image(:,:,i), eight_connectivity, varargin{2});
        else
            labeled_image(:,:,i) = labelimage_band(image(:,:,i), eight_connectivity);
        end
    end
    
end

function labeled_image_band = labelimage_band(image_band, varargin)
    eight_connectivity = 1;
    if nargin > 1, eight_connectivity = varargin{1};end
    
    shape = size(image_band);
    w = shape(1);  
    h = shape(2); 
   
    ptr = libpointer('singlePtr',image_band);
    
    labeled_image_band = zeros(w,h,'single');
    label_ptr = libpointer('singlePtr',labeled_image_band);
    
    if(nargin > 2)
        %Call with background handling
        result = calllib('libvigra_c','vigra_labelimagewithbackground_c', ptr, label_ptr, w,h, eight_connectivity, varargin{2});
    else
        result = calllib('libvigra_c','vigra_labelimage_c', ptr, label_ptr, w,h, eight_connectivity);
    end    
    if ( result == -1 )
        error('Error in vigramatlab.segmentation.labelimage: Labeling of image failed!')
    else
        labeled_image_band = label_ptr.Value;
    end
end