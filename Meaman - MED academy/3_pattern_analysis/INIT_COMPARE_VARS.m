
%INIT_COMPARE_VARS



Hi_Lo_Patterns1_2_enough_Low_responses = false ;
Hi_Lo_Patterns1_2_enough_High_responses = false ;
 
Hi_Lo_Patterns2_3_enough_Low_responses = false ;
Hi_Lo_Patterns2_3_enough_High_responses = false ;



TOTAL_RATE = []; 
SpikeRate = [] ;
 

 
    TOTAL_RATE.total_number_of_active_electrodes =0 ;
	TOTAL_RATE.TOTAL_RATE_stat_different_if_1 =0 ;
	TOTAL_RATE.psth_diff_rms =0 ;
	TOTAL_RATE.psth_diff_precent =0 ;
	TOTAL_RATE.Stat_selective_electrodes_num =0 ;
	TOTAL_RATE.Stat_Selective_electrodes_precent =0 ;
	TOTAL_RATE.Selective_electrodes_lin_div_num =0 ;
    TOTAL_RATE.Intersimilarity_Dissimilar_patterns_precent =0 ;
    TOTAL_RATE.Intersimilarity_Dissimilar_patterns =0 ;
    TOTAL_RATE.Centroid_Error_points =0 ;
    TOTAL_RATE.Centroid_Error_precent  =0 ;
    TOTAL_RATE.Clustering_error_precent_KMEANS =0 ;
    TOTAL_RATE.Clustering_error_precent_SVM   =0 ;
    TOTAL_RATE.SVM_accuracy =0 ;
    TOTAL_RATE.SpikeRate = [];
    TOTAL_RATE.Channels_overlap =[];
    
    
    SpikeRate.STAT_Selectivity_Nbins_total =0 ;
    SpikeRate.STAT_Selectivity_Nbins_precent =0 ;
    SpikeRate.LINEARY_Selectivity_Nbins_precent =0 ;
    SpikeRate.LINEARY_Selectivity_Nbins_total =0 ;
    SpikeRate.Total_bins =0 ;
    SpikeRate.SPIKE_RATE_OVERLAPS =0 ; 
    SpikeRate.SPIKE_RATE_OVERLAPS_STABLE =0 ;
    SpikeRate.SPIKE_RATE_1stBin_Centroid_Error_precent =0 ;
    SpikeRate.Bins_overlaps_mean =0 ;
    SpikeRate.SPIKE_RATE_1stBin_Clustering_error_precent_KMEANS  =0 ;
    SpikeRate.SPIKE_RATE_1stBin_KMEANS_accuracy =0 ;
    SpikeRate.FirstBIN_SPIKERATE_OVERLAPS =0 ;
    SpikeRate.SPIKE_RATE_1stBin_SVM_accuracy =0 ;
    SpikeRate.SPIKE_RATE_1stBin_Clustering_error_precent_SVM =0 ;
    SpikeRate.SPIKE_RATE_OVERLAPS = [];
    SpikeRate.SPIKE_RATE_1stBin_SPIKERATE_OVERLAPS = [];
    SpikeRate.SPIKE_RATE_optimal_tbin_OVERLAPS = [] ;
    
TOTAL_RATE_low = TOTAL_RATE ;
TOTAL_RATE_3files  =TOTAL_RATE ;
TOTAL_RATE_low_3files = TOTAL_RATE ;   

 T_act = [];
  
 T_act.total_number_of_active_electrodes  = 0 ;
 T_act.Stat_selective_channels_num  = 0 ;               
 T_act.Stat_Selective_channels_percent  = 0 ;
 T_act.Selective_electrodes_lin_div_num = 0 ;
 T_act.Intersimilarity_Dissimilar_patterns_precent = 0 ;
 T_act.Clustering_accuracy_precent_KMEANS = 0 ;
 T_act.Centroid_accuracy_precent = 0 ;
 T_act.SVM_accuracy = 0 ;
 T_act.Clustering_error_precent_SVM =0;
 T_act.Not_distinguishable_points_num_SVM =0; 
 T_act.Channels_overlap = []; 
 
T_act_low = T_act ; 
T_act_3files = T_act ;
T_act_3files_low = T_act ; 











