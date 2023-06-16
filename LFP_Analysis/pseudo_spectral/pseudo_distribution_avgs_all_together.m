
clear all; close all;

% %%%%%%%%%%%%%%%%
% PATHS
% %%%%%%%%%%%%%%%
monkey = "Bruno";
dir_out_main = 'E:\Output\GINO\Figures\avg_results_freq_vs_time\';
dir_in_null = 'E:\Output\GINO\pseudo_stats\server_results\rwd_no_rwd_diff_and_singles\';
dir_out_null = 'E:\Output\GINO\pseudo_stats\';


% %%%%%%%%%%%%%%%%
% Parameters
% %%%%%%%%%%%%%%%%

sess_range = [1,2,3];
Events = ["target"];
iter = 5;
max_ID =  10;
nsess = length(sess_range);
S = iter*nsess*max_ID;
theta_band = [3.9,10];
beta_band = [15,30];

load(strcat(dir_in_null,sprintf('%s\\pseudo_stats_%s_iter_%d_ID_1_diff_rwd_norwd.mat',monkey,monkey,iter)));
fs = pseudo_stats(1).prs.f_spec; % spectrogram frequency
psd_f = pseudo_stats(1).prs.psd_f;
t_spec = pseudo_stats(1).prs.t_spec;
ts = pseudo_stats(1).prs.ts;

theta_idx = find(fs >= theta_band(1) & fs < theta_band(2)); % theta-range index
beta_idx = find(fs >= beta_band(1) & fs < beta_band(2)); % beta-range index

% Create empty structures for the means across channels and sessions
reg_names = fieldnames(pseudo_stats(1).region); % brain regions name
for region = 1:length(reg_names)
    reg = reg_names{region};
    for EventType = Events
        
        pseudo_mean_distr.region.(reg).event.(EventType).psd_log_diff = zeros(iter*max_ID,length(psd_f));
        pseudo_mean_distr.region.(reg).event.(EventType).psd_log_rwd = zeros(iter*max_ID,length(psd_f));
        pseudo_mean_distr.region.(reg).event.(EventType).psd_log_norwd = zeros(iter*max_ID,length(psd_f));
        
        pseudo_mean_distr.region.(reg).event.(EventType).spec_log_diff = zeros(iter*max_ID,length(t_spec),length(fs));
        pseudo_mean_distr.region.(reg).event.(EventType).spec_log_rwd = zeros(iter*max_ID,length(t_spec),length(fs));
        pseudo_mean_distr.region.(reg).event.(EventType).spec_log_norwd = zeros(iter*max_ID,length(t_spec),length(fs));
        
        pseudo_mean_distr.region.(reg).event.(EventType).beta_t_log_diff = zeros(iter*max_ID,length(t_spec));
        pseudo_mean_distr.region.(reg).event.(EventType).theta_t_log_rwd = zeros(iter*max_ID,length(t_spec));
        pseudo_mean_distr.region.(reg).event.(EventType).beta_t_log_norwd = zeros(iter*max_ID,length(t_spec));
    end
end

for animal = monkey
    
    step = 0;
    for ID = 1:max_ID
        display(['Monkey ',num2str(animal),' - ID ',num2str(ID)])
        load(strcat(dir_in_null,sprintf('%s\\pseudo_stats_%s_iter_%d_ID_%d_diff_rwd_norwd.mat',animal,animal,iter,ID)));
        
        reg_names = fieldnames(pseudo_stats(1).region); % brain regions name
        
        for region = 1:length(reg_names)
            reg = reg_names{region};
            for EventType = Events
                
                nch = length(pseudo_stats(1).region.(reg).event.(EventType).ch);
                
                psd_rwd = zeros(nch*nsess,iter,length(psd_f));
                spec_rwd = zeros(nch*nsess,iter,length(t_spec),length(fs));
                theta_tf_rwd = zeros(nch*nsess,iter,length(t_spec),length(theta_idx));
                beta_tf_rwd = zeros(nch*nsess,iter,length(t_spec),length(beta_idx));
                
                psd_norwd = zeros(nch*nsess,iter,length(psd_f));
                spec_norwd = zeros(nch*nsess,iter,length(t_spec),length(fs));
                theta_tf_norwd = zeros(nch*nsess,iter,length(t_spec),length(theta_idx));
                beta_tf_norwd = zeros(nch*nsess,iter,length(t_spec),length(beta_idx));
                
                psd_diff = zeros(nch*nsess,iter,length(psd_f));
                spec_diff = zeros(nch*nsess,iter,length(t_spec),length(fs));
                theta_tf_diff = zeros(nch*nsess,iter,length(t_spec),length(theta_idx));
                beta_tf_diff = zeros(nch*nsess,iter,length(t_spec),length(beta_idx));
                
                
                cs = 1; % channel and session count 
                % stack across channel and sessions
                for sess = sess_range
                    nch = length(pseudo_stats(sess).region.(reg).event.(EventType).ch);
                    
                    % stack across channel
                    for chnl = 1:nch
                        
                      psd_rwd(cs,:,:) = pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_psd_pseudo_rwd_mat; % 5 iterations x frequency
                      spec_rwd(cs,:,:,:) = pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_spec_pseudo_rwd_mat;
                      theta_tf_rwd(cs,:,:,:) = pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_spec_pseudo_rwd_mat(:,:,theta_idx);
                      beta_tf_rwd(cs,:,:,:) = pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_spec_pseudo_rwd_mat(:,:,beta_idx);
                      
                      psd_norwd(cs,:,:) = pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_psd_pseudo_norwd_mat; % 5 iterations x frequency
                      spec_norwd(cs,:,:,:) = pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_spec_pseudo_norwd_mat;
                      theta_tf_norwd(cs,:,:,:) = pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_spec_pseudo_norwd_mat(:,:,theta_idx);
                      beta_tf_norwd(cs,:,:,:) = pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_spec_pseudo_norwd_mat(:,:,beta_idx);
                      
                      psd_diff(cs,:,:) = pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_psd_diff_mat; % 5 iterations x frequency
                      spec_diff(cs,:,:,:) = pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_tf_spec_diff_mat;
                      theta_tf_diff(cs,:,:,:) = pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_tf_spec_diff_mat(:,:,theta_idx);
                      beta_tf_diff(cs,:,:,:) = pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_tf_spec_diff_mat(:,:,beta_idx);
                      
                      cs = cs+1;
                    end % channel loop    
                   
                end % session loop
                
                    % pseudo mean across channels and sessions: These are the pseudo-stats starting quantities!
                    
                    % REWARD 
                    psd_mean_rwd = sq(mean(psd_rwd));
                    spec_mean_rwd = sq(mean(spec_rwd));
                    theta_tf_mean_rwd = sq(mean(theta_tf_rwd));
                    beta_tf_mean_rwd = sq(mean(beta_tf_rwd));
                    theta_t_mean_rwd = sq(mean(theta_tf_mean_rwd,3)); % theta power vs time
                    beta_t_mean_rwd = sq(mean(beta_tf_mean_rwd,3));   % beta power vs time 
                
                    pseudo_mean_distr.region.(reg).event.(EventType).psd_log_rwd(1+step:step+iter,:) = psd_mean_rwd;
                    pseudo_mean_distr.region.(reg).event.(EventType).spec_log_rwd(1+step:step+iter,:,:) = spec_mean_rwd;
                    pseudo_mean_distr.region.(reg).event.(EventType).theta_t_log_rwd(1+step:step+iter,:) = theta_t_mean_rwd;
                    pseudo_mean_distr.region.(reg).event.(EventType).beta_t_log_rwd(1+step:step+iter,:) = beta_t_mean_rwd;
                    
                    % NO-REWARD
                    psd_mean_norwd = sq(mean(psd_norwd));
                    spec_mean_norwd = sq(mean(spec_norwd));
                    theta_tf_mean_norwd = sq(mean(theta_tf_norwd));
                    beta_tf_mean_norwd = sq(mean(beta_tf_norwd));
                    theta_t_mean_norwd = sq(mean(theta_tf_mean_norwd, 3)); % theta power vs time
                    beta_t_mean_norwd = sq(mean(beta_tf_mean_norwd, 3));   % beta power vs time
                    
                    pseudo_mean_distr.region.(reg).event.(EventType).psd_log_norwd(1+step:step+iter,:) = psd_mean_norwd;
                    pseudo_mean_distr.region.(reg).event.(EventType).spec_log_norwd(1+step:step+iter,:,:) = spec_mean_norwd;
                    pseudo_mean_distr.region.(reg).event.(EventType).theta_t_log_norwd(1+step:step+iter,:) = theta_t_mean_norwd;
                    pseudo_mean_distr.region.(reg).event.(EventType).beta_t_log_norwd(1+step:step+iter,:) = beta_t_mean_norwd;

                    
                    % DIFFERENCE 
                    psd_mean_diff = sq(mean(psd_diff));
                    spec_mean_diff = sq(mean(spec_diff));
                    theta_tf_mean_diff = sq(mean(theta_tf_diff));
                    beta_tf_mean_diff = sq(mean(beta_tf_diff));
                    theta_t_mean_diff = sq(mean(theta_tf_mean_diff,3)); % theta power vs time
                    beta_t_mean_diff = sq(mean(beta_tf_mean_diff,3)); % beta power vs timee
                
                    pseudo_mean_distr.region.(reg).event.(EventType).psd_log_diff(1+step:step+iter,:) = psd_mean_diff;
                    pseudo_mean_distr.region.(reg).event.(EventType).spec_log_diff(1+step:step+iter,:,:) = spec_mean_diff;
                    pseudo_mean_distr.region.(reg).event.(EventType).theta_t_log_diff(1+step:step+iter,:) = theta_t_mean_diff;
                    pseudo_mean_distr.region.(reg).event.(EventType).beta_t_log_diff(1+step:step+iter,:) = beta_t_mean_diff;
                   
                    
            end % event loop          
        end % region loop   
        step = step + 5;
    end % index loop
    
end

% Compute averages and std for the null distribution
for region = 1:length(reg_names)
    reg = reg_names{region};
    for EventType = Events
        
        % REWARD
        pseudo_avg.region.(reg).event.(EventType).psd_log_rwd_avg = mean(pseudo_mean_distr.region.(reg).event.(EventType).psd_log_rwd);
        pseudo_avg.region.(reg).event.(EventType).psd_log_rwd_std = std(pseudo_mean_distr.region.(reg).event.(EventType).psd_log_rwd);
        pseudo_avg.region.(reg).event.(EventType).spec_log_rwd_avg = sq(mean(pseudo_mean_distr.region.(reg).event.(EventType).spec_log_rwd));
        pseudo_avg.region.(reg).event.(EventType).spec_log_rwd_std = sq(std(pseudo_mean_distr.region.(reg).event.(EventType).spec_log_rwd));
        pseudo_avg.region.(reg).event.(EventType).theta_t_log_rwd_avg = mean(pseudo_mean_distr.region.(reg).event.(EventType).theta_t_log_rwd);
        pseudo_avg.region.(reg).event.(EventType).theta_t_log_rwd_std = std(pseudo_mean_distr.region.(reg).event.(EventType).theta_t_log_rwd);
        pseudo_avg.region.(reg).event.(EventType).beta_t_log_rwd_avg = mean(pseudo_mean_distr.region.(reg).event.(EventType).beta_t_log_rwd);
        pseudo_avg.region.(reg).event.(EventType).beta_t_log_rwd_std = std(pseudo_mean_distr.region.(reg).event.(EventType).beta_t_log_rwd);

        % NO REWARD
        pseudo_avg.region.(reg).event.(EventType).psd_log_norwd_avg = mean(pseudo_mean_distr.region.(reg).event.(EventType).psd_log_norwd);
        pseudo_avg.region.(reg).event.(EventType).psd_log_norwd_std = std(pseudo_mean_distr.region.(reg).event.(EventType).psd_log_norwd);
        pseudo_avg.region.(reg).event.(EventType).spec_log_norwd_avg = sq(mean(pseudo_mean_distr.region.(reg).event.(EventType).spec_log_norwd));
        pseudo_avg.region.(reg).event.(EventType).spec_log_norwd_std = sq(std(pseudo_mean_distr.region.(reg).event.(EventType).spec_log_norwd));
        pseudo_avg.region.(reg).event.(EventType).theta_t_log_norwd_avg = mean(pseudo_mean_distr.region.(reg).event.(EventType).theta_t_log_norwd);
        pseudo_avg.region.(reg).event.(EventType).theta_t_log_norwd_std = std(pseudo_mean_distr.region.(reg).event.(EventType).theta_t_log_norwd);
        pseudo_avg.region.(reg).event.(EventType).beta_t_log_norwd_avg = mean(pseudo_mean_distr.region.(reg).event.(EventType).beta_t_log_norwd);
        pseudo_avg.region.(reg).event.(EventType).beta_t_log_norwd_std = std(pseudo_mean_distr.region.(reg).event.(EventType).beta_t_log_norwd);

        % DIFFERENCE 
        pseudo_avg.region.(reg).event.(EventType).psd_log_diff_avg = mean(pseudo_mean_distr.region.(reg).event.(EventType).psd_log_diff);
        pseudo_avg.region.(reg).event.(EventType).psd_log_diff_std = std(pseudo_mean_distr.region.(reg).event.(EventType).psd_log_diff);
        pseudo_avg.region.(reg).event.(EventType).spec_log_diff_avg = sq(mean(pseudo_mean_distr.region.(reg).event.(EventType).spec_log_diff));
        pseudo_avg.region.(reg).event.(EventType).spec_log_diff_std = sq(std(pseudo_mean_distr.region.(reg).event.(EventType).spec_log_diff));
        pseudo_avg.region.(reg).event.(EventType).theta_t_log_diff_avg = mean(pseudo_mean_distr.region.(reg).event.(EventType).theta_t_log_diff);
        pseudo_avg.region.(reg).event.(EventType).theta_t_log_diff_std = std(pseudo_mean_distr.region.(reg).event.(EventType).theta_t_log_diff);
        pseudo_avg.region.(reg).event.(EventType).beta_t_log_diff_avg = mean(pseudo_mean_distr.region.(reg).event.(EventType).beta_t_log_diff);
        pseudo_avg.region.(reg).event.(EventType).beta_t_log_diff_std = std(pseudo_mean_distr.region.(reg).event.(EventType).beta_t_log_diff);
        

    end
end

pseudo_avg.prs.f_spec = fs; % spectrogram frequency
pseudo_avg.prs.t_spec = t_spec; % spectrogram time
pseudo_avg.prs.psd_f = psd_f; % psd frequency
pseudo_avg.prs.ts = ts; % lfp time 

save(strcat(dir_out_null,sprintf('pseudo_avg_%s_tot_iter_%d_diff_rwd_norwd.mat',monkey,max_ID*iter)),'pseudo_avg','-v7.3');




