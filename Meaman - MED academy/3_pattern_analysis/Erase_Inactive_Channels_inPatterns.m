function  [ Patterns1  , Patterns2 , total_number_of_active_channels  ,CHANNELS_ERASED ] = ...
        Erase_Inactive_Channels_inPatterns( Patterns1 , Patterns2 ,   STIM_RESPONSE_BOTH_INPUTS , PRECENT_CHAN_TO_ERASE )
% function erases  bursts burst_activation Spike_Rates if some channels ...
% of Spike_Rates has zeros more than STIM_RESPONSE_BOTH_INPUTS for each of
% both input Patterns.
% if PRECENT_CHAN_TO_ERASE > 0 then function erases random channels
  
total_number_of_active_channels=0;
CHANNELS_ERASED = [];  
N =   Patterns1.N_channels   ;

% ERASE_RANDOM_CHANNELS = false ;
% ERASE_RANDOM_CHANNELS = true ;
PRECENT_CHAN_TO_ERASE = 0 ;
if PRECENT_CHAN_TO_ERASE > 0 
N_channels_erase = floor( (PRECENT_CHAN_TO_ERASE /100 )  * N  );

CHANNELS_ERASED= floor( (N - 1)*rand( N_channels_erase ,1) + 1);
% CHABBELS_ERASED=CHABBELS_ERASED';
CHANNELS_ERASED 
          Patterns1.bursts( : , CHANNELS_ERASED , : ) = 0 ;        
          Patterns2.bursts( : , CHANNELS_ERASED , :) = 0 ;
          Patterns1.burst_activation( : , CHANNELS_ERASED  ) = 0 ;        
          Patterns2.burst_activation( : , CHANNELS_ERASED  ) = 0 ;
          Patterns1.Spike_Rates( : , CHANNELS_ERASED ) = 0 ;        
          Patterns2.Spike_Rates( : , CHANNELS_ERASED  ) = 0 ;         
end


CHANNELS_ERASED = [];
 
%  RS_values1 = Get_RS_Values(  N, Data1, Start_t,Pattern_length_ms, [], 100000 ,   Nb ,true);
%  RS_values2 = Get_RS_Values(  N,  Data2,Start_t,Pattern_length_ms, [] , 100000 , Nb2 ,true) ;
non_zero_responses_in_channel1 = zeros( N , 1 ) ;
non_zero_responses_in_channel2 = zeros( N , 1 ) ;
Zero_response_index_1 = []; 
Zero_response_index_2 = [];
 for ch = 1 : N 
     for t = 1 : Patterns1.Number_of_Patterns        
          non_zero_responses_in_channel1( ch ) = non_zero_responses_in_channel1(ch) + ...
          H( Patterns1.Spike_Rates( t , ch ) ) ;     
     end
     
     for t = 1 : Patterns2.Number_of_Patterns        
            non_zero_responses_in_channel2( ch ) = non_zero_responses_in_channel2(ch) + ...
          H( Patterns2.Spike_Rates( t , ch ) ) ;      
     end     
 end
% Fraction_of_nonzero_responses1 = non_zero_responses_in_channel1 / Patterns1.Number_of_Patterns  ;
% Fraction_of_nonzero_responses2 = non_zero_responses_in_channel2 / Patterns2.Number_of_Patterns  ;

% Patterns_out = Erase_Some_Patterns( Patterns , weak_responses_index );

Fraction_of_nonzero_responses1 = non_zero_responses_in_channel1 / Patterns1.NUMBER_OF_STIMULS  ;
Fraction_of_nonzero_responses2 = non_zero_responses_in_channel2 / Patterns2.NUMBER_OF_STIMULS  ;


 for ch = 1 : N 
    if  Fraction_of_nonzero_responses1(ch) > STIM_RESPONSE_BOTH_INPUTS && ...
            Fraction_of_nonzero_responses2(ch) > STIM_RESPONSE_BOTH_INPUTS 
       total_number_of_active_channels = total_number_of_active_channels + 1 ;
    else
        CHANNELS_ERASED=[CHANNELS_ERASED ch ]; 
    end
 end
 
 [ Patterns1  ] = Erase_Some_Channels_inPatterns( Patterns1 ,  CHANNELS_ERASED );
  [ Patterns2  ] = Erase_Some_Channels_inPatterns( Patterns2 ,  CHANNELS_ERASED );
%           Patterns1.bursts( : , CHANNELS_ERASED , : ) = 0 ;        
%           Patterns2.bursts( : , CHANNELS_ERASED , :) = 0 ;
%           Patterns1.burst_activation( : , CHANNELS_ERASED  ) = 0 ;        
%           Patterns2.burst_activation( : , CHANNELS_ERASED  ) = 0 ;
%           Patterns1.Spike_Rates( : , CHANNELS_ERASED ) = 0 ;        
%           Patterns2.Spike_Rates( : , CHANNELS_ERASED  ) = 0 ;      
 
  
          
  CHANNELS_ERASED
%   Data1_new = Data1;
%     Data2_new = Data2;