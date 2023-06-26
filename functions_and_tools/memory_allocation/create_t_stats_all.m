
function [t_stats_all] = create_t_stats_all(Events)


reg_names = {'PPC','PFC','MST'};
var_names = ["avg_theta_t","err_theta_t","avg_beta_t","err_beta_t","avg_spec","err_spec","avg_psd","err_psd"];

for region = 1:length(reg_names)
    reg = reg_names{region}; % get region name
    
    for EventType = Events
        for r = 1:2
            
            for variable = 1:length(var_names)
                var = var_names{variable}; % get spectral variable name
                
                t_stats_all.region.(reg).event.(EventType).rwd(r).(var) = [];
            end
        end
    end
end

end
