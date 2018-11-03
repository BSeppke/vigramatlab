function maxima_image = localmaxima(image, varargin)
    eight_connectivity = 1;
    if nargin > 1, eight_connectivity = varargin{1};end
    marker = 1;
    if nargin > 2, marker = varargin{2};end
    threshold = -Inf('single');
    if nargin > 3, threshold = varargin{3};end
    allow_at_border = 0;
    if nargin > 4, allow_at_border = varargin{4};end
    allow_plateaus = 1;
    if nargin > 5, allow_plateaus = varargin{5};end
    plateau_epsilon = 0.001;
    if nargin > 6, plateau_epsilon = varargin{6};end

    shape = size(image);
    w = shape(1);  
    h = shape(2); 
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    maxima_image = zeros(w,h,b,'single');
    
    for i=1:b
        maxima_image(:,:,i) = localmaxima_band(image(:,:,i),eight_connectivity, marker, threshold, allow_at_border, allow_plateaus, plateau_epsilon);
    end
    
end

function maxima_band = localmaxima_band(image_band, varargin)
    eight_connectivity = 1;
    if nargin > 1, eight_connectivity = varargin{1};end
    marker = 1;
    if nargin > 2, marker = varargin{2};end
    threshold = -Inf('single');
    if nargin > 3, threshold = varargin{3};end
    allow_at_border = 0;
    if nargin > 4, allow_at_border = varargin{4};end
    allow_plateaus = 1;
    if nargin > 5, allow_plateaus = varargin{5};end
    plateau_epsilon = 0.001;
    if nargin > 6, plateau_epsilon = varargin{6};end
    
    shape = size(image_band);
    w = shape(1);  
    h = shape(2); 
   
    ptr = libpointer('singlePtr',image_band);
    
    maxima_band = zeros(w,h,'single');
    maxima_ptr = libpointer('singlePtr',maxima_band);
    
    result = calllib('libvigra_c','vigra_localmaxima_c', ptr, maxima_ptr, w, h, eight_connectivity, marker, threshold, allow_at_border, allow_plateaus, plateau_epsilon);
    
    if ( result == 0 )
        maxima_band = maxima_ptr.Value;
    else
        error('Error in vigramatlab.imgproc.localmaxima: Extraction of local maxima from image failed!')
    end
end