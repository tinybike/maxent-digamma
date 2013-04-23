function p_val = counts_to_fit(counts)

% Calculate PDF from counts
[x,y,freq] = get_pdf(counts);

% Get maximum likelihood estimates for the digamma p(k) for the two
% adjustable parameters mu^0 (u here) and k_0 (1/s here)
[params,params_err] = mle(counts,'pdf',@digamma_pk,'start',[2 1],...
    'lowerbound',[0 0]);
u = params(1);
s = params(2);
u_err = u-params_err(1,1);
k0 = 1/s;
k0_err = k0*(s-params_err(1,2))/s;
fit_pk = digamma_pk(x,u,s);

% Goodness-of-fit simulations
p_val = ks_gof_sim(x,y,fit_pk,u,s,1000,length(counts));

% Output to screen in TeX table format
fprintf('%f(%f) & %f(%f) & %f & %i & %f & %f\\\\\n',...
    u,u_err,k0,k0_err,mean(counts),sum(freq),u/s,p_val);
