


                            %-- Filter "bad" response ratio 
                            function data_vec = Data_erase_Bad_values( data_vec , data_i , Global_flags )  
                            
%              Channel_difference_mean_ratio_only_active  -  1 ;                 
%              Channel_difference_mean_only_active  -  2    ;
%              Channel_difference_std_ratio_only_active - 3 ;
%              Channel_difference_std_only_active - 4  ;
%              Channels_overlap_only_active - 5 ;
%              Channel_difference_mean_ratio - 6   ;
%              Channel_difference_mean  - 7 ;
%              Channel_difference_std_ratio - 8 ;
%              Channel_difference_std - 9 ;
%              Channels_overlap - 10  ;
%              Channel_is_active - 11 ;                     
                            
                            
                            SR_ratio_limit = 300 ; 
                            
                            if data_i == 1 || data_i == 3 || data_i == 6 || data_i == 8                                
                                data_vec( abs( data_vec ) > Global_flags.Max_SR_ratio )= [];
%                                 data_vec( data_vec == 0 ) = [];
                                data_vec( isinf( data_vec ) ) = [] ;
                            end