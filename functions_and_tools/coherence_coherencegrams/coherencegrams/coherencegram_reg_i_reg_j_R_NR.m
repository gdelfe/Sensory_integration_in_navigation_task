% Compute coherencegram for all channel pairs across region i and j, average the
% results across the region and store abs and phase of the coherencegram in
% a structure for further analysis 
%
% Gino Del Ferraro, NYU, April 2023

function [coherencegram] = coherencegram_reg_i_reg_j_R_NR(coherencegram,stats_den,sess,EventType,reg_i,reg_j,fk,tapers,dn)

display(['-- brain region i: ',num2str(reg_i),'-- brain region j: ',num2str(reg_j)])
fs = 1/stats_den(1).prs.psd_s_rate; % sampling rate
ts = stats_den(1).prs.ts; % time info for the LFP
pad = 2;

coh_hd_R = []; coh_ld_R = []; coh_hd_NR = []; coh_ld_NR = []; % to store coherencegrams, high density reward, low density reward, HD no reward, LD no reward
PLV_ch = {}; % to store phase-locking-values and phase-differences vs time 

% initialize PLV-channel-pairs structure 
[PLV_ch] = initialize_PLV_ch(PLV_ch);

% number of channels for each region i and j
nch_i = length(stats_den(1).region.(reg_i).event.(EventType).high_den_NR.ch); 
nch_j = length(stats_den(1).region.(reg_j).event.(EventType).high_den_NR.ch); 

for ch_i = 1:3 %nch_i
    for ch_j = 1:3 %nch_j
       
       % Coherence, Phase Locking Value, and Phase Difference across
       % trials, for a given pair of channels i and j
       
       % high density - reward 
       [coh_hd_R,tf,f,PLV_ch] = coherence_and_PLV_and_phase_diff(stats_den,PLV_ch,coh_hd_R,sess,EventType,reg_i,reg_j,"high_den_R",ch_i,ch_j,tapers,fs,dn,fk);           
       % low density - reward 
       [coh_ld_R,tf,f,PLV_ch] = coherence_and_PLV_and_phase_diff(stats_den,PLV_ch,coh_ld_R,sess,EventType,reg_i,reg_j,"low_den_R",ch_i,ch_j,tapers,fs,dn,fk);
       % high density - no reward 
       [coh_hd_NR,tf,f,PLV_ch] = coherence_and_PLV_and_phase_diff(stats_den,PLV_ch,coh_hd_NR,sess,EventType,reg_i,reg_j,"high_den_NR",ch_i,ch_j,tapers,fs,dn,fk);
       % low density - no reward 
       [coh_ld_NR,tf,f,PLV_ch] = coherence_and_PLV_and_phase_diff(stats_den,PLV_ch,coh_ld_NR,sess,EventType,reg_i,reg_j,"low_den_NR",ch_i,ch_j,tapers,fs,dn,fk);

       
    end
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%
% COHERENCEGRAM: Compute mean, std and store results
% %%%%%%%%%%%%%%%%%%%%%%%%%%

[coherencegram] = store_coherencegram_results(coherencegram,sess,"high_den_R",EventType,reg_i,reg_j,coh_hd_R,f,tf,nch_i*nch_j);
[coherencegram] = store_coherencegram_results(coherencegram,sess,"low_den_R",EventType,reg_i,reg_j,coh_hd_R,f,tf,nch_i*nch_j);
[coherencegram] = store_coherencegram_results(coherencegram,sess,"high_den_NR",EventType,reg_i,reg_j,coh_hd_R,f,tf,nch_i*nch_j);
[coherencegram] = store_coherencegram_results(coherencegram,sess,"low_den_NR",EventType,reg_i,reg_j,coh_hd_R,f,tf,nch_i*nch_j);



end