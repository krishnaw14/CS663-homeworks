sum = zeros(168*192,1);
X = zeros(168*192,38*40);
Xtest = zeros(168*192,38*20);
XimageCount = 1;
Xtestimagecount = 1;
base_path = 'data/CroppedYale/yaleB0';
for j=1:39
    if j == 14
        continue
    end
    if j > 9
        base_path = 'data/CroppedYale/yaleB';
    end
    path = strcat(base_path, string(j));
    image_files = dir( fullfile(path, '*.pgm') );
    nFiles = 40+20; %20 images as test set for Xtest
    
      for i = 1:nFiles
          currentFile = fullfile(path, image_files(i).name);
          image_path = convertStringsToChars(currentFile);
          image = im2double(imread(image_path));
          image = reshape(image, 168*192,1);
          if i<41
            sum = sum + image;
            X(:,XimageCount) = image;
            XimageCount = XimageCount + 1;
          else
            Xtest(:,Xtestimagecount) = image;
            Xtestimagecount = Xtestimagecount + 1;
          end
      end   
end
mean = sum/(38*40);
X = X - mean;
Xtest = Xtest - mean;

[U S V] = svd(double(X),'econ');
% disp(size(U));

k_values = [1; 2; 3; 5; 10; 15; 20; 30; 50; 60; 65; 75; 100; 200; 300; 500; 1000];
accuracy = zeros(size(k_values));

for i = 1:size(k_values)
    k = k_values(i);
    Vk = U(:,k);
    databaseEigenCoeffMat = dbEigCoeffMat(k, Vk, X);
%     fprintf('k = %i \n', k);
    score = 0;
    for testIndex = 1:38*20
            personIndex = 1+ fix((testIndex-1)/20);
%             disp(personIndex);
            testImage = Xtest(:, testIndex);
            [rate,index] = recognitionRate(testImage, databaseEigenCoeffMat, Vk);
            prediction = 1+ fix((index-1)/40);
%             if personIndex ==1
%                 fprintf('Index = %i \n', index);
%             end
            if prediction == personIndex
                score = score + 1;
            end
    end
%     disp(score)
    accuracy(i) = score;
end

accuracy = accuracy/(20*38);
[max_accuracy, best_k] = max(accuracy);
fprintf('\n Best Accuracy on Test Set: %f percent \n', max_accuracy*100);
fprintf('\n Best k-value: %i \n', k_values(best_k));

plot(k_values, accuracy, 'LineWidth',3);
title('Recognition Accuracy vs. k');
xlabel('k');
ylabel('Test Set Accuracy');


%constructing first k eigen-coefficients for each database image(training set)
function databaseEigenCoeffMat = dbEigCoeffMat(k, Vk, X)
    databaseEigenCoeffMat = zeros(k, 38*40); % first 40 columns for the first person, next 40 columns for the next person and so on...
    for j=1:38*40
            imageBar = X(:,j);
            %qp = V(:,(192-k+1):192);
            databaseEigenCoeffMat(:,j) = mtimes(transpose(Vk) , imageBar);
    end
end

function [rate,index] = recognitionRate(testImage, databaseEigenCoeffMat, Vk)
    testEigenCoeff = mtimes( transpose(Vk), testImage);
    eigenCoeffDifferenceMat = (databaseEigenCoeffMat - testEigenCoeff);
    recognitionRates = zeros(1,1520); %matrix of RMSD with eigen-coefficients of each training image
    for i=1:1520
        recognitionRates(i) = norm(eigenCoeffDifferenceMat(:,i), 'fro');
    end

    [rate, index] = min(recognitionRates);
end
