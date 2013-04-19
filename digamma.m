function y = digamma(x,s)

x_max = max(x);
u = zeros(x_max,1);

u(1) = 1;
for jj = 2:x_max
    u(jj) = 1/(1+s*(jj-1));
end

if min(x)
    w = cumsum(u);
    y = w(x);
else
    w = [0;cumsum(u)];
    y = w(x+1);
end