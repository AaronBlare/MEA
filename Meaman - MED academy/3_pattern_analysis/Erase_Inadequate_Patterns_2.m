

function [ Patterns number_of_Inadequate_Patterns Percent_adequate_patterns  ]...
            = Erase_Inadequate_Patterns_2( Patterns   )

         
                         %----- Patterns_Delete_Inadequate_responses
                            % TimeBin_Total_Spikes -> delete_responses_index
                            EraseIf_tru_otherwise_put_Zero = true ;
                            Patterns_Delete_Inadequate_responses
     
                            
                             responses_index = delete_responses_index ;
                             
                             number_of_Inadequate_Patterns = length(responses_index)
                             Percent_adequate_patterns = 100*(( Patterns.Number_of_Patterns - number_of_Inadequate_Patterns) /...
                             Patterns.Number_of_Patterns );
                             
                             Patterns.Number_of_Inadequate_Patterns = number_of_Inadequate_Patterns;
                             Patterns.Number_of_Inadequate_Patterns_percent = 100*(number_of_Inadequate_Patterns / Patterns.Number_of_Patterns) ;
                             Patterns.Number_of_Adequate_Patterns =  ( Patterns.Number_of_Patterns - number_of_Inadequate_Patterns) ;
                             Patterns.Number_of_Adequate_Patterns_percent = 100 * ( Patterns.Number_of_Patterns - number_of_Inadequate_Patterns)/...
                             Patterns.Number_of_Patterns ;
                          
                         
 
                                 % responses_index EraseIf_tru_otherwise_put_Zero=true/false shoulkd be defined
                                 % before call
                             Stimulus_responses_Delete_responses
                             
                             
                         Patterns_Check_if_responses_Adequate
                          % TimeBin_Total_Spikes -> if in average the PSTH is not falling down from
                          % the beginning then all responses are bad and erase them
                          % Patterns.Poststim_interval_END should be longer than 250 (300)
                          % Output: All_responses_Bad = true ,
                          % delete_responses_index
                          
                          responses_index = delete_responses_index ;
                          EraseIf_tru_otherwise_put_Zero = false ;
                          if All_responses_Bad
                              Patterns.No_patterns = true;
                                Stimulus_responses_Delete_responses   
                          else
                              Patterns.No_patterns = false ;
                          end
                             
                             
                             