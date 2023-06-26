

% Concatenate results across monkeys for t-statistics 

function [t_stats_all,f] = concatenate_t_stats(t_stats_all,monkeys,Events,dir_in_test)

for monkey = monkeys
    
    load(strcat(dir_in_test,sprintf('test_stats_%s_all_events.mat',monkey))); % test-statistics, t_stats
    
    reg_names = fieldnames(t_stats(1).region);
    
    reg_all = {};
    for region = 1:length(reg_names)
        reg = reg_names{region}; % get region name
        
        for EventType = Events
            for r = 1:2
                
                var_names = fieldnames(t_stats(1).region.(reg).event.(EventType).rwd(r));
                for variable = 1:length(var_names)
                    var = var_names{variable}; % get spectral variable name
                    t_stats_all.region.(reg).event.(EventType).rwd(r).(var)  = cat(3,t_stats_all.region.(reg).event.(EventType).rwd(r).(var),t_stats(1).region.(reg).event.(EventType).rwd(r).(var));
                end
            end
        end
    end
    f = t_stats.f_psd;
end