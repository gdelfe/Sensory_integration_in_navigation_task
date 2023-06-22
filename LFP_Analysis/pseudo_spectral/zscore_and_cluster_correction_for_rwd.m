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

function Zscored_stats = zscore_and_cluster_correction_for_rwd(t_stats,pseudo_avg,cluster,Zscored_stats,reg,EventType,quantity,z_th)

quantity_avg = ['avg_',quantity];
null_avg = [quantity,'_log_rwd_avg'];
null_std = [quantity,'_log_rwd_std'];
quantity_clust_list = [quantity,'_rwd_clust'];

% theta spectrogram difference - test statistics
log_rwd =  t_stats.region.(reg).event.(EventType).rwd(2).(quantity_avg);

log_rwd_avg_null = pseudo_avg.region.(reg).event.(EventType).(null_avg); % null distribution avg
log_rwd_std_null = pseudo_avg.region.(reg).event.(EventType).(null_std); % null distribution std

% z-score the log(spectrogram) difference between rwd = 0/1
z_log_rwd = (log_rwd - log_rwd_avg_null)./log_rwd_std_null;
Zscored_stats.region.(reg).event.(EventType).var.(quantity).z_log_rwd = z_log_rwd; % z-scored spectrogram

% set to zero values above threshold (in abs value)
z_log_rwd(z_log_rwd < z_th & z_log_rwd > - z_th) = 0;
Zscored_stats.region.(reg).event.(EventType).var.(quantity).z_log_rwd_th = z_log_rwd; % z-scored spectrogram thresholded pixel-wise

% % CLUSTER CORRECTION
clusters_list = cluster.region.(reg).event.(EventType).(quantity_clust_list);
sorted_clusters = sort(clusters_list); % sort clusters in ascending order (by weight)
percentile_95_idx = round(length(sorted_clusters)*0.95); % find idx for the cluster at the 95 percentile of the distribution
if isempty(sorted_clusters)
    clust_th = 0;
else
    clust_th = sorted_clusters(percentile_95_idx); % cluster size/weight threshold for the t-statistics
end

Z_spec_cc = z_spec_cluster_corrected(z_log_rwd,clust_th); % cluster correction of the test-statistics
Zscored_stats.region.(reg).event.(EventType).var.(quantity).z_log_rwd_corr = Z_spec_cc; % z-scored spectrogram cluster-corrected


end

