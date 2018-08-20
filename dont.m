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
                    for jp2 = jpmin:jpmax
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
                
                
                xmin= min((i1 - i1min),(i-ipmin)); 
                ymin= min((j1 - j1min),(j-jpmin)); 
                if((i1max - i1)<(ipmax - i)) 
                    xmax= (i1max - i1); 
                else xmax = (ipmax - i); 
                end;
                if((j1max - j1)<(jpmax - j)) 
                    ymax= (j1max - j1); 
                else ymax = (jpmax - j); 
                end;
                
                patch1 = zeros((i1max - i1min + 1),(j1max - j1min + 1));
                for ip = i1min:i1max
                    for jp = j1min:j1max
                        patch1((ip - i1min + 1),(jp - j1min + 1)) = c(ip, jp);
                    end;
                end;
                patchDiff = 0;
                for x = 1:(xmin+xmax+1)
                    for y = 1:(ymin+ymax+1)
                        patchDiff =patchDiff + (((patch1(x,y) - patch2(x,y))*(patch1(x,y) - patch2(x,y)))/(sigmaIntensity*sigmaIntensity));
                    end;
                end;
                expPatch((i1 - imin + 1),(j1 - jmin + 1)) = exp(patchDiff*(-1));
            end;
        end;
        
        gsSpacial = exp((spacial/(2.0))/(sigmaSpacial*sigmaSpacial)); %Cg matrix
        
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
imshow(original);
title('Original');
colorbar;
axis on;
set(gcf,'Position',get(0,'ScreenSize'));
figure;
imshow(c);
colorbar;
title('Corrupted');
axis on;
set(gcf,'Position',get(0,'ScreenSize'));
figure;
imshow(filtered);
colorbar;
title('Filtered');
axis on;
set(gcf,'Position',get(0,'ScreenSize'));


figure(2);
imagesc ((den)); 
colorbar;
title('Spacial Mask');

axis on;
set(gcf,'Position',get(0,'ScreenSize'));
