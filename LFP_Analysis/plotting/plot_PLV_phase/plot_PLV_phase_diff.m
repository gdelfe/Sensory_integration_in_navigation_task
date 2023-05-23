
clear all; close all;
% Input parameters
monkey = "Quigley";
reg_i = "MST";
reg_j = "PPC";
sess = 1;
EventType = "target";

dir_in = 'E:\Output\GINO\coherence\phase_PLV\';
load(strcat(dir_in,sprintf('PLV_phase_%s_sess_%d_event_%s_%s_%s.mat',monkey,sess,EventType,reg_i,reg_j)));

ts = PLV_sess.high_den_R.ts; % time range
PLV = PLV_sess.high_den_R.PLV_theta;
PLV_sem = PLV_sess.high_den_R.PLV_std_theta/sqrt(PLV_sess.high_den_R.nch_pairs);

figure;
shadedErrorBar(ts,PLV,PLV_sem,'lineprops',{'color',"#0066ff"},'patchSaturation',0.4); hold on
xline(0,'--k');