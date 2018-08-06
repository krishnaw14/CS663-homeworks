function output = myAHE(input_path)

input = imread(input_path, 'png');

M = size(input,1);
N = size(input,2);
C = size(input,3);

output = zeros(size(input));

w=100;

for c=1:C
    image = input(:,:,c); %Processing each channel of the image independently
    for i=1:M
        for j=1:N
            %Cropping the window to prvent it from going out of boundary 
            x1 = max(i-w, 1); 
            x2 = min(i+w, M);
            y1 = max(j-w, 1);
            y2 = min(j+w,N);
 
            window = image(x1:x2, y1:y2);
            CDF = get_CDF(window); %Function for calculating CDF of an image channel is defined below
            index = uint8(input(i,j,c)); 
            output(i, j, c) =CDF(index+1);
        
        end
    end
end

% Displaying the input and output image 
myNumOfColors = 200;
myColorScale = [ [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' ];

figure('name', 'AHE Images')
subplot(2,1,1)
%figure('name', 'Original Image')
imagesc(input);
daspect ([1 1 1]);
axis tight;
colormap (myColorScale);
title('Original Image')
if C == 1
    colormap gray;
else
    colormap jet;
end
colorbar

subplot(2,1,2) 
%figure('name', 'Adaptive Histogram Equalized Image')
imagesc(output);
daspect ([1 1 1]);
axis tight;
colormap (myColorScale);
title('Adaptive Histogram Equalized Image (Window size = 100)')
if C == 1
    colormap gray;
else
    colormap jet;
end
colorbar

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