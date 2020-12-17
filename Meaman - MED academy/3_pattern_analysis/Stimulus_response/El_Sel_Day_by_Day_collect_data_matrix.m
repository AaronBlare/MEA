

% El_Sel_Day_by_Day_collect_data_matrix
% 
%  filen
% exp_num_file_n
%  ch
 
 % if enough_Low_responses then collect that data
%                      if HiLo_Patterns1_2_enough_Low_responses 
                EXP( exp_num_file_n ).ExpStage( Pair_i ).Channel( ch ).TOTAL_RATE(1).Data_included = HiLo_Patterns1_2_enough_Low_responses ;
                     if HiLo_Patterns1_2_enough_Low_responses
                         a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE.Channel_difference_mean_ratio_only_active ;
                         data_i = 1 ;                 
                         TOTAL_RATE(1).DATA(data_i).data_vector =[TOTAL_RATE(1).DATA(data_i).data_vector  ; a ];
                         EXP( exp_num_file_n ).ExpStage( Pair_i ).Channel( ch ).TOTAL_RATE(1).DATA(data_i).data_vector = a ;

                          a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE.Channel_difference_mean_only_active ;
                          data_i = data_i +1 ;                 
                         TOTAL_RATE(1).DATA(data_i).data_vector =[TOTAL_RATE(1).DATA(data_i).data_vector  ; a ];
                         EXP( exp_num_file_n ).ExpStage( Pair_i ).Channel( ch ).TOTAL_RATE(1).DATA(data_i).data_vector = a ;
                         
                         a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE.Channel_difference_std_ratio_only_active' ;
                         data_i = data_i +1 ;                 
                         TOTAL_RATE(1).DATA(data_i).data_vector =[TOTAL_RATE(1).DATA(data_i).data_vector  ; a ];
                         EXP( exp_num_file_n ).ExpStage( Pair_i ).Channel( ch ).TOTAL_RATE(1).DATA(data_i).data_vector = a ;
                         
                          a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE.Channel_difference_std_only_active' ;
                        data_i = data_i +1 ;                
                         TOTAL_RATE(1).DATA(data_i).data_vector =[TOTAL_RATE(1).DATA(data_i).data_vector  ; a ];
                         EXP( exp_num_file_n ).ExpStage( Pair_i ).Channel( ch ).TOTAL_RATE(1).DATA(data_i).data_vector = a ;
                         
                         a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE.Channels_overlap_only_active ;
                         data_i = data_i +1 ;                 
                         TOTAL_RATE(1).DATA(data_i).data_vector =[TOTAL_RATE(1).DATA(data_i).data_vector  ; a ];
                         
                         a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE.Channel_difference_mean_ratio  ;
                         data_i = data_i +1 ;                 
                         TOTAL_RATE(1).DATA(data_i).data_vector =[TOTAL_RATE(1).DATA(data_i).data_vector  ; a ];
                         EXP( exp_num_file_n ).ExpStage( Pair_i ).Channel( ch ).TOTAL_RATE(1).DATA(data_i).data_vector = a ;
                         
                        a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE.Channel_difference_mean  ;
                         data_i = data_i +1 ;                  
                         TOTAL_RATE(1).DATA(data_i).data_vector =[TOTAL_RATE(1).DATA(data_i).data_vector  ; a ];
                         
                         a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE.Channel_difference_std_ratio' ;
                          data_i = data_i +1 ;                  
                         TOTAL_RATE(1).DATA(data_i).data_vector =[TOTAL_RATE(1).DATA(data_i).data_vector  ; a ];
                         EXP( exp_num_file_n ).ExpStage( Pair_i ).Channel( ch ).TOTAL_RATE(1).DATA(data_i).data_vector = a ;
                         
                         a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE.Channel_difference_std' ;
                         data_i = data_i +1 ;                 
                         TOTAL_RATE(1).DATA(data_i).data_vector =[TOTAL_RATE(1).DATA(data_i).data_vector  ; a ];
                         EXP( exp_num_file_n ).ExpStage( Pair_i ).Channel( ch ).TOTAL_RATE(1).DATA(data_i).data_vector = a ;
                         
                        a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE.Channels_overlap  ;
                         data_i = data_i +1 ;                
                         TOTAL_RATE(1).DATA(data_i).data_vector =[TOTAL_RATE(1).DATA(data_i).data_vector  ; a ];
                         EXP( exp_num_file_n ).ExpStage( Pair_i ).Channel( ch ).TOTAL_RATE(1).DATA(data_i).data_vector = a ;
                         
                           a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE.Channel_is_active ;
                         data_i = data_i +1 ;                  
                         TOTAL_RATE(1).DATA(data_i).data_vector =[TOTAL_RATE(1).DATA(data_i).data_vector  ; a ];
                         EXP( exp_num_file_n ).ExpStage( Pair_i ).Channel( ch ).TOTAL_RATE(1).DATA(data_i).data_vector = a ;
                     end   
%                      end
                      
                     % if enough_High_responses then collect that data
                     EXP( exp_num_file_n ).ExpStage( Pair_i ).Channel( ch ).TOTAL_RATE(2).Data_included = HiLo_Patterns1_2_enough_High_responses ;
                     if HiLo_Patterns1_2_enough_High_responses   
                         
                      a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_High.Channel_difference_mean_ratio_only_active ;
                           data_i = 1 ;                 
                         TOTAL_RATE(2).DATA(data_i).data_vector =[TOTAL_RATE(2).DATA(data_i).data_vector  ; a ];
                         EXP( exp_num_file_n ).ExpStage( Pair_i ).Channel( ch ).TOTAL_RATE(2).DATA(data_i).data_vector = a ;

                          a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_High.Channel_difference_mean_only_active ;
                         data_i = data_i +1 ;                 
                         TOTAL_RATE(2).DATA(data_i).data_vector =[TOTAL_RATE(2).DATA(data_i).data_vector  ; a ];
                          EXP( exp_num_file_n ).ExpStage( Pair_i ).Channel( ch ).TOTAL_RATE(2).DATA(data_i).data_vector = a ;
                         
                         a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_High.Channel_difference_std_ratio_only_active' ;
                        data_i = data_i +1 ;                 
                         TOTAL_RATE(2).DATA(data_i).data_vector =[TOTAL_RATE(2).DATA(data_i).data_vector  ; a ];
                          EXP( exp_num_file_n ).ExpStage( Pair_i ).Channel( ch ).TOTAL_RATE(2).DATA(data_i).data_vector = a ;
                          
                          a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_High.Channel_difference_std_only_active' ;
                        data_i = data_i +1 ;                 
                         TOTAL_RATE(2).DATA(data_i).data_vector =[TOTAL_RATE(2).DATA(data_i).data_vector  ; a ];
                          EXP( exp_num_file_n ).ExpStage( Pair_i ).Channel( ch ).TOTAL_RATE(2).DATA(data_i).data_vector = a ;
                          
                         a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_High.Channels_overlap_only_active ;
                        data_i = data_i +1 ;                 
                         TOTAL_RATE(2).DATA(data_i).data_vector =[TOTAL_RATE(2).DATA(data_i).data_vector  ; a ];
                          EXP( exp_num_file_n ).ExpStage( Pair_i ).Channel( ch ).TOTAL_RATE(2).DATA(data_i).data_vector = a ;
                          
                         a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_High.Channel_difference_mean_ratio  ;
                         data_i = data_i +1 ;                 
                         TOTAL_RATE(2).DATA(data_i).data_vector =[TOTAL_RATE(2).DATA(data_i).data_vector  ; a ];
                          EXP( exp_num_file_n ).ExpStage( Pair_i ).Channel( ch ).TOTAL_RATE(2).DATA(data_i).data_vector = a ;
                          
                         a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_High.Channel_difference_mean  ;
                         data_i = data_i +1 ;                 
                         TOTAL_RATE(2).DATA(data_i).data_vector =[TOTAL_RATE(2).DATA(data_i).data_vector  ; a ];
                          EXP( exp_num_file_n ).ExpStage( Pair_i ).Channel( ch ).TOTAL_RATE(2).DATA(data_i).data_vector = a ;
                          
                         a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_High.Channel_difference_std_ratio' ;
                        data_i = data_i +1 ;                 
                        TOTAL_RATE(2).DATA(data_i).data_vector =[TOTAL_RATE(2).DATA(data_i).data_vector  ; a ];
                      EXP( exp_num_file_n ).ExpStage( Pair_i ).Channel( ch ).TOTAL_RATE(2).DATA(data_i).data_vector = a ;
                      
                          a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_High.Channel_difference_std' ;
                        data_i = data_i +1 ;                 
                        TOTAL_RATE(2).DATA(data_i).data_vector =[TOTAL_RATE(2).DATA(data_i).data_vector  ; a ];
                         EXP( exp_num_file_n ).ExpStage( Pair_i ).Channel( ch ).TOTAL_RATE(2).DATA(data_i).data_vector = a ;
                         
                          a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_High.Channels_overlap  ;
                        data_i = data_i +1 ;                 
                        TOTAL_RATE(2).DATA(data_i).data_vector =[TOTAL_RATE(2).DATA(data_i).data_vector  ; a ];
                          EXP( exp_num_file_n ).ExpStage( Pair_i ).Channel( ch ).TOTAL_RATE(2).DATA(data_i).data_vector = a ;
                          
                         a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_High.Channel_is_active ;
                        data_i = data_i +1 ;                 
                        TOTAL_RATE(2).DATA(data_i).data_vector =[TOTAL_RATE(2).DATA(data_i).data_vector  ; a ];
                         EXP( exp_num_file_n ).ExpStage( Pair_i ).Channel( ch ).TOTAL_RATE(2).DATA(data_i).data_vector = a ;
                     
                      end  