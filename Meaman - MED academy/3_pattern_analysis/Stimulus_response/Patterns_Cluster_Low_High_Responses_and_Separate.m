%             Patterns_Cluster_Low_High_Responses_and_Separate 
            %
            % finds Low & High patterns (Patterns_get_High_Low_responses)
            % and assigns 'Low' to Patterns and 'High' to
            % Patterns_out.Patterns_high
            
            
            %--- Patterns_get_High_Low_responses ----
            % Patterns.Spike_Rates_each_burst -> High_responses_index ,
            % Low_responses_index ...
            % flags.SHOW_FIGURES_low_hi_responses should be defined before
            % Output :
            %                 Patterns.HiLo_High_responses_index  
            %                 Patterns.HiLo_Low_responses_index  
            %                 Patterns.HiLo_High_Responses_number  
            %                 Patterns.HiLo_Low_Responses_number  
            %                 Patterns.HiLo_High_Responses_TSR_Threshold 
            %                 Patterns.HiLo_High_Responses_Percent 
            %                 Patterns.HiLo_Davies_Bouldin_TSR_Clustering_index  
            %                 Patterns.HiLo_squared_sum_of_errors_CLUSTERING_Spike_Rates_each_burst  
            Patterns_get_High_Low_responses
            
            Patterns_all = Patterns ;
            
            
%                 Patterns  = Erase_Some_Patterns( Patterns_all  , Patterns_all.HiLo_High_responses_index    );
%                 Patterns.Patterns_high = Erase_Some_Patterns( Patterns_all  , Patterns_all.HiLo_Low_responses_index   );
                Patterns.Patterns_high = Patterns_erase_defined_set( Patterns_all ,Patterns_all.HiLo_Low_responses_index    );  
                Patterns.Patterns_high.Number_of_Patterns = length( Patterns_all.HiLo_High_responses_index  );
            if Patterns.HiLo_High_responses_present    
                Patterns.Patterns_low = Patterns_erase_defined_set( Patterns_all ,Patterns_all.HiLo_High_responses_index    );
                Patterns.Patterns_low.Number_of_Patterns = length( Patterns_all.HiLo_Low_responses_index  );
            else
                Patterns.Patterns_low = Patterns_all  ; 
            end
            
%             if Global_flags.Filter_small_responses
%                 Patterns.Patterns_low = Patterns_erase_defined_set( Patterns_all , 1: Patterns_all.Number_of_Patterns    ); 
%                 Patterns.HiLo_Low_responses_index = [];
%                 Patterns.HiLo_Low_Responses_number = 0 ;
%             end
            
            if Global_flags.Leave_only_high_patterns
                if Patterns.HiLo_High_responses_present
                    Patterns.Patterns_high.Patterns_low = Patterns.Patterns_low ; 
                    Patterns = Patterns.Patterns_high  ;
                end
            end
            
            if Global_flags.Leave_only_low_patterns 
                if Patterns.HiLo_Low_responses_present
                    Patterns.Patterns_low.Patterns_high = Patterns.Patterns_high ; 
                    Patterns = Patterns.Patterns_low  ;
                end
            end
            
            
            
            
            
            