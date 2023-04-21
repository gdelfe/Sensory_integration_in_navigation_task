% Compute coherencegram for N random channels across region i and j, average the
% results across the region and store abs and phase of the coherencegram in
% a structure for further analysis 
%
% Gino Del Ferraro, NYU, April 2023

function [coherencegram] = coherencegram_reg_i_reg_j(coherencegram,stats_rwd,stats_den,sess,EventType,region_i,region_j,reg_i,reg_j,channels,fk,tapers,dn)

display(['-- brain region i: ',num2str(reg_i),'-- brain region j: ',num2str(reg_j)])
fs = 1/stats_rwd(1).prs.psd_s_rate;
pad = 2;

coh_rwd_1 = [];
coh_rwd_2 = [];
coh_hd = [];
coh_ld = [];

for ch_i = channels(region_i,:)
    for ch_j = channels(region_j,:)
        
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

% compute mean and std
coh_rwd_1_mean = mean(abs(coh_rwd_1),3);
coh_rwd_2_mean = mean(abs(coh_rwd_2),3);
coh_hd_mean = mean(abs(coh_hd),3);
coh_ld_mean = mean(abs(coh_ld),3);

coh_rwd_1_std = std(abs(coh_rwd_1),[],3);
coh_rwd_2_std = std(abs(coh_rwd_2),[],3);
coh_hd_std = std(abs(coh_hd),[],3);
coh_ld_std = std(abs(coh_ld),[],3);

% Angle: return the Phase in the [-pi, pi] interval
coh_rwd_1_angle = circ_mean(angle(coh_rwd_1),[],3); 
coh_rwd_2_angle = circ_mean(angle(coh_rwd_2),[],3);
coh_hd_angle = circ_mean(angle(coh_hd),[],3);
coh_ld_angle = circ_mean(angle(coh_ld),[],3);

coh_rwd_1_angle_std = circ_std(angle(coh_rwd_1),[],3);
coh_rwd_2_angle_std = circ_std(angle(coh_rwd_2),[],3);
coh_hd_angle_std = circ_std(angle(coh_hd),[],3);
coh_ld_angle_std = circ_std(angle(coh_ld),[],3);



% store results
% Abs
coherencegram(sess).rwd(1).(EventType).reg_X.(reg_i).reg_Y.(reg_j).cohgram = coh_rwd_1_mean;
coherencegram(sess).rwd(2).(EventType).reg_X.(reg_i).reg_Y.(reg_j).cohgram = coh_rwd_2_mean;
coherencegram(sess).high_den.(EventType).reg_X.(reg_i).reg_Y.(reg_j).cohgram = coh_hd_mean;
coherencegram(sess).low_den.(EventType).reg_X.(reg_i).reg_Y.(reg_j).cohgram = coh_ld_mean;

coherencegram(sess).rwd(1).(EventType).reg_X.(reg_i).reg_Y.(reg_j).cohgram_std = coh_rwd_1_std;
coherencegram(sess).rwd(2).(EventType).reg_X.(reg_i).reg_Y.(reg_j).cohgram_std = coh_rwd_2_std;
coherencegram(sess).high_den.(EventType).reg_X.(reg_i).reg_Y.(reg_j).cohgram_std = coh_hd_std;
coherencegram(sess).low_den.(EventType).reg_X.(reg_i).reg_Y.(reg_j).cohgram_std = coh_ld_std;

% phase
coherencegram(sess).rwd(1).(EventType).reg_X.(reg_i).reg_Y.(reg_j).angle = coh_rwd_1_angle;
coherencegram(sess).rwd(2).(EventType).reg_X.(reg_i).reg_Y.(reg_j).angle = coh_rwd_2_angle;
coherencegram(sess).high_den.(EventType).reg_X.(reg_i).reg_Y.(reg_j).angle = coh_hd_angle;
coherencegram(sess).low_den.(EventType).reg_X.(reg_i).reg_Y.(reg_j).angle = coh_ld_angle;

coherencegram(sess).rwd(1).(EventType).reg_X.(reg_i).reg_Y.(reg_j).angle_std = coh_rwd_1_angle_std;
coherencegram(sess).rwd(2).(EventType).reg_X.(reg_i).reg_Y.(reg_j).angle_std = coh_rwd_2_angle_std;
coherencegram(sess).high_den.(EventType).reg_X.(reg_i).reg_Y.(reg_j).angle_std = coh_hd_angle_std;
coherencegram(sess).low_den.(EventType).reg_X.(reg_i).reg_Y.(reg_j).angle_std = coh_ld_angle_std;

coherencegram(sess).high_den.(EventType).reg_X.(reg_i).reg_Y.(reg_j).f = f;
coherencegram(sess).high_den.(EventType).reg_X.(reg_i).reg_Y.(reg_j).tf = tf;
coherencegram(sess).rwd(1).(EventType).reg_X.(reg_i).reg_Y.(reg_j).f = f;
coherencegram(sess).rwd(1).(EventType).reg_X.(reg_i).reg_Y.(reg_j).tf = tf;
            
end