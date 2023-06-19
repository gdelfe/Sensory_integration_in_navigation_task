% Compute test-statistics for average results for each monkey.
% Test-statistics: 1. Theta power vs time, 2. beta power vs time, 3. the
% whole spectrogram
%
% INPUT: stats structure for each monkey
% OUTPUT: t_stats structure for each monkey
%
% @ Gino Del Ferraro, NYU, Jan 2023



% clear all; close all;

% % PATHS 
dir_in = 'E:\Output\GINO\stats\';
dir_out = 'E:\Output\GINO\test_stats\';

% % PARAMETERS
Events = ["target","stop"];
% frequency ranges in Hz
theta = [3.9,10];
beta = [15,30];

% FOR ALL MONKEYS --------------------
for monkey = ["Schro"]
    
    load(strcat(dir_in,sprintf('stats_%s_all_events.mat',monkey)));
    
    t_stats = average_stats(stats,Events,theta,beta); % compute average test-statistics
    save(strcat(dir_out,sprintf('test_stats_%s_all_events.mat',monkey)),'t_stats','-v7.3');
    clear stats
end

