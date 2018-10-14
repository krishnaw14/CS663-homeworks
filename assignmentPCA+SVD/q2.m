sum = zeros(168*192,1);
X = zeros(168*192,38*40);
Xtest = zeros(168*192,38*20);
XimageCount = 1;
Xtestimagecount = 1;
base_path = 'CroppedYale/yaleB0';
for j=1:39
    if j == 14
        continue
    end
    if j > 9
        base_path = 'CroppedYale/yaleB';
    end
    path = strcat(base_path, string(j));
    image_files = dir( fullfile(path, '*.pgm') );
    nFiles = 40+20; %20 images as test set for Xtest
    %disp(j);
    %disp(path);
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
imageBar = X - mean;

L = mtimes(transpose(X), X);
[W, D] = eig(L);%W is the matrix of eigen vectors of L; and D is the matrix of eigen values of L
[d,ind] = sort(diag(D)); %d is the vector of eigen values in ascending order
Wsorted = W(:,ind); %eigen vectors are arranged in ascending order of eigen values

V = mtimes(X, Wsorted); %V is now the matrix of eigen vectors of the covariance matrix as required in the PCA algorithm
%V is the eigen space
%unit-normalising columns of V
for i=1:38*40
    V(:,i) = V(:,i) / norm(V(:,i));
end

k = [2, 10, 20, 50, 75, 100, 125, 150, 175];
%plotting reconstructed faces for various k values
for i=k
    reconstructedImage = reconstructFace(Xtest(:,401), i, mean, V); %index 401 corresponds to 41st image of B22
    figure(i)
    imshow(reconstructedImage);
end

%plotting eigen faces corresponding to 25 largest eigen values
for i=1:25
    eigenface = mean + V(:,38*40-i+1);
    figure(i)
    imshow(reshape(eigenface, 192, 168));
end

function reconstructedImage = reconstructFace(testImage, k, mean, V)
    Vk = V(:,(38*40-k+1):38*40);
    kEigenCoeff = mtimes(Vk.' , testImage-mean);
    reconstructedImage = mean + mtimes(Vk, kEigenCoeff);
    reconstructedImage = reshape(reconstructedImage, 192, 168);
end