% fit_vivek.m
% Parse and fit network degree distributions for Vivek's datasets
% (c) Jack Peterson, 2/26/2014

% File and datasets
basepath = '~/src/digamma/';
datafile = {'freq_orgs.txt', 'freq_persons.txt', 'freq_places.txt'};
fig_title = datafile;
fig_xlabel = {'orgs', 'words', 'places'};

num_files = length(datafile);
num_sim = 1000;

for kk = 1:num_files
    
    % Convert the edge list input file to counts
    counts = importdata(strcat(basepath,datafile{kk}));

    % Calculate PDF from counts
    [x,y,freq] = get_pdf(counts);
    cdf_y = flipud(cumsum(flipud(y)));
    
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
    
    % For plotting, set the maximum value of k to be 10^6, or
    % if there are more than 10^5 nodes, set it equal to the
    % number of nodes * 10.
    num_nodes = sum(freq);
    if num_nodes > 10^6
        max_k = num_nodes;
    else
        max_k = 10^6;
    end
    fit_pk_allpoints = digamma_pk(1:max_k,u,s);
    cdf_fit_pk_allpoints = flipud(cumsum(flipud(digamma_pk(1:max_k,u,s))));
        
    % Goodness-of-fit simulations
    sample_size = length(counts);
    p_val = ks_gof_sim(x,y,fit_pk_allpoints,u,s,num_sim,sample_size,max_k);
    
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
    loglog(x,y,'bo','MarkerSize',4);
    hold on
    loglog(x,fit_pk,'b-');
    loglog(x,cdf_y,'ro','MarkerSize',4);
    loglog(1:max_k,cdf_fit_pk_allpoints,'r-');
    axis([min(x)/2 max(x)*2 min(y(y>0))/2 1.1])
    xlabel(fig_xlabel{kk},'interpreter','latex','fontsize',16)
    ylabel('probability','interpreter','latex','fontsize',16)
    title(fig_title{kk},'interpreter','latex','fontsize',18)
    
    ti = get(gca,'LooseInset');
    set(gca,'Position',[ti(1) ti(2) 1-ti(3)-ti(1) 1-ti(4)-ti(2)]);
    set(gca,'units','centimeters')
    pos = get(gca,'Position');
    ti = get(gca,'LooseInset');
    set(gcf, 'PaperUnits','centimeters');
    set(gcf, 'PaperSize', [(pos(3)+ti(1)+ti(3))*0.95 (pos(4)+ti(2)+ti(4))]);
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperPosition',[0 0 pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);

    print('-dpdf',strcat('ME_PL_fit_',datafile{kk}));
    
        % Save workspace
    savefile = strcat(strcat('ME_PL_fitted_',...
        datafile{kk}),'.mat');
    save(savefile);
    
end