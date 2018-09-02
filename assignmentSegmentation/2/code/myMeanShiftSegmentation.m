function newImage = myMeanShiftSegmentation(d, hs, hr, k, numberOfIterations)
I = imread('../data/baboonColor.png');
smoothImage = imgaussfilt(I,1);
image = smoothImage(1:d:end,1:d:end,:);
image = im2double(image);
[rows,cols,~] = size(image);
%constructing the 5D feature-space for points on the image
featureSpace = [];
for i=1:rows
    for j=1:cols
        pixel = image(i,j,:);
        featureSpace = [featureSpace; [i/rows, j/cols, pixel(1), pixel(2), pixel(3)]];
    end
end
featureSpace(:,1:2) = featureSpace(:,1:2) / (hs);
featureSpace(:,3:5) = featureSpace(:,3:5) / (hr);

newImage = ones(size(image));
for i=1:rows
    for j=1:cols
        pixel = image(i,j,:);
        featureSpaceVector = [i/rows, j/cols, pixel(1), pixel(2), pixel(3)];
        convergedFeatureVector = meanShiftProcedure(k, featureSpace, featureSpaceVector, numberOfIterations);
        newImage(i,j,:) = convergedFeatureVector(3:5); 
%         disp(strcat(string(i) ,',', string(j)));
    end
end
myNumOfColors = 200;
myColorScale = [ [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' ];

figure('name', 'input image')
subplot(2,1,1)
imagesc(I);
colormap (myColorScale);
colormap jet;
daspect ([1 1 1]);
axis tight;
colorbar
title('Input Image')

subplot(2,1,2)
imagesc(newImage);
colormap (myColorScale);
colormap jet;
daspect ([1 1 1]);
axis tight;
colorbar
title('Segmented Image')
end

function convergedFeatureVector = meanShiftProcedure(k, featureSpace, featureSpaceVector, numberOfIterations)
    for i=1:numberOfIterations
        [Xid, D] = knnsearch(featureSpace, featureSpaceVector, 'k', k);
        weights = exp(-times(D,D))'; 
        estimate = sum(times(featureSpace(Xid,:), weights)) / sum(weights);
        featureSpaceVector = estimate;
    end    
    convergedFeatureVector = estimate;
end