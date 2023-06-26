
% create function pseudo_avg_all to store pseudo stats results across
% monkeys

function [pseudo_avg_all] = create_pseudo_stats_all(pseudo_avg,Events)


reg_names = {'PPC','PFC','MST'};
var_names = fieldnames(pseudo_avg.region.PPC.event.target);

for region = 1:length(reg_names)
    reg = reg_names{region}; % get region name
    
    for EventType = Events
        for r = 1:2
            
            
            for variable = 1:length(var_names)
                var = var_names{variable}; % get spectral variable name
                
                pseudo_avg_all.region.(reg).event.(EventType).(var) = [];
            end
        end
    end
end

end
