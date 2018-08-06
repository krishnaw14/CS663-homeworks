function output = myHE(input_path)

input = imread(input_path, 'png');

M = size(input,1); 
N = size(input,2);
C = size(input,3);

output = zeros(size(input)); % Allocating the space for output

for c=1:C
    %Performing histogram equalization on each channel of the image
    histogram = imhist(input(:,:,c));
    histogram = histogram/(M*N);
    CDF = zeros(size(histogram));
    CDF(1) = histogram(1);
    
    %Computing the CDF for the cth channel of the image
    for a=2:size(histogram)
        CDF(a)=CDF(a-1)+histogram(a);
    end
    
    %Redistributing the colour intensity based on the CDF mapping
    for i=1:M
        for j=1:N
            index = uint8(input(i,j,c));
            output(i,j,c) = CDF(index+1);
        end
    end
    
end

% Displaying the input and output image 
myNumOfColors = 200;
myColorScale = [ [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' ];

figure('name', 'HE Image')
subplot(2,1,1) 
imagesc(input);
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
%impixelinfo;

subplot(2,1,2) 
imagesc(output);
colormap (myColorScale);
if C == 1
    colormap gray;
else
    colormap jet;
end
daspect ([1 1 1]);
axis tight;
colorbar
title('Histogram Equalized Image')
%impixelinfo;
end
