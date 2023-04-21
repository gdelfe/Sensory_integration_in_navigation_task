% Compute coherence vs frequency, for pairs of channels in a given brain
% region i, for all the channel pairs in the region (upper triangular
% matrix). The coherence is computed for different optical flow density
% conditions (high/low optic flow) and for different reward conditions
% (reward/no-reward). 
%
% @ Gino Del Ferraro, NYU, April 2023


function [coherence] = coherence_reg_i(coherence,stats_rwd,stats_den,sess,EventType,reg_i,nch_i,fk,W)

display(['-- brain region i: ',num2str(reg_i),'-- brain region j: ',num2str(reg_i)])
fs = 1/stats_rwd(1).prs.psd_s_rate;
pad = 2;

X1 = stats_rwd(sess).region.(reg_i).event.(EventType).rwd(1).ch(1).lfp';
N = size(X1,2)/fs; % time resolution: lenght time series/sampling rate
[~,f] = coherency(X1,X1,[N W],fs,fk,pad,0.05,1,1); % compute this just to get the f
% allocate space
coherence.rwd(1).(EventType).reg_X.(reg_i).reg_Y.(reg_i).mat = zeros(nch_i,nch_i,length(f));
coherence.rwd(2).(EventType).reg_X.(reg_i).reg_Y.(reg_i).mat = zeros(nch_i,nch_i,length(f));
coherence.high_den.(EventType).reg_X.(reg_i).reg_Y.(reg_i).mat = zeros(nch_i,nch_i,length(f));
coherence.low_den.(EventType).reg_X.(reg_i).reg_Y.(reg_i).mat = zeros(nch_i,nch_i,length(f));

% for the triangular matrix
for ch_i = 1:nch_i
    for ch_j = ch_i+1:nch_i
        % reward 0
        coherence = coherence_reward(coherence,stats_rwd,sess,reg_i,reg_i,EventType,1,ch_i,ch_j,W,fs,fk,pad);
        % reward 1
        coherence = coherence_reward(coherence,stats_rwd,sess,reg_i,reg_i,EventType,2,ch_i,ch_j,W,fs,fk,pad);
        % high density
        coherence = coherence_density(coherence,stats_den,sess,reg_i,reg_i,EventType,"high_den",ch_i,ch_j,W,fs,fk,pad);
        % low density
        coherence = coherence_density(coherence,stats_den,sess,reg_i,reg_i,EventType,"low_den",ch_i,ch_j,W,fs,fk,pad);
        
    end % ch_j loop
end % ch_i loop
            
end