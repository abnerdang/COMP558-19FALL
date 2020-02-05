clear all;
clc;
path = 'horizontal/3.png';
rgb = imread(path);
image = single(rgb2gray(rgb));
std_img = zeros(1024, 1024);
width = size(image, 1);
height = size(image, 2);
std_img(1:width, 1:height) = image;

[keypoints, features] = sift(image,'Levels',4,'PeakThresh',5);


figure;
imshow(uint8(image)); hold on;
viscircles(keypoints(1:2, :)', keypoints(3, :)');
title('Provided SIFT')


% my_sift = siftPipeline(std_img, 5, 1, 3, 3);