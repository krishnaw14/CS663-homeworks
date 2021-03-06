
a  = imread('../data/barbara256.png');
b = fft2(double(a));
b1 = fftshift(b);
[m,n] = size(a);
sigma = 50;
i = 0:m-1;
j = 0:n-1;
Cx = 0.5*n;
Cy = 0.5*m;
[A,B] = meshgrid(i,j);
L=exp(-((A-Cx).^2+(B-Cy).^2)./(2*sigma).^2);
D = b1.*L;
D1=ifftshift(D);
B1=ifft2(D1);
figure(1)
imshow(a);
title('original Image');
%imshow(abs(B1),[40 80]);
figure(2)
imshow(abs(B1),[40 80]);
title('Output - For Gaussian filter')
