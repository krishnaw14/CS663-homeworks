function output = myLinearContrastStretching(input_path)

input = imread(input_path);
%disp(size(input,1));
M = size(input,1);
N = size(input,2);
C = size(input,3);

%fprintf('Rows: %i \n', M);
%fprintf('Columns: %i \n', N);
%fprintf('Channels: %i \n', C);
output = zeros(size(input));

for c=1:C
 %   disp(c);
CDF = get_CDF(input(:,:,c));

[temp,x1] = min(abs(CDF-0.25));
[temp,x2] = min(abs(CDF-0.75));
y1 = CDF(x1);
y2 = CDF(x2);
x3 = size(CDF,1);
y3 = CDF(x3);

map_1 = y1*(1:x1)/x1;
%disp(size(map_1));
map_2 = y1 + ( (y2-y1)/(x2-x1) )*( (x1+1:x2)-x1);
%disp(size(map_2));
map_3 = y2 + ((y3-y2)/(x3-x2) ) * ( (x2+1:x3)-x2 );
%disp(size(map_3));
map = horzcat(map_1, map_2, map_3);

for i=1:M
        for j=1:N
            index = uint8(input(i,j,c));
            %fprintf('%i \n', index);
            output(i,j,c) = map(1, index+1);
        end
end
end
    
% plot(1:256, CDF)
% hold on
% plot(1:256, map)
% hold off

% Displaying the input and output image 
myNumOfColors = 200;
myColorScale = [ [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' ];

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
%B = im2double(image);
m=size(image,1);
n=size(image,2);
hist=imhist(image);
hist=hist/(m*n);
CDF = zeros(size(hist));
CDF(1)=hist(1);
for i=2:size(hist,1)
    %disp(i);
    CDF(i)=CDF(i-1)+hist(i);
end

end
