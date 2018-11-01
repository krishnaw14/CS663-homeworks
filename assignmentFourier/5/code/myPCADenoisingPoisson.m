function output = myPCADenoisingPoisson(image, variance)
%for this function, we input the noisy image itself with known variance for
%the weiner update
M = size(image,1);
N = size(image,2);

K = 200;

denoised_im = zeros(size(image));
im_count = zeros(size(image));

for i = 1:M-6
    for j=1:N-6
        patch = image(i:i+6, j:j+6);
        
        % Defining the neighbourhood for the patch centered at top-left
        % corner of the patch
        x1 = max(i-15,1);
        x2 = min(i+9,M-6);
        y1 = max(j-15,1);
        y2 = min(j+9,N-6);
        
        count = 1;
        P = zeros(49, ((x2-x1+1)*(y2-y1+1)));
        mean_square_errors = zeros(((x2-x1+1)*(y2-y1+1)), 1);
        for m = x1:x2
            for n = y1:y2
                neighbour_patch = image(m:m+6, n:n+6);
                P(:, count) = neighbour_patch(:);
                mean_square_errors(count) = norm(neighbour_patch(:) - patch(:))^2/(size(patch(:), 1));
                count = count + 1;
            end
        end
        
        % Extracting the top 200 patches ased on minimum mean square error
        [~, KnearestPatches] = mink(mean_square_errors, K); 
        Q = P(:, KnearestPatches);
        
        QQT = mtimes(Q,Q');
        [V,D] = eig(QQT);
        
        eigenCoefficientMatrix = [];
        PCoefficients = mtimes(V', patch(:));

        % Constructinng the eigen coefficient matrix for the neighbourhood
        % Q
        for k=1:size(Q,2)
            eigenCoefficientMatrix = [eigenCoefficientMatrix mtimes(V', Q(:,k))];
        end
        
        alphaBarJMatrix = max(0, mean(eigenCoefficientMatrix.^2, 2) - variance);
        denoisedPCoefficients= zeros(size(PCoefficients));
        
        for k = 1:size(denoisedPCoefficients)
            denoisedPCoefficients(k) = PCoefficients(k)/(1+variance/alphaBarJMatrix(k));
        end
        
        denoisedPatch = mtimes(V,denoisedPCoefficients);
        denoised_im(i:i+6, j:j+6) = denoised_im(i:i+6, j:j+6) + reshape(denoisedPatch, [7,7]);
        im_count(i:i+6, j:j+6) = im_count(i:i+6, j:j+6)+1;
        
 
    end
end

 output = rdivide(denoised_im,im_count);

