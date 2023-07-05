
clear all; close all;
dir_in = 'E:\Output\GINO\stats\mobile_stationary\';
dir_out = 'E:\Output\GINO\Figures\spectral\mobile_stationary\';

monkeys = ["Bruno","Quigley","Schro","Vik"];

stationary = []; stat_sem = [];
mobile = []; mob_sem = [];
all_psd = []; all_sem = [];

load(strcat(dir_in,sprintf('psd_avg_%s_mobile_stationary.mat',"Bruno")));

psd_all = create_psd_stack_all(psd_avg);

% Stack all the avg result for each monkey together for each region 
for monkey = monkeys
    
    load(strcat(dir_in,sprintf('psd_avg_%s_mobile_stationary.mat',monkey)));
    reg_names = fieldnames(psd_avg.region);
    
    for region = 1:length(reg_names)
        reg = reg_names{region}; % get region name
        
        psd_all.region.(reg).stationary = [psd_all.region.(reg).stationary; psd_avg.region.(reg).stationary];
        psd_all.region.(reg).stat_sem = [psd_all.region.(reg).stat_sem; psd_avg.region.(reg).stat_std/sqrt(psd_avg.region.(reg).ntrials_stat)];
        psd_all.region.(reg).mobile = [psd_all.region.(reg).mobile; psd_avg.region.(reg).mobile];
        psd_all.region.(reg).mob_sem = [psd_all.region.(reg).mob_sem; psd_avg.region.(reg).mob_std/sqrt(psd_avg.region.(reg).ntrials_mob)];
        
        
    end
end


% average across monkeys for each region 
for monkey = monkeys
    
        for reg = ["PPC","PFC","MST"]
        
        psd_avg_all.region.(reg).stationary = mean(psd_all.region.(reg).stationary);
        psd_avg_all.region.(reg).stat_sem = sum(psd_all.region.(reg).stat_sem);
        psd_avg_all.region.(reg).mobile = mean(psd_all.region.(reg).mobile);
        psd_avg_all.region.(reg).mob_sem = sum(psd_all.region.(reg).mob_sem);
        
        psd_avg_all.region.(reg).tot = (psd_avg_all.region.(reg).stationary + psd_avg_all.region.(reg).mobile)/2 ;
        psd_avg_all.region.(reg).tot_sem = psd_avg_all.region.(reg).stat_sem + psd_avg_all.region.(reg).mob_sem ;
               
        end 
        
        psd_avg_all.freq = psd_avg.freq;
end


for reg = ["PPC","PFC","MST"]

% MOBILE VS STATIONARY 
stat_mean =  psd_avg_all.region.(reg).stationary;
stat_mean_sem = psd_avg_all.region.(reg).stat_sem;

mob_mean =  psd_avg_all.region.(reg).mobile;
mob_mean_sem = psd_avg_all.region.(reg).mob_sem;

fig = figure;
shadedErrorBar(psd_avg.freq,stat_mean,stat_mean_sem,'lineprops',{'color',"#ff0000"},'patchSaturation',0.5); hold on % incorrect trials
shadedErrorBar(psd_avg.freq,mob_mean,mob_mean_sem,'lineprops',{'color',"#000000"  },'patchSaturation',0.5); hold on % correct trials

title(sprintf('%s',reg),'FontSize',12)
xlabel('freq (Hz)','FontName','Arial','FontSize',15);
ylabel('log(power)','FontName','Arial','FontSize',15);
set(gcf, 'Position',  [100, 500, 700, 500])
% set(gca,'FontSize',14)
% grid on
xlim([0 50])

hold off
legend({'stationary','mobile'},'FontSize',10,'FontName','Arial')

fname = strcat(dir_out,sprintf('%s_psd_mobile_stationary.png',reg));
saveas(fig,fname)
fname = strcat(dir_out,sprintf('%s_psd_mobile_stationary.pdf',reg));
saveas(fig,fname)


% ALL TOGETHER 

% MOBILE VS STATIONARY 
tot_mean =   psd_avg_all.region.(reg).tot;
tot_mean_sem =  psd_avg_all.region.(reg).tot_sem;

fig = figure;
shadedErrorBar(psd_avg.freq,tot_mean,tot_mean_sem,'lineprops',{'color',"#000000"},'patchSaturation',0.5); hold on % incorrect trials

title(sprintf('%s',reg),'FontSize',12)
xlabel('freq (Hz)','FontName','Arial','FontSize',15);
ylabel('log(power)','FontName','Arial','FontSize',15);
set(gcf, 'Position',  [100, 500, 700, 500])
% set(gca,'FontSize',14)
% grid on
xlim([0 50])


fname = strcat(dir_out,sprintf('%s_psd_TOT.png',reg));
saveas(fig,fname)
fname = strcat(dir_out,sprintf('%s_psd_TOT.pdf',reg));
saveas(fig,fname)


end 









