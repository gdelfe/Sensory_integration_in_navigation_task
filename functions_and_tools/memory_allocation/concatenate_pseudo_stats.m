

% Concatenate results across monkeys for t-statistics 

function pseudo_all = concatenate_pseudo_stats(pseudo_all,monkeys,Events,S,dir_in_null)

for monkey = monkeys
    
    load(strcat(dir_in_null,sprintf('pseudo_avg_%s_tot_iter_%d_diff_rwd_norwd.mat',monkey,S))); % pseudo distribution averages, pseudo_avg
    
    reg_names = fieldnames(pseudo_avg.region);
    
    reg_all = {};
    for region = 1:length(reg_names)
        reg = reg_names{region}; % get region name
        
        for EventType = Events                
                var_names = fieldnames(pseudo_avg.region.(reg).event.(EventType));
                for variable = 1:length(var_names)
                    var = var_names{variable}; % get spectral variable name
                    pseudo_all.region.(reg).event.(EventType).(var)  = cat(3,pseudo_all.region.(reg).event.(EventType).(var), pseudo_avg.region.(reg).event.(EventType).(var));
                end
        end
    end
end