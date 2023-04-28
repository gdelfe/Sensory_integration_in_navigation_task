% Plot coherence vs time for the high/low density optic flow for 
% two different frequency band: theta and beta frequencies.
%
% @ Gino Del Ferraro, NYU, April 2023.

function [] = plot_coherence_vs_time_density_combined(coh_vs_time_den,monkey,Events,dir_out_fig,tsi)

dir_fig_monkey_time = fullfile(dir_out_fig + monkey + '\density\')
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
            coh_h = coh_vs_time_den.high_den.(EventType).reg_X.(reg_i).reg_Y.(reg_j).coh_theta;
            sem = coh_vs_time_den.high_den.(EventType).reg_X.(reg_i).reg_Y.(reg_j).coh_theta_sem;
            shadedErrorBar(tsi,coh_h,sem,'lineprops',{'color',"#ff6600"},'patchSaturation',0.4);
            
            coh_L = coh_vs_time_den.low_den.(EventType).reg_X.(reg_i).reg_Y.(reg_j).coh_theta;
            sem = coh_vs_time_den.low_den.(EventType).reg_X.(reg_i).reg_Y.(reg_j).coh_theta_sem;
            shadedErrorBar(tsi,coh_L,sem,'lineprops',{'color',"#0033cc"},'patchSaturation',0.4);
            
            title(sprintf("Monkey: %s, %s, THETA freq, High/Low optic flow, %s - %s",monkey,EventType,reg_i,reg_j),'FontSize',12)
            ylabel('Coherence')
            xlabel('time (sec)')
            set(gcf, 'Position',  [100, 500, 700, 500])
            legend('high density','low density')
            grid on
            ylim([min(min(coh_h),min(coh_L))-D,max(max(coh_h),max(coh_L))+D])
            fname = strcat(dir_fig_monkey_time,sprintf('density_%s_%s_coh_vs_time_THETA_%s_%s.png',monkey,EventType,reg_i,reg_j));
            saveas(fig,fname)
            
            
            % High vs Low optic flow density - coherence vs time BETA
            fig = figure; hold all
            coh_h = coh_vs_time_den.high_den.(EventType).reg_X.(reg_i).reg_Y.(reg_j).coh_beta;
            sem = coh_vs_time_den.high_den.(EventType).reg_X.(reg_i).reg_Y.(reg_j).coh_beta_std;
            shadedErrorBar(tsi,coh_h,sem,'lineprops',{'color',"#ff6600"},'patchSaturation',0.4);
            
            coh_L = coh_vs_time_den.low_den.(EventType).reg_X.(reg_i).reg_Y.(reg_j).coh_beta;
            sem = coh_vs_time_den.low_den.(EventType).reg_X.(reg_i).reg_Y.(reg_j).coh_beta_std;
            shadedErrorBar(tsi,coh_L,sem,'lineprops',{'color',"#0033cc"},'patchSaturation',0.4);
            
            title(sprintf("Monkey: %s, %s, BETA freq, High/Low optic flow, %s - %s",monkey,EventType,reg_i,reg_j),'FontSize',12)
            ylabel('Coherence')
            xlabel('time (sec)')
            set(gcf, 'Position',  [100, 500, 700, 500])
            legend('high density','low density')
            grid on
            ylim([min(min(coh_h),min(coh_L))-D,max(max(coh_h),max(coh_L))+D])
            fname = strcat(dir_fig_monkey_time,sprintf('density_%s_%s_coh_vs_time_BETA_%s_%s.png',monkey,EventType,reg_i,reg_j));
            saveas(fig,fname)           
            
        end
    end
    
end

end