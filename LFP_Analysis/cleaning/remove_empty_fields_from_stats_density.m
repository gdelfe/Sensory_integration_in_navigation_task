% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Remove empty fields from stats structure and resave them without empty
% fields
%
% Gino Del Ferraro, NYU, Jan 23


clear all; close all;

% PATHS
dir_in = 'E:\Output\GINO\stats\';
% % PARAMETERS
Events = ["target","move","stop"];

for monkey = ["Vik"]
    display([monkey])
    load(strcat(dir_in,sprintf('stats_%s_all_events_density.mat',monkey)));
    % remove empty fields from the structure stats
    stats = remove_empty_fields_density(stats,Events)
    save(strcat(dir_in,sprintf('stats_%s_all_events_density_clean.mat',monkey)),'stats','-v7.3');
end