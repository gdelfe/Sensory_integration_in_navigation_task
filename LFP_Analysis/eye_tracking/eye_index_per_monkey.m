
% clear all; close all;
dir_in = "E:\Output\GINO\eye_tracking\";

monkey = "Schro";
load(strcat(dir_in,sprintf('%s_eye_tracking.mat',monkey)));
sess_range = [1,2,3];


    
eyeidx = remove_NaN_from_EyeIndex(eyeidx,sess_range)


