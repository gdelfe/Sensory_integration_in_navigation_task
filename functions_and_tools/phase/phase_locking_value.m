% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PHASE LOCKING VALUES ACROSS TRIALS
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Phase Locking Value (PLV) is a measure of the consistency of the phase 
% difference between two signals. It's commonly used to quantify the 
% synchrony between different regions of the brain.

% The basic idea is to calculate the instantaneous phase of two signals,  
% and then to determine how these phases are related. If the phase 
% difference between the signals is consistent over time (i.e., the phases 
% are 'locked'), this indicates that the two signals are synchronizing in some way.

% To calculate PLV, one would generally follow these steps:

% 1. Apply a bandpass filter to each signal to isolate the frequency band 
%    of interest.
% 2. Use the Hilbert Transform to calculate the instantaneous phase of each 
%    filtered signal.
% 3. Calculate the difference in instantaneous phase between the two signals 
%   for each point in time.
% 4. Calculate the circular variance of these phase differences. This will 
%   give you a value between 0 and 1, with 0 indicating no phase locking and 
%   1 indicating perfect phase locking.
% 5. It's important to note that PLV is a measure of phase synchrony, not 
%   amplitude synchrony, and it's not influenced by the power of the signal.

% @ Gino Del Ferraro, NYU, May 2023

function [PLV] = phase_locking_value(low_cutoff,high_cutoff,Fs)

% Assuming you have a 3D matrix for each signal with dimensions (time x trials x channels)
% Example: y(time, trial, channel), z(time, trial, channel)

% Apply a bandpass filter to the signals to isolate the frequency band of interest
% For instance, we'll use 8-12 Hz (alpha band), assuming a sampling rate of 1000 Hz

% INPUT: 
% Fs = 1000; % sampling rate
% low_cutoff = 8; % low end of the frequency band of interest
% high_cutoff = 12; % high end of the frequency band of interest

% Create a second-order Butterworth filter
[b,a] = butter(2, [low_cutoff high_cutoff]/(Fs/2), 'bandpass');

% Get the number of trials
num_trials = size(y, 2);

% Initialize matrices to store instantaneous phase values for each trial
inst_phase_y_all_trials = zeros(size(y));
inst_phase_z_all_trials = zeros(size(z));

% Loop through trials
for trial = 1:num_trials
    % Apply the filter to the LFP data for the current trial
    filtered_y = filtfilt(b, a, y(:, trial));
    filtered_z = filtfilt(b, a, z(:, trial));

    % Use the Hilbert transform to calculate the analytic signal
    analytic_signal_y = hilbert(filtered_y);
    analytic_signal_z = hilbert(filtered_z);

    % Calculate the instantaneous phase of the analytic signal and store it in the matrices
    inst_phase_y_all_trials(:, trial) = angle(analytic_signal_y);
    inst_phase_z_all_trials(:, trial) = angle(analytic_signal_z);
end

% Compute the phase difference for each trial
phase_diff_all_trials = inst_phase_y_all_trials - inst_phase_z_all_trials;

% Compute the circular mean of the phase difference across trials
circ_mean_phase_diff = atan2(mean(sin(phase_diff_all_trials), 2), mean(cos(phase_diff_all_trials), 2));

% Calculate the Phase Locking Value (PLV)
PLV = abs(mean(exp(1i * phase_diff_all_trials), 2));

end 
