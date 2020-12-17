% Patterns_get_TimeBin_Total_Spikes
%  Spike_Rates_per_channel_per_bin - > TimeBin_Total_Spikes
% Amps_per_channel_per_bin -> TimeBin_Total_Amps

  fire_bins = floor((Patterns.Poststim_interval_END - Patterns.Poststim_interval_START) / Patterns.DT_bin) ; 
 DT = Patterns.DT_bin ;
 Nb= Patterns.Number_of_Patterns ;
   N = Patterns.N_channels ;

Patterns.TimeBin_Total_Spikes = zeros( Nb , fire_bins ); 
Patterns.TimeBin_Total_Amps = zeros( Nb , fire_bins ); 
    
     for ti=1:fire_bins
      for R = 1 : Nb      
%            Patterns.TimeBin_Total_Spikes( R , ti )= sum( Patterns.Spike_Rates_per_channel_per_bin( ti , : ,  R  )) ; 
         Patterns.TimeBin_Total_Spikes( R , ti )= sum( Patterns.Amp_Patterns( ti , : ,  R  )) ; 
      end    
        for R = 1 : Nb     
           
%           Amps = Patterns.Amps_per_channel_per_bin( ti , : ,  R  ) ;
            Amps = Patterns.Amp_Patterns( ti , : ,  R  ) ;          
          Amps(Amps>=0) =[];
        	if isempty( Amps )
                  Amps=0;
             end
            Patterns.TimeBin_Total_Amps( R , ti )= mean( Amps ) ; 
        end 
     end
     
      
       
 