% Compute coherence between two channels for trials which are either all
% high density or low density optic flow
%
% @ Gino Del Ferraro, NYU, April 2023

function [coherence] = coherence_density(coherence,stats_den,sess,reg_i,reg_j,EventType,density,ch_i,ch_j,W,fs,fk,pad)

X1 = stats_den(sess).region.(reg_i).event.(EventType).(density).ch(ch_i).lfp';
X2 = stats_den(sess).region.(reg_j).event.(EventType).(density).ch(ch_j).lfp';
N = size(X1,2)/fs; % time resolution: lenght time series/sampling rate

% -- coherence calculation via coherency()
[coh,f] = coherency(X1,X2,[N W],fs,fk,pad,0.05,1,1);

coherence.(density).(EventType).reg_X.(reg_i).reg_Y.(reg_j).mat(ch_i,ch_j,:) = coh;
coherence.(density).(EventType).reg_X.(reg_i).reg_Y.(reg_j).f = f;

end