
%  Compare2files_bursts_rates

N = 64 ;
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


MAIN_PSTH_DIFFERENCE_TIME_BIN = 20 ; % bin for PSTH difference - 10 ms default

SHOW_FIGURES = 'y' ;

TOTAL_ANAYSIS_DATA = [] ;
RESULT = 0;

pathname

cd( pathname ) ; 
m1 = load( char( filename ) ) ;
[pathstr,name,ext,versn] = fileparts ( filename ) ;
File_name_x =name;

if filename2 ~= 0 
    
cd( pathname2 ) ; 
m2 = load( char( filename2 ) ) ;
else
    m2 = m1 ;
end

Nb = length( m1.burst_start )          % Number of bursts
Nb2 = length( m2.burst_start )          % Number of bursts

xx = [] ;
I = 0 ;


% ----- CUT small responses------------------------------------------
m1.Spike_Rates_each_burst = Spikes_in_bursts( m1.bursts , Nb ,Start_t ,  Total_burst_len , N );
m2.Spike_Rates_each_burst = Spikes_in_bursts( m2.bursts , Nb2 ,Start_t ,  Total_burst_len , N );

EMPTY_SPIKE_TIME=[];  
    response_str_THR = (Spike_Rates_each_burst_cut_Threshold_precent /100) * max( m1.Spike_Rates_each_burst);
     weak_responses_index = find( m1.Spike_Rates_each_burst(:) <= response_str_THR   );
 
Nb=Nb- length(weak_responses_index);
      m1.burst_activation( weak_responses_index , :  ) = [] ;
      m1.bursts( weak_responses_index , : , :  ) = [] ;
 
%       m2.Spike_Rates_each_burst
    response_str_THR = (Spike_Rates_each_burst_cut_Threshold_precent /100) * max( m2.Spike_Rates_each_burst );
     weak_responses_index = find( m2.Spike_Rates_each_burst(:) <= response_str_THR );
     Nb2 = Nb2 - length(weak_responses_index);
      m2.burst_activation( weak_responses_index , :  ) = [] ;
      m2.bursts( weak_responses_index , : , :  ) = [] ;
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

TOTAL_ANAYSIS_DATA.FirstBIN_SPIKERATE_OVERLAPS = FirstBIN_SPIKERATE_OVERLAPS ;
TOTAL_ANAYSIS_DATA.SPIKE_RATES_1stBin_Clustering_accuracy_precent_KMEANS = SPIKE_RATES_1stBin_Clustering_error_precent_KMEANS ;
TOTAL_ANAYSIS_DATA.SPIKE_RATES_1stBin_KMEANS_accuracy = 100 * SPIKE_RATES_1stBin_KMEANS_accuracy ;
TOTAL_ANAYSIS_DATA.SPIKE_RATE_1stBin_Centroid_accuracy_precent = 100 - SPIKE_RATE_1stBin_Centroid_Error_precent ; % first bin
TOTAL_ANAYSIS_DATA.SPIKE_RATE_1stBin_SVM_accuracy = 100 * SPIKE_RATE_1stBin_SVM_accuracy ; % first bin















