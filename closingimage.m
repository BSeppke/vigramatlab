function closed_image = closingimage(image, radius)
    closed_image = erodeimage(dilateimage(image, radius),radius);
end