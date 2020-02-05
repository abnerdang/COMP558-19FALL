%=============plot figures===============
clc;
clear all;
%==============plot Gaussian===============
% g = make2DGaussian(99, 50);
% [x, y] = meshgrid(-49:1:49)
% s = surf(x, y, g)

%=============plot LOG====================
% g = make2DLOG(99, 30);
% [x, y] = meshgrid(-49:1:49)
% s = surf(x, y, g)

%==============plot Gabor================
% [x, y] = meshgrid(-49:1:49);
% [even, odd] = make2DGabor(99, 5, 0);
% [even2, odd2] = make2DGabor(99, 20, 0);
% [even3, odd3] = make2DGabor(99, 100, 0);
% figure;
% subplot(3, 2, 1);
% surf(x, y, even);
% title('lambda = 5 ,angle = 0, even')
% subplot(3, 2, 2);
% surf(x, y, odd);
% title('lambda = 5 ,angle = 0, odd')
% subplot(3, 2, 3);
% surf(x, y, even2);
% title('lambda = 20 ,angle = 0, even')
% subplot(3, 2, 4);
% surf(x, y, odd2);
% title('lambda = 20 ,angle = 0, odd')
% subplot(3, 2, 5);
% surf(x, y, even3);
% title('lambda = 100, angle = 0, even')
% subplot(3, 2, 6);
% surf(x, y, odd3);
% title('lambda = 100 ,angle = 0, odd')
%----------------------------------
[x, y] = meshgrid(-49:1:49);
[even, odd] = make2DGabor(99, 20, 0);
[even2, odd2] = make2DGabor(99, 20, 45);
[even3, odd3] = make2DGabor(99, 20, 90);
figure;
subplot(3, 2, 1);
surf(x, y, even);
title('lambda = 20 ,angle = 0, even')
subplot(3, 2, 2);
surf(x, y, odd);
title('lambda = 20 ,angle = 0, odd')
subplot(3, 2, 3);
surf(x, y, even2);
title('lambda = 20 ,angle = 45, even')
subplot(3, 2, 4);
surf(x, y, odd2);
title('lambda = 20 ,angle = 45, odd')
subplot(3, 2, 5);
surf(x, y, even3);
title('lambda = 20, angle = 90, even')
subplot(3, 2, 6);
surf(x, y, odd3);
title('lambda = 20 ,angle = 90, odd')
%==============plot Gabor================
% [even, odd] = make2DGabor(99, 5, 0);
% [x, y] = meshgrid(-49:1:49);
% [even2, odd2] = make2DGabor(99, 20, 30);
% figure(1)
% subplot(2, 2, 1)
% surf(x, y, even)
% subplot(2, 2, 2)
% surf(x, y, odd)
% subplot(2, 2, 3)
% surf(x, y, even2)
% subplot(2, 2, 4)
% surf(x, y, odd2)

