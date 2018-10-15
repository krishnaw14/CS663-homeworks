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

k_values = [1; 2; 3; 5; 10; 15; 20; 30; 50; 75; 100; 150; 170];
accuracy = zeros(size(k_values));

for i = 1:size(k_values)
    k = k_values(i);
    Vk = V(:,(192-k+1):192);
    databaseEigenCoeffMat = dbEigCoeffMat(k, Vk, mean);
%     fprintf('k = %i \n', k);
    score = 0;
    for personIndex = 1:32
        for imageIndex = 7:10
            [rate,index] = recognitionRate(personIndex, imageIndex, databaseEigenCoeffMat, Vk, mean);
            prediction = 1+ fix((index-1)/6);

            if prediction == personIndex
                score = score + 1;
            end
        end
    end
    accuracy(i) = score;
end

accuracy = accuracy/(32*4);
[max_accuracy, best_k] = max(accuracy);
fprintf('\n Best Accuracy on Test Set: %f % \n', max_accuracy*100);
fprintf('\n Best k-value: %i \n', k_values(best_k));

plot(k_values, accuracy, 'LineWidth',3);
title('Recognition Accuracy vs. k');
xlabel('k');
ylabel('Test Set Accuracy');



%constructing first k eigen-coefficients for each database image(training set)
function databaseEigenCoeffMat = dbEigCoeffMat(k, Vk, mean)
    databaseEigenCoeffMat = zeros(k, 6*32); % first six columns for the first person, next six columns for the next person and so on...
    imageCount = 1;
    for j=1:32
        for i=1:6
            image = im2double(imread(char(strcat('../data/att_faces/s' ,string(j) ,'/' ,string(i), '.pgm'))));
            image = reshape(image, 112*92, 1);
            imageBar = image - mean;
            %qp = V(:,(192-k+1):192);
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
<<<<<<< HEAD:assignmentPCA+SVD/1/att_faces/code/myMainScript.m
end
=======
end
>>>>>>> 9727373f168de2baca11703421838c49624216ed:assignmentPCA+SVD/1/att_faces/myMainScript.m
