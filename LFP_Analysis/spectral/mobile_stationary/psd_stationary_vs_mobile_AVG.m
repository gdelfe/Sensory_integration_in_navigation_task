
clear all; close all;
monkey = "Vik"
dir_in = 'E:\Output\GINO\stats\mobile_stationary\';
sess_range = [1,2,3];


load(strcat(dir_in,sprintf('psd_%s_mobile_stationary.mat',monkey)));

if monkey == "Quigley"
    psd = copy_session_quigley(psd);
end

common_freq = 0:0.1:100; % common frequency vector
reg_names = fieldnames(psd(1).region); % list of recorded brain regions (same for all sessions)
psd_common = [];

for region = 1:length(reg_names)
    reg = reg_names{region}; % get region name
    
    for sess = sess_range % for each session
        ntrials = size(psd(sess).region.(reg).trials,2);
        for trial = 1:ntrials-1 % for each trial
            
            % stationary interpolation
            f_s = psd(sess).region.(reg).trials(trial).fs;
            spec_stat = psd(sess).region.(reg).trials(trial).spec_s;
            if ~isempty(spec_stat)
                psd1_common = interp1(f_s,spec_stat, common_freq, 'linear', 'extrap');
                psd_common(sess).region.(reg).trials(trial).spec_s = psd1_common;
            end
            
            % mobile interpolation
            f_m = psd(sess).region.(reg).trials(trial).fm;
            spec_mob = psd(sess).region.(reg).trials(trial).spec_m;
            if ~isempty(spec_mob)
                psd2_common = interp1(f_m,spec_mob, common_freq, 'linear', 'extrap');
                psd_common(sess).region.(reg).trials(trial).spec_m = psd2_common;
            end
            
        end
    end
end


% stack together mobile trials
% stack together stationary trials
%




for region = 1:length(reg_names)
    reg = reg_names{region}; % get region name
    
    psd_stack.region.(reg).stationary = [];
    psd_stack.region.(reg).mobile = [];
    
    for sess = sess_range % for each session
        ntrials = size(psd_common(sess).region.(reg).trials,2);
        for trial = 1:ntrials-1 % for each trial
            
            psd_stack.region.(reg).stationary = [psd_stack.region.(reg).stationary; log10(psd_common(sess).region.(reg).trials(trial).spec_s)];
            psd_stack.region.(reg).mobile = [psd_stack.region.(reg).mobile; log10(psd_common(sess).region.(reg).trials(trial).spec_m)];
            
        end
    end
end


for region = 1:length(reg_names)
    reg = reg_names{region}; % get region name
    
    % Store in psd avg, mean and std, frequency, and number of trials
    psd_avg.region.(reg).stationary = mean(psd_stack.region.(reg).stationary,1);
    psd_avg.region.(reg).stat_std = std(psd_stack.region.(reg).stationary);
    
    psd_avg.region.(reg).mobile = mean(psd_stack.region.(reg).mobile,1);
    psd_avg.region.(reg).mob_std = std(psd_stack.region.(reg).mobile);
    
    psd_avg.region.(reg).ntrials_stat = size(psd_stack.region.(reg).stationary,1);
    psd_avg.region.(reg).ntrials_mob = size(psd_stack.region.(reg).mobile,1);
    
end

psd_avg.freq = common_freq;

save(strcat(dir_in,sprintf('psd_avg_%s_mobile_stationary.mat',monkey)),'psd_avg','-v7.3');

keyboard 

reg = "MST";
err_stat = psd_avg.region.(reg).stat_std/sqrt(psd_avg.region.(reg).ntrials_stat);
err_mob = psd_avg.region.(reg).mob_std/sqrt(psd_avg.region.(reg).ntrials_mob);

fig = figure;
shadedErrorBar(psd_avg.freq,psd_avg.region.(reg).stationary,err_stat,'lineprops',{'color',"#009900"},'patchSaturation',0.5); hold on % incorrect trials
shadedErrorBar(psd_avg.freq,psd_avg.region.(reg).mobile,err_mob,'lineprops',{'color',"#00ff00"  },'patchSaturation',0.5); hold on % correct trials

title('','FontSize',12)
xlabel('freq (Hz)','FontName','Arial','FontSize',15);
ylabel('log(power)','FontName','Arial','FontSize',15);
set(gcf, 'Position',  [100, 500, 700, 500])
% set(gca,'FontSize',14)
grid on
xlim([0 50])

hold off
legend({'stationary','mobile'},'FontSize',10,'FontName','Arial')


