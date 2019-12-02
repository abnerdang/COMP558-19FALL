clear all;
clc;
path1 = 'horizontal/1.png';
path2 = 'horizontal/2.png';
% 
rgb1 = imread(path1);
rgb2 = imread(path2);
img1 = single(rgb2gray(rgb1));
img2 = imresize(img1, 0.75);
img2 = imrotate(img2, 30);

std_img1 = zeros(1024, 1024);
width = size(img1, 1);
height = size(img1, 2);
std_img1(1:width, 1:height) = img1;

std_img2 = zeros(1024, 1024);
width = size(img2, 1);
height = size(img2, 2);
std_img2(1:width, 1:height) = img2;


[keypoints1, features1] = sift(img1,'Levels',4,'PeakThresh',5);
[keypoints2, features2] = sift(img2,'Levels',4,'PeakThresh',5);
keypoints1 = keypoints1';
keypoints2 = keypoints2';
features1 = features1';
features2 = features2';

indexPairs = matchFeatures(features1, features2);

figure(1);
imshowpair(img1, img2, 'montage');
axis on;
hold on;



Markers = {'+','o','*','x','v','d','^','s','>','<'};
sizep = size(indexPairs, 1);
for ii = 1 : sizep
     if rand(1) > 0.1
         continue;
     end    
    pos1 = keypoints1(indexPairs(ii, 1), 1:2);
    pos2 = keypoints2(indexPairs(ii, 2), 1:2);
    pos2(1) = pos2(1)+size(img1, 2);
    x1 = pos1(1);
    x2 = pos2(1);
    y1 = pos1(2);
    y2 = pos2(2);
    plot([x1, x2], [y1, y2], 'r-', 'Marker', Markers{ceil(rand(1)*10)})
end
title('Provided SIFT');

figure(2);
subplot(1,2,1);
f1 = features1(indexPairs(1, 1), :);
bar(f1);
subplot(1,2,2);
f2 = features2(indexPairs(1, 2), :);
bar(f2);
title('Provided SIFT');




% for my own sift matching
% [keypoints1, features1] = siftPipeline(std_img1, 0, 1, 3, 2);
% [keypoints2, features2] = siftPipeline(std_img2, 0, 1, 3, 2);
% indexPairs = matchFeatures(features1, features2, 'MatchThreshold', 20.0);
% 
% figure(1);
% imshowpair(std_img1, std_img2, 'montage');
% axis on;
% hold on;
% 
% 
% 
% Markers = {'+','o','*','x','v','d','^','s','>','<'};
% sizep = size(indexPairs, 1);
% for ii = 1 : sizep
%      if rand(1) > 0.1
%          continue;
%      end    
%     pos1 = keypoints1(indexPairs(ii, 1), 1:2);
%     pos2 = keypoints2(indexPairs(ii, 2), 1:2);
%     pos2(1) = pos2(1)+size(img1, 2);
%     x1 = pos1(1);
%     x2 = pos2(1);
%     y1 = pos1(2);
%     y2 = pos2(2);
%     plot([x1, x2], [y1, y2], 'r-', 'Marker', Markers{ceil(rand(1)*10)})
% end
% title('My SIFT matching');
% 
% figure(2);
% subplot(1,2,1);
% f1 = features1(indexPairs(1, 1), :);
% bar(f1);
% subplot(1,2,2);
% f2 = features2(indexPairs(1, 2), :);
% bar(f2);
% title('My SIFT matching');







