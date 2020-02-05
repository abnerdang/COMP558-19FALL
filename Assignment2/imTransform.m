function img_t = imTransform(image, x0, y0, theta, s)
    Nx = size(image, 1);
    Ny = size(image, 2);
    up = x0-1;
    down = Nx-x0;
    height = max([up, down])*2 + 1;
    
    left = y0-1;
    right = Ny-y0;
    width = max([left, right])*2 + 1;
    
    nx0 = (height+1)/2;
    ny0 = (width+1)/2;
    enlarge = zeros(height, width);
    rmin = 1-x0+nx0;
    cmin = 1-y0+ny0;
    rmax = Nx-x0+nx0;
    cmax = Ny-y0+ny0;
    enlarge(rmin:rmax, cmin:cmax) = image;
     
    img_t = imrotate(enlarge, theta, 'crop');
    img_t = img_t(rmin:rmax, cmin:cmax);
    img_t = imresize(img_t, s);
end