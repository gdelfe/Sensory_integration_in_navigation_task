% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function plots the zscored spectrogram, normal, thresholded average
%
% @ Gino Del Ferraro, NYU, June 2023

function plot_zscored_spec_AVG(Zscored_stats,reg,EventType,name,quantity,quantity_cc,ts,ti,f_spec,y_max,dir_out_region,pth,show_fig)
% show figures or not
if show_fig == 0
    set(0,'DefaultFigureVisible','off')
elseif show_fig == 1
    set(0,'DefaultFigureVisible','on')
end

quantity_th = [quantity,'_th'];
quantity_cc = [quantity_cc,'_corr'];

% for file naming 
type{1} = '';
type{2} = 'th';
type{3} = 'CC';

Z(1).data = Zscored_stats.region.(reg).event.(EventType).var.spec.(quantity);
Z(2).data = Zscored_stats.region.(reg).event.(EventType).var.spec.(quantity_th);
% Z(3).data = Zscored_stats.region.(reg).event.(EventType).var.spec.(quantity_cc);

Z(1).names = ['Zscored ', name]; % log difference spectrogram (rwd 0/1) zscored
Z(2).names = ['Zscored ',name,' th']; % log difference spectrogram (rwd 0/1) zscored thresholded
% Z(3).names = ['Zscored ',name,' CC']; % log difference spectrogram (rwd 0/1) zscored cluster corrected

Z(1).n_file = 'zscored'; % file names for figure
Z(2).n_file = 'zscored_th'; %
% Z(3).n_file = 'Zscored_cc'; %

dir_out_score  = strcat(dir_out_region,sprintf('Spec_%s\\',Z(1).names));
if ~exist(dir_out_score, 'dir')
    mkdir(dir_out_score)
end

for i = 1:2
    
    p = 0.025;  % In a two-tailed test, a p-value of 0.05 corresponds to 0.025 in each tail
    z_th = norminv(1-p);  % Computes the z-score
    
    fig = figure;
    tvimage(Z(i).data);
    
    ax = gca;
    C = max(abs(Z(i).data(:)));  % Find the absolute maximum of the data
    if C ~=0
        ax.CLim = [-C, C];  % Set the color limits to be symmetric about zero
    end
    jetColormap = jet(255);  % Generate a colormap with an odd number of colors
    
    if i > 1 && C~=0
        % Calculate the indices corresponding to the threshold values
        lowerIdx = round((-z_th / C) * 127) + 128;
        upperIdx = round((z_th / C) * 127) + 128;
        
        jetColormap(lowerIdx:upperIdx, :) = repmat([1,1,1], upperIdx-lowerIdx+1, 1);  % Set the colors in the range to white
        
    end
    colormap(jetColormap);
    colorbar;
    
    grid on
    title(sprintf('Average %s, %s, %s, pth = %.2f',reg,upper(EventType),Z(i).names,pth),'FontSize',10);
    
    [x_idx, xlbl, y_idx, ylbl] = tfspec_labels(ts,ti,f_spec,0.25,10);
    
    set(gca, 'XTick',x_idx, 'XTickLabel',xlbl)
    set(gca, 'YTick',y_idx, 'YTickLabel',ylbl)
    ylabel('frequency (Hz)')
    xlabel('time (sec)')
    grid on
    set(gcf,'position',[100,600,600,500])
    ylim([0 y_max])
    
    % Draw a vertical line at x = constant
    x = 14; % zero point (target offset)
    hold on;  % This allows us to draw on the image
    line([x, x], [0, length(f_spec)], 'Color', 'k', 'LineWidth', 1,'LineStyle', '--');  % Adjust color and line width as needed
    hold off;
    
    if EventType == "target"
        x = 8.2; % zero point (target onset)
        hold on;  % This allows us to draw on the image
        line([x, x], [0, length(f_spec)], 'Color', 'k', 'LineWidth', 1,'LineStyle', '--');  % Adjust color and line width as needed
        hold off;
    end
    
    %      % Convert z-scores to p-values
    %     p_values = 2*(1-normcdf(abs(Z(i).data)));
    %
    %     % Display the image
    %     figure;
    %     tvimage(p_values);
    %
    %     % Add the colorbar and customize the ticks
    %     h_colorbar = colorbar;
    %     h_colorbar.Label.String = 'p-value';
    %
    %     % Define tick positions if needed (0.05 and 0.01 as example)
    %     tick_positions = [0.05, 0.01];
    %     tick_labels = arrayfun(@num2str, tick_positions, 'UniformOutput', false);
    % %     h_colorbar.Ticks = tick_positions;
    % %     h_colorbar.TickLabels = tick_labels;
    %     set(gca, 'XTick',x_idx, 'XTickLabel',xlbl)
    %     set(gca, 'YTick',y_idx, 'YTickLabel',ylbl)
    %     ylabel('frequency (Hz)')
    %     xlabel('time (sec)')
    %     ylim([0 y_max])
    
    
    fname = strcat(dir_out_score,sprintf('Average_spec_%s_%s_%s_%s_%s_pth_%.2f.png',type{i},name,Z(i).n_file,reg,EventType,pth));
    saveas(fig,fname)
    
end


end