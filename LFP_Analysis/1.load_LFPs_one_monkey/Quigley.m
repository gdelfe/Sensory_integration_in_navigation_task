addpath(genpath('C:\Users\gd2112\Documents\Navigation_task'))
addpath(genpath('C:\Users\gd2112\Documents\MATLAB'))
addpath(genpath('C:\Users\gd2112\Documents\LFP_firefly'))


experiments = experiment('firefly-monkey');
% experiments.AddSessions(44,34,{'behv','lfps'})
experiments.AddSessions(44,185,{'behv','lfps'})
experiments.AddSessions(44,188,{'behv','lfps'})
experiments.AddSessions(44,207,{'behv','lfps'})
cd('E:\Output\GINO')
disp('   Saving ....')
save('experiments_lfp_Quigley_185_188_207_behv_lfps', 'experiments', '-v7.3')
% save('experiments_lfp_Quigley_34_behv_lfps', 'experiments', '-v7.3')
cd('C:\Users\gd2112\Documents\LFP_firefly')
