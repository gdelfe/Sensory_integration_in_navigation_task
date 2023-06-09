% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot test-statistics spectral features for all the monkeys and save the
% plots into figures for each monkey in a separate directory
% 
% @ Gino Del Ferraro, NYU, Jan 2023

dir_in = 'E:\Output\GINO\test_stats\'; % directory input for t_stats
dir_main = 'E:\Output\GINO\Figures\avg_results_freq_vs_time\rwd_norwd\'; % root directory for the output
Events = ["target","stop"];
show_fig = 1;

for monkey = ["Bruno","Quigley","Schro","Vik"]

        
    % load test-statistics
    load(strcat(dir_in,sprintf('test_stats_%s_all_events.mat',monkey)),'t_stats');
    % plot and save figures
    plot_spectral_features_v2(t_stats,Events,monkey,show_fig,dir_main)
    clear t_stats

end 





