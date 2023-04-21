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
%
% OUTPUT: clusters: structure containing the list of max clusters in each
%         iteration, i.e. the histogram of max clusters
%
% @ Gino Del Ferraro, NYU, Jan 2023

function null_stats = null_stats_max_cluster_count(pseudo_stats,Events,p_th)

psd_f = pseudo_stats.prs.psd_f;
f_spec = pseudo_stats.prs.f_spec;
t_spec = pseudo_stats.prs.t_spec;

z_th = abs(norminv((0.5*p_th))); % z-score threshold for two tails test

reg_names = fieldnames(pseudo_stats(1).region);

for region = 1:length(reg_names)
    reg = reg_names{region};
    for EventType = Events
        Niter = size(pseudo_stats.region.(reg).event.(EventType).log_psd_diff,1); % number of permuted data in total

        % averages and std of the null distributions 
        pseudo_log_psd_avg = mean(pseudo_stats.region.(reg).event.(EventType).log_psd_diff);
        pseudo_log_psd_std = std(pseudo_stats.region.(reg).event.(EventType).log_psd_diff);
        pseudo_log_spec_avg = squeeze(mean(pseudo_stats.region.(reg).event.(EventType).log_tf_spec_diff,1));
        pseudo_log_spec_std = squeeze(std(pseudo_stats.region.(reg).event.(EventType).log_tf_spec_diff));
        
        z_psd_diff_mat = zeros(Niter,length(psd_f));
        z_spec_diff_mat = zeros(Niter,length(t_spec),length(f_spec));
        
        % Z-score pseudo data (null-distribution) for the cluster correction analysis
        for i = 1:Niter
            
            % psd z-scored
            z_psd_temp = (pseudo_stats.region.(reg).event.(EventType).log_psd_diff(i,:)- pseudo_log_psd_avg)./pseudo_log_psd_std;
            z_psd_temp(z_psd_temp < z_th & z_psd_temp > - z_th) = 0; % set to zero values above threshold (in abs value)
            z_psd_diff_mat(i,:) = z_psd_temp;
            
            % spectrogram z-scored 
            z_spec_temp = (sq(pseudo_stats.region.(reg).event.(EventType).log_tf_spec_diff(i,:,:)) - pseudo_log_spec_avg)./pseudo_log_spec_std;
            z_spec_temp(z_spec_temp < z_th & z_spec_temp > - z_th) = 0; % set to zero values above threshold (in abs value)
            z_spec_diff_mat(i,:,:) = z_spec_temp;
            
        end % iterations loop
        
        Z = sq(z_spec_diff_mat(i,:,:)); % Z-scored psuedo spectrogram
        % % COUNT MAX CLUSTERS IN THE NULL DISTRIBUTION:
        % Generate max cluster distribution 
        cluster_weights_list = max_cluster_count_null_distribution(Z,Niter);
        
       
        null_stats.region.(reg).event.(EventType).log_psd_diff_avg = pseudo_log_psd_avg;
        null_stats.region.(reg).event.(EventType).log_psd_diff_std = pseudo_log_psd_std;
        null_stats.region.(reg).event.(EventType).log_spec_diff_avg = pseudo_log_spec_avg;
        null_stats.region.(reg).event.(EventType).log_spec_diff_std = pseudo_log_spec_std;
        null_stats.region.(reg).event.(EventType).max_clust_weigth_list = cluster_weights_list; % store the list of max clusters across each permutation/iterazion (across the null distribution)
                
    end % event loop
end % region loop 

end 