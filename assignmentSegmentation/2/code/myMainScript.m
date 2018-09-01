tic;
%% OPTIMAL VALUES
disp('Gaussian Kernel Bandwidth for Spatial Feature = 32')
disp('Gaussian Kernel Bandwidth for Color Feature = 16')
disp('Number of Iterations = 10')
%%
% d is the scaling factor for resizing the 512*512 image. For d=4, we have a 128*128 image.
% This is done to reduce running time.
d=4;
hs = 32;
hr = 16;
k = 25; % equal to number of nearest neighbours for each pixel
numberOfIterations = 10;
newImage = myMeanShiftSegmentation(d,hs,hr,k,numberOfIterations);
toc;