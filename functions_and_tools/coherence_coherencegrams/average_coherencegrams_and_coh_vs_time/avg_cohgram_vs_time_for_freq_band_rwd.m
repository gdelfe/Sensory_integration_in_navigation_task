

function [coh_vs_time] = avg_cohgram_vs_time_for_freq_band_rwd(coh_avg_rwd,reg_names,Events,theta_band,beta_band,rand_ch)

fs = coh_avg_rwd.f;
theta_idx = find(fs >= theta_band(1) & fs < theta_band(2)); % theta-range index
beta_idx = find(fs >= beta_band(1) & fs < beta_band(2)); % beta-range index

for EventType = Events
    
    for region_i = 1:length(reg_names)
        reg_i = reg_names{region_i};
        
        for region_j = region_i:length(reg_names)
            reg_j = reg_names{region_j};
            
            for r = 1:2
                
                % coherence vs time
                coh_theta = coh_avg_rwd.rwd(r).(EventType).reg_X.(reg_i).reg_Y.(reg_j).cohgram(:,theta_idx)'; % coherencegram theta band
                coh_beta = coh_avg_rwd.rwd(r).(EventType).reg_X.(reg_i).reg_Y.(reg_j).cohgram(:,beta_idx)'; % coherencegram beta band
                
                coh_theta_mu = mean(coh_theta); % average cohgram across theta frequency
                coh_beta_mu = mean(coh_beta); % average cohgram across beta frequency
                
                std_theta = coh_avg_rwd.rwd(r).(EventType).reg_X.(reg_i).reg_Y.(reg_j).cohgram_std(:,theta_idx)'; % coherencegram theta band std
                std_beta = coh_avg_rwd.rwd(r).(EventType).reg_X.(reg_i).reg_Y.(reg_j).cohgram_std(:,beta_idx)'; % coherencegram beta band std
                
                std_theta_time = sqrt(mean(coh_theta.^2 + std_theta.^2) - coh_theta_mu.^2); % std vs time
                std_beta_time = sqrt(mean(coh_beta.^2 + std_beta.^2) - coh_beta_mu.^2);
                
                % phase vs time
                phase_theta = coh_avg_rwd.rwd(r).(EventType).reg_X.(reg_i).reg_Y.(reg_j).angle(:,theta_idx)'; % coherencegram theta band
                phase_beta = coh_avg_rwd.rwd(r).(EventType).reg_X.(reg_i).reg_Y.(reg_j).angle(:,beta_idx)'; % coherencegram beta band
                
                phase_theta_mu = circ_mean(phase_theta); % average cohgram across theta frequency
                phase_beta_mu = circ_mean(phase_beta); % average cohgram across beta frequency
                
                %             std_theta_phase = coh_avg_den.(den).reg_X.(reg_i).reg_Y.(reg_j).angle_std(:,theta_idx)'; % coherencegram theta band std
                %             std_beta_phase = coh_avg_den.(den).reg_X.(reg_i).reg_Y.(reg_j).angle_std(:,beta_idx)'; % coherencegram beta band std
                %
                %             std_theta_time = mean(phase_theta.^2 + std_theta_phase.^2) - phase_theta_mu.^2; % std vs time
                %             std_beta_time = mean(phase_beta.^2 + std_beta_phase.^2) - phase_beta_mu.^2;
                
                
                coh_vs_time.rwd(r).(EventType).reg_X.(reg_i).reg_Y.(reg_j).coh_theta = coh_theta_mu;
                coh_vs_time.rwd(r).(EventType).reg_X.(reg_i).reg_Y.(reg_j).coh_theta_std = std_theta_time;
                coh_vs_time.rwd(r).(EventType).reg_X.(reg_i).reg_Y.(reg_j).coh_theta_sem = std_theta_time/sqrt(rand_ch*(rand_ch-1)/2*3*length(theta_idx)); % # SEM: divide std by # of channel pairs, # of sessions, # of frequency rows

                coh_vs_time.rwd(r).(EventType).reg_X.(reg_i).reg_Y.(reg_j).coh_beta = coh_beta_mu;
                coh_vs_time.rwd(r).(EventType).reg_X.(reg_i).reg_Y.(reg_j).coh_beta_std = std_beta_time;
                coh_vs_time.rwd(r).(EventType).reg_X.(reg_i).reg_Y.(reg_j).coh_beta_sem = std_beta_time/sqrt(rand_ch*(rand_ch-1)/2*3*length(beta_idx)); % # SEM: divide std by # of channel pairs, # of sessions, # of frequency rows
                
                coh_vs_time.rwd(r).(EventType).reg_X.(reg_i).reg_Y.(reg_j).angle_theta = phase_theta_mu;
                coh_vs_time.rwd(r).(EventType).reg_X.(reg_i).reg_Y.(reg_j).angle_beta = phase_beta_mu;
                
            end % density loop
        end % region j loop
    end % region i loop
    
end % event type loop 

reg_i = reg_names{1};
coh_vs_time.f = coh_avg_rwd.f;
coh_vs_time.tf = coh_avg_rwd.tf;


end