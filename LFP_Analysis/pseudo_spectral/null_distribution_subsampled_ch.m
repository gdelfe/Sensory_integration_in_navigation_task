%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create the Null distribution. ----
% Compute permuted spectrum (PSD) and permuted spectrogram for each session, event, rwd, channel
% PSD and spectrogram for reward = 0/1 are computed by randomly swapping
% the lfp reward in 0 with those in 1.
%
% The different channels are merged together to form a unique null
% distribution for each brain region, and each separate event (e.g. target,
% move)
%
% INPUT: stats: structure with lfp, psd, spectrogram for each region/event
%
% OUTPUT: pseudo_stats: structure with permuted PSD difference and
% spectrogram difference between rwd = 0 and 1 - to be used to construct
% a Null Distribution, for each region and event
%
% @ Gino Del Ferraro, NYU, Jan 2023


function pseudo_stats = null_distribution_subsampled_ch(stats,Events,sess_range,f_max,permutations,ID_job)

pseudo_stats = {};

% parameters to compute pseudo psd
sampling = round(1/stats(1).prs.psd_s_rate); % sampling
N = stats(1).prs.psd_N; % time series length in points
W = stats(1).prs.psd_W; % frequency resolution for spectrum
% parameters to compute pseudo spectrogram
Nt = stats(1).prs.spec_Nt;
Wt = stats(1).prs.spec_Wt;
dnt = stats(1).prs.spec_dnt;
% frequency and time parameters
psd_f = stats(1).prs.psd_f;
t_spec = stats(1).prs.t_spec;
f_spec = stats(1).prs.f_spec;

ts = stats(1).prs.ts;

Nsess = length(sess_range); % number of sessions

reg_names = fieldnames(stats(1).region); % brain regions name

for sess = sess_range
    for region = 1:length(reg_names)
        reg = reg_names{region};
        display(['-- brain region: ',num2str(reg)])
        
        for EventType = Events
            display(['-- brain region: ',num2str(reg),' - Event: ',num2str(EventType)])
            
            nch = length(stats(1).region.(reg).event.(EventType).rwd(1).ch); % total number of channels, same for each session
            display(['-- brain region: ',num2str(reg),' - Event: ',num2str(EventType), ' - sess ',num2str(sess)])
            
            n1 = size(stats(sess).region.(reg).event.(EventType).rwd(1).ch(1).lfp,2); % number of incorrect trials (no reward)
            n2 = size(stats(sess).region.(reg).event.(EventType).rwd(2).ch(1).lfp,2); % number of correct trials (reward)
            
            Npseudo = min(n1,n2);  % use this to sub-sample the numb of trials
            Nmax = max(n1,n2); % use it to randomly pick trials in the biggest LFP matrix
            
            
            for chnl = 1:nch
                display(['-- brain region: ',num2str(reg),' - Event: ',num2str(EventType), ' - sess ',num2str(sess),' - channel ',num2str(chnl)])
                
                % Pseudo LFP -- Permuted lfp between rwd 1 and 2(incorrect/correct)
                X1 = stats(sess).region.(reg).event.(EventType).rwd(1).ch(chnl).lfp; % lfp matrix -> time x trial
                X2 = stats(sess).region.(reg).event.(EventType).rwd(2).ch(chnl).lfp; % lfp matrix -> time x trial
               
                if reg == "MST" % if recording in MST, it is recorded with linear probe and should be scaled up by a factor 1000 to have it in micro-Volt
                    X1 = X1*1e3; %
                    X2 = X2*1e3; %
                end

                
                ts_size = length(ts);
                
                x_size = min([size(X1,1),size(X2,1),ts_size]);
                N = x_size;
                % for time series that are not the same length (Vik and Schro, double check)
                X1 = X1(1:x_size,:);
                X2 = X2(1:x_size,:);
                
                % create matrices to store pseudo results across session, channels,and permutations
                log_psd_diff_mat_ch = zeros(permutations,length(psd_f)); % psd
                log_psd_pseudo_rwd_ch = zeros(permutations,length(psd_f)); % psd
                log_psd_pseudo_norwd_ch = zeros(permutations,length(psd_f)); % psd
                
                log_spec_diff_mat_ch = zeros(permutations,length(t_spec),length(f_spec)); % spectrogram
                log_spec_pseudo_rwd_ch = zeros(permutations,length(t_spec),length(f_spec)); % spectrogram
                log_spec_pseudo_norwd_ch = zeros(permutations,length(t_spec),length(f_spec)); % spectrogram
             	
                rng(ID_job,'twister');
                for i = 1:permutations
                    if mod(i,100) == 0
                        display(['---- iteration n. ',num2str(i)])
                    end
                    
                    % subsample the LFP with the majority of trials to the same amount of trials in the other LFP matrix
                    perm_pick = randperm(Nmax);
                    if n1 < n2
                        X_merge = [X1,X2(:,perm_pick(1:n1))]; % if X1 trials < X2 trials, pick n1 random trials from X2
                    elseif n2 <= n1
                        X_merge = [X1(:,perm_pick(1:n2)),X2]; % if X2 trials < X1 trials, pick n2 random trials from X1
                    end
                    
                    % get new indexes to generate pseudo LFPs
                    perm_trial = randperm(2*Npseudo);
                    idx1 = perm_trial(1:Npseudo);
                    idx2 = perm_trial(Npseudo+1:end);
                    
                    % pseudo LFP
                    X1_pseudo = X_merge(:,idx1);
                    X2_pseudo = X_merge(:,idx2);
                    
                    
                    % %%%%%%%%%%%%%%
                    % ANALYSIS - PSEUDO STATS
                    %%%%%%%%%%%%%%%%%
                    
                    % % Pseudo PSD
                    [spec_1, f_psd] =  dmtspec(X1_pseudo',[N/sampling W],sampling,f_max,2,0.05,1);
                    [spec_2, f_psd] =  dmtspec(X2_pseudo',[N/sampling W],sampling,f_max,2,0.05,1);
                   
                    % Pseudo Log(PSD) difference
                    log_psd_pseudo_rwd_ch(i,:) = log10(spec_1); % pseudo reward 
                    log_psd_pseudo_norwd_ch(i,:) = log10(spec_2); % pseudo no reward
                    log_psd_diff_mat_ch(i,:) = log10(spec_1) - log10(spec_2);
                    
                    %                 figure;
                    %                 plot(f_psd,log(abs(spec)))
                    %                 title(sprintf('rwd = %d',rwd))
                    %                 grid on
                    %
                    
                    % % Pseudo Spectrogram
                    [tf_spec_1, spec_f, ti] = tfspec(X1_pseudo',[Nt Wt], sampling, dnt, f_max, 2, 0.05, 1); % pseudo spectrogram reward = 1
                    [tf_spec_2, spec_f, ti] = tfspec(X2_pseudo',[Nt Wt], sampling, dnt, f_max, 2, 0.05, 1); % pseudo spectrogram reward = 2
                    
                    % Pseudo Spectrogram difference
                    log_spec_pseudo_rwd_ch(i,:,:) = log10(tf_spec_1);
                    log_spec_pseudo_norwd_ch(i,:,:) = log10(tf_spec_2);
                    log_tf_spec_diff_mat_ch(i,:,:) = log10(tf_spec_1) - log10(tf_spec_2);
                    
                end % permutation loop
                
                pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_psd_diff_mat = log_psd_diff_mat_ch ; % null distribution for the spectrum/psd by channel
                pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_psd_pseudo_rwd_mat = log_psd_pseudo_rwd_ch ;
                pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_psd_pseudo_norwd_mat = log_psd_pseudo_norwd_ch ;
                
                pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_tf_spec_diff_mat = log_tf_spec_diff_mat_ch ; % null distribution for the spectrum/psd by channel
                pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_spec_pseudo_rwd_mat = log_spec_pseudo_rwd_ch ;
                pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_spec_pseudo_norwd_mat = log_spec_pseudo_norwd_ch ;
                clear log_psd_diff_mat_ch log_tf_spec_diff_mat_ch log_psd_pseudo_rwd_ch log_psd_pseudo_norwd_ch log_spec_pseudo_rwd_ch log_spec_pseudo_norwd_ch
                %                 figure;
                %                 tvimage(spec_diff);
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
                %
                %                 figure;
                %                 plot(psd_diff)
                
            end % channel loop
        end % Event loop
    end % region loop
    
    % frequency and time parameters
    pseudo_stats(sess).prs.psd_f = f_psd;
    pseudo_stats(sess).prs.f_spec = spec_f;
    pseudo_stats(sess).prs.t_spec = ti;
    pseudo_stats(sess).prs.ts = ts;
end % session loop




end

