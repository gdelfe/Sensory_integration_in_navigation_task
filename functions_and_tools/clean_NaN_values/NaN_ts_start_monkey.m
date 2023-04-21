
% Find the value of the first time step which contains NaN across sessions,
% events, rewards, channels, and trials for a given MONKEY
%
% INPUT: structure data experiments 
%
% OUTPUT : value of first time step without NaN 
%
% @ Gino Del Ferraro, NYU, December 20222

function [ts_start_tot, ts_stop_tot] = NaN_ts_start_monkey(experiments,Events,sess_range,rwd_range)

% Events = ["target","move","stop"];

ts_start_tot = [];
ts_stop_tot = [];
for sess = sess_range
    for EventType = Events
        for rwd = rwd_range
            [start, stop] = NaN_idx(experiments,sess,rwd,EventType); % find first time index with no NaN across all channels and trials
            ts = experiments.sessions(sess).lfps(1).stats.trialtype.reward(rwd).events.(EventType).all_freq.ts_lfp_align_ext; % lfp structure
            ts_start_tot = [ts_start_tot, ts(start)]; % first value with no NaN, concatenated across sess, events, rewards
            ts_stop_tot = [ts_stop_tot, ts(length(ts)-stop+1)];     % last value with no NaN, across sess, events, rewards
        end
    end
end

ts_start_tot = max(ts_start_tot);
ts_stop_tot = min(ts_stop_tot);

end