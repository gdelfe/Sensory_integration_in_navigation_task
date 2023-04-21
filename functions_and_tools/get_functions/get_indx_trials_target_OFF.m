% This function finds the indexes of the trials (both reward/no reward)
% which have the target always OFF during navigation. 
% INPUT: experiments structure
%
% OUTPUT: ind_1, ind_2: indexes for trial in reward 1 and 2 respectively.
%
% Gino Del Ferraro, NYU, Feb 2023


function [ind_1,ind_2,ind_rwd1,ind_rwd2] = get_indx_trials_target_OFF(experiments,sess)


RW1 = experiments.sessions(sess).behaviours.stats.trialtype.reward(1).trlindx; % trials called reward, include also target ON trials 
RW2 = experiments.sessions(sess).behaviours.stats.trialtype.reward(2).trlindx; % no reward, include also target ON trials 
ALL = experiments.sessions(sess).behaviours.stats.trialtype.all.trlindx; % all trials, DO NOT include target ON trials  

ind_RW1 = find(RW1); % indexes trials called reward, include also target ON trials
ind_RW2 = find(RW2); % indexes no reward, include also target ON trials

% these are the "real" rwd/no rwd trials: without the trials with target always ON
ind_rwd1 = find((ALL + RW1)==2); % indexes trials common to all and rwd1, they are rwd1 trials with target always OFF
ind_rwd2 = find((ALL + RW2)==2); % indexes trials common to all and rwd2, they are rwd2 trials with target always OFF

ind_1 = find(ismember(ind_RW1,ind_rwd1)); % index of trials with target OFF, in RW1 indexing 
ind_2 = find(ismember(ind_RW2,ind_rwd2)); % index of trials with target OFF, in RW2 indexing


end
