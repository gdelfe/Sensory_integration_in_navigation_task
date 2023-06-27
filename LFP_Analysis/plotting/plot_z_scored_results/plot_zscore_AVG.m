

clear all; close all;

dir_out_z_score = 'E:\Output\GINO\zscored_stats\p_th_0.05\';

p_th = 0.05;
Events = ["target","stop"];

load(strcat(dir_out_z_score,sprintf('zscored_AVERAGE_stats_p_th_%.2f_diff_rwd_norwd.mat',p_th)));
