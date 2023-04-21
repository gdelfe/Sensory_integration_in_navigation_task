% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function plots the zscored spectrogram, normal, thresholded, and
% cluster corrected 
%
% @ Gino Del Ferraro, NYU, Jan 2023

function plot_zscored_spec(Zscored_stats,reg,EventType,monkey,ts,ti,f_spec,dir_out_region,nch,pth,iterations,show_fig)
% show figures or not 
if show_fig == 0
    set(0,'DefaultFigureVisible','off')
elseif show_fig == 1 
    set(0,'DefaultFigureVisible','on')
end

Z(1).data = Zscored_stats.region.(reg).event.(EventType).var.spec.z_log_diff;
Z(2).data = Zscored_stats.region.(reg).event.(EventType).var.spec.z_log_diff_th;
Z(3).data = Zscored_stats.region.(reg).event.(EventType).var.spec.z_log_diff_clust_corr;

Z(1).names = 'Zscored diff'; % log difference spectrogram (rwd 0/1) zscored
Z(2).names = 'Zscored diff th'; % log difference spectrogram (rwd 0/1) zscored thresholded
Z(3).names = 'Zscored diff CC'; % log difference spectrogram (rwd 0/1) zscored cluster corrected 

Z(1).n_file = 'zscored'; % file names for figure                             
Z(2).n_file = 'zscored_th'; % 
Z(3).n_file = 'Zscored_cc'; % 

for i = 1:3
    
    fig = figure;
    tvimage(Z(i).data);
%     fig.OuterPosition = fig.OuterPosition + [0 0 300 0]
    ax = gca;
    if i == 1
        Cmin = min(ax.CLim);
        Cmax = max(ax.CLim);
    end
    ax.CLim = [Cmin, Cmax];
    colorbar
    grid on
    title(sprintf('M: %s, region: %s, Event: %s, %s no-rwd - rwd, nch: %d, p_th = %.2f',monkey,reg,EventType,Z(i).names,nch,pth),'FontSize',10);
    %// Create colorbar
%     cb = colorbar;
%     z = cb.Ticks;
%     pval = round(zscore2pval_2Tails(z),2);
    %// Set its ylabel property
%     ylabel(cb,'Z-score','FontSize',12);
    %// Get its position
%     BarPos = get(cb,'position');
%     BarPos = BarPos + [0. 0 0 0];
%     set(cb,'Position',BarPos)% To change size

%     set(gcf,'OuterPosition',fig.OuterPosition)
    %// Create an axes at the same position
%     haxes = axes('position',BarPos,'color','none','ytick',pval);
    
    %// Set its ylabel property
%     ylabel('Approximate position error','FontSize',12)
    
    
    [x_idx, xlbl, y_idx, ylbl] = tfspec_labels(ts,ti,f_spec,0.25,10);
    
    set(gca, 'XTick',x_idx, 'XTickLabel',xlbl)
    set(gca, 'YTick',y_idx, 'YTickLabel',ylbl)
    ylabel('frequency (Hz)')
    xlabel('time (sec)')
    grid on
    set(gcf,'position',[100,600,600,500])
    
    fname = strcat(dir_out_region,sprintf('%s_spec_diff_%s_reg_%s_event_%s_pth_%.2f_iter_%d.png',monkey,Z(i).n_file,reg,EventType,pth,iterations));
    saveas(fig,fname)
    
end


end