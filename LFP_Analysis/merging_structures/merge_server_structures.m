

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
iterations = 5;
max_ID = 1000;
tot_iter = iterations*max_ID; 

% nch = 2;
for monkey = ["Bruno","Quigley"]
    
    load(strcat(dir_in_null,sprintf('%s\\pseudo_stats_%s_iter_%d_ID_1.mat',monkey,monkey,iterations)));
    pseudo_a = pseudo_stats;
    reg_names = fieldnames(pseudo_stats(1).region); % brain regions name
    
    for ID = 2:max_ID
        load(strcat(dir_in_null,sprintf('%s\\pseudo_stats_%s_iter_%d_ID_%d.mat',monkey,monkey,iterations,ID)));
        pseudo_b = pseudo_stats;
        
        for sess = sess_range
            display(['Monkey ',num2str(monkey),' - ID ',num2str(ID),' - sess ',num2str(sess)])

            for region = 1:length(reg_names)
                reg = reg_names{region};
                for EventType = Events
                
                    nch = length(pseudo_stats(sess).region.(reg).event.(EventType).ch);
                    for chnl = 1:nch
                        
                        psd_a = pseudo_a(sess).region.(reg).event.(EventType).ch(chnl).log_psd_diff_mat;
                        psd_b = pseudo_b(sess).region.(reg).event.(EventType).ch(chnl).log_psd_diff_mat;
                        pseudo_a(sess).region.(reg).event.(EventType).ch(chnl).log_psd_diff_mat = [psd_a; psd_b];
                        
                        spec_a = pseudo_a(sess).region.(reg).event.(EventType).ch(chnl).log_tf_spec_diff_mat;
                        spec_b = pseudo_b(sess).region.(reg).event.(EventType).ch(chnl).log_tf_spec_diff_mat;
                        pseudo_a(sess).region.(reg).event.(EventType).ch(chnl).log_tf_spec_diff_mat = [spec_a; spec_b];
                        
                    end          
                end
            end
        end
    end
    
    pseudo_stats = pseudo_a;
    disp(['Saving full psuedo stats ...'])
    save(strcat(dir_out_null,sprintf('pseudo_stats_%s_iter_%d.mat',monkey,tot_iter)),'pseudo_stats','-v7.3');
    
end



