%% MyMainScript

%% Parameter Values
% k = 0.06
% threshold = 0.04
% sigma of Gaussian blurring applied to derivative images = 1.5 with a window of 8
% sigma of Gaussian blurring applied to input images = 1 with a window of 5

tic;
%% Your code here

load('../data/boat.mat');
myHarrisCornerDetector(imageOrig);

toc;
