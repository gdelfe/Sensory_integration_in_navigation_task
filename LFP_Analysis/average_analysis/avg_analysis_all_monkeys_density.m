% Compute test-statistics for average results for each monkey for high/low
% optic density flow. 
% Test-statistics: 1. Theta power vs time, 2. beta power vs time, 3. the
% whole spectrogram
%
% INPUT: stats structure for each monkey
% OUTPUT: t_stats structure for each monkey
%
% @ Gino Del Ferraro, NYU, March 2023


% clear all; close all;

% % PATHS 
dir_in = 'E:\Output\GINO\stats\';
dir_out = 'E:\Output\GINO\test_stats\optic_flow_density\';

% % PARAMETERS
Events = ["target","move","stop"];
% frequency ranges in Hz
theta = [3.9,10];
beta = [15,30];

% FOR ALL MONKEYS --------------------
for monkey = ["Vik"]
    
    load(strcat(dir_in,sprintf('stats_%s_all_events_density_clean.mat',monkey)));
    
    t_stats = average_stats_density(stats,Events,theta,beta); % compute average test-statistics
    save(strcat(dir_out,sprintf('test_stats_%s_all_events_density.mat',monkey)),'t_stats','-v7.3');
    clear stats
end

