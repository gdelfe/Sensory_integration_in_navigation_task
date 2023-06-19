% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rescale LFP in MST region by a factor 1000
% 

function stats = rescale_LFP_MST(stats,Events,sess_range)


for sess = sess_range
    nch = length(stats(1).region.MST.event.target.rwd(1).ch); % number of channels (same for reward = 0/1, event = target/move)
    for EventType = Events
        for r = 1:2
            for chnl = 1:nch
                % rescale LFP in MST by a factor 1000
                X = stats(sess).region.MST.event.(EventType).rwd(r).ch(chnl).lfp;
                X = X*1e3;
                stats(sess).region.MST.event.(EventType).rwd(r).ch(chnl).lfp = X;          
            end
        end
    end
end

end