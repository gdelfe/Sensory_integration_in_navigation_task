
% Find index of ts for the larger value bigger than -1, and the smallest
% value smaller than 1.
%
% We are only interested in the time window [-1,1] when we do target offset  
% alignment 

function [idx_l,idx_h] = find_ts_index(ts,threshold)

mask_low = ts >= -threshold;
mask_high = ts <= threshold;

val_l = ts(mask_low);
[minVal, ~] = min(val_l);
idx_l = find(ts == minVal, 1);

val_h = ts(mask_high);
[maxVal, ~] = max(val_h);
idx_h = find(ts == maxVal, 1);

end
