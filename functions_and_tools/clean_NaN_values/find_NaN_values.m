% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find the session, reward type, event type, which still contains NaN
% values after removal of the NaN: such sessions/rwd/event must be those
% which have NaN value from start to end of the LFP stream
%
% INPUT: experiment structure, ts_start = start time of no NaN, ts_stop =
% final time with no NaN
%
% OUTPUT: Sess, reward, eventype which still contain NaN values 


function NaN_values = find_NaN_values(experiments,ts_start,ts_stop) 

Events = ["target","move","stop","reward"];

NaN_values = [];
nch = size(experiments.sessions(1).lfps,2); % # of total channels
for sess = 1:3
    for EventType = Events
        for rwd = 1:2
            
            ts = experiments.sessions(sess).lfps(1).stats.trialtype.reward(rwd).events.(EventType).all_freq.ts_lfp_align_ext;
            [d, start] = min(abs(ts - ts_start)); % find first time index with no NaN across all channels and trials 
            [d, stop] = min(abs(ts - ts_stop)); % find first time index with no NaN across all channels and trials
            ts = ts(start:stop); % select time series without NaN
            
            
            s = experiments.sessions(sess).lfps(1).stats.trialtype.reward(rwd).events.(EventType).all_freq; % lfp structure
            X = s.lfp_align_ext(start:stop,:); % lfp matrix -> time x trial
            
            Y = zeros(size(X));
            
            % sum up values across channels so to check for NaN across channels 
            for chnl = 1:nch
                s = experiments.sessions(sess).lfps(chnl).stats.trialtype.reward(rwd).events.(EventType).all_freq; % lfp structure
                X = s.lfp_align_ext(start:stop,:); % lfp matrix -> time x trial
                Y =  Y + X;
            end
            if(sum(sum(isnan(Y)))) > 0 % if there are NaN after removal, these must be in the whole matrix Y
                NaN_values = [NaN_values; sess, EventType, rwd];
            end
        end
    end
end

end 