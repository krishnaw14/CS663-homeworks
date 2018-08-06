function output = myBilinearInterpolation(image_path)

f = imread(image_path);
image = cast(f,'int16');
[r,c,h]=size(image);
fac=2;
for i=1:r
    for j=1:c
      output((i-1)*3+1,(j-1)*2+1,:)=image(i,j,:); 
    end 
end
for i=1:3+(r-2)*3
    for j=1:2+(c-2)*2
        h00=output(ceil(i/3)*3-3+1,ceil(j/2)*2-2+1,:);
        h10=output(ceil(i/3)*3-3+1+3,ceil(j/2)*2-2+1,:);
        h01=output(ceil(i/3)*3-3+1,ceil(j/2)*2-2+1+2,:);
        h11=output(ceil(i/3)*3-3+1+3,ceil(j/2)*2-2+1+2,:);
        x = rem(i-1,3);
        y = rem(j-1,2);
        
        dx = x/3;
        dy = y/2;
        
        b1=h00;
        b2=h10-h00;
        b3=h01-h00;
        b4=h00-h10-h01+h11;
        output(i,j,:)=b1+b2*dx+b3*dy+b4*dx*dy;
        
    end
end

myNumOfColors = 200;
myColorScale = [ [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' ];

figure('name', 'Bilinear Interpolation');
subplot(2,1,1) 
imagesc(image);
colormap (myColorScale);
colormap gray;
daspect ([1 1 1]);
axis tight;
colorbar
title('Original Image')
%impixelinfo;

subplot(2,1,2) 
imagesc(output);
colormap (myColorScale);
colormap gray;
daspect ([1 1 1]);
axis tight;
colorbar
title('Bilinear Interpolated Image')
%impixelinfo;


end
        