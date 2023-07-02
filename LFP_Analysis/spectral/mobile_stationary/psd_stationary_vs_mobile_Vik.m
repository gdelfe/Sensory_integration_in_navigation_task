
clear all; close all;
monkey = "Vik"
dir_in = 'E:\Output\GINO\stats\mobile_stationary\';
sess_range = [1,2,3];

load(strcat(dir_in,sprintf('task_%s_mobile_stationary.mat',monkey)));


% signal = [];
% 
% reg_names = fieldnames(task(1).region); % list of recorded brain regions (same for all sessions)
% 
% for region = 1:length(reg_names)
%     reg = reg_names{region}; % get region name
%     
%     for sess = sess_range % for each session
%         nch = length(task(sess).region.(reg).ch);
%         ntrials = length(task(sess).region.(reg).ch(1).stationary);
%         for trial = 1:ntrials-1 % for each trial
%             Xs = []; % lfp for a given trial, all channels
%             Xm = [];
%             for chnl = 1:nch % for each channel
%                 %                 keyboard
%                 Xs =  [Xs; task(sess).region.(reg).ch(chnl).stationary(trial).lfp]; % concatenate same trial for different channels
%                 Xm =  [Xm; task(sess).region.(reg).ch(chnl).mobile(trial).lfp]; % concatenate same trial for different channels
%             end
%             signal(sess).region.(reg).trials(trial).stationary_lfps = Xs;
%             signal(sess).region.(reg).trials(trial).mobile_lfps = Xm;
%         end
%         
%     end
% end
% 
% save(strcat(dir_in,sprintf('signal_%s_mobile_stationary.mat',monkey)),'signal','-v7.3');
% 

load(strcat(dir_in,sprintf('signal_%s_mobile_stationary.mat',monkey)))

reg_names = fieldnames(task(1).region); % list of recorded brain regions (same for all sessions)
sampling = 167;
f_max = 100;
W = 3;

for region = 1:length(reg_names)
    reg = reg_names{region}; % get region name
    
    for sess = sess_range % for each session
        nch = length(task(sess).region.(reg).ch);
        ntrials = length(task(sess).region.(reg).ch(1).stationary);
        for trial = 1:ntrials-1 % for each trial
            
            % stationary PSD
            Ns =  size(signal(sess).region.(reg).trials(trial).stationary_lfps,2);
            if Ns ~= 0
                Xs = signal(sess).region.(reg).trials(trial).stationary_lfps;
                [spec_stat, f_s] =  dmtspec(Xs,[Ns/sampling W],sampling,f_max,2,0.05,1);
                
                % store into PSD structure
                psd(sess).region.(reg).trials(trial).spec_s = spec_stat;
                psd(sess).region.(reg).trials(trial).fs = f_s;
            end
            % mobile PSD
            Nm =  size(signal(sess).region.(reg).trials(trial).mobile_lfps,2);
            if Nm ~= 0
                Xm = signal(sess).region.(reg).trials(trial).mobile_lfps;
                [spec_mob, f_m] =  dmtspec(Xm,[Nm/sampling W],sampling,f_max,2,0.05,1);
                
                psd(sess).region.(reg).trials(trial).spec_m = spec_mob;
                psd(sess).region.(reg).trials(trial).fm = f_m;
            end
            
            
            
        end
    end
end


save(strcat(dir_in,sprintf('psd_%s_mobile_stationary.mat',monkey)),'psd','-v7.3');




