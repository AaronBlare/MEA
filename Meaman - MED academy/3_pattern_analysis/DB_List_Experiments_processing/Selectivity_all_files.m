
% Selectivity_all_files

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
Spike_Rates_each_burst_cut_Threshold_precent = 20 ; % Threshold for small bursts, % from Maximum burst
%----------------------
Cycle_close_all = false ; % if true - close all plots in each entry of cycle mane experiments
ANALYSE_ONE_EXPERIMENT =  1  ; % [1,7, 15 - is good]if > 0 will analyse only exepiment from list with number ANALYSE_ONE_EXPERIMENT
Exclude_experiments_list = []; %[10 13 14 22 23 25];
GLOB_cycle_start =2 ; %2
GLOB_cycle_step =1;   % 1
GLOB_cycle_end =2;   % 64


PHASE_ON = true ;
ADJUST_SPIKES = true ;

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

            eval(['save D:\MEA_DATA\2011_INCUBATOR\' fname ...
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


eval(['save D:\MEA_DATA\2011_INCUBATOR\Global_LOOP_TOTAL_RESULT_experiments_avg.mat ' ...
    ' Global_LOOP_TOTAL_RESULT_experiments_avg Global_LOOP_TOTAL_RESULT_experiments_std Global_loop_var_data -mat']);  

end



toc




