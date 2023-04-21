% Compute coherence across pairs of channels in both intra-region and
% inter-region interactions. 
% coherence_reg_i computes coherence vs frequency intra-region
% coherence_reg_i_reg_j computes coherence vs frequency inter-region
%
% @ Gino Del Ferraro, NYU, April 2023

function [coherence] = compute_coherency_across_regions(stats_rwd,stats_den,Events,sess_range,fk,W)

coherence = {}; % structure to store coherence vs frequency for intra- and inter-region 

reg_names = fieldnames(stats_rwd(1).region); % brain regions name

for sess = sess_range
    disp(['Session  ----',num2str(sess)])
    for EventType = Events
        disp(['EVENT  ----',num2str(EventType)])
        % diagonal blocks: intra-region coherence     
        for region_i = 1:length(reg_names)
            disp(['INTRA-REGION COHERENCE ----'])
            reg_i = reg_names{region_i};
            nch_i = size(stats_rwd(sess).region.(reg_i).event.(EventType).rwd(1).ch,2);
            coherence(sess) = coherence_reg_i(coherence,stats_rwd,stats_den,sess,EventType,reg_i,nch_i,fk,W);
            
            % off-diagonal blocks: inter-regionn coherence
            disp(['INTER-REGION COHERENCE ----'])
            for region_j = region_i+1:length(reg_names)
                reg_j = reg_names{region_j};
                nch_j = size(stats_rwd(sess).region.(reg_j).event.(EventType).rwd(1).ch,2);
                coherence(sess) = coherence_reg_i_reg_j(coherence,stats_rwd,stats_den,sess,EventType,reg_i,reg_j,nch_i,nch_j,fk,W);
                       
            end % region_j loop
            
        end % region_i loop
        
    end % event loop
end % session loop

end % function end