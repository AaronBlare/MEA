function   Patterns_out  = Erase_Some_Patterns( Patterns  , patterns_index )


       Patterns.burst_activation( patterns_index , :  ) = [] ;
       Patterns.bursts( patterns_index , : , :  ) = [] ;
       Patterns.Spike_Rates(  patterns_index , : ) = [] ;
       Patterns.artefacts( patterns_index ) = [] ;   
       Patterns.Number_of_Patterns  = Patterns.Number_of_Patterns- length(patterns_index);

       Patterns.Spike_Rates_each_burst(  patterns_index ) = [] ;
       Patterns.Spike_Rates_per_channel_per_bin(  : , : ,  patterns_index  )  = []; 
       Patterns.Amps_per_channel_per_bin(  : , : ,  patterns_index  )  = [] ; 
        
%        Patterns.Spike_Rates_each_channel_zero_values_num = zeros( Patterns.N_channels , 1 ) ;
%     for ch = 1 : Patterns.N_channels  
%        Patterns.Spike_Rates_each_channel_mean( ch )  = mean( Patterns.Spike_Rates(  : , ch ));
%        Patterns.Spike_Rates_each_channel_std( ch )  = std( Patterns.Spike_Rates(  : , ch  ));
%        Patterns.Spike_Rates_each_channel_zero_values_num( ch ) = length( find( Patterns.Spike_Rates(  : , ch ) ==0) );  
%     end
    
    Patterns_out = Patterns ;