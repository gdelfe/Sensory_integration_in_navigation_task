% Function to get the values in the upper triangular part of the coherence
% matrix for region i and store them into a new array. This is used to
% facilitate the computation of the mean and std for the coherence matrix,
% since it contains many zeros in its triangular form. With this function
% we basically get rid of all these zeros.
%
% INPUT: coherence matrix ch x ch x frequency
%
% OUTPUT: coherence matrix ch,ch x frequency
%
% @ Gino Del Ferraro, NYU, April 2023
 

function [coh_matrix] = get_triangular_matrix_values_of_coherence(coh,den,reg_ni)

F = size(coh.(den).reg_X.(reg_ni).reg_Y.(reg_ni).mat,3); % frequency length
N =  size(coh.(den).reg_X.(reg_ni).reg_Y.(reg_ni).mat,1); % matrix size (for region i)
M = N*(N-1)/2; % number of elements in the upper triangular part of the matrix

coh_matrix = zeros(M,F);
for f = 1:F
    coh_matrix(:,f) = nonzeros(coh.(den).reg_X.(reg_ni).reg_Y.(reg_ni).mat(:,:,f))';
end

end 


