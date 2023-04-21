
% Compute coherencegram between two region reg_i and reg_j, two channels
% ch_i, ch_j and store the results into a structure
%

function [coherencegram] = coherencegram_reward(coherencegram,stats_rwd,stats_den,sess,reg_i,reg_j,EventType,r,channels,region_i,tapers,dn,fs,fk,pad)

coh_rwd_1 = [];
coh_rwd_2 = [];
coh_hd = [];
coh_ld = [];

for ch_i = channels(region_i,:)
    for ch_j = channels(region_i,(find(channels(region_i,:)== ch_i)+1:end))
        
        % reward 1
        X1 = stats_rwd(sess).region.(reg_i).event.(EventType).rwd(1).ch(ch_i).lfp';
        X2 = stats_rwd(sess).region.(reg_j).event.(EventType).rwd(1).ch(ch_j).lfp';
        % -- coherence calculation via coherency()
        [coh,tf,f] = tfcoh(X1,X2,tapers,fs,dn,fk,pad,0.05,11);
        coh_rwd_1 = cat(3,coh_rwd_1,coh);
        
        % reward 2
        X1 = stats_rwd(sess).region.(reg_i).event.(EventType).rwd(2).ch(ch_i).lfp';
        X2 = stats_rwd(sess).region.(reg_j).event.(EventType).rwd(2).ch(ch_j).lfp';
        % -- coherence calculation via coherency()
        [coh,tf,f] = tfcoh(X1,X2,tapers,fs,dn,fk,pad,0.05,11);
        coh_rwd_2 = cat(3,coh_rwd_2,coh);
        
        % high density
        X1 = stats_den(sess).region.(reg_i).event.(EventType).high_den.ch(ch_i).lfp';
        X2 = stats_den(sess).region.(reg_j).event.(EventType).high_den.ch(ch_j).lfp';
        % -- coherence calculation via coherency()
        [coh,tf,f] = tfcoh(X1,X2,tapers,fs,dn,fk,pad,0.05,11);
        coh_hd = cat(3,coh_hd,coh);
        
        % low density
        X1 = stats_den(sess).region.(reg_i).event.(EventType).low_den.ch(ch_i).lfp';
        X2 = stats_den(sess).region.(reg_j).event.(EventType).low_den.ch(ch_j).lfp';
        % -- coherence calculation via coherency()
        [coh,tf,f] = tfcoh(X1,X2,tapers,fs,dn,fk,pad,0.05,11);
        coh_ld = cat(3,coh_ld,coh);
        
    end
end

coh_rwd_1_mean = mean(coh_rwd_1,3);
coh_rwd_2_mean = mean(coh_rwd_2,3);
coh_hd_mean = mean(coh_hd,3);
coh_ld_mean = mean(coh_ld,3);

% store results
coherencegram.rwd(1).reg_X.(reg_i).reg_Y.(reg_j).cohgram = coh_rwd_1_mean;
coherencegram.rwd(2).reg_X.(reg_i).reg_Y.(reg_j).cohgram = coh_rwd_2_mean;
coherencegram.high_den.reg_X.(reg_i).reg_Y.(reg_j).cohgram = coh_hd_mean;
coherencegram.low_den.reg_X.(reg_i).reg_Y.(reg_j).cohgram = coh_ld_mean;

end


