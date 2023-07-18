

% Merge coherence, PLV, phase difference results across sessions for a
% given monkey. Compute mean and std of such quantities across sessions.

clear all; close all;
% input and output directories
dir_in = 'E:\Output\GINO\cohgram_all_channels\';
dir_in_phase = 'E:\Output\GINO\phase_PLV\';

monkeys = ["Schro","Vik"];

reg_i = "PFC";
reg_j = "PPC"
EventType = "target";
n_sess = 3;

dir_out_PLV_data_avg = 'E:\Output\GINO\phase_PLV\averages\';

dir_out_PLV_data_avg = strcat(dir_out_PLV_data_avg, reg_i + '_' + reg_j + '\');
if ~exist(dir_out_PLV_data_avg, 'dir')
    mkdir(dir_out_PLV_data_avg)
end

dir_fig = 'E:\Output\GINO\Figures\PLV_phase_diff\all_together\';
dir_fig = strcat(dir_fig, reg_i + '_' + reg_j + '\');
if ~exist(dir_fig, 'dir')
    mkdir(dir_fig)
end

theta = []; theta_sem = [];

for monkey = monkeys

f_name = strcat(sprintf('%s_PLV_AVG_across_cond_%s_%s.mat',monkey,reg_i,reg_j));
load(strcat(dir_out_PLV_data_avg,f_name));

PLV_avg.theta_avg = PLV_avg.theta_avg(1:316);
PLV_avg.theta_sem = PLV_avg.theta_sem(1:316);

theta = [theta; PLV_avg.theta_avg];
theta_sem = [theta_sem; PLV_avg.theta_sem];

end


theta_avg = mean(theta,1);
theta_sem = sum(theta_sem);
ts = PLV_avg.ts;
ts = ts(1:316);

% THETA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% PLV
fig = figure;
shadedErrorBar(ts,theta_avg,theta_sem,'lineprops',{'color',"#0066ff"},'patchSaturation',0.4); hold on
xlabel('time (sec)')
ylabel('PLV')
title(sprintf('All monkeys - PLV - Theta - %s - %s',reg_i,reg_j))

% xline(-0.3,'--r'); % target onset
% xline(0,'--k') % target offset

% Create gray box
grayBoxX = [-0.3, -0.3, 0, 0];
grayBoxY = [ylim, fliplr(ylim)];
grayBoxColor = [0.7 0.7 0.7]; % Gray color (adjust as needed)
patch(grayBoxX, grayBoxY, grayBoxColor, 'EdgeColor', 'none', 'FaceAlpha', 0.3);

legend('PLV');

fig_name = strcat(sprintf('ALL_Monkekys_PLV_THETA_avg_%s_%s.pdf',reg_i,reg_j));
saveas(fig,strcat(dir_fig,fig_name))


