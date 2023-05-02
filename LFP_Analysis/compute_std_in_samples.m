
% 1D data set 
a = 50;
b = 100;
r = (b-a).*rand(1,100) + a;

mr = mean(r);
sr = std(r);

% split data set 
r1 = r(1:50);
r2 = r(51:end);
sr1 = std(r1);
sr2 = std(r2);

mr1 = mean(r1,2);
mr2 = mean(r2,2);

mr1r2 = mean([mr1,mr2]);

sr1r2 = sqrt((sr1^2 + mr1^2 + sr2^2 + mr2^2)/2 - mr1r2^2);



% 2D data set 

a = 50;
b = 100;
r1 = (b-a).*rand(10,50) + a;

a = 10;
b = 30;
r2 = (b-a).*rand(10,50) + a;

r = [r1,r2];

L = reshape(r,[],1);
mL = mean(L);
sL = std(L);

mr = mean(r,2);
sr = std(r,[],2);

r1 = r(:,1:50); % session 1
r2 = r(:,51:end); % session 2

mr1 = mean(r1,2);
mr2 = mean(r2,2);
sr1 = std(r1,[],2);
sr2 = std(r2,[],2);

mr1r2 = mean([mr1,mr2],2);
sr1r2 = sqrt((sr1.^2 + mr1.^2 + sr2.^2 + mr2.^2)/2 - mr1r2.^2); % std across session 1 and 2 

mt = mean(mr1r2);
st = sqrt(mean(sr1r2.^2 + mr1r2.^2) - mt^2); % std across frequency range 





