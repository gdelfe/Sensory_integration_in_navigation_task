% Plot coherencegram difference between high and low optic flow
% coherencegrams, and difference between rewarded and no-rewarded
% coherencegrams.
%
% @ Gino Del Ferraro, NYU, April 2023.

function [] = plot_coherencegram_difference(coh_avg_den,coh_avg_rwd,monkey,Events,dir_out_fig_gram,t_stats)

dir_fig_monkey_gram_den = fullfile(dir_out_fig_gram + monkey + '\density\')
if ~exist(strcat(dir_fig_monkey_gram_den), 'dir')
    mkdir(dir_fig_monkey_gram_den)
end

dir_fig_monkey_gram_rwd = fullfile(dir_out_fig_gram + monkey + '\reward\')
if ~exist(strcat(dir_fig_monkey_gram_rwd), 'dir')
    mkdir(dir_fig_monkey_gram_rwd)
end


% get time and frequency parameters
tsi = t_stats.ts(round(t_stats.ti));
ti = t_stats.ti;
ts = t_stats.ts;
f = coh_avg_den.f;

reg_names = fieldnames(coh_avg_den.high_den.target.reg_X); % brain regions name

for EventType = Events
    
    for region_i = 1:length(reg_names)
        reg_i = reg_names{region_i};
        
        for region_j = region_i:length(reg_names)
            reg_j = reg_names{region_j};
            
            % High vs Low optic flow density - coherencegram difference
            coh_2 = coh_avg_den.high_den.(EventType).reg_X.(reg_i).reg_Y.(reg_j).cohgram;
            coh_1 = coh_avg_den.low_den.(EventType).reg_X.(reg_i).reg_Y.(reg_j).cohgram;
            
            cohgram_diff = coh_2 - coh_1;
            
            fig = figure;
            tvimage(cohgram_diff)
            colorbar
            title(sprintf("Monkey: %s, %s, cohgram, High - low optic flow, %s - %s - Stop ",monkey,EventType,reg_i,reg_j),'FontSize',12)
            [x_idx, xlbl, y_idx, ylbl] = tfspec_labels(ts,ti,f,0.25,10); % generate labels
            set(gca, 'XTick',x_idx, 'XTickLabel',xlbl)
            set(gca, 'YTick',y_idx, 'YTickLabel',ylbl)
            ylabel('Frequency (Hz)')
            xlabel('time (sec)')
            set(gcf, 'Position',  [100, 500, 700, 500])
            
            fname = strcat(dir_fig_monkey_gram_den,sprintf('density_%s_%s_cohgram_%s_%s.png',monkey,EventType,reg_i,reg_j));
            saveas(fig,fname)
            
            
            % RWD - NO RWD - coherencegram difference
            coh_2 = coh_avg_rwd.rwd(2).(EventType).reg_X.(reg_i).reg_Y.(reg_j).cohgram;
            coh_1 = coh_avg_rwd.rwd(1).(EventType).reg_X.(reg_i).reg_Y.(reg_j).cohgram;
            
            cohgram_diff = coh_2 - coh_1;
            
            fig = figure;
            tvimage(cohgram_diff)
            colorbar
            title(sprintf("Monkey: %s, %s, cohgram, RWD -  No RWD, %s - %s - Stop ",monkey,EventType,reg_i,reg_j),'FontSize',12)
            [x_idx, xlbl, y_idx, ylbl] = tfspec_labels(ts,ti,f,0.25,10); % generate labels
            set(gca, 'XTick',x_idx, 'XTickLabel',xlbl)
            set(gca, 'YTick',y_idx, 'YTickLabel',ylbl)
            ylabel('Frequency (Hz)')
            xlabel('time (sec)')
            set(gcf, 'Position',  [100, 500, 700, 500])
            
            fname = strcat(dir_fig_monkey_gram_rwd,sprintf('rwd_%s_%s_cohgram_%s_%s.png',monkey,EventType,reg_i,reg_j));
            saveas(fig,fname)
            
            
        end
    end
    
end


end