%% Report - Unsharp Masking

tic;

%% superMoonCrop.mat :
%
% Standard deviation of the gaussian function was taken as 5.
% 
% Scaling factor was taken as 1.0
input_path = '../data/superMoonCrop.mat';
output = myUnsharpMasking(input_path, 5, 1);


%% lionCrop.mat:
% 
%  Standard deviation of the gaussian function was taken as 2.8.
%  
%  Scaling factor was taken as 1.1
input_path = '../data/lionCrop.mat';
output = myUnsharpMasking(input_path, 2.8, 1.1);

toc;
