function [allpairs, allfeatures, allkeypoints] = getHorizontalPairs(level, threshold)
    inum = 6; 
    allfeatures = cell(inum, 1);
    allkeypoints = cell(inum, 1);
    allpairs = cell(inum-1, 1);
    for i = 1:inum
        path = strcat('horizontal/', num2str(i-1), '.png');
        rgb = imread(path);
        img = single(rgb2gray(rgb));
        [keypoints, features] = sift(img,'Levels',level,'PeakThresh',threshold);
        keypoints = keypoints';
        features = features';
        allkeypoints{i} = keypoints;
        allfeatures{i} = features;
    end
    for i = 1:inum-1
        pairstmp = matchFeatures(allfeatures{i}, allfeatures{i+1});
        allpairs{i} = pairstmp;
    end    
end