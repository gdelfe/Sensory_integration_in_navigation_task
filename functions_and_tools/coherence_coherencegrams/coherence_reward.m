% Compute coherence between two channels for trials which are either all
% rewarded or all not-rewarded
%
% @ Gino Del Ferraro, NYU, April 2023

function [coherence] = coherence_reward(coherence,stats,sess,reg_i,reg_j,EventType,r,ch_i,ch_j,W,fs,fk,pad)

X1 = stats(sess).region.(reg_i).event.(EventType).rwd(r).ch(ch_i).lfp';
X2 = stats(sess).region.(reg_j).event.(EventType).rwd(r).ch(ch_j).lfp';
N = size(X1,2)/fs; % time resolution: lenght time series/sampling rate

% -- coherence calculation via coherency()
[coh,f] = coherency(X1,X2,[N W],fs,fk,pad,0.05,1,1);

coherence.rwd(r).(EventType).reg_X.(reg_i).reg_Y.(reg_j).mat(ch_i,ch_j,:) = coh;
coherence.rwd(r).(EventType).reg_X.(reg_i).reg_Y.(reg_j).f = f;

end

