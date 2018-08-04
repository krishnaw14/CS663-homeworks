function output = myCLAHE(input_path)

input = imread(input_path, 'png');

M = size(input,1);
N = size(input,2);
C= size(input,3);

output = zeros(M,N,C);
W = 11;
for c=1:C
    output(:,:,c) = nlfilter(input(:,:,c), [W,W], @block_processing);
end

imshow(output);

end

function final_image = block_processing(image)
%B = im2double(image);
M = size(image,1);
N = size(image,2);
final_image = image;

histogram = imhist(image);
histogram = histogram/(M*N);
CDF = zeros(size(histogram));
CDF(1) = histogram(1);

for a=2:256
    CDF(a)=CDF(a-1)+histogram(a);
end

index = uint8(image(round(M/2), round(N/2)) );

final_image( round(M/2), round(N/2) ) = CDF(index+1);

end
