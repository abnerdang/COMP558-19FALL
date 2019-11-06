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

color = {'r', 'g', 'b'};
figure(3);
imshow(original_image);
hold on;
for n = 1:size(keypoint, 1)
    radius = keypoint(n, 3);
    coordinate_tmp = [keypoint(n, 1), keypoint(n, 2)];
    level = log2(keypoint(n, 3));
    viscircles(coordinate_tmp.*radius, radius, 'LineWidth', 0.5, 'Color', 'r');
end

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
            

    

                
  
    
    
    
    
    
