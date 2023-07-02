% clear all; close all;

monkey = "Quigley";
% load('E:\Output\GINO\experiments_lfp_Bruno_41_42_43_behv_lfps.mat')
% load('E:\Output\GINO\experiments_lfp_Quigley_185_188_207_behv_lfps.mat')
% load('E:\Output\GINO\experiments_lfp_Schro_86_107_113_behv_lfps.mat')
% load('E:\Output\GINO\experiments_lfp_Vik_1_2_4_behv_lfps_cleaned.mat')
dir_out = 'E:\Output\GINO\stats\mobile_stationary\';
sess_range = [1,2,3];

stationary = [];
mobile = [];
task = [];

% create task variable with mobile and stationary trials
for sess = sess_range
    
    nch = length(experiments.sessions(sess).lfps); % number of channels
    for chnl = 1:nch
        
        area  = experiments.sessions(sess).lfps(chnl).brain_area; % get brain area
        area = string(area);
        task(sess).region.(area).ch(chnl).stationary = experiments.sessions(sess).lfps(chnl).stationary;
        task(sess).region.(area).ch(chnl).mobile = experiments.sessions(sess).lfps(chnl).mobile;
        
    end
    
end

% remove empty fields  from task
task = remove_empty_fields_task(task);

save(strcat(dir_out,sprintf('task_%s_mobile_stationary.mat',monkey)),'task','-v7.3');


