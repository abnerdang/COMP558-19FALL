clear all;
clc;
[allpairs, allfeatures, allkeypoints] = getHorizontalPairs(4, 5);
H_all = cell(size(allpairs, 1), 1);
inliers = cell(size(allpairs, 1), 1);
for i = 1:size(allpairs, 1)
    [inliers{i}, H_all{i}] = getHomography(allkeypoints{i}, allkeypoints{i+1}, allpairs{i});
end

% ith image from 1st 0.png->i = 1
choseni = 5;
dirct = 'horizontal/';

path1 = strcat(dirct, num2str(choseni-1), '.png');
path2 = strcat(dirct, num2str(choseni), '.png');

rgb1 = imread(path1);
rgb2 = imread(path2);
img1 = single(rgb2gray(rgb1));
img2 = single(rgb2gray(rgb2));

% Just single match
keypoints1 = allkeypoints{choseni};
keypoints2 = allkeypoints{choseni+1};
features1 = allfeatures{choseni};
features2 = allfeatures{choseni+1};
indexPairs = allpairs{choseni};

% figure(1);
% imshowpair(img1, img2, 'montage');
% title('Original Match');
% axis on;
% hold on;
% Markers = {'+','o','*','x','v','d','^','s','>','<'};
% sizep = size(indexPairs, 1);
% for ii = 1 : sizep
%      if rand(1) > 0.3
%          continue;
%      end
%         
%     pos11 = keypoints1(indexPairs(ii, 1), 1:2);
%     pos22 = keypoints2(indexPairs(ii, 2), 1:2);
%     pos22(1) = pos22(1)+size(img1, 2);
%     x11 = pos11(1);
%     x22 = pos22(1);
%     y11 = pos11(2);
%     y22 = pos22(2);
%     plot([x11, x22], [y11, y22], 'r-', 'Marker', Markers{ceil(rand(1)*10)})
% end


% My inliers
figure(2);
cur_inliers = inliers{choseni};
imshowpair(img1, img2, 'montage');
title('RANSAC matching');
axis on;
hold on;
Markers = {'+','o','*','x','v','d','^','s','>','<'};
sizep = size(cur_inliers, 1);
for ii = 1 : sizep
     if rand(1) > 0.3
         continue;
     end
        
    pos1 = cur_inliers(ii, 1:2);
    pos2 = cur_inliers(ii, 3:4);
    pos2(1) = pos2(1)+size(img1, 2);
    x1 = pos1(1);
    x2 = pos2(1);
    y1 = pos1(2);
    y2 = pos2(2);
    plot([x1, x2], [y1, y2], 'r-', 'Marker', Markers{ceil(rand(1)*10)})
end




