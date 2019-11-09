function sift = siftPipeline(original_image)
    %====================create Gaussian pyramid============================
    gaupyramid = cell(7, 1);
    kernel_size = 5;
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
    end
    % ====================create Laplacian pyramid============================
    lplpyramid = cell(6, 1);
    for i = 1:6 
        low = gaupyramid{i};
        high = gaupyramid{i+1};
        high = imresize(high, 2);
        lplpyramid{i} = high - low;
    end
    % ====================Find SIFT features============================
    keypoint = [];
    th = 3;
    spatial_size = 3;
    shift = (spatial_size-1)/2;
    sift_window = zeros(spatial_size*spatial_size, spatial_size);
    for l_num = 2:5
        current = lplpyramid{l_num};
        previous = imresize(lplpyramid{l_num-1}, 0.5);
        next = imresize(lplpyramid{l_num+1}, 2);
        for i = 2:size(current, 1)-1
            for j = 2:size(current, 2)-1
                sift_window(1:spatial_size, 1:spatial_size) = current(i-shift:i+shift, j-shift:j+shift);
                sift_window(spatial_size+1:(spatial_size*2), 1:spatial_size) = previous(i-shift:i+shift, j-shift:j+shift);
                sift_window((spatial_size*2+1):spatial_size*3, 1:spatial_size) = next(i-shift:i+shift, j-shift:j+shift);
                sift_window(2, 2) = sift_window(1, 1);
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

%     color = {'b', 'g', 'y', 'm'};
%     figure;
%     imshow(uint8(original_image));
%     hold on;
%     for n = 1:size(keypoint, 1)
%         radius = keypoint(n, 3);
%         coordinate_tmp = [keypoint(n, 2), keypoint(n, 1)];
%         level = log2(keypoint(n, 3));
%         viscircles(coordinate_tmp.*radius, radius, 'LineWidth', 0.5, 'Color', color{level});
%     end

    % ====================Q4. Compute SIFT feature vectors=====================
    gmag = cell(7, 1);
    gdir = cell(7, 1);
    for i = 1:7
        [gmag{i}, gdir{i}] = imgradient(gaupyramid{i});
    end
%     % choose a keypoint
%     selected_point = keypoint(selected_keypoint_index, :);
%     x = selected_point(1);
%     y = selected_point(2);
%     level = log2(selected_point(3))+1;
% 
%     gau_img_tmp = gaupyramid{level};
%     mag_tmp = gmag{level};
%     dir_tmp = gdir{level};
%     x_gmag_tmp = x_gmag{level};
%     y_gmag_tmp = y_gmag{level};


    

%     figure(4);
%     subplot(2, 2, 1);
% 
%     imshow(uint8(gau_img_selected));
%     title('15×15 patch');
%     subplot(2, 2, 2);
%     imshow(mag_selected, []);
%     title('gradient magnitude')
%     subplot(2, 2, 3);
%     imshow(gau_img_selected, []);
%     hold on;
%     [X, Y] = meshgrid(1:15, 1:15);
%     quiver(X, Y, x_gmag_selected, y_gmag_selected);
%     title('gradient vector visualization');
%     subplot(2, 2, 4);
%     imshow(weighted_mag, []);
%     title('weighted gradient magnitude');

    % =========Q5. Orientation histogram for each SIFT key point===========
    hist_raw = zeros(size(keypoint, 1), 39);
    hist_raw(:, 1:3) = keypoint;
    kernel = fspecial('gaussian', [15, 15], 2);
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

%     % plot the histogram of the selected keypoint
%     selected_hist = hist_raw(selected_keypoint_index, 4:end);
%     selected_hista = hist_align(selected_keypoint_index, 4:end);
%     sltd_keypoint = hist_raw(selected_keypoint_index, 1:3); 
%     bin_num = 1:36;
%     figure(5);
%     subplot(1, 2, 1);
%     bar(bin_num, selected_hist);
%     title("Histogram without alignment");
%     subplot(1, 2, 2);
%     bar(bin_num, selected_hista);
%     title("Histogram with alignment");
    sift = hist_align;

    
end