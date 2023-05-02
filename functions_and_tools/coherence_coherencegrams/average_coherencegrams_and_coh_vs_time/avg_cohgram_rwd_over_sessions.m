
% Compute averages of coherencegram across different sessions, for each
% pair of regions, for each reward = 0/1. Compute
% also the relative std for these averages by propagating the errors.
%
% Gino Del Ferraro, NYU, April 2023

function [coh_avg] = avg_cohgram_rwd_over_sessions(coh,reg_names,Events,rand_ch)

for EventType = Events
    
    for region_i = 1:length(reg_names)
        reg_i = reg_names{region_i};
        
        for region_j = region_i:length(reg_names)
            reg_j = reg_names{region_j};
            
            for r = 1:2 % reward range
                % allocation
                coh_tot = []; coh_tot_std = [];
                angle_tot = []; angle_tot_std = [];
                for sess = 1:3
                    
                    cohgram = coh(sess).rwd(r).(EventType).reg_X.(reg_i).reg_Y.(reg_j).cohgram; % coherencegram across pairs of channels
                    coh_std = coh(sess).rwd(r).(EventType).reg_X.(reg_i).reg_Y.(reg_j).cohgram_std; % std across pairs of channels
                    coh_tot = cat(3,coh_tot,cohgram); % to compute the average coherencegram across session
                    coh_tot_std = cat(3,coh_tot_std, coh_std.^2 + cohgram.^2); % to compute the std coherencegram across session
                    
                    angle = coh(sess).rwd(r).(EventType).reg_X.(reg_i).reg_Y.(reg_j).angle;
%                     angle_std = coh(sess).rwd(r).reg_X.(reg_i).reg_Y.(reg_j).angle_std;
                    angle_tot = cat(3,angle_tot, angle); % to compute the average coherencegram across session
%                     angle_tot_std = cat(3,angle_tot_std, angle_std.^2 + angle.^2); % to compute the std coherencegram across session
                    
                    
                end % session loop
                
                % averages across session
                coh_avg.rwd(r).(EventType).reg_X.(reg_i).reg_Y.(reg_j).cohgram = mean(coh_tot,3);
                coh_avg.rwd(r).(EventType).reg_X.(reg_i).reg_Y.(reg_j).angle = circ_mean(angle_tot,[],3);
                
                % std across sessions
                coh_avg.rwd(r).(EventType).reg_X.(reg_i).reg_Y.(reg_j).cohgram_std = sqrt(mean(coh_tot_std,3) - mean(coh_tot,3).^2);
                coh_avg.rwd(r).(EventType).reg_X.(reg_i).reg_Y.(reg_j).cohgram_sem = sqrt((mean(coh_tot_std,3) - mean(coh_tot,3).^2))/sqrt(rand_ch*(rand_ch-1)/2*3);

%                 coh_avg.rwd(r).reg_X.(EventType).(reg_i).reg_Y.(reg_j).angle_std = mean(angle_tot_std,3) - mean(angle_tot,3).^2;
                
            end % rwd loop
        end % region j loop
    end % region i loop
    
    
    
    reg_i = reg_names{1};
    coh_avg.f = coh(1).rwd(1).(EventType).reg_X.(reg_i).reg_Y.(reg_i).f;
    coh_avg.tf = coh(1).rwd(1).(EventType).reg_X.(reg_i).reg_Y.(reg_i).tf;
    
end

end