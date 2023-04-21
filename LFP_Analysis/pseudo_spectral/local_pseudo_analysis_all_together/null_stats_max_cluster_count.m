% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function performs the statistical correction for multiple
% comparisons using cluster-based statistics, i.e. cluster correction
% p-value statistics. In details, it computes the distribution of max
% clusters for the null distribution.
%
% Once the null distribution is generated (with
% null_distribution_subsampled.m), this function loops through the null
% distribution twice: 1. First time to z-score each pseudo spectrogram,
% 2. Second time to identify the maximum cluster in each pseudo spectrogram.
%
% Max clusters are identified with the z-score weight, and not simply with
% the size (number of pixel) in the cluster itself. This is easily
% changeable to other formulations.
%
% INPUT: psuedo_stats: structure cointaining the null distribution
%        Events: list of events, e.g. target, move
%        p_th: p-value threshold for multiple comparison, e.g. 0.05
%        theta_idx, beta_idx: indexes for the theta and beta range
%
% OUTPUT: clusters: structure containing the list of max clusters in each
%         iteration, i.e. the histogram of max clusters
%         null statistics: mean and std of null distribution for: a. whole
%         spectrogram, b. theta_band only, c. beta_band only
%
% @ Gino Del Ferraro, NYU, Jan 2023

function null_stats = null_stats_max_cluster_count(pseudo_stats,Events,p_th,theta_idx,beta_idx)

psd_f = pseudo_stats.prs.psd_f;
f_spec = pseudo_stats.prs.f_spec;
t_spec = pseudo_stats.prs.t_spec;

z_th = abs(norminv((0.5*p_th))); % z-score threshold for two tails test

reg_names = fieldnames(pseudo_stats(1).region);

for region = 1:length(reg_names)
    reg = reg_names{region};
    for EventType = Events
        Niter = size(pseudo_stats.region.(reg).event.(EventType).log_psd_diff,1); % number of permuted data in total

        % averages and std of the null distributions (across iterations)
        pseudo_log_psd_avg = mean(pseudo_stats.region.(reg).event.(EventType).log_psd_diff);
        pseudo_log_psd_std = std(pseudo_stats.region.(reg).event.(EventType).log_psd_diff);
        pseudo_log_spec_avg = sq(mean(pseudo_stats.region.(reg).event.(EventType).log_tf_spec_diff,1));
        pseudo_log_spec_std = sq(std(pseudo_stats.region.(reg).event.(EventType).log_tf_spec_diff));
        
        % averages and variance in theta band of the null distribution (across iterations and frequency band)
        pseudo_log_spec_avg_theta = mean(sq(mean(pseudo_stats.region.(reg).event.(EventType).log_tf_spec_diff(:,:,theta_idx),1)),2); % mean of the mean
        pseudo_log_spec_std_theta = sqrt(mean(sq(var(pseudo_stats.region.(reg).event.(EventType).log_tf_spec_diff(:,:,theta_idx),1)),2)); % std = sqrt(mean(var))
        
        % averages and variance in beta band of the null distribution (across iterations and frequency band)
        pseudo_log_spec_avg_beta = mean(sq(mean(pseudo_stats.region.(reg).event.(EventType).log_tf_spec_diff(:,:,beta_idx),1)),2); % mean of the mean
        pseudo_log_spec_std_beta = sqrt(mean(sq(var(pseudo_stats.region.(reg).event.(EventType).log_tf_spec_diff(:,:,beta_idx),1)),2)); % std = sqrt(mean(var))
        
        
        % matrices to store the z-score permuted data of the null distribution
        z_psd_diff_mat = zeros(Niter,length(psd_f)); % psd
        z_spec_diff_mat = zeros(Niter,length(t_spec),length(f_spec)); % spectrogram
        z_theta_diff_mat = zeros(Niter,length(t_spec)); % theta band only
        z_beta_diff_mat = zeros(Niter,length(t_spec));  % beta band only
        
        % Z-score pseudo data (null-distribution) for the cluster correction analysis
        for i = 1:Niter
            
            
            % spectrogram z-scored 
            log_spec_diff = sq(pseudo_stats.region.(reg).event.(EventType).log_tf_spec_diff(i,:,:));
            z_spec_temp = (log_spec_diff - pseudo_log_spec_avg)./pseudo_log_spec_std;
            z_spec_temp(z_spec_temp < z_th & z_spec_temp > - z_th) = 0; % set to zero values above threshold (in abs value)
            z_spec_diff_mat(i,:,:) = z_spec_temp;
            
            % psd z-scored
            z_psd_temp = (pseudo_stats.region.(reg).event.(EventType).log_psd_diff(i,:)- pseudo_log_psd_avg)./pseudo_log_psd_std;
            z_psd_temp(z_psd_temp < z_th & z_psd_temp > - z_th) = 0; % set to zero values above threshold (in abs value)
            z_psd_diff_mat(i,:) = z_psd_temp;
            
            % theta band z-scored 
            theta_pow = mean(log_spec_diff(:,theta_idx),2); 
            z_theta_temp = (theta_pow - pseudo_log_spec_avg_theta)./pseudo_log_spec_std_theta;
            z_theta_temp(z_theta_temp < z_th & z_theta_temp > - z_th) = 0; % set to zero values above threshold (in abs value)
            z_theta_diff_mat(i,:) = z_theta_temp;
            
            % theta band z-scored 
            beta_pow = mean(log_spec_diff(:,beta_idx),2); 
            z_beta_temp = (theta_pow - pseudo_log_spec_avg_beta)./pseudo_log_spec_std_beta;
            z_beta_temp(z_beta_temp < z_th & z_beta_temp > - z_th) = 0; % set to zero values above threshold (in abs value)
            z_beta_diff_mat(i,:) = z_beta_temp;
                     
        end % iterations loop
        
        
        % % COUNT MAX CLUSTERS IN THE NULL DISTRIBUTION:
        % Generate max cluster distribution by iterating through the null distribution again 
        [clust_w_psd,clust_w_spec,clust_w_theta,clust_w_beta] = max_cluster_count_null_distribution(z_psd_diff_mat,z_spec_diff_mat,z_theta_diff_mat,z_beta_diff_mat,Niter);
        
        % % SAVE RESULTS 
        % save results into structure (avg and std of the null)
        null_stats.region.(reg).event.(EventType).var.psd.log_diff_avg = pseudo_log_psd_avg;
        null_stats.region.(reg).event.(EventType).var.psd.log_diff_std = pseudo_log_psd_std;
        null_stats.region.(reg).event.(EventType).var.spec.log_diff_avg = pseudo_log_spec_avg;
        null_stats.region.(reg).event.(EventType).var.spec.log_diff_std = pseudo_log_spec_std;
        
        null_stats.region.(reg).event.(EventType).var.theta.log_diff_avg = pseudo_log_spec_avg_theta;
        null_stats.region.(reg).event.(EventType).var.theta.log_diff_std = pseudo_log_spec_std_theta;
        null_stats.region.(reg).event.(EventType).var.beta.log_diff_avg = pseudo_log_spec_avg_beta;
        null_stats.region.(reg).event.(EventType).var.beta.log_diff_std = pseudo_log_spec_std_beta;
        
        % save results into structure (cluster size lists)
        null_stats.region.(reg).event.(EventType).var.psd.max_clust_w_list = clust_w_psd; % store the list of max clusters across each permutation/iterazion (across the null distribution)
        null_stats.region.(reg).event.(EventType).var.spec.max_clust_w_list = clust_w_spec; 
        null_stats.region.(reg).event.(EventType).var.theta.max_clust_w_list = clust_w_theta;
        null_stats.region.(reg).event.(EventType).var.beta.max_clust_w_list = clust_w_beta;
      
    end % event loop
end % region loop 

end 