% Plot coherence vs time for the high/low density optic flow for 
% two different frequency band: theta and beta frequencies.
%
% @ Gino Del Ferraro, NYU, April 2023.

function [] = plot_coherence_vs_time_rwd_combined(coh_vs_time_den,monkey,Events,dir_out_fig,tsi)

dir_fig_monkey_time = fullfile(dir_out_fig + monkey + '\combined\reward\')
if ~exist(strcat(dir_fig_monkey_time), 'dir')
    mkdir(dir_fig_monkey_time)
end

D = 0.03; % shift for the yaxis plot
reg_names = fieldnames(coh_vs_time_den.rwd(1).target.reg_X); % brain regions name

for EventType = Events
    
    for region_i = 1:length(reg_names)
        reg_i = reg_names{region_i};
        
        for region_j = region_i:length(reg_names)
            reg_j = reg_names{region_j};
            
            % Reward/No-reward density - coherence vs time THETA
            fig = figure; hold all
            coh_1_T = coh_vs_time_den.rwd(1).(EventType).reg_X.(reg_i).reg_Y.(reg_j).coh_theta;
            sem_1_T = coh_vs_time_den.rwd(1).(EventType).reg_X.(reg_i).reg_Y.(reg_j).coh_theta_sem;
            ci95 = sem_1_T.*norminv(0.975);
            shadedErrorBar(tsi,coh_1_T,ci95,'lineprops',{'color',"#008000"},'patchSaturation',0.4);
            
            coh_2_T = coh_vs_time_den.rwd(2).(EventType).reg_X.(reg_i).reg_Y.(reg_j).coh_theta;
            sem_2_T = coh_vs_time_den.rwd(2).(EventType).reg_X.(reg_i).reg_Y.(reg_j).coh_theta_sem;
            ci95 = sem_2_T.*norminv(0.975);
            shadedErrorBar(tsi,coh_2_T,ci95,'lineprops',{'color',"#00ff00"},'patchSaturation',0.4);
            
             % High vs Low optic flow density - coherence vs time BETA
            coh_1_B = coh_vs_time_den.rwd(1).(EventType).reg_X.(reg_i).reg_Y.(reg_j).coh_beta;
            sem_1_B = coh_vs_time_den.rwd(1).(EventType).reg_X.(reg_i).reg_Y.(reg_j).coh_beta_sem;
            ci95 = sem_1_B.*norminv(0.975);
            shadedErrorBar(tsi,coh_1_B,ci95,'lineprops',{'color',"#e65c00"},'patchSaturation',0.5);
            
            coh_2_B = coh_vs_time_den.rwd(2).(EventType).reg_X.(reg_i).reg_Y.(reg_j).coh_beta;
            sem_2_B = coh_vs_time_den.rwd(2).(EventType).reg_X.(reg_i).reg_Y.(reg_j).coh_beta_sem;
            ci95 = sem_2_B.*norminv(0.975);
            shadedErrorBar(tsi,coh_2_B,ci95,'lineprops',{'color',"#ffc299"},'patchSaturation',0.4);
            
            if EventType == 'target'
                xline(-0.3,'--',{'Target ON'},'HandleVisibility','off');
                xline(0,'--r',{'Target OFF'},'HandleVisibility','off');
            elseif EventType == 'stop'
                xline(0,'--',{'Move STOP'},'HandleVisibility','off');
            end
            
            title(sprintf("Monkey: %s, %s, Rwd/No-Rwd, %s - %s",monkey,EventType,reg_i,reg_j),'FontSize',12)
            ylabel('Coherence')
            xlabel('time (sec)')
            set(gcf, 'Position',  [100, 500, 700, 500])
            legend('HD Theta','LD Theta','HD Beta','LD Beta')
%             grid on
            ylim([min([coh_1_T,coh_2_T,coh_1_B,coh_2_B])-D,max([coh_1_T,coh_2_T,coh_1_B,coh_2_B])+D])
            
            fname = strcat(dir_fig_monkey_time,sprintf('rwd_%s_%s_THETA_BETA_coh_vs_time_%s_%s.pdf',monkey,EventType,reg_i,reg_j));
            saveas(fig,fname)
            
            
           
            
        end
    end
    
end

end