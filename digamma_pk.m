function Y = digamma_pk(X,mu,s)

Q = sum(exp(-mu*digamma(1:10^7,s)));
Y = exp(-mu*digamma(X,s))/Q;