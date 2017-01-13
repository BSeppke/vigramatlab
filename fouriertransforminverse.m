function fft_image_out = fouriertransforminverse(fft_image_in)
    
    shape = size(fft_image_in);
    w = shape(1);  
    h = shape(2); 
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    fft_image_out = complex(zeros(w,h,b,'single'),zeros(w,h,b,'single'));
    
    for i=1:b
        fft_image_out(:,:,i) = fouriertransforminverse_band(fft_image_in(:,:,i));
    end
    
end

function fft_image_band_out = fouriertransforminverse_band(fft_image_band_in)

    shape = size(fft_image_band_in);
    w = shape(1);  
    h = shape(2); 
   
    fft_image_band_in_real = real(fft_image_band_in);
    real_in_ptr = libpointer('singlePtr',fft_image_band_in_real);
    fft_image_band_in_imag = imag(fft_image_band_in);
    imag_in_ptr = libpointer('singlePtr',fft_image_band_in_imag);

    fft_image_band_out_real = zeros(w,h,'single');
    real_out_ptr = libpointer('singlePtr',fft_image_band_out_real);
    fft_image_band_out_imag = zeros(w,h,'single');
    imag_out_ptr = libpointer('singlePtr',fft_image_band_out_imag);
    
    result = calllib('libvigra_c','vigra_fouriertransforminverse_c', real_in_ptr, imag_in_ptr, real_out_ptr, imag_out_ptr, w,h);
    
    switch result
        case 0
            fft_image_band_out = complex(real_out_ptr.Value, imag_out_ptr.Value);
        case 1
            error('Error in vigramatlab.imgproc:fouriertransforminverse: Inverse Fast Fourier Transform of fft image failed!')
    end
end
