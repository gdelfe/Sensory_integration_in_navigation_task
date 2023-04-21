% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function performs the cluster correction of the test-statistics
% spectrogram, given a p-value threshold, i.e. 0.05 and a distribution of
% max clusters for the null distribution, in detail: the 95 percentile max
% cluster in the distribution, i.e. clust_th
% 
% Given the thresholded Z_spec with a given z_th corresponding to a 0.05
% p-value, the function further removes all the clusters which are below
% the cluster_threshold (i.e. all the cluster smaller/having less weight
% that the clust_th)
% 
% INPUT: Z-scored spectrogram thresholded with a given z-score threshold;
% clust_th for the max cluster in the null distribution
%
% OUTPUT: Z-scored cluster corrected spectrogram 
%
% @ Gino Del Ferraro, NYU, Jan 2023


function Z_spec_cc = z_spec_cluster_corrected(Z_spec,clust_th)

W = bwconncomp(Z_spec); % find connected components (clusters)

Z_weights = [];
for c = 1:length(W.PixelIdxList) % for each cluster
    Z_weights = [Z_weights, sum(abs(Z_spec(W.PixelIdxList{c})))]; % count the weight of the cluster in z-score value
end

clust_idx  = Z_weights > clust_th; % find indexes of the surviving clusters after threshold in the Z_weights array
WT = cellfun(@transpose,W.PixelIdxList,'UniformOutput',false); % transpose cells in cell array with z-score for each cluster (for faster access)
matrix_idx = [WT{clust_idx}]; % matrix indexes of the pixel in the surviving clusters
mask = zeros(size(Z_spec)); %
mask(matrix_idx) = 1; % create a mask matrix with ones for elements above z_th and zeros otherwise
Z_spec_cc = mask.*Z_spec;

end 






