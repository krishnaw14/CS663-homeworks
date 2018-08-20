%% Report - Unsharp Masking

tic;
%% Mainscript Code

input_path = '../data/grassNoisy.mat';

output = myPatchBasedFiltering(imgCorrupt);

%% The parameters were chosen as follows: 
%%% Standard deviation of the gaussian function was taken as 10
%%% Scaling factor was taken as 1

toc;
