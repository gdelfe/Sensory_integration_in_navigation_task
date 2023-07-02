clear all; close all;

addpath(genpath('C:\Users\gd2112\Documents\Navigation_task'))
addpath(genpath('C:\Users\gd2112\Documents\MATLAB'))
addpath(genpath('C:\Users\gd2112\Documents\LFP_firefly'))

experiments = experiment('firefly-monkey');
experiments.AddSessions(53,86,{'behv','lfps'})
experiments.AddSessions(53,107,{'behv','lfps'})
experiments.AddSessions(53,113,{'behv','lfps'})
cd('E:\Output\GINO')
disp('   Saving ....')
save('experiments_lfp_Schro_86_107_113_behv_lfps', 'experiments', '-v7.3')
cd('C:\Users\gd2112\Documents\LFP_firefly')


