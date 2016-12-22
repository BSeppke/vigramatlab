function minima_image = localminima(image, varargin)
    eight_connectivity = 1;
    if nargin > 1, eight_connectivity = varargin{1};end

    shape = size(image);
    h = shape(1);
    w = shape(2);
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    minima_image = zeros(h,w,b,'single');
    
    for i=1:b
        minima_image(:,:,i) = localminima_band(image(:,:,i), eight_connectivity);
    end
    
end

function minima_band = localminima_band(image_band, varargin)
    eight_connectivity = 1;
    if nargin > 1, eight_connectivity = varargin{1};end
    
    shape = size(image_band);
    h = shape(1);
    w = shape(2);
   
    ptr = libpointer('singlePtr',image_band');
    
    minima_band = zeros(w,h,'single');
    minima_ptr = libpointer('singlePtr',minima_band);
    
    result = calllib('libvigra_c','vigra_localminima_c', ptr, minima_ptr, w,h, eight_connectivity);
    
    if ( result == 0 )
        minima_band = minima_ptr.Value';
    else
        error('Error in vigramatlab.imgproc.localminima: Extraction of local minima from image failed!')
    end
end