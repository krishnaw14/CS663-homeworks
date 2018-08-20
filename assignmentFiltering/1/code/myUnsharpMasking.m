function output = myUnsharpMasking(input_path, sigma, scale)

load(input_path);
input = imageOrig;

blurred = imgaussfilt(input, sigma);

output = input + (input-blurred)*scale;

% Displaying the input and output image 
myNumOfColors = 200;
myColorScale = [ [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' ];

figure('name', 'Unsharp Masking')
subplot(2,2,1) 
imagesc(input);
colormap (myColorScale);
colormap gray;
daspect ([1 1 1]);
axis tight;
colorbar
title('Input Image')

subplot(2,2,2) 
imagesc(output);
colormap (myColorScale);
colormap gray;
daspect ([1 1 1]);
axis tight;
colorbar
title('Output Image')

subplot(2,2,3) 
imagesc(myLinearContrastStretching(input));
colormap (myColorScale);
colormap gray;
daspect ([1 1 1]);
axis tight;
colorbar
title('After linear contrast stretching')

subplot(2,2,4) 
imagesc(myLinearContrastStretching(output));
colormap (myColorScale);
colormap gray;
daspect ([1 1 1]);
axis tight;
colorbar
title('After Linear Contrast Stretching')

end

