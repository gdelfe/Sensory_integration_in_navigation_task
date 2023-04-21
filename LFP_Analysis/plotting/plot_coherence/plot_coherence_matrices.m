
% Plot coherence matrix for theta/beta frequency range for both
% reward/no-reward, their difference, and both high/low density optic flow
% as well as their difference.
%
% @ Gino Del Ferraro, NYU, April 2023.


clear all; close all;

% %%%%%%%%%%%%%%%%
% PATHS
% %%%%%%%%%%%%%%%
monkey = "Bruno";
dir_in = 'E:\Output\GINO\coherence\avg_coherences\';
dir_out = 'E:\Output\GINO\Figures\coherence\avg_coherences\';

% create directories 
dir_out_theta = fullfile(dir_out + monkey + "\theta\");
if ~exist(dir_out_theta, 'dir')
    mkdir(dir_out_theta)
end

dir_out_beta = fullfile(dir_out + monkey + "\beta\");
if ~exist(dir_out_beta, 'dir')
    mkdir(dir_out_beta)
end

% load coherence files 
load(strcat(dir_in,sprintf('coherence_matrix_ij_%s.mat',monkey)));
load(strcat(dir_in,sprintf('coherence_vs_frequency_%s.mat',monkey)));
reg_names = fieldnames(coh_vs_freq.high_den.reg_X);

% get region names
region_list = reg_names{1};
for reg = 2:length(reg_names)
    region_list = strcat(region_list,{' - '},reg_names{reg});
end
if length(reg_names) == 1
    region_list = {region_list};
end

% %%%%%%%%%%%%%%%%%%%
% OPTIC FLOW DENSITY

% Plot matrices in BETA range
fig = figure;
imagesc(coh_ij.high_den.beta) % high density
colorbar
title(sprintf("Monkey: %s, high density, BETA, Region(s): %s ",monkey,region_list{1}),'FontSize',10)
ylabel('region i')
xlabel('region j')
set(gcf, 'Position',  [100, 500, 500, 400])

fname = strcat(dir_out_beta,sprintf('coh_ij_high_den_beta_%s.png',monkey));
saveas(fig,fname)


fig = figure;
imagesc(coh_ij.low_den.beta) % low density
colorbar
title(sprintf("Monkey: %s, low density, BETA, Region(s): %s ",monkey,region_list{1}),'FontSize',10)
ylabel('region i')
xlabel('region j')
set(gcf, 'Position',  [100, 500, 500, 400])

fname = strcat(dir_out_beta,sprintf('coh_ij_low_den_beta_%s.png',monkey));
saveas(fig,fname)

% DIFFERENCE high - low density
MAX = max(max(coh_ij.high_den.beta-coh_ij.low_den.beta));
MIN = min(min(coh_ij.high_den.beta-coh_ij.low_den.beta));

fig = figure;
imagesc(coh_ij.high_den.beta-coh_ij.low_den.beta) % Difference high-low density
colorbarpwn(MIN, MAX)
title(sprintf("Monkey: %s, high-low density, BETA, Region(s): %s ",monkey,region_list{1}),'FontSize',10)
ylabel('region i')
xlabel('region j')
set(gcf, 'Position',  [100, 500, 500, 400])

fname = strcat(dir_out_beta,sprintf('coh_ij_difference_beta_%s.png',monkey));
saveas(fig,fname)

% ------------------------------

% Plot matrices in THETA range
fig = figure;
imagesc(coh_ij.high_den.theta) % high density
colorbar
title(sprintf("Monkey: %s, high density, THETA, Region(s): %s ",monkey,region_list{1}),'FontSize',10)
ylabel('region i')
xlabel('region j')
set(gcf, 'Position',  [100, 500, 500, 400])

fname = strcat(dir_out_theta,sprintf('coh_ij_high_den_theta_%s.png',monkey));
saveas(fig,fname)


fig = figure;
imagesc(coh_ij.low_den.theta) % low density
colorbar
title(sprintf("Monkey: %s, low density, THETA, Region(s): %s ",monkey,region_list{1}),'FontSize',10)
ylabel('region i')
xlabel('region j')
set(gcf, 'Position',  [100, 500, 500, 400])

fname = strcat(dir_out_theta,sprintf('coh_ij_low_den_theta_%s.png',monkey));
saveas(fig,fname)


% DIFFERENCE high - low density
MAX = max(max(coh_ij.high_den.theta - coh_ij.low_den.theta));
MIN = min(min(coh_ij.high_den.theta - coh_ij.low_den.theta));

fig = figure;
imagesc(coh_ij.high_den.theta - coh_ij.low_den.theta) % Difference high-low density
colorbarpwn(MIN, MAX)   
title(sprintf("Monkey: %s, high-low density, THETA, Region(s): %s ",monkey,region_list{1}),'FontSize',10)
ylabel('region i')
xlabel('region j')
set(gcf, 'Position',  [100, 500, 500, 400])

fname = strcat(dir_out_theta,sprintf('coh_ij_difference_theta_%s.png',monkey));
saveas(fig,fname)


% -------------------

% %%%%%%%%%%%%%%%%%%%
% REWARDS

% Plot matrices in RWD range BETA
fig = figure;
imagesc(coh_ij.rwd(1).beta) % rwd 1 
colorbar
title(sprintf("Monkey: %s, rwd 1 BETA, Region(s): %s ",monkey,region_list{1}),'FontSize',10)
ylabel('region i')
xlabel('region j')
set(gcf, 'Position',  [100, 500, 500, 400])

fname = strcat(dir_out_beta,sprintf('coh_ij_rwd_1_beta_%s.png',monkey));
saveas(fig,fname)


fig = figure;
imagesc(coh_ij.rwd(2).beta) % rwd 2
colorbar
title(sprintf("Monkey: %s, rwd 2 BETA, Region(s): %s ",monkey,region_list{1}),'FontSize',10)
ylabel('region i')
xlabel('region j')
set(gcf, 'Position',  [100, 500, 500, 400])


fname = strcat(dir_out_beta,sprintf('coh_ij_rwd_2_beta_%s.png',monkey));
saveas(fig,fname)


% DIFFERENCE rwd 2 - rwd 1
MAX = max(max(coh_ij.rwd(2).beta - coh_ij.rwd(1).beta));
MIN = min(min(coh_ij.rwd(2).beta - coh_ij.rwd(1).beta));

fig = figure;
imagesc(coh_ij.rwd(2).beta - coh_ij.rwd(1).beta) % Difference rwd 2 rwd 1 density
colorbarpwn(MIN, MAX)
title(sprintf("Monkey: %s, diff rwd 2-1 BETA, Region(s): %s ",monkey,region_list{1}),'FontSize',10)
ylabel('region i')
xlabel('region j')
set(gcf, 'Position',  [100, 500, 600, 500])

fname = strcat(dir_out_beta,sprintf('coh_ij_rwd_difference_beta_%s.png',monkey));
saveas(fig,fname)


% -------------------

% Plot matrices in RWD range THETA
fig = figure;
imagesc(coh_ij.rwd(1).theta) % rwd 1 
colorbar
title(sprintf("Monkey: %s, rwd 1 THETA, Region(s): %s ",monkey,region_list{1}),'FontSize',10)
ylabel('region i')
xlabel('region j')
set(gcf, 'Position',  [100, 500, 500, 400])

fname = strcat(dir_out_theta,sprintf('coh_ij_rwd_1_theta_%s.png',monkey));
saveas(fig,fname)


fig = figure;
imagesc(coh_ij.rwd(2).theta) % rwd 2
colorbar
title(sprintf("Monkey: %s, rwd 2 THETA, Region(s): %s ",monkey,region_list{1}),'FontSize',10)
ylabel('region i')
xlabel('region j')
set(gcf, 'Position',  [100, 500, 500, 400])

fname = strcat(dir_out_theta,sprintf('coh_ij_rwd_2_theta_%s.png',monkey));
saveas(fig,fname)


% DIFFERENCE rwd 2 - rwd 1
MAX = max(max(coh_ij.rwd(2).theta - coh_ij.rwd(1).theta));
MIN = min(min(coh_ij.rwd(2).theta - coh_ij.rwd(1).theta));

fig = figure;
imagesc(coh_ij.rwd(2).theta - coh_ij.rwd(1).theta) % Difference rwd 2 rwd 1 density
colorbarpwn(MIN, MAX)
title(sprintf("Monkey: %s, diff rwd 2-1 THETA, Region(s): %s ",monkey,region_list{1}),'FontSize',10)
ylabel('region i')
xlabel('region j')
set(gcf, 'Position',  [100, 500, 600, 500])

fname = strcat(dir_out_theta,sprintf('coh_ij_rwd_difference_beta_%s.png',monkey));
saveas(fig,fname)





