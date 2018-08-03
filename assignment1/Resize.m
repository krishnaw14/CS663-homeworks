img = imread('circles_concentric.png');
d=2;
e=3;
j = img(1:d:end,1:d:end);
g = img(1:e:end,1:e:end);
figure 
imshow(img)
o1=get(gca,'Position');
colorbar
axis on
set(gca,'Position',o1)
title('Original Image')

figure
imshow(j)
o2=get(gca,'Position');
colorbar
axis on
set(gca,'Position',o2)
title('Resized Image, d=2')

figure
imshow(g)
o3=get(gca,'Position');
colorbar
axis on
set(gca,'Position',o3)
title('Resized Image, d=3')