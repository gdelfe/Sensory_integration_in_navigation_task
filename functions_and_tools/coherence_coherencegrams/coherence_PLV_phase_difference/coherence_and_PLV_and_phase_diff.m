% Compute coherencegram, phase-locking-value, and instantaneous phase
% difference between a pair of channels ch_i, ch_j in reg_i and reg_j
% respectively.
% 
% The results for the coherence are computed across trials, results for PLV
% and phase difference are averaged across trials.
%
% Gino Del Ferraro, NYU, May 2023

function [cohgram,tf,f,PLV_ch] = coherence_and_PLV_and_phase_diff(stats_den,PLV_ch,cohgram,sess,EventType,reg_i,reg_j,optic_flow,ch_i,ch_j,tapers,fs,dn,fk)

pad = 2;

% LFPs signals 
X1 = stats_den(sess).region.(reg_i).event.(EventType).(optic_flow).ch(ch_i).lfp';
X2 = stats_den(sess).region.(reg_j).event.(EventType).(optic_flow).ch(ch_j).lfp';

if reg_i == "MST" % if recording in MST, it is recorded with linear probe and should be scaled up by a factor 1000 to have it in micro-Volt
    X1 = X1*1e3; % 
end
if reg_j == "MST" % if recording in MST, it is recorded with linear probe and should be scaled up by a factor 1000 to have it in micro-Volt
    X1 = X1*1e3; % 
end

% -- coherence calculation via coherency()
tf = 0; f = 0;
% [coh,tf,f] = tfcoh(X1,X2,tapers,fs,dn,fk,pad,0.05,11);
% cohgram = cat(3,cohgram,coh); % concatenate coherencegram results across channels 

% Phase Locking Value and Phase difference for theta and beta range, averaged across trials 
[PLV_theta,PLV_std_theta,phase_diff_theta,phase_diff_std_theta, PLV_theta_trial] = phase_locking_value(X1,X2,4,10,fs); % theta range [4-10] Hz
[PLV_beta,PLV_std_beta, phase_diff_beta,phase_diff_std_beta, PLV_beta_trial] = phase_locking_value(X1,X2,15,30,fs); % beta range [15-30] Hz

% store PLV and phase-difference results to structures, for each given pair
% of channel ch_i and ch_j

% theta range 
PLV_ch.(optic_flow).PLV_theta = [PLV_ch.(optic_flow).PLV_theta,PLV_theta];
PLV_ch.(optic_flow).PLV_std_theta = [PLV_ch.(optic_flow).PLV_std_theta,PLV_std_theta];
PLV_ch.(optic_flow).PLV_theta_trial = [PLV_ch.(optic_flow).PLV_theta_trial,PLV_theta_trial]; % per trial 
PLV_ch.(optic_flow).phase_diff_theta = [PLV_ch.(optic_flow).phase_diff_theta,phase_diff_theta];
PLV_ch.(optic_flow).phase_diff_std_theta = [PLV_ch.(optic_flow).phase_diff_std_theta,phase_diff_std_theta];

% beta range
PLV_ch.(optic_flow).PLV_beta = [PLV_ch.(optic_flow).PLV_beta,PLV_beta];
PLV_ch.(optic_flow).PLV_std_beta = [PLV_ch.(optic_flow).PLV_std_beta,PLV_std_beta];
PLV_ch.(optic_flow).PLV_beta_trial = [PLV_ch.(optic_flow).PLV_beta_trial,PLV_beta_trial]; % per trial 
PLV_ch.(optic_flow).phase_diff_beta = [PLV_ch.(optic_flow).phase_diff_beta,phase_diff_beta];
PLV_ch.(optic_flow).phase_diff_std_beta = [PLV_ch.(optic_flow).phase_diff_std_beta,phase_diff_std_beta];


end 