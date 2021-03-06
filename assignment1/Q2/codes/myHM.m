function output= myHM(input_path, ref_path, input_mask_path, ref_mask_path)

image = im2double(imread(input_path));
ref = im2double(imread(ref_path));
image_mask = imread(input_mask_path);
ref_mask = imread(ref_mask_path);

M = size(image,1);
N = size(image,2);
C = size(image,3);

output = uint8(ones(size(image)));

for c = 1:C
    image_channel = image(:,:,c);
    ref_channel = ref(:,:,c);
    image_cdf = get_CDF(image_channel(image_mask>0)); %get_CDF defined below computed CDF of a single channel image
    ref_cdf = get_CDF(ref_channel(ref_mask>0));        %CDF is only calculated for the foreground 
    for i=1:M
        for j = 1:N
            if image_mask(i,j)>0
            index = uint8(image(i,j,c)*255);
            image_cdf_value = image_cdf(index+1);
            [~, inverse] = min( abs(ref_cdf-image_cdf_value) ); % Index of the value closest to index is essentially the inverse of the CDF function
            output(i,j,c) = uint8(inverse);
            else
                output(i,j,c) = image(i,j,c);
            end
        end
    end
end

% Displaying the input and output image 
myNumOfColors = 200;
myColorScale = [ [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' ];

figure('name', 'HM Image')
subplot(3,1,1)
imagesc(image);
daspect ([1 1 1]);
axis tight;
colormap (myColorScale);
colormap jet;
colorbar
title('Original Image')



subplot(3,1,2)
%figure('name', 'Histogram Matched Image')
imagesc(output);
daspect ([1 1 1]);
axis tight;
colormap (myColorScale);
colormap jet;
colorbar
title('Histogram Matched Image')

subplot(3,1,3)
%figure('name', 'Histogram Equalized Image')
imagesc(histeq(image));
daspect ([1 1 1]);
axis tight;
colormap (myColorScale);
colormap jet;
colorbar
title('Histogram Equalized Image')
        
end

function CDF = get_CDF(image)
m=size(image,1);
n=size(image,2);
hist=imhist(image);
hist=hist/(m*n);
CDF = zeros(size(hist));
CDF(1)=hist(1);
for a=2:size(hist,1)
    CDF(a)=CDF(a-1)+hist(a);
end
end