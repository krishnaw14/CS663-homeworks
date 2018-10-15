sum = zeros(112*92,1);
X = zeros(112*92,32*6);
imageCount = 1;
for j=1:32
    for i=1:6
        image = im2double(imread(char(strcat('../data/att_faces/s' ,string(j) ,'/' ,string(i), '.pgm'))));
        image = reshape(image, 112*92, 1);
        X(:, imageCount) = image;
        sum = sum + image;
        imageCount = imageCount + 1;
    end
end

Xbar = sum/(6*32);
X = X - Xbar;



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
databaseEigenCoeffMat = dbEigCoeffMat(k, Vk, Xbar);

true_rates= [];
false_rates= [];
ideal_rates = [];
    for personIndex = 1:40
        for imageIndex = 1:6
            [rate,index] = recognitionRate(personIndex, imageIndex, databaseEigenCoeffMat, Vk, Xbar);
        ideal_rates= [ideal_rates, rate*rate];
        end
    end
    
  threshold = mean(ideal_rates) + 1*std(ideal_rates);
  fprintf('\n Threshold for Classification = %f \n', threshold);

total_test_images = 40*4;
true_positives_images = 32*4;
true_negatives_images = 8*4;

score = 0;
    for personIndex = 1:40
        for imageIndex = 7:10
            [rate,index] = recognitionRate(personIndex, imageIndex, databaseEigenCoeffMat, Vk, Xbar);
            if personIndex <33
                true_rates = [true_rates, rate*rate];
            else
                false_rates = [false_rates, rate*rate];
            end
        end
    end
    
    false_negatives = size(false_rates(false_rates<threshold));
    true_negatives = size(false_rates(false_rates>threshold));
    
    false_positives = size(true_rates(true_rates>threshold));
    true_positives =  size(true_rates(true_rates<threshold));
    
    
   fprintf('\n Total Number of Positive Images = %f \n', true_positives_images);
   fprintf('\n True Positives = %f \n', true_positives(2));
   fprintf('\n False Positives = %f \n', false_positives(2));
   fprintf('\n Total Number of Negative Images = %f \n', true_negatives_images);
   fprintf('\n True Negatives = %f \n', true_negatives(2));
   fprintf('\n False Negatives = %f \n', false_negatives(2));





%constructing first k eigen-coefficients for each database image(training set)
function databaseEigenCoeffMat = dbEigCoeffMat(k, Vk, Xbar)
    databaseEigenCoeffMat = zeros(k, 6*32); % first six columns for the first person, next six columns for the next person and so on...
    imageCount = 1;
    for j=1:32
        for i=1:6
            image = im2double(imread(char(strcat('../data/att_faces/s' ,string(j) ,'/' ,string(i), '.pgm'))));
            image = reshape(image, 112*92, 1);
            imageBar = image - Xbar;
            databaseEigenCoeffMat(:,imageCount) = mtimes(transpose(Vk) , imageBar);
            imageCount = imageCount + 1;
        end
    end
end

function [rate,index] = recognitionRate(personIndex, imageIndex, databaseEigenCoeffMat, Vk, mean)
    testImagePath = char(strcat('../data/att_faces/s' ,string(personIndex) ,'/' ,string(imageIndex), '.pgm'));
    testImage = reshape(im2double(imread(testImagePath)), 112*92, 1);
    testEigenCoeff = mtimes( transpose(Vk), testImage - mean);

    eigenCoeffDifferenceMat = (databaseEigenCoeffMat - testEigenCoeff);
    recognitionRates = ones(1,192); %matrix of RMSD with eigen-coefficients of each training image
    for i=1:192
        recognitionRates(i) = norm(eigenCoeffDifferenceMat(:,i), 'fro');
    end

    [rate, index] = min(recognitionRates);
end