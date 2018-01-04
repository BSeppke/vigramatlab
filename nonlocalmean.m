function filtered_image = nonlocalmean(image, policy_type, sigma, meanVal, varRatio, epsilon, sigmaSpatial, searchRadius, patchRadius, sigmaMean, stepSize, iterations, nThreads, verbose)

    if nargin < 2
       policy_type = 1;        
    end
    
    if nargin < 3
        if policy_type == 0
            sigma    = 10.0;
            meanVal  = 0.95;
            varRatio = 0.5;
            epsilon  = 0.00001;
            sigmaSpatial = 2.0;
            searchRadius = 5;
            patchRadius = 2;
            sigmaMean = 10.0;
            stepSize = 2;
            iterations = 2;
            nThreads = 8;
            verbose = true;
        elseif policy_type == 1
            sigma    = 50.0;
            meanVal  = 5.0;
            varRatio = 0.5;
            epsilon  = 0.00001;
            sigmaSpatial = 2.0;
            searchRadius = 5;
            patchRadius = 2;
            sigmaMean = 10.0;
            stepSize = 2;
            iterations = 2;
            nThreads = 8;
            verbose = true;
        else
            error('Error in vigramatlab.filters.nonlocalmean: Policy type must be 0 or 1!');
        end
    end
    
    shape = size(image);
    w = shape(1);  
    h = shape(2); 
    b = 1;
    
    if ( length(shape) == 3 )
        b = shape(3);
    end
    
    filtered_image = zeros(w,h,b,'single');
    
    for i=1:b
        filtered_image(:,:,i) = nonlocalmean_band(image(:,:,i), policy_type, sigma, meanVal, varRatio, epsilon, sigmaSpatial, searchRadius, patchRadius, sigmaMean, stepSize, iterations, nThreads, verbose);
    end
    
end

function filtered_image_band = nonlocalmean_band(image_band, policy_type, sigma, meanVal, varRatio, epsilon, sigmaSpatial, searchRadius, patchRadius, sigmaMean, stepSize, iterations, nThreads, verbose)

    if nargin < 2
       policy_type = 1;        
    end
    
    if nargin < 3
        if policy_type == 0
            sigma    = 10.0;
            meanVal  = 0.95;
            varRatio = 0.5;
            epsilon  = 0.00001;
            sigmaSpatial = 2.0;
            searchRadius = 5;
            patchRadius = 2;
            sigmaMean = 10.0;
            stepSize = 2;
            iterations = 2;
            nThreads = 8;
            verbose = true;
        elseif policy_type == 1
            sigma    = 50.0;
            meanVal  = 5.0;
            varRatio = 0.5;
            epsilon  = 0.00001;
            sigmaSpatial = 2.0;
            searchRadius = 5;
            patchRadius = 2;
            sigmaMean = 10.0;
            stepSize = 2;
            iterations = 2;
            nThreads = 8;
            verbose = true;
        else
            error('Error in vigramatlab.filters.nonlocalmean: Policy type must be either 0 or 1!');
        end
    end
    
    
    
    shape = size(image_band);
    w = shape(1);  
    h = shape(2); 
   
    ptr = libpointer('singlePtr',image_band);
    
    filtered_image_band = zeros(w,h,'single');
    filtered_ptr = libpointer('singlePtr',filtered_image_band);
    
    result = calllib('libvigra_c','vigra_nonlocalmean_c', ptr, filtered_ptr, w,h, policy_type, single(sigma), single(meanVal), single(varRatio), single(epsilon), single(sigmaSpatial), searchRadius, patchRadius, single(sigmaMean), stepSize, iterations, nThreads, verbose);
    
    switch result
        case 0
            filtered_image_band = filtered_ptr.Value;
        case 1
            error('Error in vigramatlab.filters.nonlocalmean: Non-loccal mean filtering failed!');
        case 2
            error('Error in vigramatlab.filters.nonlocalmean: Policy must be either 0 or 1!');
    end
end