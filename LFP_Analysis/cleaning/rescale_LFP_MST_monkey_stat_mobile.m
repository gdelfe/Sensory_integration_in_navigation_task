% %%%%%%%%%%%%%%%%%%%%%%
% Rescale LFP signal if recorded with linear probe in MST. 
% MST signal should be rescaled by a factor 1000 if recorded in MST. The
% calculation of the PSD and spectrogram is already done with the rescaled
% LFP, here we just rescale the LFP and store it again. 
%


% clear all; close all;

% PATHS
dir_in = 'E:\Output\GINO\stats\mobile_stationary\';
% % PARAMETERS
sess_range = [1,2,3];

for monkey = ["Schro"]
    
    display([monkey])
%     load(strcat(dir_in,sprintf('task_%s_mobile_stationary.mat',monkey)));

    % remove empty fields from the structure stats
    task = rescale_LFP_MST_mob_stat(task,sess_range);
    save(strcat(dir_in,sprintf('task_%s_mobile_stationary.mat',monkey)),'task','-v7.3');

end