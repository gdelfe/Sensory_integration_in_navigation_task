% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Given a Z-score matrix or a z-scored vector, this function finds the
% maximum z-score cluster (where the max is found by counting the weight of
% the cluster and not just the number of elements)
%
% INPUT: Z-score matrix or vector
%
% OUPUT: z_max = sum of z-scored values in the max cluster
%
% @ Gino Del Ferraro, NYU, Jan 2023

function z_max = max_cluster(Z)
W = bwconncomp(Z); % find connected components (clusters)

Z_weights = [];
for c = 1:length(W.PixelIdxList) % for each cluster
    Z_weights = [Z_weights, sum(abs(Z(W.PixelIdxList{c})))]; % count the weight of the cluster in z-score value
end
z_max = max(Z_weights); % find the max cluster (in z-score weight, not in size weight)

end