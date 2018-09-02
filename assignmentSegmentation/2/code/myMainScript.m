tic;
%% OPTIMAL VALUES
disp('Gaussian Kernel Bandwidth for Spatial Feature = 1')
disp('Gaussian Kernel Bandwidth for Color Feature = 1.5')
disp('Number of Iterations = 15')
%%
% d is the scaling factor for resizing the 512*512 image. For d=4, we have a 128*128 image.
% This is done to reduce running time.
d=4;
hs = 1;
hr = 1.5;
k = 5; % equal to number of nearest neighbours for each pixel
numberOfIterations = 15;
newImage = myMeanShiftSegmentation(d,hs,hr,k,numberOfIterations);
toc;