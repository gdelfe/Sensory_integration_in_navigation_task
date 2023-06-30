addpath(genpath('C:\Users\gd2112\Documents\Navigation_task'))
addpath(genpath('C:\Users\gd2112\Documents\MATLAB'))
addpath(genpath('C:\Users\gd2112\Documents\LFP_firefly'))

experiments = experiment('firefly-monkey');
experiments.AddSessions(71,1,{'behv','lfps'})
experiments.AddSessions(71,2,{'behv','lfps'})
experiments.AddSessions(71,4,{'behv','lfps'})
cd('E:\Output\GINO')
disp('   Saving ....')
save('experiments_lfp_Vik_1_2_4_behv_lfps', 'experiments', '-v7.3')
cd('C:\Users\gd2112\Documents\LFP_firefly')
