function p = ks_gof_sim(x,y,fit_pk,u,s,num_syn,num_data_points,max_k)
% Goodness-of-fit test described in Clauset, Shalizi, Newman, SIAM Review
% 2009.  This goodness-of-fit test is based on the KS test, and compares
% maximum difference between the CDFs (not the complementary CDF) of 
% theory and experiment, then of fit and simulation.
% If p(k) is accurate, then the actual fit should be better than fits to 
% randomly generated datasets from p(k) half of the time.  (We set our 
% threshold at 5%.)
% Note: to build random data sets for the simulations, we need the entire
% theoretical p(k).
CDF_data = cumsum(y);
CDF_fit_pk = cumsum(fit_pk);
j = 1;
len_x = length(x);
CDF_fit_pk_compare = zeros(len_x,1);
% for i = x'
for i = x(1):len_x
    if ~i && ~min(x)
        CDF_fit_pk_compare(j) = CDF_fit_pk(i+1);
    else
        CDF_fit_pk_compare(j) = CDF_fit_pk(i);
    end
    j = j + 1;
end
% CDF_dist = abs(CDF_data-CDF_fit_pk);
CDF_dist = abs(CDF_data-CDF_fit_pk_compare);
KS_data = max(CDF_dist);
full_x = (1:max_k)';

% Generate synthetic data sets
KS_syn = zeros(num_syn,1);
for ii = 1:num_syn
    randcounts = zeros(num_data_points,1);
    % Generate random numbers from best-fit p(k) using CDF inversion
    sum_pk = sum(fit_pk);
    for jj = 1:num_data_points
        randx = sum_pk*rand();
        i = 1;
        while CDF_fit_pk(i) < randx
            i = i + 1;
        end
        randcounts(jj) = full_x(i);
    end    
    [rand_y,rand_x] = hist(randcounts,min(randcounts):max(randcounts));
    rand_y = rand_y/sum(rand_y);
    rand_x(~rand_y) = [];
    rand_y(~rand_y) = [];
    cdf_randdata = cumsum(rand_y)';
    this_pk = digamma_pk(1:max_k,u,s);
    CDF_this_pk = cumsum(this_pk);
    j = 1;
    CDF_this_pk_compare = zeros(length(rand_x),1);
    for i = rand_x
        CDF_this_pk_compare(j) = CDF_this_pk(i);
        j = j + 1;
    end
    CDF_dist = abs(cdf_randdata-CDF_this_pk_compare);
    KS_syn(ii) = max(CDF_dist);
end

% P-value: KS_data is smaller than what fraction of synthetic datasets?
p = nnz(KS_data < KS_syn)/num_syn;