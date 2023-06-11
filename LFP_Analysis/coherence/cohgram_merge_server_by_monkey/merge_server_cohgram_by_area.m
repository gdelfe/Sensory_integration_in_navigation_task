
clear all; close all;
% input and output directories 
dir_in = 'E:\Output\GINO\cohgram_all_channels\';
dir_in_phase = 'E:\Output\GINO\phase_PLV\';

monkey = "Quigley";
dir_in = dir_in + monkey + '\target\';
dir_in_phase = dir_in_phase + monkey + '\target\';

reg_i = "MST";
reg_j = "PPC"
EventType = "target";
n_sess = 3;

PLV_tot = {};
cohgram_tot =[];


for sess = 1:n_sess

    load(strcat(dir_in,sprintf('coherencegram_%s_sess_%d_event_%s_%s_%s.mat',monkey,sess,EventType,reg_i,reg_i)));
    load(strcat(dir_in_phase,sprintf('PLV_phase_%s_sess_%d_event_%s_%s_%s.mat',monkey,sess,EventType,reg_i,reg_i)));
    PLV_tot{sess} = PLV_sess;
    cohgram_tot{sess} = coherencegram;
    clear coherencegram
    
end


[cohgram_mean, PLV_mean] = PLV_and_cohgram_mean_std_across_sessions(PLV_tot,cohgram_tot,n_sess);




fieldName = 'high_den_R';
PLV_avg = PLV_mean.(fieldName).PLV_theta';
PLV_sem = (PLV_mean.(fieldName).PLV_std_theta/sqrt((PLV_mean.(fieldName).nch_pairs)))';
ts = PLV_mean.(fieldName).ts;


phase_avg = PLV_mean.(fieldName).phase_diff_theta';
phase_sem = (PLV_mean.(fieldName).phase_diff_std_theta/sqrt((PLV_mean.(fieldName).nch_pairs)))';
ts = PLV_mean.(fieldName).ts;

ts = ts(1:end-1);

phase_avg = PLV_tot{1}.high_den_R.phase_diff_theta;
phase_sem = PLV_tot{1}.high_den_R.phase_diff_std_theta/sqrt(PLV_tot{1}.high_den_R.nch_pairs);

figure;
shadedErrorBar(ts,PLV_avg,PLV_sem,'lineprops',{'color',"#0066ff"},'patchSaturation',0.4); hold on
xline(0,'--k');

figure;
shadedErrorBar(ts,phase_avg,phase_sem,'lineprops',{'color',"#ff751a"},'patchSaturation',0.4); hold on
xline(0,'--k');
ax = gca;

ax.YTick([-pi -pi/2 0 pi/2 pi]);
ax.yticklabels("-pi -pi/2 0 pi/2 pi");


