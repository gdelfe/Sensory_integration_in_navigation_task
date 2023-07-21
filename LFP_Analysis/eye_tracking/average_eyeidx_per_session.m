

function eyesess = average_eyeidx_per_session(eyeinter,sess_range)


for sess = sess_range
    
    
    ntrials_NR = length(eyeinter(sess).rwd(1).trial); % trials no reward length
    ntrials_R = length(eyeinter(sess).rwd(2).trial); % trials reward length
    
    % %%%%%%%%%%%%%%%%%%
    % Non-rewarded trials 
    % %%%%%%%%%%%%%%%%%%
    
    EI_sess = [];
    for trial = 1:ntrials_NR
        
        EI = eyeinter(sess).rwd(1).trial(trial).idx;
        EI_sess = [EI_sess; EI];
    end
    
    eyesess(sess).rwd(1).avg = mean(EI_sess);
    eyesess(sess).rwd(1).std = std(EI_sess);
    eyesess(sess).rwd(1).n_trials = ntrials_NR;
    
    
    % %%%%%%%%%%%%%%%%%%
    % Rewarded trials 
    % %%%%%%%%%%%%%%%%%%
    
    EI_sess = [];
    for trial = 1:ntrials_R
        
        EI = eyeinter(sess).rwd(2).trial(trial).idx;
        EI_sess = [EI_sess; EI];
    end
    
    eyesess(sess).rwd(2).avg = mean(EI_sess);
    eyesess(sess).rwd(2).std = std(EI_sess);
    eyesess(sess).rwd(2).n_trials = ntrials_R;
      
end

end