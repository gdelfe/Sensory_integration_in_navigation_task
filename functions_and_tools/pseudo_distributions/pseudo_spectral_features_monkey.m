% -------------------------------------------------------------------
%  Generated by MATLAB on 9-Jan-2023 14:54:19
%  MATLAB version: 9.9.0.1538559 (R2020b) Update 3
% -------------------------------------------------------------------
saveVarsMat = load('pseudo_spectral_features_monkey.mat');

ans = [264 1245];

dir_out = 'E:\Output\GINO\stats\';

monkey = saveVarsMat.monkey; % <1x1 string> unsupported class

stats = saveVarsMat.stats; % <1x3 struct> too many elements at stats(1).region.PPC.event.target.rwd(1).ch(1).lfp

clear saveVarsMat;