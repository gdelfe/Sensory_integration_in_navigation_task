% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot z-scored spectral features for each monkey and save figures
%
% Features plotted: theta/beta power vs time for each region, 
% for reward = 0/1
% OUTPUT: files 

function plot_zscored_spectral_features(Zscored_stats,t_stats,Events,monkey,pth,iterations,show_fig,dir_out)

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
[m, id] = min(abs(f_spec-50)); % find the index of max f_spec at 50 Hz
f_spec = f_spec(1:id); % get frequency from 0 to 50 Hz
% region names
reg_names = fieldnames(t_stats(1).region);
t = ts(round(ti));


for region = 1:length(reg_names)
    reg = reg_names{region}; % get region name
    nch = t_stats.region.(reg).Nch;
    
    dir_out_region  = strcat(dir_out,sprintf('%s\\',reg));
    if ~exist(dir_out_region, 'dir')
        mkdir(dir_out_region)
    end
    
    for EventType = Events
        
%         plot z-scored spectrogram, psd, freq band 
        plot_zscored_spec(Zscored_stats,reg,EventType,monkey,ts,ti,f_spec,dir_out_region,nch,pth,iterations,1)
        plot_psd_vs_freq(Zscored_stats,reg,EventType,monkey,f,dir_out_region,nch,pth,iterations,1)
        plot_freq_vs_time(Zscored_stats,reg,EventType,monkey,"theta_t",t,dir_out_region,nch,pth,iterations,1)
        plot_freq_vs_time(Zscored_stats,reg,EventType,monkey,"beta_t",t,dir_out_region,nch,pth,iterations,1)
        
     
    end
end

end
