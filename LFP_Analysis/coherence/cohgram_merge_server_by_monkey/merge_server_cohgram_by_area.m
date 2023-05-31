

% input and output directories 
dir_in = 'E:\Output\GINO\cohgram_all_channels\';
dir_in_phase = 'E:\Output\GINO\phase_PLV\';

monkey = "Quigley";
dir_in = dir_in + monkey + '\target\';
dir_in_phase = dir_in_phase + monkey + '\target\';

reg_i = "MST";
sess = 1;
EventType = "target";
n_sess = 3;

PLV_tot = {};
cohgram_tot ={};


for sess = 1:n_sess

    load(strcat(dir_in,sprintf('coherencegram_%s_sess_%d_event_%s_%s_%s.mat',monkey,sess,EventType,reg_i,reg_i)));
    load(strcat(dir_in_phase,sprintf('PLV_phase_%s_sess_%d_event_%s_%s_%s.mat',monkey,sess,EventType,reg_i,reg_i)));
    PLV_tot = [PLV_tot,PLV_sess];
    cohgram_tot = [cohgram_tot,coherencegram];
    
end


ts = PLV_tot{1}.high_den_R.ts; % time range

% Create empty structure with the same field structure of PLV_sess and coherencegram 
cohgram_mean = initializeStructure(cohgram_tot{1});
PLV_mean = initializeStructure(PLV_tot{1});


for sess = 1:n_sess
    
    % Iterate over the field names in the first level
    fieldNames = fieldnames(PLV_tot{1});
    for i = 1:numel(fieldNames)
        fieldName = fieldNames{i};
    
        % % THETA
        % PLV 
        PLV_mean.(fieldName).PLV_theta = [PLV_mean.(fieldName).PLV_theta, PLV_tot{sess}.(fieldName).PLV_theta]; % concatenate mean PLV_theta across sessions 
        PLV_mean.(fieldName).PLV_std_theta = [PLV_mean.(fieldName).PLV_std_theta, PLV_tot{sess}.(fieldName).PLV_std_theta.^2 + PLV_tot{sess}.(fieldName).PLV_theta.^2]; % concatenate std^2 + mu^2 across session, for error propagation 
        % Instantaneous phase difference
        PLV_mean.(fieldName).phase_diff_theta = [PLV_mean.(fieldName).phase_diff_theta, PLV_tot{sess}.(fieldName).phase_diff_theta]; % concatenate mean PLV_theta across sessions 
        PLV_mean.(fieldName).phase_diff_std_theta = [PLV_mean.(fieldName).phase_diff_std_theta, PLV_tot{sess}.(fieldName).phase_diff_std_theta.^2 + PLV_tot{sess}.(fieldName).phase_diff_theta.^2]; % concatenate std^2 + mu^2 across session, for error propagation 
        
        % % BETA
        % PLV 
        PLV_mean.(fieldName).PLV_beta = [PLV_mean.(fieldName).PLV_beta, PLV_tot{sess}.(fieldName).PLV_beta]; % concatenate mean PLV_theta across sessions 
        PLV_mean.(fieldName).PLV_std_beta = [PLV_mean.(fieldName).PLV_std_beta, PLV_tot{sess}.(fieldName).PLV_std_beta.^2 + PLV_tot{sess}.(fieldName).PLV_beta.^2]; % concatenate std^2 + mu^2 across session, for error propagation 
        % Instantaneous phase difference
        PLV_mean.(fieldName).phase_diff_beta = [PLV_mean.(fieldName).phase_diff_beta, PLV_tot{sess}.(fieldName).phase_diff_beta]; % concatenate mean PLV_theta across sessions 
        PLV_mean.(fieldName).phase_diff_std_beta = [PLV_mean.(fieldName).phase_diff_std_beta, PLV_tot{sess}.(fieldName).phase_diff_std_beta.^2 + PLV_tot{sess}.(fieldName).phase_diff_beta.^2]; % concatenate std^2 + mu^2 across session, for error propagation 
        
        
    end 
end



PLV_mean = PLV{1}.high_den_R.PLV_theta;
PLV_sem = PLV{1}.high_den_R.PLV_std_theta/sqrt(PLV{1}.high_den_R.nch_pairs);

phase = PLV{1}.high_den_R.phase_diff_theta;
phase_sem = PLV{1}.high_den_R.phase_diff_std_theta/sqrt(PLV{1}.high_den_R.nch_pairs);

figure;
shadedErrorBar(ts,PLV_mean,PLV_sem,'lineprops',{'color',"#0066ff"},'patchSaturation',0.4); hold on
% shadedErrorBar(ts,phase,phase_sem,'lineprops',{'color',"#ff751a"},'patchSaturation',0.4); hold on

xline(0,'--k');
ax = gca;
ax.YTick([-pi -pi/2 0 pi/2 pi]);
ax.yticklabels("-pi -pi/2 0 pi/2 pi");


