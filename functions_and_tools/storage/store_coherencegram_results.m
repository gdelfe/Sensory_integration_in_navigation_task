% Store coherencegram amplitude and phase results into structure, together
% with std
%

function [coherencegram] = store_coherencegram_results(coherencegram,sess,optic_flow,cohgram,f,tf,n_pairs)

% store results
% Abs
coherencegram(sess).(optic_flow).cohgram = mean(abs(cohgram),3);
coherencegram(sess).(optic_flow).cohgram_std = std(abs(cohgram),[],3);
% phase
coherencegram(sess).(optic_flow).angle = circ_mean(angle(cohgram),[],3);
coherencegram(sess).(optic_flow).angle_std = circ_std(angle(cohgram),[],[],3);
% coherencegram time and frequency ranges
coherencegram(sess).(optic_flow).f = f; % frequency range in coherencegram
coherencegram(sess).(optic_flow).tf = tf; % time range in coherencegram 
coherencegram(sess).(optic_flow).nch_pairs = n_pairs; % number of channels pair


end