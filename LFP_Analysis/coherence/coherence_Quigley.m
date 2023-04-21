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
monkey = "Quigley";
dir_in = 'E:\Output\GINO\stats\';
dir_out = 'E:\Output\GINO\coherence\';


% %%%%%%%%%%%%%%%%
% Parameters
% %%%%%%%%%%%%%%%%

Events = ["target","move","stop"];
sess_range = [1,2,3];
rwd_range = [1,2];

load(strcat(dir_in,sprintf('stats_%s_all_events.mat',monkey)));
stats_rwd = stats; clear stats;
load(strcat(dir_in,sprintf('stats_%s_all_events_density_clean.mat',monkey)));
stats_den = stats; clear stats;


coh = compute_coherency_across_regions(stats_rwd,stats_den,Events,sess_range,100,5);

save(strcat(dir_out,sprintf('coherence_%s_all_events.mat',monkey)),'coh','-v7.3');



% C4 = sq(coh.low_den.reg_X.MST.reg_Y.PPC.mat(1,2,:));
% C5 = sq(coh.low_den.reg_X.PFC.reg_Y.PPC.mat(1,2,:));
% 
% C1 = sq(coh.low_den.reg_X.MST.reg_Y.MST.mat(1,2,:));
% C2 = sq(coh.low_den.reg_X.PFC.reg_Y.PFC.mat(1,2,:));
% C3 = sq(coh.low_den.reg_X.PPC.reg_Y.PPC.mat(1,2,:));
% 
% figure;
% hold all
% 
% plot(f,abs(C1));
% plot(f,abs(C2));
% plot(f,abs(C3));
% 
% plot(f,abs(C4));
% plot(f,abs(C5));








