

% El_Sel_Day_by_Day_collect_data

 % if enough_Low_responses then collect that data
%                      if HiLo_Patterns1_2_enough_Low_responses 
                         
                         a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE.Channel_difference_mean_ratio_only_active ;
                                          TOTAL_RATE(1).all_exp_diff_mean_ratio_only_active =[TOTAL_RATE(1).all_exp_diff_mean_ratio_only_active ; a ];

                                          a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE.Channel_difference_mean_only_active ;
                                          TOTAL_RATE(1).all_exp_diff_mean_only_active =[TOTAL_RATE(1).all_exp_diff_mean_only_active ; a ];             

                                          a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE.Channel_difference_std_ratio_only_active' ;
                                          TOTAL_RATE(1).all_exp_diff_std_ratio_only_active =[TOTAL_RATE(1).all_exp_diff_std_ratio_only_active; a  ];

                                          a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE.Channel_difference_std_only_active' ;
                                          TOTAL_RATE(1).all_exp_diff_std_only_active =[TOTAL_RATE(1).all_exp_diff_std_only_active; a ];

                                          a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE.Channels_overlap_only_active ;
                                          TOTAL_RATE(1).all_exp_Channels_overlap_only_active =[TOTAL_RATE(1).all_exp_Channels_overlap_only_active ; a ]; 

                                          a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE.Channel_difference_mean_ratio  ;
                                          TOTAL_RATE(1).all_exp_diff_mean_ratio =[TOTAL_RATE(1).all_exp_diff_mean_ratio; a ];

                                          a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE.Channel_difference_mean  ;
                                          TOTAL_RATE(1).all_exp_diff_mean =[TOTAL_RATE(1).all_exp_diff_mean; a ];             

                                          a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE.Channel_difference_std_ratio' ;
                                          TOTAL_RATE(1).all_exp_diff_std_ratio =[TOTAL_RATE(1).all_exp_diff_std_ratio; a  ];

                                          a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE.Channel_difference_std' ;
                                          TOTAL_RATE(1).all_exp_diff_std =[TOTAL_RATE(1).all_exp_diff_std; a ];

                                          a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE.Channels_overlap  ;
                                          TOTAL_RATE(1).all_exp_Channels_overlap =[TOTAL_RATE(1).all_exp_Channels_overlap ; a ];                                            
                                          a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE.Channel_is_active ;
                                          TOTAL_RATE(1).all_exp_Channel_is_active  =[TOTAL_RATE(1).all_exp_Channel_is_active ; a ];   

%                      end
                      
                     % if enough_High_responses then collect that data
                     if HiLo_Patterns1_2_enough_High_responses   
                         
                                        a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_High.Channel_difference_mean_ratio_only_active ;
                                          TOTAL_RATE(2).all_exp_diff_mean_ratio_only_active =[TOTAL_RATE(2).all_exp_diff_mean_ratio_only_active ; a ];

                                          a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_High.Channel_difference_mean_only_active ;
                                          TOTAL_RATE(2).all_exp_diff_mean_only_active =[TOTAL_RATE(2).all_exp_diff_mean_only_active; a ];             

                                          a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_High.Channel_difference_std_ratio_only_active' ;
                                          TOTAL_RATE(2).all_exp_diff_std_ratio_only_active =[TOTAL_RATE(2).all_exp_diff_std_ratio_only_active; a ];

                                          a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_High.Channel_difference_std_only_active' ;
                                          TOTAL_RATE(2).all_exp_diff_std_only_active =[TOTAL_RATE(2).all_exp_diff_std_only_active; a ];

                                          a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_High.Channels_overlap_only_active ;
                                          TOTAL_RATE(2).all_exp_Channels_overlap_only_active =[TOTAL_RATE(2).all_exp_Channels_overlap_only_active ; a ]; 

                                           a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_High.Channel_difference_mean_ratio  ;
                                          TOTAL_RATE(2).all_exp_diff_mean_ratio =[TOTAL_RATE(2).all_exp_diff_mean_ratio; a ];

                                          a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_High.Channel_difference_mean  ;
                                          TOTAL_RATE(2).all_exp_diff_mean =[TOTAL_RATE(2).all_exp_diff_mean; a ];             

                                          a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_High.Channel_difference_std_ratio' ;
                                          TOTAL_RATE(2).all_exp_diff_std_ratio =[TOTAL_RATE(2).all_exp_diff_std_ratio; a ];

                                          a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_High.Channel_difference_std' ;
                                          TOTAL_RATE(2).all_exp_diff_std =[TOTAL_RATE(2).all_exp_diff_std; a ];

                                          a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_High.Channels_overlap  ;
                                          TOTAL_RATE(2).all_exp_Channels_overlap =[TOTAL_RATE(2).all_exp_Channels_overlap ; a ]; 
                                          
                                          a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_High.Channel_is_active ;
                                          TOTAL_RATE(2).all_exp_Channel_is_active  =[TOTAL_RATE(2).all_exp_Channel_is_active ; a ];                                    
                              
                      end  