% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function plots the zscored psd vs freq, normal, thresholded, and
% cluster corrected 
%
% @ Gino Del Ferraro, NYU, Jan 2023
%
%

function plot_psd_vs_freq(Zscored_stats,reg,EventType,monkey,f,dir_out_region,nch,pth,iterations,show_fig)

% show figures or not 
if show_fig == 0
    set(0,'DefaultFigureVisible','off')
elseif show_fig == 1 
    set(0,'DefaultFigureVisible','on')
end

z_th = abs(norminv((0.5*pth))); % z-score threshold for two tails test


z_diff = Zscored_stats.region.(reg).event.(EventType).var.psd.z_log_diff;
z_diff_th = Zscored_stats.region.(reg).event.(EventType).var.psd.z_log_diff_th;
z_diff_cc = Zscored_stats.region.(reg).event.(EventType).var.psd.z_log_diff_clust_corr;


fig = figure;
plot(f,z_diff); hold on
yline(z_th); 
yline(-z_th)

hold on
% %%%%%%%%%%%%%%%%%%%% 
% GET THE GREY SHADED BAR FOR CLUSTER CORRECTION PLOTS
% %%%%%%%%%%%%%%%%%%%%

% find starting and ending point of cluster corrected significant intervals
prod = z_diff_cc.*f; % create a mask between zscore cc and time axis for the grey shaded bars
mask = logical(prod(:).');    %(:).' to force row vector
starts = strfind([false, mask], [0 1]);
stops = strfind([mask, false], [1 0]);

bands  = cat(1,starts,stops)';

xp = [f(bands) fliplr(f(bands))];                                                         % X-Coordinate Band Definitions 
yp = ([[1;1]*min(ylim); [1;1]*max(ylim)]*ones(1,size(bands,1))).';                  % Y-Coordinate Band Definitions
for k = 1:size(bands,1)                                                             % Plot Bands
    patch(xp(k,:), yp(k,:), [1 1 1]*0.25, 'FaceAlpha',0.2, 'EdgeColor','None')
end
hold off

title(sprintf("M: %s, Zpsd diff, reg = %s, event = %s, nch = %d, p_th = %.2f",monkey,reg,EventType,nch,pth),'FontSize',12)
xlabel('frequency (Hz)','FontName','Arial','FontSize',12);
ylabel('zscored log(power) diff','FontName','Arial','FontSize',12);
legend({'zscored diff','zscored threshold'},'FontSize',10,'FontName','Arial','Location','NorthWest')
set(gcf, 'Position',  [100, 500, 800, 500])
% set(gca,'FontSize',14)
grid on

fname = strcat(dir_out_region,sprintf('%s_zscored_psd_diff_vs_time_reg_%s_event_%s_pth_%.2f_iter_%d.png',monkey,reg,EventType,pth,iterations));
saveas(fig,fname)


end 