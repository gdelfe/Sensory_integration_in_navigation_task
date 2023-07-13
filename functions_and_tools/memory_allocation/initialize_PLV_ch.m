% Initialize the fields of PLV_ch as structures in order to make dynamic
% allocation of memory
%
% @ GDF, NYU, April 2023

function [PLV_ch] = initialize_PLV_ch(PLV_ch)

% hight density - reward
PLV_ch.high_den_R.PLV_theta = {}; PLV_ch.high_den_R.PLV_std_theta = {}; PLV_ch.high_den_R.PLV_theta_trial = {};
PLV_ch.high_den_R.phase_diff_theta = {}; PLV_ch.high_den_R.phase_diff_std_theta = {};

PLV_ch.high_den_R.PLV_beta = {}; PLV_ch.high_den_R.PLV_std_beta = {}; PLV_ch.high_den_R.PLV_beta_trial = {};
PLV_ch.high_den_R.phase_diff_beta = {}; PLV_ch.high_den_R.phase_diff_std_beta = {};

% low density - reward
PLV_ch.low_den_R.PLV_theta = {}; PLV_ch.low_den_R.PLV_std_theta = {}; PLV_ch.low_den_R.PLV_theta_trial = {};
PLV_ch.low_den_R.phase_diff_theta = {}; PLV_ch.low_den_R.phase_diff_std_theta = {};

PLV_ch.low_den_R.PLV_beta = {}; PLV_ch.low_den_R.PLV_std_beta = {}; PLV_ch.low_den_R.PLV_beta_trial = {};
PLV_ch.low_den_R.phase_diff_beta = {}; PLV_ch.low_den_R.phase_diff_std_beta = {};

% hight density - no reward
PLV_ch.high_den_NR.PLV_theta = {}; PLV_ch.high_den_NR.PLV_std_theta = {}; PLV_ch.high_den_NR.PLV_theta_trial = {};
PLV_ch.high_den_NR.phase_diff_theta = {}; PLV_ch.high_den_NR.phase_diff_std_theta = {};

PLV_ch.high_den_NR.PLV_beta = {}; PLV_ch.high_den_NR.PLV_std_beta = {}; PLV_ch.high_den_NR.PLV_beta_trial = {};
PLV_ch.high_den_NR.phase_diff_beta = {}; PLV_ch.high_den_NR.phase_diff_std_beta = {};

% low density - no reward
PLV_ch.low_den_NR.PLV_theta = {}; PLV_ch.low_den_NR.PLV_std_theta = {}; PLV_ch.low_den_NR.PLV_theta_trial = {};
PLV_ch.low_den_NR.phase_diff_theta = {}; PLV_ch.low_den_NR.phase_diff_std_theta = {};

PLV_ch.low_den_NR.PLV_beta = {}; PLV_ch.low_den_NR.PLV_std_beta = {}; PLV_ch.low_den_NR.PLV_beta_trial = {};
PLV_ch.low_den_NR.phase_diff_beta = {}; PLV_ch.low_den_NR.phase_diff_std_beta = {};

end