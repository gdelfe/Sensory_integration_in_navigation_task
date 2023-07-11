
% Function which computes the Eye Tracking index as in Neuron paper
% Lakshminarasimhan et al. 2020
%
% Ideal Observer frame of reference and Monkey frame of reference are
% computed in order to compute the eye tracking index/score
% 
% INPUT: structure experiments
% OUTPUT: structure eyeidx 
%
% @ Gino Del Ferraro, July 2023 

function [eyeidx] = eye_index(experiments)

for sess = 1:sess_range
    ntrials = size(experiments.sessions(sess).behaviours.stats.pos_rel.x_targ,2);
    
    for i = 1:ntrials
        
        % spike 2 frame of reference
        x = experiments.sessions(sess).behaviours.stats.pos_rel.x_targ{i};
        y = experiments.sessions(sess).behaviours.stats.pos_rel.y_targ{i};
        z = 10;
        
        % Ideal Observer frame of reference
        [IOx,IOy,IOx,IOy] = world2eye(x,y,-z,0); % delta is zero, so left and right are the same values
        
        % Monkey frame of reference
        xl = experiments.sessions(sess).behaviours.trials(i).continuous.yle; % left eye x
        xr = experiments.sessions(sess).behaviours.trials(i).continuous.yre; % right eye x
        
        yl = experiments.sessions(sess).behaviours.trials(i).continuous.zle; % left eye y
        yr = experiments.sessions(sess).behaviours.trials(i).continuous.zre; % right eye y
        
        % Average Left and Right eye - Monkey frame of reference
        xm = (xl+xr)/2;
        ym = (yl+yr)/2;
        
        ts = experiments.sessions(sess).behaviours.trials(i).continuous.ts';
        
        error = (IOx - xm).^2 + (IOy - ym).^2; % error between Monkey and Ideal observer frame of reference
        IO = (IOx.^2 + IOy.^2);
        % eye tracking index
        EI = sqrt( 1 - error./IO)';
        
        eyeidx(sess).trial(i).idx = EI;
        eyeidx(sess).trial(i).ts = ts;
        
    end
    
end


end 


