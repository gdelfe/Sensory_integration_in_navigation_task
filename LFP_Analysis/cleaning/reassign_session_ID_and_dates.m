

dir_in = 'E:\Output\GINO\stats\';

% FOR ALL MONKEYS --------------------
monkey = "Quigley";
load(strcat(dir_in,sprintf('stats_%s_all_events.mat',monkey)));

stats(1).ids.sess_id = 185;
stats(1).ids.sess_date = '14-Feb-2018';

stats(2).ids.sess_id = 188;
stats(2).ids.sess_date = '21-Feb-2018';

stats(3).ids.sess_id = 207;
stats(3).ids.sess_date = '03-Apr-2018';

save(strcat(dir_in,sprintf('stats_%s_all_events.mat',monkey)),'stats','-v7.3');