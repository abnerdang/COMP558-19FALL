rgb = imread('roof.jpg');
image = single(rgb2gray(rgb));
[keypoints,features] = sift(image,'Levels',4,'PeakThresh',5);
subplot(1,2,1)
imshow(rgb);hold on;
viscircles(keypoints(1:2,:)',keypoints(3,:)');

theta = 45;
[keypoints,~] = sift(imrotate(image,theta,'crop'),'Levels',4,'PeakThresh',5);
subplot(1,2,2)
imshow(imrotate(rgb,theta,'crop'));hold on;
viscircles(keypoints(1:2,:)',keypoints(3,:)');
