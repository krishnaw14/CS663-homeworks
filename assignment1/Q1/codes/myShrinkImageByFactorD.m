function [out_2, out_3] = myShrinkImageByFactorD(input_path)

img = imread(input_path);
d=2;
e=3;
out_2 = img(1:d:end,1:d:end); %Uniform Sampling
out_3 = img(1:e:end,1:e:end);

figure('name', 'Image Shrinking');
subplot(1,3,1)
imagesc(img)
o1=get(gca,'Position');
colormap gray
axis on
set(gca,'Position',o1)
title('Original Image')
colorbar

subplot(1,3,2)
imagesc(out_2)
o2=get(gca,'Position');
colormap gray
colorbar
axis on
set(gca,'Position',o2)
title('Resized Image, d=2')

subplot(1,3,3)
imagesc(out_3)
o3=get(gca,'Position');
colormap gray
colorbar
axis on
set(gca,'Position',o3)
title('Resized Image, d=3')

end