function minima_image = localminima(image, varargin)
    eight_connectivity = 1;
    if nargin > 1, eight_connectivity = varargin{1};end
    marker = 1;
    if nargin > 2, marker = varargin{2};end
    threshold = Inf('single');
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
    
    minima_image = zeros(w,h,b,'single');
    
    for i=1:b
        minima_image(:,:,i) = localminima_band(image(:,:,i), eight_connectivity, marker, threshold, allow_at_border, allow_plateaus, plateau_epsilon);
    end
    
end

function minima_band = localminima_band(image_band, varargin)
    eight_connectivity = 1;
    if nargin > 1, eight_connectivity = varargin{1};end
    marker = 1;
    if nargin > 2, marker = varargin{2};end
    threshold = Inf('single');
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
    
    minima_band = zeros(w,h,'single');
    minima_ptr = libpointer('singlePtr',minima_band);
    
    result = calllib('libvigra_c','vigra_localminima_c', ptr, minima_ptr, w,h, eight_connectivity, marker, threshold, allow_at_border, allow_plateaus, plateau_epsilon);
    
    if ( result == 0 )
        minima_band = minima_ptr.Value;
    else
        error('Error in vigramatlab.imgproc.localminima: Extraction of local minima from image failed!')
    end
end