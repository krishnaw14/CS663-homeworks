function output = myHE(input_path)

input = imread(input_path, 'png');

rows = size(input,1);
columns = size(input,2);
channels= size(input,3);

%fprintf('Rows: %i \n', rows);
%fprintf('Columns: %i \n', columns);
%fprintf('Channels: %i \n', channels);

outputs = zeros(size(input));

for c=1:channels
    image = input(:,:,c);
    %figure('Name','image'), imshow(image);
    histogram = imhist(image);
    histogram = histogram/(rows*columns);
    CDF = zeros(size(histogram));
    CDF(1) = histogram(1);
    
    for a=2:256
        CDF(a)=CDF(a-1)+histogram(a);
    end
    %figure('Name','hist'), plot(CDF);
    for i=1:rows
        for j=1:columns
            index = uint8(input(i,j,c));
            output(i,j,c) = CDF(index+1);
        end
    end
end

% Displaying the input and output images together 
myNumOfColors = 200;
myColorScale = [ [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' ];

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
title('Histogram Equalized Image')
%impixelinfo;
end
