
clear all; close all;

% %%%%%%%%%%%%%%%
% PARAMETERS
% %%%%%%%%%%%%%%

monkeys = ["Bruno","Quigley","Schro","Vik"]

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
pseudo_avg_all = create_pseudo_stats_all(pseudo_avg,Events);

% Concatenate results across monkeys for t-statistics and pseudo-statistics
t_stats_all = concatenate_t_stats(t_stats_all,monkeys,Events,dir_in_test);
pseudo_avg_all = concatenate_pseudo_stats(pseudo_avg_all,monkeys,Events,S,dir_in_null);



for monkey = monkeys
        
    reg_names = {'PPC','PFC','MST'};
    
    reg_all = {};
    for region = 1:length(reg_names)
        reg = reg_names{region}; % get region name
        
        for EventType = Events
            
            var_names = fieldnames(t_stats_all.region.(reg).event.(EventType).rwd(1));
            for variable = 1:length(var_names)
                
                var = var_names{variable}; % get spectral variable name
                t_stat_avg.region.(reg).event.(EventType).(var) = sq(mean(t_stats_all.region.(reg).event.(EventType).rwd(1).(var),3)) - sq(mean(t_stats_all.region.(reg).event.(EventType).rwd(2).(var),3));
            end
        end
    end
end



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







