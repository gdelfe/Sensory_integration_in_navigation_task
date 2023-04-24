% Compute the inter- and intra-regional coherence phase as a function of
% time for the high/low density trials
%
% @ Gino Del Ferraro, NYU, April 2023

function [] = plot_phase_vs_time_density(coh_vs_time_den,monkey,Events,dir_out_fig_time,tsi)

dir_fig_monkey_time = fullfile(dir_out_fig_time + monkey + '\density\phase\')
if ~exist(strcat(dir_fig_monkey_time), 'dir')
    mkdir(dir_fig_monkey_time)
end

D = 0.07; % shift for the yaxis plot
reg_names = fieldnames(coh_vs_time_den.high_den.target.reg_X); % brain regions name

for EventType = Events
    
    for region_i = 1:length(reg_names)
        reg_i = reg_names{region_i};
        
        for region_j = region_i:length(reg_names)
            reg_j = reg_names{region_j};
            
            % High vs Low optic flow density - coherence vs time THETA
            fig = figure; hold all
            phase_h = coh_vs_time_den.high_den.(EventType).reg_X.(reg_i).reg_Y.(reg_j).angle_theta;
            plot(tsi,phase_h,'LineWidth',2,'color',"#ff6600");
            
            phase_L = coh_vs_time_den.low_den.(EventType).reg_X.(reg_i).reg_Y.(reg_j).angle_theta;
            plot(tsi,phase_L,'LineWidth',2,'color',"#0033cc");
            
            
            title(sprintf("Monkey: %s, %s, THETA phase, High/Low optic flow, %s - %s",monkey,EventType,reg_i,reg_j),'FontSize',12)
            ylabel('Phase')
            xlabel('time (sec)')
            set(gcf, 'Position',  [100, 500, 700, 500])
            legend('high density','low density')
            grid on
            ylim([-pi,pi])
            yticks([-pi -pi/2 0 pi/2 pi])
            yticklabels({'-\pi','-\pi/2','0','\pi/2','\pi'})
            fname = strcat(dir_fig_monkey_time,sprintf('density_phase_%s_%s_coh_vs_time_THETA_%s_%s.png',monkey,EventType,reg_i,reg_j));
            saveas(fig,fname)
            
            
            % High vs Low optic flow density - coherence vs time BETA
            fig = figure; hold all
            phase_h = coh_vs_time_den.high_den.(EventType).reg_X.(reg_i).reg_Y.(reg_j).angle_beta;
            plot(tsi,phase_h,'LineWidth',2,'color',"#ff6600");
            
            phase_L = coh_vs_time_den.low_den.(EventType).reg_X.(reg_i).reg_Y.(reg_j).angle_beta;
            plot(tsi,phase_L,'LineWidth',2,'color',"#0033cc");
            
            
            title(sprintf("Monkey: %s, %s, BETA phase, High/Low optic flow, %s - %s",monkey,EventType,reg_i,reg_j),'FontSize',12)
            ylabel('Phase')
            xlabel('time (sec)')
            set(gcf, 'Position',  [100, 500, 700, 500])
            legend('high density','low density')
            grid on
            ylim([-pi,pi])
            yticks([-pi -pi/2 0 pi/2 pi])
            yticklabels({'-\pi','-\pi/2','0','\pi/2','\pi'})
            fname = strcat(dir_fig_monkey_time,sprintf('density_phase_%s_%s_coh_vs_time_BETA_%s_%s.png',monkey,EventType,reg_i,reg_j));
            saveas(fig,fname)           
            
        end
    end
    
end

end