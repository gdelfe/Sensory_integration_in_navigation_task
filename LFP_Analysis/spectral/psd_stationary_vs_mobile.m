
monkey = "Quigley";
% load('E:\Output\GINO\experiments_lfp_Bruno_41_42_43_behv_lfps.mat')
load('E:\Output\GINO\experiments_lfp_Quigley_185_188_207_behv_lfps.mat')
load('E:\Output\GINO\experiments_lfp_Schro_86_107_113_behv_lfps.mat')
% load('E:\Output\GINO\stats\stats_Bruno_v2.mat')
dir_out = 'E:\Output\GINO\stats\';
sess_range = [1,2,3];

stationary = [];
mobile = [];

for sess = sess_range
    
    nch = length(experiments.sessions(sess).lfps); % number of channels
    for chnl = 1:nch
        
        area  = experiments.sessions(sess).lfps(chnl).brain_area; % get brain area
        area = string(area);
        task(sess).region.(area).ch(chnl).stationary = experiments.sessions(sess).lfps(chnl).stationary;
        task(sess).region.(area).ch(chnl).mobile = experiments.sessions(sess).lfps(chnl).mobile;
        
    end
    
end


