%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute spectrum (PSD) and spectrogram for each session, event, rwd, channel 
% PSD and spectrogram are computed across trials
%
% OUTPUT: stats: structure with PSD, spectrogram data
%
% Gino Del Ferraro @NYU, Dec 2022


function stats = spectral_features_monkey(experiments,Events,sess_range,rwd_range,ts_start,ts_stop,W,f_max,Nt,Wt,dnt)

    stats = {};
for sess = sess_range
    
    stats(sess).ids.monk_id = experiments.sessions(sess).monk_id;
    stats(sess).ids.sess_id = experiments.sessions(sess).sess_id;
    stats(sess).ids.sess_date = experiments.sessions(sess).sess_date;
    
    % get indexes of trials with target always OFF
    [ind_rwd1,ind_rwd2] = get_indx_trials_target_OFF(experiments,sess);
    ind_rwd = {ind_rwd1,ind_rwd2};
    
    nch = length(experiments.sessions(sess).lfps); % number of channels
    for EventType = Events
        for r = rwd_range
            
            display(['---- sess ',num2str(sess),', Event: ',num2str(EventType),', reward = ',num2str(r)])

            ts = experiments.sessions(sess).lfps(1).stats.trialtype.reward(r).events.(EventType).all_freq.ts_lfp_align_ext;
            [d, start] = min(abs(ts - ts_start)); % find first time index (for this case) with no NaN across all channels and trials 
            [d, stop] = min(abs(ts - ts_stop)); % find first time index with no NaN across all channels and trials
            ts = ts(start:stop); % select time series without NaN
            
            sampling = round(length(ts)/(ts(end)-ts(1))); % sampling 
            N = length(ts); % time series length in points
            
            for chnl = 1:nch
                
                s = experiments.sessions(sess).lfps(chnl).stats.trialtype.reward(r).events.(EventType).all_freq; % lfp structure
                X = s.lfp_align_ext(start:stop,ind_rwd{r}); % lfp matrix -> time x trial
                
                assert(sum(sum(isnan(X)))==0,'LFP matrix contains NaN values')
                area  = experiments.sessions(sess).lfps(chnl).brain_area; % get brain area
                area = string(area);
                
                % %%%%%%%%%%%%%%
                % ANALYSIS
                %%%%%%%%%%%%%%%%%
                
                if area == "MST" % if recording in MST, it is recorded with linear probe and should be scaled up by a factor 1000 to have it in micro-Volt
                    X = X*1e3; %
                end
                
                % Store LFP and time 
                stats(sess).region.(area).event.(EventType).rwd(r).ch(chnl).lfp = X;
                
                             
                % % PSD
                [spec, f_psd] =  dmtspec(X',[N/sampling W],sampling,f_max,2,0.05,1);
                stats(sess).region.(area).event.(EventType).rwd(r).ch(chnl).psd = spec;

%                 figure;
%                 plot(f_psd,log(abs(spec)))
%                 title(sprintf('rwd = %d',rwd))
%                 grid on
%                 
                % % Spectrogram 
                [tf_spec, spec_f, ti] = tfspec(X',[Nt Wt], sampling, dnt, f_max, 2, 0.05, 1);            
                stats(sess).region.(area).event.(EventType).rwd(r).ch(chnl).tf_spec = tf_spec;
                
                
%                 figure;
%                 tvimage(log(tf_spec));
% %                 colormap(bone)
%                 colorbar
%                 grid on
%                 title([sprintf("%s",EventType),sprintf("W = %d, Nt = %.1f, dn = %.2f, rwd = %d, ch = %d",W,Nt,dnt,r,chnl)]);
%                 [x_idx, xlbl, y_idx, ylbl] = tfspec_labels(ts,ti,spec_f,0.25,10);
%                 
%                 set(gca, 'XTick',x_idx, 'XTickLabel',xlbl)
%                 set(gca, 'YTick',y_idx, 'YTickLabel',ylbl)
%                 
%                 ylabel('frequency (Hz)')
%                 xlabel('time (sec)')
%                 grid on
                
            end % channel loop
 
        end % reward loop
    end % Events loop
    
    % PSD and spectrogram parameters 
    stats(sess).prs.psd_s_rate = 1/sampling; 
    
    stats(sess).prs.ts = ts;
    stats(sess).prs.psd_f = f_psd;
    stats(sess).prs.f_spec = spec_f;
    stats(sess).prs.t_spec = ti;

              
    stats(sess).prs.psd_N = N;
    stats(sess).prs.psd_W = W;
    
    stats(sess).prs.spec_Nt = Nt;
    stats(sess).prs.spec_Wt = Wt;
    stats(sess).prs.spec_dnt = dnt;
    
%     
end % session loop

end