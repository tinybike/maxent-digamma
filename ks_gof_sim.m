function p = ks_gof_sim(x,y,fit_pk,u,s,num_syn,num_data_points)
% Goodness-of-fit test described in Clauset, Shalizi, Newman, SIAM Review
% 2009.
CDF_data = cumsum(y);
CDF_fit_pk = cumsum(fit_pk);
CDF_dist = abs(CDF_data-CDF_fit_pk);
KS_data = max(CDF_dist);

% Generate synthetic data sets
KS_syn = zeros(num_syn,1);
for ii = 1:num_syn
    tic
    randcounts = zeros(num_data_points,1);
    % Generate random numbers from best-fit p(k) using CDF inversion
    sum_pk = sum(fit_pk);
    for jj = 1:num_data_points
        randx = sum_pk*rand();
        i = 1;
        while CDF_fit_pk(i) < randx
            i = i + 1;
        end
        randcounts(jj) = x(i);
    end    
    toc
    [rand_y,rand_x] = hist(randcounts,min(randcounts):max(randcounts));
    rand_y = rand_y/sum(rand_y);
    rand_x(~rand_y) = [];
    rand_y(~rand_y) = [];
    cdf_randdata = cumsum(rand_y)';
    this_pk = digamma_pk(rand_x,u,s);
    CDF_dist = abs(cdf_randdata-cumsum(this_pk));
    KS_syn(ii) = max(CDF_dist);
end

% P-value: KS_data is smaller than what fraction of synthetic datasets?
p = nnz(KS_data < KS_syn)/num_syn;