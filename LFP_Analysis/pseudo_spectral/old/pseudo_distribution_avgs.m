

clear all; close all;

% %%%%%%%%%%%%%%%%
% PATHS
% %%%%%%%%%%%%%%%
monkey = "Bruno";
dir_out_main = 'E:\Output\GINO\Figures\avg_results_freq_vs_time\';
dir_in_null = 'E:\Output\GINO\pseudo_stats\server_results\';
dir_out_null = 'E:\Output\GINO\pseudo_stats\';


% %%%%%%%%%%%%%%%%
% Parameters
% %%%%%%%%%%%%%%%%

sess_range = [1,2,3];
Events = ["target","move"];
iter = 5;
max_ID = 300;
nsess = length(sess_range);
S = iter*nsess*max_ID;

theta_band = [3.9,10];
beta_band = [15,30];

load(strcat(dir_in_null,sprintf('%s\\pseudo_stats_%s_iter_%d_ID_1.mat',monkey,monkey,iter)));
fs = pseudo_stats(1).prs.f_spec; % spectrogram frequency
psd_f = pseudo_stats(1).prs.psd_f;
t_spec = pseudo_stats(1).prs.t_spec;

theta_idx = find(fs >= theta_band(1) & fs < theta_band(2)); % theta-range index
beta_idx = find(fs >= beta_band(1) & fs < beta_band(2)); % beta-range index


reg_names = fieldnames(pseudo_stats(1).region); % brain regions name

for region = 1:length(reg_names)
    reg = reg_names{region};
    for EventType = Events
        
        pseudo_avg_temp.region.(reg).event.(EventType).psd_mean = zeros(max_ID,length(psd_f));
        pseudo_avg_temp.region.(reg).event.(EventType).psd_var = zeros(max_ID,length(psd_f));
        pseudo_avg_temp.region.(reg).event.(EventType).spec_mean = zeros(max_ID,length(t_spec),length(fs));
        pseudo_avg_temp.region.(reg).event.(EventType).spec_var = zeros(max_ID,length(t_spec),length(fs));
        pseudo_avg_temp.region.(reg).event.(EventType).theta_t_mean = zeros(max_ID,length(t_spec));
        pseudo_avg_temp.region.(reg).event.(EventType).theta_t_var = zeros(max_ID,length(t_spec));
        pseudo_avg_temp.region.(reg).event.(EventType).beta_t_mean = zeros(max_ID,length(t_spec));
        pseudo_avg_temp.region.(reg).event.(EventType).beta_t_var = zeros(max_ID,length(t_spec));
        
    end
end



for monkey = ["Bruno"]
    
    for ID = 1:max_ID
        display(['Monkey ',num2str(monkey),' - ID ',num2str(ID)])
        load(strcat(dir_in_null,sprintf('%s\\pseudo_stats_%s_iter_%d_ID_%d.mat',monkey,monkey,iter,ID)));
        
        reg_names = fieldnames(pseudo_stats(1).region); % brain regions name
        
        for region = 1:length(reg_names)
            reg = reg_names{region};
            for EventType = Events
                
                psd_mean_sess = zeros(nsess,length(psd_f));
                spec_mean_sess = zeros(nsess,length(t_spec),length(fs));
                theta_tf_mean_sess = zeros(nsess,length(t_spec),length(theta_idx));
                beta_tf_mean_sess = zeros(nsess,length(t_spec),length(beta_idx));
                
                psd_var_sess = zeros(nsess,length(psd_f));
                spec_var_sess = zeros(nsess,length(t_spec),length(fs));
                theta_tf_var_sess = zeros(nsess,length(t_spec),length(theta_idx));
                beta_tf_var_sess = zeros(nsess,length(t_spec),length(beta_idx));
                
                step = 1;
                for sess = sess_range
                    nch = length(pseudo_stats(sess).region.(reg).event.(EventType).ch);
                    
                    psd = zeros(length(psd_f),nch);
                    spec = zeros(length(t_spec),length(fs),nch);
                    theta_tf = zeros(length(t_spec),length(theta_idx),nch);
                    beta_tf = zeros(length(t_spec),length(beta_idx),nch);
                    
                    psd_var = zeros(length(psd_f),nch);
                    spec_var = zeros(length(t_spec),length(fs),nch);
                    theta_tf_var = zeros(length(t_spec),length(theta_idx),nch);
                    beta_tf_var = zeros(length(t_spec),length(beta_idx),nch);
                    
                    % stack across channel
                    for chnl = 1:nch
                        
                        % averages and var across 5 iteration of pseudo-results within the ID file
                        psd(:,chnl) = sq(mean(pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_psd_diff_mat));
                        spec(:,:,chnl) = sq(mean(pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_tf_spec_diff_mat));
                        theta_tf(:,:,chnl) = sq(mean(pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_tf_spec_diff_mat(:,:,theta_idx)));
                        beta_tf(:,:,chnl) = sq(mean(pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_tf_spec_diff_mat(:,:,beta_idx)));
                        
                        psd_var(:,chnl) = sq(var(pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_psd_diff_mat));
                        spec_var(:,:,chnl) = sq(var(pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_tf_spec_diff_mat));
                        theta_tf_var(:,:,chnl) = sq(var(pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_tf_spec_diff_mat(:,:,theta_idx)));
                        beta_tf_var(:,:,chnl) = sq(var(pseudo_stats(sess).region.(reg).event.(EventType).ch(chnl).log_tf_spec_diff_mat(:,:,beta_idx)));
                        
                    end % channel loop
                    
                    % %% averages and std across channels and across 5 iterations 
                    
                    psd_mean_sess(sess,:) = mean(psd,2);
                    psd_var_sess(sess,:) = mean((psd.^2) + psd_var,2)' - psd_mean_sess(sess,:).^2;
                    spec_mean_sess(sess,:,:) = mean(spec,3);
                    spec_var_sess(sess,:,:) = mean((spec.^2)+spec_var,3) - sq(spec_mean_sess(sess,:,:)).^2;
                    
                    % theta range 
                    theta_tf_mean_sess(sess,:,:) = sq(mean(theta_tf,3));
                    theta_tf_var_sess(sess,:,:) = mean((theta_tf.^2)+theta_tf,3) - sq(theta_tf_mean_sess(sess,:,:)).^2;
                    % beta range 
                    beta_tf_mean_sess(sess,:,:) = mean(beta_tf,3);
                    beta_tf_var_sess(sess,:,:) = mean((beta_tf.^2)+beta_tf,3) - sq(beta_tf_mean_sess(sess,:,:)).^2;
                    
                    
                end % session loop
                
                % average across frequency and propagate error
                theta_t_mean_sess = mean(theta_tf_mean_sess,3);
                theta_t_var_sess = mean(sq(theta_tf_mean_sess).^2 + sq(theta_tf_var_sess),3) - theta_t_mean_sess.^2;
                % average across frequency and propagate error
                beta_t_mean_sess = mean(beta_tf_mean_sess,3);
                beta_t_var_sess = mean(sq(beta_tf_mean_sess).^2 + sq(beta_tf_var_sess),3) - beta_t_mean_sess.^2;
                
                % % AVERAGES ACROSS SESSIONS 
                psd_mean = mean(psd_mean_sess);
                psd_var = mean((psd_mean_sess.^2) + psd_var_sess) - psd_mean.^2;
                spec_mean = sq(mean(spec_mean_sess));
                spec_var = sq(mean((spec_mean_sess.^2) + spec_var_sess)) - spec_mean.^2;
                theta_t_mean = sq(mean(theta_t_mean_sess));
                theta_t_var = sq(mean((theta_t_mean_sess.^2) + theta_t_var_sess)) - theta_t_mean.^2;
                beta_t_mean = sq(mean(beta_t_mean_sess));
                beta_t_var = sq(mean((beta_t_mean_sess.^2) + beta_t_var_sess)) - beta_t_mean.^2;
     
                
                pseudo_avg_temp.region.(reg).event.(EventType).psd_mean(ID,:) = psd_mean;
                pseudo_avg_temp.region.(reg).event.(EventType).psd_var(ID,:) = psd_var;
                pseudo_avg_temp.region.(reg).event.(EventType).spec_mean(ID,:,:) = spec_mean;
                pseudo_avg_temp.region.(reg).event.(EventType).spec_var(ID,:,:) = spec_var;
                pseudo_avg_temp.region.(reg).event.(EventType).theta_t_mean(ID,:) = theta_t_mean;
                pseudo_avg_temp.region.(reg).event.(EventType).theta_t_var(ID,:) = theta_t_var;
                pseudo_avg_temp.region.(reg).event.(EventType).beta_t_mean(ID,:) = beta_t_mean;
                pseudo_avg_temp.region.(reg).event.(EventType).beta_t_var(ID,:) = beta_t_var;
                
       
            end % event loop
            
        end % region loop     
    end % index loop
    
    
end


for region = 1:length(reg_names)
    reg = reg_names{region};
    for EventType = Events


    mean_obj = pseudo_avg_temp.region.(reg).event.(EventType).psd_mean;
    var_obj = pseudo_avg_temp.region.(reg).event.(EventType).psd_var;
    pseudo_avg.region.(reg).event.(EventType).psd_mean = mean(mean_obj);
    pseudo_avg.region.(reg).event.(EventType).psd_std = sqrt(mean(mean_obj.^2 + var_obj) - mean(mean_obj).^2);
    
    mean_obj = pseudo_avg_temp.region.(reg).event.(EventType).spec_mean;
    var_obj = pseudo_avg_temp.region.(reg).event.(EventType).spec_var;   
    pseudo_avg.region.(reg).event.(EventType).spec_mean = sq(mean(mean_obj));
    pseudo_avg.region.(reg).event.(EventType).spec_std = sq(sqrt(mean(mean_obj.^2 + var_obj) - mean(mean_obj).^2));
    
    mean_obj = pseudo_avg_temp.region.(reg).event.(EventType).theta_t_mean;
    var_obj = pseudo_avg_temp.region.(reg).event.(EventType).theta_t_var;   
    pseudo_avg.region.(reg).event.(EventType).theta_t_mean = sq(mean(mean_obj));
    pseudo_avg.region.(reg).event.(EventType).theta_t_std = sq(sqrt(mean(mean_obj.^2 + var_obj) - mean(mean_obj).^2));
    
    mean_obj = pseudo_avg_temp.region.(reg).event.(EventType).beta_t_mean;
    var_obj = pseudo_avg_temp.region.(reg).event.(EventType).beta_t_var;   
    pseudo_avg.region.(reg).event.(EventType).beta_t_mean = sq(mean(mean_obj));
    pseudo_avg.region.(reg).event.(EventType).beta_t_std = sq(sqrt(mean(mean_obj.^2 + var_obj) - mean(mean_obj).^2));
    
    % time and frequency parameters
    pseudo_avg.prs.f_spec = fs;
    pseudo_avg.prs.t_spec = t_spec;
    pseudo_avg.prs.psd_f = psd_f;
    
    
    disp(['Saving full psuedo stats ...'])
    save(strcat(dir_out_null,sprintf('pseudo_avg_stats_%s_iter_%d.mat',monkey,S)),'pseudo_avg','-v7.3');

    end
end
















