clear all; close all;

% %%%%%%%%%%%%%%%
% PARAMETERS
% %%%%%%%%%%%%%%

p_th = 0.05; % p-value threshold
S = 5000;
Events = ["target","stop"];

dir_main = 'E:\Output\GINO\';
dir_out_zscore = strcat(dir_main,sprintf('zscored_stats\\p_th_%.2f\\',p_th));

temp_max = 0;
temp_min = 0;

for monkey = ["Bruno","Quigley","Schro","Vik"]
    
    load(strcat(dir_out_zscore,sprintf('zscored_stats_%s_p_th_%.2f_iter_%d_diff_rwd_norwd.mat',monkey,p_th,S)));
   
    reg_names = fieldnames(Zscored_stats(1).region); % brain regions name
    
    for region = 1:length(reg_names)
        reg = reg_names{region};
        
        for EventType = Events
            
            
            temp_max = max(temp_max,max(max(Zscored_stats.region.(reg).event.(EventType).var.spec.z_log_diff)));
            temp_min = min(temp_min,min(min(Zscored_stats.region.(reg).event.(EventType).var.spec.z_log_diff)));
            
        end
    end
end

