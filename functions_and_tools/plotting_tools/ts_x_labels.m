%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Construct time axis labels based on ts_lfp_align_ext
%
% INPUT: ts = ts_lfp_align_ext
%        time step between labels
% OUTPUT: xticks, xtickslabels
%
% Gino Del Ferraro, Dec 2022, NYU

function [x_idx, xtlbl] = ts_x_labels(ts,ts_step)

x_idx = [];
val_min = round(min(ts),1);
val_max = round(max(ts),1);
val = val_min:ts_step:val_max; % create range and ticklabels for x axis 

for i = val
    [ d, ix ] = min( abs( ts - i ) );
    x_idx = [x_idx, ix];
end
xtlbl = round(ts(x_idx),2);                  % New 'XTickLabel' Vector\

end