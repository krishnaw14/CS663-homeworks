function output = myNearestNeighborInterpolation(input_path)

input = imread(input_path, 'png');
M = size(input,1);
N = size(input,2);
C = size(input,3);

out_M = 3*M-2;
out_N = 2*N-1;
out_C = C;

output = zeros(out_M, out_N, out_C);

%Scaling factor
M_factor = out_M/M; 
N_factor = out_N/N;

for m=1:out_M
    for n=1:out_N
        map_m = ceil(m/M_factor); %Round the mapping to 1 or greater than 1 (Positive infinity)
        map_n = ceil(n/N_factor);
        output(m,n, :) = uint8(input(map_m, map_n, :));       
    end
end

myNumOfColors = 200;
myColorScale = [ [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' ];

%Displaying the input and output images
figure('name', 'Nearest Neighbor Interpolation');
subplot(2,1,1) 
imagesc(input);
colormap (myColorScale);

if C == 1
    colormap gray;
else
    colormap jet;
end
daspect ([1 1 1]);
axis tight;
colorbar
title('Original Image')
%impixelinfo;

subplot(2,1,2) 
imagesc(output), colorbar;
colormap (myColorScale);
if C == 1
    colormap gray;
else
    colormap jet;
end
daspect ([1 1 1]);
axis tight;
colorbar
title('Nearest Neighbor Interpolated Image')
%impixelinfo;
        
end