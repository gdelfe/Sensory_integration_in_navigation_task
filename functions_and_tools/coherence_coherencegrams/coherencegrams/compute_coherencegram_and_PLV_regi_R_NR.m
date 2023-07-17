% Compute coherencegram, phase-locking-value, and instantaneous phase
% difference for all channel pairs across region i and j, average the
% results across the region and store coherence abs and phase of the coherencegram in
% a structure for further analysis.
% Store PLV and phase difference in another structure for further analysis.
%
% Gino Del Ferraro, NYU, May 2023

function [coherencegram, PLV_sess] = compute_coherencegram_and_PLV_regi_R_NR(stats_den,sess,EventType,reg_i,fk,tapers,dn)
                                                                               
display(['-- brain region i: ',num2str(reg_i),'-- brain region j: ',num2str(reg_i)])
fs = 1/stats_den(1).prs.psd_s_rate; % sampling rate
ts = stats_den(1).prs.ts; % time info for the LFP
pad = 2;

coh_hd_R = []; coh_ld_R = []; coh_hd_NR = []; coh_ld_NR = []; % to store coherencegrams, high density reward, low density reward, HD no reward, LD no reward
PLV_ch = {}; PLV_sess = {}; PLV_trial = {}; % to store phase-locking-values and phase-differences vs time 
coherencegram = [];
 
% initialize PLV-channel-pairs structure 
[PLV_ch] = initialize_PLV_ch(PLV_ch);
[PLV_sess] = initialize_PLV_ch(PLV_sess);
PLV_trial = initialize_PLV_trial(PLV_trial);

% number of channels for each region i and j
nch_i = length(stats_den(1).region.(reg_i).event.(EventType).high_den_NR.ch); 

% nch_i = 3;

cnt = 1;
for ch_i = 1:nch_i
    for ch_j = (ch_i+1):nch_i % it is an upper triangular matrix (due to symmetry)

	    if mod(cnt,20) == 0
	    	disp(["Pair ",num2str(cnt)," out of a total of ",num2str(nch_i*(nch_i-1)/2)," pairs"]);
	    end
	    cnt = cnt + 1;

       % Coherence, Phase Locking Value, and Phase Difference across
       % trials, for a given pair of channels i and j
       
       % high density - reward                                   
       [coh_hd_R,tf,f,PLV_ch] = coherence_and_PLV_and_phase_diff(stats_den,PLV_ch,coh_hd_R,sess,EventType,reg_i,reg_i,"high_den_R",ch_i,ch_j,tapers,fs,dn,fk);           
       % low density - reward 
       [coh_ld_R,tf,f,PLV_ch] = coherence_and_PLV_and_phase_diff(stats_den,PLV_ch,coh_ld_R,sess,EventType,reg_i,reg_i,"low_den_R",ch_i,ch_j,tapers,fs,dn,fk);
       % high density - no reward 
       [coh_hd_NR,tf,f,PLV_ch] = coherence_and_PLV_and_phase_diff(stats_den,PLV_ch,coh_hd_NR,sess,EventType,reg_i,reg_i,"high_den_NR",ch_i,ch_j,tapers,fs,dn,fk);
       % low density - no reward 
       [coh_ld_NR,tf,f,PLV_ch] = coherence_and_PLV_and_phase_diff(stats_den,PLV_ch,coh_ld_NR,sess,EventType,reg_i,reg_i,"low_den_NR",ch_i,ch_j,tapers,fs,dn,fk);

       
    end
end

Npairs = nch_i*(nch_i -1)/2;
% %%%%%%%%%%%%%%%%%%%%%%%%%%
% COHERENCEGRAM: Compute mean, std and store results
% %%%%%%%%%%%%%%%%%%%%%%%%%%

% % mean and std coherencegram and phase-coherencegram across channels, for a given session
% [coherencegram] = store_coherencegram_results(coherencegram,"high_den_R",coh_hd_R,f,tf,nch_i*(nch_i-1)/2); % number of pairs take into account that the matrix is symmetric and upper triangular
% [coherencegram] = store_coherencegram_results(coherencegram,"low_den_R",coh_hd_R,f,tf,nch_i*(nch_i-1)/2);
% [coherencegram] = store_coherencegram_results(coherencegram,"high_den_NR",coh_hd_R,f,tf,nch_i*(nch_i-1)/2);
% [coherencegram] = store_coherencegram_results(coherencegram,"low_den_NR",coh_hd_R,f,tf,nch_i*(nch_i-1)/2);

% number of trials 
num_trials_HD_R = size(stats_den(sess).region.(reg_i).event.(EventType).high_den_R.ch(1).lfp,2);
num_trials_LD_R = size(stats_den(sess).region.(reg_i).event.(EventType).low_den_R.ch(1).lfp,2);
num_trials_HD_NR = size(stats_den(sess).region.(reg_i).event.(EventType).high_den_NR.ch(1).lfp,2);
num_trials_LD_NR = size(stats_den(sess).region.(reg_i).event.(EventType).low_den_NR.ch(1).lfp,2);

% PLV_trial = average_PLV_across_channels();

n_pairs = nch_i*(nch_i-1)/2;
% PLV and instantaneous phase difference mean and std across channels 
PLV_sess = average_PLV_and_phase_across_channels(PLV_sess,PLV_ch,"high_den_R",n_pairs,num_trials_HD_R,ts);
PLV_sess = average_PLV_and_phase_across_channels(PLV_sess,PLV_ch,"low_den_R",n_pairs,num_trials_LD_R,ts);
PLV_sess = average_PLV_and_phase_across_channels(PLV_sess,PLV_ch,"high_den_NR",n_pairs,num_trials_HD_NR,ts);
PLV_sess = average_PLV_and_phase_across_channels(PLV_sess,PLV_ch,"low_den_NR",n_pairs,num_trials_LD_NR,ts);

end

