% 
%
%

function thresholded_maps(pseudo_stats,Events,p_th)

psd_f = pseudo_stats.prs.psd_f;
f_spec = pseudo_stats.prs.f_spec;
t_spec = pseudo_stats.prs.t_spec;

z_th = norminv((0.5*p_th)) % z-score threshold for two tails test

reg_names = fieldnames(stats(1).region);

for region = 1:length(reg_names)
    reg = reg_names{region};
    Niter = size(pseudo_stats.region.(reg).event.(EventType).psd_diff,1); % number of permuted data in total 
    for EventType = Events
        
        % averages and std of the null distributions 
        pseudo_psd_avg = mean(pseudo_stats.region.PPC.event.target.psd_diff);
        pseudo_psd_std = std(pseudo_stats.region.PPC.event.target.psd_diff);
        pseudo_spec_avg = squeeze(mean(pseudo_stats.region.PPC.event.target.tf_spec_diff,1));
        pseudo_spec_std = squeeze(std(pseudo_stats.region.PPC.event.target.tf_spec_diff));
        
        z_psd_diff_mat = zeros(Niter,length(psd_f));
        z_spec_diff_mat = zeros(Niter,length(t_spec),length(f_spec));
        
        % Z-score pseudo data (null-distribution) for the cluster correction analysis
        for i = 1:Niter
            
            z_psd_diff_mat(i,:) = (pseudo_stats.region.PPC.event.target.psd_diff(i,:)- pseudo_psd_avg)/pseudo_psd_std;
            z_spec_diff_mat(i,:,:) = (squeeze(pseudo_stats.region.PPC.event.target.tf_spec_diff(i,:,:)) - pseudo_spec_avg)/pseudo_spec_std;
        
        end % iterations loop
        
        
        
    end % event loop
end % region loop 

end 