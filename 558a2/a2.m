%read the image, take the blue channel
clear all;
clc;
image = imread('manor.png');
original_image = image(:, :, 3);

%====================create Gaussian pyramid============================
gaupyramid = cell(7, 1);
kernel_size = 5;
figure(1);
for i = 1:7
    if i == 1
        gaupyramid{i} = original_image;
    else
        gaupyramid{i} = gaupyramid{i-1};
    end
    %for each level, smooth it with a Gaussian
    sigma = 2^(i-1);
    kernel = fspecial('gaussian', [kernel_size, kernel_size], sigma);
    gaupyramid{i} = conv2(gaupyramid{i}, kernel, 'same');
    if i ~= 1
        gaupyramid{i} = imresize(gaupyramid{i}, 0.5);
    end
    
    subplot(2, 4, i);
    imshow(uint8(gaupyramid{i})); 
end


% ====================create Laplacian pyramid============================
figure(2);
lplpyramid = cell(6, 1);
for i = 1:6 
    low = gaupyramid{i};
    high = gaupyramid{i+1};
    high = imresize(high, 2);
    lplpyramid{i} = high - low + 128;
    
    subplot(2, 3, i);
    imshow(uint8(lplpyramid{i}));
end
    
% ====================Find SIFT features============================
keypoint = [];
th = 15;
spatial_size = 3;
for l_num = 2:5
    current = lplpyramid{l_num};
    previous = imresize(lplpyramid{l_num-1}, size(current));
    next = imresize(lplpyramid{l_num+1}, size(current));
    for i = 2:size(current, 1)-1
        for j = 2:size(current, 2)-1
            [current_min, current_max] = findCurrLocalExtremas(spatial_size, i, j, current);
            [next_min, next_max] = getLocalExtremas(spatial_size, i, j, next);
            [previous_min, previous_max] = getLocalExtremas(spatial_size, i, j, previous);
            if current(i, j) > current_max+th && current(i, j) > next_max+th && current(i, j) > previous_max+th
                tmp = [i, j, 2^(l_num-1)];
                keypoint = [keypoint; tmp];
            end
            if current(i, j) < current_min-th && current(i, j) < next_min-th && current(i, j) < previous_min-th
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
    coordinate_tmp = [keypoint(n, 1), keypoint(n, 2)];
    level = log2(keypoint(n, 3));
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
selected_point = keypoint(51, :);
x = selected_point(1);
y = selected_point(2);
level = log2(selected_point(3))+1;
mag_tmp = gmag{level};
dir_tmp = gdir{level};
x_gmag_tmp = x_gmag{level};
y_gmag_tmp = y_gmag{level};
mag_selected = imcrop(mag_tmp, [x-7, y-7, 14, 14]);
dir_selected = imcrop(dir_tmp, [x-7, y-7, 14, 14]);
x_gmag_selected = imcrop(x_gmag_tmp, [x-7, y-7, 14, 14]);
y_gmag_selected = imcrop(y_gmag_tmp, [x-7, y-7, 14, 14]);
kernel = fspecial('gaussian', [15, 15], 2);
weighted_mag = kernel.*mag_selected;

figure(4);
subplot(1, 3, 1);
imshow(uint8(mag_selected));
hold on;
[X, Y] = meshgrid(1:15, 1:15);
quiver(X, Y, x_gmag_selected, y_gmag_selected);
subplot(1, 3, 2);
imshow(uint8(weighted_mag));








% =========================Utils funciton=================================
function [minv, maxv] = findCurrLocalExtremas(N, x, y, image)
    minv = 999;
    maxv = -999;
    shift = (N-1)/2;
    for i = x-shift:x+shift
        for j = y-shift:y+shift
            if i ~= x && j ~= y
                if image(i, j) < minv
                    minv = image(i, j);
                end
                if image(i, j) > maxv
                    maxv = image(i, j);
                end
            end
        end
    end       
end

function [minv, maxv] = getLocalExtremas(N, i, j, image)
    shift = (N-1)/2;
    maxv = max(max(image(i-shift:i+shift, j-shift:j+shift)));
    minv = min(min(image(i-shift:i+shift, j-shift:j+shift)));
end
            

    

                
  
    
    
    
    
    
