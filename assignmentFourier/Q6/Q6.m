%Image I - 300x300
in = imread('I.jpg');
[x,y]=size(in);
%take a fourier transform
H=fftshift(fft2(in));
%define shift paramet
x1 = -30;
y1 = 70;
%the shift in frequency domain
[X,Y] = meshgrid(-150:149,-150:149);
%the transform equation 
H=H.*exp(-1i*2*pi.*(X*x1+Y*y1)/300);
IF = ifft2(ifftshift(H));
figure;
imshow(real(IF));
figure;
imshow(in);