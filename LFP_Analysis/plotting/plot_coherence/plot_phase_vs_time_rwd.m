% Compute the inter- and intra-regional coherence phase as a function of
% time for the reward/no-reward trials
%
% @ Gino Del Ferraro, NYU, April 2023


function [] = plot_phase_vs_time_rwd(coh_vs_time_den,monkey,Events,dir_out_fig_time,tsi)

dir_fig_monkey_time = fullfile(dir_out_fig_time + monkey + '\density\phase\')
if ~exist(strcat(dir_fig_monkey_time), 'dir')
    mkdir(dir_fig_monkey_time)
end

D = 0.07; % shift for the yaxis plot
reg_names = fieldnames(coh_vs_time_den.rwd(1).target.reg_X); % brain regions name

for EventType = Events
    
    for region_i = 1:length(reg_names)
        reg_i = reg_names{region_i};
        
        for region_j = region_i:length(reg_names)
            reg_j = reg_names{region_j};
            
            % High vs Low optic flow density - coherence vs time THETA
            fig = figure; hold all
            phase_1 = coh_vs_time_den.rwd(1).(EventType).reg_X.(reg_i).reg_Y.(reg_j).angle_theta;
            plot(tsi,phase_1,'LineWidth',2,'color',"#ff6600");
            
            phase_2 = coh_vs_time_den.rwd(2).(EventType).reg_X.(reg_i).reg_Y.(reg_j).angle_theta;
            plot(tsi,phase_2,'LineWidth',2,'color',"#0033cc");
            
            
            title(sprintf("Monkey: %s, %s, THETA phase, no-rwd/rwd, %s - %s",monkey,EventType,reg_i,reg_j),'FontSize',12)
            ylabel('Phase')
            xlabel('time (sec)')
            set(gcf, 'Position',  [100, 500, 700, 500])
            legend('no-reward','reward')
            grid on
            ylim([-pi,pi])
            yticks([-pi -pi/2 0 pi/2 pi])
            yticklabels({'-\pi','-\pi/2','0','\pi/2','\pi'})
            fname = strcat(dir_fig_monkey_time,sprintf('rwd_phase_%s_%s_coh_vs_time_THETA_%s_%s.png',monkey,EventType,reg_i,reg_j));
            saveas(fig,fname)
            
            
            % High vs Low optic flow density - coherence vs time BETA
            fig = figure; hold all
            phase_1 = coh_vs_time_den.rwd(1).(EventType).reg_X.(reg_i).reg_Y.(reg_j).angle_beta;
            plot(tsi,phase_1,'LineWidth',2,'color',"#ff6600");
            
            phase_2 = coh_vs_time_den.rwd(2).(EventType).reg_X.(reg_i).reg_Y.(reg_j).angle_beta;
            plot(tsi,phase_2,'LineWidth',2,'color',"#0033cc");
            
            
            title(sprintf("Monkey: %s, %s, BETA phase, no-rwd/rwd, %s - %s",monkey,EventType,reg_i,reg_j),'FontSize',12)
            ylabel('Phase')
            xlabel('time (sec)')
            set(gcf, 'Position',  [100, 500, 700, 500])
            legend('no-reward','reward')
            grid on
            ylim([-pi,pi])
            yticks([-pi -pi/2 0 pi/2 pi])
            yticklabels({'-\pi','-\pi/2','0','\pi/2','\pi'})
            fname = strcat(dir_fig_monkey_time,sprintf('rwd_phase_%s_%s_coh_vs_time_BETA_%s_%s.png',monkey,EventType,reg_i,reg_j));
            saveas(fig,fname)           
            
        end
    end
    
end

end