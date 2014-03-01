% fit_konect.m
% Parse and fit network degree distributions for datasets downloaded from 
% the Konect website (konect.uni-koblenz.de/networks)
% (c) Jack Peterson, 4/18/2013

% Basic file and dataset info
basepath = '/Users/jack/Documents/Scripts/digamma/';
datafile = {'freq_orgs.txt', 'freq_persons.txt', 'freq_places.txt'};
fig_title = datafile;
fig_xlabel = {'orgs', 'words', 'places'};

num_files = length(datafile);

for kk = 1:num_files
    
    % Convert the edge list input file to counts
    counts = importdata(strcat(basepath,datafile{kk}));
    
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
    
    % Scaling exponent
    g = u/s;
    g_err = g*sqrt((u_err/u)^2+(k0_err/k0)^2);
    
    % Output to screen in TeX table format
    [u_sig,u_paren] = pretty_errors(u,u_err);
    [k0_sig,k0_paren] = pretty_errors(k0,k0_err);
    [g_sig,g_paren] = pretty_errors(g,g_err);
    comma_N = insert_commas(sum(freq));
    mean_k = num2str(round(mean(counts)*1000)/1000);
    fprintf('%s & %s(%s) & %s(%s) & %s & %s & %s(%s) & %s\\\\\n',...
        fig_title{kk},u_sig,u_paren,k0_sig,k0_paren,mean_k,comma_N,...
        g_sig,g_paren,num2str(p_val));
    
    % Label plot and save to EPS file
    figure(1)
    clf
    loglog(x,y,'bo');
    hold on
    loglog(x,fit_pk,'k-');
    axis([min(x)/2 max(x)*2 min(y(y>0))/2 max(y)*2])
    xlabel(fig_xlabel{kk},'interpreter','latex','fontsize',22)
    ylabel('probability','interpreter','latex','fontsize',22)
    title(fig_title{kk},'interpreter','latex','fontsize',22)
    print('-depsc2',strcat('ME_PL_fit_',datafile{kk}));
    
    % Save workspace
    savefile = strcat(strcat(strcat('ME_PL_fitted_',...
        datafile{kk}),'_'),'.mat');
    save(savefile);
    
end