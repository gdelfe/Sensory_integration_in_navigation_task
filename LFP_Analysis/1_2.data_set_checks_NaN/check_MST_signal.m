
dir_in = 'E:\Output\GINO\stats\';
dir_out = 'E:\Output\GINO\Figures\LFPs\';

% FOR ALL MONKEYS --------------------
monkey = "Quigley";
EventType = "target";
load(strcat(dir_in,sprintf('stats_%s_all_events.mat',monkey)));
% load('E:\Output\GINO\experiments_lfp_Quigley_34_behv_lfps.mat')


size(stats(1).region.MST.event.(EventType).rwd(2).ch(1).lfp)
size(stats(1).region.MST.event.(EventType).rwd(1).ch(1).lfp)

Xmst = stats(1).region.MST.event.(EventType).rwd(2).ch(1).lfp; % time vs trial 
Xppc = stats(1).region.PPC.event.(EventType).rwd(2).ch(1).lfp;
% Xpfc = stats(1).region.PFC.event.(EventType).rwd(2).ch(1).lfp;


ts = stats(1).prs.ts;

trial = 1;
fig = figure;
plot(ts, Xmst(:,trial),'color', "k"); hold on
plot(ts,Xppc(:,trial),'color', "#0072BD"); hold on
% plot(ts,Xpfc(:,trial),'color',"#D95319"); hold on
grid on
xlabel('time')
ylabel('LFP (\mu V)')
legend('MST','PPC')
title(sprintf('Monkey %s, LFPs vs time, %s aligned, one trial',monkey,EventType));
set(gcf,'position',[100,400,700,500])
fname = strcat(dir_out,sprintf('%s_LFP_signals_event_%s.png',monkey,EventType));
saveas(fig,fname)

trial = 1;
fig = figure;
plot(ts, Xmst(:,trial),'color', "k"); hold on
grid on
xlabel('time')
ylabel('LFP (\mu V)')
legend('MST')
title(sprintf('Monkey %s, MST only LFPs vs time, %s aligned, one trial',monkey,EventType));
set(gcf,'position',[100,400,700,500])
fname = strcat(dir_out,sprintf('%s_LFP_signal_MST_only_event_%s.png',monkey,EventType));
saveas(fig,fname)



XppcLinear = experiments.sessions(1).lfps(1).stats.trialtype.reward(2).events.target.all_freq.lfp_align_ext;
ts = experiments.sessions(1).lfps(1).stats.trialtype.reward(2).events.target.all_freq.ts_lfp_align_ext;

trial = 1;
fig = figure;
plot(ts, XppcLinear(:,trial),'color', "k"); hold on
grid on
xlabel('time')
ylabel('LFP (\mu V)')
legend('MST')
title(sprintf('Monkey %s, PPC linear probe LFPs vs time, %s aligned, one trial',monkey,EventType));
set(gcf,'position',[100,400,700,500])
fname = strcat(dir_out,sprintf('%s_LFP_signal_PPC_only_linear_probe_event_%s.png',monkey,EventType));
saveas(fig,fname)


