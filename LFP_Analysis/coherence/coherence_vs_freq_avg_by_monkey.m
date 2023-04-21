% Compute coherence matrix averages for theta and beta frequency range. 
% Compute average coherences across region i and region i and j, and across
% a given frequency range (theta/beta). Compute phase vs frequency averages
% across a given region i and region i-j.
%
% @ Gino Del Ferraro, NYU, 2023.



clear all; close all;

% %%%%%%%%%%%%%%%%
% PATHS
% %%%%%%%%%%%%%%%
monkey = "Quigley";
dir_in = 'E:\Output\GINO\coherence\';
dir_in_stats = 'E:\Output\GINO\stats\';
dir_out = 'E:\Output\GINO\coherence\avg_coherences\';

load(strcat(dir_in,sprintf('coherence_%s_all_events.mat',monkey)));
load(strcat(dir_in_stats,sprintf('stats_%s_all_events_density_clean.mat',monkey)));
stats_den = stats; clear stats;

density = ["high_den","low_den"];
freq_names = ["theta","beta"];
rwd_range = [1,2];

% frequency ranges in Hz
theta = [3.9,10];
beta = [15,30];

coh_ij = {};
coh_vs_freq = {};

region_sizes = [];
reg_names = fieldnames(coh.high_den.reg_X);

fs = coh.high_den.reg_X.(reg_names{1}).reg_Y.(reg_names{1}).f;
theta_idx = find(fs >= theta(1) & fs < theta(2)); % theta-range index
beta_idx = find(fs >= beta(1) & fs < beta(2)); % beta-range index

for reg_i = 1:length(reg_names)
        reg = reg_names{reg_i};
        reg_size = length(stats_den(1).region.(reg).event.move.high_den.ch);
        region_sizes = [region_sizes, reg_size];
        
end

tot_size = sum(region_sizes);
% coherence structure to store all values in theta and beta frequency
coh_ij.high_den.theta = zeros(tot_size); % coherence ij matrix for theta band
coh_ij.high_den.beta = zeros(tot_size); % coherence ij matrix for beta band 
coh_ij.low_den.theta = zeros(tot_size); % coherence ij matrix for theta band
coh_ij.low_den.beta = zeros(tot_size); % coherence ij matrix for beta band 
coh_ij.rwd(1).theta = zeros(tot_size); % coherence ij matrix for theta band
coh_ij.rwd(1).beta = zeros(tot_size); % coherence ij matrix for beta band 
coh_ij.rwd(2).theta = zeros(tot_size); % coherence ij matrix for theta band
coh_ij.rwd(2).beta = zeros(tot_size); % coherence ij matrix for beta band 


coh_ij = coherence_matrix_density(coh_ij,coh,reg_names,region_sizes,density,"theta",theta_idx);
coh_ij = coherence_matrix_density(coh_ij,coh,reg_names,region_sizes,density,"beta",beta_idx);
coh_ij = coherence_matrix_reward(coh_ij,coh,reg_names,region_sizes,rwd_range,"theta",theta_idx);
coh_ij = coherence_matrix_reward(coh_ij,coh,reg_names,region_sizes,rwd_range,"beta",beta_idx);


coh_vs_freq = coherence_vs_freq_avg_density(coh_vs_freq,coh,reg_names,region_sizes,density);
coh_vs_freq = coherence_vs_freq_avg_reward(coh_vs_freq,coh,reg_names,region_sizes,rwd_range);

save(strcat(dir_out,sprintf('coherence_matrix_ij_%s.mat',monkey)),'coh_ij','-v7.3');
save(strcat(dir_out,sprintf('coherence_vs_frequency_%s.mat',monkey)),'coh_vs_freq','-v7.3');

















