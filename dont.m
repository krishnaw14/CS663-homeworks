windowsize = 25;
sigmaSpacial = 1;
sigmaIntensity = 1;
pathsize = 9;
p = (pathsize - 1) /2;
%inpImg = 'data\barbara.mat';
%f1 = load(inpImg,'-mat');
f2 = imageOrig;
original = mat2gray(f2);
original = original(1:3:end , 1:3:end); 
rows = size(original,1);
cols = size(original,2);
c =  original + 0.06*randn(size(original));
imin=0;
imax=0;
jmin=0;
jmax=0;
w = 12; 
num = zeros(rows,cols);
den = zeros(rows,cols);
spacial = zeros(25,25);
expPatch = zeros(25,25);
window = zeros(25,25);
rangeDifference = zeros(25,25);
count = 0;
for i = 1:rows
    
    ipmin = max((i-4),1);
    ipmax = min((i+4),rows);
    imin = max((i-12),1);
    imax = min((i+12),rows);
    for j = 1:cols 
        count = count + 1;
        
        jpmin = max((j-4),1);
        jpmax = min((j+4),cols);
        jmin = max((j-12),1);
        jmax = min((j+12),cols);
        
        
        for ip2 = ipmin:ipmax
                    for jp2 = jpmin:jpMax
                        patch2((ip2 - ipmin + 1),(jp2 - jpmin + 1)) = c(ip2, jp2);
                    end;
        end;
        for i1 = imin:imax
            i1min = max(i1-4,1);
            i1max = min(i1+4,rows);
            for j1 = jmin:jmax
                window((i1 - imin + 1),(j1-jmin+1)) = c(i1, j1);
                spacial((i1-imin + 1), (j1 - jmin + 1)) = (i - i1)*(i - i1) +(j - j1)*(j-j1);
                j1min = max(j1-4,1);
                j1max = min(j1+4,cols);
                
                
                xMin= min((i1 - i1min),(i-ipmin)); 
                yMin= min((j1 - j1min),(j-jpmin)); 
                if((i1max - i1)<(ipmax - i)) xMax= (i1max - i1); else xMax = (ipmax - i); end;
                if((j1max - j1)<(jpMax - j)) yMax= (j1max - j1); else yMax = (jpMax - j); end;
                
                patch1 = zeros((i1max - i1min + 1),(j1max - j1min + 1));
                for ip = i1min:i1max
                    for jp = j1min:j1max
                        patch1((ip - i1min + 1),(jp - j1min + 1)) = c(ip, jp);
                    end;
                end;
                patchDiff = 0;
                for x = 1:(xMin+xMax+1)
                    for y = 1:(yMin+yMax+1)
                        patchDiff =patchDiff + (((patch1(x,y) - patch2(x,y))*(patch1(x,y) - patch2(x,y)))/(sigmaIntensity*sigmaIntensity));
                    end;
                end;
                expPatch((i1 - imin + 1),(j1 - jmin + 1)) = exp(patchDiff*(-1));
            end;
        end;
        % p pixel is at location i,j
        
        gsSpacial = exp((spacial*(-0.5))/(sigmaSpacial*sigmaSpacial)); %Cg matrix
        % expPatchDiff is Cs matrix
        t = gsSpacial.*expPatch;
        num(i,j) = sum(sum(window.*t));
        den(i,j) = sum(sum(t));
    end;
end;
filtered = num./den;
e = original - filtered;
r = sqrt((1/(rows*cols))*(sum(sum((e)*(e)))));
disp(r);
figure;
imshow(original)
colorbar;
axis on;
set(gcf,'Position',get(0,'ScreenSize'));
figure;
imshow(c)
colorbar;
axis on;
set(gcf,'Position',get(0,'ScreenSize'));
figure;
imshow(filtered)
colorbar;
axis on;
set(gcf,'Position',get(0,'ScreenSize'));
%figure(1);
%subplot(1,3,1);
%imagesc ((original)); % phantom is a popular test image
%colormap('Gray');
%title('Original');
%axis tight;
%subplot(1,3,2);
%imagesc ((c)); % phantom is a popular test image
%colormap('Gray');
%title('Corrupted');
%daspect ([1 1 1]);
%axis tight;
%subplot(1,3,3);
%imagesc ((filtered)); % phantom is a popular test image
%colormap('Gray');
%title('Filtered');
%daspect ([1 1 1]);
%axis tight;
%set(gcf,'Position',get(0,'ScreenSize'));%maximize figure

figure(2);
imagesc ((den)); % phantom is a popular test image
colormap('Gray');
title('Spacial Mask');
daspect ([1 1 1]);
axis tight;

%imwrite(corrupted,'images\barbaraCorrupted.png');
%imwrite(filtered,'images\barbaraPatchBasedFiltered.png');