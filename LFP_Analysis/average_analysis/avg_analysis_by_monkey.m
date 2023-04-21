% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TEST-CODE: compute test-statistics for spectral features for one monkey
% only and check by plotting. For a full analysis and a finalized code look
% at avg_analysis_all_monkeys.m 


% clear all; close all;

% % PARAMETERS
Events = ["target","move","stop"];
% frequency ranges in Hz
theta = [3.9,10];
beta = [15,30];

% % PATHS 
dir_in = 'E:\Output\GINO\stats\';
dir_out = 'E:\Output\GINO\test_stats\';

% load(strcat(dir_out,sprintf('stats_%s.mat',monkey)));
Events = ["target","move","stop"];
% remove empty fields from the structure stats
stats = remove_empty_fields(stats,Events)


t_stats = average_stats(stats,Events,theta,beta)
save(strcat(dir_out,sprintf('test_stats_%s.mat',monkey)),'t_stats','-v7.3');

ts = t_stats.ts(round(t_stats.ti));

reg = "PFC";
EventType = "target";
% theta 
reg1_rwd1_theta_pow = t_stats.region.(reg).event.(EventType).rwd(1).avg_theta_pow;
reg1_rwd1_err_theta = t_stats.region.(reg).event.(EventType).rwd(1).err_theta_pow;
reg1_rwd2_theta_pow = t_stats.region.(reg).event.(EventType).rwd(2).avg_theta_pow;
reg1_rwd1_err_theta = t_stats.region.(reg).event.(EventType).rwd(2).err_theta_pow;

% beta
reg1_rwd1_beta_pow = t_stats.region.(reg).event.(EventType).rwd(1).avg_beta_pow;
reg1_rwd1_err_beta = t_stats.region.(reg).event.(EventType).rwd(1).err_beta_pow;
reg1_rwd2_beta_pow = t_stats.region.(reg).event.(EventType).rwd(2).avg_beta_pow;
reg1_rwd1_err_beta = t_stats.region.(reg).event.(EventType).rwd(2).err_beta_pow;


figure;
shadedErrorBar(ts,reg1_rwd1_theta_pow,reg1_rwd1_err_theta,'lineprops',{'color',[28 199 139]/255 },'patchSaturation',0.5); hold on
shadedErrorBar(ts,reg1_rwd2_theta_pow,reg1_rwd1_err_theta,'lineprops',{'color',[50 250 93]/255 },'patchSaturation',0.5); 

title(sprintf("Monkey: %s, region = %s, event = %s",monkey,reg,EventType),'FontSize',12)
xlabel('time (s)','FontName','Arial','FontSize',15);
ylabel('log(power)','FontName','Arial','FontSize',15);
legend({'no reward','reward'},'FontSize',10,'FontName','Arial')
set(gcf, 'Position',  [100, 500, 700, 500])
% set(gca,'FontSize',14)
grid on



