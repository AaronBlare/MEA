 %----------Patterns_get_Statistsic_all_parameters     
% Patterns.TimeBin_Total_Spikes  ... -> TimeBin_Total_Spikes_mean

   Nb= Patterns.Number_of_Patterns ;
%     fire_bins = floor((Patterns.Poststim_interval_END - Patterns.Poststim_interval_START) / Patterns.DT_bin) ; 
    fire_bins = round((Patterns.Poststim_interval_END  ) / Patterns.DT_bin) ; 
 DT = Patterns.DT_bin ; 
  N = Patterns.N_channels ;
  show_figures_test = true ;
  
 TimeBins_x = 0:DT: (fire_bins-1)*DT ;
 TimeBins_x0 = TimeBins_x ;
  
  new_method = true ;
  
  if new_method
      
      var.Find_only_SpikeRate = false ;  
 var.Burst_Data_Ver =  Burst_Data_Ver ; 
 var.N = N ;
        
% [  Patterns.TimeBin_Total_Spikes ,  Patterns.TimeBin_Total_Spikes_mean , Patterns.TimeBin_Total_Spikes_std , ...
%                Patterns.Spike_Rate_Patterns ,  Patterns.Spike_Rates_Signature ,  ... 
%                Patterns.Spike_Rate_Signature_std , Patterns.Amp_Patterns , Patterns.Amps_Signature , Patterns.Amps_Signature_std ,...
%                Patterns.TimeBin_Total_Amps ,  Patterns.TimeBin_Total_Amps_mean ,  Patterns.TimeBin_Total_Amps_std ]   ...
%                   = Get_Electrodes_Rates_at_TimeBins_1pattern_for_Bursts( N ,Nb  , Patterns.bursts , ...
%                   Patterns.Poststim_interval_START ,   Patterns.Poststim_interval_END , Patterns.DT_bin  ,Patterns.bursts_amps ,var );
       if Nb > 0       
              [  Patterns.TimeBin_Total_Spikes ,  Patterns.TimeBin_Total_Spikes_mean , Patterns.TimeBin_Total_Spikes_std , ...
               Patterns.Spike_Rate_Patterns ,  Patterns.Spike_Rates_Signature ,  ... 
               Patterns.Spike_Rate_Signature_std , Patterns.Amp_Patterns , Patterns.Amps_Signature , Patterns.Amps_Signature_std  , ...
    Patterns.TimeBin_Total_Amps ,  Patterns.TimeBin_Total_Amps_mean ,  Patterns.TimeBin_Total_Amps_std , ...
     Patterns.Amps_Signature_mean , Patterns.Total_Amps_mean_all_chan , ...
   Patterns.Total_Amps_std_all_chan , Patterns.Amps_each_channel_mean ,  Patterns.Amps_each_channel_std ...
   , Patterns.Amps_mean_each_burst ,Patterns.AmpRates ]   ...
                          = Get_Electrodes_Rates_at_TimeBins_1pattern_for_Bursts( N , Nb  , Patterns.bursts , ...
                  Patterns.Poststim_interval_START ,  Patterns.Poststim_interval_END , Patterns.DT_bin  ,Patterns.bursts_amps  ,var );
              Patterns.DT_bins_number =  fire_bins   ;
            Patterns.TimeBins_x = TimeBins_x  ;  
       end
              
Patterns.Spike_Rates_each_burst_mean  = 0;
Patterns.Spike_Rates_each_burst_std  = 0;
Patterns.Spike_Rates_each_channel_mean  = zeros(  N , 1 );
Patterns.Spike_Rates_each_channel_std  = zeros(  N , 1 );             
Patterns.burst_activation_mean =zeros(  N , 1 );  



if  isfield( Patterns , 'burst_activation_2')
   Patterns.burst_activation_2_mean =zeros(  N , 1 );  
end 
  for ch = 1 : N  
      
        Patterns.Spike_Rates_each_channel_mean( ch )  = mean(Patterns.Spike_Rates(  : , ch ));
        Patterns.Spike_Rates_each_channel_std( ch )  = std(Patterns.Spike_Rates(  : , ch  ));
        Patterns.Spike_Rates_each_channel_zero_values_num( ch ) = length( find( Patterns.Spike_Rates(  : , ch ) ==0) ); 
 
        Patterns.burst_activation_mean( ch ) = mean(  Patterns.burst_activation(:, ch )   ) ; 
        if  isfield( Patterns , 'burst_activation_2')
             Patterns.burst_activation_2_mean( ch ) = mean( Patterns.burst_activation_2(:, ch ) ) ;
        end
        

  end          
        Patterns.Spike_Rates_each_burst_mean  = mean( Patterns.Spike_Rates_each_burst );
        Patterns.Spike_Rates_each_burst_std = std( Patterns.Spike_Rates_each_burst ); 
        


  else
  
%-- Statistical characteristics INIT------------
Patterns.burst_activation_mean =zeros(  N , 1 );  
if  isfield( Patterns , 'burst_activation_2')
   Patterns.burst_activation_2_mean =zeros(  N , 1 );  
end
Patterns.Spike_Rates_each_burst_mean  = 0;
Patterns.Spike_Rates_each_burst_std  = 0;
Patterns.Spike_Rates_each_channel_mean  = zeros(  N , 1 );
Patterns.Spike_Rates_each_channel_std  = zeros(  N , 1 ); 
Patterns.Spike_Rates_Signature = zeros( fire_bins  , N ); 
Patterns.Spike_Rates_Signature_std = zeros( fire_bins  , N );  
Patterns.TimeBin_Total_Spikes_mean = zeros(1,fire_bins); 
Patterns.TimeBin_Total_Spikes_std = zeros(1,fire_bins);  
Patterns.TimeBin_Total_Amps_mean = zeros(1,fire_bins);
Patterns.TimeBin_Total_Amps_std = zeros(1,fire_bins);
Patterns.Amps_Signature = zeros( fire_bins  , N ); 
Patterns.Amps_Signature_std = zeros( fire_bins  , N );
Patterns.DT_bins_number = length( fire_bins ) ;
Patterns.TimeBins_x = TimeBins_x ;  
%------------------------------------
  chan_firing1_total = zeros( Nb , 1) ; 
chan_amps_total = zeros( Nb , 1) ;
  
  for ch = 1 : N 
      for ti=1: fire_bins   
            chan_firing1_total( : ) = Patterns.Spike_Rate_Patterns(  ti , ch ,  :  ) ; 
            chan_amps_total( : ) = Patterns.Amp_Patterns(  ti , ch ,  :  );
            
            Patterns.Spike_Rates_Signature( ti , ch ) = Calc_Centroid_value_1D( chan_firing1_total )  ;
            Patterns.Spike_Rates_Signature_std( ti ,  ch ) = std( chan_firing1_total  )  ; 
            Patterns.Amps_Signature( ti , ch ) = Calc_Centroid_value_1D( chan_amps_total )  ;
            Patterns.Amps_Signature_std( ti ,  ch ) = std( chan_amps_total  )  ;
      end 
      
        Patterns.Spike_Rates_each_channel_mean( ch )  = mean(Patterns.Spike_Rates(  : , ch ));
        Patterns.Spike_Rates_each_channel_std( ch )  = std(Patterns.Spike_Rates(  : , ch  ));
        Patterns.Spike_Rates_each_channel_zero_values_num( ch ) = length( find( Patterns.Spike_Rates(  : , ch ) ==0) ); 
         
       	Patterns.burst_activation_nonZeros = Patterns.burst_activation(:, ch )  ;
        Patterns.burst_activation_nonZeros=Patterns.burst_activation_nonZeros( Patterns.burst_activation_nonZeros > 0);
        Patterns.burst_activation_mean( ch ) = mean(  Patterns.burst_activation_nonZeros  ) ; 
        if  isfield( Patterns , 'burst_activation_2')
             Patterns.burst_activation_2_mean( ch ) = mean( Patterns.burst_activation_2(:, ch ) ) ;
        end
        
  end
  
  
  for ti=1:fire_bins 
      Patterns.TimeBin_Total_Spikes_mean( ti ) = mean( Patterns.TimeBin_Total_Spikes( : , ti ));
      Patterns.TimeBin_Total_Spikes_std( ti ) = std( Patterns.TimeBin_Total_Spikes( : , ti ));
 
      Amps = Patterns.TimeBin_Total_Amps( : , ti ) ;
      Amps(Amps>=0) =[];
      if isempty( Amps )
          Amps=0;
      end
       Patterns.TimeBin_Total_Amps_mean( ti ) = mean( Amps );
       Patterns.TimeBin_Total_Amps_std( ti ) = std( Amps );
  end   
        Patterns.Spike_Rates_each_burst_mean  = mean( Patterns.Spike_Rates_each_burst );
        Patterns.Spike_Rates_each_burst_std = std( Patterns.Spike_Rates_each_burst ); 
        
  end
          
%       figure
%        DT_step = Patterns.DT_bin ;
%                             DT_bins_number = floor((Patterns.Poststim_interval_END - Patterns.Poststim_interval_START) / Patterns.DT_bin  ) ;
%                             Start_t =  Patterns.Poststim_interval_START ; 
%                             TimeBins = 0 : DT_bins_number-1 ; 
%                             TimeBins_x = Start_t + TimeBins * DT_step ;
%                             barwitherr2( Patterns.TimeBin_Total_Spikes_std  , TimeBins_x  , Patterns.TimeBin_Total_Spikes_mean );
%                                  title( ['High reponses PSTH'  ', bin=' int2str( DT_step ) 'ms' ] )
%                                 xlabel( 'Post-stimulus time, ms')
%                                 ylabel( 'Spikes per bin')
%                                 if max( Patterns.TimeBin_Total_Spikes_mean ) > 1
%                                     axis( [ min( TimeBins_x  )- DT_step   max( TimeBins_x ) + DT_step   ...
%                                         0 1.2 * max(   Patterns.TimeBin_Total_Spikes_std ) ...
%                                          + max(  Patterns.TimeBin_Total_Spikes_mean) ] )
%                                 end 
%                                 
%                                 
%                                 
%                                DT_step
%         
        
        
           %>>>>>>>>>> Analyze spikerate profiles
               
              Calc_Spikerate_profile_1ms_bin = Global_flags.Stim_Calc_Spikerate_profile_1ms_bin ;
              SR_Search_Params = Global_flags.Stim_Search_Params  ; 
              Spike_Rate_Signature_max_duration_ms =  Patterns.Poststim_interval_END ;

if Calc_Spikerate_profile_1ms_bin               
%               [ TimeBin_Total_Spikes_1ms , TimeBin_Total_Spikes_mean_1ms , TimeBin_Total_Spikes_std_1ms , Spike_Rate_Patterns_1ms , ...
%                    Spike_Rate_Signature_1ms , Spike_Rate_Signature_std_1ms , Spike_Rate_1ms_smooth_Max_corr_delay , ...
%                    Spike_Rate_Signature_1ms_smooth , Amp_Patterns_1ms , Amps_Signature_1ms  , Amps_Signature_1ms_std , Amps_Signature_1ms_smooth , ...
%                    Spike_Rate_1ms_Max_corr_delay , Spike_Rate_Signature_1ms_interp , DT_bin_interp ]   = ...
   [  Patterns.TimeBin_Total_Spikes_1ms , Patterns.TimeBin_Total_Spikes_std_1ms , Patterns.Spike_Rate_Patterns_1ms ,  ...
      Patterns.Spike_Rate_Signature_1ms ,  Patterns.Spike_Rate_Signature_std_1ms ,  Patterns.Spike_Rate_1ms_smooth_Max_corr_delay , ...
      Patterns.Spike_Rate_Signature_1ms_smooth , Patterns.Amp_Patterns_1ms , Patterns.Amps_Signature_1ms ...
      , Patterns.Amps_Signature_1ms_std ,  Patterns.Amps_Signature_1ms_smooth , ...
      Patterns.Spike_Rate_1ms_Max_corr_delay , Patterns.Spike_Rate_Signature_1ms_interp , Patterns.DT_bin_interp ] =  ...   
             SR_profile_1ms_calc( Calc_Spikerate_profile_1ms_bin ,  N , Nb ,Patterns.bursts  , ...
             Patterns.bursts_amps , SR_Search_Params , Patterns.Poststim_interval_END ) ;
           
%>>>>>>>>>> 
        %--- Burst activation based on average activity ---------------   
       
        DT_bin_1ms = 1 ;
        if  SR_Search_Params.Calc_Spikerate_profile_1ms_interp 
            Patterns.Spike_Rate_Signature_1ms_for_Tact = Patterns.Spike_Rate_Signature_1ms_interp ;
            DT_bin_1ms_Tact =   Patterns.DT_bin_interp ;
        else
            Patterns.Spike_Rate_Signature_1ms_for_Tact = Patterns.Spike_Rate_Signature_1ms_smooth ;
            DT_bin_1ms_Tact =   DT_bin_1ms ;
        end
         
       %---------------------------------------------------  
         if SR_Search_Params.Plot_Tact3_diff_levels && show_figures_test
          
%              Tact_2d_diff = MNDB_Make2d_data_from_vector( burst_activation_3_smooth_1ms_mean  );
%               var.new_figure = true ;
%              var.calc_bidirection = false ;
%              var.background_1d_vector = true ;
%              var.background_1d_vector_data = burst_activation_3_smooth_1ms_mean ;
%              
%                  Connectiv_Post_proc( Tact_2d_diff  , var  ) 
             
             figure
             Nx = 3 ; Ny = 3 ;
              i = 0 ;
              
             for T_activation_stat_threshold_param = 1 : 9
                 i = i +1 ;
                 subplot( Ny , Nx , i )
                   [ burst_activation_2_mean , burst_activation_2 , burst_activation_3_smooth_1ms_mean , ...
                 burst_max_rate_delay_ms , burst_max_rate_delay_ms_mean    ] = ... 
                SR_profile_Tact2_3_from_1msProfile( N , Nb , Calc_Spikerate_profile_1ms_bin , Search_Params.Burst_activation_based_smooth_find_all_bursts , ...
                 Spike_Rate_Signature_max_duration_ms  ,  DT_bin_1ms_Tact , Patterns.Spike_Rate_Patterns_1ms , ...
                 Global_flags ,  SR_Search_Params.T_activation_stat_threshold_param ,...
                 Global_flags , Patterns.Spike_Rate_Signature_1ms_for_Tact ,  Patterns.burst_activation_mean , Patterns.Spike_Rates_each_channel_mean ) ;
             
%                  Plot8x8Data( burst_activation_3_smooth_1ms_mean , false , false )
                 
%                   Tact_2d_diff = MNDB_Make2d_data_from_vector( burst_activation_3_smooth_1ms_mean  );
%                  var.new_figure = false ;
%                  var.calc_bidirection = false ;
%                  var.background_1d_vector = true ;
%                  var.background_1d_vector_data = burst_activation_3_smooth_1ms_mean ;
%              
%                  Connectiv_Post_proc( Tact_2d_diff  , var  )
%                 title( ['Activation ' num2str( T_activation_stat_threshold_param * 10 ) ' %' ] )
             end 
         end
       %---------------------------------------------------  
          [ Patterns.burst_activation_2_mean , Patterns.burst_activation_2 , Patterns.burst_activation_3_smooth_1ms_mean , ...
     Patterns.burst_max_rate_delay_ms , Patterns.burst_max_rate_delay_ms_mean    ] = ... 
            SR_profile_Tact2_3_from_1msProfile( N , Nb , Calc_Spikerate_profile_1ms_bin , SR_Search_Params.Burst_activation_based_smooth_find_all_bursts , ...
             Spike_Rate_Signature_max_duration_ms ,  DT_bin_1ms_Tact , Patterns.Spike_Rate_Patterns_1ms , ...
             Global_flags , SR_Search_Params.T_activation_stat_threshold_param ,...
             Global_flags , Patterns.Spike_Rate_Signature_1ms_for_Tact ,  Patterns.burst_activation_mean , Patterns.Spike_Rates_each_channel_mean ) ;
        
        
end     
        
        
        
        
        