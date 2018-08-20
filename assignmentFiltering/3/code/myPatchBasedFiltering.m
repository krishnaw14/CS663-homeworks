function output = myPatchBasedFiltering(image)

input = image;
imshow(input);
corrupted_input = input + 0.05*randn(size(input));

M = size(input,1);
N = size(input,1);
output = zeros(size(input));

sigma = 5;

patch_w = 4;
size_w = 12;

for i = 1:M
    for j = 1:N
        x1 = max(i-size_w,1);
        x2 = min(i+size_w,M);
        y1 = max(j-size_w,1);
        y2 = min(j+size_w,N);
        
        px1 = max(i-patch_w, 1);
        px2 = min(i+patch_w, M);
        py1 = max(j-patch_w, 1);
        py2 = min(j-patch_w, N);
        
        patch_P = input(px1:px2, py1:py2);
        
        window = input(x1:x2, y1:y2);
        W_P = zeros(size(window));
        w1 = size(window,1);
        w2 = size(window,2);
        
        for k = 1:w1
            for l=1:w2
                wx1 = max(k-patch_w, 1);
                wx2 = min(k+patch_w, w1);
                wy1 = max(l-patch_w, 1);
                wy2 = min(l-patch_w, w2);
                
                patch_W = window(wx1:wx2, wy1:wy2);
                
                Xi = min(size(patch_W,1), size(patch_P,1));
                Yi = min(size(patch_W,2), size(patch_P,2));
                patch_diff_matrix = patch_P(1:Xi, 1:Yi) - window(1:Xi, 1:Yi);
                
                patch_diff_norm = sum(( patch_diff_matrix(:).^2 )) / (Xi*Yi);
                W_P(k,l) = patch_diff_norm;
            end
        end
        
        gaussian_W_P = exp(-W_P.^2/(2*sigma*sigma))/(sigma*sqrt(2*pi));
        weighted_avg = times(window, gaussian_W_P)/(sum(gaussian_W_P(:) ));
        output(i,j) = sum(weighted_avg(:));
        
    end
end

end