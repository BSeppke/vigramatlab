load_vigra_c();

display('loading lenna-image')

img = loadimage('images/lenna_face.png');
shape = size(img);

display( 'performance test gaussian smoothing')
display( 'vigra-method [in ms]:')
tic
img = gaussiansmoothing(img, 0.3);
toc


display( 'testing subimage and correlation facilities')
img_cut = subimage(img, 100, 50, 151, 101); % Mask needs to have odd size!

fcc_res = fastcrosscorrelation(img, img_cut);
fncc_res = fastnormalizedcrosscorrelation(img, img_cut);
pos_matches = localmaxima(fncc_res);
neg_matches = localminima(fncc_res);

display( 'performing watershed transform on resized gradient image')
img_ggm = gaussiangradient(resizeimage(img, 2*shape(1), 2*shape(2),  4),  1.0);
img2 = regionimagetocrackedgeimage( labelimage(watersheds(img_ggm)), 0.0);

display( 'performing fft on image')
img3 = fouriertransform(loadimage('images/rect.gif'));

display( 'testing rotation and reflection functions on image')
img4 = reflectimage( img, 3);
img5 = rotateimage( img, 15.0, 3);


display( 'testing affine transformation on image')
theta = (-15 * 3.14157)/ 180.0;

rotmat = [[cos(theta), -1*sin(theta), 0];   [sin(theta), cos(theta)   , 0];  [ 0        ,  0           , 1]];

t1mat = [[1, 0, 0];   [0, 1, 0]; [-shape(1)/2.0, -shape(2)/2.0, 1]];
t2mat = [[1, 0, 0];   [0, 1, 0]; [ shape(1)/2.0,  shape(2)/2.0, 1]];
mat = t2mat * (rotmat * t1mat);
img6 =  affinewarpimage( img , mat',  3);




display( 'performing distance transform on canny edges of image')
img7 = distancetransform(cannyedgeimage( img,  1.8,  0.1,  100.0),  0.0,  2);

display( 'testing difference of exponential edge detection on image')
img8 = differenceofexponentialedgeimage( img, 1.8, 0.5, 100.0);

display( 'testing nearly all filters')
img9  = gaussiansmoothing( img, 3.0);
img10 = laplacianofgaussian( img, 3.0);
img11 = gaussiansharpening( img, 0.5, 3.0);
img12 = simplesharpening( img, 3.0);
img13 = nonlineardiffusion( img, 0.1, 2.0);

%Tensor tests
[img_st_xx, img_st_xy, img_st_yy]  = structuretensor(img, 1.0, 4.0);

%Boundary tensor
[img_bt_xx, img_bt_xy, img_bt_yy]  = boundarytensor(img, 1.0);

%Boundary tensor without 0 order parts
[img_bt_xx, img_bt_xy, img_bt_yy]  = boundarytensor1(img, 1.0);

%Tensor to eigen repr.
[maj_ew, min_ew, ew_angle] = tensoreigenrepresentation(img_st_xx, img_st_xy, img_st_yy);

%Tensor trace
img_bt_tt = tensortrace(img_bt_xx, img_bt_xy, img_bt_yy);

%Tensor to edge corner
[maj_ew, min_ew, ew_edgeness]  = tensortoedgecorner(img_st_xx, img_st_xy, img_st_yy);

%Tensor to hourglass-filtered tensor
[bt_hg_xx, bt_hg_xy, bt_hg_yy] = hourglassfilter(img_bt_xx, img_bt_xy, img_bt_yy, 1.0, 1.0);


display('testing some convolutions')
gauss_kernel = [[1.0 , 2.0 , 1.0],  [2.0 , 4.0 , 2.0], [1.0 , 2.0 , 1.0] ]/16.0;
mean_kernel =  [[1.0 , 1.0 , 1.0],  [1.0 , 1.0 , 1.0], [1.0 , 1.0 , 1.0] ]/9.0;
                  
sep_x_kernel =  [ 1.0,  1.0, 1.0 ]/3.0;
sep_y_kernel =  [ 1.0; 1.0; 1.0; 1.0; 1.0; 1.0; 1.0; 1.0; 1.0 ]/9.0;

img14 = convolveimage( img, gauss_kernel');
img15 = convolveimage( img, mean_kernel');
img16 = convolveimage( img, sep_x_kernel, sep_y_kernel);


display( 'testing the spline image view');
siv = create_splineimageview(img,2);
pos_x = 11.23;
pos_y = 23.42;

siv_val = splineimageview_value(siv, pos_x, pos_y);

siv_dx = splineimageview_derivative(siv, pos_x, pos_y, 1,0);
siv_dy = splineimageview_derivative(siv, pos_x, pos_y, 0,1);

siv_dxx = splineimageview_derivative(siv, pos_x, pos_y, 2,0);
siv_dxy = splineimageview_derivative(siv, pos_x, pos_y, 1,1);
siv_dyy = splineimageview_derivative(siv, pos_x, pos_y, 0,2);

siv_dxxx = splineimageview_derivative(siv, pos_x, pos_y, 3,0);
siv_dxxy = splineimageview_derivative(siv, pos_x, pos_y, 2,1);
siv_dxyy = splineimageview_derivative(siv, pos_x, pos_y, 1,2);
siv_dyyy = splineimageview_derivative(siv, pos_x, pos_y, 0,3);

siv_g2 = splineimageview_g2(siv, pos_x, pos_y, 0,0);

siv_g2x = splineimageview_g2(siv, pos_x, pos_y, 1,0);
siv_g2y = splineimageview_g2(siv, pos_x, pos_y, 0,1);

siv_g2xx = splineimageview_g2(siv, pos_x, pos_y, 2,0);
siv_g2xy = splineimageview_g2(siv, pos_x, pos_y, 1,1);
siv_g2yy = splineimageview_g2(siv, pos_x, pos_y, 0,2);

delete_splineimageview(siv);

display( 'saving resulting images');
saveimage(img2,  'images/lenna-relabeled-watersheds-on-resized-gradient-image.png');

saveimage( real(img3),        'images/rect-fft-real.png');
saveimage( imag(img3) ,       'images/rect-fft-imag.png');
saveimage( abs(img3) ,        'images/rect-fft-magnitude.png');
saveimage( sqrt(abs(img3)),   'images/rect-fft-sqrt-magnitude.png');

saveimage( img4 ,  'images/lenna-reflected-both.png');
saveimage( img5 ,  'images/lenna-rotated-15deg.png');
saveimage( img6 ,  'images/lenna-aff-rotated-15deg.png');
saveimage( img7 ,  'images/lenna-disttransform-on-canny.png');
saveimage( img8 ,  'images/lenna-diff_of_exp.png');
saveimage( img9 ,  'images/lenna-gsmooth-3.0.png');
saveimage( img10,  'images/lenna-log-3.0.png');
saveimage( img11,  'images/lenna-gsharpening-0.5-3.0.png');
saveimage( img12,  'images/lenna-sharpening-3.0.png');
saveimage( img13,  'images/lenna-nonlineardiffusion-0.1-2.0.png');
saveimage( img14,  'images/lenna-gauss-convolve.png');
saveimage( img15,  'images/lenna-mean-convolve.png');
saveimage( img16,  'images/lenna-sep-convolve.png');
