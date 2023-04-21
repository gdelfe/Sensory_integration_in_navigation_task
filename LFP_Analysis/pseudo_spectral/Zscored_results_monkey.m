
clear all; close all;

% %%%%%%%%%%%%%%%%
% PATHS
% %%%%%%%%%%%%%%%
monkey = "Schro";
p_th = 0.1; % p-value threshold
iterations = 400;
fname_in = sprintf('%s_iter_%d',monkey,iterations);
fname_out = sprintf('%s_pth_%.2f_iter_%d',monkey,p_th,iterations);

dir_in_test = 'E:\Output\GINO\test_stats\';
dir_in_out_null = 'E:\Output\GINO\pseudo_stats\';
dir_out_test = 'E:\Output\GINO\test_stats\';

% LOAD STRUCTURES 
load(strcat(dir_in_test,sprintf('test_stats_%s.mat',monkey)));
load(strcat(dir_in_out_null,sprintf('pseudo_stats_%s.mat',fname_in)));
% %%%%%%%%%%%%%%%%
% Parameters
% %%%%%%%%%%%%%%%%

Events = ["target","move"];

theta_band = [3.9,10];
beta_band = [15,30];

fs = t_stats.f_spec; % spectrogram frequency
theta_idx = find(fs >= theta_band(1) & fs < theta_band(2)); % theta-range index
beta_idx = find(fs >= beta_band(1) & fs < beta_band(2)); % beta-range index

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ANALYSIS 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% count max clusters in null distribution: generate max cluster distribution
disp(['Null-distribution stats and Max cluster count in null distribution ....'])
null_stats = null_stats_max_cluster_count(pseudo_stats,Events,p_th,theta_idx,beta_idx);

% cluster correction for the test-statistics spectrogram 
disp(['Cluster correction of the test-statistics spectrogram ....'])
Zscored_stats = Zscored_results(t_stats,null_stats,Events,p_th);

disp(['Saving null stats averages and z-scored results ...'])
save(strcat(dir_in_out_null,sprintf('null_stats_%s.mat',fname_out)),'null_stats','-v7.3');
save(strcat(dir_out_test,sprintf('zscored_stats_%s.mat',fname_out)),'Zscored_stats','-v7.3');


        


