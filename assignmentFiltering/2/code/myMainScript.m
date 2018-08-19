imagePath = '../data/honeyCombReal_Noisy.mat';
tic;
newImage = myBilateralFiltering(imagePath);
toc;