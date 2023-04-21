

function [coh_vs_freq] = coherence_vs_freq_avg_reward(coh_vs_freq,coh,reg_names,region_sizes,rwd_range)

for r = rwd_range
    display(['- reward: ',num2str(r)])
    % BLOCK DIAGONAL TERMS of the CORRELATION MATRIX
    a = 1;
    b = 0;
    for reg_i = 1:length(reg_names)
        reg_ni = reg_names{reg_i};
        display(['--- brain region i: ',num2str(reg_ni)])
        
        b = b + region_sizes(reg_i);
        
        coh_matrix = get_triangular_matrix_values_of_coherence_rwd(coh,r,reg_ni); % get the non-zero values (the upper triangular part of the corr matrix)
        coh_vs_freq.rwd(r).reg_X.(reg_ni).reg_Y.(reg_ni).corr = mean(abs(coh_matrix),1); % mean corr vs frequency
        coh_vs_freq.rwd(r).reg_X.(reg_ni).reg_Y.(reg_ni).std = std(abs(coh_matrix),[],1); % std 
        coh_vs_freq.rwd(r).reg_X.(reg_ni).reg_Y.(reg_ni).sem = std(abs(coh_matrix),[],1)/sqrt(size(coh_matrix,1)); % SEM
        
        coh_vs_freq.rwd(r).reg_X.(reg_ni).reg_Y.(reg_ni).angle = mean(angle(coh_matrix),1);
        coh_vs_freq.rwd(r).reg_X.(reg_ni).reg_Y.(reg_ni).angle = std(angle(coh_matrix),[],1);
        coh_vs_freq.rwd(r).reg_X.(reg_ni).reg_Y.(reg_ni).angle = std(angle(coh_matrix),[],1)/sqrt(size(coh_matrix,1));
        
        % OFF-DIAGONAL BLOCKS of the CORRELATION MATRIX
        c = b + 1;
        d = b;
        for reg_j = reg_i+1:length(reg_names)
            reg_nj = reg_names{reg_j};
            display(['----- brain region j: ',num2str(reg_nj)])
            
            d = d + region_sizes(reg_j);
            
            C = coh.rwd(r).reg_X.(reg_ni).reg_Y.(reg_nj).mat;
            coh_reg_ij = reshape(C,size(C,1)*size(C,2),[]);
            coh_vs_freq.rwd(r).reg_X.(reg_ni).reg_Y.(reg_nj).corr = mean(abs(coh_reg_ij),1); % mean corr vs freq for off-diagonal block terms
            coh_vs_freq.rwd(r).reg_X.(reg_ni).reg_Y.(reg_nj).std = std(abs(coh_reg_ij),[],1); % std for off-diagonal blocks
            coh_vs_freq.rwd(r).reg_X.(reg_ni).reg_Y.(reg_nj).sem = std(abs(coh_reg_ij),[],1)/sqrt(size(coh_reg_ij,1)); % SEM for off-diagonal blocks
            
            coh_vs_freq.rwd(r).reg_X.(reg_ni).reg_Y.(reg_nj).angle = mean(angle(coh_reg_ij),1);
            coh_vs_freq.rwd(r).reg_X.(reg_ni).reg_Y.(reg_nj).angle = std(angle(coh_reg_ij),[],1);
            coh_vs_freq.rwd(r).reg_X.(reg_ni).reg_Y.(reg_nj).angle = std(angle(coh_reg_ij),[],1)/sqrt(size(coh_reg_ij,1));
            
            c = c + region_sizes(reg_j);
            
        end
        a = a + region_sizes(reg_i);
        
    end
    
end

end
