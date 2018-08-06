%% MyMainScript

tic;
%% Your code here



input_path = '../data/barbara.png';
HM_input_path = '../data/retina.png';
HM_ref_path = '../data/retinaRef.png';
HM_input_mask_path = '../data/retinaMask.png';
HM_ref_mask_path = '../data/retinaRefMask.png';

output_Linear = myLinearContrastStretching(input_path);
output_HE = myHE(input_path);
output_AHE = myAHE(input_path);
output_CLAHE = myCLAHE(input_path);
output_HM = myHM(HM_input_path, HM_ref_path, HM_input_mask_path, HM_ref_mask_path);

toc;