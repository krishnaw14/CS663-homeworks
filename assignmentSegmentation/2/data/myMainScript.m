tic;
%% OPTIMAL VALUES
disp('Gaussian Kernel Bandwidth for Spatial Feature = 32')
disp('Gaussian Kernel Bandwidth for Color Feature = 16')
disp('Number of Iterations = 10')
%%
hs = 32;
hr = 16;
k = 25; % equal to number of nearest neighbours for each pixel
numberOfIterations = 10;
newImage = myMeanShiftSegmentation(hs,hr,k,numberOfIterations);
toc;