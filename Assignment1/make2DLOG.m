function g = make2DLOG(N, sigma) 
    for m = 1 : N
        for n = 1 : N
            x = m-1-(N-1)/2;
            y = n-1-(N-1)/2;
            item1 = -1/(pi*(sigma^4));
            item2 = (x^2+y^2)/(2*(sigma^2));
            g(m, n) = item1*(1-item2)*exp(-item2);
        end
    end
end 

% =========for display============
% g = make2DLOG(99, 1);
% [x, y] = meshgrid(-49:1:49)
% s = surf(x, y, g)
