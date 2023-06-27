
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
                pseudo_mu = sq(mean(pseudo_all.region.(reg).event.(EventType).(var),3));
                pseudo_avg.region.(reg).event.(EventType).(var) = pseudo_mu;
                
                % compute variance, v = 1/3 * (v1 + v2 + v3) + 1/3 * [(µ1-µ)^2 + (µ2-µ)^2 + (µ3-µ)^2]
                variance = mean(pseudo_all.region.(reg).event.(EventType).(err),3) + mean( (pseudo_all.region.(reg).event.(EventType).(var) - pseudo_mu).^2 ,3)  ;
                pseudo_avg.region.(reg).event.(EventType).(err) = sqrt(variance);
                
            end
            
        end
    end
end




