function [x,y,freq] = get_pdf(counts)

[freq,x] = hist(counts,min(counts):max(counts));
y = freq/sum(freq);
freq(~freq) = [];
x(~y) = [];
y(~y) = [];
freq = freq';
x = x';
y = y';
