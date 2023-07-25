
% Merge coherence, PLV, phase difference results across sessions for a
% given monkey. Compute mean and std of such quantities across sessions.
% 
% Plot: A. PLV and coherence for high/low density, reward/no-reward for each
%       monkey
%       B. PLV averaged across conditions for each monkey
%


clear all; close all;

% input and output directories
dir_in = 'E:\Output\GINO\cohgram_all_channels\';
dir_in_phase = 'E:\Output\GINO\phase_PLV\';
% dir_in_phase = 'E:\Output\GINO\coherence\phase_PLV\';

monkey = "Schro";

reg_i = "MST";
reg_j = "PPC"
EventType = "target";
sess_range = [1,2,3];


dir_in = dir_in + monkey + '\' + EventType + '\';
dir_in_phase = dir_in_phase + monkey + '\' + EventType + '\';
dir_out_main = 'E:\Output\GINO\Figures\PLV_phase_diff';
dir_out_PLV_data_avg = 'E:\Output\GINO\phase_PLV\averages\';
dir_out_coh_data_avg = 'E:\Output\GINO\coherence\avg_by_area\';

dir_fig = 'E:\Output\GINO\Figures\PLV_phase_diff\all_together\';

dir_out_PLV_data_avg = strcat(dir_out_PLV_data_avg, reg_i + '_' + reg_j + '\');
if ~exist(dir_out_PLV_data_avg, 'dir')
    mkdir(dir_out_PLV_data_avg)
end

dir_out_coh_data_avg = strcat(dir_out_coh_data_avg, reg_i + '_' + reg_j + '\');
if ~exist(dir_out_coh_data_avg, 'dir')
    mkdir(dir_out_coh_data_avg)
end

dir_fig = strcat(dir_fig, reg_i + '_' + reg_j + '\');
if ~exist(dir_fig, 'dir')
    mkdir(dir_fig)
end

PLV_tot = {};
cohgram_tot =[];


% Load data across sessions for one monkey
for sess = sess_range
    
    load(strcat(dir_in,sprintf('coherencegram_%s_sess_%d_event_%s_%s_%s.mat',monkey,sess,EventType,reg_i,reg_j)));
    load(strcat(dir_in_phase,sprintf('PLV_phase_%s_sess_%d_event_%s_%s_%s.mat',monkey,sess,EventType,reg_i,reg_j)));
    PLV_tot{sess} = PLV_sess;
    cohgram_tot{sess} = coherencegram;
    clear coherencegram
    
end


% Perform averages per each session separately 
for sess = sess_range
    
% Means across sessions
[cohgram_mean, PLV_mean] = PLV_and_cohgram_mean_std_across_sessions(PLV_tot,cohgram_tot,sess);
PLV_sess(sess) = PLV_mean;

end 


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HIGH DENSITY REWARD AND NO REWARD, LOW DENSITY REWARD AND NO REWARD
% TOGETHER
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ts = PLV_mean.high_den_NR.ts;
ts = ts(1:end-1);

PLV_avg = average_PLV_per_session(PLV_sess,ts,sess_range,monkey)




