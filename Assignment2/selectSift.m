function ssift = selectSift(shift, pointc, sift)
    rmin = pointc(1)-shift;
    rmax = pointc(1)+shift;
    cmin = pointc(2)-shift;
    cmax = pointc(2)+shift;
    sizes = size(sift, 1);
    ssift = [];
    for i = 1:sizes
        postmp = [sift(i, 1)*sift(i, 3), sift(i, 2)*sift(i, 3)];
        if (postmp(1) > rmin) && (postmp(1) < rmax) && (postmp(2) > cmin) && (postmp(2) < cmax)
            ssift = [ssift; sift(i, :)];
        end
    end
    
end