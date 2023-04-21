
% This code removes bad trials in the monkey VIK. Bad trials are those with
% "too many" NaN values. After visual investigation, I find that it is
% enough just to remove two trials in total, each one from two different
% sessions: in session 1, rwd 2, we remove trial 600, in session 2, rwd 1, we remove trial
% 326.
%
% The new structure experiment is then save with the same name of the
% original one.
%
% Gino Del Ferraro, NYU, Feb 2023.

clear all; close all;
% clearvars -except experiments

monkey = "Vik";
load('E:\Output\GINO\experiments_lfp_Vik_1_2_4_behv_lfps.mat')
% load('E:\Output\GINO\stats\stats_Vik_v2.mat')
dir_out = 'E:\Output\GINO\stats\';

sess_range = [1,2,3];
rwd_range = [1,2];

% structure which contains all the trials to be removed in "stop" event due to NaN
remove.session(1).rwd(1).trials = [];
remove.session(1).rwd(2).trials = [300,600];
remove.session(2).rwd(1).trials = 326;
remove.session(2).rwd(2).trials = [888,1162];
remove.session(3).rwd(1).trials = 494;
remove.session(3).rwd(2).trials = [650,847];


nch = size(experiments.sessions(1).lfps,2); % # of total channels
% experiments = exp;
EventType = ["stop"];


for sess = sess_range
    exp.sessions(sess).behaviours = experiments.sessions(sess).behaviours;
    exp.sessions(sess).lfps(1).stats.trialtype.all.events.(EventType).all_freq.lfp_align_ext = experiments.sessions(sess).lfps(1).stats.trialtype.all.events.(EventType).all_freq.lfp_align_ext;
    for r = rwd_range
        exp.sessions(sess).lfps(1).stats.trialtype.reward(r).events.(EventType).all_freq.lfp_align_ext = experiments.sessions(sess).lfps(1).stats.trialtype.reward(r).events.(EventType).all_freq.lfp_align_ext;
    end
end


for sess = sess_range
    
    % remove bad trials from rwd1, rwd2, all
    RW1 = experiments.sessions(sess).behaviours.stats.trialtype.reward(1).trlindx; % trials called reward, include also target ON trials
    RW2 = experiments.sessions(sess).behaviours.stats.trialtype.reward(2).trlindx; % no reward, include also target ON trials
    ALL = experiments.sessions(sess).behaviours.stats.trialtype.all.trlindx; % all trials, DO NOT include target ON trials
    
    ind_RW1 = find(RW1); % indexes trials called reward, include also target ON trials
    ind_RW2 = find(RW2); % indexes no reward, include also target ON trials
    ind_ALL = find(ALL); % indexes of all trials, they do not include target ON trials
    
    remove_1 = remove.session(sess).rwd(1).trials;
    remove_2 = remove.session(sess).rwd(2).trials;
    
    % get the index of the trials to be removed, wrt the RW1 and RW2 indexing
    ind_remove_1 = ind_RW1(remove_1);
    ind_remove_2 = ind_RW2(remove_2);
    remove_all = [ind_remove_1, ind_remove_2]; % concatenate trials to be removed for both rwd 1 and 2

    size(experiments.sessions(sess).behaviours.stats.trialtype.all.trlindx)
    
    experiments.sessions(sess).behaviours.stats.trialtype.reward(1).trlindx(remove_all) = []; % trials called reward, include also target ON trials
    experiments.sessions(sess).behaviours.stats.trialtype.reward(2).trlindx(remove_all) = []; % no reward, include also target ON trials
    experiments.sessions(sess).behaviours.stats.trialtype.all.trlindx(remove_all) = []; % all trials, DO NOT include target ON trials
    experiments.sessions(sess).behaviours.trials(remove_all) = []; % remove trial parameters such as optic flow density, etc...
    
    size(experiments.sessions(sess).behaviours.stats.trialtype.all.trlindx)
    size(experiments.sessions(sess).behaviours.stats.trialtype.reward(1).trlindx)
    size(experiments.sessions(sess).behaviours.stats.trialtype.reward(2).trlindx)
    
    % remove bad trials from LFPs
    for ch = 1:nch %across channels
%         remove_all = [remove_1, remove_2]; % note this is different from remove_all above, it is wrt to the rwd1/rwd2 indexing
        [~,index] = ismember(ind_ALL,remove_all);
        index_all = find(index); % indexes wrt to the all_trial indexing
        experiments.sessions(sess).lfps(ch).stats.trialtype.all.events.(EventType).all_freq.lfp_align_ext(:,index_all) = [];
        for r = rwd_range
            sess, r
            size(experiments.sessions(sess).lfps(1).stats.trialtype.reward(r).events.(EventType).all_freq.lfp_align_ext)
            rem_trials = remove.session(sess).rwd(r).trials;
            experiments.sessions(sess).lfps(ch).stats.trialtype.reward(r).events.(EventType).all_freq.lfp_align_ext(:,rem_trials) = []; % remove trials with NaN
        end
        size(experiments.sessions(sess).lfps(1).stats.trialtype.reward(r).events.(EventType).all_freq.lfp_align_ext)
    end
    
    
    
end

NaN_plots(experiments,"stop",sess_range,rwd_range)

Events = ["target","move","stop"];
% Find NaN across: sessions, events, rewards, channels, and trials
[ts_start, ts_stop] = NaN_ts_start_monkey_density(experiments,"stop",sess_range) % find first time index with no NaN 
ts_start = max(ts_start,-0.9) % end of time series to be analyzed 
ts_stop = min(ts_stop,1.) % end of time series to be analyzed 


save('E:\Output\GINO\experiments_lfp_Vik_1_2_4_behv_lfps_cleaned.mat','experiments','-v7.3');



% sess = 2; r = 1; EventType = "stop";
% size(exp.sessions(sess).lfps(ch).stats.trialtype.reward(r).events.(EventType).all_freq.lfp_align_ext)
% size(experiments.sessions(sess).lfps(ch).stats.trialtype.reward(r).events.(EventType).all_freq.lfp_align_ext)
% 
% 
% RW1 = experiments.sessions(sess).behaviours.stats.trialtype.reward(1).trlindx; % trials called reward, include also target ON trials 
% RW2 = experiments.sessions(sess).behaviours.stats.trialtype.reward(2).trlindx; % no reward, include also target ON trials 
% ALL = experiments.sessions(sess).behaviours.stats.trialtype.all.trlindx;
% 
% 
% 






