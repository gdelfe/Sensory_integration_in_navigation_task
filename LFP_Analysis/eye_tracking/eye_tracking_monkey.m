addpath(genpath('C:\Users\gd2112\Documents\Navigation_task'))
addpath(genpath('C:\Users\gd2112\Documents\MATLAB'))
addpath(genpath('C:\Users\gd2112\Documents\LFP_firefly'))

clear all; close all;
% clearvars -except experiments

% %%%%%%%%%%%%%%%%
% PATHS
% %%%%%%%%%%%%%%%
monkey = "Schro";
load('E:\Output\GINO\experiments_lfp_Schro_86_107_113_behv_lfps.mat')
sess_range = 3;

[eyeidx] = eye_index(experiments,sess_range)