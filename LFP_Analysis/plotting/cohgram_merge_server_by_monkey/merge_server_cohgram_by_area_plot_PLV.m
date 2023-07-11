% Merge coherence, PLV, phase difference results across sessions for a
% given monkey. Compute mean and std of such quantities across sessions.

clear all; close all;
% input and output directories
dir_in = 'E:\Output\GINO\cohgram_all_channels\';
dir_in_phase = 'E:\Output\GINO\phase_PLV\';

monkey = "Schro";

reg_i = "PFC";
reg_j = "PFC"
EventType = "target";
n_sess = 3;


dir_in = dir_in + monkey + '\' + EventType + '\';
dir_in_phase = dir_in_phase + monkey + '\' + EventType + '\';
dir_out_main = 'E:\Output\GINO\Figures\PLV_phase_diff';
dir_out_PLV_data_avg = 'E:\Output\GINO\phase_PLV\averages\';
dir_out_coh_data_avg = 'E:\Output\GINO\coherence\avg_by_area\';

dir_fig = 'E:\Output\GINO\Figures\PLV_phase_diff\all_together\';
    
dir_out_PLV_data_avg = strcat(dir_out_PLV_data_avg, reg_i + '_' + reg_j + '\');
if ~exist(dir_out_PLV_data_avg, 'dir')
    mkdir(dir_out_PLV_data_avg)
end
dir_out_coh_data_avg = strcat(dir_out_coh_data_avg, reg_i + '_' + reg_j + '\');
if ~exist(dir_out_coh_data_avg, 'dir')
    mkdir(dir_out_coh_data_avg)
end

dir_fig = strcat(dir_fig, reg_i + '_' + reg_j + '\');
if ~exist(dir_fig, 'dir')
    mkdir(dir_fig)
end

PLV_tot = {};
cohgram_tot =[];


% Load data across sessions for one monkey
for sess = 1:n_sess
    
    load(strcat(dir_in,sprintf('coherencegram_%s_sess_%d_event_%s_%s_%s.mat',monkey,sess,EventType,reg_i,reg_i)));
    load(strcat(dir_in_phase,sprintf('PLV_phase_%s_sess_%d_event_%s_%s_%s.mat',monkey,sess,EventType,reg_i,reg_i)));
    PLV_tot{sess} = PLV_sess;
    cohgram_tot{sess} = coherencegram;
    clear coherencegram
    
end

% Means across sessions
[cohgram_mean, PLV_mean] = PLV_and_cohgram_mean_std_across_sessions(PLV_tot,cohgram_tot,n_sess);

f_name = strcat(sprintf('%s_PLV_Phase_diff_high_low_rwd_norwd_%s_%s.mat',monkey,reg_i,reg_j));
save(strcat(dir_out_PLV_data_avg,f_name),'PLV_mean');

f_name = strcat(sprintf('%s_coherence_and_phase_high_low_rwd_norwd_%s_%s.mat',monkey,reg_i,reg_j));
save(strcat(dir_out_coh_data_avg,f_name),'cohgram_mean');

field_names = {'high den NR','high den R', 'low den NR', 'low den R'};

% Plot PLV and phase difference mean across sessions for both theta and
% beta band 

% fieldNames = fieldnames(PLV_mean);
% for i = 1:numel(fieldNames)
%     fieldName = fieldNames{i};
%     f_name = field_names{i}; % name of field for Title in Figures
%     
%     dir_out = strcat(dir_out_main,'\' +reg_i + '_' + reg_j + '\' + EventType + '\' + fieldName + '\');
%     if ~exist(dir_out, 'dir')
%         mkdir(dir_out)
%     end
% 
%     % THETA %%%%%%%%%%%%%%%%%%%%%%%
%     
%     % Phase Locking Value
%     PLV_avg_theta = PLV_mean.(fieldName).PLV_theta';
%     PLV_sem_theta = (PLV_mean.(fieldName).PLV_std_theta/sqrt((PLV_mean.(fieldName).nch_pairs*PLV_mean.(fieldName).num_trials))).';
%     
%     % Instantaneous phase difference
%     phase_avg_theta = PLV_mean.(fieldName).phase_diff_theta';
%     phase_sem_theta = (PLV_mean.(fieldName).phase_diff_std_theta/sqrt((PLV_mean.(fieldName).nch_pairs*PLV_mean.(fieldName).num_trials))).';
%     ts = PLV_mean.(fieldName).ts;
%     
%     % BETA %%%%%%%%%%%%%%%%%%%%%%%
%     
%     % Phase Locking Value
%     PLV_avg_beta = PLV_mean.(fieldName).PLV_beta';
%     PLV_sem_beta = (PLV_mean.(fieldName).PLV_std_beta/sqrt((PLV_mean.(fieldName).nch_pairs*PLV_mean.(fieldName).num_trials))).';
%     
%     % Instantaneous phase difference
%     phase_avg_beta = PLV_mean.(fieldName).phase_diff_beta';
%     phase_sem_beta = (PLV_mean.(fieldName).phase_diff_std_beta/sqrt((PLV_mean.(fieldName).nch_pairs*PLV_mean.(fieldName).num_trials))).';
%     ts = PLV_mean.(fieldName).ts;
%     
%     ts = ts(1:end-1);
%     
%     % phase_avg = PLV_tot{1}.high_den_R.phase_diff_theta;
%     % phase_sem = PLV_tot{1}.high_den_R.phase_diff_std_theta/sqrt(PLV_tot{1}.high_den_R.nch_pairs).;
%     
%     % %%%%%%%%%%%%%%%%%
%     % FIGURES
%     % %%%%%%%%%%%%%%%%%
%     
%     % THETA %%%%%%%%%%%%%%%%%%%%%%%
%     
%     % PLV
%     fig = figure;
%     shadedErrorBar(ts,PLV_avg_theta,PLV_sem_theta,'lineprops',{'color',"#003d99"},'patchSaturation',0.4); hold on
%     xlabel('time (sec)')
%     ylabel('PLV')
%     title(sprintf('PLV - Theta - %s - %s, %s - %s',monkey,f_name,reg_i,reg_j))
%     
%     xline(-0.3,'--r'); % target onset
%     xline(0,'--k') % target offset
%     
%     fig_name = strcat(sprintf('%s_PLV_THETA_%s_%s_%s.jpg',monkey,fieldName,reg_i,reg_j));
%     saveas(fig,strcat(dir_out,fig_name))
%     
%     % Phase difference
%     fig = figure;
%     shadedErrorBar(ts,phase_avg_theta,phase_sem_theta,'lineprops',{'color',"#3385ff"},'patchSaturation',0.4);
%     xlabel('time (sec)')
%     ylabel('Phase Difference')
%     title(sprintf('Phase Difference - Theta - %s - %s, %s - %s',monkey,f_name,reg_i,reg_j))
%     
%     xline(0,'--k');
%     xline(-0.3,'--r'); % target onset
%     xline(0,'--k') % target offset
%     
%     fig_name = strcat(sprintf('%s_Phase_Diff_THETA_%s_%s_%s.jpg',monkey,fieldName,reg_i,reg_j));
%     saveas(fig,strcat(dir_out,fig_name))
%     
%     % BETA %%%%%%%%%%%%%%%%%%%%%%%
%     
%     
%     % PLV
%     fig = figure;
%     shadedErrorBar(ts,PLV_avg_beta,PLV_sem_beta,'lineprops',{'color',"#ff0000"},'patchSaturation',0.4); hold on
%     xlabel('time (sec)')
%     ylabel('PLV')
%     title(sprintf('PLV - Beta - %s - %s, %s - %s',monkey,f_name,reg_i,reg_j))
%     
%     xline(-0.3,'--r'); % target onset
%     xline(0,'--k') % target offset
%     
%     fig_name = strcat(sprintf('%s_PLV_BETA_%s_%s_%s.jpg',monkey,fieldName,reg_i,reg_j));
%     saveas(fig,strcat(dir_out,fig_name))
%     
%     % Phase difference
%     fig = figure;
%     shadedErrorBar(ts,phase_avg_beta,phase_sem_beta,'lineprops',{'color',"#ff8533"},'patchSaturation',0.4);
%     xlabel('time (sec)')
%     ylabel('Phase Difference')
%     title(sprintf('Phase Difference - Beta - %s - %s, %s - %s',monkey,f_name,reg_i,reg_j))
%     
%     xline(0,'--k');
%     xline(-0.3,'--r'); % target onset
%     xline(0,'--k') % target offset
%     
%     fig_name = strcat(sprintf('%s_Phase_Diff_BETA_%s_%s_%s.jpg',monkey,fieldName,reg_i,reg_j));
%     saveas(fig,strcat(dir_out,fig_name))
%     
% end


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HIGH DENSITY REWARD AND NO REWARD, LOW DENSITY REWARD AND NO REWARD
% TOGETHER 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ts = PLV_mean.high_den_NR.ts;
ts = ts(1:end-1);
% THETA %%%%%%%%%%%%%%%%%%%%%%%
PLV_avg_theta_HDNR = PLV_mean.high_den_NR.PLV_theta';
PLV_sem_theta_HDNR = (PLV_mean.high_den_NR.PLV_std_theta/sqrt((PLV_mean.high_den_NR.nch_pairs*PLV_mean.high_den_NR.num_trials))).';

PLV_avg_theta_LDNR = PLV_mean.low_den_NR.PLV_theta';
PLV_sem_theta_LDNR = (PLV_mean.low_den_NR.PLV_std_theta/sqrt((PLV_mean.low_den_NR.nch_pairs*PLV_mean.low_den_NR.num_trials))).';

PLV_avg_theta_HDR = PLV_mean.high_den_R.PLV_theta';
PLV_sem_theta_HDR = (PLV_mean.high_den_R.PLV_std_theta/sqrt((PLV_mean.high_den_R.nch_pairs*PLV_mean.high_den_R.num_trials))).';

PLV_avg_theta_LDR = PLV_mean.low_den_R.PLV_theta';
PLV_sem_theta_LDR = (PLV_mean.low_den_R.PLV_std_theta/sqrt((PLV_mean.low_den_R.nch_pairs*PLV_mean.low_den_R.num_trials))).';


% PLV
fig = figure;
shadedErrorBar(ts,PLV_avg_theta_HDNR,PLV_sem_theta_HDNR,'lineprops',{'color',"#b32400"},'patchSaturation',0.4); hold on
shadedErrorBar(ts,PLV_avg_theta_LDNR,PLV_sem_theta_LDNR,'lineprops',{'color',"#ff471a"},'patchSaturation',0.4); hold on
shadedErrorBar(ts,PLV_avg_theta_HDR,PLV_sem_theta_HDR,'lineprops',{'color',"#00b300"},'patchSaturation',0.4); hold on
shadedErrorBar(ts,PLV_avg_theta_LDR,PLV_sem_theta_LDR,'lineprops',{'color',"#4dff4d"},'patchSaturation',0.4); hold on
xlabel('time (sec)')
ylabel('PLV')
title(sprintf('%s - PLV - Theta - %s - %s',monkey,reg_i,reg_j))

% xline(-0.3,'--r'); % target onset
% xline(0,'--k') % target offset

% Create gray box
grayBoxX = [-0.3, -0.3, 0, 0];
grayBoxY = [ylim, fliplr(ylim)];
grayBoxColor = [0.7 0.7 0.7]; % Gray color (adjust as needed)
patch(grayBoxX, grayBoxY, grayBoxColor, 'EdgeColor', 'none', 'FaceAlpha', 0.3);

legend('High den NO RWD','Low den NO RWD','High den RWD','Low den RWD');

fig_name = strcat(sprintf('%s_PLV_THETA_all_together_%s_%s.png',monkey,reg_i,reg_j));
saveas(fig,strcat(dir_fig,fig_name))


% BETA %%%%%%%%%%%%%%%%%%%%%%%

PLV_avg_beta_HDNR = PLV_mean.high_den_NR.PLV_beta';
PLV_sem_beta_HDNR = (PLV_mean.high_den_NR.PLV_std_beta/sqrt((PLV_mean.high_den_NR.nch_pairs*PLV_mean.high_den_NR.num_trials))).';

PLV_avg_beta_LDNR = PLV_mean.low_den_NR.PLV_beta';
PLV_sem_beta_LDNR = (PLV_mean.low_den_NR.PLV_std_beta/sqrt((PLV_mean.low_den_NR.nch_pairs*PLV_mean.low_den_NR.num_trials))).';

PLV_avg_beta_HDR = PLV_mean.high_den_R.PLV_beta';
PLV_sem_beta_HDR = (PLV_mean.high_den_R.PLV_std_beta/sqrt((PLV_mean.high_den_R.nch_pairs*PLV_mean.high_den_R.num_trials))).';

PLV_avg_beta_LDR = PLV_mean.low_den_R.PLV_beta';
PLV_sem_beta_LDR = (PLV_mean.low_den_R.PLV_std_beta/sqrt((PLV_mean.low_den_R.nch_pairs*PLV_mean.low_den_R.num_trials))).';


fig = figure;
shadedErrorBar(ts,PLV_avg_beta_HDNR,PLV_sem_beta_HDNR,'lineprops',{'color',"#b32400"},'patchSaturation',0.4); hold on
shadedErrorBar(ts,PLV_avg_beta_LDNR,PLV_sem_beta_LDNR,'lineprops',{'color',"#ff471a"},'patchSaturation',0.4); hold on
shadedErrorBar(ts,PLV_avg_beta_HDR,PLV_sem_beta_HDR,'lineprops',{'color',"#00b300"},'patchSaturation',0.4); hold on
shadedErrorBar(ts,PLV_avg_beta_LDR,PLV_sem_beta_LDR,'lineprops',{'color',"#4dff4d"},'patchSaturation',0.4); hold on
xlabel('time (sec)')
ylabel('PLV')
title(sprintf('%s - PLV - Beta - %s - %s',monkey,reg_i,reg_j))

% xline(-0.3,'--r'); % target onset
% xline(0,'--k') % target offset

% Create gray box
grayBoxX = [-0.3, -0.3, 0, 0];
grayBoxY = [ylim, fliplr(ylim)];
grayBoxColor = [0.7 0.7 0.7]; % Gray color (adjust as needed)
patch(grayBoxX, grayBoxY, grayBoxColor, 'EdgeColor', 'none', 'FaceAlpha', 0.3);

legend('High den NO RWD','Low den NO RWD','High den RWD','Low den RWD');

fig_name = strcat(sprintf('%s_PLV_BETA_all_together_%s_%s.png',monkey,reg_i,reg_j));
saveas(fig,strcat(dir_fig,fig_name))




