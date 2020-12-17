% Patterns_get_BIN_rates_from_bursts
 % Patterns.bursts -> Patterns.Spike_Rates_per_channel_per_bin ,
 % Patterns.Amps_per_channel_per_bin

 old_analysis = false ;
 
if ~old_analysis 
 var.Find_only_SpikeRate = false ;  
 var.Burst_Data_Ver =  Burst_Data_Ver ; 
 var.N = N ;
 s = size( Patterns.bursts ) ;
 N_responses = s(1);
               [  Patterns.TimeBin_Total_Spikes ,  Patterns.TimeBin_Total_Spikes_mean , Patterns.TimeBin_Total_Spikes_std , ...
               Patterns.Spike_Rate_Patterns ,  Patterns.Spike_Rates_Signature ,  ... 
               Patterns.Spike_Rate_Signature_std , Patterns.Amp_Patterns , Patterns.Amps_Signature , Patterns.Amps_Signature_std  , ...
    Patterns.TimeBin_Total_Amps ,  Patterns.TimeBin_Total_Amps_mean ,  Patterns.TimeBin_Total_Amps_std , ...
     Patterns.Amps_Signature_mean , Patterns.Total_Amps_mean_all_chan , ...
   Patterns.Total_Amps_std_all_chan , Patterns.Amps_each_channel_mean ,  Patterns.Amps_each_channel_std ...
   , Patterns.Amps_mean_each_burst ,Patterns.AmpRates ]   ...
                          = Get_Electrodes_Rates_at_TimeBins_1pattern_for_Bursts( N , N_responses  , Patterns.bursts , ...
                  Patterns.Poststim_interval_START ,  Patterns.Poststim_interval_END , Patterns.DT_bin  ,Patterns.bursts_amps  ,var );
 
else
 
  fire_bins = floor((Patterns.Poststim_interval_END - Patterns.Poststim_interval_START) / Patterns.DT_bin) ; 
%      fire_bins = round( ( Patterns.Poststim_interval_END )/ ...
%        Patterns.DT_bin );
  
 DT = Patterns.DT_bin ;
 Nb= Patterns.Number_of_Patterns ;
   N = Patterns.N_channels ;
   Patterns.DT_bins_number = fire_bins ;
   
Patterns.Amps_per_channel_per_bin = zeros( fire_bins  , N , Nb );  
Patterns.Spike_Rates_each_channel_zero_values_num  = zeros(  N , 1 );   

Patterns.Spike_Rate_Patterns = zeros( fire_bins  , N , Nb );  
Patterns.Amp_Patterns = zeros( fire_bins  , N , Nb );  

 

   for t = 1 :  Nb
      for ti=1: fire_bins         
        dti = DT*(ti-1) ;
                for ch = 1 : N  
                    if Burst_Data_Ver == 1 
                         si = find( Patterns.bursts( t , ch ,: )> dti+Patterns.Poststim_interval_START & ...
                                Patterns.bursts( t , ch ,: )<= dti+DT +Patterns.Poststim_interval_START ) ;
                    else
                         si = find( Patterns.bursts{ t }{ ch }> dti+Patterns.Poststim_interval_START & ...
                                Patterns.bursts{ t }{ ch }<= dti+DT +Patterns.Poststim_interval_START ) ;
                    end
                    rate =length( si ) ;if ~isfinite(  rate  ) rate= 0 ;end 
%                     chan_firing1_total(t) = rate;
                    
                    if Patterns.Normalize_responses
                        if Patterns.Spike_Rates_each_burst( t ) > 0
                            rate = 100* (rate /  Patterns.Spike_Rates_each_burst( t )) ;
                        else
                            rate = 0 ;
                        end
                    end
                        
%                     Patterns.Spike_Rates_per_channel_per_bin(  ti , ch ,  t  ) = rate ;
                    Patterns.Spike_Rate_Patterns(  ti , ch ,  t  ) = rate ;

                    if isempty(  rate  ) 
                       meanAmp = 0 ;
                    else
                        if Burst_Data_Ver == 1 
                            amps =  Patterns.bursts_amps( t , ch , si );
                            meanAmp  = mean( amps( si )  );  
                        else
                            amps =  Patterns.bursts_amps{ t }{ ch }( si )  ;
                            meanAmp  = mean( amps( si )  ); 
                        end
                    end 
                    if isnan( meanAmp )
                        meanAmp = 0 ;
                    end
%                     chan_amps_total( t ) = meanAmp ;
%                     Patterns.Amps_per_channel_per_bin(  ti , ch ,  t  ) = meanAmp ;  
                    Patterns.Amp_Patterns(  ti , ch ,  t  ) = meanAmp ;  
                end 
      end 
   end 
   
end

     
     
     
     