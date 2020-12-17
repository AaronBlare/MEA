% Collect_all_data_to_vectors

                Data_x = [];
                Data_y = [] ;
                 for exp_num_file_n = 1 : 1 : Nexp
                  for ch  = 1 :  EXP( exp_num_file_n  ).ExpStage( filen ).ch_end
                    if EXP( exp_num_file_n ).ExpStage( filen ).Channel( ch ).TOTAL_RATE(TotalRate_num).Data_included && ...
                       EXP( exp_num_file_n ).ExpStage( filen ).Channel( ch ).TOTAL_RATE(TotalRate_num).Data_included  
                            
                        Data_x_new = EXP( exp_num_file_n ).ExpStage( 1 ).Channel( ch ).TOTAL_RATE(TotalRate_num).DATA(data_i).data_vector ;
                        Data_y_new = EXP( exp_num_file_n ).ExpStage(  filen ).Channel( ch ).TOTAL_RATE(TotalRate_num).DATA(data_i).data_vector ;
                         
                            Data_x = [ Data_x Data_x_new  ];
                            Data_y = [ Data_y  Data_y_new ];
                         
   
                    end
                  end
                 end                 
                plot( Data_x , ...
                              Data_y , '*' , 'Color' , cmap( filen-1,:) )   ;