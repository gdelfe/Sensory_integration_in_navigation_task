% This function goes through all the trial indexes with target always OFF
% (ind_rwd) and checks whether each trial has high/low optic density flow.
% It creates new indexes high/low_ind 
%
% @ Gino Del Ferraro, March 2023, NYU

function [high_ind, low_ind] = get_indx_density(experiments,sess,ind_rwd)
    ind_rwd = sort(ind_rwd);
    high_ind = []; low_ind = [];
    cnt = 0;
    for ind = ind_rwd
        
        d = experiments.sessions(sess).behaviours.trials(ind).prs.floordensity;
        if d >= 0.001
            high_ind = [high_ind,ind];
        elseif d <= 0.0005
            low_ind = [low_ind,ind];
        else
            cnt = cnt+1;
        end

    end

end
