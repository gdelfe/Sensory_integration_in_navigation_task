
function PLV_avg = average_PLV_per_session(PLV_sess,ts,sess_range,monkey)

for sess = sess_range 
    
% THETA %%%%%%%%%%%%%%%%%%%%%%%
PLV_avg_theta_HDNR = PLV_sess(sess).high_den_NR.PLV_theta';
PLV_sem_theta_HDNR = (PLV_sess(sess).high_den_NR.PLV_std_theta/sqrt((PLV_sess(sess).high_den_NR.nch_pairs*PLV_sess(sess).high_den_NR.num_trials))).';

PLV_avg_theta_LDNR = PLV_sess(sess).low_den_NR.PLV_theta';
PLV_sem_theta_LDNR = (PLV_sess(sess).low_den_NR.PLV_std_theta/sqrt((PLV_sess(sess).low_den_NR.nch_pairs*PLV_sess(sess).low_den_NR.num_trials))).';

PLV_avg_theta_HDR = PLV_sess(sess).high_den_R.PLV_theta';
PLV_sem_theta_HDR = (PLV_sess(sess).high_den_R.PLV_std_theta/sqrt((PLV_sess(sess).high_den_R.nch_pairs*PLV_sess(sess).high_den_R.num_trials))).';

PLV_avg_theta_LDR = PLV_sess(sess).low_den_R.PLV_theta';
PLV_sem_theta_LDR = (PLV_sess(sess).low_den_R.PLV_std_theta/sqrt((PLV_sess(sess).low_den_R.nch_pairs*PLV_sess(sess).low_den_R.num_trials))).';

if monkey == "Vik"
    PLV_all.theta = [2*PLV_avg_theta_HDNR;2*PLV_avg_theta_HDR];
    PLV_all.theta_sem = [PLV_sem_theta_HDNR;PLV_sem_theta_HDR];
else
    PLV_all.theta = [PLV_avg_theta_HDNR;PLV_avg_theta_LDNR;PLV_avg_theta_HDR;PLV_avg_theta_LDR];
    PLV_all.theta_sem = [PLV_sem_theta_HDNR;PLV_sem_theta_LDNR;PLV_sem_theta_HDR;PLV_sem_theta_LDR];
end



% BETA %%%%%%%%%%%%%%%%%%%%%%%

PLV_avg_beta_HDNR = PLV_sess(sess).high_den_NR.PLV_beta';
PLV_sem_beta_HDNR = (PLV_sess(sess).high_den_NR.PLV_std_beta/sqrt((PLV_sess(sess).high_den_NR.nch_pairs*PLV_sess(sess).high_den_NR.num_trials))).';

PLV_avg_beta_LDNR = PLV_sess(sess).low_den_NR.PLV_beta';
PLV_sem_beta_LDNR = (PLV_sess(sess).low_den_NR.PLV_std_beta/sqrt((PLV_sess(sess).low_den_NR.nch_pairs*PLV_sess(sess).low_den_NR.num_trials))).';

PLV_avg_beta_HDR = PLV_sess(sess).high_den_R.PLV_beta';
PLV_sem_beta_HDR = (PLV_sess(sess).high_den_R.PLV_std_beta/sqrt((PLV_sess(sess).high_den_R.nch_pairs*PLV_sess(sess).high_den_R.num_trials))).';

PLV_avg_beta_LDR = PLV_sess(sess).low_den_R.PLV_beta';
PLV_sem_beta_LDR = (PLV_sess(sess).low_den_R.PLV_std_beta/sqrt((PLV_sess(sess).low_den_R.nch_pairs*PLV_sess(sess).low_den_R.num_trials))).';

if monkey == "Vik"
    PLV_all.beta = [PLV_avg_beta_HDNR;PLV_avg_beta_HDR];
    PLV_all.beta_sem = [2*PLV_sem_beta_HDNR;2*PLV_sem_beta_HDR];
else
    PLV_all.beta = [PLV_avg_beta_HDNR;PLV_avg_beta_LDNR;PLV_avg_beta_HDR;PLV_avg_beta_LDR];
    PLV_all.beta_sem = [PLV_sem_beta_HDNR;PLV_sem_beta_LDNR;PLV_sem_beta_HDR;PLV_sem_beta_LDR];
end



avg_theta = mean(PLV_all.theta);
sem_theta = sum(PLV_all.theta_sem);
avg_beta = mean(PLV_all.beta);
sem_beta = sum(PLV_all.beta_sem);

PLV_avg(sess).theta_avg = avg_theta;
PLV_avg(sess).theta_sem = sem_theta;
PLV_avg(sess).beta_avg = avg_beta;
PLV_avg(sess).beta_sem = sem_beta;
PLV_avg(sess).ts = ts;

end 

end 