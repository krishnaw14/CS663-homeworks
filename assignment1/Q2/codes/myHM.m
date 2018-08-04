function output= myHM(input_path, ref_path)

image = im2double(imread(input_path));
%figure, imshow(image);
ref = im2double(imread(ref_path));
%figure, imshow(ref);

M = size(image,1);
N = size(image,2);
C = size(image,3);

% fprintf('M = %f \n', M);
% fprintf('N = %f \n', N);
% fprintf('C = %f \n', C);

%image_cdf = get_CDF(image);
%ref_cdf = get_CDF(image);

output = uint8(ones(size(image)));

for c = 1:C
    image_cdf = get_CDF(image(:,:,c));
    ref_cdf = get_CDF(ref(:,:,c));
    for i=1:M
        for j = 1:N
            index = uint8(image(i,j,c)*255);
            image_cdf_value = image_cdf(index+1);
            %fprintf("IMAGE CDF VALUE!!! %f\n",image_cdf_value);
            %output(i,j,c) = find((ref_cdf-image_cdf_value)*1 >= 0.00001  , 1);
            [value, inverse] = min( abs(ref_cdf-image_cdf_value) );
            output(i,j,c) = uint8(inverse);
        end
    end
end

% Displaying the input and output image 
myNumOfColors = 200;
myColorScale = [ [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' ];

subplot(3,1,1)
imshow(image, []);
daspect ([1 1 1]);
axis tight;
colormap (myColorScale);
colormap jet;
colorbar
title('Original Image')



subplot(3,1,2)
imshow(im2double(output), []);
daspect ([1 1 1]);
axis tight;
colormap (myColorScale);
colormap jet;
colorbar
title('Histogram Matched Image')

subplot(3,1,3)
imshow(histeq(image), []);
daspect ([1 1 1]);
axis tight;
colormap (myColorScale);
colormap jet;
colorbar
title('Histogram Matched Image')
        
end

function CDF = get_CDF(image)
%B = im2double(image);
m=size(image,1);
n=size(image,2);
hist=imhist(image);
hist=hist/(m*n);
CDF = zeros(size(hist));
CDF(1)=hist(1);
for a=2:size(hist,1)
    %disp(i);
    CDF(a)=CDF(a-1)+hist(a);
end
end


