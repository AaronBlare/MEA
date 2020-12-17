function [ ANALYZED_DATA ] = Erase_big_data_from_ANALYZED_DATA( ANALYZED_DATA )


ANALYZED_DATA.Statistical_ANALYSIS = [];
           ANALYZED_DATA.Statistical_ANALYSIS_median_values=[];

           ANALYZED_DATA.Burst_Data_Ver  ;
           
           ANALYZED_DATA.Active_channels_index = [];
           ANALYZED_DATA.Active_channels_number   ;
           
%            ANALYZED_DATA.Total_spikes_each_channel = []  ;
%            ANALYZED_DATA.Total_firing_rates_each_channel = []  ;
           ANALYZED_DATA.Total_spikes_number  ;
           ANALYZED_DATA.Spikes_per_sec   ;
           ANALYZED_DATA.Firing_rate_per_channel =  []   ;
%            ANALYZED_DATA.Amps_mean_all_chan     ;
%            ANALYZED_DATA.Amps_std_all_chan     ;
    
           ANALYZED_DATA.Raster_duration_ms  ;  
           ANALYZED_DATA.Raster_duration_sec     ;
           
           ANALYZED_DATA.burst_activation_normalized_mean = [] ;
           ANALYZED_DATA.burst_activation_mean = [] ;
           if isfield(ANALYZED_DATA  , 'burst_activation_2_mean' )
               ANALYZED_DATA.burst_activation_2_mean = []  ;
               ANALYZED_DATA.burst_activation_3_smooth_1ms_mean = [] ; 
               ANALYZED_DATA.burst_max_rate_delay_ms_mean  ;
           end
            
           ANALYZED_DATA.burst_start     ;
           ANALYZED_DATA.burst_max  ;
           ANALYZED_DATA.burst_end ;
            
           ANALYZED_DATA.Number_of_bursts     ;       
           ANALYZED_DATA.Number_of_Patterns     ;  
           ANALYZED_DATA.Bursts_per_sec   ;
           ANALYZED_DATA.Bursts_per_min   ;

           ANALYZED_DATA.InteBurstInterval  ;
           ANALYZED_DATA.BurstDurations  ;

           ANALYZED_DATA.Spike_Rates = []   ;       
           ANALYZED_DATA.Spike_Rates_each_burst =  [] ;
           ANALYZED_DATA.Spike_Rates_each_channel_mean  ; %( 64 x 1 )
           ANALYZED_DATA.Spike_Rates_each_channel_std  ; %( 64 x 1 )
           ANALYZED_DATA.Spike_Rates_Signature =  [];% DT_bins number x 64
           ANALYZED_DATA.Spike_Rates_Signature_std =  [] ; % DT_bins number x 64
           ANALYZED_DATA.Spike_Rates_Signature_step_ms =  [] ;
           ANALYZED_DATA.Spike_Rates_Signature_max_duration_ms =  [] ;
           
           if isfield(ANALYZED_DATA  , 'Spike_Rate_Signature_1ms' )
           ANALYZED_DATA.Spike_Rate_Signature_1ms = [] ;% DT_bins number x 64
           ANALYZED_DATA.Spike_Rate_Signature__std_1ms = [] ; % DT_bins number x 64
           ANALYZED_DATA.Spike_Rates_Signature_step_ms = [] ;
           ANALYZED_DATA.Spike_Rates_Signature_max_duration_1ms = [] ;
           ANALYZED_DATA.Spike_Rate_Signature_1ms_smooth = [] ;  
           ANALYZED_DATA.Spike_Rate_Signature_1ms_interp = [] ; 
           ANALYZED_DATA.DT_bin_interp = [] ;  
           ANALYZED_DATA.Spike_Rate_1ms_smooth_Max_corr_delay = [] ;
           ANALYZED_DATA.Spike_Rate_1ms_Max_corr_delay = [] ;           
           ANALYZED_DATA.burst_max_rate_delay_ms = [] ;
            end
             
           ANALYZED_DATA.AmpRates = [] ;
           ANALYZED_DATA.Amps_mean_each_burst =  [] ;                       
           ANALYZED_DATA.Amps_each_channel_mean  ;
           ANALYZED_DATA.Amps_each_channel_std   ;
           ANALYZED_DATA.Amps_Signature  = [] ;
           ANALYZED_DATA.Amps_Signature_std = [] ; 
           ANALYZED_DATA.Amps_Signature_step_ms = [] ;
           ANALYZED_DATA.Amps_Signature_Signature_max_duration_ms = [] ;
            
           if isfield(ANALYZED_DATA  , 'Amps_Signature_1ms' )     
           ANALYZED_DATA.Amps_Signature_1ms = [];
           ANALYZED_DATA.Amps_Signature_1ms_std = [] ; 
           ANALYZED_DATA.Amps_Signature_1ms_smooth = [] ;
            
            
           ANALYZED_DATA.SpikeRate_burst_profile_1ms ;  
           ANALYZED_DATA.SpikeRate_burst_profile_1ms_max_duration   ;
           ANALYZED_DATA.SpikeRate_burst_profile_1ms_all   ;
            end
            
           ANALYZED_DATA.Firing_Rates = [] ;         
           ANALYZED_DATA.Firing_Rates_each_channel_mean     ; 
           ANALYZED_DATA.Firing_Rates_each_channel_std     ; 
           ANALYZED_DATA.Firing_Rates_each_burst = [] ;

           

           ANALYZED_DATA.TimeBin_Total_Spikes  = [] ; % Ns x DT_bins number 
           ANALYZED_DATA.TimeBin_Total_Spikes_mean   ;  % 1 x DT_bins number 
           ANALYZED_DATA.TimeBin_Total_Spikes_std   ;  % 1 x DT_bins number  
           ANALYZED_DATA.TimeBin_Total_Amps = []  ; 
           ANALYZED_DATA.TimeBin_Total_Amps_mean   ; 
           ANALYZED_DATA.TimeBin_Total_Amps_std    ; 
            
           ANALYZED_DATA.DT_bin     ; % Used for TimeBin_Total_Spikes_mean, ..      
           ANALYZED_DATA.DT_BINS_number  ;  
 
           ANALYZED_DATA.Small_bursts_filter_applied   ;
           ANALYZED_DATA.Small_bursts_number ;
           ANALYZED_DATA.Small_bursts_index = [] ;
           ANALYZED_DATA.Small_bursts_Davies_Bouldin_Clustering_index ;
           ANALYZED_DATA.Number_of_bursts_original    ; % before cut to small bursts
           

           % Superburstrs
           Superbrsts.Small_bursts_data = [] ;
           ANALYZED_DATA.Superbrsts  = [] ;  
           ANALYZED_DATA.Number_of_Superbursts    ;
           ANALYZED_DATA.SB_start  = [] ;
           ANALYZED_DATA.SB_end  = [] ; 
           ANALYZED_DATA.burst_in_superbursts     ;  
           

           % Awsr
           ANALYZED_DATA.AWSR_TimeBin     ;
           ANALYZED_DATA.AWSR_sig_tres ; 
           ANALYZED_DATA.Threshold_AWSR   ;
           
           ANALYZED_DATA.Flags  ;    
           
           ANALYZED_DATA.burst_activation_amps =[];           %  spike amps in first spikes
           ANALYZED_DATA.burst_activation = [];          
           ANALYZED_DATA.burst_activation_normalized = [] ; 
           if isfield(ANALYZED_DATA  , 'burst_activation_2' )
           ANALYZED_DATA.burst_activation_2 =  [] ;
           end     
           
           %======== Convert all structure to cell ============================
            ANALYZED_DATA.Analysis_data_cell =  [];
            ANALYZED_DATA.Analysis_data_cell_field_names =  [] ;
            
            
            
            ANALYZED_DATA.Spike_Rate_Patterns =  [];
            ANALYZED_DATA.Spike_Rate_Patterns_1ms =  []; 
            ANALYZED_DATA.Amp_Patterns =  [];
            ANALYZED_DATA.Amp_Patterns_1ms  =  []; 
            ANALYZED_DATA.bursts_absolute =  [];
               ANALYZED_DATA.bursts =  [];
               ANALYZED_DATA.bursts_amps=  [];
            
            
            
            
            
            
            