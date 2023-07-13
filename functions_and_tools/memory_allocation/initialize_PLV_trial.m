% Initialize the fields of PLV_trial as structures in order to make dynamic
% allocation of memory - the structure stores PLV for each trial, averaged
% across channels.
%
% @ GDF, NYU, July 2023

function [PLV_trial] = initialize_PLV_trial(PLV_trial,sess_range)

for sess = sess_range
    % hight density - reward
    PLV_trial(sess).high_den_R.PLV_theta_trial = {};
    PLV_trial(sess).high_den_R.PLV_beta_trial = {};
    
    % low density - reward
    PLV_trial(sess).low_den_R.PLV_theta_trial = {};
    PLV_trial(sess).low_den_R.PLV_beta_trial = {};
    
    % hight density - no reward
    PLV_trial(sess).high_den_NR.PLV_theta_trial = {};
    PLV_trial(sess).high_den_NR.PLV_beta_trial = {};
    
    % low density - no reward
    PLV_trial(sess).low_den_NR.PLV_theta_trial = {};
    PLV_trial(sess).low_den_NR.phase_diff_std_theta = {};
    
end
end