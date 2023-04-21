% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot spectral features for each monkey and save figures
%
% Features plotted: theta/beta power vs time for each region, 
% for reward = 0/1
% OUTPUT: files 

function plot_spectral_features(t_stats,Events,monkey,show_fig,dir_out)

if show_fig == 0
    set(0,'DefaultFigureVisible','off')
elseif show_fig == 1 
    set(0,'DefaultFigureVisible','on')
end

% time axis
ts = t_stats.ts(round(t_stats.ti));
% region names
reg_names = fieldnames(t_stats(1).region);

for region = 1:length(reg_names)
    reg = reg_names{region}; % get region name
    nch = t_stats.region.(reg).Nch;
    
    for EventType = Events
        
        % theta pow rwd = 0/1
        reg1_rwd1_theta_pow = t_stats.region.(reg).event.(EventType).rwd(1).avg_theta_pow;
        reg1_rwd1_err_theta = t_stats.region.(reg).event.(EventType).rwd(1).err_theta_pow;
        reg1_rwd2_theta_pow = t_stats.region.(reg).event.(EventType).rwd(2).avg_theta_pow;
        reg1_rwd1_err_theta = t_stats.region.(reg).event.(EventType).rwd(2).err_theta_pow;
        
        % beta pow for rwd = 0/1
        reg1_rwd1_beta_pow = t_stats.region.(reg).event.(EventType).rwd(1).avg_beta_pow;
        reg1_rwd1_err_beta = t_stats.region.(reg).event.(EventType).rwd(1).err_beta_pow;
        reg1_rwd2_beta_pow = t_stats.region.(reg).event.(EventType).rwd(2).avg_beta_pow;
        reg1_rwd1_err_beta = t_stats.region.(reg).event.(EventType).rwd(2).err_beta_pow;
        
        % % THETA POWER
        fig = figure;
        shadedErrorBar(ts,reg1_rwd1_theta_pow,reg1_rwd1_err_theta,'lineprops',{'color',"#ff6600"},'patchSaturation',0.5); hold on % incorrect trials
        shadedErrorBar(ts,reg1_rwd2_theta_pow,reg1_rwd1_err_theta,'lineprops',{'color',"#00cc66"  },'patchSaturation',0.5); % correct trials
        
        title(sprintf("Monkey: %s, region = %s, event = %s, nch = %d",monkey,reg,EventType,nch),'FontSize',12)
        xlabel('time (s)','FontName','Arial','FontSize',15);
        ylabel('log(power)','FontName','Arial','FontSize',15);
        legend({'no reward','reward'},'FontSize',10,'FontName','Arial')
        set(gcf, 'Position',  [100, 500, 700, 500])
        % set(gca,'FontSize',14)
        grid on
        fname = strcat(dir_out,sprintf('%s_theta_power_vs_time_reg_%s_event_%s.png',monkey,reg,EventType));
        saveas(fig,fname)
        
        
        % % BETA POWER
        fig = figure;
        shadedErrorBar(ts,reg1_rwd1_beta_pow,reg1_rwd1_err_beta,'lineprops',{'color',"#ff6600"},'patchSaturation',0.5); hold on % incorrect trials
        shadedErrorBar(ts,reg1_rwd2_beta_pow,reg1_rwd1_err_beta,'lineprops',{'color',"#00cc66"  },'patchSaturation',0.5); % correct trials
        
        title(sprintf("Monkey: %s, region = %s, event = %s, nch = %d",monkey,reg,EventType,nch),'FontSize',12)
        xlabel('time (s)','FontName','Arial','FontSize',15);
        ylabel('log(power)','FontName','Arial','FontSize',15);
        legend({'no reward','reward'},'FontSize',10,'FontName','Arial')
        set(gcf, 'Position',  [100, 500, 700, 500])
        % set(gca,'FontSize',14)
        grid on
        fname = strcat(dir_out,sprintf('%s_beta_power_vs_time_reg_%s_event_%s.png',monkey,reg,EventType));
        saveas(fig,fname)
        
    end
end

end
