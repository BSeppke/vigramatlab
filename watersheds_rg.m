function labeled_image = watersheds_rg(image, varargin)
    if nargin > 1
        seeds =  varargin{1};
    else
        seeds = labelimage(localminima(image))-1;
    end
    eight_connectivity = 1;
    keep_contours = 0;
    use_turbo = 0;
    stop_cost = -1.0;
    if nargin > 2, eight_connectivity = varargin{2};end
    if nargin > 3, keep_contours = varargin{3};end
    if nargin > 4, use_turbo = varargin{4};end
    if nargin > 5, stop_cost = varargin{5};end
    
    shape = size(image);
    h = shape(1);
    w = shape(2);
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    labeled_image = zeros(h,w,b,'single');
    
    for i=1:b
        labeled_image(:,:,i) = watersheds_rg_band(image(:,:,i), seeds(:,:,i), eight_connectivity, keep_contours, use_turbo, stop_cost);
    end
    
end

function labeled_image_band = watersheds_rg_band(image_band, varargin)
    if nargin > 1
        seeds_band =  varargin{1};
    else
        seeds_band = labelimage_band(localminima_band(image_band))-1;
    end
    eight_connectivity = 1;
    keep_contours = 0;
    use_turbo = 0;
    stop_cost = -1.0;
    if nargin > 2, eight_connectivity = varargin{2};end
    if nargin > 3, keep_contours = varargin{3};end
    if nargin > 4, use_turbo = varargin{4};end
    if nargin > 5, stop_cost = varargin{5};end

    shape = size(image_band);
    h = shape(1);
    w = shape(2);
   
    ptr = libpointer('singlePtr',image_band');
    label_ptr = libpointer('singlePtr',seeds_band');
    
    result = calllib('libvigra_c','vigra_watershedsregiongrowing_c', ptr, label_ptr, w,h, eight_connectivity, keep_contours, use_turbo, stop_cost);
    
    if ( result == -1 )
        error('Error in vigramatlab.segmentation.watersheds_rg: Region-Growing Watersheds Transform of image failed!')
    else
        labeled_image_band = label_ptr.Value';
    end
end