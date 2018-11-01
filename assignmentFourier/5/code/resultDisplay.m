function resultDisplay(originalImage, noisyImage, denoisedImage)
    myNumOfColors = 200;
    myColorScale = [ [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' ];
    figure('name', 'Input and Output Images for PCADenoising2')

    subplot(3,1,1)
    imagesc(originalImage);
    daspect ([1 1 1]);
    axis tight;
    colormap (myColorScale);
    colormap gray;
    colorbar
    title('Original Image')

    subplot(3,1,2)
    imagesc(noisyImage);
    daspect ([1 1 1]);
    axis tight;
    colormap (myColorScale);
    colormap gray;
    colorbar
    title('Image after noise additionn')

    subplot(3,1,3)
    imagesc(denoisedImage);
    daspect ([1 1 1]);
    axis tight;
    colormap (myColorScale);
    colormap gray;
    colorbar
    title('Denoised Image')
end