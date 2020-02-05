function [inliers, H] = getHomography(keyp1, keyp2, indexp)
    % get a 4-tuple (x1, y1, x2, y2)
    pairs = zeros(size(indexp, 1), 4);
    for i = 1:size(indexp, 1)
        pairs(i, :) = ...
            [keyp1(indexp(i, 1), 1:2) keyp2(indexp(i, 2), 1:2)];
    end
    
    inliers = [];
    max_cnum = 0;
    for k = 1:30
        % get random number
        fouri = randi([1, size(indexp, 1)], 4, 1);
        while length(fouri) ~= length(unique(fouri))
            fouri = randi([1, size(indexp, 1)], 4, 1);
        end
        fourp = pairs(fouri, :);
        % randomly choose 4 4-tuples
        x1 = fourp(1, 1);
        y1 = fourp(1, 2);
        x1h = fourp(1, 3);
        y1h = fourp(1, 4);
        
        x2 = fourp(2, 1);
        y2 = fourp(2, 2);
        x2h = fourp(2, 3);
        y2h = fourp(2, 4);
        
        x3 = fourp(3, 1);
        y3 = fourp(3, 2);
        x3h = fourp(3, 3);
        y3h = fourp(3, 4);
        
        x4 = fourp(4, 1);
        y4 = fourp(4, 2);
        x4h = fourp(4, 3);
        y4h = fourp(4, 4);
        A = ...
            [x1, y1, 1, 0, 0, 0, -x1h*x1, -x1h*y1, -x1h; ...
            0, 0, 0, x1, y1, 1, -y1h*x1, -y1h*y1, -y1h; ...
            x2, y2, 1, 0, 0, 0, -x2h*x2, -x2h*y2, -x2h; ...
            0, 0, 0, x2, y2, 1, -y2h*x2, -y2h*y2, -y2h; ...
            x3, y3, 1, 0, 0, 0, -x3h*x3, -x3h*y3, -x3h; ...
            0, 0, 0, x3, y3, 1, -y3h*x3, -y3h*y3, -y3h; ...
            x4, y4, 1, 0, 0, 0, -x4h*x4, -x4h*y4, -x4h; ...
            0, 0, 0, x4, y4, 1, -y4h*x4, -y4h*y4, -y4h];
        H_cur = null(A);
        if size(H_cur, 2) > 1
            continue;
        end
        % H_cur = H_cur/H_cur(9);
        H_cur = [H_cur(1:3)'; H_cur(4:6)'; H_cur(7:9)'];
        cons_th = 5;
        cons_points = [];
        for i = 1:size(indexp, 1)
            cur_p = pairs(i, :);
            pixel1 = [cur_p(1:2), 1];
            xh = cur_p(3);
            yh = cur_p(4);
            pixelt = H_cur*pixel1';
            pixelt = (pixelt/pixelt(3))';
            xt = pixelt(1);
            yt = pixelt(2);
            dist = (xh-xt)^2 + (yh-yt)^2;
            if dist < cons_th
                cons_points = [cons_points; cur_p];
            end
        end
        if size(cons_points, 1) > max_cnum
            max_cnum = size(cons_points, 1);
            inliers = cons_points;
        end
    end
    
    matrix_A = [];
    for i = 1:size(inliers,1) 
        x = inliers(i, 1);
        y = inliers(i, 2);
        xh = inliers(i, 3);
        yh = inliers(i, 4);
        matrix_A = [matrix_A;...
            x, y, 1, 0, 0, 0, -xh*x, -xh*y, -xh; ...
            0, 0, 0, x, y, 1, -yh*x, -yh*y, -yh];
    end
    
    matric_AAT = matrix_A'*matrix_A;
    [V, D] = eig(matric_AAT);
    [~, ind] = sort(diag(D));
    Vs = V(:,ind);
    H = Vs(:, 1);
    H = [H(1:3)'; H(4:6)'; H(7:9)'];
end














