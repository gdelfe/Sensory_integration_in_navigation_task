% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function iterates through each spectrogram in the null distribution
% and counts/store the size of the max cluster for each spectrogram. It
% creates a max cluster distribution by selecting one max cluster in the
% pseudo spectrograms.
%
% INPUT: Z_spec_pseudo: Collection of pseudo-spectrogram, 3D matrix with 
% dimensions: iteration x time x frequency
%
% OUTPUT: list of max clusters (histogram/distribution)
%
% @ Gino Del Ferraro, NYU, Jan 2023


function [clust_w_psd_list,clust_w_spec_list,clust_w_list_theta,clust_w_list_beta] = max_cluster_count_null_distribution_ch(z_spec_diff_mat,z_psd_diff_mat,z_theta_diff_mat,z_beta_diff_mat,Niter)

% loop on the null distribution for a second time to identify the maximum clusters
clust_w_psd_list = []; % cluster weight list for psd 
clust_w_spec_list = []; % cluster weight list for spectrogram 
clust_w_list_theta = [];  % cluster weight list for theta only 
clust_w_list_beta = []; % cluster weight list for beta only  

for i = 1:Niter % for each pseudo spectrogram
    
    % WHOLE SPECTROGRAM 
    Z = sq(z_spec_diff_mat(i,:,:)); % Z-scored psuedo spectrogram
    z_max = max_cluster(Z);
    clust_w_spec_list = [clust_w_spec_list; z_max];
    
    % PSD 
    Z_psd = z_psd_diff_mat(i,:);
    z_max = max_cluster(Z_psd);
    clust_w_psd_list = [clust_w_psd_list; z_max];
      
    
    % THETA BAND 
    Z_theta = z_theta_diff_mat(i,:); % Z-scored psuedo spectrogram
    z_max = max_cluster(Z_theta);
    clust_w_list_theta = [clust_w_list_theta; z_max];
    
    
    % BETA BAND 
    Z_beta = z_beta_diff_mat(i,:); % Z-scored psuedo spectrogram
    z_max = max_cluster(Z_beta);
    clust_w_list_beta = [clust_w_list_beta; z_max];
    
    
    
end

end