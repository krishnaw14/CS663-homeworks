function gaussianMask(windowSize, sigma_spatial_gaussian)
if windowSize == 3
    mask = fspecial('gaussian', [3 3], sigma_spatial_gaussian);
    figure('name', 'Gaussian Mask')
    imagesc(mask);
    colormap gray;
    daspect ([1 1 1]);
    axis tight;
    colorbar;
    title('3x3 Gaussian Mask, Sigma = 0.6')
    
    colorbar;
elseif windowSize == 7
    mask = fspecial('gaussian', [7 7], sigma_spatial_gaussian);
    figure('name', 'Gaussian Mask')
    imagesc(mask);
    colormap gray;
    daspect ([1 1 1]);
    axis tight;
    colorbar;
    title('7x7 Gaussian Mask, Sigma = 1')
end
end