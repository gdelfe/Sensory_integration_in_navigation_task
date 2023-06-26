
% Compute avg and std for pseudo distribution across monkey

function pseudo_avg = compute_pseudo_avg(pseudo_all,Events)

var_names = ["spec_log_diff_avg"];
err_names = ["spec_log_diff_std"];

reg_names = {'PPC','PFC','MST'};


reg_all = {};
for region = 1:length(reg_names)
    reg = reg_names{region}; % get region name
    
    for EventType = Events
            for variable = 1:length(var_names)
                var = var_names{variable}; % get spectral variable name
                err = err_names{variable}; % get error name
                % compute means
                pseudo_all.region.(reg).event.(EventType).(var) = sq(mean(t_stats_all.region.(reg).event.(EventType).rwd(r).(var),3));
                Nm = size(t_stats_all.region.(reg).event.(EventType).rwd(r).(var),3); % Number of monkeys
                
                % compute variance, std, sem throughout error propagation
                variance = sum(t_stats_all.region.(reg).event.(EventType).rwd(r).(err),3)/(Nm^2);
                t_stat_avg.region.(reg).event.(EventType).rwd(r).(err) = sqrt(variance);
                
            end
            
        end
    end
end




