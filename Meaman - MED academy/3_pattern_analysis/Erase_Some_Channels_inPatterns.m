function  [ Patterns  ] = Erase_Some_Channels_inPatterns( Patterns ,  CHANNELS )
% Tested in PoestStim Responses structs 
% After erase it's better to recal all stat. characterestics - 
 Erase_element = 0;
 empt = [] ;
%     num_erased_patterns = length( CHANNELS )  ;
%      
%       Patterns.burst_activation( : , CHANNELS   ) = [] ;
%       Patterns.bursts( : , CHANNELS   , :  ) = [] ;
%       Patterns.Spike_Rates( : , CHANNELS  ) = [] ; 
      
      Patterns.burst_activation( : , CHANNELS   ) = 0 ;
%       
%        if iscell( Patterns.bursts )
%         s = size( Patterns.bursts{1});    
%         empt = cell( s(1),1);
%         emptyIndex = cellfun(@isempty,empt);       %# Find indices of empty cells
%         empt(emptyIndex) = { Erase_element };                    %# Fill empty cells with 0 
%         for i=1:length(responses_index )
%             Patterns.bursts{ responses_index(i) }   = empt ;
%             Patterns.bursts_absolute{ responses_index(i) }  = empt ; 
%             Patterns.bursts_amps{ responses_index(i) }  = empt ;   
%         end    
%       else
%         Patterns.bursts( responses_index , : , :  ) = Erase_element ;
%         Patterns.bursts_absolute( responses_index , :  ,: ) = Erase_element ; 
%         Patterns.bursts_amps( responses_index , : , :  ) = Erase_element ;    
%       end 

      
       if iscell( Patterns.bursts )
%            Patterns.bursts( : , CHANNELS )   = [] ;
%             Patterns.bursts_absolute( : , CHANNELS )  = [] ; 
%             Patterns.bursts_amps( : , CHANNELS )  = [] ;   
            for i = 1 : Patterns.Number_of_Patterns
                for ch = 1 : length( CHANNELS )
                    ch_i = CHANNELS( ch ) ;
                Patterns.bursts{ i }{ ch_i } = [] ;
              Patterns.bursts_absolute{ i }{ ch_i }  = [] ; 
            Patterns.bursts_amps{ i }{ ch_i }   = [] ;   
                end
                
            end
 
             
      else
        Patterns.bursts( : , CHANNELS   , :  ) = Erase_element ;
        Patterns.bursts_absolute( : , CHANNELS   , : ) = Erase_element ; 
        Patterns.bursts_amps( : , CHANNELS   , : ) = Erase_element ;    
       end 
      
      
%       Patterns.bursts( : , CHANNELS   , :  ) = 0 ;
      Patterns.Spike_Rates( : , CHANNELS  ) = 0 ; 
      
  if isfield( Patterns  , 'Firing_Rates' )
      Patterns.Firing_Rates( : , CHANNELS  ) = 0 ; 
  end
  
   if isfield( Patterns  , 'burst_max_rate_delay_ms_mean' )
      Patterns.burst_max_rate_delay_ms_mean(  CHANNELS  ) = 0 ; 
  end
  if isfield( Patterns  , 'burst_activation_3_smooth_1ms_mean' )
      Patterns.burst_activation_3_smooth_1ms_mean(  CHANNELS  ) = 0 ; 
  end  
  
    if isfield( Patterns  , 'burst_activation_3_smooth_1ms_mean' )
      Patterns.burst_activation_3_smooth_1ms_mean( CHANNELS  ) = 0 ; 
  end  
  
  
      s=size( Patterns.Spike_Rates ) ;
      Nb = s(1);
      for i=1:  Nb 
           Patterns.Spike_Rates_each_burst(i) = sum( Patterns.Spike_Rates( i , :)); 
             if isfield( Patterns  , 'Firing_Rates' )
                  Patterns.Firing_Rates_each_burst(i) = sum( Patterns.Firing_Rates( i , :)); 
             end
      end 
      
      s = size( Patterns.Spike_Rates ) ;
      Patterns.N_channels = s(2);
      
        Channels_active = ones( 1 , Patterns.N_channels ) ; 
        Channels_active( CHANNELS ) = 0 ;
        Patterns.Channels_active = Channels_active ;  
%         Patterns2.Channels_active = Channels_active ;
      
       Patterns.Spike_Rates_each_channel_mean( CHANNELS )  = 0;
       Patterns.Spike_Rates_each_channel_std( CHANNELS )  = 0;
       Patterns.Spike_Rates_each_channel_zero_values_num( CHANNELS ) = 0 ;  
       
       if isfield( Patterns  , 'Spike_Rate_Signature_1ms_smooth' )
            Patterns.Spike_Rate_Signature_1ms_smooth( : , CHANNELS  ) = 0 ; 
       end
        N = length( Patterns.Spike_Rates_each_channel_mean ) ;
        
      if isfield( Patterns  , 'Spike_Rate_1ms_Max_corr_delay' ) 
          for i = 1 : N
                for j = 1 : N
                    fi = find( i == CHANNELS ) ;
                    fj = find( j == CHANNELS ) ;
                    erase_channel = ~isempty( fi ) ||  ~isempty( fj ) ;
                    if erase_channel
                     Patterns.Spike_Rate_1ms_Max_corr_delay(    ...
                          i , j ) = 0 ;
                    end 
                end
          end  
      end
      
      if isfield( Patterns  , 'Spike_Rate_1ms_smooth_Max_corr_delay' ) 
          for i = 1 : N
                for j = 1 : N
                    fi = find( i == CHANNELS ) ;
                    fj = find( j == CHANNELS ) ;
                    erase_channel = ~isempty( fi ) ||  ~isempty( fj ) ;
                    if erase_channel
                     Patterns.Spike_Rate_1ms_smooth_Max_corr_delay(    ...
                          i , j ) = 0 ;
                    end 
                end
          end  
      end      
      
      
       if isfield( Patterns  , 'Spike_Rates_Signature' )
            Patterns.Spike_Rates_Signature( : , CHANNELS  ) = 0 ; 
       end
       
        if isfield( Patterns  , 'burst_activation_mean' )
            Patterns.burst_activation_mean( CHANNELS  ) = 0 ; 
        end
       
          if isfield( Patterns  , 'burst_activation_2_mean' )
            Patterns.burst_activation_2_mean(  CHANNELS  ) = 0 ; 
          end
       
         if isfield( Patterns  , 'MNDB_Compare_2sets_matrix_diff' )
            Patterns.MNDB_Compare_2sets_matrix_diff(   CHANNELS  ) = 0 ; 
         end
       
                        
       
       
       
       
       
       
       
       