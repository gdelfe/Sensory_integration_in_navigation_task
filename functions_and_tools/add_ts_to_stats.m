%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add time axis value for the LFP into the stats structure
%
% OUTPUT: stats structure with one more field
%
% Gino Del Ferraro @NYU, Dec 2022


function add_ts_to_stats(experiments,stats,Events,sess_range,rwd_range,ts_start,ts_stop)

for sess = sess_range
    nch = length(experiments.sessions(sess).lfps); % number of channels
    for EventType = Events
        for r = rwd_range
            
            display(['---- sess ',num2str(sess),', Event: ',num2str(EventType),', reward = ',num2str(r)])
            
            area  = experiments.sessions(sess).lfps(chnl).brain_area; % get brain area
            area = string(area);
                
            ts = experiments.sessions(sess).lfps(1).stats.trialtype.reward(r).events.(EventType).all_freq.ts_lfp_align_ext;
            [d, start] = min(abs(ts - ts_start)); % find first time index (for this case) with no NaN across all channels and trials 
            [d, stop] = min(abs(ts - ts_stop)); % find first time index with no NaN across all channels and trials
            ts = ts(start:stop); % select time series without NaN
            
            stats(sess).region.(area).event.(EventType).rwd(r).ts = ts;
        end
    end
end

end