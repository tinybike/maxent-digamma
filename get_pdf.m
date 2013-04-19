function [x,y,freq] = get_pdf(counts)

[freq,x] = hist(counts,min(counts):max(counts));
y = freq/sum(freq);
x(~y) = [];
y(~y) = [];
x = x';
y = y';
