% Distance_in_motif_raster_2

% function Result = Poststim_response_compare_2_patterns( m1 , m2 , var )
 
random_channel = 'n' ; 

% STIM_RESPONSE_BOTH_INPUTS =  0.6 ;
N = 60 ;


BUILD_SURROGATES_T_ACTIVATION = false ;
REBUILD_ACTIVATION_PATTERNS = false ;
      DT_Tact_shift = 80 ;

ERASE_CHANNELS_NUMBER = false ;
ERASE_CHANNELS_WITH_UNIQUE_DATA = false ; % erases number (CHANNELS_NUMBER_to_erase) of channels with lowest or      1
                                         % highest overlap
%     CHANNELS_NUMBER_to_erase = 20 ; 

LEAVE_CHANNELS_WITH_UNIQUE_DATA = false ;
LEAVE_LOWEST_OVERLAP = false ;
%     CHANNELS_NUMBER_to_analyze = 10 ;
      
      
CHECK_SPIKES_NUM_IN_BOTH_RASTERS = 'n' ;
MOTIF_AS_RATE = 'n' ; % Patterns as spike rate on each electrode
CYCLE_NUM_SIGNIFICANT_ELECTRODES = 'n' ;

MAIN_PSTH_DIFFERENCE_TIME_BIN = 20 ; % bin for PSTH difference - 10 ms default

SHOW_FIGURES = 'y' ;
one_burst_part_at_all = 'n' ;
Show_pattern_dur_hist = 'n';

one_burst_from = 2000 ;
one_burst_to = 2300 ;
TOTAL_ANAYSIS_DATA = [] ;
RESULT = 0;

% pathname = ffpath(filename);

% cd( pathname ) ; 
% % index_r = load( char( filename ) ) ;
% m1 = load( char( filename ) ) ;
% % motif = m1.burst_activation ;
% [pathstr,name,ext,versn] = fileparts ( filename ) ;
% File_name_x =name;
% Tmax = max( index_r( : , 1 ) ) ;

% if 1 ~= 0 
%     
% % pathname2 = ffpath(filename2);
% cd( pathname2 ) ; 
% % index_r2 = load( char( filename2 ) ) ;
% m2 = load( char( filename2 ) ) ;
% % N = 64 ;
% % Tmax2 = max( index_r2( : , 1 ) ) ;
% else
%     m2 = m1 ;
% end

% Nstart = 15 ;
% burst_start( 1 : Nstart ) = [];
% burst_max( 1 : Nstart   )  = [];
% burst_end( 1 : Nstart  )  = [];
% 
% burst_start( 1: end - Nstart  ) = [];
% burst_max( 1: end - Nstart )  = [];
% burst_end( 1: end - Nstart )  = [];
% Nb = length( burst_start ) ;

% burst_start = burst_start + 100 ;

% ER = 15 ;
% m1.burst_activation(  ER : end , :) = [] ;
% m2.burst_activation(  ER+3 : end, :) = [] ;
% m1.bursts(  ER : end , : , :) = [] ;
% m2.bursts(  ER+3 : end , : , :) = [] ;
% m1.burst_start( ER : end  ) = [];
% m2.burst_start( ER+3 : end  ) = [];

% Nb = length( m1.burst_start )          % Number of bursts
% Nb2 = length( m2.burst_start )          % Number of bursts

Nb = m1.Number_of_Patterns 
Nb2 = m2.Number_of_Patterns 

xx = [] ;
I = 0 ;

if MOTIF_AS_RATE == 'y' 
  Start_t = 20 ;
  DT = 40 ;
  for k = 1 : N             
    for t = 1 : Nb                         
       si = find( m1.bursts( t , k ,: )>= Start_t & m1.bursts( t , k ,: )<  DT + Start_t ) ;
           ssss =  length( si ) ; if ~isfinite(  ssss )  ssss= 0 ;end
       m1.burst_activation( t , k ) =     ssss +1;
           ssss ;
    end
    
    ch2 = 0 ;
    for t = 1 : Nb2                      
        si = find( m2.bursts( t , k ,: )>= Start_t & m2.bursts( t , k ,: )<  DT + Start_t ) ;
           ssss =  length( si ) ; if ~isfinite(  ssss )  ssss= 0 ;end
       m2.burst_activation( t , k ) =     ssss +1;    
       ssss; 
    end 
  end  
end 





CYCLE_NUM_SIGNIFICANT_ELECTRODES = 'n' ;

if CYCLE_NUM_SIGNIFICANT_ELECTRODES == 'y' 
    
 m1burstactivation_reserv = m1.burst_activation ;
m2burstactivation_reserv = m2.burst_activation ;
  Sense_CH = [] ;
  Sense_CH_all = [] ;    
    
   m1.burst_activation =m1burstactivation_reserv ;
  m2.burst_activation =m2burstactivation_reserv ;
  ITERA = 200 ;
  Sensitive_electrodes = zeros(N,1);
   DATA = [] ;
  ZERO_CHANNELS_NUM = 60 ;
min_R4 = 1 ;
Found_elec = 0 ;
   
%   for ZERO_CHANNELS_NUM = 58 : N-4
      ZERO_CHANNELS_NUM
      mean_Jacc = [] ;
      for it = 1  : ITERA
  
            m1.burst_activation =m1burstactivation_reserv ;
          m2.burst_activation =m2burstactivation_reserv ;
        Y = EraseRandomChannles( ZERO_CHANNELS_NUM , N ) ;
     
              m1.burst_activation( : , Y ) = 0 ;          
                 
              m2.burst_activation( : , Y ) = 0 ;             
         
         Num_channels_active = N - ZERO_CHANNELS_NUM ;      
         [P_val1 ,P_val2 , P_val_cross,P_val_surr_cross, mR_difference,R1,R2,R3,R4,R5 ,R6] = Two_sets_compare_similarity( ...
           m1.burst_activation , m2.burst_activation , 0 , 0 , 0 ,0 , 'n' , PHASE_ON , ADJUST_SPIKES );  
       % R6 = Active_Patterns_to_centroid1 %!!!!    
       min_R4
           Found_elec
           mean_Jacc = [ mean_Jacc R4 ] ;
           if min_R4 > R4 min_R4 = R4; Sense_CH = Y ; end
           if R4 <= 0.05 && R5 == 1      
               f= 1 :64 ;
               Sense_CH = Y ;
               Found_elec = Found_elec + 1 ;
%                Sense_CH_all = [ Sense_CH_all ; Sense_CH ];
               f(Y) = [] ;
               f
               Sensitive_electrodes( Y ) = Sensitive_electrodes( Y )- 1 ;
           end
%        end
%     DATA= [ DATA ; Num_channels_active mean( mean_Jacc ) ];
  end
%      std(x)/sqrt(n)
mmm = min(Sensitive_electrodes) ;
Sensitive_electrodes = Sensitive_electrodes + abs(mmm);
save  'Jacc_on_Active_electrodes.mat'
figure
bar( Sensitive_electrodes );
title('Sensetive electrodes')

Sense_CH'
 m1.burst_activation =m1burstactivation_reserv ;
 m2.burst_activation =m2burstactivation_reserv ;
 f= 1 :64 ;
 f(  Sense_CH ) = [] ;
 Sense_CH = f ;
% Sense_CH  = [  1     3    17    32    53    64   ];
 f= 1 :64 ;
 f(  Sense_CH ) = [] ;
 m1.burst_activation( : , f ) = 0 ;    
 m2.burst_activation( : , f ) = 0 ;
end
  

%  m1.burst_activation =m1burstactivation_reserv ;
%  m2.burst_activation =m2burstactivation_reserv ;
%  Sense_CH  = [   4    17    37    49    54    64 ];
%  f= 1 :64 ;
%  f(  Sense_CH ) = [] ;
%  m1.burst_activation( : , f ) = 0 ;    
%  m2.burst_activation( : , f ) = 0 ;
 
% DDT= 20 ;
%      m2.burst_activation( : , :) =   m2.burst_activation( : , :) +DDT ;
%      m2.bursts( : , :, : ) =   m2.bursts( : , : , :) +DDT ;
%  
%      m2.burst_activation( m2.burst_activation == DDT ) =  0 ;
%      m2.bursts(  m2.bursts == DDT  ) =  0 ;
%         
%  Nb2=Nb;


%      m2.burst_activation( : , :) =   m1.burst_activation( : , :)    ;
%      m2.bursts( : , :, : ) =   m1.bursts( : , : , :)    ;
%       Nb2=Nb;


% ----- ERASE SPECIFIC CHANNELS ------------------------------------------
% CHANNELStoErase = [1 :26 30:64 ];
%  [Data1_new , Data2_new] = Erase_Specified_Channels( m1.bursts , m2.bursts ,  CHANNELStoErase );
% m1.bursts = Data1_new; m2.bursts = Data2_new ;
%  [Data1_new , Data2_new] = Erase_Specified_Channels( m1.burst_activation , m2.burst_activation ,  CHANNELStoErase );
% m1.burst_activation = Data1_new; m2.burst_activation = Data2_new ;
% --------------------------------------------


% ----- ERASE NUMBER OF CHANNELS ------------------------------------------
if ERASE_CHANNELS_NUMBER
% CHANNELS_NUMBER_to_erase = 40 ;
CHANNELStoErase = 1 : CHANNELS_NUMBER_to_erase ;
          m1.bursts( : , CHANNELStoErase , : ) = 0 ;        
          m2.bursts( : , CHANNELStoErase , :) = 0 ;
          m1.burst_activation( : , CHANNELStoErase  ) = 0 ;        
          m2.burst_activation( : , CHANNELStoErase  ) = 0 ;  
end
% --------------------------------------------



% ----- CUT small responses------------------------------------------
m1.Spike_Rates_each_burst = Spikes_in_bursts( m1.bursts , Nb ,Start_t ,  Total_burst_len , N );
m2.Spike_Rates_each_burst = Spikes_in_bursts( m2.bursts , Nb2 ,Start_t ,  Total_burst_len , N );

EMPTY_SPIKE_TIME=[];  
    response_str_THR = ( Spike_Rates_each_burst_cut_Threshold_precent /100) * max( m1.Spike_Rates_each_burst);
     weak_responses_index = find( m1.Spike_Rates_each_burst(:) <= response_str_THR   );
     good_response_index = 1:Nb ;
     good_response_index( weak_responses_index ) = [] ; 
 
Nb=Nb- length(weak_responses_index);

      m1.burst_activation( weak_responses_index , :  ) = [] ;
      m1.bursts( weak_responses_index ,: ) = [] ;
%         m2.bursts = m2.bursts{ good_response_index }  ;
        
 %       m2.Spike_Rates_each_burst
    response_str_THR = (Spike_Rates_each_burst_cut_Threshold_precent /100) * max( m2.Spike_Rates_each_burst );
     weak_responses_index = find( m2.Spike_Rates_each_burst(:) <= response_str_THR );
     good_response_index = 1:Nb2 ;
     Nb2 = Nb2 - length(weak_responses_index);
     good_response_index( weak_responses_index ) = [] ; 
      m2.burst_activation( weak_responses_index , :  ) = [] ;
%      m2.bursts = m2.bursts{ good_response_index }  ;
     m2.bursts( weak_responses_index ,: ) = [] ;
%-----------------------------------------------------------------     
     
% ----- PSTH analysis------------------------------------------
[psth_dx1 , psth1 , psth_norm1] = PSTH_calc( m1.bursts , Nb , MAIN_PSTH_DIFFERENCE_TIME_BIN ,Total_burst_len , N );
[psth_dx2 , psth2 , psth_norm2] = PSTH_calc( m2.bursts , Nb2 , MAIN_PSTH_DIFFERENCE_TIME_BIN ,Total_burst_len, N );
 
 psth_diff=sum( abs(psth2-psth1) ) ;
 psth_diff_precent = 100*psth_diff / sum( psth1 ) ; 
 TOTAL_ANAYSIS_DATA.psth_diff_precent = psth_diff_precent;
 psth_diff_precent
 
 
%  ---draw PSTH of 2 patterns
 BIN= 10 ;
        [psth_dx , psth , psth_norm] = PSTH_calc( m1.bursts , Nb , BIN  , Total_burst_len , N ) ;      
           figure
subplot(2,1,1);
    bar( psth_dx , psth  )    
           [psth_dx , psth , psth_norm] = PSTH_calc( m2.bursts , Nb2 , BIN  , Total_burst_len , N ) ;
subplot(2,1,2);
    bar( psth_dx , psth  )    
     title( ['Spikes after stimulus, ' int2str( Pattern_length_ms) 'ms, Bin=' int2str( BIN )] )
 
%   -----------------------------------------------------------------      

% [Data1_new , Data2_new , total_number_of_active_channels , CHABBELS_ERASED]  = ...
%         Erase_Rare_Channels(N ,Nb ,Nb2, m1.bursts , m2.bursts ,  Start_t , Total_burst_len , 0  );  
% m1.bursts = Data1_new; m2.bursts = Data2_new ;
% [Data1_new , Data2_new , total_number_of_active_channels , CHABBELS_ERASED]  = ...
%         Erase_Rare_Channels(N ,Nb ,Nb2, m1.burst_activation , m2.burst_activation ,  Start_t , Total_burst_len , 0 ,0  );  
% m1.burst_activation = Data1_new; m2.burst_activation = Data2_new ;

 % erase low t activation channels on both patterns
[Data1_new , Data2_new , total_number_of_active_channels , CHABBELS_ERASED]  = ...
        Erase_Rare_Channels(N ,Nb ,Nb2, m1.burst_activation , m2.burst_activation ,  Start_t , Total_burst_len , STIM_RESPONSE_BOTH_INPUTS,0  );
m1.burst_activation = Data1_new; m2.burst_activation = Data2_new ;

% erase low rate channels on both patterns
[Data1_new , Data2_new , total_number_of_active_channels ,  CHABBELS_ERASED]  = ...
        Erase_Rare_Channels(N ,Nb ,Nb2, m1.bursts , m2.bursts ,  Start_t , Total_burst_len , STIM_RESPONSE_BOTH_INPUTS,0  );
m1.bursts = Data1_new; m2.bursts = Data2_new ;

Active_channels = ones( 1,64);
Active_channels( CHABBELS_ERASED ) = 0 ;

total_number_of_active_channels
total_number_of_active_channels_precent=100* total_number_of_active_channels / N ;
total_number_of_active_channels_precent
TOTAL_ANAYSIS_DATA.total_number_of_active_channels=total_number_of_active_channels;
TOTAL_ANAYSIS_DATA.total_number_of_active_channels_precent=total_number_of_active_channels_precent;


% -----------   SURROGATES of the T activation
if BUILD_SURROGATES_T_ACTIVATION == true
 X = RandomArrayN( Nb + Nb2 ); 
 PATTERNS = [ m1.burst_activation ; m2.burst_activation ];
X = RandomArrayN( Nb + Nb2 );
 for i = 1 : Nb 
 m1.burst_activation( i , : ) = PATTERNS(  X(i)   , : );
 end  
 for i = 1 : Nb2  
  m2.burst_activation( i , : ) = PATTERNS(  X(i + Nb )   , : );
 end
end
% ------------------------------------------- 



%------------------------- T act - make new from bursts with delay
if REBUILD_ACTIVATION_PATTERNS == true  
  Start_t = 20 ;
  for k = 1 : N             
    for t = 1 : Nb                         
       si = find( m1.bursts( t , k ,: )>= Start_t + DT_Tact_shift & m1.bursts( t , k ,: )<  DT_Tact_shift + Start_t + DT_Tact_shift * 3  ) ;
         if ~isempty( si)
            m1.burst_activation( t , k ) =    m1.bursts( t , k , si(1) )   ;
         else
             m1.burst_activation( t , k ) =   0  ;
         end
    end
    
    ch2 = 0 ;
    for t = 1 : Nb2                      
        si = find( m2.bursts( t , k ,: )>=  Start_t + DT_Tact_shift & m2.bursts( t , k ,: )<  DT_Tact_shift + Start_t + DT_Tact_shift * 3  ) ;
              if ~isempty( si)
            m2.burst_activation( t , k ) =    m2.bursts( t , k , si(1) )   ;
         else
             m2.burst_activation( t , k ) =   0  ;
         end
    end 
  end  
end 
%------------------------------------------------------------------






 
% How much electrodes sesitive to Spike rate
[ TOTAL_RATE_total_number_of_active_electrodes , TOTAL_RATE_Stat_selective_electrodes_num ,...
    TOTAL_RATE_Stat_Selective_electrodes_precent , TOTAL_RATE_Selective_electrodes_lin_div_num ...
    ,TOTAL_RATE_Selective_electrodes_lin_div_precent , Overlaps_lin_div , Channels_overlap , Channels_is_selective , Channel_is_active ] ...
    = Selective_Electrodes_Rate(N ,Nb ,Nb2, m1.bursts , m2.bursts ,Start_t , Pattern_length_ms, OVERLAP_TRESHOLD);
TOTAL_RATE_total_number_of_active_electrodes
TOTAL_RATE_Stat_selective_electrodes_num
TOTAL_RATE_Stat_Selective_electrodes_precent
TOTAL_RATE_Selective_electrodes_lin_div_precent 
Total_Rate_Overlaps = Overlaps_lin_div';
Total_Rate_Overlaps ;
TOTAL_ANAYSIS_DATA.TOTAL_RATE_total_number_of_active_electrodes=TOTAL_RATE_total_number_of_active_electrodes;
TOTAL_ANAYSIS_DATA.TOTAL_RATE_Stat_selective_electrodes_num=TOTAL_RATE_Stat_selective_electrodes_num;
TOTAL_ANAYSIS_DATA.TOTAL_RATE_Stat_Selective_electrodes_precent=TOTAL_RATE_Stat_Selective_electrodes_precent;
TOTAL_ANAYSIS_DATA.TOTAL_RATE_Selective_electrodes_lin_div_precent=TOTAL_RATE_Selective_electrodes_lin_div_precent;
TOTAL_ANAYSIS_DATA.TOTAL_RATE_Selective_electrodes_lin_div_num=TOTAL_RATE_Selective_electrodes_lin_div_num;
TOTAL_ANAYSIS_DATA.TOTAL_RATE_Overlaps_lin_div = Overlaps_lin_div; 


%---------------------------- ERASE number of channels with lowest or
%---------------------------- highest  overlap of Total spike rate
if ERASE_CHANNELS_WITH_UNIQUE_DATA
%    sort(Channels_overlap, 'descend')
    [B, index_chan_ascend ]=sort(Channels_overlap) ; %index_chan_ascend(1) -index of channel with lowest overlap
    CHANNELStoErase = index_chan_ascend( 1 : CHANNELS_NUMBER_to_erase  );
    CHANNELStoErase
     [Data1_new , Data2_new] = Erase_Specified_Channels( m1.bursts , m2.bursts ,  CHANNELStoErase );
    m1.bursts = Data1_new; m2.bursts = Data2_new ;
     [Data1_new , Data2_new] = Erase_Specified_Channels( m1.burst_activation , m2.burst_activation ,  CHANNELStoErase );
    m1.burst_activation = Data1_new; m2.burst_activation = Data2_new ;
end
%--------------------------------------------------------------------------

%---------------------------- LEAVE or Erase number of channels with lowest or
%---------------------------- highest overlap of Total spike rate and erase
%---- the rest
if LEAVE_CHANNELS_WITH_UNIQUE_DATA 
%    sort(Channels_overlap, 'descend')
if TOTAL_RATE_total_number_of_active_electrodes >= CHANNELS_NUMBER_to_analyze
    [B, index_chan_ascend ]=sort(Channels_overlap) ; %index_chan_ascend(1) -index of channel with lowest overlap
    index_chan_ascend=index_chan_ascend';
    CHANNELStoErase = index_chan_ascend( TOTAL_RATE_total_number_of_active_electrodes +1:N);
    CHANNELStoErase
    if TOTAL_RATE_total_number_of_active_electrodes > CHANNELS_NUMBER_to_analyze
        if LEAVE_LOWEST_OVERLAP 
        CHANNELStoErase=[CHANNELStoErase index_chan_ascend((CHANNELS_NUMBER_to_analyze+1):N)];
        else
        CHANNELStoErase=[CHANNELStoErase  index_chan_ascend(1:(TOTAL_RATE_total_number_of_active_electrodes -CHANNELS_NUMBER_to_analyze)) ];            
        end
    end 
else
    CHANNELStoErase = 1:N;
end
CHANNELStoErase
     [Data1_new , Data2_new] = Erase_Specified_Channels( m1.bursts , m2.bursts ,  CHANNELStoErase );
    m1.bursts = Data1_new; m2.bursts = Data2_new ;
     [Data1_new , Data2_new] = Erase_Specified_Channels( m1.burst_activation , m2.burst_activation ,  CHANNELStoErase );
    m1.burst_activation = Data1_new; m2.burst_activation = Data2_new ;
end
%--------------------------------------------------------------------------




 % How much electrodes sesitive to T activation 
[ Tact_total_number_of_active_electrodes  , Tact_Stat_selective_electrodes_num ,...
    Tact_Stat_Selective_electrodes_precent , Tact_Selective_electrodes_lin_div_num,Tact_Selective_electrodes_lin_div_precent , Overlaps_lin_div ]...
    = Selective_Electrodes_Tactivation(N ,Nb ,Nb2, m1.burst_activation ,  m2.burst_activation , 0,OVERLAP_TRESHOLD);
Tact_total_number_of_active_electrodes
Tact_Stat_selective_electrodes_num
Tact_Stat_Selective_electrodes_precent
Tact_Selective_electrodes_lin_div_precent
TOTAL_ANAYSIS_DATA.Tact_total_number_of_active_electrodes =Tact_total_number_of_active_electrodes ; 
TOTAL_ANAYSIS_DATA.Tact_Stat_selective_electrodes_num  =Tact_Stat_selective_electrodes_num;
TOTAL_ANAYSIS_DATA.Tact_Stat_Selective_electrodes_precent=Tact_Stat_Selective_electrodes_precent;
TOTAL_ANAYSIS_DATA.Tact_Selective_electrodes_lin_div_num=Tact_Selective_electrodes_lin_div_num;
TOTAL_ANAYSIS_DATA.Tact_Selective_electrodes_lin_div_precent=Tact_Selective_electrodes_lin_div_precent;
TOTAL_ANAYSIS_DATA.Tact_Overlaps_lin_div = Overlaps_lin_div ;


 
[ Tact_SVM_accuracy , Tact_Clustering_error_precent_SVM , Tact_Not_distinguishable_points_num_SVM ] = SVM_check_accuracy_1D_data( ... 
      m1.burst_activation , m2.burst_activation,  Nb , Nb2 , N );

Tact_SVM_accuracy
% TOTAL_ANAYSIS_DATA.SVM_accuracy_activation_P1vsP2 = SVM_accuracy_activation_P1vsP2 ;

    [ SpikeRate_STAT_Selectivity_Nbins_total ,SpikeRate_STAT_Selectivity_Nbins_precent , ...
         SpikeRate_LINEARY_Selectivity_Nbins_precent , SpikeRate_LINEARY_Selectivity_Nbins_total ...
    TOTAL_RATE_Intersimilarity_Dissimilar_patterns_precent , TOTAL_RATE_Intersimilarity_Dissimilar_patterns , TOTAL_RATE_Centroid_Error_points , ...
    TOTAL_RATE_Centroid_Error_precent ,TOTAL_RATE_Clustering_error_precent_KMEANS ,TOTAL_RATE_Clustering_error_precent_SVM  , TOTAL_RATE_SVM_accuracy , ...
    Total_bins , SPIKE_RATE_OVERLAPS, SPIKE_RATE_OVERLAPS_STABLE , ...
      SPIKE_RATE_1stBin_Centroid_Error_precent,Bins_overlaps_mean ,   ...
    SPIKE_RATES_1stBin_Clustering_error_precent_KMEANS , SPIKE_RATES_1stBin_KMEANS_accuracy , FirstBIN_SPIKERATE_OVERLAPS , ...
    SPIKE_RATE_1stBin_SVM_accuracy ] =...
        compare_activities( m1.bursts , m2.bursts , Nb , Nb2 , Pattern_length_ms , Start_t , DT_step , STIM_RESPONSE_BOTH_INPUTS ,OVERLAP_TRESHOLD , ...
                  PvalRanksum , CHABBELS_ERASED ,File_name_x) ;

TOTAL_ANAYSIS_DATA.Total_bins = Total_bins ;

TOTAL_ANAYSIS_DATA.TOTAL_RATE_Intersimilarity_Dissimilar_patterns_precent =TOTAL_RATE_Intersimilarity_Dissimilar_patterns_precent;
TOTAL_ANAYSIS_DATA.TOTAL_RATE_Intersimilarity_Dissimilar_patterns =  TOTAL_RATE_Intersimilarity_Dissimilar_patterns;
TOTAL_ANAYSIS_DATA.TOTAL_RATE_Centroid_Error_points =  TOTAL_RATE_Centroid_Error_points ;
TOTAL_ANAYSIS_DATA.TOTAL_RATE_Centroid_Accuracy_precent = 100 - TOTAL_RATE_Centroid_Error_precent  ;
TOTAL_ANAYSIS_DATA.TOTAL_RATE_Clustering_error_precent_SVM= TOTAL_RATE_Clustering_error_precent_SVM;
TOTAL_ANAYSIS_DATA.TOTAL_RATE_Clustering_Accuracy_precent_KMEANS = 100 - TOTAL_RATE_Clustering_error_precent_KMEANS  ;
TOTAL_ANAYSIS_DATA.TOTAL_RATE_SVM_accuracy=100* TOTAL_RATE_SVM_accuracy; 

TOTAL_ANAYSIS_DATA.SpikeRate_STAT_Selectivity_Nbins_total = SpikeRate_STAT_Selectivity_Nbins_total;
TOTAL_ANAYSIS_DATA.SpikeRate_STAT_Selectivity_Nbins_precent = SpikeRate_STAT_Selectivity_Nbins_precent;
TOTAL_ANAYSIS_DATA.SpikeRate_LINEARY_Selectivity_Nbins_precent = SpikeRate_LINEARY_Selectivity_Nbins_precent;
TOTAL_ANAYSIS_DATA.SpikeRate_LINEARY_Selectivity_Nbins_total = SpikeRate_LINEARY_Selectivity_Nbins_total  ;

TOTAL_ANAYSIS_DATA.SPIKE_RATE_OVERLAPS = SPIKE_RATE_OVERLAPS ;

TOTAL_ANAYSIS_DATA.Tact_SVM_accuracy = 100 * Tact_SVM_accuracy ;
TOTAL_ANAYSIS_DATA.Tact_Clustering_error_precent_SVM = Tact_Clustering_error_precent_SVM ;

TOTAL_ANAYSIS_DATA.FirstBIN_SPIKERATE_OVERLAPS = FirstBIN_SPIKERATE_OVERLAPS ;
TOTAL_ANAYSIS_DATA.SPIKE_RATES_1stBin_Clustering_accuracy_precent_KMEANS = SPIKE_RATES_1stBin_Clustering_error_precent_KMEANS ;
TOTAL_ANAYSIS_DATA.SPIKE_RATES_1stBin_KMEANS_accuracy = 100 * SPIKE_RATES_1stBin_KMEANS_accuracy ;
TOTAL_ANAYSIS_DATA.SPIKE_RATE_1stBin_Centroid_accuracy_precent = 100 - SPIKE_RATE_1stBin_Centroid_Error_precent ; % first bin
TOTAL_ANAYSIS_DATA.SPIKE_RATE_1stBin_SVM_accuracy = 100 * SPIKE_RATE_1stBin_SVM_accuracy ; % first bin
% SPIKE_RATE_OVERLAPS

x=0;
x_last = 0 ;
       
  for x = 0: 10 : x_last
 
    xx = [ xx x ];
    I = I + 1 ;
    I;
    
%     
%    
% motif = zeros( Nb , N ) ;
% motif2 = zeros( Nb2 , N ) ;
% for t = 1 : Nb
% %     x = 0 ; % rand() * mmnn ;  
% rand_CH = RandomArrayN( N );                   
%     
%   for ch = 1 : N   
%         
%         if random_channel == 'y'
% %             channel = floor( rand()*(N-1) +1);
%             channel = rand_CH( ch );
%         else    
%             channel = ch ; % 
%         end
%                
%         if one_burst_part_at_all == 'y'
%             if round(x) > one_burst_from && round(x) <= one_burst_to        
%                    ss = find( index_r( : , 1 ) >= burst_start( 1 ) + round(x) & ...            
%                    index_r( : , 1 ) < burst_end( 1 ) & index_r( : , 2 ) == channel , 1 ) ;       
%                if isempty( ss ) ~= 1
%                   motif( t , ch ) = index_r( ss , 1 )  - burst_start( 1 );  
% %                   burst( t , ch ) = index_r( ss , 1)* 20-  burst_start( 1 )*20;
%                end 
%             else
%                   ss = find( index_r( : , 1 ) >= burst_start( t ) + round(x) & ...            
%                   index_r( : , 1 ) < burst_end( t ) & index_r( : , 2 ) == rand_CH( ch ) , 1 ) ;       
%                 if isempty( ss ) ~= 1
%                    motif( t , ch ) = index_r( ss , 1 )  -  burst_start( t ); 
% %                    burst( t , ch ) = index_r( ss , 1)* 20-  burst_start( t )*20;
%                end 
%             end    
%         else
%                 
%         ss = find( index_r( : , 1 ) >= (burst_start( t ) + round(x)) & ...            
%             index_r( : , 1 ) < burst_end( t ) & index_r( : , 2 ) == channel , 1 ) ;       
%           if isempty( ss ) ~= 1
%               motif( t , ch ) = index_r( ss , 1 )  -  ( burst_start( t )  + round(x) );
% %               burst( t , ch ) = index_r( ss , 1)* 20-  burst_start( t )*20;
%           end
%         
%         end
%                 
%         
% %         for s = 1 : k
% %             burst( t , ss( k - s + 1 ) , : ) = index_r( ss( k - s + 1 ) , : ) ;
% %             index_r( ss( k - s + 1 ) , : ) = [] ;
% %         end
%     end
% %     motif( t , : ) = burst( t , : ) - min( motif( t , : ) ) ;
% % 
% %     figure
% %     chh = 1:64 ;
% %         plot(  motif( t , :) , chh(:) ,'.','MarkerEdgeColor' ,[.04 .52 .78] )
% % %         
% 
% end
% 
% % /////////////////////////// 2nd set
% for t = 1 : Nb2
% %     x = 0 ; % rand() * mmnn ;  
% rand_CH = RandomArrayN( N );                   
%     
%   for ch = 1 : N   
%         
%         if random_channel == 'y'
% %             channel = floor( rand()*(N-1) +1);
%             channel = rand_CH( ch );
%         else    
%             channel = ch ; % 
%         end
%                
%         if one_burst_part_at_all == 'y'
%             if round(x) > one_burst_from && round(x) <= one_burst_to        
%                    ss = find( index_r( : , 1 ) >= burst_start( 1 ) + round(x) & ...            
%                    index_r( : , 1 ) < burst_end( 1 ) & index_r( : , 2 ) == channel , 1 ) ;       
%                if isempty( ss ) ~= 1
%                   motif( t , ch ) = index_r( ss , 1 )  - burst_start( 1 );  
% %                   burst( t , ch ) = index_r( ss , 1)* 20-  burst_start( 1 )*20;
%                end 
%             else
%                   ss = find( index_r( : , 1 ) >= burst_start( t ) + round(x) & ...            
%                   index_r( : , 1 ) < burst_end( t ) & index_r( : , 2 ) == rand_CH( ch ) , 1 ) ;       
%                 if isempty( ss ) ~= 1
%                    motif( t , ch ) = index_r( ss , 1 )  -  burst_start( t ); 
% %                    burst( t , ch ) = index_r( ss , 1)* 20-  burst_start( t )*20;
%                end 
%             end    
%         else
%                 
%         ss = find( index_r2( : , 1 ) >= (burst_start2( t ) + round(x)) & ...            
%             index_r2( : , 1 ) < burst_end2( t ) & index_r2( : , 2 ) == channel , 1 ) ;       
%           if isempty( ss ) ~= 1
%               motif2( t , ch ) = index_r2( ss , 1 )  -  ( burst_start2( t )  + round(x) );
% %               burst( t , ch ) = index_r( ss , 1)* 20-  burst_start( t )*20;
%           end
%         
%         end
%                         
% %         for s = 1 : k
% %             burst( t , ss( k - s + 1 ) , : ) = index_r( ss( k - s + 1 ) , : ) ;
% %             index_r( ss( k - s + 1 ) , : ) = [] ;
% %         end
%     end
% %     motif( t , : ) = burst( t , : ) - min( motif( t , : ) ) ;
% % 
% %     figure
% %     chh = 1:64 ;
% %         plot(  motif( t , :) , chh(:) ,'.','MarkerEdgeColor' ,[.04 .52 .78] )
% % %         
% 
% end

if ANALYSE_SIMILARITY 

    mR_difference_arr = [] ;
    R1s = [];
    R2s = [];
    R3s =[] ;R4s =[] ;
    ix = [];
    % Nb2 = Nb ;

    nbursts = 0 ;
    % nbursts = nbursts - 1 ;
    n11 = 1 ; n12 = 1+ nbursts ;
    for n21 = 1 :1: Nb2 - 1*nbursts
        % for n21 = Nb2 - nbursts - 1 :-1: 1
        [P_val1 ,P_val2 , P_val_cross,P_val_surr_cross, mR_difference,R1,R2,R3,R4 , R5] = Two_sets_compare_similarity( ...
                   m1.burst_activation , m2.burst_activation , 0 , 0 , n21 , n21 + 1*0 , 'n' , PHASE_ON , ADJUST_SPIKES , 2 );
        %        [P_val1 ,P_val2 , P_val_cross,P_val_surr_cross, mR_difference,R1,R2,R3,R4 ] = Two_sets_compare_similarity( ...
        %            m1.burst_activation , m2.burst_activation , 0 , 0 , n21 , n21 + 1*0 , 'n' , PHASE_ON , ADJUST_SPIKES );
        mR_difference_arr = [ mR_difference_arr mR_difference ] ;
        R1s = [ R1s R1 ];R2s = [ R2s R2 ];R3s = [ R3s R3 ];R4s = [ R4s R4 ];
        ix = [ ix m2.burst_start(n21)/1000 ];
    end
    % figure
    % plot( ix , mR_difference_arr )
    if SHOW_FIGURES == 'y'
        figure
        hold on
    plot(ix , R2s , '-o' ) 
    plot(  ix , R1s  ,ix , R3s ,'-o' ) 
    hold off
    title( 'Pattern distance to center mass' )

    figure
    % plot(ix , R1s , ix , R2s , ix , R3s )
    ix2 = ix ; ix2(end) = ix(end)*2 + 30 ;
    hold on
    plot(ix , R2s , '-o' )
    plot( ix2 , R1s , ix+ix(end)+30 , R3s , '-o' )
    hold off
    title( 'Pattern distance to center mass' )
    end


[P_val1 ,P_val2 , P_val_cross,P_val_surr_cross, mR_difference,R1,R2,R3,R4,R5,R6 ,ResCell ] = Two_sets_compare_similarity( ...
           m1.burst_activation , m2.burst_activation , 0 , 0 , 0 ,0 , SHOW_FIGURES , PHASE_ON , ADJUST_SPIKES , 2);   
% title( 'first 10% of bursts VS last 10%' )


% TOTAL_ANAYSIS_DATA.Activation_Patterns_different_if1_P1C1vsP2C1=R5 ;
% TOTAL_ANAYSIS_DATA.JaccardI_P1C1_P2C1 = R4 ;
% TOTAL_ANAYSIS_DATA.JaccardI_P1_P2 = R6 ;

eval(['save ANAlYSIS_2sets_compare_total.mat TOTAL_ANAYSIS_DATA -mat']);  

RESULT = [];


TOTAL_ANAYSIS_DATA.Tact_Intersimilarity_Dissimilar_patterns_precent=  ResCell.Tact_Intersimilarity_Dissimilar_patterns_precent  ;
TOTAL_ANAYSIS_DATA.Tact_Centroid_accuracy_precent= 100 - ResCell.Tact_Centroid_Error_precent ;
TOTAL_ANAYSIS_DATA.Tact_Clustering_accuracy_precent_KMEANS= 100 - ResCell.Tact_Clustering_error_precent_KMEANS ;
TOTAL_ANAYSIS_DATA.Tact_Centroid_Error_points=   ResCell.Tact_Centroid_Error_points ;
TOTAL_ANAYSIS_DATA.Tact_Intersimilarity_Dissimilar_patterns=  ResCell.Tact_Intersimilarity_Dissimilar_patterns  ;
TOTAL_ANAYSIS_DATA.patterns_numS1 = Nb ;
TOTAL_ANAYSIS_DATA.patterns_numS2 =  Nb2 ;


RESULT=[RESULT  TOTAL_ANAYSIS_DATA.total_number_of_active_channels  ];
RESULT=[RESULT  TOTAL_ANAYSIS_DATA.total_number_of_active_channels_precent ];
RESULT=[RESULT  TOTAL_ANAYSIS_DATA.Tact_total_number_of_active_electrodes  ];
RESULT=[RESULT  TOTAL_ANAYSIS_DATA.Tact_Stat_selective_electrodes_num  ];                
RESULT=[RESULT  TOTAL_ANAYSIS_DATA.Tact_Selective_electrodes_lin_div_num  ];
RESULT=[RESULT  TOTAL_ANAYSIS_DATA.Tact_Intersimilarity_Dissimilar_patterns_precent];
RESULT=[RESULT  TOTAL_ANAYSIS_DATA.Tact_Clustering_accuracy_precent_KMEANS ];
RESULT=[RESULT  TOTAL_ANAYSIS_DATA.Tact_Centroid_accuracy_precent ];
RESULT=[RESULT  TOTAL_ANAYSIS_DATA.Tact_SVM_accuracy];
RESULT=[RESULT  TOTAL_ANAYSIS_DATA.TOTAL_RATE_total_number_of_active_electrodes ];
RESULT=[RESULT  TOTAL_ANAYSIS_DATA.TOTAL_RATE_Stat_selective_electrodes_num ];
RESULT=[RESULT  TOTAL_ANAYSIS_DATA.TOTAL_RATE_Selective_electrodes_lin_div_num  ];
RESULT=[RESULT  TOTAL_ANAYSIS_DATA.TOTAL_RATE_Intersimilarity_Dissimilar_patterns_precent];
RESULT=[RESULT  TOTAL_ANAYSIS_DATA.TOTAL_RATE_Clustering_Accuracy_precent_KMEANS  ];
RESULT=[RESULT  TOTAL_ANAYSIS_DATA.TOTAL_RATE_Centroid_Accuracy_precent ];
RESULT=[RESULT  TOTAL_ANAYSIS_DATA.TOTAL_RATE_SVM_accuracy ];
RESULT=[RESULT  TOTAL_ANAYSIS_DATA.Total_bins  ];
RESULT=[RESULT  TOTAL_ANAYSIS_DATA.SpikeRate_STAT_Selectivity_Nbins_total ];
RESULT=[RESULT  TOTAL_ANAYSIS_DATA.SpikeRate_STAT_Selectivity_Nbins_precent ];
RESULT=[RESULT  TOTAL_ANAYSIS_DATA.SpikeRate_LINEARY_Selectivity_Nbins_total ];
RESULT=[RESULT  TOTAL_ANAYSIS_DATA.SpikeRate_LINEARY_Selectivity_Nbins_precent ];
RESULT=[RESULT  TOTAL_ANAYSIS_DATA.SPIKE_RATES_1stBin_Clustering_accuracy_precent_KMEANS ];
RESULT=[RESULT  TOTAL_ANAYSIS_DATA.SPIKE_RATE_1stBin_Centroid_accuracy_precent ];
RESULT=[RESULT  TOTAL_ANAYSIS_DATA.SPIKE_RATE_1stBin_SVM_accuracy  ];
RESULT=[RESULT  TOTAL_ANAYSIS_DATA.patterns_numS1 ];
RESULT=[RESULT  TOTAL_ANAYSIS_DATA.patterns_numS2 ];
RESULT=[RESULT   TOTAL_ANAYSIS_DATA.psth_diff_precent ];

TOTAL_RATE_Overlaps_lin_div = TOTAL_ANAYSIS_DATA.TOTAL_RATE_Overlaps_lin_div'   ;
Tact_Overlaps_lin_div =TOTAL_ANAYSIS_DATA.Tact_Overlaps_lin_div';
LENGTH_TOTAL_RATE_Overlaps_lin_div = length( TOTAL_RATE_Overlaps_lin_div);
LENGTH_Tact_Overlaps_lin_div = length( Tact_Overlaps_lin_div );
TOTAL_RATE_Overlaps_lin_div
Tact_Overlaps_lin_div
 SPIKE_RATE_OVERLAPS
 
 [ countsTOTAL_RATE_Overlaps_lin_div , xTOTAL_RATE ] = hist_desired( TOTAL_RATE_Overlaps_lin_div ,5 ) ;
 [ countsTact_Overlaps_lin_div , xTact_Overlaps ] = hist_desired( Tact_Overlaps_lin_div  ,5) ; 
 [ countsSPIKE_RATE_OVERLAPS , xSPIKE_RATE_OVERLAPS ] = hist_desired( SPIKE_RATE_OVERLAPS ,5 ) ;
  [ countsFirstBIN_SPIKERATE_OVERLAPS , xFirstBIN_SPIKERATE_OVERLAPS ] = hist_desired( FirstBIN_SPIKERATE_OVERLAPS ,5 ) ;
  [ countsTOTAL_RATE_Overlaps_lin_div_bin2 , xTOTAL_RATE_bin2 ] = hist_desired( TOTAL_RATE_Overlaps_lin_div ,2 ) ;
 [ countsTact_Overlaps_lin_div_bin2 , xTact_Overlaps_bin2 ] = hist_desired( Tact_Overlaps_lin_div  ,2) ; 
 [ countsSPIKE_RATE_OVERLAPS_bin2 , xSPIKE_RATE_OVERLAPS_bin2 ] = hist_desired( SPIKE_RATE_OVERLAPS ,2 ) ;
  [ countsFirstBIN_SPIKERATE_OVERLAPS_bin2 , xSPIKE_RATE_OVERLAPS_bin2 ] = hist_desired( FirstBIN_SPIKERATE_OVERLAPS ,2 ) ;
 
 countsSPIKE_RATE_OVERLAPS
 countsFirstBIN_SPIKERATE_OVERLAPS
countsTOTAL_RATE_Overlaps_lin_div
 countsTact_Overlaps_lin_div
 xTact_Overlaps
RESULT = RESULT';
RESULT






end

  end
  
  
if Nb < 4 & Nb2 < 4 
    RESULT(1)=0;
end