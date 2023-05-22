

function [cohgram,tf,f,PLV_ch] = coherence_and_PLV_and_phase_diff(stats_den,PLV_ch,cohgram,sess,EventType,reg_i,reg_j,optic_flow,ch_i,ch_j,tapers,fs,dn,fk)

pad = 2;

X1 = stats_den(sess).region.(reg_i).event.(EventType).(optic_flow).ch(ch_i).lfp';
X2 = stats_den(sess).region.(reg_j).event.(EventType).(optic_flow).ch(ch_j).lfp';
% -- coherence calculation via coherency()
[coh,tf,f] = tfcoh(X1,X2,tapers,fs,dn,fk,pad,0.05,11);
cohgram = cat(3,cohgram,coh);

% Phase Locking Value and Phase difference for theta and beta range 
[PLV_theta,PLV_std_theta,phase_diff_theta,phase_diff_std_theta] = phase_locking_value(X1,X2,4,10,fs); % theta range [4-10] Hz
[PLV_beta,PLV_std_beta, phase_diff_beta,phase_diff_std_beta] = phase_locking_value(X1,X2,15,30,fs); % beta range [15-30] Hz

% store results to structures

% theta range 
PLV_ch.(optic_flow).PLV_theta = [PLV_ch.(optic_flow).PLV_theta,PLV_theta];
PLV_ch.(optic_flow).PLV_std_theta = [PLV_ch.(optic_flow).PLV_std_theta,PLV_std_theta];
PLV_ch.(optic_flow).phase_diff_theta = [PLV_ch.(optic_flow).phase_diff_theta,phase_diff_theta];
PLV_ch.(optic_flow).phase_diff_std_theta = [PLV_ch.(optic_flow).phase_diff_std_theta,phase_diff_std_theta];

% beta range
PLV_ch.(optic_flow).PLV_beta = [PLV_ch.(optic_flow).PLV_beta,PLV_beta];
PLV_ch.(optic_flow).PLV_std_beta = [PLV_ch.(optic_flow).PLV_std_beta,PLV_std_beta];
PLV_ch.(optic_flow).phase_diff_beta = [PLV_ch.(optic_flow).phase_diff_beta,phase_diff_beta];
PLV_ch.(optic_flow).phase_diff_std_beta = [PLV_ch.(optic_flow).phase_diff_std_beta,phase_diff_std_beta];


end 