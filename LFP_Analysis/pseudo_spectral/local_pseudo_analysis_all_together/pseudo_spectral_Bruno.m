
clear all; close all;

% %%%%%%%%%%%%%%%%
% PATHS
% %%%%%%%%%%%%%%%
monkey = "Bruno";
dir_out_main = 'E:\Output\GINO\Figures\avg_results_freq_vs_time\'
dir_in_stats = 'E:\Output\GINO\stats\';
dir_in_test = 'E:\Output\GINO\test_stats\';
dir_out_null = 'E:\Output\GINO\pseudo_stats\';
dir_out_test = 'E:\Output\GINO\test_stats\';

% LOAD STRUCTURES 
load(strcat(dir_in_stats,sprintf('stats_%s.mat',monkey)));
load(strcat(dir_in_test,sprintf('test_stats_%s.mat',monkey)));

% %%%%%%%%%%%%%%%%
% Parameters
% %%%%%%%%%%%%%%%%

f_max = 100; % max frequency for PSD (Hz)
iterations = 2;
p_th = 0.1; % p-value threshold
sess_range = [1,2];
Events = ["target"];
filename_out = sprintf('_pth_%.2f_iter_%d_nch_2',p_th,iterations);
ts = t_stats.ts;
ti = t_stats.ti;
spec_f = t_stats.f_spec;

theta_band = [3.9,10];
beta_band = [15,30];

fs = t_stats.f_spec; % spectrogram frequency
theta_idx = find(fs >= theta_band(1) & fs < theta_band(2)); % theta-range index
beta_idx = find(fs >= beta_band(1) & fs < beta_band(2)); % beta-range index

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ANALYSIS 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% create null distribution data set
disp(['Generating the null distribution....'])
pseudo_stats = null_distribution_subsampled_ch(stats,Events,sess_range,f_max,iterations); 

% count max clusters in null distribution: generate max cluster distribution
disp(['Null-distribution stats and Max cluster count in null distribution ....'])
null_stats = null_stats_max_cluster_count(pseudo_stats,Events,p_th,theta_idx,beta_idx);

% cluster correction for the test-statistics spectrogram 
disp(['Cluster correction of the test-statistics spectrogram ....'])
Zscored_stats = Zscored_results(t_stats,null_stats,Events,p_th);

disp(['Saving psuedo stats ...'])
save(strcat(dir_out_null,sprintf('pseudo_stats_%s%s.mat',monkey,filename_out)),'pseudo_stats','-v7.3');

disp(['Saving null stats averages and z-scored results ...'])
save(strcat(dir_out_null,sprintf('null_stats_%s%s.mat',monkey,filename_out)),'null_stats','-v7.3');
save(strcat(dir_out_test,sprintf('zscored_stats_%s_pth_%.2f%s.mat',monkey,p_th,filename_out)),'Zscored_stats','-v7.3');


        
        