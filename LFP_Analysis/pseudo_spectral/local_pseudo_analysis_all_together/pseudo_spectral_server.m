
function [] = pseudo_spectral_server(monkey,N_iter,ID_job)


% %%%%%%%%%%%%%%%%
% PATHS
% %%%%%%%%%%%%%%%
addpath(genpath('/scratch/gd2112/GINO_CODES/MATLAB'));

dir_out = '/scratch/gd2112/GINO_CODES/Output/';
dir_in_stats = strcat(dir_out,'stats/');
dir_in_test = strcat(dir_out,'test_stats/');
dir_out_null = strcat(dir_out,sprintf('pseudo_stats/%s/',monkey));

% LOAD STRUCTURES 
load(strcat(dir_in_stats,sprintf('stats_%s.mat',monkey)));
load(strcat(dir_in_test,sprintf('test_stats_%s.mat',monkey)));

% %%%%%%%%%%%%%%%%
% Parameters
% %%%%%%%%%%%%%%%%

iterations = str2double(N_iter);
ID_job = str2double(ID_job)
f_max = 100; % max frequency for PSD (Hz)
sess_range = [1,2];
Events = ["target"];
filename_null = sprintf('%s_iter_%d_ID_%d',monkey,iterations,ID_job);
ts = t_stats.ts;
ti = t_stats.ti;
spec_f = t_stats.f_spec;

theta_band = [3.9,10];
beta_band = [15,30];

fs = t_stats.f_spec; % spectrogram frequency
theta_idx = find(fs >= theta_band(1) & fs < theta_band(2)); % theta-range index
beta_idx = find(fs >= beta_band(1) & fs < beta_band(2)); % beta-range index

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ANALYSIS 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% create null distribution data set

disp(['Generating the null distribution....'])
pseudo_stats = null_distribution_subsampled_ch(stats,Events,sess_range,f_max,iterations); 


disp(['Saving psuedo stats ...'])
save(strcat(dir_out_null,sprintf('pseudo_stats_%s.mat',filename_null)),'pseudo_stats','-v7.3');

end

        
        
