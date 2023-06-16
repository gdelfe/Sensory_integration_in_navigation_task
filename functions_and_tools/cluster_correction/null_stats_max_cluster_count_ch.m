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

function cluster = null_stats_max_cluster_count_ch(monkey,pseudo_avg,sess_range,Events,max_ID,Niter,p_th,dir_in_null,theta_idx,beta_idx)

psd_f = pseudo_avg.prs.psd_f;
f_spec = pseudo_avg.prs.f_spec;
t_spec = pseudo_avg.prs.t_spec;
nsess = length(sess_range);

z_th = abs(norminv((0.5*p_th))); % z-score threshold for two tails test
reg_names = fieldnames(pseudo_avg.region);

for region = 1:length(reg_names)
    reg = reg_names{region};
    for EventType = Events
        
        % REWARD
        cluster.region.(reg).event.(EventType).psd_rwd_clust = [];
        cluster.region.(reg).event.(EventType).spec_rwd_clust = [];
        cluster.region.(reg).event.(EventType).theta_t_rwd_clust = [];
        cluster.region.(reg).event.(EventType).beta_t_rwd_clust = [];
        
        % NO REWARD
        cluster.region.(reg).event.(EventType).psd_norwd_clust = [];
        cluster.region.(reg).event.(EventType).spec_norwd_clust = [];
        cluster.region.(reg).event.(EventType).theta_t_norwd_clust = [];
        cluster.region.(reg).event.(EventType).beta_t_norwd_clust = [];
        
        % DIFFERENCE 
        cluster.region.(reg).event.(EventType).psd_diff_clust = [];
        cluster.region.(reg).event.(EventType).spec_diff_clust = [];
        cluster.region.(reg).event.(EventType).theta_t_diff_clust = [];
        cluster.region.(reg).event.(EventType).beta_t_diff_clust = [];
        
        
    end
end



for ID = 1:max_ID % for all the pseudo spectrograms 
    display(['Monkey ', num2str(monkey),' - ID ',num2str(ID)])
    load(strcat(dir_in_null,sprintf('%s\\pseudo_stats_%s_iter_%d_ID_%d_diff_rwd_norwd.mat',monkey,monkey,Niter,ID)));
    
    
    for region = 1:length(reg_names)
        reg = reg_names{region};
        for EventType = Events
            
            
            nch = length(pseudo_stats(1).region.(reg).event.(EventType).ch);
            % REWARD 
            psd_rwd = zeros(Niter,length(psd_f),nsess*nch);
            spec_rwd = zeros(Niter,length(t_spec),length(f_spec),nsess*nch);
            theta_tf_rwd = zeros(Niter,length(t_spec),length(theta_idx),nsess*nch);
            beta_tf_rwd = zeros(Niter,length(t_spec),length(beta_idx),nsess*nch);
            
            % NO REWARD
            psd_norwd = zeros(Niter,length(psd_f),nsess*nch);
            spec_norwd = zeros(Niter,length(t_spec),length(f_spec),nsess*nch);
            theta_tf_norwd = zeros(Niter,length(t_spec),length(theta_idx),nsess*nch);
            beta_tf_norwd = zeros(Niter,length(t_spec),length(beta_idx),nsess*nch);
            
            % DIFFERENCE 
            psd_diff = zeros(Niter,length(psd_f),nsess*nch);
            spec_diff = zeros(Niter,length(t_spec),length(f_spec),nsess*nch);
            theta_tf_diff = zeros(Niter,length(t_spec),length(theta_idx),nsess*nch);
            beta_tf_diff = zeros(Niter,length(t_spec),length(beta_idx),nsess*nch);
            
            cs = 1;
            for sess = sess_range
                for chnl = 1:nch
                    
                    % REWARD
                    psd_rwd(:,:,cs) = pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_psd_pseudo_rwd_mat;
                    spec_rwd(:,:,:,cs) = pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_spec_pseudo_rwd_mat;
                    theta_tf_rwd(:,:,cs) = mean(pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_spec_pseudo_rwd_mat(:,:,theta_idx),3);
                    beta_tf_rwd(:,:,cs) = mean(pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_spec_pseudo_rwd_mat(:,:,beta_idx),3);
                    
                    % NO REWARD 
                    psd_norwd(:,:,cs) = pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_psd_pseudo_norwd_mat;
                    spec_norwd(:,:,:,cs) = pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_spec_pseudo_norwd_mat;
                    theta_tf_norwd(:,:,cs) = mean(pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_spec_pseudo_norwd_mat(:,:,theta_idx),3);
                    beta_tf_norwd(:,:,cs) = mean(pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_spec_pseudo_norwd_mat(:,:,beta_idx),3);
                    
                    % DIFFERENCE
                    psd_diff(:,:,cs) = pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_psd_diff_mat;
                    spec_diff(:,:,:,cs) = pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_tf_spec_diff_mat;
                    theta_tf_diff(:,:,cs) = mean(pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_tf_spec_diff_mat(:,:,theta_idx),3);
                    beta_tf_diff(:,:,cs) = mean(pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_tf_spec_diff_mat(:,:,beta_idx),3);
                    
                    cs = cs + 1;
                end
            end
            
            % pseudo mean across sessions and channels
            
            % REWARD
            psd_mean_rwd = mean(psd_rwd,3);
            spec_mean_rwd = mean(spec_rwd,4);
            theta_t_mean_rwd = mean(mean(theta_tf_rwd,4),3);
            beta_t_mean_rwd = mean(mean(beta_tf_rwd,4),3);
            
            % NO REWARD
            psd_mean_norwd = mean(psd_norwd,3);
            spec_mean_norwd = mean(spec_norwd,4);
            theta_t_mean_norwd = mean(mean(theta_tf_norwd,4),3);
            beta_t_mean_norwd = mean(mean(beta_tf_norwd,4),3);

            % DIFFERENCE
            psd_mean_diff = mean(psd_diff,3);
            spec_mean_diff = mean(spec_diff,4);
            theta_t_mean_diff = mean(mean(theta_tf_diff,4),3);
            beta_t_mean_diff = mean(mean(beta_tf_diff,4),3);
            
            
            % matrices to store the z-score permuted data of the null distribution
            % REWARD
            z_psd_rwd_mat = zeros(Niter,length(psd_f)); % psd
            z_spec_rwd_mat = zeros(Niter,length(t_spec),length(f_spec)); % spectrogram
            z_theta_rwd_mat = zeros(Niter,length(t_spec)); % theta band only
            z_beta_rwd_mat = zeros(Niter,length(t_spec));  % beta band only
            
            % NO REWARD
            z_psd_norwd_mat = zeros(Niter,length(psd_f)); % psd
            z_spec_norwd_mat = zeros(Niter,length(t_spec),length(f_spec)); % spectrogram
            z_theta_norwd_mat = zeros(Niter,length(t_spec)); % theta band only
            z_beta_norwd_mat = zeros(Niter,length(t_spec));  % beta band only
            
            % DIFFERENCE 
            z_psd_diff_mat = zeros(Niter,length(psd_f)); % psd
            z_spec_diff_mat = zeros(Niter,length(t_spec),length(f_spec)); % spectrogram
            z_theta_diff_mat = zeros(Niter,length(t_spec)); % theta band only
            z_beta_diff_mat = zeros(Niter,length(t_spec));  % beta band only
            
            
            % zscore each pseudo psd, theta_t, beta_t, for each iteration
            % REWARD
            z_psd_rwd_mat = (psd_mean_rwd - pseudo_avg.region.(reg).event.(EventType).psd_log_rwd_avg)./pseudo_avg.region.(reg).event.(EventType).psd_log_rwd_std;
            z_theta_rwd_mat = (theta_t_mean_rwd - pseudo_avg.region.(reg).event.(EventType).theta_t_log_rwd_avg)./pseudo_avg.region.(reg).event.(EventType).theta_t_log_rwd_std;
            z_beta_rwd_mat = (beta_t_mean_rwd - pseudo_avg.region.(reg).event.(EventType).beta_t_log_rwd_avg)./pseudo_avg.region.(reg).event.(EventType).beta_t_log_rwd_std;

            % NO REWARD
            z_psd_norwd_mat = (psd_mean_norwd - pseudo_avg.region.(reg).event.(EventType).psd_log_norwd_avg)./pseudo_avg.region.(reg).event.(EventType).psd_log_norwd_std;
            z_theta_norwd_mat = (theta_t_mean_norwd - pseudo_avg.region.(reg).event.(EventType).theta_t_log_norwd_avg)./pseudo_avg.region.(reg).event.(EventType).theta_t_log_norwd_std;
            z_beta_norwd_mat = (beta_t_mean_norwd - pseudo_avg.region.(reg).event.(EventType).beta_t_log_norwd_avg)./pseudo_avg.region.(reg).event.(EventType).beta_t_log_norwd_std;
            
            % DIFFERENCE 
            z_psd_diff_mat = (psd_mean_diff - pseudo_avg.region.(reg).event.(EventType).psd_log_diff_avg)./pseudo_avg.region.(reg).event.(EventType).psd_log_diff_std;
            z_theta_diff_mat = (theta_t_mean_diff - pseudo_avg.region.(reg).event.(EventType).theta_t_log_diff_avg)./pseudo_avg.region.(reg).event.(EventType).theta_t_log_diff_std;
            z_beta_diff_mat = (beta_t_mean_diff - pseudo_avg.region.(reg).event.(EventType).beta_t_log_diff_avg)./pseudo_avg.region.(reg).event.(EventType).beta_t_log_diff_std;
            
            % Z-score spectrogram pseudo data (null-distribution) for the cluster correction analysis
            for i = 1:Niter
                z_spec_rwd_mat(i,:,:) = (sq(spec_mean_rwd(i,:,:)) - pseudo_avg.region.(reg).event.(EventType).spec_log_rwd_avg)./pseudo_avg.region.(reg).event.(EventType).spec_log_rwd_std(i,:,:);
                z_spec_norwd_mat(i,:,:) = (sq(spec_mean_norwd(i,:,:)) - pseudo_avg.region.(reg).event.(EventType).spec_log_norwd_avg)./pseudo_avg.region.(reg).event.(EventType).spec_log_norwd_std(i,:,:);
                z_spec_diff_mat(i,:,:) = (sq(spec_mean_diff(i,:,:)) - pseudo_avg.region.(reg).event.(EventType).spec_log_diff_avg)./pseudo_avg.region.(reg).event.(EventType).spec_log_diff_std(i,:,:);              
            end         
            
            % REWARD
            % spectrogram z-scored and thresholded
            z_spec_rwd_mat(z_spec_rwd_mat < z_th & z_spec_rwd_mat > -z_th) = 0; % set to zero values above threshold (in abs value)
            % psd z-scored and thresholded
            z_psd_rwd_mat(z_psd_rwd_mat < z_th & z_psd_rwd_mat > -z_th) = 0; % set to zero values above threshold (in abs value)
            % theta band z-scored and thresholded
            z_theta_rwd_mat(z_theta_rwd_mat < z_th & z_theta_rwd_mat > -z_th) = 0; % set to zero values above threshold (in abs value)
            % theta band z-scored and thresholded
            z_beta_rwd_mat(z_beta_rwd_mat < z_th & z_beta_rwd_mat > -z_th) = 0; % set to zero values above threshold (in abs value)
            
            % NO-REWARD
            % spectrogram z-scored and thresholded
            z_spec_norwd_mat(z_spec_norwd_mat < z_th & z_spec_norwd_mat > -z_th) = 0; % set to zero values above threshold (in abs value)
            % psd z-scored and thresholded
            z_psd_norwd_mat(z_psd_norwd_mat < z_th & z_psd_norwd_mat > -z_th) = 0; % set to zero values above threshold (in abs value)
            % theta band z-scored and thresholded
            z_theta_norwd_mat(z_theta_norwd_mat < z_th & z_theta_norwd_mat > -z_th) = 0; % set to zero values above threshold (in abs value)
            % theta band z-scored and thresholded
            z_beta_norwd_mat(z_beta_norwd_mat < z_th & z_beta_norwd_mat > -z_th) = 0; % set to zero values above threshold (in abs value)

            
            % DIFFERENCE 
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
            [clust_w_psd_rwd, clust_w_spec_rwd, clust_w_theta_rwd, clust_w_beta_rwd] = max_cluster_count_null_distribution_ch(z_spec_rwd_mat, z_psd_rwd_mat, z_theta_rwd_mat, z_beta_rwd_mat, Niter);
            [clust_w_psd_norwd, clust_w_spec_norwd, clust_w_theta_norwd, clust_w_beta_norwd] = max_cluster_count_null_distribution_ch(z_spec_norwd_mat, z_psd_norwd_mat, z_theta_norwd_mat, z_beta_norwd_mat, Niter);
            [clust_w_psd_diff,clust_w_spec_diff,clust_w_theta_diff,clust_w_beta_diff] = max_cluster_count_null_distribution_ch(z_spec_diff_mat,z_psd_diff_mat,z_theta_diff_mat,z_beta_diff_mat,Niter);

            % % SAVE RESULTS
            % save results into structure (avg and std of the null)
            
            
            % save results into structure (cluster size lists)
            
            % REWARD
            cluster.region.(reg).event.(EventType).psd_rwd_clust = [cluster.region.(reg).event.(EventType).psd_rwd_clust; clust_w_psd_rwd];
            cluster.region.(reg).event.(EventType).spec_rwd_clust = [cluster.region.(reg).event.(EventType).spec_rwd_clust; clust_w_spec_rwd];
            cluster.region.(reg).event.(EventType).theta_t_rwd_clust = [cluster.region.(reg).event.(EventType).theta_t_rwd_clust; clust_w_theta_rwd];
            cluster.region.(reg).event.(EventType).beta_t_rwd_clust = [cluster.region.(reg).event.(EventType).beta_t_rwd_clust; clust_w_beta_rwd];
            % NO REWARD
            cluster.region.(reg).event.(EventType).psd_norwd_clust = [cluster.region.(reg).event.(EventType).psd_norwd_clust; clust_w_psd_norwd];
            cluster.region.(reg).event.(EventType).spec_norwd_clust = [cluster.region.(reg).event.(EventType).spec_norwd_clust; clust_w_spec_norwd];
            cluster.region.(reg).event.(EventType).theta_t_norwd_clust = [cluster.region.(reg).event.(EventType).theta_t_norwd_clust; clust_w_theta_norwd];
            cluster.region.(reg).event.(EventType).beta_t_norwd_clust = [cluster.region.(reg).event.(EventType).beta_t_norwd_clust; clust_w_beta_norwd];
            % DIFFERENCE 
            cluster.region.(reg).event.(EventType).psd_diff_clust = [cluster.region.(reg).event.(EventType).psd_diff_clust; clust_w_psd_diff];
            cluster.region.(reg).event.(EventType).spec_diff_clust = [cluster.region.(reg).event.(EventType).spec_diff_clust; clust_w_spec_diff];
            cluster.region.(reg).event.(EventType).theta_t_diff_clust = [cluster.region.(reg).event.(EventType).theta_t_diff_clust; clust_w_theta_diff];
            cluster.region.(reg).event.(EventType).beta_t_diff_clust = [cluster.region.(reg).event.(EventType).beta_t_diff_clust; clust_w_beta_diff];
            
        end % event loop
    end % region loop
end

cluster.prs.monk_name = monkey;
cluster.prs.p_value_thresh = p_th;

end