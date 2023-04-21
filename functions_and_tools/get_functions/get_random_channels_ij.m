% Get M random channels from each brain region. They will be used to
% compute coherence inter and intra region. Using all the channels in each
% region will take too long (too many computations)
%
% Gino Del Ferraro, NYU, April 2023

function [channels] = get_random_channels_ij(stats_den,reg_names,rand_ch)

channels = zeros(length(reg_names),rand_ch);

for region_i = 1:length(reg_names)
    reg_i = reg_names{region_i}; % region name
    nch = length(stats_den(1).region.(reg_i).event.target.high_den.ch); % number of channels
    ch = randperm(nch);
    ch = ch(1:rand_ch); % take 10 random channels out of all those in the brain region i
    channels(region_i,:) = ch;
end


end