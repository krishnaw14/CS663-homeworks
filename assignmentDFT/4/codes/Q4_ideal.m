img=imread('../data/barbara256.png');
P=50;%somewhere between 40-80
[M,N]=size(img);
F=fft2(double(img));
u=0:(M-1);
v=0:(N-1);
idx=find(u>M/2);
u(idx)=u(idx)-M;
idy=find(v>N/2);
v(idy)=v(idy)-N;
[V,U]=meshgrid(v,u);
D=sqrt(U.^2+V.^2);
H=double(D<=P);
G=H.*F;
g=real(ifft2(double(G)));
figure(3)
imshow(img)
title('original Image');
figure(4)
imshow(g,[ ]);
title('Output - For ideal filter');