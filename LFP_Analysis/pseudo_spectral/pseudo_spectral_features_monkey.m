%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute permuted spectrum (PSD) and permuted spectrogram for each session, event, rwd, channel
% PSD and spectrogram for reward = 0/1 are computed by randomly swapping
% the lfp reward in 0 with those in 1.
%
% OUTPUT: stats: structure with PSD, spectrogram (permuted data) - to be
% used to construct a Null Distribution
%
% Gino Del Ferraro @NYU, Jan 2023


function pseudo_stats = pseudo_spectral_features_monkey(stats,Events,sess_range,f_max,iterations)

pseudo_stats = {};
for sess = sess_range
    
    pseudo_stats(sess).ids.monk_id = stats(1).ids.monk_id;
    pseudo_stats(sess).ids.sess_id = stats(1).ids.sess_id;
    pseudo_stats(sess).ids.sess_date = stats(1).ids.sess_date;
    
    sampling = round(1/stats(1).prs.psd_s_rate); % sampling
    N = stats(1).prs.psd_N; % time series length in points
    W = stats(1).prs.psd_W; % frequency resolution for spectrum
    Nt = stats(1).prs.spec_Nt;
    Wt = stats(1).prs.spec_Wt;
    dnt = stats(1).prs.spec_dnt;
    
    reg_names = fieldnames(stats(1).region);
    
    for region = 1:length(reg_names)
        for EventType = Events
            
            display(['---- sess ',num2str(sess),', Event: ',num2str(EventType)])
            
            reg = reg_names{region};
            nch = length(stats(sess).region.(reg).event.(EventType).rwd(1).ch); % total number of channels
            n1 = size(stats(sess).region.(reg).event.(EventType).rwd(1).ch(1).lfp,2); % number of incorrect trials (no reward)
            n2 = size(stats(sess).region.(reg).event.(EventType).rwd(2).ch(1).lfp,2); % number of correct trials (reward)
            
            n_tot = n1 + n2; % tot number of trials
                        
            for chnl = 1:2%nch
                display(['---- channel ',num2str(chnl)])

                % Pseudo LFP -- Permuted lfp between rwd 1 and 2(incorrect/correct)
                X1 = stats(sess).region.(reg).event.(EventType).rwd(1).ch(chnl).lfp; % lfp matrix -> time x trial
                X2 = stats(sess).region.(reg).event.(EventType).rwd(2).ch(chnl).lfp; % lfp matrix -> time x trial
                X_merge = [X1,X2];
                
                for i=1:iterations
                    if mod(i,100) == 0
                        display(['---- iteration n. ',num2str(i)])
                    end
                    
                    % get permuted indexes and keep the same statistiscs for both sets of data rewarded/unrewarded trials 
                    perm = randperm(n_tot);
                    idx1 = perm(1:n1);
                    idx2 = perm(n1+1:end);
                    
                    % pseudo LFP
                    X1_pseudo = X_merge(:,idx1);
                    X2_pseudo = X_merge(:,idx2);
                    
                    
                    % %%%%%%%%%%%%%%
                    % ANALYSIS
                    %%%%%%%%%%%%%%%%%
                       
                    % % Pseudo PSD
                    [spec_1, f_psd] =  dmtspec(X1_pseudo',[N/sampling W],sampling,f_max,2,0.05,1);
                    [spec_2, f_psd] =  dmtspec(X2_pseudo',[N/sampling W],sampling,f_max,2,0.05,1);
                    
                    pseudo_stats(sess).region.(reg).event.(EventType).rwd(1).ch(chnl).iter(i).psd = spec_1;
                    pseudo_stats(sess).region.(reg).event.(EventType).rwd(2).ch(chnl).iter(i).psd = spec_2;

                    
                    %                 figure;
                    %                 plot(f_psd,log(abs(spec)))
                    %                 title(sprintf('rwd = %d',rwd))
                    %                 grid on
                    %
                    
                    % % Pseudo Spectrogram
                    [tf_spec_1, spec_f, ti] = tfspec(X1_pseudo',[Nt Wt], sampling, dnt, f_max, 2, 0.05, 1); % pseudo spectrogram reward = 1
                    [tf_spec_2, spec_f, ti] = tfspec(X2_pseudo',[Nt Wt], sampling, dnt, f_max, 2, 0.05, 1); % pseudo spectrogram reward = 2
                    
                    pseudo_stats(sess).region.(reg).event.(EventType).rwd(1).ch(chnl).iter(i).tf_spec = tf_spec_1;
                    pseudo_stats(sess).region.(reg).event.(EventType).rwd(2).ch(chnl).iter(i).tf_spec = tf_spec_2;
                    
                end
                            
                
                %                 figure;
                %                 tvimage(log(tf_spec_1));
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
        end % Event loop
    end % region loop
    
    % PSD and spectrogram parameters
    pseudo_stats(sess).prs.psd_s_rate = 1/sampling;
    pseudo_stats(sess).prs.ts = stats(sess).prs.ts;
    
    % frequency and time 
    pseudo_stats(sess).prs.psd_f = f_psd;
    pseudo_stats(sess).prs.f_spec = spec_f;
    pseudo_stats(sess).prs.t_spec = ti;
    
    % spectrum parameters
    pseudo_stats(sess).prs.psd_N = N;
    pseudo_stats(sess).prs.psd_W = W;
    
    % spectrogram parameters 
    pseudo_stats(sess).prs.tfspec_Nt = Nt;
    pseudo_stats(sess).prs.tfspec_Wt = Wt;
    pseudo_stats(sess).prs.tfspec_dnt = dnt;
    

end % session loop

end