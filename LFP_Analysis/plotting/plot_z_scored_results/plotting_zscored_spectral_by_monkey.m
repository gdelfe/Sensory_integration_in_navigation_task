
clear all; close all;


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot test-statistics spectral features for all the monkeys and save the
% plots into figures for each monkey in a separate directory
% 
% @ Gino Del Ferraro, NYU, Jan 2023

dir_in_test = 'E:\Output\GINO\test_stats\'; % directory input for t_stats
dir_in_zscored = 'E:\Output\GINO\zscored_stats\';
dir_main_out = 'E:\Output\GINO\Figures\z_scored_spectral\rwd_norwd_diff\'; % root directory for the output
p_th = 0.05;
iterations = 5000;
Events = ["target","stop"];

for monkey = ["Bruno","Quigley","Schro","Vik"]
   
    dir_out = strcat(dir_main_out,sprintf('p_th_%.2f\\',p_th)); % create directory z_scored_spectral\p_th_XXX\monkey\
    dir_in_zscored_pth = strcat(dir_in_zscored,sprintf('p_th_%.2f\\',p_th));
    
    % load test-statistics
    load(strcat(dir_in_test,sprintf('test_stats_%s.mat',monkey)));
    % load z-scored statistics
    load(strcat(dir_in_zscored_pth,sprintf('zscored_stats_%s_p_th_%.2f_iter_%d_diff_rwd_norwd.mat',monkey,p_th,iterations)));
    
    
    
    % plot and save figures
    plot_zscored_spectral_features(Zscored_stats,t_stats,Events,monkey,p_th,iterations,1,dir_out)
    clear Zscored_stats

end 







