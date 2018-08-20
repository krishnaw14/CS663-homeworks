function output = myPatchBasedFiltering(image, sigma)

%input = image;
%imshow(input);


sd = 0.05*(max(max(image)) - min(min(image)));
corrupted_image = image + sd*randn(size(image));

input = corrupted_image;

M = size(input,1);
N = size(input,2);
output = zeros(size(input));

%sigma = 10.5;

patch_w = 4;
size_w = 12;

mask = zeros(25,25);

for i = 1:M
    for j = 1:N
        x1 = max(i-size_w,1);
        x2 = min(i+size_w,M);
        y1 = max(j-size_w,1);
        y2 = min(j+size_w,N);
        
        px1 = max(i-patch_w, 1);
        px2 = min(i+patch_w, M);
        py1 = max(j-patch_w, 1);
        py2 = min(j+patch_w, N);
        
        patch_P = input(px1:px2, py1:py2);
        %fprintf('Size = %i, %i \n', py1,py2);
        window = input(x1:x2, y1:y2);
        W_P = zeros(size(window));
        w1 = size(window,1);
        w2 = size(window,2);
        
        for k = 1:w1
            for l=1:w2
                wx1 = max(k-patch_w, 1);
                wx2 = min(k+patch_w, w1);
                wy1 = max(l-patch_w, 1);
                wy2 = min(l+patch_w, w2);
                
                patch = window(wx1:wx2, wy1:wy2);
                
                Xi = min(size(patch,1), size(patch_P,1));
                Yi = min(size(patch,2), size(patch_P,2));
                patch_diff_matrix = patch(1:Xi, 1:Yi) - patch_P(1:Xi, 1:Yi);
                
                patch_diff_norm = sum( patch_diff_matrix(:) ) / (Xi*Yi);
                %fprintf('W-Y : %i, P-Y = %i,  \n', size(patch_W,2),size(patch_P,2));
                W_P(k,l) = patch_diff_norm;
            end
        end
        
        gaussian_W_P = exp( -W_P.^2/(sigma*sigma) );
        weighted_avg = times(gaussian_W_P,window)/(sum(gaussian_W_P(:) ));
        mask = weighted_avg;
        output(i,j) = sum(weighted_avg(:));
        
    end
end

% Displaying the input and output image 
myNumOfColors = 200;
myColorScale = [ [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' ];

figure('name', 'Patch Based Filtering')
subplot(1,3,1)
imagesc(image);
colormap (myColorScale);
colormap gray;
daspect ([1 1 1]);
axis tight;
colorbar
title('Input Image after subsampling')

subplot(1,3,2)
imagesc(corrupted_image);
colormap (myColorScale);
colormap gray;
daspect ([1 1 1]);
axis tight;
colorbar
title('Corrupted Image')

subplot(1,3,3)
imagesc(output);
colormap (myColorScale);
colormap gray;
daspect ([1 1 1]);
axis tight;
colorbar
title('Output Image')

end