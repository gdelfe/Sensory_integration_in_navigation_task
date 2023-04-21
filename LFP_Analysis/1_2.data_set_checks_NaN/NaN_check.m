clear all; close all;
% clearvars -except experiments

% load('E:\Output\GINO\experiments_lfp_Bruno_41_42_43_behv_lfps.mat')
% load('E:\Output\GINO\experiments_lfp_Quigley_185_188_207_behv_lfps.mat')
load('E:\Output\GINO\experiments_lfp_Vik_1_2_4_behv_lfps')


% Parameters
monkey = 'Vik';

Events = ["target","move","stop"];
sess_range = [1,2,3];
rwd_range = [1,2];

s = experiments.sessions(sess).lfps(ch).stats.trialtype.reward(rwd).events.(Events).all_freq;
ts = s.ts_lfp_align_ext;
sampling = round(length(s.ts_lfp_align_ext)/(abs(s.ts_lfp_align_ext(end)-s.ts_lfp_align_ext(1))));

% [start, stop] = NaN_idx(experiments,sess,rwd,EventType); % start and stop of time idx without 


% %%%%%%%%%%%%%%%%%%%
% Find NANs across sess, event, rwd
% %%%%%%%%%%%%%%%%%%%

% Find NaN across: sessions, events, rewards, channels, and trials
[ts_start, ts_stop] = NaN_ts_start_monkey(experiments,Events,sess_range,rwd_range) % find first time index with no NaN 
ts_stop = min(ts_stop,1.8); % end of time series to be analyzed 
nch = size(experiments.sessions(sess).lfps,2); % # of total channels

% NaN_values = find_NaN_values(experiments,ts_start,ts_stop); % find sess, event, and rwd with NaN after removal 

% Find start and stop time without NaN
% [d, start] = min(abs(ts - ts_start)); % find first time index (for this case) with no NaN across all channels and trials
% [d, stop] = min(abs(ts - ts_stop)); % find first time index with no NaN across all channels and trials
% 
% % Cut LFP and time series in order to have no NaN
% ts = ts(start:stop); % select time series without NaN
% X = s.lfp_align_ext(start:stop,:); % lfp matrix -> time x trial


% %%%%%%%%%%%%%%
% ANALYSIS 
%%%%%%%%%%%%%%%%%

% --------- LFP
X = s.lfp_align_ext;

% LFP matrix trial vs time
figure;
imagesc(isnan(X)')
colorbar
title(sprintf('sess = %d, rwd = %d, Event = %s',sess,rwd,"stop"))
[x_idx, xtlbl] = ts_x_labels(ts,0.1); % get xticks and xticklabels
set(gca, 'XTick',x_idx, 'XTickLabel',xtlbl)
xlabel('time (sec)')
ylabel('trials')
grid on

% LFP time series
figure;
trial = 1;
plot(ts,X(:,trial))
title(sprintf('LFP, sess = %d, rwd = %d, Event = %s',sess,rwd,Events))
xlabel('time (sec)')
ylabel('LFP')
grid on

% --------- PSD

% PSD parameters
W = 3; % frequency resolution (Hz)
f_max = 100; % max frequency for PSD (Hz)
N = length(ts); % time series length in points
[psd,f] =  dmtspec(X',[N/sampling W],sampling,f_max,2,0.05,1);

psd = stats(1).region.PPC.event.target.rwd(1).ch(65).psd;
f = stats(1).prs.psd_f;

figure;
plot(f,log(abs(psd)))
% title([sprintf("%s - %s",monkey,EventType),sprintf("PSD - Log(Power), sess = %d, rwd = %d, ch = %d",sess,rwd,ch)])
ylabel('Log(Power)')
xlabel('Frequency (Hz)')
grid on 

X1 = stats(1).region.MST.event.target.rwd(1).ch(20).lfp;
X2 = stats(1).region.PPC.event.target.rwd(1).ch(25).lfp;
ts = stats(1).prs.ts;

figure;
plot(ts,X1(1:end,1)'); hold on
plot(ts,X2(1:end,1)'); 
legend('MST','PPC')



% -------- Spectrogram

% Spectrogram parameters
Wt = 5; % freq resolution (Hz)
Nt = 0.5; % time resolution (sec)
dnt = 0.05; % step-size in time direction (sec)
k = floor(2*Wt*Nt - 1);
display(['tapers = ',num2str(k)]);


[tf_spec, f_spec, ti] = tfspec(X', [Nt Wt], sampling, dnt, f_max, 2, 0.05, 1);
size(tf_spec)


figure;
tvimage(log(tf_spec));
% colormap(bone)
colorbar
grid on
title([sprintf("%s - %s",monkey,Events),sprintf("Spectrogram - Log(Power), sess = %d, rwd = %d, ch = %d",sess,rwd,ch)])
[x_idx, xlbl, y_idx, ylbl] = tfspec_labels(ts,ti,f_spec,0.25,10); % generate labels
set(gca, 'XTick',x_idx, 'XTickLabel',xlbl)
set(gca, 'YTick',y_idx, 'YTickLabel',ylbl) 
ylabel('frequency (Hz)')
xlabel('time (sec)')
grid on


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT NaN across session, events, rewards, channels, trials 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NaN_plots(experiments,"stop",3,rwd_range)
% NaN_plots(experiments,["reward"],sess_range,[2]) % reward alignment with rwd = 2 is all NaN 







