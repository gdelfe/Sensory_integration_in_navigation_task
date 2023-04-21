
clear all; close all;

% %%%%%%%%%%%%%%%
% PARAMETERS
% %%%%%%%%%%%%%%

monkey = "Vik";
p_th = 0.05; % p-value threshold 
iter = 5 ;
sess_range = [1,2,3];
Events = ["target","move","stop"];
max_ID = 1000;
S = 5000;

dir_main = 'E:\Output\GINO\';
dir_in_null = 'E:\Output\GINO\pseudo_stats\server_results\optic_flow_density\';
dir_avg =  'E:\Output\GINO\pseudo_stats\optic_flow_density\';
dir_in_test = 'E:\Output\GINO\test_stats\optic_flow_density\';



load(strcat(dir_avg,sprintf('pseudo_avg_%s_tot_iter_%d_all_events_density.mat',monkey,S))); % pseudo distribution averages, pseudo_avg
load(strcat(dir_in_test,sprintf('test_stats_%s_all_events_density.mat',monkey))); % test-statistics, t_stats


pseudo_avg.prs.ts = t_stats.ts;
fs = pseudo_avg.prs.f_spec;

theta_band = [3.9,10];
beta_band = [15,30];

theta_idx = find(fs >= theta_band(1) & fs < theta_band(2)); % theta-range index
beta_idx = find(fs >= beta_band(1) & fs < beta_band(2)); % beta-range index


% max cluster distribution across the null distribution 
cluster  = null_stats_max_cluster_count_ch_density(monkey,pseudo_avg,sess_range,Events,max_ID,iter,p_th,dir_in_null,theta_idx,beta_idx);


dir_out_clust = strcat(dir_avg,'cluster_distr\');
if ~exist(dir_out_clust, 'dir')
    mkdir(dir_out_clust)
end

save(strcat(dir_out_clust,sprintf('cluter_distribution_%s_p_th_%.2f_iter_%d_all_events_density.mat',monkey,p_th,iter)),'cluster','-v7.3');
% load(strcat(dir_out_clust,sprintf('cluter_distribution_%s_p_th_%.2f_iter_%d_all_events.mat',monkey,p_th,iter)));


% cluster correction for the test-statistics spectrogram 
disp(['Cluster correction of the test-statistics spectrogram ....'])
Zscored_stats = Zscored_results_ch_density(t_stats,pseudo_avg,cluster,Events,p_th);

dir_out_zscore = strcat(dir_main,sprintf('zscored_stats\\optic_flow_density\\p_th_%.2f\\',p_th));
if ~exist(dir_out_zscore, 'dir')
    mkdir(dir_out_zscore)
end
save(strcat(dir_out_zscore,sprintf('zscored_stats_%s_p_th_%.2f_iter_%d_all_events_density.mat',monkey,p_th,S)),'Zscored_stats','-v7.3');







