
clear all; close all;

% %%%%%%%%%%%%%%%
% PARAMETERS
% %%%%%%%%%%%%%%

monkeys = ["Bruno","Quigley","Schro","Vik"];

p_th = 0.05; % p-value threshold
iter = 5 ;
sess_range = [1,2,3];
Events = ["target","stop"];
max_ID = 1000;
S = 5000;

dir_main = 'E:\Output\GINO\';
dir_in_null = 'E:\Output\GINO\pseudo_stats\';
dir_IDs =  'E:\Output\GINO\pseudo_stats\server_results\rwd_no_rwd_diff_and_singles\';
dir_in_test = 'E:\Output\GINO\test_stats\';

load(strcat(dir_in_null,sprintf('pseudo_avg_%s_tot_iter_%d_diff_rwd_norwd.mat',"Bruno",S))); % pseudo distribution averages, pseudo_avg

% create structure to stack t-stats and pseudo-stats results across monkeys
t_stats_all = create_t_stats_all(Events);
pseudo_all = create_pseudo_stats_all(pseudo_avg,Events);

% Concatenate results across monkeys for t-statistics and pseudo-statistics
[t_stats_all,f] = concatenate_t_stats(t_stats_all,monkeys,Events,dir_in_test);
pseudo_all = concatenate_pseudo_stats(pseudo_all,monkeys,Events,S,dir_in_null);

% compute t-stat and pseudo-stat average and std 
t_stat_avg = compute_t_stat_avg(t_stats_all,Events);
pseudo_avg = compute_pseudo_avg(pseudo_all,Events);


Zscored_stats = zscore_for_difference_across_monkeys(t_stat_avg,pseudo_avg,Events,'spec',p_th)

EventType = 'target';
reg = 'PPC';
spec = t_stat_avg.region.(reg).event.(EventType).rwd(1).avg_spec - t_stat_avg.region.(reg).event.(EventType).rwd(2).avg_spec;

figure;
tvimage(spec)
colorbar 
ylim([0 100])



pseudo_avg.prs.ts = t_stats.ts;
fs = pseudo_avg.prs.f_spec;

theta_band = [3.9,10];
beta_band = [15,30];

theta_idx = find(fs >= theta_band(1) & fs < theta_band(2)); % theta-range index
beta_idx = find(fs >= beta_band(1) & fs < beta_band(2)); % beta-range index


% max cluster distribution across the null distribution
% cluster  = null_stats_max_cluster_count_ch(monkey,pseudo_avg,sess_range,Events,max_ID,iter,p_th,dir_IDs,theta_idx,beta_idx);
%
%
dir_out_clust = strcat(dir_in_null,'cluster_distr\');
% if ~exist(dir_out_clust, 'dir')
%     mkdir(dir_out_clust)
% end

% save(strcat(dir_out_clust,sprintf('cluter_distribution_%s_p_th_%.2f_iter_%d_diff_rwd_norwd.mat',monkey,p_th,iter)),'cluster','-v7.3');
load(strcat(dir_out_clust,sprintf('cluter_distribution_%s_p_th_%.2f_iter_%d_diff_rwd_norwd.mat',monkey,p_th,iter)));


% cluster correction for the test-statistics spectrogram
disp(['Cluster correction of the test-statistics spectrogram ....'])
Zscored_stats = Zscored_results_ch(t_stats,pseudo_avg,cluster,Events,p_th);

dir_out_zscore = strcat(dir_main,sprintf('zscored_stats\\p_th_%.2f\\',p_th));
if ~exist(dir_out_zscore, 'dir')
    mkdir(dir_out_zscore)
end
save(strcat(dir_out_zscore,sprintf('zscored_stats_%s_p_th_%.2f_iter_%d_diff_rwd_norwd.mat',monkey,p_th,S)),'Zscored_stats','-v7.3');







