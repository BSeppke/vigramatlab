function opened_image = openingimage(image, radius)
    opened_image = dilateimage(erodeimage(image, radius),radius);
end