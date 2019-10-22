clc;
clear all;
img = imread('books.jpg');
gray_img = rgb2gray(img);
origin_gray = gray_img;

N = 7;
lambda = 2.2;
degree = 0;
[even, odd] = make2DGabor(N, lambda, degree);
img_filt = conv2(gray_img, odd, 'same');
[x, y] = size(img_filt);
zero_crossing = zeros(x, y);
th = 10;
figure;
subplot(2, 2, 1);

imshow(img_filt);
title({['After convolution--', 'N=', num2str(N)];[' lambda=', num2str(lambda), ' degree=', num2str(degree), 'threshold=', num2str(th)]});
%Do zero-crossing checking
%Starting from 2, because for a specific location[i, j], we have to loop up
%[i-1, j-1]

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
        end
    end
end

subplot(2, 2, 2)
imshow(zero_crossing)
title({['Zero Crossing--', 'N=', num2str(N)] ;[' lambda=', num2str(lambda), ' degree=', num2str(degree), 'threshold=', num2str(th)]});

subplot(2,2, 3)
imshow(img);
title({['Overlapping Image--', 'N=', num2str(N)];[ ' lambda=', num2str(lambda), ' degree=', num2str(degree), 'threshold=', num2str(th)]});

