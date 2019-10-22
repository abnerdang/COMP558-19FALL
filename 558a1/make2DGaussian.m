function g = make2DGaussian(N, sigma)
    for x = 1:N
        for y = 1:N
            %compute the 2DGaussian
            g(x,y) = exp(-((x-(N+1)/2)^2+(y-(N+1)/2)^2)/(2*sigma^2));
        end
    end
    %normalize
    g = g/sum(sum(g));
end 