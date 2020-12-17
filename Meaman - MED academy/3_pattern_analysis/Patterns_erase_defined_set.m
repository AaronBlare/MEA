

function Patterns = Patterns_erase_defined_set( Patterns ,responses_index )

        if  isfield( Patterns , 'artefacts')
         Patterns.artefacts(   responses_index ) = [] ;  
        end
 
         Patterns.Spike_Rates(  responses_index , : ) = [] ;

        Patterns.Spike_Rates_each_burst(  responses_index ) = [] ;    
         
        Patterns.burst_activation( responses_index , :  ) = [] ;
        Patterns.burst_activation_amps( responses_index , :  ) = [] ;  
        
        if  isfield( Patterns , 'burst_start')
            Patterns.burst_start( responses_index  ) = [] ;
        end
        
        if  isfield( Patterns , 'burst_activation_absolute')
            Patterns.burst_activation_absolute( responses_index , :  ) = [] ;
        end
        
        if  isfield( Patterns , 'BurstDurations')
            Patterns.BurstDurations( responses_index  ) = [] ;
        end
        
        if  isfield( Patterns , 'burst_max_rate_delay_ms')
            Patterns.burst_max_rate_delay_ms( responses_index  ) = [] ;
        end
        
        if  isfield( Patterns , 'burst_activation_2')
            Patterns.burst_activation_2( responses_index , :  ) = [] ;
        end
        
        if  isfield( Patterns , 'burst_activation_normalized')
            Patterns.burst_activation_normalized( responses_index , :  ) = [] ;
        end
        
        
        if iscell( Patterns.bursts ) 
            if  length( Patterns.bursts ) > 0
                s = size( Patterns.bursts{1});    
                empt = cell( s(1),1);
        %         for i=1:length(responses_index )
        %             Patterns.bursts{ responses_index(i) }   = empt ;
        %             Patterns.bursts_absolute{ responses_index(i) }  = empt ; 
        %             Patterns.bursts_amps{ responses_index(i) }  = empt ;   
        %         end
                    Patterns.bursts( responses_index  )   = [] ;
                    Patterns.bursts_absolute( responses_index  )   = [] ; 
                    Patterns.bursts_amps( responses_index  )   = [] ;  
            end
        else
        Patterns.bursts( responses_index , : , :  ) = [] ;
        Patterns.bursts_absolute( responses_index , :  ,: ) = [] ; 
        Patterns.bursts_amps( responses_index , : , :  ) = [] ;    
        end
      


        Patterns.TimeBin_Total_Spikes( responses_index , : )= [] ; 
        if  isfield( Patterns , 'TimeBin_Total_Amps')
            Patterns.TimeBin_Total_Amps( responses_index , : )= [] ;
        end
          
        Patterns.Amp_Patterns( :  , : , responses_index )= [] ;
        Patterns.Spike_Rate_Patterns( :  , : , responses_index )= [] ;
        
        Patterns.Number_of_Patterns = Patterns.Number_of_Patterns - length( responses_index ) ;
        
    if  isfield( Patterns , 'burst_activation_absolute')  
        if  isfield( Patterns , 'burst_start')  
            Patterns.burst_start =  zeros( Patterns.Number_of_Patterns    ,1);   
                Patterns.burst_start_Tact_mean =  zeros( Patterns.Number_of_Patterns    ,1); 
        for t = 1 :  Patterns.Number_of_Patterns  
          
                  
                    % find response burst start
                 Tact_all =  Patterns.burst_activation_absolute( t , : ) ;
                 Tact_all( Tact_all==0) = [] ;
                 if isempty( Tact_all )
                     Tact_all = 0 ;
                     Tact_mean= 0 ;
                 end
                 Tact_min = min( Tact_all ) ;
                 Tact_mean = mean( Tact_all ) ;
                   Patterns.burst_start( t ) =  Tact_min ;    
                   Patterns.burst_start_Tact_mean( t ) =  Tact_mean ;    
            end      
        end
    end
         
                 
        
        
        
        