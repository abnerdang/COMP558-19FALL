%read the image, take the blue channel
clear all;
clc;
%================hyper parameters=======================================
% kernel size for guassian pyramid
kernel_size = 5;
% threshold for laplacian pyramid
th = 1;
spatial_size = 3;
% selected keypoint for visualization
selected_keypoint_index = 3;
% weighted gaussian sigma
wsigma = 3;

scale1 = 1.25;
angle1 = -15;
scale2 = 1.25;
angle2 = -15;
% point1 = [268, 382];
% point1 = [390, 672];
% point1 = [500, 700];
% point1 = [628 672];
point1 = [194 384];
% point1 = [104, 594];

%=======================================================================
% image = imread('books.jpg');
image = imread('manor.png');
image = imresize(image, [1024, 1024]);
original_image = rgb2gray(image);
% original_image = image(:, :, 3);

%====================create Gaussian pyramid============================
gaupyramid = cell(7, 1);
% kernel_size = 5;
figure(1);
for i = 1:7
    if i == 1
        gaupyramid{i} = original_image;
    else
        gaupyramid{i} = gaupyramid{i-1};
    end
    %for each level, smooth it with a Gaussian
    sigma = 2^(i-1);
    % kernelp = fspecial('gaussian', [kernel_size, kernel_size], sigma);
    % gaupyramid{i} = conv2(gaupyramid{i}, kernelp, 'same');
    gaupyramid{i} = imgaussfilt(gaupyramid{i}, 2);
    if i ~= 1
        gaupyramid{i} = imresize(gaupyramid{i}, 0.5);
    end
    
    subplot(2, 4, i);
    imshow(uint8(gaupyramid{i})); 
    title({['Gaussian Pyramid'], ['sigma = ', num2str(sigma)]});
end


% ====================create Laplacian pyramid============================
figure(2);
lplpyramid = cell(6, 1);
for i = 1:6 
    low = gaupyramid{i};
    high = gaupyramid{i+1};
    high = imresize(high, 2);
    lplpyramid{i} = high - low;
    
    subplot(2, 3, i);
    imshow(uint8(lplpyramid{i}), []);
    title({['Laplacian Pyramid'], ['level ', num2str(i)], [num2str(spatial_size), '×', num2str(spatial_size),' spatial neighbor']});
end
    
% ====================Find SIFT features============================
keypoint = [];
% th = 5;
% spatial_size = 3;
shift = (spatial_size-1)/2;
sift_window = zeros(spatial_size*spatial_size, spatial_size);
for l_num = 2:5
    current = lplpyramid{l_num};
    previous = imresize(lplpyramid{l_num-1}, 0.5);
    next = imresize(lplpyramid{l_num+1}, 2);
    bound = (spatial_size+1)/2;
    for i = bound:size(current, 1)-bound+1
        for j = bound:size(current, 2)-bound+1
            sift_window(1:spatial_size, 1:spatial_size) = current(i-shift:i+shift, j-shift:j+shift);
            sift_window(spatial_size+1:(spatial_size*2), 1:spatial_size) = previous(i-shift:i+shift, j-shift:j+shift);
            sift_window((spatial_size*2+1):spatial_size*3, 1:spatial_size) = next(i-shift:i+shift, j-shift:j+shift);
            sift_window(bound, bound) = sift_window(1, 1);
            maxv = max(max(sift_window));
            minv = min(min(sift_window));
            if current(i, j) > (maxv+th)
                tmp = [i, j, 2^(l_num-1)];
                keypoint = [keypoint; tmp];
            end
            %min_v = min([current_min, next_min, previous_min]);
            if current(i, j) < (minv-th)
                tmp = [i, j, 2^(l_num-1)];
                keypoint = [keypoint; tmp];
            end
        end
    end
end

color = {'b', 'g', 'y', 'm'};
figure(3);
imshow(original_image);
hold on;
for n = 1:size(keypoint, 1)
    radius = keypoint(n, 3);
    coordinate_tmp = [keypoint(n, 2), keypoint(n, 1)];
    level = log2(keypoint(n, 3));
    %we should map the coordinate to the original coordinate
    viscircles(coordinate_tmp.*radius, radius, 'LineWidth', 0.5, 'Color', color{level});
end

% ====================Q4. Compute SIFT feature vectors=====================

gmag = cell(7, 1);
gdir = cell(7, 1);
gau_gmag = cell(7, 1);
x_gmag = cell(7, 1);
y_gmag = cell(7, 1);
for i = 1:7
    [gmag{i}, gdir{i}] = imgradient(gaupyramid{i});
    [x_gmag{i}, y_gmag{i}] = imgradientxy(gaupyramid{i});
end
% choose a keypoint
selected_point = keypoint(selected_keypoint_index, :);
x = selected_point(1);
y = selected_point(2);
level = log2(selected_point(3))+1;

% get the corresponding magnitude and direction 
gau_img_tmp = gaupyramid{level};
mag_tmp = gmag{level};
dir_tmp = gdir{level};
x_gmag_tmp = x_gmag{level};
y_gmag_tmp = y_gmag{level};

% For a sift point
gau_img_selected = imcrop(gau_img_tmp, [x-7, y-7, 14, 14]);
mag_selected = imcrop(mag_tmp, [x-7, y-7, 14, 14]);
dir_selected = imcrop(dir_tmp, [x-7, y-7, 14, 14]);
x_gmag_selected = imcrop(x_gmag_tmp, [x-7, y-7, 14, 14]);
y_gmag_selected = imcrop(y_gmag_tmp, [x-7, y-7, 14, 14]);
kernel = fspecial('gaussian', [15, 15], wsigma);
weighted_mag = kernel.*mag_selected;

figure(4);
subplot(2, 2, 1);

imshow(uint8(gau_img_selected));
title('15×15 patch');
subplot(2, 2, 2);
imshow(mag_selected, []);
title('gradient magnitude')
subplot(2, 2, 3);
imshow(gau_img_selected, []);
hold on;
[X, Y] = meshgrid(1:15, 1:15);
quiver(X, Y, x_gmag_selected, y_gmag_selected);
title('gradient vector visualization');
subplot(2, 2, 4);
imshow(weighted_mag, []);
title('weighted gradient magnitude');

% =========Q5. Orientation histogram for each SIFT key point===========
hist_raw = zeros(size(keypoint, 1), 39);
hist_raw(:, 1:3) = keypoint;
for i=1:size(keypoint, 1)
    cur_point = keypoint(i, :);
    level = log2(cur_point(3))+1;
    mag_tmp = gmag{level};
    dir_tmp = gdir{level};
    x = cur_point(1);
    y = cur_point(2);
    mag_selected = imcrop(mag_tmp, [x-7, y-7, 14, 14]);
    %ignore the keypoint which do not have 15*15 window
    size_tmp = size(mag_selected);
    if sum(size_tmp) < 30
        continue;
    end
    dir_selected = imcrop(dir_tmp, [x-7, y-7, 14, 14]);
    w_mag = kernel.*mag_selected;
    hist_cur = getHistgram(w_mag, dir_selected);
    hist_raw(i, 4:end) = hist_cur;
end


hist_align = hist_raw;
for i = 1:size(keypoint, 1)
    tmp = hist_align(i, 4:end);
    [~, index] = max(tmp);
    if index == 1
        continue;
    else
        tmp = [tmp(index:end), tmp(1:index-1)];
        hist_align(i, 4:end) = tmp;
    end
end

% plot the histogram of the selected keypoint
selected_hist = hist_raw(selected_keypoint_index, 4:end);
selected_hista = hist_align(selected_keypoint_index, 4:end);
sltd_keypoint = hist_raw(selected_keypoint_index, 1:3); 
bin_num = 1:36;
figure(5);
subplot(1, 2, 1);
bar(bin_num, selected_hist);
title("Histogram without alignment");
subplot(1, 2, 2);
bar(bin_num, selected_hista);
title("Histogram with alignment");
% =========Q6. Rotate and scale original image===========

point2 = [500, 700];
scale2 = 1.25;
eg1 = imTransform(original_image, point1(1), point1(2), angle1, scale1);
eg2 = imTransform(original_image, point2(1), point2(2), -30, scale2);
figure(6)
subplot(1, 2, 1);
imshow(uint8(eg1));
hold on;
plot(point1(2)*scale1, point1(1)*scale1, 'r*', 'LineWidth', 2);
axis on;
title({['Rotated angle = ', num2str(angle1)], ['Scale = ', num2str(scale1)]});

subplot(1, 2, 2);
imshow(uint8(eg2));
hold on;
plot(point2(2)*scale2, point2(1)*scale2, 'r*', 'LineWidth', 2);
axis on;
title({['Rotated angle = ', num2str(angle2)], ['Scale = ', num2str(scale2)]});

%==============Q7. Features matching=====================================
sift1 = siftPipeline(eg1, kernel_size, th, spatial_size, wsigma);
sift2 = siftPipeline(eg2, kernel_size, th, spatial_size, wsigma);

% get interested sift features
inshift = 100;
Hsource = selectSift(inshift, point1, hist_align);
point11 = point1*scale1;
inshift1 = inshift*scale1;
Htarget = selectSift(inshift1, point11, sift1);
pairs1 = findPairs(Hsource, Htarget);


% plot the result
Markers = {'+','o','*','x','v','d','^','s','>','<'};
figure(7);
imsize = max(size(original_image, 1), size(eg1, 1));
sizep = size(pairs1);
imshowpair(uint8(original_image), uint8(eg1), 'montage');
axis on;
hold on;
for i = 1:sizep
    vec1 = Hsource(pairs1(i, 1), 1:3);
    vec2 = Htarget(pairs1(i, 2), 1:3);
    pos1 = vec1(1:2)*vec1(3);
    pos2 = vec2(1:2)*vec2(3);
    posinfig1 = pos1;
    posinfig2 = [pos2(1), pos2(2)+imsize];
    x1 = posinfig1(2);
    x2 = posinfig2(2);
    y1 = posinfig1(1);
    y2 = posinfig2(1);
    plot([x1, x2], [y1, y2], 'r-', 'Color', [rand(1), rand(1), rand(1)], 'LineWidth', 1);
    level1 = log2(vec1(3));
    radius1 = vec1(3);
    % viscircles([x1, y1], radius1, 'LineWidth', 0.5, 'Color', color{level1});
    level2 = log2(vec2(3));
    radius2 = vec2(3);
    % viscircles([x2, y2], radius2, 'LineWidth', 0.5, 'Color', color{level2});
    plot([x1, x2], [y1, y2], 'Marker', Markers{ceil(rand(1)*10)}, 'LineWidth', 3, 'Color', [rand(1), rand(1), rand(1)]);
end






                
  
    
    
    
    
    
