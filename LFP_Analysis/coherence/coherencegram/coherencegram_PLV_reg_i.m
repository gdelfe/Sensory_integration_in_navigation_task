
% Compute coherengram across all channel pairs within region i.
% Compute the averages across channels for a give session. 
%
% Compute PLV and instantaneous phase difference across all trials and 
% average across channels. 
% 
% Computations are done for one session, one event, and a given reg_i
% in order to parallelize the calculations on a HPC cluster.
% 
% INPUT: monkey name, session, event type, brain region i
%
% OUTPUT: saved into two different structures: 1. coherencegram, 2. PLV and
% phase differences.
%
% Gino Del Ferraro, NYU, May 2023.

function [] = coherencegram_PLV_reg_i(monkey,sess,EventType,reg_i)

addpath(genpath('C:\Users\gd2112\Documents\Navigation_task'))

if nargin ~= 4
    fprintf('Error. Input parameters are:  monkey, sess, EventType, region_i, region_j')
    return;
end 

sess = str2double(sess);

% Display the input parameters
fprintf('Input parameters:\n');
fprintf('monkey = %s\n', monkey);
fprintf('session = %d\n', sess);
fprintf('event = %s\n', EventType);
fprintf('region i = %s\n', reg_i);
 

% %%%%%%%%%%%%%%%%
% PATHS
% %%%%%%%%%%%%%%%

% input and output directories 
dir_in = 'E:\Output\GINO\stats\';
dir_out = 'E:\Output\GINO\coherence\coherencegrams\all_channels\';
dir_out_phase = 'E:\Output\GINO\coherence\phase_PLV\';


% parameters for multi-tapers analysis 
tapers = [0.5 5];
dn = 0.05;
fk = 100; % frequency upper value 

% load stat density structure with LFPs data 
load(strcat(dir_in,sprintf('stats_%s_all_events_R_NR_density_clean.mat',monkey)));


% compute coherencegrams, PLV, and phase difference, across all channel-pairs, for a given session                                      
[coherencegram,PLV_sess] = compute_coherencegram_and_PLV_regi_R_NR(stats,sess,EventType,reg_i,fk,tapers,dn);
      
% save results 
save(strcat(dir_out,sprintf('coherencegram_%s_sess_%d_event_%s_%s_%s.mat',monkey,sess,EventType,reg_i,reg_i)),'coherencegram','-v7.3');
save(strcat(dir_out_phase,sprintf('PLV_phase_%s_sess_%d_event_%s_%s_%s.mat',monkey,sess,EventType,reg_i,reg_i)),'PLV_sess','-v7.3');



end 
