                


%     Cycle_chans_collect_data2


                    for exp_num_file_n = 1 : 1 : Nexp
                            exp_num_file_n_fix= exp_num_file_n ;
                          ch_end = 1 ; 
                          
                          %/// For each experiment take it's own
                          % electrode_sel_param 
                            %--- Extract el_sel protocol from string 
                               Global_flags.electrode_sel_param =...
                               electrode_sel_param_from_string( electrode_sel_param_Strings_files{ Experiment_number } )   ;   
                           %---------------------------------------  
                            if ~Summ_all_exp_ctrl_channels 
                                if Tet_channel_number_1_or_2 == 1
                                   Tet_channel_linear_num = Global_flags.electrode_sel_param.Tet1_linear_num ;
                                else
                                   Tet_channel_linear_num = Global_flags.electrode_sel_param.Tet2_linear_num ;
                                end
                            end
                          
                          
                          
                             exp_num_file_n_fix= exp_num_file_n ;
                          ch_end = 1 ;                          
                          % if take data from all stim electrodes
                          if Global_flags.cycle_all_electrodes
                              ch_end = Global_flags.electrode_sel_param.Channels_number  ;
                          end 
                          for ch= 1 : ch_end      
                            HiLo_Patterns1_2_enough_Low_responses  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).HiLo_Patterns1_2_enough_Low_responses ;
                            HiLo_Patterns1_2_enough_High_responses  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).HiLo_Patterns1_2_enough_High_responses ;                     
                            HiLo_Patterns2_3_enough_Low_responses  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).HiLo_Patterns2_3_enough_Low_responses ;
                            HiLo_Patterns2_3_enough_High_responses  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).HiLo_Patterns2_3_enough_High_responses ;                     


                            HiLo_Patterns2_3_enough_Low_responses
                            
                             %-- if current channel is tetanazied channel
                            %....
                            Add_data_from_current_channel = false; 
                            if Summ_all_exp_ctrl_channels &&  ch ~= Global_flags.electrode_sel_param.Tet1_linear_num && ...
                                     ch ~= Global_flags.electrode_sel_param.Tet2_linear_num   
                                 Add_data_from_current_channel = true ;
                            end   
                            
                            if ~Summ_all_exp_ctrl_channels  &&  ch == Tet_channel_linear_num  
                                 Add_data_from_current_channel = true ;
                            end                                
                            
                             if Add_data_from_current_channel
                             % if enough_Low_responses then collect that data
                             if HiLo_Patterns1_2_enough_Low_responses  && HiLo_Patterns2_3_enough_Low_responses

                                      a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_3files.Channel_difference_mean2_ratio_only_active ;
                                      TOTAL_RATE(1).all_exp_diff_mean_ratio_only_active =[TOTAL_RATE(1).all_exp_diff_mean_ratio_only_active; a ];

                                      a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_3files.Channel_difference_mean2_only_active ;
                                      TOTAL_RATE(1).all_exp_diff_mean_only_active =[TOTAL_RATE(1).all_exp_diff_mean_only_active; a ];             

                                      a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_3files.Channel_difference_std2_ratio_only_active' ;
                                      TOTAL_RATE(1).all_exp_diff_std_ratio_only_active =[TOTAL_RATE(1).all_exp_diff_std_ratio_only_active; a  ];

                                      a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_3files.Channel_difference_std2_only_active' ;
                                      TOTAL_RATE(1).all_exp_diff_std_only_active =[TOTAL_RATE(1).all_exp_diff_std_only_active; a ];

                                      a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_3files.Channels_overlap2_only_active ;
                                      TOTAL_RATE(1).all_exp_Channels_overlap_only_active =[TOTAL_RATE(1).all_exp_Channels_overlap_only_active ; a ]; 

                                      a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_3files.Channel_difference_mean2_ratio ;
                                      TOTAL_RATE(1).all_exp_diff_mean_ratio =[TOTAL_RATE(1).all_exp_diff_mean_ratio; a ];

                                      a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_3files.Channel_difference_mean2  ;
                                      TOTAL_RATE(1).all_exp_diff_mean =[TOTAL_RATE(1).all_exp_diff_mean; a ];             

                                      a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_3files.Channel_difference_std2_ratio' ;
                                      TOTAL_RATE(1).all_exp_diff_std_ratio =[TOTAL_RATE(1).all_exp_diff_std_ratio; a  ];

                                      a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_3files.Channel_difference_std2' ;
                                      TOTAL_RATE(1).all_exp_diff_std =[TOTAL_RATE(1).all_exp_diff_std; a ];

                                      a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_3files.Channels_overlap2_only_active ;
                                      TOTAL_RATE(1).all_exp_Channels_overlap =[TOTAL_RATE(1).all_exp_Channels_overlap ; a ];
                                      
                                           a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_3files.Channel_is_active2 ;
                                          TOTAL_RATE(1).all_exp_Channel_is_active  =[TOTAL_RATE(1).all_exp_Channel_is_active ; a ];                                                 
                             end

                             % if enough_High_responses then collect that data
                             if HiLo_Patterns1_2_enough_High_responses  && HiLo_Patterns2_3_enough_High_responses
                                      a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_High_3files.Channel_difference_mean2_ratio_only_active ;
                                      TOTAL_RATE(2).all_exp_diff_mean_ratio_only_active =[TOTAL_RATE(2).all_exp_diff_mean_ratio_only_active; a ];

                                      a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_High_3files.Channel_difference_mean2_only_active ;
                                      TOTAL_RATE(2).all_exp_diff_mean_only_active =[TOTAL_RATE(2).all_exp_diff_mean_only_active; a ];             

                                      a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_High_3files.Channel_difference_std2_ratio_only_active' ;
                                      TOTAL_RATE(2).all_exp_diff_std_ratio_only_active =[TOTAL_RATE(2).all_exp_diff_std_ratio_only_active; a ];

                                      a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_High_3files.Channel_difference_std2_only_active' ;
                                      TOTAL_RATE(2).all_exp_diff_std_only_active =[TOTAL_RATE(2).all_exp_diff_std_only_active; a ];

                                      a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_High_3files.Channels_overlap2_only_active ;
                                      TOTAL_RATE(2).all_exp_Channels_overlap_only_active =[TOTAL_RATE(2).all_exp_Channels_overlap_only_active ; a ]; 

                                       a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_High_3files.Channel_difference_mean2_ratio  ;
                                      TOTAL_RATE(2).all_exp_diff_mean_ratio =[TOTAL_RATE(2).all_exp_diff_mean_ratio; a ];

                                      a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_High_3files.Channel_difference_mean2  ;
                                      TOTAL_RATE(2).all_exp_diff_mean =[TOTAL_RATE(2).all_exp_diff_mean; a ];             

                                      a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_High_3files.Channel_difference_std2_ratio' ;
                                      TOTAL_RATE(2).all_exp_diff_std_ratio =[TOTAL_RATE(2).all_exp_diff_std_ratio; a ];

                                      a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_High_3files.Channel_difference_std2' ;
                                      TOTAL_RATE(2).all_exp_diff_std =[TOTAL_RATE(2).all_exp_diff_std; a ];

                                      a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_High_3files.Channels_overlap2 ;
                                      TOTAL_RATE(2).all_exp_Channels_overlap =[TOTAL_RATE(2).all_exp_Channels_overlap ; a ];                                      
                                            a  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).TOTAL_RATE_High_3files.Channel_is_active2 ;
                                          TOTAL_RATE(2).all_exp_Channel_is_active  =[TOTAL_RATE(2).all_exp_Channel_is_active ; a ];                                        
                              end                     

                          end
                          end
                      end % cycle for fixed files pair for all experiments