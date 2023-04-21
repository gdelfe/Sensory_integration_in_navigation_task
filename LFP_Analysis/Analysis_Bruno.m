
clear all;  close all;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOAD DATA PSD and Spectrogram 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
monkey = 'Bruno';
dir_out = 'E:\Output\GINO\stats\';
load(strcat(dir_out,sprintf('stats_%s.mat',monkey))); 

sess = 1; reg = "PPC"; EventType = "target"; r = 1; chnl = 1; 


psd = stats(sess).region.(reg).event.(EventType).rwd(r).ch(chnl).psd;
f_psd = stats(sess).region.(reg).event.(EventType).rwd(r).psd_f;


spec = stats(sess).region.(reg).event.(EventType).rwd(r).ch(chnl).tf_spec;
f_spec = stats(sess).region.(reg).event.(EventType).rwd(r).tfspec_f;
t_spec = stats(sess).region.(reg).event.(EventType).rwd(r).tfspec_t;
Wt = stats(sess).prs.tfspec_Wt; 
Nt = stats(sess).prs.tfpspec_Nt;
dnt = stats(sess).prs.tfspec_dnt;

figure;
plot(f_psd,log(abs(psd)))
title(sprintf('rwd = %d',r))
grid on


figure;
tvimage(log(spec));
% colormap(bone)
colorbar
grid on
% title([sprintf("%s",EventType),sprintf("W = %d, Nt = %.1f, dn = %.2f, rwd = %d, ch = %d",Wt,Nt,dnt,r,chnl)]);
[x_idx, xlbl, y_idx, ylbl] = tfspec_labels(ts,ti,f_spec,0.05,10);

set(gca, 'XTick',x_idx, 'XTickLabel',xlbl)
set(gca, 'YTick',y_idx, 'YTickLabel',ylbl)

ylabel('frequency (Hz)')
xlabel('time (sec)')
grid on


