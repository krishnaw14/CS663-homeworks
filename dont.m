windowsize = 25;
sigmaSpacial = 1;
sigmaIntensity = 1;
pathsize = 9;
p = (pathsize - 1) /2;
inpImg = 'data\barbara.mat';
f1 = load(inpImg,'-mat');
f2 = f1.imageOrig;
original = mat2gray(f2);
original = original(1:3:end , 1:3:end); 
in_rows = size(original,1);
in_cols = size(original,2);
corrupted =  original + 0.05*randn(size(original));
imin=0;
imax=0;
jMin=0;
jMax=0;
w = (windowsize-1) /2; % half windowsize
w = round(w);
num = zeros(in_rows,in_cols);
den = zeros(in_rows,in_cols);
spacialDiff = zeros(windowsize, windowsize);
expPatchDiff = zeros(windowsize, windowsize);
window = zeros(windowsize, windowsize);
rangeDifference = zeros(windowsize, windowsize);
count = 0;
for i = 1:in_rows
    
    ipmin = max((i-4),1);
    ipmax = min((i+4),rows);
    imin = max((i-12),1);
    imax = min((i+12),rows);
    for j = 1:in_cols 
        count = count + 1;
        %disp(count);
        jpMin = max((j-4),1);
        jpMax = min((j+4),cols);
        jMin = max((j-12),1);
        jMax = min((j+12),cols);
        
        
        for ip2 = ipmin:ipmax
                    for jp2 = jpMin:jpMax
                        patch2((ip2 - ipmin + 1),(jp2 - jpMin + 1)) = corrupted(ip2, jp2);
                    end;
        end;
        for i1 = imin:imax
            i1Min = max(i1-4,1);
            i1Max = min(i1+4,rows);
            for j1 = jMin:jMax
                window((i1 - imin + 1),(j1-jMin+1)) = corrupted(i1, j1);
                spacialDiff((i1-imin + 1), (j1 - jMin + 1)) = (i - i1)*(i - i1) +(j - j1)*(j-j1);
                if ((j1 - p)>1)
                    j1Min = j1-p;
                else
                    j1Min = 1;
                end;
                if ((j1 + p)< in_cols)
                    j1Max = j1+p;
                else
                    j1Max = in_cols;
                end;
                
                xMin= min((i1 - i1Min),(i-ipmin)); 
                yMin= min((j1 - j1Min),(j-jpMin)); 
                if((i1Max - i1)<(ipmax - i)) xMax= (i1Max - i1); else xMax = (ipmax - i); end;
                if((j1Max - j1)<(jpMax - j)) yMax= (j1Max - j1); else yMax = (jpMax - j); end;
                
                patch1 = zeros((i1Max - i1Min + 1),(j1Max - j1Min + 1));
                for ip = i1Min:i1Max
                    for jp = j1Min:j1Max
                        patch1((ip - i1Min + 1),(jp - j1Min + 1)) = corrupted(ip, jp);
                    end;
                end;
                patchDiff = 0;
                for x = 1:(xMin+xMax+1)
                    for y = 1:(yMin+yMax+1)
                        patchDiff =patchDiff + (((patch1(x,y) - patch2(x,y))*(patch1(x,y) - patch2(x,y)))/(sigmaIntensity*sigmaIntensity));
                    end;
                end;
                expPatchDiff((i1 - imin + 1),(j1 - jMin + 1)) = exp(patchDiff*(-1));
            end;
        end;
        % p pixel is at location i,j
        
        gsSpacial = exp((spacialDiff*(-0.5))/(sigmaSpacial*sigmaSpacial)); %Cg matrix
        % expPatchDiff is Cs matrix
        t = gsSpacial.*expPatchDiff;
        num(i,j) = sum(sum(window.*t));
        den(i,j) = sum(sum(t));
    end;
end;
filtered = num./den;
rmsd = sqrt((1/(in_rows*in_cols))*(sum(sum((original-filtered)*(original-filtered)))));
disp(rmsd);

figure(1);
subplot(1,3,1);
imagesc ((original)); % phantom is a popular test image
colormap('Gray');
title('Original');
daspect ([1 1 1]);
axis tight;
subplot(1,3,2);
imagesc ((corrupted)); % phantom is a popular test image
colormap('Gray');
title('Corrupted');
daspect ([1 1 1]);
axis tight;
subplot(1,3,3);
imagesc ((filtered)); % phantom is a popular test image
colormap('Gray');
title('Filtered');
daspect ([1 1 1]);
axis tight;
set(gcf,'Position',get(0,'ScreenSize'));%maximize figure

figure(2);
imagesc ((den)); % phantom is a popular test image
colormap('Gray');
title('Spacial Mask');
daspect ([1 1 1]);
axis tight;

%imwrite(corrupted,'images\barbaraCorrupted.png');
%imwrite(filtered,'images\barbaraPatchBasedFiltered.png');