function pairs = findPairs(Hsource, Htarget)
    sizes = size(Hsource);
    sizet = size(Htarget);
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
        for j = 1:sizet
            Httmp = Htarget(j, 4:end);
            if sum(Httmp) == 0
                continue;
            end
            dtmp = Bhattacharya(Hstmp, Httmp);
            if dtmp < dmin
                pairtmp(2) = j;
                dmin = dtmp;
            end
        end
        pairs = [pairs; pairtmp];      
    end
end