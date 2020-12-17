%     Stimulus_responses_Delete_responses
    % responses_index shoulkd be defined before call
    
    if length(responses_index)>0
    if EraseIf_tru_otherwise_put_Zero
      Erase_element = []; 

            Patterns = Patterns_erase_defined_set( Patterns ,responses_index );

     else
      Erase_element = 0;  


         Patterns.artefacts(   responses_index ) = [] ;  
 
         Patterns.Spike_Rates(  responses_index , : ) = [] ;

         Patterns.Spike_Rates_each_burst(  responses_index ) = [] ;    
         
        Patterns.burst_activation( responses_index , :  ) = [] ;
        Patterns.burst_activation_amps( responses_index , :  ) = [] ;  
        Patterns.burst_activation_absolute( responses_index , :  ) = [] ;
        
%         if iscell( Patterns.bursts )
%         s = size( Patterns.bursts{1});    
%         empt = cell( s(1),1);
%         emptyIndex = cellfun(@isempty,empt);       %# Find indices of empty cells
%         empt(emptyIndex) = { Erase_element };                    %# Fill empty cells with 0 
%         for i=1:length(responses_index )
%             Patterns.bursts{ responses_index(i) }   = empt ;
%             Patterns.bursts_absolute{ responses_index(i) }  = empt ; 
%             Patterns.bursts_amps{ responses_index(i) }  = empt ;   
%         end    
%         else
%         Patterns.bursts( responses_index , : , :  ) = Erase_element ;
%         Patterns.bursts_absolute( responses_index , :  ,: ) = Erase_element ; 
%         Patterns.bursts_amps( responses_index , : , :  ) = Erase_element ;    
%         end  
%         
        if iscell( Patterns.bursts )
        s = size( Patterns.bursts{1});    
        empt = cell( s(1),1);
            Patterns.bursts( responses_index  )   = [] ;
            Patterns.bursts_absolute( responses_index  )   = [] ; 
            Patterns.bursts_amps( responses_index  )   = [] ;  
        else
        Patterns.bursts( responses_index , : , :  ) = [] ;
        Patterns.bursts_absolute( responses_index , :  ,: ) = [] ; 
        Patterns.bursts_amps( responses_index , : , :  ) = [] ;    
        end
        

        Patterns.burst_activation_amps( responses_index , :  ) = Erase_element ;  

        Patterns.TimeBin_Total_Spikes( responses_index , : )= Erase_element ;[] ;
        Patterns.TimeBin_Total_Amps( responses_index , : )= Erase_element ;
        
        Patterns.Amp_Patterns( :  , : , responses_index )= [] ;
        Patterns.Spike_Rate_Patterns( :  , : , responses_index )= [] ;
%         Patterns.Amps_per_channel_per_bin( :  , : , responses_index )= Erase_element ;
%         Patterns.Spike_Rates_per_channel_per_bin( :  , : , responses_index )= Erase_element ;
        Patterns.Number_of_Patterns = Patterns.Number_of_Patterns - length( responses_index ) ;
    end    
    
    end