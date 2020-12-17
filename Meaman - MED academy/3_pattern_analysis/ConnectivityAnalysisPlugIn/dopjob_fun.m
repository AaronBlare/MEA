function [ res ] = dopjob_fun(Fun, res_produce, fun_params, conf)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%jm = findResource('scheduler','type','jobmanager','Name',conf.jmName,'LookupURL',conf.host);
jm = findResource('scheduler','configuration','local');
pjob = jm.createParallelJob;
%%
%set(pjob,'MinimumNumberOfWorkers',conf.wc);
%set(pjob,'MaximumNumberOfWorkers',conf.wc);
%%
set(pjob, 'FileDependencies', {conf.dir});
%%
obj = createTask(pjob, Fun, 1, fun_params);%{conf.mode, conf.h, RASTR, conf.delay_m, conf.d_step, conf.fuzz});
%%
submit(pjob); waitForState(pjob);
%%
results = getAllOutputArguments(pjob);
%%
%сшивка результатов работы всех процессов в 4мерный массив и вычисление

res = res_produce(results);

clear results
destroy(pjob)

end