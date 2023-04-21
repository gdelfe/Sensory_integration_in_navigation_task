
% This function takes the indexing high/low optic flow density and remaps
% it to the indexing for the trials in all_trials.
%
% @ Gino Del Ferraro, March 2023, NYU


function [Hidx_remap, Lidx_remap] = map_high_low_indexes_to_all_trial_indexing(high_ind,low_ind)

ind = sort([high_ind,low_ind]);
Hidx_remap = []; Lidx_remap = [];
for i = high_ind
    Hidx_remap = [Hidx_remap, find(ind==i)];
end 

for i = low_ind
    Lidx_remap = [Lidx_remap, find(ind==i)];
end

end 