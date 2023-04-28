 
clear all; close all;

% %%%%%%%%%%%%%%%%
% PATHS
% %%%%%%%%%%%%%%%
monkey = "Schro";
dir_in = 'E:\Output\GINO\coherence\coherencegrams\';
dir_out_gram = 'E:\Output\GINO\coherence\avg_coherencegrams\';
dir_out_time = 'E:\Output\GINO\coherence\coherence_vs_time\';

density = ["high_den","low_den"];
Events = ["target","stop"];

% frequency ranges in Hz
theta = [3.9,10];
beta = [15,30];
rand_ch = 10; % number of channels used to compute the spectrograms for each regions

load(strcat(dir_in,sprintf('coherencegram_%s_all_events_v3.mat',monkey))); % coh, coherencegram average across 10 channels per brain region

reg_names = fieldnames(coh(1).high_den.target.reg_X); % brain regions name

% coherencegram averages across brain region for high/low density optic flow
coh_avg_den = avg_cohgram_density_over_sessions(coh,density,reg_names,Events,rand_ch);
% coherencegram averages across brain region for reward/no-reward 
coh_avg_rwd = avg_cohgram_rwd_over_sessions(coh,reg_names,Events,rand_ch);

% coherence vs time in theta and beta band 
coh_vs_time_den = avg_cohgram_vs_time_for_freq_band_density(coh_avg_den,density,reg_names,Events,theta,beta,rand_ch);
coh_vs_time_rwd = avg_cohgram_vs_time_for_freq_band_rwd(coh_avg_rwd,reg_names,Events,theta,beta,rand_ch);


save(strcat(dir_out_gram,sprintf('avg_coherencegram_density_%s.mat',monkey)),'coh_avg_den','-v7.3');
save(strcat(dir_out_gram,sprintf('avg_coherencegram_rwd_%s.mat',monkey)),'coh_avg_rwd','-v7.3');

save(strcat(dir_out_time,sprintf('coherence_vs_time_density_%s.mat',monkey)),'coh_vs_time_den','-v7.3');
save(strcat(dir_out_time,sprintf('coherence_vs_time_rwd_%s.mat',monkey)),'coh_vs_time_rwd','-v7.3');
 

