
% is_pattern_adequate
function [ Patterns_out number_of_Inadequate_Patterns Percent_adequate_patterns number_of_High_Patterns Percent_High_patterns ...
    response_str_THR_higher response_str_THR_lower ]...
            = Erase_Inadequate_Patterns( Patterns , Pattern_filtering_settings  )
 

% ----- CUT small responses------------------------------------------
Nb0 =  Patterns.Number_of_Patterns ;
% EMPTY_SPIKE_TIME=[];  
if ~Pattern_filtering_settings.use_defined_threshold

    response_str_THR_lower = min(Patterns.Spike_Rates_each_burst) + (  Pattern_filtering_settings.Low_Resp_Thr_percent / 100) * ...
                               ( max( Patterns.Spike_Rates_each_burst)-min(Patterns.Spike_Rates_each_burst) ) ;
else    
    response_str_THR_lower = Pattern_filtering_settings.response_str_THR_lower; 
end

if Pattern_filtering_settings.High_Resp_Thr_percent < 100 && Pattern_filtering_settings.use_defined_threshold    
    response_str_THR_higher = Pattern_filtering_settings.response_str_THR_higher ;
else
    response_str_THR_higher = min(Patterns.Spike_Rates_each_burst) + ( Pattern_filtering_settings.High_Resp_Thr_percent / 100) * ...
                               ( max( Patterns.Spike_Rates_each_burst)-min(Patterns.Spike_Rates_each_burst) ) ;
end

if Pattern_filtering_settings.use_defined_High_values_for_thres   
    response_str_THR_higher = min(Patterns.Spike_Rates_each_burst) + ( Pattern_filtering_settings.High_Resp_Thr_percent / 100) * ...
                               ( Pattern_filtering_settings.Highes_value_for_high_thres -min(Patterns.Spike_Rates_each_burst) ) ;  
end


        % if weak responses 
        weak_responses_index = find( Patterns.Spike_Rates_each_burst(:) < response_str_THR_lower   );
    
        % if high responses  
        high_responses_index = find( Patterns.Spike_Rates_each_burst(:) > response_str_THR_higher   );
        not_high_responses_index = find( Patterns.Spike_Rates_each_burst(:) <= response_str_THR_higher   );
    
    Inadequate_Patterns = [ weak_responses_index'  high_responses_index' ];    
    % Inadequate = low + high
    number_of_Inadequate_Patterns = length( Inadequate_Patterns ) ;
    number_of_High_Patterns = length( high_responses_index ) ;
    number_of_Low_Patterns = length( weak_responses_index ) ;
   
Nb = length( Inadequate_Patterns ); 

%        Patterns.burst_activation( weak_responses_index , :  ) = [] ;
%        Patterns.bursts( weak_responses_index , : , :  ) = [] ;
%        Patterns.burst_activation( weak_responses_index , :  ) = [] ;
%        Patterns.bursts( weak_responses_index , : , :  ) = [] ;
%        Patterns.Spike_Rates(  weak_responses_index , : ) = [] ;
%        Patterns.artefacts( weak_responses_index ) = [] ;   
%        Patterns.Number_of_Patterns  = Nb0 - number_of_Inadequate_Patterns ;
%        Patterns.Spike_Rates_each_burst(  weak_responses_index ) = [] ;

    Patterns_out = Erase_Some_Patterns( Patterns  , Inadequate_Patterns );
    Patterns_out.Patterns_high = Erase_Some_Patterns( Patterns  , not_high_responses_index );
       
%  
%       Patterns_out = Patterns ;
      
% [ Patterns_out  ] = Erase_Some_Channels_inPatterns( Patterns ,  weak_responses_index );
% Tested in PoestStim Responses structs 
% After erase it's better to recal all stat. characterestics - ...
      
      Percent_adequate_patterns = 100 *((Nb0 - number_of_Inadequate_Patterns)/Nb0) ;
      Patterns_out.Percent_adequate_patterns = Percent_adequate_patterns ;
      Patterns_out.Number_of_Adequate_Patterns  = Patterns.Number_of_Patterns- length( number_of_Inadequate_Patterns );

      Percent_low_patterns = 100 *((Nb0 - number_of_Low_Patterns )/ Nb0 ) ;
      Patterns_out.Percent_Low_patterns = Percent_low_patterns ;
      Patterns_out.Number_of_Low_Patterns  = number_of_Low_Patterns ;            
      
      Percent_High_patterns = 100 *((Nb0 - number_of_High_Patterns )/ Nb0 ) ;
      Patterns_out.Percent_high_patterns = Percent_High_patterns ;
      Patterns_out.Number_of_High_Patterns  = number_of_High_Patterns ;      
      
%       m2.Spikes_per_burst
%     response_str_THR = (Spikes_per_burst_cut_Threshold_precent /100) * max( m2.Spikes_per_burst );
%      weak_responses_index = find( m2.Spikes_per_burst(:) <= response_str_THR );
%      Nb2 = Nb2 - length(weak_responses_index);
%       m2.burst_activation( weak_responses_index , :  ) = [] ;
%       m2.bursts( weak_responses_index , : , :  ) = [] ;
%-----------------------------------------------------------------    