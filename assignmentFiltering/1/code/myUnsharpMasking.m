function output = myUnsharpMasking(input_path)

load(input_path);
image = imageOrig;


%Parameters to tune
sigma = 10;
scale = 1;

blurred = imgaussfilt(image, sigma);

output = image + (image-blurred)*scale;

figure('name', 'Original Image');
imshow(image);

figure('name', 'Blurred Image');
imshow(blurred);

figure('name', 'Output Image');
imshow(output);

figure('name', 'Input Image - After LCS');
imshow(myLinearContrastStretching(imageOrig));

figure('name', 'Output Image - AfterLCS');
imshow(myLinearContrastStretching(output));


end