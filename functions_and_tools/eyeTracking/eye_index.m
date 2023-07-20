
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

function [eyeidx] = eye_index(experiments,sess_range)

for sess = sess_range
    ntrials = size(experiments.sessions(sess).behaviours.stats.pos_rel.x_targ,2);
  
    for i = 1:ntrials
        
        % spike 2 frame of reference
        x = experiments.sessions(sess).behaviours.stats.pos_rel.x_targ{i};
        y = experiments.sessions(sess).behaviours.stats.pos_rel.y_targ{i};
        z = 10;
        delta = 3.5; % inter-ocular distance 
        
        % Ideal Observer frame of reference
        [IOxle,IOyle,IOxre,IOyre] = world2eye(x,y,-z,delta); % delta is zero, so left and right are the same values
        % average left and right eye for ideal observer
        IOx = (IOxle + IOxre)/2;
        IOy = (IOyle + IOyre)/2;
        
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
        EI2 = ( 1 - error./IO)'; % in order to have the eye-tracking index we need to take the sqrt of this. Note: negative values of EI2 should be considere invalid
        
        
        
        
        
%         figure;
%         plot(ts,) 
%         
        eyeidx(sess).trial(i).idx = EI2;
        eyeidx(sess).trial(i).ts = ts;
        
    end
    
end


end 


