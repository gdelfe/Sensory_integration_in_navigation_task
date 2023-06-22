% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot spectral features for each monkey and save figures
%
% Features plotted: theta/beta power vs time for each region, 
% for reward = 0/1
% OUTPUT: files 

function plot_spectral_features(t_stats,Events,monkey,show_fig,dir_main)

% show figures or not 
if show_fig == 0
    set(0,'DefaultFigureVisible','off')
elseif show_fig == 1 
    set(0,'DefaultFigureVisible','on')
end

% time axis
ts = t_stats.ts;
tsi = t_stats.ts(round(t_stats.ti)); 
f = t_stats.f_psd; % psd frequency 
ti = t_stats.ti;
f_spec = t_stats.f_spec;
% region names
reg_names = fieldnames(t_stats(1).region);

for region = 1:length(reg_names)
    reg = reg_names{region}; % get region name
    nch = t_stats.region.(reg).Nch;
    
    
    for EventType = Events
        
        dir_out_region  = strcat(dir_main,sprintf('%s\\%s\\',reg,EventType));
        if ~exist(dir_out_region, 'dir')
            mkdir(dir_out_region)
        end
     
        % theta pow rwd = 0/1
        rwd1_theta_t = t_stats.region.(reg).event.(EventType).rwd(1).avg_theta_t;
        rwd1_err_theta = t_stats.region.(reg).event.(EventType).rwd(1).err_theta_t;
        rwd2_theta_t = t_stats.region.(reg).event.(EventType).rwd(2).avg_theta_t;
        rwd2_err_theta = t_stats.region.(reg).event.(EventType).rwd(2).err_theta_t;
        
        % beta pow for rwd = 0/1
        rwd1_beta_t = t_stats.region.(reg).event.(EventType).rwd(1).avg_beta_t;
        rwd1_err_beta = t_stats.region.(reg).event.(EventType).rwd(1).err_beta_t;
        rwd2_beta_t = t_stats.region.(reg).event.(EventType).rwd(2).avg_beta_t;
        rwd2_err_beta = t_stats.region.(reg).event.(EventType).rwd(2).err_beta_t;
        
        % spectrogram for rwd = 0/1
        rwd1_spec = t_stats.region.(reg).event.(EventType).rwd(1).avg_spec;
        rwd2_spec = t_stats.region.(reg).event.(EventType).rwd(2).avg_spec;
        log_spec_diff = rwd1_spec - rwd2_spec;
        
        
        % psd for rwd = 0/1
        rwd1_psd = t_stats.region.(reg).event.(EventType).rwd(1).avg_psd;
        rwd1_err_psd = t_stats.region.(reg).event.(EventType).rwd(1).err_psd;
        rwd2_psd = t_stats.region.(reg).event.(EventType).rwd(2).avg_psd;
        rwd2_err_psd = t_stats.region.(reg).event.(EventType).rwd(2).err_psd;
        
        
        % % THETA POWER
        fig = figure;
        shadedErrorBar(tsi,rwd1_theta_t,rwd1_err_theta,'lineprops',{'color',"#009900"},'patchSaturation',0.5); hold on % incorrect trials
        shadedErrorBar(tsi,rwd2_theta_t,rwd2_err_theta,'lineprops',{'color',"#00ff00"  },'patchSaturation',0.5); hold on % correct trials
        
        title(sprintf("%s, %s, theta band, %s, nch = %d",monkey,reg,upper(EventType),nch),'FontSize',12)
        xlabel('time (s)','FontName','Arial','FontSize',15);
        ylabel('log(power)','FontName','Arial','FontSize',15);
        set(gcf, 'Position',  [100, 500, 700, 500])
        % set(gca,'FontSize',14)
        grid on
        xline(0,'k--')
        if EventType == 'target'
            xline(-0.3,'r--')
        end
        hold off 
        legend({'no reward','reward'},'FontSize',10,'FontName','Arial')

        fname = strcat(dir_out_region,sprintf('%s_THETA_power_vs_time_reg_%s_event_%s.png',monkey,reg,EventType));
        saveas(fig,fname)
        
        
        % % BETA POWER
        fig = figure;
        shadedErrorBar(tsi,rwd1_beta_t,rwd1_err_beta,'lineprops',{'color',"#993d00"},'patchSaturation',0.5); hold on % incorrect trials
        shadedErrorBar(tsi,rwd2_beta_t,rwd2_err_beta,'lineprops',{'color',"#ff944d"  },'patchSaturation',0.5); hold on % correct trials
        
        title(sprintf("%s, %s, beta band, %s, nch = %d",monkey,reg,upper(EventType),nch),'FontSize',12)
        xlabel('time (s)','FontName','Arial','FontSize',15);
        ylabel('log(power)','FontName','Arial','FontSize',15);
        set(gcf, 'Position',  [100, 500, 700, 500])
        % set(gca,'FontSize',14)
        grid on
        xline(0,'k--')
        if EventType == 'target'
            xline(-0.3,'r--')
        end
        hold off 
        legend({'no reward','reward'},'FontSize',10,'FontName','Arial')
        
        fname = strcat(dir_out_region,sprintf('%s_BETA_power_vs_time_reg_%s_event_%s.png',monkey,reg,EventType));
        saveas(fig,fname)
        
        
        % % THETA-BETA POWER
        fig = figure;
        shadedErrorBar(tsi,rwd1_theta_t,rwd1_err_theta,'lineprops',{'color',"#009900"},'patchSaturation',0.5); hold on % incorrect trials
        shadedErrorBar(tsi,rwd2_theta_t,rwd2_err_theta,'lineprops',{'color',"#00ff00"  },'patchSaturation',0.5); hold on % correct trials
        shadedErrorBar(tsi,rwd1_beta_t,rwd1_err_beta,'lineprops',{'color',"#993d00"},'patchSaturation',0.5); hold on % incorrect trials
        shadedErrorBar(tsi,rwd2_beta_t,rwd2_err_beta,'lineprops',{'color',"#ff944d"  },'patchSaturation',0.5); hold on % correct trials
        
        title(sprintf("%s, %s, theta/beta band, %s, nch = %d",monkey,reg,upper(EventType),nch),'FontSize',12)
        xlabel('time (s)','FontName','Arial','FontSize',15);
        ylabel('log(power)','FontName','Arial','FontSize',15);
        set(gcf, 'Position',  [100, 500, 700, 500])
        % set(gca,'FontSize',14)
        grid on
        xline(0,'k--')
        if EventType == 'target'
            xline(-0.3,'r--')
        end
        hold off 
        legend({'no reward','reward'},'FontSize',10,'FontName','Arial')
        
        fname = strcat(dir_out_region,sprintf('%s_THETA_BETA_power_vs_time_reg_%s_event_%s.png',monkey,reg,EventType));
        saveas(fig,fname)
        
        
        % % PSD - SPECTRUM
        fig = figure;
        shadedErrorBar(f,rwd1_psd,rwd1_err_psd,'lineprops',{'color',"#ff6600"},'patchSaturation',0.5); hold on % incorrect trials
        shadedErrorBar(f,rwd2_psd,rwd2_err_psd,'lineprops',{'color',"#00cc66"  },'patchSaturation',0.5); % correct trials
        title(sprintf("%s, %s, PSD, %s, nch = %d",monkey,reg,upper(EventType),nch),'FontSize',12)
        xlabel('frequency (Hz)','FontName','Arial','FontSize',15);
        ylabel('log(psd)','FontName','Arial','FontSize',15);
        legend({'no reward','reward'},'FontSize',10,'FontName','Arial')
        set(gcf, 'Position',  [100, 500, 700, 500])
        grid on
        xlim([0 30])
        fname = strcat(dir_out_region,sprintf('%s_PSD_reg_%s_event_%s.png',monkey,reg,EventType));
        saveas(fig,fname)
        
%         % % SPECTROGRAM DIFFERENCE
%         fig = figure;
%         tvimage(log_spec_diff)
%         colorbar
%         grid on
%         title(sprintf("Monkey: %s, Spec diff, region = %s, event = %s, nch = %d",monkey,reg,EventType,nch),'FontSize',12)
%         [x_idx, xlbl, y_idx, ylbl] = tfspec_labels(ts,ti,f_spec,0.25,10); % generate labels
%         set(gca, 'XTick',x_idx, 'XTickLabel',xlbl)
%         set(gca, 'YTick',y_idx, 'YTickLabel',ylbl)
%         ylabel('frequency (Hz)')
%         xlabel('time (sec)')
%         set(gcf, 'Position',  [100, 500, 700, 500])
%         grid on
%         fname = strcat(dir_out_region,sprintf('%s_spec_difference_reg_%s_event_%s.png',monkey,reg,EventType));
%         saveas(fig,fname)
        
        
%         % % SPECTROGRAMS reward and no-reward 
%         % REWARD 
%         fig = figure;
%         tvimage(rwd1_spec)
%         colorbar
%         grid on
%         title(sprintf("Monkey: %s, No rwd, region = %s, event = %s, nch = %d",monkey,reg,EventType,nch),'FontSize',12)
%         [x_idx, xlbl, y_idx, ylbl] = tfspec_labels(ts,ti,f_spec,0.25,10); % generate labels
%         set(gca, 'XTick',x_idx, 'XTickLabel',xlbl)
%         set(gca, 'YTick',y_idx, 'YTickLabel',ylbl)
%         ylabel('frequency (Hz)')
%         xlabel('time (sec)')
%         set(gcf, 'Position',  [100, 500, 700, 500])
%         grid on
%         fname = strcat(dir_out_region,sprintf('%s_spec_no_reward_reg_%s_event_%s.png',monkey,reg,EventType));
%         saveas(fig,fname)
        
% %         NO REWARD 
%         fig = figure;
%         tvimage(rwd2_spec)
%         colorbar
%         grid on
%         title(sprintf("Monkey: %s, rwd, region = %s, event = %s, nch = %d",monkey,reg,EventType,nch),'FontSize',12)
%         [x_idx, xlbl, y_idx, ylbl] = tfspec_labels(ts,ti,f_spec,0.25,10); % generate labels
%         set(gca, 'XTick',x_idx, 'XTickLabel',xlbl)
%         set(gca, 'YTick',y_idx, 'YTickLabel',ylbl)
%         ylabel('frequency (Hz)')
%         xlabel('time (sec)')
%         set(gcf, 'Position',  [100, 500, 700, 500])
%         grid on
%         fname = strcat(dir_out_region,sprintf('%s_spec_reward_reg_%s_event_%s.png',monkey,reg,EventType));
%         saveas(fig,fname)
        
    end
end

end
