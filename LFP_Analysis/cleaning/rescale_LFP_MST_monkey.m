% %%%%%%%%%%%%%%%%%%%%%%
% Rescale LFP signal if recorded with linear probe in MST. 
% MST signal should be rescaled by a factor 1000 if recorded in MST. The
% calculation of the PSD and spectrogram is already done with the rescaled
% LFP, here we just rescale the LFP and store it again. 
%


clear all; close all;

% PATHS
dir_in = 'E:\Output\GINO\stats\';
% % PARAMETERS
Events = ["target","stop"];
sess_range = [1,2,3];

for monkey = ["Schro"]
    display([monkey])
    load(strcat(dir_in,sprintf('stats_%s_all_events.mat',monkey)));
    % remove empty fields from the structure stats
    stats = rescale_LFP_MST(stats,Events,sess_range)
    save(strcat(dir_in,sprintf('stats_%s_all_events.mat',monkey)),'stats','-v7.3');
end