% Store coherencegram amplitude and phase results into structure, together
% with std
%

function [coherencegram] = store_coherencegram_results(coherencegram,sess,optic_flow,EventType,reg_i,reg_j,cohgram,f,tf,n_pairs)

% store results
% Abs
coherencegram(sess).(optic_flow).(EventType).reg_X.(reg_i).reg_Y.(reg_j).cohgram = mean(abs(cohgram),3);
coherencegram(sess).(optic_flow).(EventType).reg_X.(reg_i).reg_Y.(reg_j).cohgram_std = std(abs(cohgram),[],3);
% phase
coherencegram(sess).(optic_flow).(EventType).reg_X.(reg_i).reg_Y.(reg_j).angle = circ_mean(angle(cohgram),[],3);
coherencegram(sess).(optic_flow).(EventType).reg_X.(reg_i).reg_Y.(reg_j).angle_std = circ_std(angle(cohgram),[],3);
% coherencegram time and frequency ranges
coherencegram(sess).(optic_flow).(EventType).reg_X.(reg_i).reg_Y.(reg_j).nch_pairs = n_pairs;
coherencegram(sess).(optic_flow).(EventType).reg_X.(reg_i).reg_Y.(reg_j).f = f;
coherencegram(sess).(optic_flow).(EventType).reg_X.(reg_i).reg_Y.(reg_j).tf = tf;

end