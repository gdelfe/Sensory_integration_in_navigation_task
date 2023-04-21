% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function deletes empty fields in the stats structure. These field
% come from the labelling of the channels in monkeys having more than one
% recorded area. This is for the case with optic flow density change
%
% INPUT: structure stats
% OUTPUT: structure stats without empty fields
%
% @ Gino Del Ferraro, NYU, Jan 2023.

function stats = remove_empty_fields_density(stats,Events)

reg_names = fieldnames(stats(1).region); % list of recorded brain regions (same for all sessions)
density = ["high_den","low_den"];

for region = 1:length(reg_names)
    disp(['region ',num2str(region)])
    reg = reg_names{region}; % get region name
    nch = length(stats(1).region.(reg).event.target.lfp.ch); % number of channels (same for reward = 0/1, event = target/move)
    for EventType = Events
        disp(['Event :',num2str(EventType)])
        for chnl = nch:-1:1
            if isempty(stats(1).region.(reg).event.(EventType).lfp.ch(chnl).lfp)
                stats(1).region.(reg).event.(EventType).lfp.ch(chnl) = [];
                stats(2).region.(reg).event.(EventType).lfp.ch(chnl) = [];
                stats(3).region.(reg).event.(EventType).lfp.ch(chnl) = [];
                for den = density
                    stats(1).region.(reg).event.(EventType).(den).ch(chnl) = [];
                    stats(2).region.(reg).event.(EventType).(den).ch(chnl) = [];
                    stats(3).region.(reg).event.(EventType).(den).ch(chnl) = [];
                end
            end
        end
    end
end

end