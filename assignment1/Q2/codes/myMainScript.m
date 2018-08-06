%% MyMainScript

tic;
%% Your code here



input_path = '../data/barbara.png';
HM_input_path = '../data/HMInputImage.png';
HM_ref_path = '../data/HMRefImage.png';

output_Linear = myLinearContrastStretching(input_path);
output_HE = myHE(input_path);
output_AHE = myAHE(input_path);
output_CLAHE = myCLAHE(input_path);
output_HM = myHM(HM_input_path, HM_ref_path );

toc;