function hist = getHistgram(mag, dir)
    hist = zeros(1, 36);
    for i = 1:size(mag, 1)
        for j = 1:size(mag, 2)
            cur = dir(i, j)+180.0;
            % index begin from 0
            index = floor(cur/10);
            hist(index+1) = hist(index+1) + mag(i, j);
        end
    end         
end
