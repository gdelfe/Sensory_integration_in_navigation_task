% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot matrix trial vs time enhancing the NaN values
%
%   OUTPUT: images
%


function NaN_plots(experiments,Events,sess_range,rwd_range)
for EventType = Events
    for sess = sess_range
        for rwd = rwd_range
            
            % skip reward = 1 cases (un-rewarded) for reward alignment: all the trials are NaN in this case

                s = experiments.sessions(sess).lfps(1).stats.trialtype.reward(rwd).events.(EventType).all_freq;
                nch = size(experiments.sessions(sess).lfps,2); % # of total channels
                ts = s.ts_lfp_align_ext;
                
                Y = zeros(size(s.lfp_align_ext));
                for ch = 1:nch % across channels
                    X = experiments.sessions(sess).lfps(ch).stats.trialtype.reward(rwd).events.(EventType).all_freq.lfp_align_ext; % LFP time x trials
                    Y = Y + isnan(X);
                    NaNtemp = sum(isnan(X')); % count NaN for each trial
                end
                
                figure;
                imagesc(Y')
                colorbar
                title(sprintf('sess = %d, rwd = %d, Event = %s',sess,rwd,EventType))
                [x_idx, xtlbl] = ts_x_labels(ts,0.5); % get xticks and xticklabels
%                 set(gca, 'XTick',x_idx, 'XTickLabel',xtlbl)
                xlabel('time (sec)')
                ylabel('trials')
                grid on
            
        end
    end
end