function labeled_image = watersheds_uf(image, varargin)
    eight_connectivity = 1;
    if nargin > 1, eight_connectivity = varargin{1};end
    
    shape = size(image);
    h = shape(1);
    w = shape(2);
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    labeled_image = zeros(h,w,b,'single');
    
    for i=1:b
        labeled_image(:,:,i) = watersheds_uf_band(image(:,:,i), eight_connectivity);
    end
    
end

function labeled_image_band = watersheds_uf_band(image_band, varargin)
    eight_connectivity = 1;
    if nargin > 1, eight_connectivity = varargin{1};end

    shape = size(image_band);
    h = shape(1);
    w = shape(2);
   
    ptr = libpointer('singlePtr',image_band');
    
    labeled_image_band = zeros(w,h,'single');
    label_ptr = libpointer('singlePtr',labeled_image_band);
    
    result = calllib('libvigra_c','vigra_watershedsunionfind_c', ptr, label_ptr, w,h, eight_connectivity);
    
    if ( result == -1 )
        error('Error in vigramatlab.segmentation.watersheds_uf: Union-Find Watersheds Transform of image failed!')
    else
        labeled_image_band = label_ptr.Value';
    end
end