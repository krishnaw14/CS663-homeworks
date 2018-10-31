
image_path = '../data/barbara256-part.png';
image = double(imread(image_path));

output = myPCADenoising1(image); 

rmse_value = norm((image(:) - output(:) ))/norm(image(:));

fprintf('\n Final RMSE Value between the input and output image: %f \n', rmse_value);