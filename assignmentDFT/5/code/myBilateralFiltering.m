function [newImage, rmsd] = myBilateralFiltering(originalImage, sigmaR, sigmaS, windowSize)
[rows, cols] = size(originalImage);
size_ = rows;
%corrupting the image with noise
sd = 20;
noisyImage = originalImage + sd*randn(size(originalImage));

%parameters for the bilateral filter
global sigmar; %standard deviation for the range-based gaussian
global sigmas; %standard deviation for the spatial gaussian
sigmar = sigmaR;
sigmas = sigmaS; 

%kernel for each pixel is chosen to be of size 3*3
newImage = eye(size_); %initialising the new image

for i=1:rows
    for j=1:cols
        newImage(i,j) = bilateralFilter(windowSize, noisyImage, i, j);
    end
end

rmsd = (norm(newImage - originalImage, 'fro'))/256; %'fro' stands for frobenius norm

% Displaying the input and output image 
myNumOfColors = 200;
myColorScale = [ [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' ];

figure('name', 'Bilateral Filtering')
subplot(3,1,1)
imagesc(originalImage);
colormap (myColorScale);
colormap gray
daspect ([1 1 1]);
axis tight;
colorbar
title('Original Image');
colorbar

subplot(3,1,2)
imagesc(noisyImage);
colormap (myColorScale);
%o2=get(gca,'Position');
colormap gray
% set(gca,'Position',o2)
daspect ([1 1 1]);
axis tight;
colorbar
title('Noisy Image');
colorbar

subplot(3,1,3)
imagesc(newImage);
%o2=get(gca,'Position');
colormap (myColorScale);
colormap gray
% set(gca,'Position',o2)
daspect ([1 1 1]);
axis tight;
colorbar
title(strcat('Filtered Image, ',  "RMSD = ", string(rmsd)));
colorbar
end

function pixelValue = bilateralFilter(windowSize, image, i, j)
    global sigmas;
    global sigmar;
    window = generateWindow(windowSize, image, i, j);
    [rowsWin, colsWin] = size(window);
    spatialGaussianWeights = fspecial('gaussian', size(window), sigmas); %approximation for edge pixels
    intensityGaussianWeights = eye(size(window)); %initialising the intensity gaussian mask
    for io=1:rowsWin
        for jo=1:colsWin
            intensityGaussianWeights(io,jo) = gaussianFunction(window(io,jo) - image(i,j), sigmar);
        end
    end
    kernel = times(spatialGaussianWeights, intensityGaussianWeights); %element-wise multiplication
    numerator = sum(sum(times(window, kernel)));
    denominator = sum(sum(kernel));
    pixelValue = numerator/denominator;
end

function window = generateWindow(windowSize, image,i,j)
    w= (windowSize - 1)/2; %w = 1 for a 3*3 window, w = 2 for a 5*5 window and so on ....
    [rows, cols] = size(image);
    x1 = max(i-w, 1); 
    x2 = min(i+w, rows);
    y1 = max(j-w, 1);
    y2 = min(j+w, cols);
    window = image(x1:x2, y1:y2);
end

function gaussx = gaussianFunction(x, standardDeviation)
        gaussx = (1/(standardDeviation*sqrt(2*pi)))*exp(-x*x/(2*standardDeviation*standardDeviation));
end