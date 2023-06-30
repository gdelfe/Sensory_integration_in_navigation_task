% clear all; close all;
% clearvars -except experiments

% %%%%%%%%%%%%%%%%
% PATHS
% %%%%%%%%%%%%%%%
monkey = "Vik";
% load('E:\Output\GINO\experiments_lfp_Vik_1_2_4_behv_lfps_cleaned.mat')
% load('E:\Output\GINO\stats\stats_Vik_v2.mat')
dir_out = 'E:\Output\GINO\stats\';

% %%%%%%%%%%%%%%%%
% Parameters
% %%%%%%%%%%%%%%%%

Events = ["reward"];
sess_range = [1,2,3];
rwd_range = [2];

% PSD
W = 3; % frequency resolution (Hz)
f_max = 100; % max frequency for PSD (Hz)

% Spectrogram
Wt = 5; % freq resolution (Hz)
Nt = 0.5; % time resolution (sec)
dnt = 0.05; % step-size in time direction (sec)
k = floor(2*Wt*Nt - 1);
display(['tapers = ',num2str(k)]);

nch = size(experiments.sessions(1).lfps,2); % # of total channels

% %%%%%%%%%%%%%%%%%%%
% REMOVE NANs
% %%%%%%%%%%%%%%%%%%%

% TARGET AND STOP --------------
% Find NaN across: sessions, events, rewards, channels, and trials
[ts_start, ts_stop] = NaN_ts_start_monkey(experiments,Events,sess_range,rwd_range); % find first time index with no NaN 
ts_start = max(ts_start,-0.9) % end of time series to be analyzed 
ts_stop = min(ts_stop,1.) % end of time series to be analyzed 

% NaN_values = find_NaN_values(experiments,ts_start,ts_stop); % find sess, event, and rwd with NaN after removal  


% compute spectral feature for the monkey
stats = spectral_features_monkey(experiments,Events,sess_range,rwd_range,ts_start,ts_stop,W,f_max,Nt,Wt,dnt);

% % MOVE --------------
% [ts_start, ts_stop] = NaN_ts_start_monkey(experiments,"stop",[1,2]) % find first time index with no NaN 
% ts_start = max(ts_start,-0.9); % end of time series to be analyzed 
% ts_stop = min(ts_stop,1.); % end of time series to be analyzed 
% stats_stop = spectral_features_monkey(experiments,["stop"],[1,2,3],[1,2],ts_start,ts_stop,W,f_max,Nt,Wt,dnt);
% 
% % REWARD --------------
% [ts_start, ts_stop] = NaN_ts_start_monkey(experiments,"reward",2) % find first time index with no NaN 
% ts_start = max(ts_start,-0.9); % end of time series to be analyzed 
% ts_stop = min(ts_stop,1.); % end of time series to be analyzed 
% stats_rwd = spectral_features_monkey(experiments,["reward"],[1,2,3],2,ts_start,ts_stop,W,f_max,Nt,Wt,dnt);


save(strcat(dir_out,sprintf('stats_%s_reward.mat',monkey)),'stats','-v7.3');

% save(strcat(dir_out,sprintf('stats_stop_%s.mat',monkey)),'stats_stop','-v7.3');
% save(strcat(dir_out,sprintf('stats_rwd_%s.mat',monkey)),'stats_rwd','-v7.3');

% load(strcat(dir_out,sprintf('stats_%s.mat',monkey))); 