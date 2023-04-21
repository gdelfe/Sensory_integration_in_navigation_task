% Compute the coherence matrix for a give frequency band, for two different
% reward situations (reward/no-reward). The result is a
% coherence matrix, organized by region, NxN.
%
% @ Gino Del Ferraro, NYU, April 2023

function [coh_ij] = coherence_matrix_reward(coh_ij,coh,reg_names,region_sizes,rwd_range,freq_band,freq_idx)

for r = rwd_range
    
    % BLOCK DIAGONAL TERMS of the CORRELATION MATRIX
    a = 1;
    b = 0;
    for reg_i = 1:length(reg_names)
        reg_ni = reg_names{reg_i};
        display(['-- brain region i: ',num2str(reg_ni)])
        
        b = b + region_sizes(reg_i);
        coh_ij.rwd(r).(freq_band)(a:b,a:b) = mean(abs(coh.rwd(r).reg_X.(reg_ni).reg_Y.(reg_ni).mat(:,:,freq_idx)),3); % block diagonal term
        
        % OFF-DIAGONAL BLOCKS of the CORRELATION MATRIX
        c = b + 1;
        d = b;
        for reg_j = reg_i+1:length(reg_names)
            reg_nj = reg_names{reg_j};
            display(['----- brain region j: ',num2str(reg_nj)])
            
            d = d + region_sizes(reg_j);
            coh_ij.rwd(r).(freq_band)(a:b,c:d) = mean(abs(coh.rwd(r).reg_X.(reg_ni).reg_Y.(reg_nj).mat(:,:,freq_idx)),3); % off-diagonal block term
            c = c + region_sizes(reg_j);
        end
        a = a + region_sizes(reg_i);
        
    end 
end

end
