function [even, odd] = make2DGabor(N, lamda, angle)
    for m = 1 : N
        for n = 1 : N
            x = m-1-(N-1)/2;
            y = n-1-(N-1)/2;
            even(m, n) = exp(-(x^2+y^2)/(2*lamda^2))*cos(2*pi*x/lamda);
            odd(m, n) = exp(-(x^2+y^2)/(2*lamda^2))*sin(2*pi*x/lamda);
        end
    end
    even = imrotate(even, angle, 'bilinear', 'crop');
    odd = imrotate(odd, angle, 'bilinear', 'crop');
end