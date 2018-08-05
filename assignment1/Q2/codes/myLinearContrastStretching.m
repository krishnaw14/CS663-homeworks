function output = myLinearContrastStretching(input_path)

input = imread(input_path);

M = size(input,1);
N = size(input,2);
C = size(input,3);

output = zeros(size(input));

%The Linear contrast enhancing function is a piecewise linear function (map)
%formed from 3 Line segments- map_1, map_2 and map_3. We need 4 points to 
%construct this piecewise function, which are obtained from the CDF of the image. 
%The first point is the origin of the CDF- (1,0). Second point is the point where the value of
%CDF is 0.25, so second point is (x1,0.25). Third point is the point where 
%the value of CDF is 0.75, so second point is (x2,0.75). Fourth point is
%the final point of the CDF, that is,  (256,1).

for c=1:C
    CDF = get_CDF(input(:,:,c));
    
    x0 = 1;
    [~,x1] = min(abs(CDF-0.25)); 
    [~,x2] = min(abs(CDF-0.75));
    y1 = CDF(x1);
    y2 = CDF(x2);
    x3 = size(CDF,1);
    y3 = CDF(x3);

    map_1 = y1*(x0:x1)/x1;
    map_2 = y1 + ( (y2-y1)/(x2-x1) )*( (x1+1:x2)-x1);
    map_3 = y2 + ((y3-y2)/(x3-x2) ) * ( (x2+1:x3)-x2 );

    map = horzcat(map_1, map_2, map_3);

    for i=1:M
        for j=1:N
            index = uint8(input(i,j,c));
            output(i,j,c) = map(1, index+1);
        end
    end
end
    
% figure('name', 'CDF and Linear Contrast function')
%  plot(1:256, CDF)
%  hold on
%  plot(1:256, map)
%  title('CDF and Linear Contrast function for barbara.png')
%  legend({'CDF','Linear Contrast Function'}, 'Location','southeast')
%  text(x0, 0, '(x0,y0)')
%  text(x1,y1, '(x1,y1)')
%  text(x2,y2, '(x2,y3)')
%  text(x3,y3, '(x3,y3)')
%  hold off

% Displaying the input and output image 
myNumOfColors = 200;
myColorScale = [ [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' ];

figure('name', 'Images')
subplot(2,1,1)
imshow(input);
colormap (myColorScale);
if C == 1
    colormap gray;
else
    colormap jet;
end
daspect ([1 1 1]);
axis tight;
colorbar
title('Original Image')
impixelinfo

subplot(2,1,2)
imshow(output, [] );
colormap (myColorScale);
if C == 1
    colormap gray;
else
    colormap jet;
end
daspect ([1 1 1]);
axis tight;
colorbar
title('Linear Contrast Enhanced Image')
impixelinfo
impixelinfo
end



function CDF = get_CDF(image)
m=size(image,1);
n=size(image,2);
hist=imhist(image);
hist=hist/(m*n);
CDF = zeros(size(hist));
CDF(1)=hist(1);
for i=2:size(hist,1)
    CDF(i)=CDF(i-1)+hist(i);
end
end
