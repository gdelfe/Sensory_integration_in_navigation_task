
% Compute avg and std for t_stats across monkey
%
% @ Gino Del Ferraro, June 2023, NYU

function t_stats_avg = compute_t_stat_avg(t_stats_all,Events)

var_names = ["avg_theta_t","avg_beta_t","avg_spec","avg_psd"];
err_names = ["err_theta_t","err_beta_t","err_spec","err_psd"];

reg_names = {'PPC','PFC','MST'};

Nsess = 3;

theta_band = [3.9,10];
beta_band = [15,30];

fs = t_stats_all.f_spec; % spectrogram frequency
theta_idx = find(fs >= theta_band(1) & fs < theta_band(2)); % theta-range index
beta_idx = find(fs >= beta_band(1) & fs < beta_band(2)); % beta-range index

Ntheta = length(theta_idx);
Nbeta = length(beta_idx);

% number of frequency points used to average theta and beta
N.err_theta_t = Ntheta;
N.err_beta_t = Nbeta;
N.err_psd = 1; % for the psd error
N.err_spec = 1;


for region = 1:length(reg_names)
    reg = reg_names{region}; % get region name
    nch = t_stats_all.region.(reg).Nch;
    for EventType = Events
        for r = 1:2
            for variable = 1:length(var_names)
                var = var_names{variable}; % get spectral variable name
                err = err_names{variable}; % get error variable name
                
                Nm = size(t_stats_all.region.(reg).event.(EventType).rwd(r).(var),3); % number of monkeys
                % compute means
                mu = sq(mean(t_stats_all.region.(reg).event.(EventType).rwd(r).(var),3));
                t_stats_avg.region.(reg).event.(EventType).rwd(r).(var) = mu;
                
                % compute variance, std, sem throughout error propagation
                % σ² = [ (σ1² + (μ1 - μ)²) + (σ2² + (μ2 - μ)²) + (σ3² + (μ3 - μ)²) ] / 3
                variance = mean(t_stats_all.region.(reg).event.(EventType).rwd(r).(err).^2,3) + mean( (t_stats_all.region.(reg).event.(EventType).rwd(r).(var) - mu).^2,3) ;
                t_stats_avg.region.(reg).event.(EventType).rwd(r).(err) = sqrt(variance)/sqrt(Nsess*N.(err)*nch*Nm);
                
            end
            
        end
    end
    t_stats_avg.region.(reg).Nch = nch;
end

t_stats_avg.ti =  t_stats_all.ti;
t_stats_avg.ts =  t_stats_all.ts;
t_stats_avg.f_psd =  t_stats_all.f_psd;
t_stats_avg.f_spec =  t_stats_all.f_spec;


end




