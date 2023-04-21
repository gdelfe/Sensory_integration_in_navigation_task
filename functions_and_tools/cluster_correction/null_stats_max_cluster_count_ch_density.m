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

function cluster = null_stats_max_cluster_count_ch_density(monkey,pseudo_avg,sess_range,Events,max_ID,Niter,p_th,dir_in_null,theta_idx,beta_idx)

psd_f = pseudo_avg.prs.psd_f;
f_spec = pseudo_avg.prs.f_spec;
t_spec = pseudo_avg.prs.t_spec;
nsess = length(sess_range);

z_th = abs(norminv((0.5*p_th))); % z-score threshold for two tails test
reg_names = fieldnames(pseudo_avg.region);

for region = 1:length(reg_names)
    reg = reg_names{region};
    for EventType = Events
        
        cluster.region.(reg).event.(EventType).psd_clust_list = [];
        cluster.region.(reg).event.(EventType).spec_clust_list = [];
        cluster.region.(reg).event.(EventType).theta_t_clust_list = [];
        cluster.region.(reg).event.(EventType).beta_t_clust_list = [];
        
        
    end
end



for ID = 1:max_ID % for all the pseudo spectrograms 
    display(['Monkey ', num2str(monkey),' - ID ',num2str(ID)])
    load(strcat(dir_in_null,sprintf('%s\\pseudo_stats_%s_iter_%d_ID_%d_all_events_density.mat',monkey,monkey,Niter,ID)));
    
    
    for region = 1:length(reg_names)
        reg = reg_names{region};
        for EventType = Events
            
            nch = length(pseudo_stats(1).region.(reg).event.(EventType).ch);
            psd = zeros(Niter,length(psd_f),nsess*nch);
            spec = zeros(Niter,length(t_spec),length(f_spec),nsess*nch);
            theta_tf = zeros(Niter,length(t_spec),length(theta_idx),nsess*nch);
            beta_tf = zeros(Niter,length(t_spec),length(beta_idx),nsess*nch);
            
            cs = 1;
            for sess = sess_range
                for chnl = 1:nch
                    
                    psd(:,:,cs) = pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_psd_diff_mat;
                    spec(:,:,:,cs) = pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_tf_spec_diff_mat;
                    theta_tf(:,:,cs) = mean(pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_tf_spec_diff_mat(:,:,theta_idx),3);
                    beta_tf(:,:,cs) = mean(pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_tf_spec_diff_mat(:,:,beta_idx),3);
                    cs = cs + 1;
                end
            end
            
            % pseudo mean across sessions and channels
            psd_mean = mean(psd,3);
            spec_mean = mean(spec,4);
            theta_t_mean = mean(mean(theta_tf,4),3);
            beta_t_mean = mean(mean(beta_tf,4),3);
              
            
            % matrices to store the z-score permuted data of the null distribution
            z_psd_diff_mat = zeros(Niter,length(psd_f)); % psd
            z_spec_diff_mat = zeros(Niter,length(t_spec),length(f_spec)); % spectrogram
            z_theta_diff_mat = zeros(Niter,length(t_spec)); % theta band only
            z_beta_diff_mat = zeros(Niter,length(t_spec));  % beta band only
            
            % zscore each pseudo psd, theta_t, beta_t, for each iteration
            z_psd_diff_mat = (psd_mean - pseudo_avg.region.(reg).event.(EventType).psd_log_diff_avg)./pseudo_avg.region.(reg).event.(EventType).psd_log_diff_std;
            z_theta_diff_mat = (theta_t_mean - pseudo_avg.region.(reg).event.(EventType).theta_t_log_diff_avg)./pseudo_avg.region.(reg).event.(EventType).theta_t_log_diff_std;
            z_beta_diff_mat = (beta_t_mean - pseudo_avg.region.(reg).event.(EventType).beta_t_log_diff_avg)./pseudo_avg.region.(reg).event.(EventType).beta_t_log_diff_std;
            
            % Z-score spectrogram pseudo data (null-distribution) for the cluster correction analysis
            for i = 1:Niter
                z_spec_diff_mat(i,:,:) = (sq(spec_mean(i,:,:)) - pseudo_avg.region.(reg).event.(EventType).spec_log_diff_avg)./pseudo_avg.region.(reg).event.(EventType).spec_log_diff_std(i,:,:);              
            end         
            
            % spectrogram z-scored and thresholded
            z_spec_diff_mat(z_spec_diff_mat < z_th & z_spec_diff_mat > - z_th) = 0; % set to zero values above threshold (in abs value)
            % psd z-scored and thresholded
            z_psd_diff_mat(z_psd_diff_mat < z_th & z_psd_diff_mat > - z_th) = 0; % set to zero values above threshold (in abs value)
            % theta band z-scored and thresholded
            z_theta_diff_mat(z_theta_diff_mat < z_th & z_theta_diff_mat > - z_th) = 0; % set to zero values above threshold (in abs value)
            % theta band z-scored and thresholded
            z_beta_diff_mat(z_beta_diff_mat < z_th & z_beta_diff_mat > - z_th) = 0; % set to zero values above threshold (in abs value)
            
            
            % % COUNT MAX CLUSTERS IN THE NULL DISTRIBUTION:
            % Generate max cluster distribution by iterating through the null distribution again
            [clust_w_psd,clust_w_spec,clust_w_theta,clust_w_beta] = max_cluster_count_null_distribution_ch(z_spec_diff_mat,z_psd_diff_mat,z_theta_diff_mat,z_beta_diff_mat,Niter);
            
            % % SAVE RESULTS
            % save results into structure (avg and std of the null)
            
            
            % save results into structure (cluster size lists)
            cluster.region.(reg).event.(EventType).psd_clust_list = [cluster.region.(reg).event.(EventType).psd_clust_list; clust_w_psd];
            cluster.region.(reg).event.(EventType).spec_clust_list = [cluster.region.(reg).event.(EventType).spec_clust_list; clust_w_spec];
            cluster.region.(reg).event.(EventType).theta_t_clust_list = [cluster.region.(reg).event.(EventType).spec_clust_list; clust_w_theta];
            cluster.region.(reg).event.(EventType).beta_t_clust_list = [cluster.region.(reg).event.(EventType).spec_clust_list; clust_w_beta];
            
        end % event loop
    end % region loop
end

cluster.prs.monk_name = monkey;
cluster.prs.p_value_thresh = p_th;

end