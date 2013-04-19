function p = ks_gof_sim(x,y,fit_pk,u,s,num_syn,num_data_points)

CDF_data = cumsum(y);
CDF_dist = abs(CDF_data-cumsum(fit_pk));
KS_data = max(CDF_dist);
% KS_index = find(CDF_dist == KS_data);
% fprintf('N = %i\n',length(counts));
% fprintf('%i\t%f\n',KS_index,KS_data);
% fprintf('Simulating...\n');

% Generate synthetic data sets
KS_syn = zeros(num_syn,1);
for ii = 1:num_syn
    randcounts = zeros(num_data_points,1);
    for jj = 1:num_data_points
        randcounts(jj) = randarb(x,fit_pk);
    end
    [rand_y,rand_x] = hist(randcounts,min(randcounts):max(randcounts));
    rand_y = rand_y/sum(rand_y);
    rand_x(~rand_y) = [];
    rand_y(~rand_y) = [];
    cdf_randdata = cumsum(rand_y)';
    this_pk = digamma_pk(rand_x,u,s);
    CDF_dist = abs(cdf_randdata-cumsum(this_pk));
    KS_syn(ii) = max(CDF_dist);
%     KS_index = find(CDF_dist == KS_syn(ii));
%     fprintf('%i\t%f\t%i\n',KS_index,KS_syn(ii),KS_data < KS_syn(ii));
end

% P-value: KS_data is smaller than what fracountsion of synthetic datasets?
p = nnz(KS_data < KS_syn)/num_syn;