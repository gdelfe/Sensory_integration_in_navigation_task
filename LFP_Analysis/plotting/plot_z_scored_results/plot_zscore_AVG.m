
% Plot zscore average for each region 
%
% @ Gino Del Ferraro, June 2023

clear all; close all;

dir_out_z_score = 'E:\Output\GINO\zscored_stats\p_th_0.05\';
dir_in_test = 'E:\Output\GINO\test_stats\';
dir_main_out = 'E:\Output\GINO\Figures\z_scored_spectral\rwd_norwd_diff\'; % root directory for the output

p_th = 0.05;
Events = ["target","stop"];

load(strcat(dir_out_z_score,sprintf('zscored_AVERAGE_stats_p_th_%.2f_diff_rwd_norwd.mat',p_th)));
load(strcat(dir_in_test,sprintf('test_stats_%s_all_events.mat',"Bruno"))); % t_stats, test-statistics

dir_out = strcat(dir_main_out,sprintf('p_th_%.2f\\',p_th)); % create directory z_scored_spectral\p_th_XXX\

% plot and save figures
plot_zscored_spectral_features_AVG(Zscored_stats,t_stats,Events,p_th,1,dir_out)