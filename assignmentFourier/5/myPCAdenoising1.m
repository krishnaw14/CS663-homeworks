im = double(imread('~/Downloads/barbara256.png'));
[rows, cols] = size(im);
im1 = im + 20*randn(size(im));
windowSize = 7;
N = 1 + floor(rows/7);
numberOfPatches = N*N;
P = zeros(49, numberOfPatches);
patchNumber = 1;
for j=union(1:7:252,250)
    for i=union(1:7:252, 250)
        patch = im1(i:(i+windowSize-1), j:(j+windowSize-1));
        patch = reshape(patch, [windowSize*windowSize,1]);
        P(:, patchNumber) = patch;
        patchNumber = patchNumber + 1;
    end
end
[V,  D] = eig(mtimes(P, P.'));
%computing eigen-coefficients of each noisy patch
eigenCoefficientMatrix = zeros(49, numberOfPatches);
for i=1:N*N
    eigenCoefficientMatrix(:,i) = mtimes(V.', P(:,i));
end
denoisedEigenCoefficientMatrix = zeros(49, numberOfPatches);
denoisedP = zeros(49, numberOfPatches); %stores denoised patches; reshape to get image
for i=1:N*N
    eigenCoefficientVector = eigenCoefficientMatrix(:,i);
    for j=1:49
        alphaBarj = ((norm(eigenCoefficientMatrix(j,:)))^2 - 400)/numberOfPatches;
        denoisedEigenCoefficientMatrix(j,i) = eigenCoefficientVector(j)/(1+(400/alphaBarj)); 
    end
    denoisedP(:,i) = mtimes(V, denoisedEigenCoefficientMatrix(:,i));
end
%rolling back the patch matrix denoisedP into the denoised image
denoised_im = zeros(size(im));
for i=1:rows
    for j=1:cols
        
    end
end