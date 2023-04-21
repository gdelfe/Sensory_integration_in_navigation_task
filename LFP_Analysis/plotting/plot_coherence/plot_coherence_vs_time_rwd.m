% Plot coherence vs time for the reward/no-reward trials 
% two different frequency band: theta and beta frequencies.
%
% @ Gino Del Ferraro, NYU, April 2023.

function [] = plot_coherence_vs_time_rwd(coh_vs_time_rwd,monkey, Events,dir_out_fig,tsi)

dir_fig_monkey_time = fullfile(dir_out_fig + monkey + '\reward\')
if ~exist(strcat(dir_fig_monkey_time), 'dir')
    mkdir(dir_fig_monkey_time)
end

reg_names = fieldnames(coh_vs_time_rwd.rwd(1).target.reg_X); % brain regions name
D = 0.07; % shift for the yaxis plot

for EventType = Events
    
    for region_i = 1:length(reg_names)
        reg_i = reg_names{region_i};
        
        for region_j = region_i:length(reg_names)
            reg_j = reg_names{region_j};
            
            % RWD vs NO RWD - coherence vs time THETA
            fig = figure; hold all
            coh_1 = coh_vs_time_rwd.rwd(2).(EventType).reg_X.(reg_i).reg_Y.(reg_j).coh_theta;
            std = coh_vs_time_rwd.rwd(2).(EventType).reg_X.(reg_i).reg_Y.(reg_j).coh_theta_std;
            shadedErrorBar(tsi,coh_1,std,'lineprops',{'color',"#ff6600"},'patchSaturation',0.4);
            
            coh_2 = coh_vs_time_rwd.rwd(1).(EventType).reg_X.(reg_i).reg_Y.(reg_j).coh_theta;
            std = coh_vs_time_rwd.rwd(1).(EventType).reg_X.(reg_i).reg_Y.(reg_j).coh_theta_std;
            shadedErrorBar(tsi,coh_2,std,'lineprops',{'color',"#0033cc"},'patchSaturation',0.4);
            
            title(sprintf("Monkey: %s, %s, THETA freq, Rwd/No-rwd, %s - %s - Stop ",monkey,EventType,reg_i,reg_j),'FontSize',12)
            ylabel('Coherence')
            xlabel('time (sec)')
            set(gcf, 'Position',  [100, 500, 700, 500])
            legend('Reward','No reward')
            grid on
            ylim([min(min(coh_1),min(coh_2))-D,max(max(coh_1),max(coh_2))+D])
            fname = strcat(dir_fig_monkey_time,sprintf('rwd_%s_%s_coh_vs_time_THETA_%s_%s.png',monkey,EventType,reg_i,reg_j));
            saveas(fig,fname)
            
            
            % RWD vs NO RWD - coherence vs time BETA
            fig = figure; hold all
            coh_1 = coh_vs_time_rwd.rwd(2).(EventType).reg_X.(reg_i).reg_Y.(reg_j).coh_beta;
            std = coh_vs_time_rwd.rwd(2).(EventType).reg_X.(reg_i).reg_Y.(reg_j).coh_beta_std;
            shadedErrorBar(tsi,coh_1,std,'lineprops',{'color',"#ff6600"},'patchSaturation',0.4);
            
            coh_2 = coh_vs_time_rwd.rwd(1).(EventType).reg_X.(reg_i).reg_Y.(reg_j).coh_beta;
            std = coh_vs_time_rwd.rwd(1).(EventType).reg_X.(reg_i).reg_Y.(reg_j).coh_beta_std;
            shadedErrorBar(tsi,coh_2,std,'lineprops',{'color',"#0033cc"},'patchSaturation',0.4);
            
            title(sprintf("Monkey: %s, %s, BETA freq, Rwd/No-rwd, %s - %s - Stop ",monkey,EventType,reg_i,reg_j),'FontSize',12)
            ylabel('Coherence')
            xlabel('time (sec)')
            set(gcf, 'Position',  [100, 500, 700, 500])
            legend('Reward','No reward')
            grid on
            ylim([min(min(coh_1),min(coh_2))-D,max(max(coh_1),max(coh_2))+D])
            fname = strcat(dir_fig_monkey_time,sprintf('rwd_%s_%s_coh_vs_time_BETA_%s_%s.png',monkey,EventType,reg_i,reg_j));
            saveas(fig,fname)
            
            
        end
    end
    
end

end