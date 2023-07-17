
function PLV_avg_OF = PLV_avg_across_conditions(PLV_mean)

theta = []; theta_std = [];
beta = []; beta_std = [];

fields = fieldnames(PLV_mean);

for field = 1:length(fields)
    optic_flow = fields{field};

    theta = [theta, PLV_mean.(optic_flow).PLV_theta];
    theta_sem = [theta_std, PLV_mean.(optic_flow).PLV_std_theta/sqrt(PLV_mean.(optic_flow).nch_pairs*PLV_mean.(optic_flow).num_trials)];
    beta = [beta, PLV_mean.(optic_flow).PLV_beta];
    beta_sem = [beta_std, PLV_mean.(optic_flow).PLV_std_beta/sqrt(PLV_mean.(optic_flow).nch_pairs*PLV_mean.(optic_flow).num_trials)];
    
end

ts = PLV_mean.high_den_R.ts;
ts = ts(1:end-1);
    
PLV_avg_OF.theta = mean(theta,2);
PLV_avg_OF.theta_sem = sum(theta_sem,2);
PLV_avg_OF.beta = mean(beta,2);
PLV_avg_OF.beta_sem = sum(beta_sem,2);

PLV_avg_OF.ts = ts;


end