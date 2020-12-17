    % Erase_defined_bursts ( index in Burst_to_erase)
    Spike_Rates( Burst_to_erase , :) = [] ;
    Nb = Nb - length( Burst_to_erase );
    
    Firing_Rates_each_burst( Burst_to_erase ) =[];
    Spike_Rates_each_burst( Burst_to_erase ) =[];
    
    burst_start( Burst_to_erase ) =[];
%     Spike_Rates_each_burst( Burst_to_erase ) =[];
    BurstDurations( Burst_to_erase ) =[];
    burst_durations( Burst_to_erase ) =[];
    burst_end( Burst_to_erase ) = [] ;
    burst_max( Burst_to_erase ) = [] ;
   if Burst_Data_Ver == 1
                        bursts_absolute( Burst_to_erase , : , : ) = []; 
                        bursts( Burst_to_erase , : , : ) = []; 
                        bursts_amps( Burst_to_erase , : , : ) = []; 
   else        
                        bursts_cell_absolute_Nb_N( Burst_to_erase , :   ) = []; 
                        bursts_cell_Nb_N( Burst_to_erase , :   ) = []; 
                        bursts_cell_amps_Nb_N( Burst_to_erase , :   ) = []; 
   end
                    
                    
     
     
    burst_activation( Burst_to_erase ,  : ) = [];  
    burst_activation_amps( Burst_to_erase ,  : ) = [];  
    burst_activation_normalized( Burst_to_erase ,  : ) = []; 
    % Spikes_per_electrodeNb( Burst_to_erase ,  : ) = [];  
%     index_max( Burst_to_erase  ) = [];  
%     index( Burst_to_erase  ) = [];  
%     Durations( Burst_to_erase  ) = [];   
    
   
    Firing_Rates( Burst_to_erase , :) = [] ;
    
%     bursts_cell_absolute_Nb_N( Burst_to_erase , : , : ) = []; 
%     bursts_cell_Nb_N( Burst_to_erase , : , : ) = []; 
%     bursts_cell_amps_Nb_N( Burst_to_erase , : , : ) = []; 
    %-----------------------------
    
    
       for ch = 1 : N  
           Spike_Rates_each_channel_mean( ch )  = mean( Spike_Rates(    :, ch ));
           Spike_Rates_each_channel_std( ch )  = std( Spike_Rates(   :, ch ));
           Firing_Rates_each_channel_mean( ch )  = mean( Firing_Rates( : , ch ));
           Firing_Rates_each_channel_std( ch )  = std( Firing_Rates( : , ch )); 
       end
       
       
       
       
       