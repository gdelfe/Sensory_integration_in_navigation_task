
% Compute mean and std (with error propagation) across sessions for PLV,
% instantaneous phase difference, coherencegrams (Magnitude and Phase). The
% final results reflect averages and error propagation across trials,
% channels, and sessions. Results are, therefore, a global average estimate
% across all the recordings.
%
% @ Gino Del Ferraro, NYU, June 2023


function [cohgram_mean, PLV_mean] = PLV_and_cohgram_mean_std_across_sessions(PLV_tot,cohgram_tot,n_sess)

% Create empty structure with the same field structure of PLV_sess and coherencegram 
cohgram_mean = initializeStructure(cohgram_tot{1});
PLV_mean = initializeStructure(PLV_tot{1});

L = length(PLV_tot{1}.high_den_NR.ts) - 1;
for sess = 1:n_sess
    
    % Iterate over the field names and concatenate results across sessions
    % for PLV, phase difference, coherencegrams in theta and beta range
    
    fieldNames = fieldnames(PLV_tot{1});
    for i = 1:numel(fieldNames)
        fieldName = fieldNames{i};
         
        % % THETA
        % PLV 
        PLV_mean.(fieldName).PLV_theta = [PLV_mean.(fieldName).PLV_theta, PLV_tot{sess}.(fieldName).PLV_theta(1:L)]; % concatenate mean PLV_theta across sessions 
        PLV_mean.(fieldName).PLV_std_theta = [PLV_mean.(fieldName).PLV_std_theta, PLV_tot{sess}.(fieldName).PLV_std_theta(1:L).^2 + PLV_tot{sess}.(fieldName).PLV_theta(1:L).^2]; % concatenate std^2 + mu^2 across session, for error propagation 
        % Instantaneous phase difference
        PLV_mean.(fieldName).phase_diff_theta = [PLV_mean.(fieldName).phase_diff_theta, PLV_tot{sess}.(fieldName).phase_diff_theta(1:L)]; % concatenate mean PLV_theta across sessions 
        PLV_mean.(fieldName).phase_diff_std_theta = [PLV_mean.(fieldName).phase_diff_std_theta, PLV_tot{sess}.(fieldName).phase_diff_std_theta(1:L).^2 + PLV_tot{sess}.(fieldName).phase_diff_theta(1:L).^2]; % concatenate std^2 + mu^2 across session, for error propagation 
        
        % % BETA
        % PLV 
        PLV_mean.(fieldName).PLV_beta = [PLV_mean.(fieldName).PLV_beta, PLV_tot{sess}.(fieldName).PLV_beta(1:L)]; % concatenate mean PLV_theta across sessions 
        PLV_mean.(fieldName).PLV_std_beta = [PLV_mean.(fieldName).PLV_std_beta, PLV_tot{sess}.(fieldName).PLV_std_beta(1:L).^2 + PLV_tot{sess}.(fieldName).PLV_beta(1:L).^2]; % concatenate std^2 + mu^2 across session, for error propagation 
        % Instantaneous phase difference
        PLV_mean.(fieldName).phase_diff_beta = [PLV_mean.(fieldName).phase_diff_beta, PLV_tot{sess}.(fieldName).phase_diff_beta(1:L)]; % concatenate mean PLV_theta across sessions 
        PLV_mean.(fieldName).phase_diff_std_beta = [PLV_mean.(fieldName).phase_diff_std_beta, PLV_tot{sess}.(fieldName).phase_diff_std_beta(1:L).^2 + PLV_tot{sess}.(fieldName).phase_diff_beta(1:L).^2]; % concatenate std^2 + mu^2 across session, for error propagation 
        
        % COHERENCEGRAMS
        % Magnitude
        cohgram_mean.(fieldName).cohgram = cat(3,cohgram_mean.(fieldName).cohgram, cohgram_tot{sess}.(fieldName).cohgram);
        cohgram_mean.(fieldName).cohgram_std = cat(3,cohgram_mean.(fieldName).cohgram_std, ((cohgram_tot{sess}.(fieldName).cohgram).^2) + (cohgram_tot{sess}.(fieldName).cohgram_std).^2); % temp std - concatenate std^2 + mu^2 across session, for error propagation
        % Phase 
        cohgram_mean.(fieldName).angle = cat(3,cohgram_mean.(fieldName).angle, cohgram_tot{sess}.(fieldName).angle);
        cohgram_mean.(fieldName).angle_std = cat(3,cohgram_mean.(fieldName).angle_std, ((cohgram_tot{sess}.(fieldName).angle).^2) + (cohgram_tot{sess}.(fieldName).angle_std).^2); % temp std - concatenate std^2 + mu^2 across session, for error propagation

    end 
end

% STD propagation across sessions: std^2 = 1/N \sum std_i^2 + mu_i^2 - mu^2

fieldNames = fieldnames(cohgram_mean);
for i = 1:numel(fieldNames)
    fieldName = fieldNames{i};
    
    % PLV and phase-difference mean - THETA RANGE
    PLV_mean.(fieldName).PLV_theta = mean(PLV_mean.(fieldName).PLV_theta,2);
    PLV_mean.(fieldName).phase_diff_theta = circ_mean(PLV_mean.(fieldName).phase_diff_theta,[],2);
    
    % PLV and phase-difference STD propagation across sessions - THETA RANGE
    PLV_mean.(fieldName).PLV_std_theta = sqrt( mean(PLV_mean.(fieldName).PLV_std_theta,2) - mean(PLV_mean.(fieldName).PLV_theta,2).^2 ); % std^2 = 1/N \sum std_i^2 + mu_i^2 - mu^2 --- Error propagation of std across sessions 
    PLV_mean.(fieldName).phase_diff_std_theta = sqrt( circ_mean(PLV_mean.(fieldName).phase_diff_std_theta,[],2) - circ_mean(PLV_mean.(fieldName).phase_diff_theta,[],2).^2 ); % std^2 = 1/N \sum std_i^2 + mu_i^2 - mu^2 --- Error propagation of std across sessions 
    
    % PLV and phase-difference mean - BETA RANGE
    PLV_mean.(fieldName).PLV_beta = mean(PLV_mean.(fieldName).PLV_beta,2);
    PLV_mean.(fieldName).phase_diff_beta = circ_mean(PLV_mean.(fieldName).phase_diff_beta,[],2);
    
    % PLV and phase-difference STD propagation across sessions - BETA RANGE
    PLV_mean.(fieldName).PLV_std_beta = sqrt( mean(PLV_mean.(fieldName).PLV_std_beta,2) - mean(PLV_mean.(fieldName).PLV_beta,2).^2 ); % std^2 = 1/N \sum std_i^2 + mu_i^2 - mu^2 --- Error propagation of std across sessions 
    PLV_mean.(fieldName).phase_diff_std_beta = sqrt( circ_mean(PLV_mean.(fieldName).phase_diff_std_beta,[],2) - circ_mean(PLV_mean.(fieldName).phase_diff_beta,[],2).^2 ); % std^2 = 1/N \sum std_i^2 + mu_i^2 - mu^2 --- Error propagation of std across sessions 
    
    % coherence gram amplitude
    cohgram_mean.(fieldName).cohgram = mean(cohgram_mean.(fieldName).cohgram,3);
    cohgram_mean.(fieldName).angle = mean(cohgram_mean.(fieldName).angle,3);
    
    % coherence gram std
    cohgram_mean.(fieldName).cohgram_std = sqrt(mean(cohgram_mean.(fieldName).cohgram_std,3) - mean(cohgram_mean.(fieldName).cohgram,3).^2 ); % std^2 = 1/N \sum std_i^2 + mu_i^2 - mu^2 --- Error propagation of std across sessions
    cohgram_mean.(fieldName).angle_std = sqrt(circ_mean(cohgram_mean.(fieldName).angle_std,[],3) - circ_mean(cohgram_mean.(fieldName).angle,[],3).^2 ); % std^2 = 1/N \sum std_i^2 + mu_i^2 - mu^2 --- Error propagation of std across sessions
    
    % Time, frequency parameters
    PLV_mean.(fieldName).ts = PLV_tot{1}.(fieldName).ts;
    PLV_mean.(fieldName).nch_pairs = PLV_tot{1}.(fieldName).nch_pairs;
    PLV_mean.(fieldName).num_trials = PLV_tot{1}.(fieldName).num_trials;
    
    cohgram_mean.(fieldName).f = cohgram_tot{1}.(fieldName).f;
    cohgram_mean.(fieldName).tf = cohgram_tot{1}.(fieldName).tf;
    cohgram_mean.(fieldName).nch_pairs = cohgram_tot{1}.(fieldName).nch_pairs;
    
    
end



end 