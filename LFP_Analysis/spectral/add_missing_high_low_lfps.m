%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute spectrum (PSD) and spectrogram for each session, event, rwd, channel 
% PSD and spectrogram are computed across trials
%
% OUTPUT: stats: structure with PSD, spectrogram data
%
% Gino Del Ferraro @NYU, Dec 2022


function stats = add_missing_high_low_lfps(experiments,stats,Events,sess_range,ts_start,ts_stop)

for sess = sess_range

    % get indexes of trials with target always OFF
    [ind_rwd1,ind_rwd2] = get_indx_trials_target_OFF_density(experiments,sess);
    ind_rwd = [ind_rwd1,ind_rwd2];
    
    
    nch = length(experiments.sessions(sess).lfps); % number of channels
    for EventType = Events
            
            display(['---- sess ',num2str(sess),', Event: ',num2str(EventType)])

            ts = experiments.sessions(sess).lfps(1).stats.trialtype.all.events.(EventType).all_freq.ts_lfp_align_ext;
            [d, start] = min(abs(ts - ts_start)); % find first time index (for this case) with no NaN across all channels and trials 
            [~, stop] = min(abs(ts - ts_stop)); % find first time index with no NaN across all channels and trials
            ts = ts(start:stop); % select time series without NaN
            
            sampling = round(length(ts)/(ts(end)-ts(1))); % sampling 
            N = length(ts); % time series length in points
            
            [high_ind,low_ind] = get_indx_density(experiments,sess,ind_rwd); % get trial index for high/low optic flow density
            [Hidx_remap, Lidx_remap] = map_high_low_indexes_to_all_trial_indexing(high_ind,low_ind); % get the indexing wrt all_trials
            
            for chnl = 1:nch
                
                s = experiments.sessions(sess).lfps(1).stats.trialtype.all.events.(EventType).all_freq; % lfp structure
                X = s.lfp_align_ext(start:stop,:); % lfp matrix -> time x trial
                
                assert(sum(sum(isnan(X)))==0,'LFP matrix contains NaN values')
                area  = experiments.sessions(sess).lfps(chnl).brain_area; % get brain area
                area = string(area);
                
                % %%%%%%%%%%%%%%
                % ANALYSIS
                %%%%%%%%%%%%%%%%%
                
                % Store LFP and time 
                stats(sess).region.(area).event.(EventType).lfp.ch(chnl).lfp = X;
                stats(sess).region.(area).event.(EventType).high_den.ch(chnl).lfp = X(:,Hidx_remap);
                stats(sess).region.(area).event.(EventType).low_den.ch(chnl).lfp = X(:,Lidx_remap);
                
             
                
            end % channel loop
 
    end % Events loop
%     
end % session loop

end