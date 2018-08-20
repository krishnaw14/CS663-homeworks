%% Report - Bilateral Filtering
clear;
warning('off','MATLAB:dispatcher:nameConflict');
clc;
disp('IMPORTANT REMARKS:')
disp('1. RMSD value is subject to change slightly with each run of code as the noisy image which is input to the filter is different for each run.');
disp('2. RMSD values for the four different cases were computed for each image by calling the function myBilateralFiltering() again and again.');
%% honeyCombReal_Noisy.mat
tic;
imagePath = '../data/honeyCombReal_Noisy.mat';
[newImage, RMSD] = myBilateralFiltering(imagePath, 0.2, 0.6, 3);
disp('Optimal sigma_intensity_gaussian = 0.2');
disp('Optimal sigma_spatial_gaussian = 0.6');
disp(strcat('Optimal RMSD value =  ' ,string(RMSD)));
% NOTE: This value is subject to change slightly with each run of code because of noise addition. The noisyImage which is input to the filter is different 
% for each run. This value of optimal RMSD was observed for our run of the code.

%GAUSSIAN MASK
spatial_gaussian_mask = fspecial('gaussian', [3 3], 0.6);
gaussianMask(3, 0.6);

%Printing RMSD values (values obtained by calling the function myBilateralFiltering() for different sigma)
disp('RMSD values for different sigma :');
disp('(a) 0.9*sigma_spatial and sigma_intensity = 0.043005');
disp('(b) 1.1*sigma_spatial and sigma_intensity = 0.042661');
disp('(c) sigma_spatial and 0.9*sigma_intensity = 0.042686');
disp('(d) sigma_spatial and 1.1*sigma_intensity = 0.042504');
clear;
%% grassNoisy.mat
imagePath2 = '../data/grassNoisy.mat';
[newImage2, RMSD] = myBilateralFiltering(imagePath2, 0.2, 0.6, 3);
disp('Optimal sigma_intensity_gaussian = 0.2');
disp('Optimal sigma_spatial_gaussian = 0.6');
disp(strcat('Optimal RMSD value =  ' ,string(RMSD)));

%GAUSSIAN MASK
spatial_gaussian_mask = fspecial('gaussian', [3 3], 0.6);
gaussianMask(3, 0.6);

%Printing RMSD values (values obtained by calling the function myBilateralFiltering() for different sigma)
disp('RMSD values for different sigma :');
disp('(a) 0.9*sigma_spatial and sigma_intensity = 0.021392');
disp('(b) 1.1*sigma_spatial and sigma_intensity = 0.021585');
disp('(c) sigma_spatial and 0.9*sigma_intensity = 0.021572');
disp('(d) sigma_spatial and 1.1*sigma_intensity = 0.021453');
clear;
%% barbara.mat
imagePath3 = '../data/barbara.mat';
% barbara.mat is a 512*512 image and hence we use 7*7 windows for filtering
[newImage3, RMSD] = myBilateralFiltering(imagePath3, 0.12, 1, 7);
disp('Optimal sigma_intensity_gaussian = 0.12 ');
disp('Optimal sigma_spatial_gaussian = 1.0 ');
disp(strcat('Optimal RMSD value =  ' ,string(RMSD)));
fprintf('\n');
%GAUSSIAN MASK
spatial_gaussian_mask = fspecial('gaussian', [7 7], 1);
gaussianMask(7, 1);

%Printing RMSD values (values obtained by calling the function myBilateralFiltering() for different sigma)
disp('RMSD values for different sigma :');
disp('(a) 0.9*sigma_spatial and sigma_intensity = 0.066689');
disp('(b) 1.1*sigma_spatial and sigma_intensity = 0.066354');
disp('(c) sigma_spatial and 0.9*sigma_intensity = 0.066583');
disp('(d) sigma_spatial and 1.1*sigma_intensity = 0.066864');
toc;