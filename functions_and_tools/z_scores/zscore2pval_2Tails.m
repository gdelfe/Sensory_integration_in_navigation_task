%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Convert zscore to p value for a Two Tails test

function pval = zscore2pval_2Tails(z)
    pval = (1-normcdf(abs(z)))*2;
end