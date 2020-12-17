

% Tests12

% filename='Rastr_test.txt';
% h=0.05;
% neu_count = 60 ;
% 
% fid = fopen(filename, 'rt');
%   fseek(fid, 0, -1);
%   C = textscan(fid, '%f %d %f',-1);
%   fclose(fid);
%   % C{2} - neurons numebers
%   % C{1} - timings
%   cmin=min(C{1});
%   cmax=max(C{1});
%   tmax = floor((1+cmax-cmin)./h);
%   %RASTR = zeros(tmax, neu_count);
%   Spikes=cell(neu_count,1);
%   for i=1:1:length(C{1})
%       Spikes{C{2}(i)}=[Spikes{C{2}(i)}; floor((1+C{1}(i)-cmin)./h)];
%   end
  
N=4;
Spiketimes_all = cell( N , 1);
Spiketimes_all{1} = [ 1 1 1 ];
Spiketimes_all{2} = [ 0 0 0 ];
Spiketimes_all{3} = [ 2 2 2 ];
Spiketimes_all{4} = [ 3 3 3 ];

  %UNTITLED Summary of this function goes here
%%   Detailed explanation goes here
 
jm = findResource('scheduler','configuration','local');

pjob = jm.createParallelJob; 
set(pjob,'MaximumNumberOfWorkers',2 );
%%
set(pjob, 'FileDependencies', {'B:\Med64\Meaman\Connectivity_analysis_SpTrans'} );
%%
obj = createTask(pjob, @func1, 1, { N , Spiketimes_all } );%{conf.mode, conf.h, RASTR, conf.delay_m, conf.d_step, conf.fuzz});
%%
submit(pjob); waitForState(pjob);
%%
results = getAllOutputArguments(pjob);

res = results
 
%%
%сшивка результатов работы всех процессов в 4мерный массив и вычисление
Result_all ={};
for i=1:length( res)
   Result_all = [ Result_all ;  res{i} ] ;
end
Result_all
% res = res_produce(results);

clear results
destroy(pjob)







