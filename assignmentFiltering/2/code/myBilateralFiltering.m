function newImage = myBilateralFiltering(imagePath)
load(imagePath);
originalImage = imgCorrupt;
[rows, cols] = size(imgCorrupt);
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
sigmar = 0.2;
sigmas = 0.8;
%kernel for each pixel is chosen to be of size 3*3
newImage = eye(size_); %initialising the new image

for i=1:rows
    for j=1:cols
        newImage(i,j) = bilateralFilter(noisyImage, i, j);
    end
end

RMSD = (norm(newImage - imgCorrupt, 'fro'))/256;

figure(1)
imshow(imgCorrupt);
title('Original Image');


figure(2)
imshow(noisyImage);
title('Noisy Image');

figure(3)
imshow(newImage);
title(strcat('Filtered Image, sigmar = ', string(sigmar), " , sigmas = ", string(sigmas), ", RMSD = ", string(RMSD)));
end

function pixelValue = bilateralFilter(image, i, j)
    global sigmas;
    global sigmar;
    window = generateWindow(image, i, j);
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

function window = generateWindow(image,i,j)
    w=1; %for a 3*3 window
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