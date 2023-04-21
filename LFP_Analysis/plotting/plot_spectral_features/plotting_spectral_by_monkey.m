% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot test-statistics spectral features for all the monkeys and save the
% plots into figures for each monkey in a separate directory
% 
% @ Gino Del Ferraro, NYU, Jan 2023

dir_in = 'E:\Output\GINO\test_stats\'; % directory input for t_stats
dir_main = 'E:\Output\GINO\Figures\avg_results_freq_vs_time\'; % root directory for the output
Events = ["target","move","stop"];
show_fig = 1;

for monkey = ["Vik"]

    dir_out = strcat(dir_main,sprintf('%s\\',monkey));
        
    % load test-statistics
    load(strcat(dir_in,sprintf('test_stats_%s_all_events.mat',monkey)),'t_stats');
    % plot and save figures
    plot_spectral_features(t_stats,Events,monkey,show_fig,dir_out)
    clear t_stats

end 





