% Remove NaN value from the Eye Index vectors. Eye values are always at the
% beginning of the trial, they are used to fill in values when the trial
% has not started yet. 
% 
% This function removes them by cutting the trial and make the trial start
% from the first non-NaN value.
%
% The operation is done only on the reward and non-rewarded trials, and not
% on all the other general trials (which might contain also target ON trials)
%
% @ Gino Del Ferraro, July, 2023, NYU.



function eyeidx = remove_NaN_from_EyeIndex(eyeidx,sess_range)

for  sess = sess_range

    ntrials_NR = length(eyeidx(sess).rwd(1).trial); % trials no reward length
    ntrials_R = length(eyeidx(sess).rwd(2).trial); % trials reward length
    
    
    % no reward loop 
    for trial = 1:ntrials_NR
        
        EI = eyeidx(sess).rwd(1).trial(trial).idx; % get eyeidx
        NaN_indices = find(isnan(EI));
        up = NaN_indices(end); % index for the last NaN value
        
        ts = eyeidx(sess).rwd(1).trial(trial).ts; % get ts
        [idx_l,idx_h] = find_ts_index(ts,1); % find indexes of ts for 0 < ts < 1
        
        idx_l = max(idx_l, up);
        EI = EI(idx_l:idx_h);
        ts = ts(idx_l:idx_h);
        
        % rewrite value into structures 
        eyeidx(sess).rwd(1).trial(trial).idx = EI; % get eyeidx
        eyeidx(sess).rwd(1).trial(trial).ts = ts;
        
    end
    
    % reward loop
    for trial = 1:ntrials_R
        
        EI = eyeidx(sess).rwd(2).trial(trial).idx; % get eyeidx
        NaN_indices = find(isnan(EI));
        up = NaN_indices(end); % index for the last NaN value
        
        ts = eyeidx(sess).rwd(2).trial(trial).ts; % get ts
        [idx_l,idx_h] = find_ts_index(ts,1); % find indexes of ts for 0 < ts < 1
        
        idx_l = max(idx_l, up);
        EI = EI(idx_l:idx_h);
        ts = ts(idx_l:idx_h);
        
        % rewrite value into structures 
        eyeidx(sess).rwd(2).trial(trial).idx = EI; % get eyeidx
        eyeidx(sess).rwd(2).trial(trial).ts = ts; 
    end
    
    
end
