%Image I - 300x300
in = imread('I.png');
in = imnoise(in,'gaussian',0,20);
[x,y]=size(in);
%take a fourier transform
H=fftshift(fft2(in));
%define shift parameters
x1 = -30;
y1 = 70;
%the shift in frequency domain
[X,Y] = meshgrid(-150:149,-150:149);
%the equation in the paper
H=H.*exp(-1i*2*pi.*(X*x1+Y*y1)/300);
IF = ifft2(ifftshift(H));
%show the images
figure;
imshow(real(IF));
figure;
%time complexity - N^2
imshow(in);
%after addition of noise, the image seems to get brighter on transform
