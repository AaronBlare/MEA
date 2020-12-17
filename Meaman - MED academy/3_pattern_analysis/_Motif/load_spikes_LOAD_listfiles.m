
%  MED_AWSR_Find_Bursts
function load_spikes_LOAD_listfiles(Cycle_P_val_process ,ADJUST_SPIKES,PHASE_ON,FILE_LIST_PROCESS )

if nargin == 0
FILE_LIST_PROCESS = 'n' ; % 'y'-process list of files specefied in textfile
end


Cycle_P_val_process = 'n' ;  % if 'y' calc p-vals and jaccrd for all shifts from burst start 
 Pval_act_cycle =  'n'; % if 'y' - calc pval only of patttern activations of all rasters
 PREDEFINED_FILE_LIST = 'y' ; % if 'y' - calc pvals of defined file list 'specific_files_to_analyse

specific_files_to_analyse = { 'K:\MEA_DATA\good_rasters\20090407004_Raster_8sigma_ready\20090407004_Raster_8sigma_ready_BURSTS_spikes50ms_TimeBin.mat'   ...
'K:\MEA_DATA\good_rasters\20090506001_Raster_8sigma_ok\20090506001_Raster_8sigma_BURSTS_spikes50ms_TimeBin.mat' ...
    'K:\MEA_DATA\good_rasters\20090412001_Raster_8sigma_ok\20090412001_Raster_8sigma_BURSTS_spikes50ms_TimeBin.mat' ...
'K:\MEA_DATA\good_rasters\20090503003_Raster_8sigma_ok\20090503003_Raster_8sigma_BURSTS_spikes50ms_TimeBin.mat' ...
'K:\MEA_DATA\good_rasters\20090408002_Raster_8sigma_OK\20090408002_Raster_8sigma_BURSTS_spikes50ms_TimeBin.mat' ...
'K:\MEA_DATA\good_rasters\20090410002_Raster_8sigma_OK\20090410002_Raster_8sigma_BURSTS_spikes50ms_TimeBin.mat' };
 
 
 
 
file_in = 'n' ;
if FILE_LIST_PROCESS  ~= 'y'
    [filename,PathName] = uigetfile('*.*','Select file');
if filename ~= 0
   file_in = 'y' ; 


c_file = filename ;
[pathstr,name,ext,versn] = fileparts( c_file ) ;
% DATA_TYPE = ext ;
init_dir = cd ;
cd(  PathName );
DIR =[ pathstr PathName ];
n_files = 1 ;
end
else
% list_files = textread(files ,'%s');
init_dir = cd ;
init_dir_list = cd ;
% [filename, PathName] = uigetfile('*.*','Select file', 'MultiSelect', 'on') ;
files = uipickfiles
if length( files) > 1
    file_in = 'y' ;
else    
% if filename(1) ~= 0
   file_in = 'y' ;
% end 
end

if file_in == 'y' 
init_dir = cd ;
% list_files 
list_files = files ;
list_files{:}
n_files = length(list_files ) ;
end

end



tot_PP = [] ;
tot_TT = [] ;
tot_AE = [] ;
NOISE_t=[];
tot_DIFF = [] ;
tot_AVG_PATTERN_DUR = [] ;
tot_Pairs=[];
tot_PP_rel = [] ;
tot_TT_rel = [] ;
tot_AE_rel = [] ;
tot_DIFF_rel = [] ; 
tot_AVG_PATTERN_DUR_rel = [] ;

tot_Time_shift = [];   
tot_Time_shift_relative = []; 


if PREDEFINED_FILE_LIST == 'y'
file_in='y';
% list_files=cell(1,2);
list_files = specific_files_to_analyse ;
 
% list_files = { 'K:\MEA_DATA\good_rasters\20090407004_Raster_8sigma_ready\20090407004_Raster_8sigma_ready_BURSTS_spikes50ms_TimeBin.mat'   ...
%   'K:\MEA_DATA\good_rasters\20090408004_Raster_8sigma_ok\20090408004_Raster_8sigma_BURSTS_spikes50ms_TimeBin.mat' ...

n_files = 6 ;

  FILE_LIST_PROCESS = 'y' ;
list_files
  whos list_files  
  
end  

  
if file_in == 'y' 
for k= 1:n_files %---------------------------------------------------
    
if FILE_LIST_PROCESS == 'y'
c_file = char( list_files{ 1, k } ) 
[pathstr,name,ext,versn] = fileparts( c_file ) ;
% DATA_TYPE = ext ;
% init_dir = cd ;
% cd(init_dir_list);
cd(pathstr);
dir = c_file( 1 : strfind(   c_file , '.') -1  ) ;
end   

filename = c_file ; 




load_spikes_mat_cycle1
 
if Cycle_P_val_process == 'y' 
tot_PP = [ tot_PP PP' ] ;
tot_TT = [ tot_TT TT' ];
tot_AE = [ tot_AE AE' ] ;
tot_DIFF = [ tot_DIFF DIFF' ] ;
tot_AVG_PATTERN_DUR = [ tot_AVG_PATTERN_DUR AVG_PATTERN_DUR' ] ;
tot_Pairs=[ tot_Pairs Pairs' ];
tot_PP_rel = [ tot_PP_rel PP_rel' ] ;
tot_TT_rel = [ tot_TT_rel  TT_rel' ];
tot_AE_rel =[ tot_AE_rel AE_rel' ] ;
tot_DIFF_rel = [ tot_DIFF_rel DIFF_rel' ];
tot_AVG_PATTERN_DUR_rel =[ tot_AVG_PATTERN_DUR_rel AVG_PATTERN_DUR_rel' ] ;
tot_Time_shift = [tot_Time_shift   Time_shift   ];   
tot_Time_shift_relative = [tot_Time_shift_relative Time_shift_relative   ]; 
 Time_shift_relative
end


% if Cycle_P_val_process ~= 'y' &  Pval_act_cycle == 'y'  
    if Cycle_P_val_process ~= 'y'    
   tot_PP = [ tot_PP PP' ] ;
   tot_DIFF = [ tot_DIFF DIFF' ] ;
   tot_PP_rel = [ tot_PP_rel PP_rel' ] ;
   tot_DIFF_rel = [ tot_DIFF_rel DIFF_rel' ];
   tot_AVG_PATTERN_DUR = [ tot_AVG_PATTERN_DUR AVG_PATTERN_DUR ];
end  
    
fclose('all') ;
end



end


if Cycle_P_val_process ~= 'y'  
     
   tot_PP_mean = mean( tot_PP' ); 
   tot_PP_std = std( tot_PP' );
   tot_DIFF_mean = mean( tot_DIFF' ); 
   tot_DIFF_std = std( tot_DIFF' ); 
  NOISE_t= NOISE_t';
 tot_PP_mean = tot_PP_mean';
 tot_PP_std = tot_PP_std' ;
 tot_DIFF_mean = tot_DIFF_mean';
 tot_DIFF_std = tot_DIFF_std' ;
  NOISE_t 
 tot_PP_mean 
 tot_PP_std  
tot_DIFF_mean
tot_DIFF_std
   
   if  Pval_act_cycle ==  'y'
    figure
plot( NOISE_t ,tot_PP_mean  )
title( 'tot_PP_mean - Noise' )

    figure
plot( NOISE_t ,tot_DIFF_mean  )
title( 'tot_DIFF_mean - Noise' )

   end

%    figure
%    hist( tot_AVG_PATTERN_DUR )
% % 
% tot_AVG_PATTERN_DUR
end

%0---------------------------------------
if Cycle_P_val_process == 'y' 
    
    
a=size(tot_Time_shift_relative);
size(a);

tot_AE_mean = mean( tot_AE' );
tot_PP_mean = mean( tot_PP' );
tot_DIFF_mean = mean( tot_DIFF' );
tot_AVG_PATTERN_DUR_mean = mean( tot_AVG_PATTERN_DUR' );
tot_PP_rel_mean = mean( tot_PP_rel' );
tot_DIFF_rel_mean = mean( DIFF_rel' );

tot_AE_std = std( tot_AE' );
tot_PP_std = std( tot_PP' );
tot_DIFF_std = std( tot_DIFF' );
tot_AVG_PATTERN_DUR_std = std( tot_AVG_PATTERN_DUR' );
tot_PP_rel_std = std( tot_PP_rel' );
tot_DIFF_rel_std = std( DIFF_rel' );
 
whos tot_PP
whos tot_AE
whos tot_DIFF
whos tot_AVG_PATTERN_DUR
whos tot_PP_rel
whos tot_Time_shift
whos tot_Time_shift_relative 



figure
plot( tot_Time_shift_relative , tot_AE_mean )
title( 'tot AE mean')

figure
plot( tot_Time_shift_relative , tot_PP_mean )
title( 'tot PP mean')

figure
plot( tot_Time_shift_relative , tot_AE )
title( 'AE')
figure
plot( tot_Time_shift_relative , AVG_PATTERN_DUR )
title( 'AVG PATTERN_DUR')

figure
plot( tot_Time_shift_relative , tot_DIFF )
title( 'tot DIFF')

figure
plot( tot_Time_shift_relative , tot_DIFF_rel )
title( 'tot DIFF rel')

figure
plot( tot_Time_shift_relative , tot_PP )
title( 'tot PP')

figure
plot( tot_Time_shift_relative , tot_PP_rel )
title( 'tot PP rel')
 

        TimeBin = 50 ;
finame = [ 'TOTAL_similarity_analysis' int2str(TimeBin) 'ms_TimeBin.mat' ] ;
eval(['save ' char( finame )...
    ' tot_Time_shift tot_Time_shift_relative tot_PP tot_TT tot_AE  tot_DIFF tot_AVG_PATTERN_DUR tot_Pairs ' ...
    ' tot_PP_rel tot_TT_rel tot_AE_rel tot_DIFF_rel  tot_AVG_PATTERN_DUR_rel ' ...
    ' tot_AE_mean tot_PP_mean tot_DIFF_mean tot_AVG_PATTERN_DUR_mean tot_PP_rel_mean tot_DIFF_rel_mean '...
    ' tot_AE_std tot_PP_std tot_DIFF_std tot_AVG_PATTERN_DUR_std tot_PP_rel_std  tot_DIFF_rel_std -mat']); 
end 


cd( init_dir ) ;
clear;
