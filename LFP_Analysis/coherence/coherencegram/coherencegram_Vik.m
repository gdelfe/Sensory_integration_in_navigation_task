
% Compute pair-wise coherencegrams across N random channels chosen in
% region i and region j. Coherencegrams are computed intra- and
% inter-regions. Instead that computing them for all possible pairs of
% channels (it would take too long) we chose a variable number N of them to
% compute, stored in the variable rand_ch.
%
% Average results for the abs coherencegram and avg phase are stored in a
% structure  (averaged across region i and j)
%
% Gino Del Ferraro, NYU, 2023.


clear all; close all;

% %%%%%%%%%%%%%%%%
% PATHS
% %%%%%%%%%%%%%%%
monkey = "Vik";
dir_in = 'E:\Output\GINO\stats\';
dir_out = 'E:\Output\GINO\coherence\coherencegrams\';


% %%%%%%%%%%%%%%%%
% Parameters
% %%%%%%%%%%%%%%%%

Events = ["target","stop"];
sess_range = [1,2,3];
rwd_range = [1,2];

load(strcat(dir_in,sprintf('stats_%s_all_events.mat',monkey)));
stats_rwd = stats; clear stats;
load(strcat(dir_in,sprintf('stats_%s_all_events_density_clean.mat',monkey)));
stats_den = stats; clear stats;

tapers = [0.5 5];
dn = 0.05;
rand_ch = 15; % number of random channels chosen for each region
coh = compute_coherencegram_across_regions(stats_rwd,stats_den,Events,sess_range,100,tapers,dn,rand_ch);

save(strcat(dir_out,sprintf('coherencegram_%s_all_events_v3.mat',monkey)),'coh','-v7.3');


