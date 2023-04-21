% clear all; close all;

% %%%%%%%%%%%%%%%%
% PATHS
% %%%%%%%%%%%%%%%
monkey = "Bruno";
load('E:\Output\GINO\experiments_lfp_Bruno_41_42_43_behv_lfps.mat')
dir_out = 'E:\Output\GINO\stats\';

% %%%%%%%%%%%%%%%%
% Parameters
% %%%%%%%%%%%%%%%%

Events = ["target","move","stop","reward"];

% PSD
W = 3; % frequency resolution (Hz)
f_max = 100; % max frequency for PSD (Hz)


% Spectrogram
Wt = 5; % freq resolution (Hz)
Nt = 0.5; % time resolution (sec)
dnt = 0.01; % step-size in time direction (sec)
k = floor(2*Wt*Nt - 1);
display(['tapers = ',num2str(k)]);

% -------------- This part is not needed for now
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Split channels by brain region
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% regions = cell(1,nch);
% for ch = 1:nch
%     regions{ch} = experiments.sessions(sess).lfps(ch).brain_area; % get the brain region for each channel
% end
% % find channel index for each region
% PFC = find(strcmp(regions,'PFC'));
% PPC = find(strcmp(regions,'PPC'));
% MST = find(strcmp(regions,'MST'));
% 
% reg_idx = {PFC,PPC,MST}; % assign channel index for each area
% reg_name = {"PFC","PPC","MST"}; % assign channel index for each area

% ----------------------------------------------------------

% Find NaN across: sessions, events, rewards, channels, and trials
[ts_start, ts_stop] = NaN_ts_start_monkey(experiments); % find first time index with no NaN across all channels and trials
ts_stop = min(ts_stop,1.8); % end of time series to be analyzed 

stats = {}; % structure to store data psd and spectrum
nch = size(experiments.sessions(sess).lfps,2); % # of total channels

for sess = 1:3
    for EventType = Events
        for rwd = 1:2
%             display(['---- sess ',num2str(sess),', Event: ',num2str(EventType),', reward = ',num2str(rwd)])

            ts = experiments.sessions(sess).lfps(1).stats.trialtype.reward(rwd).events.(EventType).all_freq.ts_lfp_align_ext;
            [d, start] = min(abs(ts - ts_start)); % find first time index with no NaN across all channels and trials 
            [d, stop] = min(abs(ts - ts_stop)); % find first time index with no NaN across all channels and trials
            ts = ts(start:stop); % select time series without NaN
            
            s_rate = round(length(ts)/(ts(end)-ts(1))); % sampling rate (Hz)
            N = length(ts); % time series length in points

            for chnl = 1:nch
                
                s = experiments.sessions(sess).lfps(chnl).stats.trialtype.reward(rwd).events.(EventType).all_freq; % lfp structure
                
                X = s.lfp_align_ext(start:stop,:); % lfp matrix -> time x trial
                %                 sum(sum(isnan(X)))
                if(sum(sum(isnan(X)))) > 0
                    display(['---- sess ',num2str(sess),', Event: ',num2str(EventType),', reward = ',num2str(rwd)])
                    display(['channel, ',num2str(chnl)])
                    size(X,1)*size(X,2)
                    sum(sum(isnan(X)))
                    
                end
                %                 assert(sum(sum(isnan(X)))==0,'LFP matrix contains NaN values')
                area  = experiments.sessions(sess).lfps(ch).brain_area; % get brain area
                % %%%%%%%%%%%%%%
                % ANALYSIS
                %%%%%%%%%%%%%%%%%
                
                
%                 % % PSD
%                 [spec, f_psd] =  dmtspec(X',[N/s_rate W],s_rate,f_max,2,0.05,1);
%                 
%                 stats(sess).region.(area).(EventType).reward(rwd).ch(chnl).psd = spec;
%    
%                 
%                 figure;
%                 plot(f_psd,log(abs(spec)))
%                 title(sprintf('rwd = %d',rwd))
%                 grid on
%                 
                % % Spectrogram 
%                 [tf_spec, f_spec, ti] = tfspec(X', [Nt Wt], s_rate, dnt, f_max, 2, 0.05, 1);
%                 size(tf_spec)
%             
%                 stats(sess).region.(area).(EventType).reward(rwd).ch(chnl).tf_spec = tf_spec;
%                 
%                 figure;
%                 tvimage(log(tf_spec));
%                 % colormap(bone)
%                 colorbar
%                 grid on
%                 title([sprintf("%s",EventType),sprintf("W = %d, Nt = %.1f, dn = %.2f, rwd = %d, ch = %d",W,Nt,dnt,rwd,channel)]);
%                 [x_idx, xlbl, y_idx, ylbl] = tfspec_labels(ts,ti,f_spec,0.25,10);
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
%     stats(sess).prs.psd_s_rate = s_rate; 
%     stats(sess).prs.psd_ts = ts;
%     
%     stats(sess).prs.psd_N = N;
%     stats(sess).prs.psd_W = W;
%     stats(sess).prs.psd_f = f_psd;
%     
%     stats(sess).prs.tfpspec_Nt = Nt;
%     stats(sess).prs.tfspec_Wt = Wt;
%     stats(sess).prs.tfspec_dnt = dnt;
%     stats(sess).prs.tfspec_f = f_spec;
%     stats(sess).prs.tfspec_t = ti;
%     
end % session loop

save(strcat(dir_out,sprintf('stats_%s.mat',monkey)),'stats','-v7.3');
% load(strcat(dir_out,sprintf('stats_%s.mat',monkey))); 







