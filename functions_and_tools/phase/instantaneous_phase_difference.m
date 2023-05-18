%%% INSTANTENEOUS PHASE DIFFERENCE BETWEEN BRAIN REGIONS %%%

% To compute the average instantaneous phase difference between two LFP signals 
% across multiple trials, you can follow these steps. This example assumes that 
% the data has already be preprocessed (e.g., filtered it, removed artifacts, etc.):

% 1. Calculate the instantaneous phase difference for each trial.
% 2. Average the instantaneous phase differences across trials.
% 
% @ Gino Del Ferraro, NYU, May 2023

function instantaneous_phase_difference(Fs,low_cutoff,high_cutoff)

% Assuming you have a 3D matrix for each signal with dimensions (time x trials x channels)
% Example: y(time, trial, channel), z(time, trial, channel)

% Apply a bandpass filter to the signals to isolate the frequency band of interest
% For instance, we'll use 8-12 Hz (alpha band), assuming a sampling rate of 1000 Hz

% Fs = 1000; % sampling rate
% low_cutoff = 8; % low end of the frequency band of interest
% high_cutoff = 12; % high end of the frequency band of interest

% Create a second-order Butterworth filter
[b,a] = butter(2, [low_cutoff high_cutoff]/(Fs/2), 'bandpass');

% Get the number of trials
num_trials = size(y, 2);

% Initialize a matrix to store instantaneous phase differences for each trial
inst_phase_diff_all_trials = zeros(size(y));

% Loop through trials
for trial = 1:num_trials
    % Apply the filter to the LFP data for the current trial
    filtered_y = filtfilt(b, a, y(:, trial));
    filtered_z = filtfilt(b, a, z(:, trial));

    % Use the Hilbert transform to calculate the analytic signal
    analytic_signal_y = hilbert(filtered_y);
    analytic_signal_z = hilbert(filtered_z);

    % Calculate the instantaneous phase of the analytic signal
    inst_phase_y = angle(analytic_signal_y);
    inst_phase_z = angle(analytic_signal_z);

    % Compute the instantaneous phase difference and store it in the matrix
    inst_phase_diff_all_trials(:, trial) = inst_phase_y - inst_phase_z;
end

% Compute the circular mean of the instantaneous phase difference across all trials
% This is done by taking the atan2 of the sum of sines and cosines of the phase differences
avg_inst_phase_diff = atan2(mean(sin(inst_phase_diff_all_trials), 2), mean(cos(inst_phase_diff_all_trials), 2));

% If you want the phase difference in degrees instead of radians:
avg_inst_phase_diff_deg = rad2deg(avg_inst_phase_diff);



end 