
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
dir_out_z_score = 'E:\Output\GINO\zscored_stats\p_th_0.05\';
dir_out_test = 'E:\Output\GINO\test_stats';

load(strcat(dir_in_null,sprintf('pseudo_avg_%s_tot_iter_%d_diff_rwd_norwd.mat',"Bruno",S))); % pseudo distribution averages, pseudo_avg

% create structure to stack t-stats and pseudo-stats results across monkeys
t_stats_all = create_t_stats_all(Events);
pseudo_all = create_pseudo_stats_all(pseudo_avg,Events);

% Concatenate results across monkeys for t-statistics and pseudo-statistics
[t_stats_all] = concatenate_t_stats(t_stats_all,monkeys,Events,dir_in_test);  
pseudo_all = concatenate_pseudo_stats(pseudo_all,monkeys,Events,S,dir_in_null);

% compute t-stat and pseudo-stat average and std 
t_stats_avg = compute_t_stat_avg(t_stats_all,Events); % % % % The error calculation should be modified. For beta/theta vs time --- modify it above in concatenate_t_stats
pseudo_avg = compute_pseudo_avg(pseudo_all,Events);


Zscored_stats = zscore_for_difference_across_monkeys(t_stats_avg,pseudo_avg,Events,'spec',p_th);
save(strcat(dir_out_z_score,sprintf('zscored_AVERAGE_stats_p_th_%.2f_diff_rwd_norwd.mat',p_th)),'Zscored_stats','-v7.3');
save(strcat(dir_out_test,'\test_AVERAGE_stats_diff_rwd_norwd.mat'),'t_stats_avg','-v7.3');







