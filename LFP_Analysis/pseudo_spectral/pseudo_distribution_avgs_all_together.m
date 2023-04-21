
clear all; close all;

% %%%%%%%%%%%%%%%%
% PATHS
% %%%%%%%%%%%%%%%
monkey = "Vik";
dir_out_main = 'E:\Output\GINO\Figures\avg_results_freq_vs_time\';
dir_in_null = 'E:\Output\GINO\pseudo_stats\server_results\';
dir_out_null = 'E:\Output\GINO\pseudo_stats\';


% %%%%%%%%%%%%%%%%
% Parameters
% %%%%%%%%%%%%%%%%

sess_range = [1,2,3];
Events = ["target","move","stop"];
iter = 5;
max_ID =  1000;
nsess = length(sess_range);
S = iter*nsess*max_ID;
theta_band = [3.9,10];
beta_band = [15,30];

load(strcat(dir_in_null,sprintf('%s\\pseudo_stats_%s_iter_%d_ID_1_all_events.mat',monkey,monkey,iter)));
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
        pseudo_mean_distr.region.(reg).event.(EventType).spec_log_diff = zeros(iter*max_ID,length(t_spec),length(fs));
        pseudo_mean_distr.region.(reg).event.(EventType).theta_t_log_diff = zeros(iter*max_ID,length(t_spec));
        pseudo_mean_distr.region.(reg).event.(EventType).beta_t_log_diff = zeros(iter*max_ID,length(t_spec));
    end
end

for animal = monkey
    
    step = 0;
    for ID = 1:max_ID
        display(['Monkey ',num2str(animal),' - ID ',num2str(ID)])
        load(strcat(dir_in_null,sprintf('%s\\pseudo_stats_%s_iter_%d_ID_%d_all_events.mat',animal,animal,iter,ID)));
        
        reg_names = fieldnames(pseudo_stats(1).region); % brain regions name
        
        for region = 1:length(reg_names)
            reg = reg_names{region};
            for EventType = Events
                
                nch = length(pseudo_stats(1).region.(reg).event.(EventType).ch);
                psd = zeros(nch*nsess,iter,length(psd_f));
                spec = zeros(nch*nsess,iter,length(t_spec),length(fs));
                theta_tf = zeros(nch*nsess,iter,length(t_spec),length(theta_idx));
                beta_tf = zeros(nch*nsess,iter,length(t_spec),length(beta_idx));
                
                cs = 1; % channel and session count 
                % stack across channel and sessions
                for sess = sess_range
                    nch = length(pseudo_stats(sess).region.(reg).event.(EventType).ch);
                    
                    % stack across channel
                    for chnl = 1:nch
                        
                      psd(cs,:,:) = pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_psd_diff_mat; % 5 iterations x frequency
                      spec(cs,:,:,:) = pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_tf_spec_diff_mat;
                      theta_tf(cs,:,:,:) = pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_tf_spec_diff_mat(:,:,theta_idx);
                      beta_tf(cs,:,:,:) = pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_tf_spec_diff_mat(:,:,beta_idx);
                      cs = cs+1;
                    end % channel loop    
                   
                end % session loop
                
                    % pseudo mean across channels and sessions: These are the pseudo-stats starting quantities! 
                    psd_mean = sq(mean(psd));
                    spec_mean = sq(mean(spec));
                    theta_tf_mean = sq(mean(theta_tf));
                    beta_tf_mean = sq(mean(beta_tf));
                    theta_t_mean = sq(mean(theta_tf_mean,3)); % theta power vs time
                    beta_t_mean = sq(mean(beta_tf_mean,3));   % beta power vs time 
                
                    pseudo_mean_distr.region.(reg).event.(EventType).psd_log_diff(1+step:step+iter,:) = psd_mean;
                    pseudo_mean_distr.region.(reg).event.(EventType).spec_log_diff(1+step:step+iter,:,:) = spec_mean;
                    pseudo_mean_distr.region.(reg).event.(EventType).theta_t_log_diff(1+step:step+iter,:) = theta_t_mean;
                    pseudo_mean_distr.region.(reg).event.(EventType).beta_t_log_diff(1+step:step+iter,:) = beta_t_mean;
                   
                    
            end % event loop          
        end % region loop   
        step = step + 5;
    end % index loop
    
end

% Compute averages and std for the null distribution
for region = 1:length(reg_names)
    reg = reg_names{region};
    for EventType = Events
        
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

save(strcat(dir_out_null,sprintf('pseudo_avg_%s_tot_iter_%d_all_events.mat',monkey,max_ID*iter)),'pseudo_avg','-v7.3');




