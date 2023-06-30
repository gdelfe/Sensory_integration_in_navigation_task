% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function deletes empty fields in the stats structure. These field
% come from the labelling of the channels in monkeys having more than one
% recorded area.
%
% INPUT: structure stats
% OUTPUT: structure stats without empty fields
%
% @ Gino Del Ferraro, NYU, Jan 2023.

function stats = remove_empty_fields(stats,Events)

reg_names = fieldnames(stats(1).region); % list of recorded brain regions (same for all sessions)

for region = 1:length(reg_names)
    reg = reg_names{region}; % get region name
    nch = length(stats(1).region.(reg).event.reward.rwd(1).ch); % number of channels (same for reward = 0/1, event = target/move)
    for EventType = Events
        for r = 1:2
            for chnl = nch:-1:1
                if isempty(stats(1).region.(reg).event.(EventType).rwd(r).ch(chnl).lfp)
                    stats(1).region.(reg).event.(EventType).rwd(r).ch(chnl) = [];
                    stats(2).region.(reg).event.(EventType).rwd(r).ch(chnl) = [];
                    stats(3).region.(reg).event.(EventType).rwd(r).ch(chnl) = [];
                end
            end
        end
    end
end

end