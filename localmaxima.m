function maxima_image = localmaxima(image, varargin)
    eight_connectivity = 1;
    if nargin > 1, eight_connectivity = varargin{1};end

    shape = size(image);
    h = shape(1);
    w = shape(2);
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    maxima_image = zeros(h,w,b,'single');
    
    for i=1:b
        maxima_image(:,:,i) = localmaxima_band(image(:,:,i),eight_connectivity);
    end
    
end

function maxima_band = localmaxima_band(image_band, varargin)
    eight_connectivity = 1;
    if nargin > 1, eight_connectivity = varargin{1};end
    
    shape = size(image_band);
    h = shape(1);
    w = shape(2);
   
    ptr = libpointer('singlePtr',image_band');
    
    maxima_band = zeros(w,h,'single');
    maxima_ptr = libpointer('singlePtr',maxima_band);
    
    result = calllib('libvigra_c','vigra_localmaxima_c', ptr, maxima_ptr, w, h, eight_connectivity);
    
    if ( result == 0 )
        maxima_band = maxima_ptr.Value';
    else
        error('Error in vigramatlab.imgproc.localmaxima: Extraction of local maxima from image failed!')
    end
end