% Plot coherence vs time for the high/low density optic flow for 
% two different frequency band: theta and beta frequencies.
%
% @ Gino Del Ferraro, NYU, April 2023.

function [] = plot_angle_vs_time_density_combined(coh_vs_time_den,monkey,Events,dir_out_fig,tsi)

dir_fig_monkey_time = fullfile(dir_out_fig + monkey + '\combined\density\phase\')
if ~exist(strcat(dir_fig_monkey_time), 'dir')
    mkdir(dir_fig_monkey_time)
end

D = 0.03; % shift for the yaxis plot
reg_names = fieldnames(coh_vs_time_den.high_den.target.reg_X); % brain regions name

for EventType = Events
    
    for region_i = 1:length(reg_names)
        reg_i = reg_names{region_i};
        
        for region_j = region_i:length(reg_names)
            reg_j = reg_names{region_j};
            
            % High vs Low optic flow density - coherence vs time THETA
            fig = figure; hold all
            coh_h_T = coh_vs_time_den.high_den.(EventType).reg_X.(reg_i).reg_Y.(reg_j).angle_theta;
            plot(tsi,coh_h_T,"linewidth",1,'Color',"#008000");
            
            coh_L_T = coh_vs_time_den.low_den.(EventType).reg_X.(reg_i).reg_Y.(reg_j).angle_theta;
            plot(tsi,coh_L_T,"linewidth",1,'Color',"#00ff00");
            
             % High vs Low optic flow density - coherence vs time BETA
            coh_h_B = coh_vs_time_den.high_den.(EventType).reg_X.(reg_i).reg_Y.(reg_j).angle_beta;
            plot(tsi,coh_h_B,"linewidth",1,'Color',"#e65c00");
            
            coh_L_B = coh_vs_time_den.low_den.(EventType).reg_X.(reg_i).reg_Y.(reg_j).angle_beta;
            plot(tsi,coh_L_B,"linewidth",1,'Color',"#ffc299");
            
            if EventType == 'target'
                xline(-0.3,'--',{'Target ON'},'HandleVisibility','off');
                xline(0,'--r',{'Target OFF'},'HandleVisibility','off');
            elseif EventType == 'stop'
                xline(0,'--',{'Move STOP'},'HandleVisibility','off');
            end
            
            title(sprintf("Phase: %s, %s, High/Low optic flow, %s - %s",monkey,EventType,reg_i,reg_j),'FontSize',12)
            ylabel('Coherence')
            xlabel('time (sec)')
            set(gcf, 'Position',  [100, 500, 700, 500])
            legend('HD Theta','LD Theta','HD Beta','LD Beta')
%             grid on
            ylim([-2*pi/3,2*pi/3])
            yticks([-pi -pi/2 0 pi/2 pi])
            yticklabels({'-\pi','-\pi/2','0','\pi/2','\pi'})    
            
            fname = strcat(dir_fig_monkey_time,sprintf('density_%s_%s_THETA_BETA_phase_vs_time_%s_%s.pdf',monkey,EventType,reg_i,reg_j));
            saveas(fig,fname)
            
            
           
            
        end
    end
    
end

end