clear all;  close all;

dir_in = 'E:\Output\GINO\test_stats\'; % directory input for t_stats
dir_out = 'E:\Output\GINO\Figures\avg_results_freq_vs_time\rwd_norwd\';
Events = ["target","stop"];
show_fig = 1;


% load test-statistics
load(strcat(dir_in,sprintf('test_AVERAGE_stats_diff_rwd_norwd.mat')));
% plot and save figures
plot_spectral_features_AVG(t_stats_avg,Events,show_fig,dir_out)