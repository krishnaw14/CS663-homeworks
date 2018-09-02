function myHarrisCornerDetector(input)

M = size(input,1);
N = size(input,2);

G = fspecial('gaussian', 5 , 1);
input = imfilter(input, G);

image = myLinearContrastStretching(input/255);

dx = [-1 0 1; -1 0 1; -1 0 1];
dy = dx';

Ix = imfilter(image, dx);
Iy = imfilter(image, dy);
 
Image_eigen_1 = zeros(M,N);
Image_eigen_2 = zeros(M,N);

G = fspecial('gaussian', 8 , 1.5);
Ix2 = imfilter(Ix.*Ix, G);
Iy2 = imfilter(Iy.*Iy, G);
Ixy = imfilter(Ix.*Iy, G);

determinant_A = Ix2.*Iy2 - Ixy.*Ixy;
trace_A = Ix2 + Iy2;

k = 0.06;
threshold = 0.04;

cornerness_matrix = determinant_A - k*(trace_A.*trace_A);
cornerness = (cornerness_matrix>threshold)*255;

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
 
myNumOfColors = 200;
myColorScale = [ [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' ];

figure('name', 'Original Image after gaussian smoothing and intensity rescaling')
imagesc(image);
colormap (myColorScale);
colormap gray;
daspect ([1 1 1]);
axis tight;
colorbar
title('Original Image after gaussian smoothing and intensity rescaling')

figure('name', 'derivative images')
subplot(1,2,1)
imshow(Ix);
colormap (myColorScale);
colormap gray;
daspect ([1 1 1]);
axis on;
colorbar
title('Derivative along X')

subplot(1,2,2)
imshow(Iy);
colormap (myColorScale);
colormap gray;
daspect ([1 1 1]);
axis on;
colorbar
title('Derivative along Y')


figure('name', 'Eigen Value Images')
subplot(1,2,1)
imagesc(Image_eigen_1);
colormap (myColorScale);
colormap gray;
daspect ([1 1 1]);
axis tight;
colorbar
title('Larger Eigen Values')

subplot(1,2,2)
imagesc(Image_eigen_2);
colormap (myColorScale);
colormap gray;
daspect ([1 1 1]);
axis tight;
colorbar
title('Smaller Eigen Values')

figure('name', 'cornerness measure')
imagesc(cornerness);
colormap (myColorScale);
colormap gray;
daspect ([1 1 1]);
axis tight;
colorbar
title('Cornerness Measure')
    

end