%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute spectrum (PSD) and spectrogram for each session, event, rwd, channel 
% PSD and spectrogram are computed across trials
%
% OUTPUT: stats: structure with PSD, spectrogram data
%
% Gino Del Ferraro @NYU, Dec 2022


function stats = spectral_features_monkey_density_R_NR(experiments,Events,sess_range,ts_start,ts_stop,W,f_max,Nt,Wt,dnt)

    stats = {};
for sess = sess_range
    
    stats(sess).ids.monk_id = experiments.sessions(sess).monk_id;
    stats(sess).ids.sess_id = experiments.sessions(sess).sess_id;
    stats(sess).ids.sess_date = experiments.sessions(sess).sess_date;
    
    % get indexes of trials with target always OFF
    [ vft,ind_rwd2] = get_indx_trials_target_OFF_density(experiments,sess);
%     ind_rwd = [ind_rwd1,ind_rwd2]; % include both rewarded and unrewarded trials 
%     ind_rwd = ind_rwd2; % include only rewarded trials 
    
    nch = length(experiments.sessions(sess).lfps); % number of channels
    for EventType = Events
            
            display(['---- sess ',num2str(sess),', Event: ',num2str(EventType)])

            ts = experiments.sessions(sess).lfps(1).stats.trialtype.all.events.(EventType).all_freq.ts_lfp_align_ext;
            [d, start] = min(abs(ts - ts_start)); % find first time index (for this case) with no NaN across all channels and trials 
            [~, stop] = min(abs(ts - ts_stop)); % find first time index with no NaN across all channels and trials
            ts = ts(start:stop); % select time series without NaN
            
            sampling = round(length(ts)/(ts(end)-ts(1))); % sampling 
            N = length(ts); % time series length in points
            
            [high_ind_NR,low_ind_NR] = get_indx_density(experiments,sess,ind_rwd1); % get trial index for high/low optic flow density no reward trials
            [Hidx_remap_NR, Lidx_remap_NR] = map_high_low_indexes_to_all_trial_indexing(high_ind_NR,low_ind_NR); % get the indexing wrt all_trials
            
            [high_ind_R,low_ind_R] = get_indx_density(experiments,sess,ind_rwd2); % get trial index for high/low optic flow density reward trials 
            [Hidx_remap_R, Lidx_remap_R] = map_high_low_indexes_to_all_trial_indexing(high_ind_R,low_ind_R); % get the indexing wrt all_trials
            
            for chnl = 1:nch
                
                s = experiments.sessions(sess).lfps(chnl).stats.trialtype.all.events.(EventType).all_freq; % lfp structure
                X = s.lfp_align_ext(start:stop,:); % lfp matrix -> time x trial
                
                assert(sum(sum(isnan(X)))==0,'LFP matrix contains NaN values')
                area  = experiments.sessions(sess).lfps(chnl).brain_area; % get brain area
                area = string(area);
                
                % %%%%%%%%%%%%%%
                % ANALYSIS
                %%%%%%%%%%%%%%%%%
                
                % Store LFP and time 
                stats(sess).region.(area).event.(EventType).lfp.ch(chnl).lfp = X;
                stats(sess).region.(area).event.(EventType).high_den_NR.ch(chnl).lfp = X(:,Hidx_remap_NR); % high density/no reward
                stats(sess).region.(area).event.(EventType).low_den_NR.ch(chnl).lfp = X(:,Lidx_remap_NR); % low density/no rewardd
                stats(sess).region.(area).event.(EventType).high_den_R.ch(chnl).lfp = X(:,Hidx_remap_R); % high density/reward
                stats(sess).region.(area).event.(EventType).low_den_R.ch(chnl).lfp = X(:,Lidx_remap_R); % low density/reward 
                
                
                % % PSD High density optic flow
                [spec_HD, f_psd] =  dmtspec(X(:,Hidx_remap)',[N/sampling W],sampling,f_max,2,0.05,1);
                stats(sess).region.(area).event.(EventType).high_den.ch(chnl).psd = spec_HD;
                
                % % PSD Low density optic flow
                [spec_LD, f_psd] =  dmtspec(X(:,Lidx_remap)',[N/sampling W],sampling,f_max,2,0.05,1);
                stats(sess).region.(area).event.(EventType).low_den.ch(chnl).psd = spec_LD;
                
% 
% %                 figure;
% %                 plot(f_psd,log(abs(spec)))
% %                 title(sprintf('rwd = %d',rwd))
% %                 grid on
% %                 
%                 % % Spectrogram high density optic flow
%                 [tf_spec_HD, spec_f, ti] = tfspec(X(:,Hidx_remap)',[Nt Wt], sampling, dnt, f_max, 2, 0.05, 1);            
%                 stats(sess).region.(area).event.(EventType).high_den.ch(chnl).tf_spec = tf_spec_HD;
%                 
%                 % % Spectrogram low density optic flow
%                 [tf_spec_LD, spec_f, ti] = tfspec(X(:,Lidx_remap)',[Nt Wt], sampling, dnt, f_max, 2, 0.05, 1);            
%                 stats(sess).region.(area).event.(EventType).low_den.ch(chnl).tf_spec = tf_spec_LD;
%                 
                
%                 figure;
% %                 tvimage(log(tf_spec_LD));
%                 tvimage(isnan(X));
% 
% %                 colormap(bone)
%                 colorbar
%                 grid on
%                 title([sprintf("%s",EventType),sprintf("W = %d, Nt = %.1f, dn = %.2f, ch = %d",W,Nt,dnt,chnl)]);
%                 [x_idx, xlbl, y_idx, ylbl] = tfspec_labels(ts,ti,spec_f,0.25,10);
%                 
%                 set(gca, 'XTick',x_idx, 'XTickLabel',xlbl)
%                 set(gca, 'YTick',y_idx, 'YTickLabel',ylbl)
%                 
%                 ylabel('frequency (Hz)')
%                 xlabel('time (sec)')
%                 grid on
                
            end % channel loop
 
    end % Events loop
    
    % PSD and spectrogram parameters 
    stats(sess).prs.psd_s_rate = 1/sampling; 
    
    stats(sess).prs.ts = ts;
%     stats(sess).prs.psd_f = f_psd;
%     stats(sess).prs.f_spec = spec_f;
%     stats(sess).prs.t_spec = ti;

              
    stats(sess).prs.psd_N = N;
    stats(sess).prs.psd_W = W;
    
    stats(sess).prs.spec_Nt = Nt;
    stats(sess).prs.spec_Wt = Wt;
    stats(sess).prs.spec_dnt = dnt;
    
%     
end % session loop

end