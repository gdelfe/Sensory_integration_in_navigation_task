

function [PLV_sess] = average_PLV_and_phase_across_channels(PLV_sess,PLV_ch,optic_flow,n_pairs,ts)

% % THETA RANGE 
% PLV
% average across channels 
PLV_sess.(optic_flow).PLV_theta = mean(cell2mat(PLV_ch.(optic_flow).PLV_theta),2);
% std across channels: error propagation for the error across trials, and
% across channels: std^2 = (\sum (std^2)_ch_i + \mu_ch_i) - mu_ch 
PLV_sess.(optic_flow).PLV_std_theta = mean((cell2mat(PLV_ch.(optic_flow).PLV_std_theta).^2) + (cell2mat(PLV_ch.(optic_flow).PLV_theta).^2),2) - mean(cell2mat(PLV_ch.(optic_flow).PLV_theta),2).^2;

% PHASE DIFFERENCE
PLV_sess.(optic_flow).phase_diff_theta = circ_mean(cell2mat(PLV_ch.(optic_flow).phase_diff_theta),[],2);
PLV_sess.(optic_flow).phase_diff_std_theta = circ_mean((cell2mat(PLV_ch.(optic_flow).phase_diff_std_theta).^2) + (cell2mat(PLV_ch.(optic_flow).phase_diff_theta).^2),[],2) - circ_mean(cell2mat(PLV_ch.(optic_flow).phase_diff_theta),[],2).^2;

% % BETA RANGE 
% PLV
PLV_sess.(optic_flow).PLV_beta = mean(cell2mat(PLV_ch.(optic_flow).PLV_beta),2);
PLV_sess.(optic_flow).PLV_std_beta = mean((cell2mat(PLV_ch.(optic_flow).PLV_std_beta).^2) + (cell2mat(PLV_ch.(optic_flow).PLV_beta).^2),2) - mean(cell2mat(PLV_ch.(optic_flow).PLV_beta),2).^2;
% PHASE DIFFERENCE
PLV_sess.(optic_flow).phase_diff_beta = circ_mean(cell2mat(PLV_ch.(optic_flow).phase_diff_beta),[],2);
PLV_sess.(optic_flow).phase_diff_std_beta = circ_mean((cell2mat(PLV_ch.(optic_flow).phase_diff_std_beta).^2) + (cell2mat(PLV_ch.(optic_flow).phase_diff_beta).^2),[],2) - circ_mean(cell2mat(PLV_ch.(optic_flow).phase_diff_beta),[],2).^2;

% other parameters 
PLV_sess.(optic_flow).ts = ts; % time variable 
PLV_sess.(optic_flow).nch_pairs = n_pairs; % number of channel pairs

end