tic;

image_path = '../data/barbara256-part.png';
image = double(imread(image_path));

output_1 = myPCADenoising1(image); 

rmse_value_1 = norm((image(:) - output_1(:) ))/norm(image(:));

fprintf('\n For myPCADenoising1: \n')
fprintf('Final RMSE Value between the input and output image: %f \n', rmse_value_1);
fprintf('\n\n\n')

output_2 = myPCADenoising2(image);
rmse_value_2 = norm((image(:) - output_2(:) ))/norm(image(:));

fprintf('\n For myPCADenoising2: \n')
fprintf('Final RMSE Value between the input and output image: %f \n', rmse_value_2);
fprintf('\n\n\n')


fprintf('Displaying the final output separately as well \n')
figure('name', 'PCADenoising1')
imshow(output_1, []);
figure('name', 'PCADenoising2')
imshow(output_2, []);

toc;