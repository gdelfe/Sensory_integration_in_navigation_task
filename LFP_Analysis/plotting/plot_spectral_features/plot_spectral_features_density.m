% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot spectral features for each monkey and save figures
%
% Features plotted: theta/beta power vs time for each region, 
% for reward = 0/1
% OUTPUT: files 

function plot_spectral_features(t_stats,Events,monkey,show_fig,dir_out)

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
    
    dir_out_region  = strcat(dir_out,sprintf('%s\\',reg));
    if ~exist(dir_out_region, 'dir')
       mkdir(dir_out_region)
     end
    
    for EventType = Events
        
        % theta pow for high/low optic flow density
        HD_theta_t = t_stats.region.(reg).event.(EventType).high_den.avg_theta_t;
        HD_err_theta = t_stats.region.(reg).event.(EventType).high_den.err_theta_t;
        LD_theta_t = t_stats.region.(reg).event.(EventType).low_den.avg_theta_t;
        LD_err_theta = t_stats.region.(reg).event.(EventType).low_den.err_theta_t;
        
        % beta pow for high/low optic flow density
        HD_beta_t = t_stats.region.(reg).event.(EventType).high_den.avg_beta_t;
        HD_err_beta = t_stats.region.(reg).event.(EventType).high_den.err_beta_t;
        LD_beta_t = t_stats.region.(reg).event.(EventType).low_den.avg_beta_t;
        LD_err_beta = t_stats.region.(reg).event.(EventType).low_den.err_beta_t;
        
        % spectrogram for high/low optic flow density
        HD_spec = t_stats.region.(reg).event.(EventType).high_den.avg_spec;
        LD_spec = t_stats.region.(reg).event.(EventType).low_den.avg_spec;
        log_spec_diff = HD_spec - LD_spec;
        
        
        % psd for high/low optic flow density
        HD_psd = t_stats.region.(reg).event.(EventType).high_den.avg_psd;
        HD_err_psd = t_stats.region.(reg).event.(EventType).high_den.err_psd;
        LD_psd = t_stats.region.(reg).event.(EventType).low_den.avg_psd;
        LD_err_psd = t_stats.region.(reg).event.(EventType).low_den.err_psd;
        
        
        % % THETA POWER
        fig = figure;
        shadedErrorBar(tsi,HD_theta_t,HD_err_theta,'lineprops',{'color',"#ff6600"},'patchSaturation',0.5); hold on % incorrect trials
        shadedErrorBar(tsi,LD_theta_t,LD_err_theta,'lineprops',{'color',"#00cc66"  },'patchSaturation',0.5); % correct trials
        
        title(sprintf("Monkey: %s, theta band, region = %s, event = %s, nch = %d",monkey,reg,EventType,nch),'FontSize',12)
        xlabel('time (s)','FontName','Arial','FontSize',15);
        ylabel('log(power)','FontName','Arial','FontSize',15);
        legend({'high density','low density'},'FontSize',10,'FontName','Arial')
        set(gcf, 'Position',  [100, 500, 700, 500])
        % set(gca,'FontSize',14)
        grid on
        fname = strcat(dir_out_region,sprintf('%s_power_theta_vs_time_reg_%s_event_%s_density.png',monkey,reg,EventType));
        saveas(fig,fname)
        
        
        % % BETA POWER
        fig = figure;
        shadedErrorBar(tsi,HD_beta_t,HD_err_beta,'lineprops',{'color',"#ff6600"},'patchSaturation',0.5); hold on % incorrect trials
        shadedErrorBar(tsi,LD_beta_t,LD_err_beta,'lineprops',{'color',"#00cc66"  },'patchSaturation',0.5); % correct trials
        
        title(sprintf("Monkey: %s, beta band, region = %s, event = %s, nch = %d",monkey,reg,EventType,nch),'FontSize',12)
        xlabel('time (s)','FontName','Arial','FontSize',15);
        ylabel('log(power)','FontName','Arial','FontSize',15);
        legend({'high density','low density'},'FontSize',10,'FontName','Arial')
        set(gcf, 'Position',  [100, 500, 700, 500])
        % set(gca,'FontSize',14)
        grid on
        fname = strcat(dir_out_region,sprintf('%s_power_beta_vs_time_reg_%s_event_%s_density.png',monkey,reg,EventType));
        saveas(fig,fname)
        
        % % PSD - SPECTRUM
        fig = figure;
        shadedErrorBar(f,HD_psd,HD_err_psd,'lineprops',{'color',"#ff6600"},'patchSaturation',0.5); hold on % incorrect trials
        shadedErrorBar(f,LD_psd,LD_err_psd,'lineprops',{'color',"#00cc66"  },'patchSaturation',0.5); % correct trials
        title(sprintf("Monkey: %s, PSD, region = %s, event = %s, nch = %d",monkey,reg,EventType,nch),'FontSize',12)
        xlabel('frequency (Hz)','FontName','Arial','FontSize',15);
        ylabel('log(psd)','FontName','Arial','FontSize',15);
        legend({'high density','low density'},'FontSize',10,'FontName','Arial')
        set(gcf, 'Position',  [100, 500, 700, 500])
        grid on
        fname = strcat(dir_out_region,sprintf('%s_PSD_reg_%s_event_%s_density.png',monkey,reg,EventType));
        saveas(fig,fname)
        
        % % SPECTROGRAM DIFFERENCE
        fig = figure;
        tvimage(log_spec_diff)
        colorbar
        grid on
        title(sprintf("Monkey: %s, Spec diff, region = %s, event = %s, nch = %d",monkey,reg,EventType,nch),'FontSize',12)
        [x_idx, xlbl, y_idx, ylbl] = tfspec_labels(ts,ti,f_spec,0.25,10); % generate labels
        set(gca, 'XTick',x_idx, 'XTickLabel',xlbl)
        set(gca, 'YTick',y_idx, 'YTickLabel',ylbl)
        ylabel('frequency (Hz)')
        xlabel('time (sec)')
        set(gcf, 'Position',  [100, 500, 700, 500])
        grid on
        fname = strcat(dir_out_region,sprintf('%s_spec_difference_reg_%s_event_%s_density.png',monkey,reg,EventType));
        saveas(fig,fname)
        
        
        % % SPECTROGRAMS high/low density
        % high density 
        fig = figure;
        tvimage(HD_spec)
        colorbar
        grid on
        title(sprintf("Monkey: %s, high density, region = %s, event = %s, nch = %d",monkey,reg,EventType,nch),'FontSize',12)
        [x_idx, xlbl, y_idx, ylbl] = tfspec_labels(ts,ti,f_spec,0.25,10); % generate labels
        set(gca, 'XTick',x_idx, 'XTickLabel',xlbl)
        set(gca, 'YTick',y_idx, 'YTickLabel',ylbl)
        ylabel('frequency (Hz)')
        xlabel('time (sec)')
        set(gcf, 'Position',  [100, 500, 700, 500])
        grid on
        fname = strcat(dir_out_region,sprintf('%s_spec_high_den_reg_%s_event_%s_density.png',monkey,reg,EventType));
        saveas(fig,fname)
        
        % low density
        fig = figure;
        tvimage(LD_spec)
        colorbar
        grid on
        title(sprintf("Monkey: %s, low density, region = %s, event = %s, nch = %d",monkey,reg,EventType,nch),'FontSize',12)
        [x_idx, xlbl, y_idx, ylbl] = tfspec_labels(ts,ti,f_spec,0.25,10); % generate labels
        set(gca, 'XTick',x_idx, 'XTickLabel',xlbl)
        set(gca, 'YTick',y_idx, 'YTickLabel',ylbl)
        ylabel('frequency (Hz)')
        xlabel('time (sec)')
        set(gcf, 'Position',  [100, 500, 700, 500])
        grid on
        fname = strcat(dir_out_region,sprintf('%s_spec_low_density_reg_%s_event_%s_density.png',monkey,reg,EventType));
        saveas(fig,fname)
        
    end
end

end
