function [newImage, rmsd] = myBilateralFiltering(imagePath, sigmaR, sigmaS, windowSize)
load(imagePath);

if isequal(imagePath, '../data/barbara.mat') 
    originalImage = imageOrig/100;
else
    originalImage = imgCorrupt;
end

[rows, cols] = size(originalImage);
size_ = rows;
%corrupting the image with noise
sd = 0.05*(max(max(originalImage)) - min(min(originalImage)));
noisyImage = eye(size_);
for i=1:rows
    for j=1:cols
        noisyImage(i,j) = originalImage(i,j) + sd*randn;
    end
end

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

figure('name', 'Bilateral Filtering')
subplot(1,3,1)
imagesc(originalImage);
o1=get(gca,'Position');
colormap gray
set(gca,'Position',o1)
title('Original Image');
colorbar

subplot(1,3,2)
imagesc(noisyImage);
o2=get(gca,'Position');
colormap gray
set(gca,'Position',o2)
title('Noisy Image');
colorbar

subplot(1,3,3)
imagesc(newImage);
o2=get(gca,'Position');
colormap gray
set(gca,'Position',o2)
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