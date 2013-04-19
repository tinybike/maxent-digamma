function Y = digamma_pk(X,mu,s)
Y = exp(-mu*PS(X,s));
if min(X)
    Q = sum(exp(-mu*PS(1:max(X),s)));
else
    Q = sum(exp(-mu*PS(0:max(X),s)));
end
Y = Y/Q;
