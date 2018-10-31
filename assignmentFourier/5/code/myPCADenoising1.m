function output = myPCADenoising1(image)

noise = 20*randn(size(image));

img = image + noise;


% imshow(img, 'DisplayRange',[min(img(:)) max(img(:))])
% imshow(img, [])

% Constructing P Matrix
P = [];

M = size(img,1);
N = size(img,2);

for i = 1:M-6
    for j = 1:N-6
        patch = img(i:i+6, j:j+6);
        P = [P patch(:)];
        
    end
end
% fprintf('P constructed \n');
% Computing the Eigencoefficients
PPT = mtimes(P,P');
[V,D] = eig(PPT);

% eigenCoefficientMatrix = zeros(size(P));
% count = 1;
eigenCoefficientMatrix = [];

for i=1:M-6
    for j = 1:N-6
    patch = img(i:i+6, j:j+6);
    eigenCoefficientMatrix = [eigenCoefficientMatrix mtimes(V', patch(:))];
%     count = count+1;
    end
end

% fprintf('eigenCoefficientMatrix constructed \n');

denoisedEigenCoefficientMatrix = zeros(size(P));
denoisedP = zeros(size(P)); %stores denoised patches; reshape to get image
for i=1:size(P,2)
    eigenCoefficientVector = eigenCoefficientMatrix(:,i);
    for j=1:size(P,1)
        alphaBarj = max(0, (norm(eigenCoefficientMatrix(j,:))^2 - 400*size(P,2))/(size(P,2)) );
        denoisedEigenCoefficientMatrix(j,i) = eigenCoefficientVector(j)/(1+(400/alphaBarj)); 
    end
    denoisedP(:,i) = mtimes(V, denoisedEigenCoefficientMatrix(:,i));
end

fprintf('Denoising Process Completed! \n');
%rolling back the patch matrix denoisedP into the denoised image
 denoised_im = zeros(size(img));
 im_count = zeros(size(img));
 count = 1;
 for i=1:M-6
     for j=1:N-6
%          patch = denoisedP(:,count);
        patch = mtimes(V, denoisedEigenCoefficientMatrix(:, count));
         denoised_im(i:i+6, j:j+6) = denoised_im(i:i+6, j:j+6) + reshape(patch, [7,7]);
         im_count(i:i+6, j:j+6) = im_count(i:i+6, j:j+6)+1;
         count = count+1;  
     end
 end

 output = rdivide(denoised_im,im_count);
 
% Displaying the input and output image 
myNumOfColors = 200;
myColorScale = [ [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' ];

figure('name', 'Input and Output Images')
subplot(3,1,1)
imagesc(image);
daspect ([1 1 1]);
axis tight;
colormap (myColorScale);
colormap gray;
colorbar
title('Original Image')



subplot(3,1,2)
%figure('name', 'Histogram Matched Image')
imagesc(img);
daspect ([1 1 1]);
axis tight;
colormap (myColorScale);
colormap gray;
colorbar
title('Image after noise additionn')

subplot(3,1,3)
%figure('name', 'Histogram Equalized Image')
imagesc(output);
daspect ([1 1 1]);
axis tight;
colormap (myColorScale);
colormap gray;
colorbar
title('Denoised Image')
        
end




