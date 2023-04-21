
% %%%%%%%%%%%%%%%%
% PATHS
% %%%%%%%%%%%%%%%
addpath(genpath('/scratch/gd2112/GINO_CODES/MATLAB'));
dir_in_null = 'E:\Output\GINO\pseudo_stats\';

% %%%%%%%%%%%%%%%%
% Parameters
% %%%%%%%%%%%%%%%%

monkey = "Bruno";
sess_range = [1,2,3];
Events = ["target","move"];
iterations = 5;
max_ID = 1000;
tot_iter = iterations*max_ID;

load(strcat(dir_in_null,sprintf('\\pseudo_stats_%s_iter_5000.mat',monkey)));
