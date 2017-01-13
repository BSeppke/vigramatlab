function fft_image = fouriertransform(image)
    
    shape = size(image);
    w = shape(1);
    h = shape(2);
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    fft_image = complex(zeros(w,h,b,'single'),zeros(w,h,b,'single'));
    
    for i=1:b
        fft_image(:,:,i) = fouriertransform_band(image(:,:,i));
    end
    
end

function fft_image_band = fouriertransform_band(image_band)

    shape = size(image_band);
    w = shape(1);
    h = shape(2);
   
    ptr = libpointer('singlePtr',image_band);
    
    fft_image_band_real = zeros(w,h,'single');
    real_ptr = libpointer('singlePtr',fft_image_band_real);
    fft_image_band_imag = zeros(w,h,'single');
    imag_ptr = libpointer('singlePtr',fft_image_band_imag);
    
    result = calllib('libvigra_c','vigra_fouriertransform_c', ptr, real_ptr, imag_ptr, w,h);
    
    switch result
        case 0
            fft_image_band = complex(real_ptr.Value, imag_ptr.Value);
        case 1
            error('Error in vigramatlab.imgproc:fouriertransform: FastFourier Transform of image failed!')
    end
end