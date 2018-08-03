function output = myHE(input_path)

input = imread(input_path, 'png');

rows = size(input,1);
columns = size(input,2);
channels= size(input,3);

output = zeros(size(input));

w=150;

for c=1:channels
    image = input(:,:,c);
    for i=1:rows
        for j=1:columns
            x1 = max(i-w, 1);
            x2 = min(i+w, rows);
            y1 = max(j-w, 1);
            y2 = min(j+w,columns);
 
            window = image(x1:x2, y1:y2);
            CDF = get_CDF(window);
            index = uint8(input(i,j,c)); 
        %disp(index)
            output(i, j, c) =CDF(index+1);
        
        end
    end
end

% Displaying the input and output image 
myNumOfColors = 200;
myColorScale = [ [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' ];

subplot(2,1,1) 
imshow(input);
colormap (myColorScale);

if channels == 1
    colormap gray;
else
    colormap jet;
end
daspect ([1 1 1]);
axis tight;
colorbar
title('Original Image')
%impixelinfo;

subplot(2,1,2) 
imshow(output), colorbar;
colormap (myColorScale);
if channels == 1
    colormap gray;
else
    colormap jet;
end
daspect ([1 1 1]);
axis tight;
colorbar
title('Adaptive Histogram Equalized Image')
%impixelinfo;

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