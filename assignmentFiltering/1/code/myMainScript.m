%% MyMainScript

tic;
%% Your code here

input_path = '../data/superMoonCrop.mat';
input = imread(input_path);
unsharp_output = myUnsharpMasking(input_path);
final_input = myLinearContrastStretching(unsharp_output);
final_output = myLinearContrastStretching(unsharp_output);


toc;
