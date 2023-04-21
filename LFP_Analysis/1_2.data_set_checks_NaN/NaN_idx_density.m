
% Find the index of the first time step which contains NaN across trials
% and all the channels for a given session and the last indx without NaN 
%
% INPUT: structure data experiments, session, type or reward (i.e. 1 or 2),
% type of event (i.e. move, target, stop, reward) in string format
%
% OUTPUT : idx of first time step without NaN
%
% @ Gino Del Ferraro, NYU, November 20222

function [idx_L, idx_R] = NaN_idx_density(experiments,sess,EventType)

nch = length(experiments.sessions(sess).lfps); % number of channels 
s = experiments.sessions(sess).lfps(1).stats.trialtype.all.events.(EventType).all_freq;
NaNcount = zeros(1,size(s.lfp_align_ext,1));

for ch = 1:nch % across channels
    X = experiments.sessions(sess).lfps(ch).stats.trialtype.all.events.(EventType).all_freq.lfp_align_ext; % LFP time x trials
    NaNtemp = sum(isnan(X')); % count NaN for each trial
    NaNcount = NaNcount + NaNtemp; % cumulative num of cound across trials: NaN vs time step
end
idx_L = find(NaNcount == 0,1); % find idx of first time point with no NaN
idx_R = find(fliplr(NaNcount) == 0,1); % find idx of last time point with no NaN
end