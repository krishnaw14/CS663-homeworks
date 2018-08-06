%% MyMainScript

tic;
%% Your code here
input_path_1 = '../data/barbaraSmall.png';
input_path_2 = '../data/circles_concentric.png';
output = myNearestNeighborInterpolation(input_path_1);
output = myBilinearInterpolation(input_path_1);
output = myBilinearInterpolation(input_path_2);

toc;
