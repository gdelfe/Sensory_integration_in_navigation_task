% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function computes the average statistics: avg theta/beta frequency
% vs time, avg spectrogram, and their errors - where avg is across
% sessions, channels, region by region
%
% INPUT: stats structure
%
% OUTPUT: t_stat structure (which contains the test-statistics for the
% average values
%
% @ Gino Del Ferraro, NYU, Jan 2023



function t_stats = average_stats(stats,Events,theta_band,beta_band)


fs = stats(1).prs.f_spec; % spectrogram frequency
% frequency ranges in Hz
theta = [3.9,10];
beta = [15,30];

theta_idx = find(fs >= theta_band(1) & fs < theta_band(2)); % theta-range index
beta_idx = find(fs >= beta_band(1) & fs < beta_band(2)); % beta-range index

Nsess = 3; % number of sessions
Ntheta = length(theta_idx); % how many frequency values in theta frequency band
Nbeta = length(beta_idx); % how many frequency values in beta frequency band

reg_names = fieldnames(stats(1).region);

for region = 1:length(reg_names)
 
    for EventType = Events
        for r = 1:2
            
            reg = reg_names{region}; % get region name
            nch = length(stats(1).region.(reg).event.(EventType).rwd(r).ch); % same for each session, event, reward
            
            theta_tf = []; beta_tf = []; % arrays to store theta and beta power for a given region
            theta_tf_var = []; beta_tf_var = [];
            spec = []; log_psd = [];
            
            for sess = 1:3
                for chnl = 1:nch
                    theta_tf = [theta_tf, mean(log10(stats(sess).region.(reg).event.(EventType).rwd(r).ch(chnl).tf_spec(:,theta_idx)),2)]; % mean across theta band
                    theta_tf_var = [theta_tf_var, var(log10(stats(sess).region.(reg).event.(EventType).rwd(r).ch(chnl).tf_spec(:,theta_idx)),[],2)]; % variance
                    beta_tf = [beta_tf, mean(log10(stats(sess).region.(reg).event.(EventType).rwd(r).ch(chnl).tf_spec(:,beta_idx)),2)]; % mean across beta band
                    beta_tf_var = [beta_tf_var, var(log10(stats(sess).region.(reg).event.(EventType).rwd(r).ch(chnl).tf_spec(:,beta_idx)),[],2)]; % variance
                    
                    spec = cat(3,spec,stats(sess).region.(reg).event.(EventType).rwd(r).ch(chnl).tf_spec); % concatenate spectrogram in 3D
                    
                    log_psd = [log_psd; log10(stats(sess).region.(reg).event.(EventType).rwd(r).ch(chnl).psd)];
                end
            end % sess loop
            
            % POWER vs TIME
            % theta band
            t_stats.region.(reg).event.(EventType).rwd(r).avg_theta_t = mean((theta_tf),2)'; % mean across channel and sessions
            t_stats.region.(reg).event.(EventType).rwd(r).err_theta_t = (sqrt(mean((theta_tf_var),2))/sqrt(nch*Ntheta*Nsess))'; % SEM across channels and theta band
            % beta band
            t_stats.region.(reg).event.(EventType).rwd(r).avg_beta_t = mean((beta_tf),2)'; % mean across channel and sessions
            t_stats.region.(reg).event.(EventType).rwd(r).err_beta_t = (sqrt(mean((beta_tf_var),2))/sqrt(nch*Nbeta*Nsess))'; % SEM across channels and theta band
            % spectrogram
            t_stats.region.(reg).event.(EventType).rwd(r).avg_spec = mean(log10(spec),3); % mean across channel and sessions
            t_stats.region.(reg).event.(EventType).rwd(r).err_spec = std(log10(spec),[],3)/sqrt(nch*Nsess);
            
            % PSD 
            t_stats.region.(reg).event.(EventType).rwd(r).avg_psd = mean(log_psd); % mean across channel and sessions
            t_stats.region.(reg).event.(EventType).rwd(r).err_psd = std(log_psd)/sqrt(nch*Nsess);
            
            
        end % reward loop
    end % event loop
    
    t_stats.region.(reg).Nch = nch;
    
    
end % region loop 

% time and frequency values for plotting
t_stats.ts = stats(1).prs.ts;
t_stats.f_psd = stats(1).prs.psd_f;
t_stats.ti = stats(1).prs.t_spec;
t_stats.f_spec = stats(1).prs.f_spec;

end