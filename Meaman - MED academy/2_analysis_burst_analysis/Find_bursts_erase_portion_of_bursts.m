
% Find_bursts_erase_portion_of_bursts

BurstDurations_mean = mea_Mean_defined( BurstDurations  ) ;
% BurstDurations_new = Search_Params.Burst_delete_spikes_burst_tail * BurstDurations_mean ;
BurstDurations_new = Search_Params.Burst_delete_spikes_burst_tail  ;


    for t = 1 : Nb 
          
        BurstDurations( t ) = BurstDurations_new ; 
        burst_end( t ) = burst_start( t ) + BurstDurations_new ; 

        for ch = 1 : N            
             
            
            
                    if Burst_Data_Ver == 1
%                         bursts_absolute( t , ch , 1:length(index_spikes_in_burst) ) =   index_r_chan_times{ch}( index_spikes_in_burst ) ; 
%                         bursts( t , ch , 1:length(index_spikes_in_burst) ) = index_r_chan_times{ch}( index_spikes_in_burst(1) ) - burst_start( t ) ;
%                         bursts_amps( t , ch , 1:length(index_spikes_in_burst) ) =    index_r_chan_amps{ch}( index_spikes_in_burst(1))    ;
                    else        
 
 
                        spikes_in_burst = bursts_cell_Nb_N{ t }{ ch} ;
                        new_index = find( spikes_in_burst < BurstDurations_new ) ;
                        spikes_in_burst = spikes_in_burst( new_index ) ;
                        bursts_cell_Nb_N{ t }{ ch}  = spikes_in_burst ;
                        
                        spikes_in_burst  = bursts_cell_absolute_Nb_N{ t }{ ch} ;
                        bursts_cell_absolute_Nb_N{ t }{ ch} = spikes_in_burst( new_index ) ;
                        
                        spikes_in_burst  =  bursts_cell_amps_Nb_N{ t }{ ch} ;
                        bursts_cell_amps_Nb_N{ t }{ ch} = spikes_in_burst( new_index ) ;                        
                         
                    end
  
            
            spn = length( new_index ) ;
            if spn  <= MAX_SPIKES_PER_CHANNEL_AT_BURST
                Firing_Rates( t , ch ) = length( new_index ) / burst_durations(t) ;
                Spike_Rates( t , ch )  = length( new_index ) ; 
            end
        end  
    end
     
     
    Spike_Rates_each_burst  = zeros( Nb ,1);    
    Firing_Rates_each_burst  = zeros( Nb ,1); 
       for i=1:  Nb 
           Spike_Rates_each_burst(i) = sum( Spike_Rates( i , :)); 
           Firing_Rates_each_burst(i) = sum( Firing_Rates( i , :)); 
       end 
    
   
     %+++++++ SPIKE RATE statistics +++++++++++++++++
    Spike_Rates_each_channel_mean  = zeros(  N , 1 );
    Spike_Rates_each_channel_std  = zeros(  N , 1 );
    Firing_Rates_each_channel_mean  = zeros(  N , 1 );
    Firing_Rates_each_channel_std  = zeros(  N , 1 ); 
    Total_spikes_each_channel   = zeros(  N , 1 );
       for ch = 1 : N  
           Spike_Rates_each_channel_mean( ch )  = mea_Mean_defined( Spike_Rates(    :, ch ));
           Spike_Rates_each_channel_std( ch )  = mea_Std_defined( Spike_Rates(   :, ch ));
           Firing_Rates_each_channel_mean( ch )  = mea_Mean_defined( Firing_Rates( : , ch ));
           Firing_Rates_each_channel_std( ch )  = mea_Std_defined( Firing_Rates( : , ch )); 
           Total_spikes_each_channel( ch ) = sum( Spike_Rates( : , ch ) );           
       end 









