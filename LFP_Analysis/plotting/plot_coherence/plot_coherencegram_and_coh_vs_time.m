
% Plot avg coherence vs time and avg coherencegrams for both reward/no-reward
% trials and high/low optic flow density. Save figures on files.
%
% @ Gino Del Ferraro, NYU, April 2023.

clear all; close all;

monkey = "Schro";
dir_in_test = 'E:\Output\GINO\test_stats\';
dir_in_gram = 'E:\Output\GINO\coherence\avg_coherencegrams\';
dir_in_time = 'E:\Output\GINO\coherence\coherence_vs_time\';
dir_out_fig_time = 'E:\Output\GINO\Figures\coherence\coherence_vs_time\';
dir_out_fig_gram = 'E:\Output\GINO\Figures\coherence\coherencegrams\';

Events = ["target","stop"];

% load test-statistics
load(strcat(dir_in_test,sprintf('test_stats_%s_all_events.mat',monkey))); % t_stats

load(strcat(dir_in_gram,sprintf('avg_coherencegram_density_%s.mat',monkey))); % coh_avg_den
load(strcat(dir_in_gram,sprintf('avg_coherencegram_rwd_%s.mat',monkey))); % coh_avg_rwd

load(strcat(dir_in_time,sprintf('coherence_vs_time_density_%s.mat',monkey))); % coh_vs_time_den
load(strcat(dir_in_time,sprintf('coherence_vs_time_rwd_%s.mat',monkey))); % coh_vs_time_rwd

% get time and frequency parameters
tsi = t_stats.ts(round(t_stats.ti));

% theta and beta coherence vs time for DENSITY 
% plot_coherence_vs_time_density(coh_vs_time_den,monkey,Events,dir_out_fig_time,tsi)
% plot_phase_vs_time_density(coh_vs_time_den,monkey,Events,dir_out_fig_time,tsi)

plot_coherence_vs_time_density_combined(coh_vs_time_den,monkey,Events,dir_out_fig_time,tsi)
plot_angle_vs_time_density_combined(coh_vs_time_den,monkey,Events,dir_out_fig_time,tsi)

% theta and beta coherence vs time for REWARD
% plot_coherence_vs_time_rwd(coh_vs_time_rwd,monkey,Events,dir_out_fig_time,tsi)
% plot_phase_vs_time_rwd(coh_vs_time_rwd,monkey,Events,dir_out_fig_time,tsi)

plot_coherence_vs_time_rwd_combined(coh_vs_time_rwd,monkey,Events,dir_out_fig_time,tsi)
plot_angle_vs_time_rwd_combined(coh_vs_time_rwd,monkey,Events,dir_out_fig_time,tsi)

% coherencegram difference
% plot_coherencegram_difference(coh_avg_den,coh_avg_rwd,monkey,Events,dir_out_fig_gram,t_stats)



