function clipped_image = clipimage(image, varargin)
    low = 0.0;
    if nargin > 1, low = varargin{1};end
    upp = 255.0;
    if nargin > 2, upp = varargin{2};end

    shape = size(image);
    w = shape(1);  
    h = shape(2); 
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    clipped_image = zeros(w,h,b,'single');
    
    for i=1:b
        clipped_image(:,:,i) = clipimage_band(image(:,:,i), low, upp);
    end
    
end

function clipped_image_band = clipimage_band(image_band, varargin)
    low = 0.0;
    if nargin > 1, low = varargin{1};end
    upp = 255.0;
    if nargin > 2, upp = varargin{2};end
    
    shape = size(image_band);
    w = shape(1);  
    h = shape(2); 
   
    ptr = libpointer('singlePtr',image_band);
    
    clipped_image_band = zeros(w,h,'single');
    label_ptr = libpointer('singlePtr',clipped_image_band);
    
    result = calllib('libvigra_c','vigra_clipimage_c', ptr, label_ptr, w,h, low, upp);
   
    if ( result == 0 )
        clipped_image_band = label_ptr.Value;
    else
        error('Error in vigramatlab.imgproc.clipimage: Clipping of image failed!')
    end
end