
% Concatenate results across monkeys for t-statistics
% @ Gino Del Ferraro, June 2023, NYU

function [t_stats_all] = concatenate_t_stats(t_stats_all,monkeys,Events,dir_in_test)

var_names = ["avg_theta_t","avg_beta_t","avg_spec","avg_psd"];
err_names = ["err_theta_t","err_beta_t","err_spec","err_psd"];
Nsess = 3;

N.err_psd = 1; % for the psd error 
N.err_spec = 1;

theta_band = [3.9,10];
beta_band = [15,30];

for monkey = monkeys
    
    load(strcat(dir_in_test,sprintf('test_stats_%s_all_events.mat',monkey))); % t_stats, test-statistics
    
    fs = t_stats.f_spec; % spectrogram frequency
    theta_idx = find(fs >= theta_band(1) & fs < theta_band(2)); % theta-range index
    beta_idx = find(fs >= beta_band(1) & fs < beta_band(2)); % beta-range index
    
    Ntheta = length(theta_idx);
    Nbeta = length(beta_idx);
    
    % number of frequency points used to average theta and beta 
    N.err_theta_t = Ntheta;
    N.err_beta_t = Nbeta;
    
    reg_names = fieldnames(t_stats(1).region);
    
    for region = 1:length(reg_names)
        reg = reg_names{region}; % get region name
        nch = t_stats(1).region.PPC.Nch;
        
        for EventType = Events
            for r = 1:2
                
                for variable = 1:length(var_names)
                    var = var_names{variable}; % get spectral variable name
                    t_stats_all.region.(reg).event.(EventType).rwd(r).(var)  = cat(3,t_stats_all.region.(reg).event.(EventType).rwd(r).(var),t_stats(1).region.(reg).event.(EventType).rwd(r).(var));
                end
                for error = 1:length(err_names)
                    err = err_names{error}; % get error variable name
                    standard_dev = (t_stats(1).region.(reg).event.(EventType).rwd(r).(err))*sqrt(Nsess*N.(err)*nch);  % SEM * sqrt(N) = std 
                    t_stats_all.region.(reg).event.(EventType).rwd(r).(err)  = cat(3,t_stats_all.region.(reg).event.(EventType).rwd(r).(err),standard_dev); % store std for all monkeys
                end
            end
        end
    end
end