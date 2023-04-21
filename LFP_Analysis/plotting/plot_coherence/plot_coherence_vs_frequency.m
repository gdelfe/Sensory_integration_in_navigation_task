% Plot coherence vs frequency average across region i and region i-j for a
% given monkey
%
% @ Gino Del Ferraro, NYU, April 2023

clear all; close all;

% %%%%%%%%%%%%%%%%
% PATHS
% %%%%%%%%%%%%%%%
monkey = "Quigley";
dir_in = 'E:\Output\GINO\coherence\avg_coherences\';
dir_out = 'E:\Output\GINO\Figures\coherence\coherence_vs_frequency\';
density = ["high_den","low_den"];

% create directories 
dir_out_monkey = fullfile(dir_out + monkey);
if ~exist(dir_out_monkey, 'dir')
    mkdir(dir_out_monkey)
end


% load coherence files 
load(strcat(dir_in,sprintf('coherence_vs_frequency_%s.mat',monkey)));
reg_names = fieldnames(coh_vs_freq.high_den.reg_X);

% get region names
region_list = reg_names{1};
for reg = 2:length(reg_names)
    region_list = strcat(region_list,{' - '},reg_names{reg});
end
if length(reg_names) == 1
    region_list = {region_list};
end

% %%%%%%%%%%%%%%%%%%%
% OPTIC FLOW DENSITY


for i = 1:length(reg_names)
    reg_i = reg_names{i};
    for j = i:length(reg_names)
        reg_j = reg_names{j};
        
        colororder = ["#ff0000","#005ce6"];
        cnt = 1;
        fig = figure; hold all
        for den = density
            
            coh = coh_vs_freq.(den).reg_X.(reg_i).reg_Y.(reg_j).corr;
            sem = coh_vs_freq.(den).reg_X.(reg_i).reg_Y.(reg_j).sem;
            f = linspace(1,100,length(coh_vs_freq.(den).reg_X.(reg_i).reg_Y.(reg_j).corr)); 
            shadedErrorBar(f,coh,sem,'lineprops',{'color',colororder(cnt)},'patchSaturation',0.4)
            grid on
            cnt = cnt + 1;
        end
        title(sprintf('%s, %s - %s coherence vs frequency',monkey,reg_i,reg_j),'FontSize',10);
        legend('high den','low den');
        set(gcf, 'Position',  [100, 100, 600, 400])
        fname = strcat(dir_out_monkey,sprintf('\\coh_vs_freq_%s_density_%s_%s.png',monkey,reg_i,reg_j));
        saveas(fig,fname)
        
    end
end










