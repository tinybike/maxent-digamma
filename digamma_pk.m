function Y = digamma_pk(X,mu,s)

Q = sum(exp(-mu*digamma((min(X)>0):max(X),s)));
Y = exp(-mu*digamma(X,s))/Q;