
addpath(genpath('C:\Users\gd2112\Documents\LFP_firefly'))
addpath(genpath('C:\Users\gd2112\Documents\MATLAB'))

experiments = experiment('firefly-monkey');
experiments.AddSessions(53,86,{'behv','lfps'})
experiments.AddSessions(53,107,{'behv','lfps'})
experiments.AddSessions(53,113,{'behv','lfps'})
cd('E:\Output\GINO')
disp('   Saving ....')
save('experiments_lfp_Schro_86_107_113_behv_lfps', 'experiments', '-v7.3')
cd('C:\Users\gd2112\Documents\LFP_firefly')


