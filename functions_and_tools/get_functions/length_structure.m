% Add a value to the structure field (last value) if the structure is
% missing a value compared to the length of the time series

function PLV_tot = length_structure(PLV_tot,n_sess)
    
ts = PLV_tot{1}.high_den_R.ts;
% Get field names from the source structure
fieldNames = fieldnames(PLV_tot{1});

for sess = 1:n_sess
    % Iterate over the field names
    for i = 1:numel(fieldNames)
        fieldName = fieldNames{i};
        if length(PLV_tot{sess}.(fieldName).PLV_theta) == length(ts) - 1
            
            PLV_tot{sess}.(fieldName).PLV_theta = [PLV_tot{sess}.(fieldName).PLV_theta; PLV_tot{sess}.(fieldName).PLV_theta(end)];
            PLV_tot{sess}.(fieldName).PLV_std_theta = [PLV_tot{sess}.(fieldName).PLV_std_theta; PLV_tot{sess}.(fieldName).PLV_std_theta(end)];
            PLV_tot{sess}.(fieldName).phase_diff_theta = [PLV_tot{sess}.(fieldName).phase_diff_theta; PLV_tot{sess}.(fieldName).phase_diff_theta(end)];
            PLV_tot{sess}.(fieldName).phase_diff_std_theta = [PLV_tot{sess}.(fieldName).phase_diff_std_theta; PLV_tot{sess}.(fieldName).phase_diff_std_theta(end)];
            PLV_tot{sess}.(fieldName).PLV_beta = [PLV_tot{sess}.(fieldName).PLV_beta; PLV_tot{sess}.(fieldName).PLV_beta(end)];
            PLV_tot{sess}.(fieldName).PLV_std_beta = [PLV_tot{sess}.(fieldName).PLV_std_beta; PLV_tot{sess}.(fieldName).PLV_std_beta(end)];
            PLV_tot{sess}.(fieldName).phase_diff_beta = [PLV_tot{sess}.(fieldName).phase_diff_beta; PLV_tot{sess}.(fieldName).phase_diff_beta(end)];
            PLV_tot{sess}.(fieldName).phase_diff_std_beta = [PLV_tot{sess}.(fieldName).phase_diff_std_beta; PLV_tot{sess}.(fieldName).phase_diff_std_beta(end)];
            
        end
    end
end

end