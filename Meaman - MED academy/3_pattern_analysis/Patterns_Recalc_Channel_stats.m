 %----------Patterns_get_Statistsic_all_parameters     
 function Patterns = Patterns_Recalc_Channel_stats( Patterns )

   Nb= Patterns.Number_of_Patterns ;
%     fire_bins = floor((Patterns.Poststim_interval_END - Patterns.Poststim_interval_START) / Patterns.DT_bin) ; 
%  DT = Patterns.DT_bin ; 
a = size( Patterns.Spike_Rates );
  N = a(2) ;
  
%-- Statistical characteristics INIT------------
% Patterns.burst_activation_mean =zeros(  N , 1 );  
% Patterns.Spike_Rates_each_burst_mean  = 0;
% Patterns.Spike_Rates_each_burst_std  = 0;
% Patterns.Spike_Rates_each_channel_mean  = zeros(  N , 1 );
% Patterns.Spike_Rates_each_channel_std  = zeros(  N , 1 ); 
% Patterns.Spike_Rates_Signature = zeros( fire_bins  , N ); 
% Patterns.Spike_Rates_Signature_std = zeros( fire_bins  , N );  
% Patterns.TimeBin_Total_Spikes_mean = zeros(1,fire_bins); 
% Patterns.TimeBin_Total_Spikes_std = zeros(1,fire_bins);  
% Patterns.TimeBin_Total_Amps_mean = zeros(1,fire_bins);
% Patterns.TimeBin_Total_Amps_std = zeros(1,fire_bins);
% Patterns.Amps_Signature = zeros( fire_bins  , N ); 
% Patterns.Amps_Signature_std = zeros( fire_bins  , N );
%------------------------------------
%   chan_firing1_total = zeros( Nb , 1) ; 
% chan_amps_total = zeros( Nb , 1) ;
  
  for ch = 1 : N 
%       for ti=1: fire_bins   
%             chan_firing1_total( : ) = Patterns.Spike_Rate_Patterns(  ti , ch ,  :  ) ; 
%             chan_amps_total( : ) = Patterns.Amp_Patterns(  ti , ch ,  :  );
%             
%             Patterns.Spike_Rates_Signature( ti , ch ) = Calc_Centroid_value_1D( chan_firing1_total )  ;
%             Patterns.Spike_Rates_Signature_std( ti ,  ch ) = std( chan_firing1_total  )  ; 
%             Patterns.Amps_Signature( ti , ch ) = Calc_Centroid_value_1D( chan_amps_total )  ;
%             Patterns.Amps_Signature_std( ti ,  ch ) = std( chan_amps_total  )  ;
%       end 
      
        Patterns.Spike_Rates_each_channel_mean( ch )  = mea_Mean_defined(Patterns.Spike_Rates(  : , ch ));
        Patterns.Spike_Rates_each_channel_std( ch )  = mea_Std_defined(Patterns.Spike_Rates(  : , ch  ));
%         Patterns.Spike_Rates_each_channel_zero_values_num( ch ) = length( find( Patterns.Spike_Rates(  : , ch ) ==0) ); 
         
%        	Patterns.burst_activation_nonZeros = Patterns.burst_activation(:, ch )  ;
%         Patterns.burst_activation_nonZeros=Patterns.burst_activation_nonZeros( Patterns.burst_activation_nonZeros > 0);
        Patterns.burst_activation_mean( ch ) = mea_Mean_defined(  Patterns.burst_activation(:, ch )  ) ;   
%         Patterns.burst_activation_2_mean( ch ) = mea_Mean_defined(  Patterns.burst_activation_2_mean(:, ch )  ) ;   
%         Patterns.burst_activation_3_smooth_1ms_mean( ch ) = mea_Mean_defined(  Patterns.burst_activation_3_smooth_1ms_mean(:, ch )  ) ;   
  end
  
  
%   for ti=1:fire_bins 
%       Patterns.TimeBin_Total_Spikes_mean( ti ) = mean( Patterns.TimeBin_Total_Spikes( : , ti ));
%       Patterns.TimeBin_Total_Spikes_std( ti ) = std( Patterns.TimeBin_Total_Spikes( : , ti ));
%  
%        
%       Amps = Patterns.TimeBin_Total_Amps( : , ti ) ;
%       Amps(Amps>=0) =[];
%       if isempty( Amps )
%           Amps=0;
%       end
%        Patterns.TimeBin_Total_Amps_mean( ti ) = mean( Amps );
%        Patterns.TimeBin_Total_Amps_std( ti ) = std( Amps );
%   end   
  
%       for i=1:  Nb
%           Spike_Rates_each_burst(i) = sum( Spike_Rates( i , :)); 
%       end
   
    
        Patterns.Spike_Rates_each_burst_mean  = mea_Mean_defined( Patterns.Spike_Rates_each_burst );
        Patterns.Spike_Rates_each_burst_std = mea_Std_defined( Patterns.Spike_Rates_each_burst ); 
        

        
        
%               figure
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
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        