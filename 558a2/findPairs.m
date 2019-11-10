function pairs = findPairs(Hsource, Htarget)
    sizes = size(Hsource, 1);
    sizet = size(Htarget, 1);
    flag = zeros(sizet, 1);
    % normalize the histogram
    % notice there are still 0s in the sift feature vectors
    for i = 1:sizes
        if sum(Hsource(i, 4:end)) == 0
            continue;
        else
            Hsource(i, 4:end) = Hsource(i, 4:end)./sum(Hsource(i, 4:end));
        end
    end
    
    for i = 1:sizet
        if sum(Htarget(i, 4:end)) == 0
            continue;
        else
            Htarget(i, 4:end) = Htarget(i, 4:end)./sum(Htarget(i, 4:end));
        end
    end
    
    pairs = [];  
    for i = 1:sizes
        pairtmp = [i, -1];
        Hstmp = Hsource(i, 4:end);
        if sum(Hstmp) == 0
            continue;
        end
        dmin = 1;
        jmin = -1;
        for j = 1:sizet
            if flag(j) == 1
                continue;
            end
            Httmp = Htarget(j, 4:end);
            if sum(Httmp) == 0
                continue;
            end
            dtmp = Bhattacharya(Hstmp, Httmp);
            if dtmp < dmin
                pairtmp(2) = j;
                dmin = dtmp;
                jmin = j;
            end
        end
        if jmin > 0
            flag(jmin) = 1;
            pairs = [pairs; pairtmp];  
        end
    end
end