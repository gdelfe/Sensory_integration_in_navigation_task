

function Zscored_stats = zscore_for_difference_across_monkeys(t_stat_avg,pseudo_avg,Events,quantity,p_th)

quantity_avg = ['avg_',quantity];
null_avg = [quantity,'_log_diff_avg'];
null_std = [quantity,'_log_diff_std'];
quantity_clust_list = [quantity,'_diff_clust'];

reg_names = {'PPC','PFC','MST'};

% z-score threshold 
z_th = norminv(1 - p_th/2, 0, 1);

for region = 1:length(reg_names)
    reg = reg_names{region}; % get region name
    
    for EventType = Events
                
                % theta spectrogram difference - test statistics
                log_diff =  t_stat_avg.region.(reg).event.(EventType).rwd(1).(quantity_avg) - t_stat_avg.region.(reg).event.(EventType).rwd(2).(quantity_avg);
                log_diff_avg_null = pseudo_avg.region.(reg).event.(EventType).(null_avg); % null distribution avg
                log_diff_std_null = pseudo_avg.region.(reg).event.(EventType).(null_std); % null distribution std
                
                % z-score the log(spectrogram) difference between rwd = 0/1
                z_log_diff = (log_diff - log_diff_avg_null)./log_diff_std_null;
                Zscored_stats.region.(reg).event.(EventType).var.(quantity).z_log_diff = z_log_diff; % z-scored spectrogram
                
                % set to zero values above threshold (in abs value)
                z_log_diff(z_log_diff < z_th & z_log_diff > - z_th) = 0;
                Zscored_stats.region.(reg).event.(EventType).var.(quantity).z_log_diff_th = z_log_diff; % z-scored spectrogram thresholded pixel-wise
    end
end



end