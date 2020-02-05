clear all;
clc;
path1 = 'horizontal/1.png';
path2 = 'horizontal/2.png';
% 
rgb1 = imread(path1);
rgb2 = imread(path2);
img1 = single(rgb2gray(rgb1));
img2 = single(rgb2gray(rgb2));
% 
% [keypoints1, features1] = sift(img1,'Levels',4,'PeakThresh',5);
% [keypoints2, features2] = sift(img2,'Levels',4,'PeakThresh',5);
% keypoints1 = keypoints1';
% keypoints2 = keypoints2';
% features1 = features1';
% features2 = features2';
% indexPairs = matchFeatures(features1, features2);
[allpairs, allfeatures, allkeypoints] = getHorizontalPairs(4, 5);
keypoints1 = allkeypoints{2};
keypoints2 = allkeypoints{3};
features1 = allfeatures{2};
features2 = allfeatures{3};
indexPairs = allpairs{2};

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


