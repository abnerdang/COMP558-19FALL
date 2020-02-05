clc;
clear all;
img = imread('books.jpg');
gray_img = rgb2gray(img);
origin_gray = gray_img;

N = 7
sigma = 1.5
img_filt = conv2(gray_img, make2DLOG(N, sigma), 'same');
%img_filt = conv2(gray_img, fspecial('log', 3, 0.8), 'same');
[x, y] = size(img_filt);
figure;

subplot(2, 2, 1)
imshow(img_filt);
title(['After convolution--', 'N=', num2str(N), ' sigma=', num2str(sigma)]);
zero_crossing = zeros(x, y);

%Do zero-crossing checking
%Starting from 2, because for a specific location[i, j], we have to loop up
%[i-1, j-1]
th = 10
for i=2:x-1
    for j = 2:y-1
        if (img_filt(i-1, j)*img_filt(i+1, j) < 0 && abs(img_filt(i-1, j)-img_filt(i+1, j))>th)...
                || (img_filt(i, j-1)*img_filt(i, j+1) < 0 && abs(img_filt(i, j-1)-img_filt(i, j+1))>th)...
                || (img_filt(i-1, j-1)*img_filt(i+1, j+1) < 0 && abs(img_filt(i-1, j-1)-img_filt(i+1, j+1))>th)...
                || (img_filt(i-1, j+1)*img_filt(i+1, j-1) < 0 && abs(img_filt(i-1, j+1)-img_filt(i+1, j-1))>th)...
              
            zero_crossing(i, j) = 1;
            img(i, j, 1) = 255;
            img(i, j, 2) = 255;
            img(i, j, 3) = 0;
            gray_img(i, j) = 255;
        end
    end
end

subplot(2, 2, 2)
imshow(zero_crossing)
title({['Zero Crossing--', 'N=', num2str(N)];[ ' sigma=', num2str(sigma), ' threshold=', num2str(th)]});
subplot(2, 2, 3)
imshow(img);
title(['Overlapping image--', 'N=', num2str(N), ' sigma=', num2str(sigma), ' threshold=', num2str(th)]);



