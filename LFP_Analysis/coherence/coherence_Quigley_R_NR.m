
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
monkey = "Quigley";
reg_i = "MST";
reg_j = "PPC";
dir_in = 'E:\Output\GINO\stats\';
dir_out = 'E:\Output\GINO\coherence\coherencegrams\';


% %%%%%%%%%%%%%%%%
% Parameters
% %%%%%%%%%%%%%%%%

Events = ["target","stop"];
sess_range = [1,2,3];
rwd_range = [1,2];

load(strcat(dir_in,sprintf('stats_%s_all_events_R_NR_density_clean.mat',monkey)));
stats_den = stats; clear stats;

tapers = [0.5 5];
dn = 0.05;

EventType = "target";
sess = 1;
fk = 100;
reg_i = "MST"; reg_j = "PPC";
coh = compute_coherencegram_regi_regj_R_NR(stats_den,EventType,sess,reg_i,reg_j,fk,tapers,dn);
      

save(strcat(dir_out,sprintf('coherencegram_%s_all_events_v3.mat',monkey)),'coh','-v7.3');

% v3 contains data for high/low density trials wrt to reward only trials:
% basically in the computation of anything related to high/low density we
% consider only the rewarded trials.




