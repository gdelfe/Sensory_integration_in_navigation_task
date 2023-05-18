
function [coherencegram] = compute_coherencegram_regi_regj_R_NR(stats_den,EventType,sess,reg_i,reg_j,fk,tapers,dn)

coherencegram = [];

disp(['Session  ----',num2str(sess)])
disp(['EVENT  ----',num2str(EventType)])
disp(['INTRA-REGION COHERENCE ----'])

coherencegram = coherencegram_reg_i_reg_j_R_NR(coherencegram,stats_den,sess,EventType,reg_i,reg_j,fk,tapers,dn);



end % function end