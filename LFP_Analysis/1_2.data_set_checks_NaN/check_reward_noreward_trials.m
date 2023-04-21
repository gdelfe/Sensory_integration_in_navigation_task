
% Trials called reward/not rewarded include 10% of the trials with target
% always ON. We should remove those from the analysis

RW1 = experiments.sessions(1).behaviours.stats.trialtype.reward(1).trlindx; % trials called reward
RW2 = experiments.sessions(1).behaviours.stats.trialtype.reward(2).trlindx; % no reward 
ALL = experiments.sessions(1).behaviours.stats.trialtype.all.trlindx; % all trials 

RW = RW1 + RW2;
rwd1 = find(RW1);
rwd2 = find(RW2);

sRW1 = length(find(RW1));
sRW2 = length(find(RW2));
sRW = length(find(RW));
sALL = length(find(ALL));




% these are the "real" rwd/no rwd trials: without the trials with target
% always ON
allr1 = find((ALL + RW1)==2); % trials common to all and rwd1
allr2 = find((ALL + RW2)==2); % trials common to all and rwd2

rwd2_targOFF = ismember(rwd2,allr2); % get 1 for trials in rwd2 which are also in allr2, 0 otherwise.