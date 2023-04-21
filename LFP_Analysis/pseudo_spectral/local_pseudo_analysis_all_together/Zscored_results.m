% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function z-scores the test-statistics and applies cluster correction
% to it. The z-scoring and cluster correction is applied to the whole
% spectrogram, the psd, the freq vs time in theta and beta band
%
% INPUT: t_stats: structure with t-statistics; null_stats: structure with
% null statistics; Event list (target/move); p_th: p-value threshold
%
% OUPUT: Zscored_stats: structure with all the z-scored statistics for
% spec, psd, theta and beta freq. vs tims


function Zscored_stats = Zscored_results(t_stats,null_stats,Events,p_th)

z_th = abs(norminv((0.5*p_th))); % z-score threshold for two tails test
reg_names = fieldnames(t_stats(1).region); % brain regions name

Zscored_stats = {};
for region = 1:length(reg_names)
    reg = reg_names{region};
    
    for EventType = Events
           
           Zscored_stats = zscore_and_cluster_correction_for_variable(t_stats,null_stats,Zscored_stats,reg,EventType,'avg_spec','spec',z_th);
           Zscored_stats = zscore_and_cluster_correction_for_variable(t_stats,null_stats,Zscored_stats,reg,EventType,'avg_psd','psd',z_th);
           Zscored_stats = zscore_and_cluster_correction_for_variable(t_stats,null_stats,Zscored_stats,reg,EventType,'avg_theta_pow','theta',z_th);
           Zscored_stats = zscore_and_cluster_correction_for_variable(t_stats,null_stats,Zscored_stats,reg,EventType,'avg_beta_pow','beta',z_th);      
    
    end % event loop  
end % region loop 

end 