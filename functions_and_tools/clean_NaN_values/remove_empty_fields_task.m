% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function deletes empty fields in the stats task which contains mobile
% and stationary lfps.
%
% INPUT: structure task
% OUTPUT: structure task without empty fields
%
% @ Gino Del Ferraro, NYU, Jan 2023.

function task = remove_empty_fields_task(task)

reg_names = fieldnames(task(1).region); % list of recorded brain regions (same for all sessions)

for region = 1:length(reg_names)
    reg = reg_names{region}; % get region name
    nch = length(task(1).region.(reg).ch); % number of channels (same for reward = 0/1, event = target/move)
    
    for chnl = nch:-1:1
        if isempty(task(1).region.(reg).ch(chnl).stationary)
            task(1).region.(reg).ch(chnl) = [];
            task(2).region.(reg).ch(chnl) = [];
            task(3).region.(reg).ch(chnl) = [];
            
        end
    end
end

end