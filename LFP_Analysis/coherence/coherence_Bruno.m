% Compute coherence matrix vs frequency for a given monkey, region-by-region,
% channel-by-channel. The coherence matrix is computed for each optical
% flow density condition, for each reward condition (reward/no-reward) for
% any given frequency (it is a 3D object).
%
% @ Gino Del Ferraro, NYU, April 2023


clear all; close all;

% %%%%%%%%%%%%%%%%
% PATHS
% %%%%%%%%%%%%%%%
monkey = "Bruno";
dir_in = 'E:\Output\GINO\stats\';
dir_out = 'E:\Output\GINO\coherence\';


% %%%%%%%%%%%%%%%%
% Parameters
% %%%%%%%%%%%%%%%%

Events = ["target","move","stop"];
sess_range = [1,2,3];
rwd_range = [1,2];

load(strcat(dir_in,sprintf('stats_%s_all_events.mat',monkey)));
stats_rwd = stats; clear stats; % stats containing reward statistics 
load(strcat(dir_in,sprintf('stats_%s_all_events_density_clean.mat',monkey)));
stats_den = stats; clear stats; % stats containing optic flow density statistiscs 


coh = compute_coherency_across_regions(stats_rwd,stats_den,Events,sess_range,100,5);

save(strcat(dir_out,sprintf('coherence_%s_all_events.mat',monkey)),'coh','-v7.3');









