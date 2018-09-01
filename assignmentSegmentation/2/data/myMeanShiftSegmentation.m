function newImage = myMeanShiftSegmentation(hs, hr, k, numberOfIterations)
I = imread('baboonColor.png');
smoothImage = imgaussfilt(I,1);
image = smoothImage(1:4:end,1:4:end,:);
image = im2double(image);
%constructing the 5D feature-space for points on the image
featureSpace = [];
for i=1:128
    for j=1:128
        pixel = image(i,j,:);
        featureSpace = [featureSpace; [i/128, j/128, pixel(1), pixel(2), pixel(3)]];
    end
end
featureSpace(:,1:2) = featureSpace(:,1:2) / (hs);
featureSpace(:,3:5) = featureSpace(:,3:5) / (hr);

newImage = ones(size(image));
for i=1:128
    for j=1:128
        pixel = image(i,j,:);
        featureSpaceVector = [i/128, j/128, pixel(1), pixel(2), pixel(3)];
        convergedFeatureVector = meanShiftProcedure(k, featureSpace, featureSpaceVector, numberOfIterations);
        newImage(i,j,:) = convergedFeatureVector(3:5); 
        disp(strcat(string(i) ,',', string(j)));
    end
end
imshow(newImage);
end

%function neighbourhoodMeanEstimate = meanShift(k, featureSpace, featureSpaceVector)
%For a given input pixel, this function returns the result of the converged
%iterative mean-shift procedure.
%[Xid, D] = knnsearch(featureSpace, featureSpaceVector, 'k', k);
%weights = exp(-times(D,D))'; 
%neighbourhoodMeanEstimate = sum(times(featureSpace(Xid,:), weights)) / sum(weights);
%end

function convergedFeatureVector = meanShiftProcedure(k, featureSpace, featureSpaceVector, numberOfIterations)
    %estimate = meanShift(k, featureSpace, featureSpaceVector);
    for i=1:numberOfIterations
        [Xid, D] = knnsearch(featureSpace, featureSpaceVector, 'k', k);
        weights = exp(-times(D,D))'; 
        estimate = sum(times(featureSpace(Xid,:), weights)) / sum(weights);
        %newEstimate = meanShift(k, featureSpace, estimate);
        featureSpaceVector = estimate;
    end    
    convergedFeatureVector = estimate;
end