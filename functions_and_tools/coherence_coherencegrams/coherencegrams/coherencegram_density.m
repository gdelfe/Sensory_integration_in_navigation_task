% Compute coherencegram between two region reg_i and reg_j, two channels
% ch_i, ch_j and store the results into a structure
%

function [coherencegram] = coherencegram_density(coherencegram,stats,sess,reg_i,reg_j,EventType,den,ch_i,ch_j,tapers,dn,fs,fk,pad)

X1 = stats(sess).region.(reg_i).event.(EventType).(den).ch(ch_i).lfp';
X2 = stats(sess).region.(reg_j).event.(EventType).(den).ch(ch_j).lfp';

% -- coherence calculation via coherency()
[coh,f] = tfcoh(X1,X2,tapers,fs,dn,fk,pad,0.05,1,11);

coherencegram.rwd(r).reg_X.(reg_i).reg_Y.(reg_j).mat(ch_i,ch_j,:) = coh;
coherencegram.rwd(r).reg_X.(reg_i).reg_Y.(reg_j).f = f;

end
