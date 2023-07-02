% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot z-scored spectral features AVERAGES
%
% Features plotted: theta/beta power vs time for each region, 
% for reward = 0/1
% OUTPUT: files 

function plot_zscored_spectral_features_AVG(Zscored_stats,t_stats,Events,pth,show_fig,dir_out)

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
reg_names = {'PPC','PFC','MST'};
t = ts(round(ti));


for region = 1:length(reg_names)
    reg = reg_names{region}; % get region name
    
    for EventType = Events
        
        dir_out_region  = strcat(dir_out,sprintf('%s\\%s\\',reg,EventType));
        
        
%         plot z-scored spectrogram
        plot_zscored_spec_AVG(Zscored_stats,reg,EventType,'diff','z_log_diff','z_log_diff_clust',ts,ti,f_spec,id,dir_out_region,pth,1)

     
    end
end

end
