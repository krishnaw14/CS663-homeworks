sum = zeros(112*92,1);
X = zeros(112*92,32*6);
imageCount = 1;
for j=1:32
    for i=1:6
        image = im2double(imread(char(strcat('s' ,string(j) ,'/' ,string(i), '.pgm'))));
        image = reshape(image, 112*92, 1);
        imageBar = image - mean;
        X(:, imageCount) = imageBar;
        sum = sum + image;
        imageCount = imageCount + 1;
    end
end
mean = sum/(6*32);
X = X - mean;

L = mtimes(transpose(X), X);
[W, D] = eig(L);%W is the matrix of eigen vectors of L; and D is the matrix of eigen values of L
[d,ind] = sort(diag(D)); %d is the vector of eigen values in ascending order
Wsorted = W(:,ind); %eigen vectors are arranged in ascending order of eigen values


V = mtimes(X, Wsorted); %V is now the matrix of eigen vectors of the covariance matrix as required in the PCA algorithm
%V is the eigen space
%unit-normalising columns of V
for i=1:192
    V(:,i) = V(:,i) / norm(V(:,i));
end

k = 20;

Vk = V(:,(192-k+1):192);
disp(size(Vk));
disp(size(V));

databaseEigenCoeffMat = dbEigCoeffMat(k, Vk, mean);
rate = recognitionRate(1,8,k,mean,Vk);



%constructing first k eigen-coefficients for each database image(training set)
function databaseEigenCoeffMat = dbEigCoeffMat(k, Vk, mean)
    databaseEigenCoeffMat = zeros(k, 6*32); % first six columns for the first person, next six columns for the next person and so on...
    imageCount = 1;
    for j=1:32
        for i=1:6
            image = im2double(imread(char(strcat('s' ,string(j) ,'/' ,string(i), '.pgm'))));
            image = reshape(image, 112*92, 1);
            imageBar = image - mean;
            %qp = V(:,(192-k+1):192);
            databaseEigenCoeffMat(:,imageCount) = mtimes(transpose(Vk) , imageBar);
            imageCount = imageCount + 1;
        end
    end
end

function rate = recognitionRate(personIndex, imageIndex, k, mean, Vk)
    databaseEigenCoeffMat = dbEigCoeffMat(k, Vk, mean);
    testImagePath = char(strcat('s' ,string(personIndex) ,'/' ,string(imageIndex), '.pgm'));
    testImage = reshape(im2double(imread(testImagePath)), 112*92, 1);
    testEigenCoeff = mtimes( transpose(Vk), testImage - mean);
    dummyTestEigCoeffMat = mtimes(testEigenCoeff, ones(1,192)); 
    %dummyTestEigCoeffMat is a matrix whose each column is a eigen
    %coefficient vector
    eigenCoeffDifferenceMat = dummyTestEigCoeffMat - databaseEigenCoeffMat;
    recognitionRates = ones(1,192); %matrix of RMSD with eigen-coefficients of each training image 
    for i=1:192
        recognitionRates(i) = norm(eigenCoeffDifferenceMat(:,i), 'fro');
    end
    rate = min(recognitionRates);
end