%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is the core function to compute z-score the test-statistics
% and cluster correction. 
% Given a t_stats and null_stat matrix, it computes the z-scored statistics
% cluster corrected.
%
% INPUT: t_stats; null_stats; Zscored_stats; EventType; 
% quantity (e.g. psd/spec/theta/beta); quantity_avg = 'avg_of_the_quantity'
% 
% OUTPUT: Zscored_stats structure with z-scored stats cluster corrected
%
% @ Gino Del Ferraro, NYU, Jan 2023

function Zscored_stats = zscore_and_cluster_correction_for_variable(t_stats,null_stats,Zscored_stats,reg,EventType,quantity_avg,quantity,z_th)

% theta spectrogram difference - test statistics
log_diff =  t_stats.region.(reg).event.(EventType).rwd(1).(quantity_avg) - t_stats.region.(reg).event.(EventType).rwd(2).(quantity_avg);
log_diff_avg_null = null_stats.region.(reg).event.(EventType).var.(quantity).log_diff_avg; % null distribution avg
log_diff_std_null = null_stats.region.(reg).event.(EventType).var.(quantity).log_diff_std; % null distribution std

% z-score the log(spectrogram) difference between rwd = 0/1
if quantity ~= "spec"
    log_diff = log_diff';
end
z_log_diff = (log_diff - log_diff_avg_null)./log_diff_std_null;
Zscored_stats.region.(reg).event.(EventType).var.(quantity).z_log_diff = z_log_diff; % z-scored spectrogram

% set to zero values above threshold (in abs value)
z_log_diff(z_log_diff < z_th & z_log_diff > - z_th) = 0;
Zscored_stats.region.(reg).event.(EventType).var.(quantity).z_log_diff_th = z_log_diff; % z-scored spectrogram thresholded pixel-wise

% % CLUSTER CORRECTION
clusters_list = null_stats.region.(reg).event.(EventType).var.(quantity).max_clust_w_list;
sorted_clusters = sort(clusters_list); % sort clusters in ascending order (by weight)
percentile_95_idx = round(length(clusters_list)*0.95); % find idx for the cluster at the 95 percentile of the distribution
if isempty(sorted_clusters)
    clust_th_theta = 0;
else
    clust_th_theta = sorted_clusters(percentile_95_idx); % cluster size/weight threshold for the t-statistics
end

Z_spec_theta_cc = z_spec_cluster_corrected(z_log_diff,clust_th_theta); % cluster correction of the test-statistics
Zscored_stats.region.(reg).event.(EventType).var.(quantity).z_log_diff_clust_corr = Z_spec_theta_cc; % z-scored spectrogram cluster-corrected
           
           
end