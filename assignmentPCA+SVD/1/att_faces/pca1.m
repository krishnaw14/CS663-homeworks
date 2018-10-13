function pca1
    %calculating the mean vector
    sum = zeros(112*92,1);
    for j=1:32
        for i=1:6
            image = im2double(imread(char(strcat('s' ,string(j) ,'/' ,string(i), '.pgm'))));
            image = reshape(image, 112*92, 1);
            sum = sum + image;
        end
    end
    mean = sum/(6*32);

    %constructing the X matrix
    X = zeros(112*92,32*6);
    imageCount = 1;
    for j=1:32
        for i=1:6
            image = im2double(imread(char(strcat('s' ,string(j) ,'/' ,string(i), '.pgm'))));
            image = reshape(image, 112*92, 1);
            imageBar = image - mean;
            X(:,imageCount) = imageBar;
            imageCount = imageCount + 1;
        end
    end

    L = mtimes(transpose(X), X);
    [V, D] = eig(L);%V is the matrix of eigen vectors of L; and D is the matrix of eigen values of L
    [d,ind] = sort(diag(D));
    Vsorted = V(:,ind); %eigen vectors are arranged in ascending order of eigen values

    V = mtimes(X, Vsorted); %V is now the matrix of eigen vectors of the covariance matrix as required in the PCA algorithm
    %V is the eigen space
    %unit-normalising columns of V
    for i=1:192
    V(:,i) = V(:,i) / norm(V(:,i));
    end
%% 
%trying to reconstruct a test image
testImage = im2double(imread(char(strcat('s' ,string(2) ,'/' ,string(1), '.pgm'))));
testImage = reshape(testImage, 112*92, 1);
testImageBar = testImage - mean;
eigenCoefficients = mtimes(transpose(V), testImageBar);
end