
% clear all; close all;
dir_in = "E:\Output\GINO\eye_tracking\";

monkey = "Schro";
load(strcat(dir_in,sprintf('%s_eye_tracking.mat',monkey)));
sess_range = [1,2,3];

% remove NaN from beginning of the trial, make the trial start from first non-NaN value
eyeidx = remove_NaN_from_EyeIndex(eyeidx,sess_range); 
% Find common time window for all the trials and interpolate value of eye index
eyeinter = interpolate_eyeidx_values(eyeidx,sess_range);

plot_per_trial(eyeinter,sess_range);

eye_avg = average_eyeidx_per_session(eyeinter,sess_range);