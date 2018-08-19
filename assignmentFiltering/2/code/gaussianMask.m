function gaussianMask(windowSize, sigma_spatial_gaussian)
if windowSize == 3
    mask = fspecial('gaussian', [3 3], sigma_spatial_gaussian);
    figure()
    imagesc(mask);
    title('3x3 Gaussian Mask, Sigma = 0.6')
    colormap gray;
    colorbar;
elseif windowSize == 7
    mask = fspecial('gaussian', [7 7], sigma_spatial_gaussian);
    figure()
    imagesc(mask);
    title('7x7 Gaussian Mask, Sigma = 1')
    colormap gray;
    colorbar;
end
end