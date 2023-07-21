
function plot_per_trial(eyeinter,sess_range)

for sess = sess_range
   
    ntrials_NR = length(eyeinter(sess).rwd(1).trial); % trials no reward length
    ntrials_R = length(eyeinter(sess).rwd(2).trial); % trials reward length
    
    figure;  
    for trial = 1:ntrials_NR
        EI = eyeinter(sess).rwd(1).trial(trial).idx;
        ts = eyeinter(sess).rwd(1).ts_interp;
        title(sprintf('sess %d, Non-reward',sess))
        plot(ts,EI); hold on
    end 
    hold off
    
    figure;
    for trial = 1:ntrials_R
        EI = eyeinter(sess).rwd(2).trial(trial).idx;
        ts = eyeinter(sess).rwd(2).ts_interp;
        title(sprintf('sess %d, reward',sess))
        plot(ts,EI); hold on
    end
    hold off
    
end

end 