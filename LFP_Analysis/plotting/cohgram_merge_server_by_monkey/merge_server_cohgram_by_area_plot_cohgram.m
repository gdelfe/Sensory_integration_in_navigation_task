
clear all; close all;
% input and output directories
dir_in = 'E:\Output\GINO\cohgram_all_channels\';
dir_in_phase = 'E:\Output\GINO\phase_PLV\';

monkey = "Schro";


reg_i = "PPC";
reg_j = "PPC"
EventType = "stop";
n_sess = 3;


dir_in = dir_in + monkey + '\' + EventType + '\';
dir_in_phase = dir_in_phase + monkey + '\' + EventType + '\';
dir_out_main = 'E:\Output\GINO\Figures\cohgram_all_channels';

    
    
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


field_names = {'high den NR','high den R', 'low den NR', 'low den R'};


fieldNames = fieldnames(PLV_mean);
for i = 1:numel(fieldNames)
    fieldName = fieldNames{i};
    f_name = field_names{i}; % name of field for Title in Figures
    
    dir_out = strcat(dir_out_main,'\' +reg_i + '_' + reg_j + '\' + EventType + '\' + fieldName + '\');
    if ~exist(dir_out, 'dir')
        mkdir(dir_out)
    end

    % THETA %%%%%%%%%%%%%%%%%%%%%%%
    
    % Phase Locking Value
    PLV_avg_theta = PLV_mean.(fieldName).PLV_theta';
    PLV_sem_theta = (PLV_mean.(fieldName).PLV_std_theta/sqrt((PLV_mean.(fieldName).nch_pairs*PLV_mean.(fieldName).num_trials))).';
    
    % Instantaneous phase difference
    phase_avg_theta = PLV_mean.(fieldName).phase_diff_theta';
    phase_sem_theta = (PLV_mean.(fieldName).phase_diff_std_theta/sqrt((PLV_mean.(fieldName).nch_pairs*PLV_mean.(fieldName).num_trials))).';
    ts = PLV_mean.(fieldName).ts;
    
    % BETA %%%%%%%%%%%%%%%%%%%%%%%
    
    % Phase Locking Value
    PLV_avg_beta = PLV_mean.(fieldName).PLV_beta';
    PLV_sem_beta = (PLV_mean.(fieldName).PLV_std_beta/sqrt((PLV_mean.(fieldName).nch_pairs*PLV_mean.(fieldName).num_trials))).';
    
    % Instantaneous phase difference
    phase_avg_beta = PLV_mean.(fieldName).phase_diff_beta';
    phase_sem_beta = (PLV_mean.(fieldName).phase_diff_std_beta/sqrt((PLV_mean.(fieldName).nch_pairs*PLV_mean.(fieldName).num_trials))).';
    ts = PLV_mean.(fieldName).ts;
    
    ts = ts(1:end-1);
    
    % phase_avg = PLV_tot{1}.high_den_R.phase_diff_theta;
    % phase_sem = PLV_tot{1}.high_den_R.phase_diff_std_theta/sqrt(PLV_tot{1}.high_den_R.nch_pairs).;
    
    % %%%%%%%%%%%%%%%%%
    % FIGURES
    % %%%%%%%%%%%%%%%%%
    
    % THETA %%%%%%%%%%%%%%%%%%%%%%%
    
    % PLV
    fig = figure;
    tvimage(cohgram_mean.high_den_NR.cohgram)
    
    fig_name = strcat(sprintf('%s_PLV_THETA_%s_%s_%s.jpg',monkey,fieldName,reg_i,reg_j));
    saveas(fig,strcat(dir_out,fig_name))
    
    % Phase difference
    fig = figure;
    shadedErrorBar(ts,phase_avg_theta,phase_sem_theta,'lineprops',{'color',"#3385ff"},'patchSaturation',0.4);
    xlabel('time (sec)')
    ylabel('Phase Difference')
    title(sprintf('Phase Difference - Theta - %s - %s, %s - %s',monkey,f_name,reg_i,reg_j))
    
    xline(0,'--k');
    xline(-0.3,'--r'); % target onset
    xline(0,'--k') % target offset
    
    fig_name = strcat(sprintf('%s_Phase_Diff_THETA_%s_%s_%s.jpg',monkey,fieldName,reg_i,reg_j));
    saveas(fig,strcat(dir_out,fig_name))
    
    % BETA %%%%%%%%%%%%%%%%%%%%%%%
    
    
    % PLV
    fig = figure;
    shadedErrorBar(ts,PLV_avg_beta,PLV_sem_beta,'lineprops',{'color',"#ff0000"},'patchSaturation',0.4); hold on
    xlabel('time (sec)')
    ylabel('PLV')
    title(sprintf('PLV - Beta - %s - %s, %s - %s',monkey,f_name,reg_i,reg_j))
    
    xline(-0.3,'--r'); % target onset
    xline(0,'--k') % target offset
    
    fig_name = strcat(sprintf('%s_PLV_BETA_%s_%s_%s.jpg',monkey,fieldName,reg_i,reg_j));
    saveas(fig,strcat(dir_out,fig_name))
    
    % Phase difference
    fig = figure;
    shadedErrorBar(ts,phase_avg_beta,phase_sem_beta,'lineprops',{'color',"#ff8533"},'patchSaturation',0.4);
    xlabel('time (sec)')
    ylabel('Phase Difference')
    title(sprintf('Phase Difference - Beta - %s - %s, %s - %s',monkey,f_name,reg_i,reg_j))
    
    xline(0,'--k');
    xline(-0.3,'--r'); % target onset
    xline(0,'--k') % target offset
    
    fig_name = strcat(sprintf('%s_Phase_Diff_BETA_%s_%s_%s.jpg',monkey,fieldName,reg_i,reg_j));
    saveas(fig,strcat(dir_out,fig_name))
    
end