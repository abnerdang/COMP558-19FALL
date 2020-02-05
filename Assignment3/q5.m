clear all;
clc;
[allpairs, allfeatures, allkeypoints] = getMyPicsPairs(4, 5);
H_all = cell(size(allpairs, 1), 1);
inliers = cell(size(allpairs, 1), 1);
for i = 1:size(allpairs, 1)
    [inliers{i}, H_all{i}] = getHomography(allkeypoints{i}, allkeypoints{i+1}, allpairs{i});
end


H_q4 = cell(2);
H_q4{1} = H_all{1};
H_q4{2} = H_all{2};


dir = 'mypics/';
buildingScene = imageDatastore(dir);
% montage(buildingScene.Files);

I = readimage(buildingScene, 1);
grayImage = rgb2gray(I);

numImages = numel(buildingScene.Files);
tforms(numImages) = projective2d(eye(3));
imageSize = zeros(numImages, 2);

for n = 2:numImages
    imageSize(n, :) = size(grayImage);
    tforms(n).T = H_q4{n-1}';
    tforms(n).T = tforms(n).T * tforms(n-1).T;
end



% Compute the output limits  for each transform
for i = 1:numel(tforms)           
    [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(i,2)], [1 imageSize(i,1)]);    
end

avgXLim = mean(xlim, 2);

[~, idx] = sort(avgXLim);

centerIdx = floor((numel(tforms)+1)/2);

Tinv = invert(tforms(2));

for i = 1:numel(tforms)
    tforms(i).T = tforms(i).T * Tinv.T;
    tforms(i) = invert(tforms(i));
end

% Step 3 - Initialize the Panorama
for i = 1:numel(tforms)           
    [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(i,2)], [1 imageSize(i,1)]);
end

maxImageSize = max(imageSize);

% Find the minimum and maximum output limits 
xMin = min([1; xlim(:)]);
xMax = max([maxImageSize(2); xlim(:)]);

yMin = min([1; ylim(:)]);
yMax = max([maxImageSize(1); ylim(:)]);

% Width and height of panorama.
width  = round(xMax - xMin);
height = round(yMax - yMin);

% Initialize the "empty" panorama.
panorama = zeros([height width 3], 'like', I);


blender = vision.AlphaBlender('Operation', 'Binary mask', ...
    'MaskSource', 'Input port');  

% Create a 2-D spatial reference object defining the size of the panorama.
xLimits = [xMin xMax];
yLimits = [yMin yMax];
panoramaView = imref2d([height width], xLimits, yLimits);

% Create the panorama.
for i = 1:numImages
    
    I = readimage(buildingScene, i);   
   
    % Transform I into the panorama.
    warpedImage = imwarp(I, tforms(i), 'OutputView', panoramaView);
                  
    % Generate a binary mask.    
    mask = imwarp(true(size(I,1),size(I,2)), tforms(i), 'OutputView', panoramaView);
    
    % Overlay the warpedImage onto the panorama.
    panorama = step(blender, panorama, warpedImage, mask);
end

figure
imshow(uint8(panorama))
