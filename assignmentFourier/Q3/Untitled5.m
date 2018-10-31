x = imread('test.png');
a = fft2(double(x));
a1 = fftshift(x);
imtool((a1),[]);
[m,n]=size(x);

t = 0:pi/20:2*pi;
x1 = (m+150)/2;
y1 = (n+150)/2;
r=400;
r1=300;
x2 = r*cos(t)+x1;
y2 = r*sin(t)+y1;
x3 = r1*cos(t)+x1;
y3 = r1*sin(t)+y1;
mask = poly2mask(double(x2),double(y2), m,n);
mask1 = poly2mask(double(x3),double(y3), m,n);
mask(mask1)=0;
b1 = a1;
b1(mask)=0;
imtool(abs(b1),[]);
op = ifft2(ifftshift(b1));
imtool(op,[]);