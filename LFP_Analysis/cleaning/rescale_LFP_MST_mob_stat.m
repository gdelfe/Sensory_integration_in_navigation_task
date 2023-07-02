% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rescale LFP in MST region by a factor 1000
%

function task = rescale_LFP_MST_mob_stat(task,sess_range)


for sess = sess_range
    nch = size(task(sess).region.MST.ch,2); % number of channels (same for reward = 0/1, event = target/move)
    for chnl = 1:nch
        ntrials = size(task(sess).region.MST.ch(1).stationary,2);
        for trial = 1:ntrials
            % rescale LFP in MST by a factor 1000
            
            %stationary trials
            Xs = task(sess).region.MST.ch(chnl).stationary(trial).lfp;
            Xs = Xs*1e3;
            task(sess).region.MST.ch(chnl).stationary(trial).lfp = Xs;
            % mobile trials 
            Xm = task(sess).region.MST.ch(chnl).mobile(trial).lfp;
            Xm = Xm*1e3;
            task(sess).region.MST.ch(chnl).mobile(trial).lfp = Xm;
        end
    end
end

end