
% LOAD_2files_Distance_in_motif_raster

DEFINED_FILE_LIST = true ;
% DEFINED_FILE_LIST = false ;
 
tic

%--- MAIN parameters---------------
 Start_t = 20 ;
 Pattern_length_ms = 300 ; 
 Total_burst_len =300 ;
 DT_step= 20 ;
 STIM_RESPONSE_BOTH_INPUTS = 0.7 ;
ANALYSE_SIMILARITY = true ;
OVERLAP_TRESHOLD = 15 ;
PvalRanksum = 0.05 ;
Spike_Rates_each_burst_cut_Threshold_precent = 30 ; % Threshold for small bursts, % from Maximum burst
%----------------------
Cycle_close_all = false ; % if true - close all plots in each entry of cycle mane experiments
ANALYSE_ONE_EXPERIMENT =  1  ; % [1,7, 15 - is good]if > 0 will analyse only exepiment from list with number ANALYSE_ONE_EXPERIMENT
Exclude_experiments_list = []; %[10 13 14 22 23 25];
GLOB_cycle_start =2 ; %2
GLOB_cycle_step =1;   % 1
GLOB_cycle_end =2;   % 64

% 20110108002_d14_h6_stim_13-14
% filename = 'K:\MEA_DATA\2011_INCUBATOR\2011_01_08\Analyzed_20110108002_d15_h6_stim_13-14_8_sigma\_20110108002_d15_h6_stim_13-14_Artefact_8sigma_Post_20ms_Stimlus_responses.mat' ;
% filename2 = 'K:\MEA_DATA\2011_INCUBATOR\2011_01_08\Analyzed_20110108002_d15_h6_stim_51-52_8_sigma\_20110108002_d15_h6_stim_51-52_Artefact_8sigma_Post_20ms_Stimlus_responses.mat' ;
% filename = '_20110108002_d15_h6_stim_13-14_Artefact_8sigma_Post_20ms_Stimlus_responses.mat' ;
% filename2 = '_20110108002_d15_h6_stim_51-52_Artefact_8sigma_Post_20ms_Stimlus_responses.mat' ;
% files={ filename}; files2={ filename2};

%good
% 20110109_d15_h4_stim08_52-53_8_sigma  
  filename = 'K:\MEA_DATA\2011_INCUBATOR\2011_01_09\20101226_h4\Analyzed_20110109_d15_h4_stim08_52-53_8_sigma\_20110109_d15_h4_stim08_52-53_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';  
 filename2 = 'K:\MEA_DATA\2011_INCUBATOR\2011_01_09\20101226_h4\Analyzed_20110109_d15_h4_stim09_49-57_8_sigma\_20110109_d15_h4_stim09_49-57_Artefact_8sigma_Post_20ms_Stimlus_responses.mat' ;
%   filename = 'K:\MEA_DATA\2011_INCUBATOR\2011_01_09\20101226_h4\Analyzed_20110109_d15_h4_stim10_52-53_8_sigma\_20110109_d15_h4_stim10_52-53_Artefact_8sigma_Post_20ms_Stimlus_responses.mat'; 
%  filename2 = 'K:\MEA_DATA\2011_INCUBATOR\2011_01_15\122210\Analyzed_20110115010_d18_h3_08_stim_58-59_8_sigma\_20110115010_d18_h3_08_stim_58-59_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
% files=[ files  ; filename]; files2=[ files2 ; filename2];
files={ filename}; files2={ filename2};

% good
% 20110109_d15_h6_stim02_46-54 
filename = 'K:\MEA_DATA\2011_INCUBATOR\2011_01_09\20101226_h6\Analyzed_20110109_d16_h6_stim02_46-54_8_sigma\_20110109_d16_h6_stim02_46-54_Artefact_8sigma_Post_20ms_Stimlus_responses.mat' ;
filename2 = 'K:\MEA_DATA\2011_INCUBATOR\2011_01_09\20101226_h6\Analyzed_20110109_d16_h6_stim03_15-16_8_sigma\_20110109_d16_h6_stim03_15-16_Artefact_8sigma_Post_20ms_Stimlus_responses.mat' ;
files=[ files  ; filename]; files2=[ files2 ; filename2];



%low electrodes
% %  20110115016_d24_h3_05_stim_7-8
%    filename = 'K:\MEA_DATA\2011_INCUBATOR\2011_01_15\122210\Analyzed_20110115016_d24_h3_05_stim_7-8_8_sigma\_20110115016_d24_h3_05_stim_7-8_Artefact_8sigma_Post_20ms_Stimlus_responses.mat'; 
%    filename2 = 'K:\MEA_DATA\2011_INCUBATOR\2011_01_15\122210\Analyzed_20110115017_d24_h3_06_stim_47-55_8_sigma\_20110115017_d24_h3_06_stim_47-55_Artefact_8sigma_Post_20ms_Stimlus_responses.mat'; 
% %  filename = 'K:\MEA_DATA\2011_INCUBATOR\2011_01_15\122210\Analyzed_20110115018_d24_h3_07_stim_7-8_8_sigma\_20110115018_d24_h3_07_stim_7-8_Artefact_8sigma_Post_20ms_Stimlus_responses.mat'; 
% %   filename2 ='K:\MEA_DATA\2011_INCUBATOR\2011_01_15\122210\Analyzed_20110115019_d24_h3_08_stim_47-55_8_sigma\_20110115019_d24_h3_08_stim_47-55_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
% files=[ files  ; filename]; files2=[ files2 ; filename2];
 

%--------------------------- same culture
% 20110115004_d18_h3_02_stim_6-7
%    filename = ...
%    'K:\MEA_DATA\2011_INCUBATOR\2011_01_15\122810\Analyzed_20110115007_d18_h3_05_stim_6-7_8_sigma\_20110115007_d18_h3_05_stim_6-7_Artefact_8sigma_Post_20ms_Stimlus_responses.mat'; 
%    filename2 =...
%    'K:\MEA_DATA\2011_INCUBATOR\2011_01_15\122810\Analyzed_20110115008_d18_h3_06_stim_58-59_8_sigma\_20110115008_d18_h3_06_stim_58-59_Artefact_8sigma_Post_20ms_Stimlus_responses.mat'; 
% files=[ files  ; filename]; files2=[ files2 ; filename2];

% % 20110115007_d18_h3_05_stim_6-7  ----------!!!!!!! Repeatition of PREVIOUS
%                 filename = ...
%    'K:\MEA_DATA\2011_INCUBATOR\2011_01_15\122210\Analyzed_20110115007_d18_h3_05_stim_6-7_8_sigma\_20110115007_d18_h3_05_stim_6-7_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
%                 filename2 =...
%    'K:\MEA_DATA\2011_INCUBATOR\2011_01_15\122210\Analyzed_20110115008_d18_h3_06_stim_58-59_8_sigma\_20110115008_d18_h3_06_stim_58-59_Artefact_8sigma_Post_20ms_Stimlus_responses.mat'; 
%  files=[ files  ; filename]; files2=[ files2 ; filename2]; 
%    filename =
%    'K:\K:\MEA_DATA\2011_INCUBATOR\2011_01_15\122210\Analyzed_20110115009_d18_h3_07_stim_6-7_8_sigma\_20110115009_d18_h3_07_stim_6-7_Artefact_8sigma_Post_20ms_Stimlus_responses.mat'; 
% filename2 =
%    'K:\MEA_DATA\2011_INCUBATOR\2011_01_15\122210\Analyzed_20110115010_d18_h3_08_stim_58-59_8_sigma\_20110115010_d18_h3_08_stim_58-59_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
% files=[ files  ; filename]; files2=[ files2 ; filename2]; 
% ----------------------------------------------



% %good
% 20110119005_d25_h4_03_stim_29-30
   filename = ...
    'K:\MEA_DATA\2011_INCUBATOR\2011_01_19\122510\Analyzed_20110119004_d25_h4_02_stim_26-27_8_sigma\_20110119004_d25_h4_02_stim_26-27_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
filename2 =...
   'K:\MEA_DATA\2011_INCUBATOR\2011_01_19\122510\Analyzed_20110119006_d25_h4_04_stim_51-59_8_sigma\_20110119006_d25_h4_04_stim_51-59_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
files=[ files  ; filename]; files2=[ files2 ; filename2];


%  good
% 20110119006_d24_h4_02_stim_1-2
   filename =...
   'K:\MEA_DATA\2011_INCUBATOR\2011_01_19\122610\Analyzed_20110119006_d24_h4_02_stim_1-2_8_sigma\_20110119006_d24_h4_02_stim_1-2_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
filename2 =...
   'K:\MEA_DATA\2011_INCUBATOR\2011_01_19\122610\Analyzed_20110119007_d24_h4_03_stim_51-59_8_sigma\_20110119007_d24_h4_03_stim_51-59_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
files=[ files  ; filename]; files2=[ files2 ; filename2];


 %  good
% 20110120002_d25_h5_02_stim_7-8
filename =...
   'K:\MEA_DATA\2011_INCUBATOR\2011_01_20\122610\Analyzed_20110120002_d25_h5_02_stim_7-8_8_sigma\_20110120002_d25_h5_02_stim_7-8_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
  filename2 ='K:\MEA_DATA\2011_INCUBATOR\2011_01_20\122610\Analyzed_20110120003_d25_h5_03_stim_53-54_8_sigma\_20110120003_d25_h5_03_stim_53-54_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
files = [ files  ; filename]; files2 = [ files2 ; filename2];




% %LOW ELECTRODES
% % 20110121002_d30_h3_02_stim_47-55  
%   filename = 'K:\MEA_DATA\2011_INCUBATOR\2011_01_21\122210\Analyzed_20110121002_d30_h3_02_stim_47-55_8_sigma\_20110121002_d30_h3_02_stim_47-55_Artefact_8sigma_Post_20ms_Stimlus_responses.mat' ;
%   filename2 ='K:\MEA_DATA\2011_INCUBATOR\2011_01_21\122210\Analyzed_20110121004_d30_h3_04_stim_7-8_7_sigma\_20110121004_d30_h3_04_stim_7-8_Artefact_7sigma_Post_20ms_Stimlus_responses.mat' ;
% files = [ files  ; filename]; files2 = [ files2 ; filename2];




% % ---------------------------------------
  filename = ...
 'K:\MEA_DATA\2011_INCUBATOR\2011_03_04\Analyzed_20110304008_d17_h5_stim_3-11_8_sigma\_20110304008_d17_h5_stim_3-11_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
filename2 = ...
 'K:\MEA_DATA\2011_INCUBATOR\2011_03_04\Analyzed_20110304009_d17_h5_stim_14-15_8_sigma\_20110304009_d17_h5_stim_14-15_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
 files=[ files  ; filename]; files2=[ files2 ; filename2];

  filename = ...
 'K:\MEA_DATA\2011_INCUBATOR\2011_03_04\Analyzed_20110304009_d17_h5_stim_14-15_8_sigma\_20110304009_d17_h5_stim_14-15_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
 filename2 = ...
 'K:\MEA_DATA\2011_INCUBATOR\2011_03_04\Analyzed_20110304010_d17_h5_stim_50-51_8_sigma\_20110304010_d17_h5_stim_50-51_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
   files=[ files  ; filename]; files2=[ files2 ; filename2];

   filename = ...
 'K:\MEA_DATA\2011_INCUBATOR\2011_03_04\Analyzed_20110304011_d17_h5_stim_3-11_8_sigma\_20110304011_d17_h5_stim_3-11_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
 filename2 = ...
 'K:\MEA_DATA\2011_INCUBATOR\2011_03_04\Analyzed_20110304013_d17_h5_stim_50-51_8_sigma\_20110304013_d17_h5_stim_50-51_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
 files=[ files  ; filename]; files2=[ files2 ; filename2];
% ---------------------------------------




%    filename = ...
%    'K:\MEA_DATA\2011_INCUBATOR\2011_03_04\Analyzed_20110304019_d17_h1_stim_18-19_8_sigma\_20110304019_d17_h1_stim_18-19_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
% filename2 = ...
%    'K:\MEA_DATA\2011_INCUBATOR\2011_03_04\Analyzed_20110304020_d17_h1_stim_36-44_8_sigma\_20110304020_d17_h1_stim_36-44_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
% % files=[ files  ; filename]; files2=[ files2 ; filename2];

%    filename = ...
%    'K:\MEA_DATA\2011_INCUBATOR\2011_03_04\Analyzed_20110304019_d17_h1_stim_18-19_8_sigma\_20110304019_d17_h1_stim_18-19_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
% filename2 = ...
%    'K:\MEA_DATA\2011_INCUBATOR\2011_03_04\Analyzed_20110304020_d17_h1_stim_36-44_8_sigma\_20110304020_d17_h1_stim_36-44_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
% % files=[ files  ; filename]; files2=[ files2 ; filename2];

% ---------------------------------------







%  good
% 20110305004_d18_h5_stim_50-51
 filename = ...
'K:\MEA_DATA\2011_INCUBATOR\2011_03_05\Analyzed_20110305004_d18_h5_stim_50-51_8_sigma\_20110305004_d18_h5_stim_50-51_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
filename2 = ...
'K:\MEA_DATA\2011_INCUBATOR\2011_03_05\Analyzed_20110305005_d18_h5_stim_9-10_8_sigma\_20110305005_d18_h5_stim_9-10_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
files=[ files  ; filename]; files2=[ files2 ; filename2];


 filename = ...
'K:\MEA_DATA\2011_INCUBATOR\2011_03_05\Analyzed_20110305006_d18_h5_stim_18-19_8_sigma\_20110305006_d18_h5_stim_18-19_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
filename2 = ...
'K:\MEA_DATA\2011_INCUBATOR\2011_03_05\Analyzed_20110305005_d18_h5_stim_9-10_8_sigma\_20110305005_d18_h5_stim_9-10_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
files=[ files  ; filename]; files2=[ files2 ; filename2];

 filename = ...
 'K:\MEA_DATA\2011_INCUBATOR\2011_03_05\Analyzed_20110305007_d18_h5_stim_14-15_8_sigma\_20110305007_d18_h5_stim_14-15_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
filename2 = ...
 'K:\MEA_DATA\2011_INCUBATOR\2011_03_05\Analyzed_20110305008_d18_h5_stim_50-51_8_sigma\_20110305008_d18_h5_stim_50-51_Artefact_8sigma_Post_20ms_Stimlus_responses.mat' ;
files=[ files  ; filename]; files2=[ files2 ; filename2];


 filename = ...
 'K:\MEA_DATA\2011_INCUBATOR\2011_03_05\Analyzed_20110305008_d18_h5_stim_50-51_8_sigma\_20110305008_d18_h5_stim_50-51_Artefact_8sigma_Post_20ms_Stimlus_responses.mat' ;
filename2 = ...
 'K:\MEA_DATA\2011_INCUBATOR\2011_03_05\Analyzed_20110305010_d18_h5_stim_18-19_8_sigma\_20110305010_d18_h5_stim_18-19_Artefact_8sigma_Post_20ms_Stimlus_responses.mat' ;
files=[ files  ; filename]; files2=[ files2 ; filename2];


% ---------------------------------------
 filename = ...
'K:\MEA_DATA\2011_INCUBATOR\2011_03_06\Analyzed_20110306013_d19_h1_stim_14-22_8_sigma\_20110306013_d19_h1_stim_14-22_Raster_8sigma_Post_20ms_Stimlus_responses.mat';
filename2 = ...
'K:\MEA_DATA\2011_INCUBATOR\2011_03_06\Analyzed_20110306014_d19_h1_stim_18-19_8_sigma\_20110306014_d19_h1_stim_18-19_Raster_8sigma_Post_20ms_Stimlus_responses.mat';
files=[ files  ; filename]; files2=[ files2 ; filename2];

 filename = ...
'K:\MEA_DATA\2011_INCUBATOR\2011_03_06\Analyzed_20110306015_d19_h1_stim_36-44_8_sigma\_20110306015_d19_h1_stim_36-44_Raster_8sigma_Post_20ms_Stimlus_responses.mat';
filename2 = ...
'K:\MEA_DATA\2011_INCUBATOR\2011_03_06\Analyzed_20110306014_d19_h1_stim_18-19_8_sigma\_20110306014_d19_h1_stim_18-19_Raster_8sigma_Post_20ms_Stimlus_responses.mat';
files=[ files  ; filename]; files2=[ files2 ; filename2];

% ---------------------------------------
%good
% % 20110307005_d20_h5_stim_9-10   
filename = 'K:\MEA_DATA\2011_INCUBATOR\2011_03_07\Analyzed_20110307004_d20_h5_stim_50-51_8_sigma\_20110307004_d20_h5_stim_50-51_Artefact_8sigma_Post_20ms_Stimlus_responses.mat' ;
     filename2 = 'K:\MEA_DATA\2011_INCUBATOR\2011_03_07\Analyzed_20110307005_d20_h5_stim_9-10_8_sigma\_20110307005_d20_h5_stim_9-10_Artefact_8sigma_Post_20ms_Stimlus_responses.mat' ;
%      filename2 ='K:\MEA_DATA\2011_INCUBATOR\2011_03_07\Analyzed_20110307008_d20_h5_stim_50-51_8_sigma\_20110307008_d20_h5_stim_50-51_Artefact_8sigma_Post_20ms_Stimlus_responses.mat' ;
% ='K:\MEA_DATA\2011_INCUBATOR\2011_03_07\Analyzed_20110307010_d20_h5_stim_18-19_8_sigma\_20110307010_d20_h5_stim_18-19_Artefact_8sigma_Post_20ms_Stimlus_responses.mat' ;
files = [ files  ; filename]; files2 = [ files2 ; filename2];
 
filename =...
      'K:\MEA_DATA\2011_INCUBATOR\2011_03_07\Analyzed_20110307006_d20_h5_stim_18-19_8_sigma\_20110307006_d20_h5_stim_18-19_Artefact_8sigma_Post_20ms_Stimlus_responses.mat' ;
     filename2 = 'K:\MEA_DATA\2011_INCUBATOR\2011_03_07\Analyzed_20110307005_d20_h5_stim_9-10_8_sigma\_20110307005_d20_h5_stim_9-10_Artefact_8sigma_Post_20ms_Stimlus_responses.mat' ;
 files = [ files  ; filename]; files2 = [ files2 ; filename2];
% ---------------------------------------

  
% ---------------------------------------
%  good
filename = ...
'K:\MEA_DATA\2011_INCUBATOR\2011_03_13\Analyzed_20110313009_d26_h2_stim_4-5_8_sigma\_20110313009_d26_h2_stim_4-5_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
filename2 = ...
'K:\MEA_DATA\2011_INCUBATOR\2011_03_13\Analyzed_20110313014_d26_h2_stim_32-40_8_sigma\_20110313014_d26_h2_stim_32-40_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
files=[ files  ; filename]; files2=[ files2 ; filename2];
 

filename = ...
'K:\MEA_DATA\2011_INCUBATOR\2011_03_13\Analyzed_20110313010_d26_h2_stim_6-7_8_sigma\_20110313010_d26_h2_stim_6-7_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
filename2 = ...
'K:\MEA_DATA\2011_INCUBATOR\2011_03_13\Analyzed_20110313016_d26_h2_stim_53-61_8_sigma\_20110313016_d26_h2_stim_53-61_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
files=[ files  ; filename]; files2=[ files2 ; filename2];

filename = ...
'K:\MEA_DATA\2011_INCUBATOR\2011_03_13\Analyzed_20110313012_d26_h2_stim_14-15_8_sigma\_20110313012_d26_h2_stim_14-15_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
filename2 = ...
'K:\MEA_DATA\2011_INCUBATOR\2011_03_13\Analyzed_20110313017_d26_h2_stim_61-62_8_sigma\_20110313017_d26_h2_stim_61-62_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
files=[ files  ; filename]; files2=[ files2 ; filename2];


filename = ...
'K:\MEA_DATA\2011_INCUBATOR\2011_03_13\Analyzed_20110313013_d26_h2_stim_30-38_8_sigma\_20110313013_d26_h2_stim_30-38_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
filename2 = ...
'K:\MEA_DATA\2011_INCUBATOR\2011_03_13\Analyzed_20110313018_d26_h2_stim_42-50_8_sigma\_20110313018_d26_h2_stim_42-50_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
files=[ files  ; filename]; files2=[ files2 ; filename2];
% % 20110313009_d26_h2_stim_4-5 
%%% ERROR IN ANALYSIS
% filename = ...
% 'K:\MEA_DATA\2011_INCUBATOR\2011_03_13\Analyzed_20110313009_d26_h2_stim_4-5_8_sigma\_20110313009_d26_h2_stim_4-5_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
% filename2 = ...
% 'K:\MEA_DATA\2011_INCUBATOR\2011_03_13\Analyzed_20110313011_d26_h2_stim_14-22_8_sigma\_20110313011_d26_h2_stim_14-22_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
% files=[ files  ; filename]; files2=[ files2 ; filename2];


filename = ...
'K:\MEA_DATA\2011_INCUBATOR\2011_03_13\Analyzed_20110313013_d26_h2_stim_30-38_8_sigma\_20110313013_d26_h2_stim_30-38_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
% filename2 = ...
% 'K:\MEA_DATA\2011_INCUBATOR\2011_03_13\Analyzed_20110313014_d26_h2_stim_3
% 2-40_8_sigma\_20110313014_d26_h2_stim_32-40_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
filename2 = ...
'K:\MEA_DATA\2011_INCUBATOR\2011_03_13\Analyzed_20110313015_d26_h2_stim_44-45_8_sigma\_20110313015_d26_h2_stim_44-45_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
files=[ files  ; filename]; files2=[ files2 ; filename2];
% ---------++++++++++++++------------

filename = ...
'K:\MEA_DATA\2011_INCUBATOR\2011_04_08\Analyzed_20110408001_h4_stim_50_58ch_8_sigma\_20110408001_h4_stim_50_58ch_Raster_8sigma_Post_20ms_Stimlus_responses.mat'; 
filename2 = ...
'K:\MEA_DATA\2011_INCUBATOR\2011_04_08\Analyzed_20110408001_h4_stim_56_64_8_sigma\_20110408001_h4_stim_56_64_Raster_8sigma_Post_20ms_Stimlus_responses.mat';
files=[ files  ; filename]; files2=[ files2 ; filename2];
% ---------++++++++++++++------------
filename = ...
'K:\MEA_DATA\2011_INCUBATOR\2011_06_14\Analyzed_20110614007_d23_h1_stim01_7-15_10min_8_sigma\_20110614007_d23_h1_stim01_7-15_10min_Artefact_8sigma_Post_20ms_Stimlus_responses.mat'; 
filename2 = ...
'K:\MEA_DATA\2011_INCUBATOR\2011_06_14\Analyzed_20110614008_d23_h1_stim02_48-50_10min_8_sigma\_20110614008_d23_h1_stim02_48-50_10min_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
files=[ files  ; filename]; files2=[ files2 ; filename2];
% ---------++++++++++++++------------
filename = ...
'K:\MEA_DATA\2011_INCUBATOR\2011_06_15\Analyzed_20110615005_d24_h4_stim_ch14-15_10min_8_sigma\_20110615005_d24_h4_stim_ch14-15_10min_Artefact_8sigma_Post_20ms_Stimlus_responses.mat'; 
filename2 = ...
'K:\MEA_DATA\2011_INCUBATOR\2011_06_15\Analyzed_20110615006_d24_h4_stim_ch3-11_10min_8_sigma\_20110615006_d24_h4_stim_ch3-11_10min_Raster_8sigma_Post_20ms_Stimlus_responses.mat';
files=[ files  ; filename]; files2=[ files2 ; filename2];
% ---------------------------------------

% ---------------------------------------
filename = ...
'K:\MEA_DATA\2011_INCUBATOR\2011_06_24\Analyzed_20110624004_d32_h3_stim_ch23-24_10min_8_sigma\_20110624004_d32_h3_stim_ch23-24_10min_Artefact_8sigma_Post_20ms_Stimlus_responses.mat'; 
filename2 = ...
'K:\MEA_DATA\2011_INCUBATOR\2011_06_24\Analyzed_20110624005_d32_h3_stim_ch32-40_10min_8_sigma\_20110624005_d32_h3_stim_ch32-40_10min_Artefact_8sigma_Post_20ms_Stimlus_responses.mat';
files=[ files  ; filename]; files2=[ files2 ; filename2];
% ---------------------------------------


N_exeperiments_start =  1 ;
N_exeperiments = length( files ) ;
%!!!!!!!!!!!!!!!!!!!!!!!!
%!!!!!!!!!!!!!!!!!!!!!!!!
% N_exeperiments_start =  5 ;
% N_exeperiments = 3  ;
%!!!!!!!!!!!!!!!!!!!!!!!!
 
if ANALYSE_ONE_EXPERIMENT > 0
    N_exeperiments_start =  ANALYSE_ONE_EXPERIMENT ;
    N_exeperiments = ANALYSE_ONE_EXPERIMENT ;
end

Global_loop_var_data =[];
Global_LOOP_TOTAL_RESULT_experiments_avg = []; 
Global_LOOP_TOTAL_RESULT_experiments_std =[]; 
Global_LOOP_TOTAL_RESULT_experiments_all = [];


if DEFINED_FILE_LIST ~= true
[filename, pathname] = uigetfile('*.*','Select file') ;
 [filename2, pathname2] = uigetfile('*.*','Select file') ;
 cd( pathname ) ;   
 N_exeperiments=1;
 N_exeperiments_start=1;
end
N_exeperiments

%!!!!!!!!!!!!!!!!!!!!!!!!
%----GLOBAL LOOP-----------------------------
Nx=0;
   


%--- Variables if files loop-----   
%  for   Global_loop_var= 0.3 :0.1: 0.9 
% STIM_RESPONSE_BOTH_INPUTS = Global_loop_var
%  
%     for   Global_loop_var= 0 :10: 70 
%       Spike_Rates_each_burst_cut_Threshold_precent = Global_loop_var;


for  Global_loop_var = GLOB_cycle_start : GLOB_cycle_step : GLOB_cycle_end

    
%     ERASE_CHANNELS_WITH_UNIQUE_DATA = true ;
%     CHANNELS_NUMBER_to_erase = Global_loop_var ;
    LEAVE_CHANNELS_WITH_UNIQUE_DATA = true ;
    CHANNELS_NUMBER_to_analyze = Global_loop_var ;
    
        %  Start_t = 20 ;
        %  Pattern_length_ms = 200 ; 
        %  Total_burst_len =200 ;
        %  DT_step=   50 ;
        %  STIM_RESPONSE_BOTH_INPUTS = 0.5 ;
        % ANALYSE_SIMILARITY = true ;
        % OVERLAP_TRESHOLD = 15 ;
        % PvalRanksum = 0.05 ;
        % Spike_Rates_each_burst_cut_Threshold_precent; = 0 ; 

        TOTAL_ANAYSIS_DATA_all_experiments_loop_var=[];
        TOTAL_ANAYSIS_DATA_all_experiments=[];
        TOTAL_RESULT_experiments=[];
        TOTAL_countsTOTAL_RATE_Overlaps_lin_div=[];
        TOTAL_countsTact_Overlaps_lin_div=[];
        TOTAL_countsSPIKE_RATE_OVERLAPS=[];
        TOTAL_countsFirstBIN_SPIKERATE_OVERLAPS =[];
          TOTAL_countsTOTAL_RATE_Overlaps_lin_div_bin2 =[];
          TOTAL_countsTact_Overlaps_lin_div_bin2 =[];
          TOTAL_countsSPIKE_RATE_OVERLAPS_bin2=[];
          TOTAL_countsFirstBIN_SPIKERATE_OVERLAPS_bin2=[];
        xBinsOverlaps=[];
        xBinsOverlaps_bin2=[];
        TOTAL_SPIKE_RATE_OVERLAPS =[];
        TOTAL_FirstBIN_SPIKERATE_OVERLAPS=[];
        TOTAL_Tact_Overlaps_lin_div=[];
        TOTAL_TOTAL_RATE_Overlaps_lin_div=[];


            Nx=Nx+1;
        Global_loop_var_data=[Global_loop_var_data Global_loop_var];

        Global_LOOP_TOTAL_RESULT_experiments_currentLoop_experemints = [];

        for Nex = N_exeperiments_start :   N_exeperiments 

%         if DEFINED_FILE_LIST == true
            if (DEFINED_FILE_LIST == true) && ( isempty(find(Exclude_experiments_list == Nex, 1)))
        % %    files
        %  char(files{Nex}  )
        % char(files2{Nex} ) 
             filename = char(files{Nex} )  ;
              filename2 = char(files2{Nex} )  ;
               [pathname,name,ext,versn] =  fileparts( filename ) ; 
             [pathname2,name,ext,versn] = fileparts( filename2 ) ; 
            end

            filename
            filename2
            if filename ~= 0 
            Init_dir = cd ;

              Distance_in_motif_raster_2

            if N_exeperiments >= 1 & DEFINED_FILE_LIST    
              if total_number_of_active_channels > 2  
               if    RESULT(1)~= 0  
                  TOTAL_ANAYSIS_DATA_all_experiments = [ TOTAL_ANAYSIS_DATA_all_experiments TOTAL_ANAYSIS_DATA ];
                  TOTAL_ANAYSIS_DATA_all_experiments_loop_var=[TOTAL_ANAYSIS_DATA_all_experiments_loop_var Global_loop_var];
                  TOTAL_RESULT_experiments=[TOTAL_RESULT_experiments   RESULT ];

                      Global_loop_var
                      whos countsTOTAL_RATE_Overlaps_lin_div 
                      whos countsTact_Overlaps_lin_div
                      
                      
                  d=size(countsTact_Overlaps_lin_div);       
                  countsTact_Overlaps_lin_div
%                   TOTAL_countsTact_Overlaps_lin_div=[TOTAL_countsTact_Overlaps_lin_div countsTact_Overlaps_lin_div ];
                  if d(1) ==1
                      countsTact_Overlaps_lin_div=countsTact_Overlaps_lin_div';
                  end
                  TOTAL_countsTact_Overlaps_lin_div=[TOTAL_countsTact_Overlaps_lin_div countsTact_Overlaps_lin_div ];                  
                  TOTAL_countsTact_Overlaps_lin_div
                  
                  d=size(countsTact_Overlaps_lin_div_bin2);
                  if d(1) ==1
                     countsTact_Overlaps_lin_div_bin2 = countsTact_Overlaps_lin_div_bin2';
                  end
                  TOTAL_countsTact_Overlaps_lin_div_bin2 =[TOTAL_countsTact_Overlaps_lin_div_bin2  countsTact_Overlaps_lin_div_bin2 ];                  
                                   
                  
                    d=size(Tact_Overlaps_lin_div);
                      if d(1) ==1
                         Tact_Overlaps_lin_div=Tact_Overlaps_lin_div';
                      end
                    TOTAL_Tact_Overlaps_lin_div=[TOTAL_Tact_Overlaps_lin_div  Tact_Overlaps_lin_div'];     
                    
                    
                  TOTAL_countsTOTAL_RATE_Overlaps_lin_div=[TOTAL_countsTOTAL_RATE_Overlaps_lin_div  countsTOTAL_RATE_Overlaps_lin_div];                    
                  TOTAL_TOTAL_RATE_Overlaps_lin_div=[TOTAL_TOTAL_RATE_Overlaps_lin_div TOTAL_RATE_Overlaps_lin_div' ];  
                  
                  d=size(countsTOTAL_RATE_Overlaps_lin_div_bin2);
                  if d(1) ==1
                      countsTOTAL_RATE_Overlaps_lin_div_bin2=countsTOTAL_RATE_Overlaps_lin_div_bin2'; 
                  end
                  TOTAL_countsTOTAL_RATE_Overlaps_lin_div_bin2 =[ TOTAL_countsTOTAL_RATE_Overlaps_lin_div_bin2 countsTOTAL_RATE_Overlaps_lin_div_bin2];
                                      
              

%                d=size(countsSPIKE_RATE_OVERLAPS_bin2);
%               if d(1) ==1 
%                   countsSPIKE_RATE_OVERLAPS_bin2 = countsSPIKE_RATE_OVERLAPS_bin2' ;
% 
%               end
              
                  countsFirstBIN_SPIKERATE_OVERLAPS
                  
                 
                  d=size(countsSPIKE_RATE_OVERLAPS_bin2);
                  if d(1) ==1
                      countsSPIKE_RATE_OVERLAPS_bin2=countsSPIKE_RATE_OVERLAPS_bin2'; 
                  end
                  TOTAL_countsSPIKE_RATE_OVERLAPS_bin2 =[ TOTAL_countsSPIKE_RATE_OVERLAPS_bin2 countsSPIKE_RATE_OVERLAPS_bin2];   
                  
                  d=size(countsSPIKE_RATE_OVERLAPS);
                  if d(1) ==1
                      countsSPIKE_RATE_OVERLAPS=countsSPIKE_RATE_OVERLAPS'; 
                  end
                  TOTAL_countsSPIKE_RATE_OVERLAPS=[ TOTAL_countsSPIKE_RATE_OVERLAPS countsSPIKE_RATE_OVERLAPS ];
                  

                  
                  TOTAL_SPIKE_RATE_OVERLAPS =[TOTAL_SPIKE_RATE_OVERLAPS  SPIKE_RATE_OVERLAPS ];

                  
                  
                  TOTAL_FirstBIN_SPIKERATE_OVERLAPS=[TOTAL_FirstBIN_SPIKERATE_OVERLAPS  FirstBIN_SPIKERATE_OVERLAPS'];      
                  
                   d=size(countsFirstBIN_SPIKERATE_OVERLAPS);
                  if d(1) ==1
                      countsFirstBIN_SPIKERATE_OVERLAPS=countsFirstBIN_SPIKERATE_OVERLAPS'; 
                  end
                  TOTAL_countsFirstBIN_SPIKERATE_OVERLAPS = [ TOTAL_countsFirstBIN_SPIKERATE_OVERLAPS countsFirstBIN_SPIKERATE_OVERLAPS ] ;
                  
                  d=size(countsFirstBIN_SPIKERATE_OVERLAPS_bin2);
                  if d(1) ==1
                      countsFirstBIN_SPIKERATE_OVERLAPS_bin2=countsFirstBIN_SPIKERATE_OVERLAPS_bin2'; 
                  end      
                  TOTAL_countsFirstBIN_SPIKERATE_OVERLAPS_bin2 = [ TOTAL_countsFirstBIN_SPIKERATE_OVERLAPS_bin2 countsFirstBIN_SPIKERATE_OVERLAPS_bin2 ] ;

                  xBinsOverlaps_bin2=xTact_Overlaps_bin2;
                  xBinsOverlaps=xTact_Overlaps; 


                  

                    

                      


                    

              
               end
                   Global_LOOP_TOTAL_RESULT_experiments_currentLoop_experemints = [Global_LOOP_TOTAL_RESULT_experiments_currentLoop_experemints ...
                      RESULT ] ;
              end
               


            end
            
            if Cycle_close_all
                  close all
             end

            cd( Init_dir ) ;

            end
        end

            if N_exeperiments > 1 & DEFINED_FILE_LIST
                xBinsOverlaps =xBinsOverlaps' ;
            %     Global_LOOP_TOTAL_RESULT_experiments_currentLoop_experemints
                Global_LOOP_TOTAL_RESULT_experiments_all(Nx,:,:)=  Global_LOOP_TOTAL_RESULT_experiments_currentLoop_experemints';

                TOTAL_RESULT_experiments_avg = mean(TOTAL_RESULT_experiments');
                TOTAL_RESULT_experiments_avg=TOTAL_RESULT_experiments_avg';
                TOTAL_RESULT_experiments_std = SEM_calc(TOTAL_RESULT_experiments');
                TOTAL_RESULT_experiments_std=TOTAL_RESULT_experiments_std';
                 
                %---------galbal loop collecting data----------- 
                Global_LOOP_TOTAL_RESULT_experiments_avg=[Global_LOOP_TOTAL_RESULT_experiments_avg TOTAL_RESULT_experiments_avg];
                Global_LOOP_TOTAL_RESULT_experiments_std=[Global_LOOP_TOTAL_RESULT_experiments_std TOTAL_RESULT_experiments_std];
                 %------------------

            TOTAL_RESULT_experiments
            TOTAL_countsTOTAL_RATE_Overlaps_lin_div
            TOTAL_countsTact_Overlaps_lin_div
            TOTAL_countsSPIKE_RATE_OVERLAPS
            TOTAL_countsFirstBIN_SPIKERATE_OVERLAPS
            xBinsOverlaps

            
             TOTAL_SPIKE_RATE_OVERLAPS=TOTAL_SPIKE_RATE_OVERLAPS';
               TOTAL_FirstBIN_SPIKERATE_OVERLAPS=TOTAL_FirstBIN_SPIKERATE_OVERLAPS';
               TOTAL_Tact_Overlaps_lin_div=TOTAL_Tact_Overlaps_lin_div';
               TOTAL_TOTAL_RATE_Overlaps_lin_div=TOTAL_TOTAL_RATE_Overlaps_lin_div';
            

            fname = [  int2str(Nx) '_TOTALexp_analysis2sets_PSRR_' int2str(  100*STIM_RESPONSE_BOTH_INPUTS) '_DT_' int2str(DT_step) '_ThrSpikes_' ...
                int2str( Spike_Rates_each_burst_cut_Threshold_precent) '.mat' ];

            eval(['save K:\MEA_DATA\2011_INCUBATOR\' fname ...
                ' TOTAL_RESULT_experiments_avg Global_LOOP_TOTAL_RESULT_experiments_std '...
                'TOTAL_RESULT_experiments TOTAL_countsTOTAL_RATE_Overlaps_lin_div '...
                ' TOTAL_countsTact_Overlaps_lin_div TOTAL_countsFirstBIN_SPIKERATE_OVERLAPS   '...
                'TOTAL_countsFirstBIN_SPIKERATE_OVERLAPS_bin2 TOTAL_countsSPIKE_RATE_OVERLAPS '...
                'TOTAL_countsTOTAL_RATE_Overlaps_lin_div_bin2 TOTAL_countsTact_Overlaps_lin_div_bin2 '...
                 'TOTAL_SPIKE_RATE_OVERLAPS  TOTAL_FirstBIN_SPIKERATE_OVERLAPS '...
                    'TOTAL_Tact_Overlaps_lin_div TOTAL_TOTAL_RATE_Overlaps_lin_div '...               
                ' TOTAL_countsSPIKE_RATE_OVERLAPS_bin2 xBinsOverlaps_bin2 xBinsOverlaps  TOTAL_ANAYSIS_DATA_all_experiments -mat']);  
            end 

    if length( Global_loop_var_data ) >1
        close all
    end


end



if N_exeperiments -N_exeperiments_start>= 1 & DEFINED_FILE_LIST
%----GLOBAL LOOP--ends---------------------------
Global_LOOP_TOTAL_RESULT_experiments_avg
Global_loop_var_data

% plot( Global_loop_var_data ,
% Global_LOOP_TOTAL_RESULT_experiments_avg(1,:))

% Global_LOOP_TOTAL_RESULT_experiments_avg(1,:)

% Global_LOOP_TOTAL_RESULT_experiments_all(1,:,1)
XX=[];YY=[];
for nnx=1: Nx
  YY=[YY Global_LOOP_TOTAL_RESULT_experiments_all(nnx,:,1)];
  a=zeros(1,N_exeperiments);a(:)= Global_loop_var_data(nnx);
  XX=[XX a];
end
    
figure
      errorbar( Global_loop_var_data , Global_LOOP_TOTAL_RESULT_experiments_avg(1,:) ,Global_LOOP_TOTAL_RESULT_experiments_std(1,:) )
title( 'total number of active channels' )

figure
      plot( XX , YY ,'*') 
title( 'total number of active channels' )

figure
% plot( Global_loop_var_data , Global_LOOP_TOTAL_RESULT_experiments_avg(4,:))
      errorbar( Global_loop_var_data , Global_LOOP_TOTAL_RESULT_experiments_avg(4,:) ,Global_LOOP_TOTAL_RESULT_experiments_std(4,:) )
title( 'Tac Stat selective electrodes num' )

figure
% plot( Global_loop_var_data , Global_LOOP_TOTAL_RESULT_experiments_avg(4,:))
      errorbar( Global_loop_var_data , Global_LOOP_TOTAL_RESULT_experiments_avg(11,:) ,Global_LOOP_TOTAL_RESULT_experiments_std(11,:) )
title( 'RATE Stat selective electrodes num' )


XX=[];YY=[];YY_mean=[];YY_std=[];
for nnx=1: Nx
%   YY=[YY Global_LOOP_TOTAL_RESULT_experiments_all(nnx,:,8)];
%   a=zeros(1,N_exeperiments);a(:)= Global_loop_var_data(nnx);
%   XX=[XX a];
       Y= Global_LOOP_TOTAL_RESULT_experiments_all(nnx,:,8);
      a=zeros(1,N_exeperiments);
      a(:)= Global_loop_var_data(nnx);      
      c=find(Y==0);
      Y(c)=[];
      a(c)=[]; 
      XX=[XX a];
      YY=[YY Y ];
      YY_mean = [YY_mean mean(Y)];
      YY_std=[YY_std std(Y)] ;
      
end

figure
% plot( Global_loop_var_data , Global_LOOP_TOTAL_RESULT_experiments_avg(7,:))
      errorbar( Global_loop_var_data , YY_mean , YY_std )
%       errorbar( Global_loop_var_data , Global_LOOP_TOTAL_RESULT_experiments_avg(8,:) ,Global_LOOP_TOTAL_RESULT_experiments_std(8,:) )
title( 'Tact Centroid accuracy precent' )

figure
      plot( XX , YY ,'*') 
title('Tact Centroid Error precent' )
XX=XX;YY_mean=YY_mean;YY_std=YY_std;
X_tact = XX' ; Y_tact_accuracy = YY_mean' ; Y_tact_accuracy_std = YY_std' ;
X_tact 
Y_tact_accuracy 
Y_tact_accuracy_std 

% figure
% % plot( Global_loop_var_data , Global_LOOP_TOTAL_RESULT_experiments_avg(7,:))
%       errorbar( Global_loop_var_data , Global_LOOP_TOTAL_RESULT_experiments_avg(8,:) ,Global_LOOP_TOTAL_RESULT_experiments_std(8,:) )
% title( 'Tact_Clustering_error_precent_KMEANS' )


 
XX=[];YY=[];YY_mean=[];YY_std=[];
for nnx=1: Nx  
       Y= Global_LOOP_TOTAL_RESULT_experiments_all(nnx,:,15);
      a=zeros(1,N_exeperiments);
      a(:)= Global_loop_var_data(nnx);      
      c=find(Y==0);
      Y(c)=[];
      a(c)=[]; 
      XX=[XX a];
      YY=[YY Y ];
      YY_mean = [YY_mean mean(Y)];
      YY_std=[YY_std std(Y)] ;
end

figure
% plot( Global_loop_var_data , Global_LOOP_TOTAL_RESULT_experiments_avg(13,:))
      errorbar( Global_loop_var_data  , YY_mean , YY_std )
title( 'TOTAL RATE Centroid accuracy precent' )

figure
      plot( XX , YY ,'*') 
title('TOTAL RATE Centroid accuracy precent' )
X_tsr = XX' ; Y_tsr_accuracy = YY_mean' ; Y_tsr_accuracy_std = YY_std' ;
X_tsr 
Y_tsr_accuracy 
Y_tsr_accuracy_std 
 
 
figure
% plot( Global_loop_var_data , Global_LOOP_TOTAL_RESULT_experiments_avg(13,:))
      errorbar( Global_loop_var_data , Global_LOOP_TOTAL_RESULT_experiments_avg(27,:) ,Global_LOOP_TOTAL_RESULT_experiments_std(27,:) )
title( 'PSTH difference, %' )


% figure
% % plot( Global_loop_var_data , Global_LOOP_TOTAL_RESULT_experiments_avg(13,:))
%       errorbar( Global_loop_var_data , Global_LOOP_TOTAL_RESULT_experiments_avg(14,:) ,Global_LOOP_TOTAL_RESULT_experiments_std(14,:) )
% title( 'TOTAL_RATE_Clustering_error_precent_KMEANS' )

% figure
% % plot( Global_loop_var_data , Global_LOOP_TOTAL_RESULT_experiments_avg(13,:))
%       errorbar( Global_loop_var_data , Global_LOOP_TOTAL_RESULT_experiments_avg(17,:) ,Global_LOOP_TOTAL_RESULT_experiments_std(17,:) )
% title( 'SpikeRate_STAT_Selectivity_Nbins_precent' )
% 


eval(['save K:\MEA_DATA\2011_INCUBATOR\Global_LOOP_TOTAL_RESULT_experiments_avg.mat ' ...
    ' Global_LOOP_TOTAL_RESULT_experiments_avg Global_LOOP_TOTAL_RESULT_experiments_std Global_loop_var_data -mat']);  

end



toc




