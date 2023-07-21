
% Find a common time window across trial. This is needed to compute the
% averages. After finding the window, interpolate the values of the eye
% index in order to have that, across trials, EI values refer to the same
% time points
%
% @ Gino Del Ferraro, July 2023.

function eyeinter = interpolate_eyeidx_values(eyeidx,sess_range)

for sess = sess_range
    
    ntrials_NR = length(eyeidx(sess).rwd(1).trial); % trials no reward length
    ntrials_R = length(eyeidx(sess).rwd(2).trial); % trials reward length
    
    % %%%%%%%%%%%%%%%
    % Find common range in ts without NaN across trials
    % %%%%%%%%%%%%%%%
    
    % no reward loop
    min_ts = -10;
    max_ts = 10;
    for trial = 1:ntrials_NR
        
        ts = eyeidx(sess).rwd(1).trial(trial).ts; % get eyeidx
        ts_minimum = min(ts); % find the min
        min_ts = max(min_ts,ts_minimum); % update the min
        ts_maximum = max(ts); % find the max
        max_ts = min(max_ts,ts_maximum); % update the max
        
    end
    
    for trial = 1:ntrials_R
        
        ts = eyeidx(sess).rwd(2).trial(trial).ts; % get eyeidx
        ts_minimum = min(ts); % find the min
        min_ts = max(min_ts,ts_minimum); % update the min
        ts_maximum = max(ts); % find the max
        max_ts = min(max_ts,ts_maximum); % update the max
        
    end
    
      
    % %%%%%%%%%%%%%%%%%%%
    % Shorten the time ts and EI to the time window that is shared across
    % trials and interpolate the value of EI such that, across trials, EI
    % refers to the same time point
    % %%%%%%%%%%%%%%%%%%%%%%%%%%
    
    L = idx_M_ts - idx_m_ts + 1; % length of the interpolated time series 
    ts_p = linspace(m_ts,M_ts,L); % interpolated time series 
    
    for trial = 1:ntrials_NR
        
        ts = eyeidx(sess).rwd(1).trial(trial).ts; % get eyeidx
        [m_ts,idx_m_ts] = min(abs(ts-min_ts));
        [M_ts,idx_M_ts] = min(abs(ts-max_ts));
        
        ts_trial = ts(idx_m_ts:idx_M_ts); % shorten ts
        eyeinter(sess).rwd(1).trial(trial).ts = ts_trial;
        
        EI = eyeidx(sess).rwd(1).trial(trial).idx;
        EI = EI(idx_m_ts:idx_M_ts); % shorten EI
        EI_interp = interp1(ts_trial, EI, ts_p, 'linear'); % interpolate EI
        
        eyeinter(sess).rwd(1).trial(trial).idx = EI_interp;

    end
    
    eyeinter(sess).rwd(1).ts_interp = ts_p; % interpolated ts 
    
    for trial = 1:ntrials_R
        
        ts = eyeidx(sess).rwd(2).trial(trial).ts; % get eyeidx
        [m_ts,idx_m_ts] = min(abs(ts-min_ts));
        [M_ts,idx_M_ts] = min(abs(ts-max_ts));
        
        ts_trial = ts(idx_m_ts:idx_M_ts); % shorten ts
        eyeinter(sess).rwd(2).trial(trial).ts = ts_trial;
        
        EI = eyeidx(sess).rwd(2).trial(trial).idx;
        EI = EI(idx_m_ts:idx_M_ts); % shorten EI
        EI_interp = interp1(ts_trial, EI, ts_p, 'linear'); % interpolate EI
        
        eyeinter(sess).rwd(2).trial(trial).idx = EI_interp;
        
    end
    
     eyeinter(sess).rwd(2).ts_interp = ts_p; % interpolated ts 
    
end

end