% Compute coherence vs frequency, for pairs of channels in two different brain
% region i and j, for all the channel pairs in the two regions. 
% The coherence is computed for different optical flow density
% conditions (high/low optic flow) and for different reward conditions
% (reward/no-reward). 
%
% @ Gino Del Ferraro, NYU, April 2023

function [coherence] = coherence_reg_i_reg_j(coherence,stats_rwd,stats_den,sess,EventType,reg_i,reg_j,nch_i,nch_j,fk,W)

display(['-- brain region i: ',num2str(reg_i),'-- brain region j: ',num2str(reg_j)])
fs = 1/stats_rwd(1).prs.psd_s_rate;
pad = 2;

X1 = stats_rwd(sess).region.(reg_i).event.(EventType).rwd(1).ch(1).lfp';
N = size(X1,2)/fs; % time resolution: lenght time series/sampling rate
[~,f] = coherency(X1,X1,[N W],fs,fk,pad,0.05,1,1); % compute this just to get the f
% allocate space
coherence.rwd(1).(EventType).reg_X.(reg_i).reg_Y.(reg_j).mat = zeros(nch_i,nch_j,length(f));
coherence.rwd(2).(EventType).reg_X.(reg_i).reg_Y.(reg_j).mat = zeros(nch_i,nch_j,length(f));
coherence.high_den.(EventType).reg_X.(reg_i).reg_Y.(reg_j).mat = zeros(nch_i,nch_j,length(f));
coherence.low_den.(EventType).reg_X.(reg_i).reg_Y.(reg_j).mat = zeros(nch_i,nch_j,length(f));

for ch_i = 1:nch_i
    for ch_j = 1:nch_j
        % reward 0
        coherence = coherence_reward(coherence,stats_rwd,sess,reg_i,reg_j,EventType,1,ch_i,ch_j,W,fs,fk,pad);
        % reward 1
        coherence = coherence_reward(coherence,stats_rwd,sess,reg_i,reg_j,EventType,2,ch_i,ch_j,W,fs,fk,pad);
        % high density
        coherence = coherence_density(coherence,stats_den,sess,reg_i,reg_j,EventType,"high_den",ch_i,ch_j,W,fs,fk,pad);
        % low density
        coherence = coherence_density(coherence,stats_den,sess,reg_i,reg_j,EventType,"low_den",ch_i,ch_j,W,fs,fk,pad);
        
    end % ch_j loop
end % ch_i loop
            
end