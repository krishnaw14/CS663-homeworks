function myHarrisCornerDetector(input)

M = size(input,1);
N = size(input,2);

maxI = max(input(:));
minI = min(input(:));

image = 1.0*(input-minI)/(maxI-minI);

dx = [-1 0 1; -1 0 1; -1 0 1];
dy = dx';

Ix = imfilter(image, dx);
Iy = imfilter(image, dy);
 
 Image_eigen_1 = zeros(M,N);
 Image_eigen_2 = zeros(M,N);
 

% [Gx, Gy] = imgradientxy(image);
% 
% figure('name', 'grad x')
% imshow(Gx);
% figure('name', 'grad y')
% imshow(Gy);

G = fspecial('gaussian', 10 , 1.5);
Ix2 = imfilter(Ix.*Ix, G);
Iy2 = imfilter(Iy.*Iy, G);
Ixy = imfilter(Ix.*Iy, G);

determinant_A = Ix2.*Iy2 - Ixy.*Ixy;
trace_A = Ix2 + Iy2;

k = 0.04;
threshold = 0.015;

cornerness_matrix = determinant_A - k*(trace_A.*trace_A);
c = (cornerness_matrix>threshold)*255;

for i = 1:M
    for j = 1:N
        a11 = Ix2(i,j);
        a22 = Iy2(i,j);
        a21 = Ixy(i,j);
        
        A = [a11 a21; a21 a22];
        
        eigen_values = eig(A);
        Image_eigen_1(i,j) = max(eigen_values);
        Image_eigen_2(i,j) = min(eigen_values);
        
    end
end

alpha = zeros(M,N,3);
alpha(:,:,1) = input +c;
alpha(:,:,2) = input ;
alpha(:,:,3) = input ;
 
myNumOfColors = 200;
myColorScale = [ [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' ];

figure('name', 'derivative images')
subplot(2,1,1)
imagesc(Ix);
colormap (myColorScale);
colormap gray;
daspect ([1 1 1]);
axis tight;
colorbar
title('Derivative along X')

subplot(2,1,2)
imagesc(Iy);
colormap (myColorScale);
colormap gray;
daspect ([1 1 1]);
axis tight;
colorbar
title('Derivative along Y')


figure('name', 'Eigen Value Images')
subplot(2,1,1)
imagesc(Image_eigen_1);
colormap (myColorScale);
colormap gray;
daspect ([1 1 1]);
axis tight;
colorbar
title('Larger Eigen Values')

subplot(2,1,2)
imagesc(Image_eigen_2);
colormap (myColorScale);
colormap gray;
daspect ([1 1 1]);
axis tight;
colorbar
title('Smaller Eigen Values')

figure('name', 'cornerness measure')
imagesc(alpha);
colormap (myColorScale);
colormap gray;
daspect ([1 1 1]);
axis tight;
colorbar
title('Cornerness Measure')

figure('name', 'Original Image')
imagesc(image);
colormap (myColorScale);
colormap gray;
daspect ([1 1 1]);
axis tight;
colorbar
title('Cornerness Measure')
    

end