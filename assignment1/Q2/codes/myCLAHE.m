function output = myAHE(input_path)

input = imread(input_path, 'png');

rows = size(input,1);
columns = size(input,2);
channels= size(input,3);

output = zeros(size(input));

w=100;

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
            output(i, j, c) =CDF(index+1);
        
        end
    end
end

% Displaying the input and output image 
myNumOfColors = 200;
myColorScale = [ [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' ];

figure('name', 'CLAHE Image')
subplot(2,1,1) 
imagesc(input);
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
%figure('name', 'CLAHE Image')
imagesc(output);
colormap (myColorScale);
if channels == 1
    colormap gray;
else
    colormap jet;
end
daspect ([1 1 1]);
axis tight;
colorbar
title('Adaptive Histogram Equalized Image (W=100, clip-threshold = 0.25)')
%impixelinfo;

end

function CDF = get_CDF(image)
m=size(image,1);
n=size(image,2);
hist=imhist(image);
hist=hist/(m*n);
CDF = zeros(size(hist));
CDF(1)=hist(1);
threshold = 0.25;
for i=2:size(hist,1)
    %disp(i);
    CDF(i)=CDF(i-1)+min(hist(i),threshold);
end
end