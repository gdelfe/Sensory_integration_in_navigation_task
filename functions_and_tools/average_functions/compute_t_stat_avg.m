
% Compute avg and std for t_stats across monkey
%
% @ Gino Del Ferraro, June 2023, NYU

function t_stat_avg = compute_t_stat_avg(t_stats_all,Events)

var_names = ["avg_theta_t","avg_beta_t","avg_spec","avg_psd"];
err_names = ["err_theta_t","err_beta_t","err_spec","err_psd"];

reg_names = {'PPC','PFC','MST'};

for region = 1:length(reg_names)
    reg = reg_names{region}; % get region name
    
    for EventType = Events
        for r = 1:2
            for variable = 1:length(var_names)
                var = var_names{variable}; % get spectral variable name
                err = err_names{variable}; % get error variable name
                
                % compute means
                mu = sq(mean(t_stats_all.region.(reg).event.(EventType).rwd(r).(var),3));
                t_stat_avg.region.(reg).event.(EventType).rwd(r).(var) = mu;
                
                % compute variance, std, sem throughout error propagation
                % σ² = [ (σ1² + (μ1 - μ)²) + (σ2² + (μ2 - μ)²) + (σ3² + (μ3 - μ)²) ] / 3
                variance = mean(t_stats_all.region.(reg).event.(EventType).rwd(r).(err).^2,3) + mean( (t_stats_all.region.(reg).event.(EventType).rwd(r).(var) - mu).^2,3) ;
                t_stat_avg.region.(reg).event.(EventType).rwd(r).(err) = sqrt(variance);
                
            end
            
        end
    end
end




