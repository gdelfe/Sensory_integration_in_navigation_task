% Load structure experiment and extra data about eyetracking at the trial
% level: compute eye-tracking index per trial
%
% OUTPUT: save results into eyeidx structure. Eye-index for each session,
% per trials, for both: 1. all trials, 2. rewarded trials, 3. no-rwd trials
%
% @ Gino Del Ferraro, July 2023



addpath(genpath('C:\Users\gd2112\Documents\Navigation_task'))
addpath(genpath('C:\Users\gd2112\Documents\MATLAB'))
addpath(genpath('C:\Users\gd2112\Documents\LFP_firefly'))

clear all; close all;
dir_out = "E:\Output\GINO\eye_tracking\";
% clearvars -except experiments

% %%%%%%%%%%%%%%%%
% PATHS
% %%%%%%%%%%%%%%%
monkey = "Bruno";
load('E:\Output\GINO\experiments_lfp_Bruno_41_42_43_behv_lfps.mat')
% load('E:\Output\GINO\experiments_lfp_Quigley_185_188_207_behv_lfps.mat')
% load('E:\Output\GINO\experiments_lfp_Schro_86_107_113_behv_lfps.mat')
% load('E:\Output\GINO\experiments_lfp_Vik_1_2_4_behv_lfps.mat')

sess_range = [1,2,3];

[eyeidx] = eye_index(experiments,sess_range);


for sess = sess_range
    
    % get indexes of trials with target always OFF
    [~,~,ind_rwd1,ind_rwd2] = get_indx_trials_target_OFF(experiments,sess);
    
    % no reward trials
    eyeNOrwd = eyeidx(sess).trial(ind_rwd1);
    eyeidx(sess).rwd(1).trial = eyeNOrwd;
    % reward trials
    eyerwd = eyeidx(sess).trial(ind_rwd2);
    eyeidx(sess).rwd(2).trial = eyerwd;
    
end

 

save(strcat(dir_out,sprintf('%s_eye_tracking.mat',monkey)),'eyeidx','-v7.3');

