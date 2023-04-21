% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot matrix trial vs time enhancing the NaN values
%
%   OUTPUT: images
%


function NaN_plots_all_trials(experiments,Events,sess_range)
for EventType = Events
    for sess = sess_range
            
            % skip reward = 1 cases (un-rewarded) for reward alignment: all the trials are NaN in this case

                s = experiments.sessions(sess).lfps(1).stats.trialtype.all.events.(EventType).all_freq;
                nch = size(experiments.sessions(sess).lfps,2); % # of total channels
                ts = s.ts_lfp_align_ext;
                
                Y = zeros(size(s.lfp_align_ext));
                for ch = 1:nch % across channels
                    X = experiments.sessions(sess).lfps(ch).stats.trialtype.all.events.(EventType).all_freq.lfp_align_ext; % LFP time x trials
                    Y = Y + isnan(X);
                    NaNtemp = sum(isnan(X')); % count NaN for each trial
                end
                
                figure;
                imagesc(Y')
                colorbar
                title(sprintf('sess = %d, all trials, Event = %s',sess,EventType))
                [x_idx, xtlbl] = ts_x_labels(ts,0.2); % get xticks and xticklabels
                set(gca, 'XTick',x_idx, 'XTickLabel',xtlbl)
                xlabel('time (sec)')
                ylabel('trials')
                grid on
          
    end
end