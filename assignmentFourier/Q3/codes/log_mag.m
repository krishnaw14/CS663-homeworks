x = imread('../data/barbara256.png');
y = fft(x);     
f = (0:length(y)-1)*50/length(y);
plot(log(f),abs(y));
log(f)
