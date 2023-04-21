
function [coherencegram] = compute_coherencegram_across_regions(stats_rwd,stats_den,Events,sess_range,fk,tapers,dn,rand_ch)

nsess = 3;
coherencegram = [];

reg_names = fieldnames(stats_rwd(1).region); % brain regions name

[channels] = get_random_channels_ij(stats_den,reg_names,rand_ch);

for sess = sess_range
    disp(['Session  ----',num2str(sess)])
    for EventType = Events
        disp(['EVENT  ----',num2str(EventType)])
        % diagonal blocks: intra-region coherence     
        for region_i = 1:length(reg_names)
            disp(['INTRA-REGION COHERENCE ----'])
            reg_i = reg_names{region_i};
            coherencegram = coherencegram_reg_i(coherencegram,stats_rwd,stats_den,sess,EventType,region_i,reg_i,channels,fk,tapers,dn);
            
            % off-diagonal blocks: inter-regionn coherence
            disp(['INTER-REGION COHERENCE ----'])
            for region_j = region_i+1:length(reg_names)
                reg_j = reg_names{region_j};
                coherencegram = coherencegram_reg_i_reg_j(coherencegram,stats_rwd,stats_den,sess,EventType,region_i,region_j,reg_i,reg_j,channels,fk,tapers,dn);
                       
            end % region_j loop
            
        end % region_i loop
        
    end % event loop
end % session loop

end % function end