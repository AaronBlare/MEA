



% Calc_mean_values_for_each_experiment_in_total_from_matrix
% Input - All_data_all_exp

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

DATA_types = 11 ;
                for Tracenum = 1 : 2 
                    for Pair_i = 1 : Kpairs
                        for data_i = 1 : DATA_types
                            data_vec =    All_data_all_exp( Pair_i ).TOTAL_RATE( Tracenum ).DATA(data_i).data_vector ;

                            %-- Filter "bad" response ratio 
                            data_vec = Data_erase_Bad_values( data_vec , data_i , Global_flags ) ;
                             
                            
                            All_data_all_exp( Pair_i ).TOTAL_RATE_mean(Tracenum).MEAN_ABS.DATA(data_i).value  = ...
                                    mean( abs( data_vec )) ;

                             All_data_all_exp( Pair_i ).TOTAL_RATE_mean(Tracenum).STD_ABS.DATA(data_i).value = ...
                                    std( abs( data_vec )) ;                           

                             data_vec_pos = data_vec( data_vec>0);
                             data_vec_neg = data_vec( data_vec<0 );
                             All_data_all_exp( Pair_i ).TOTAL_RATE_mean(Tracenum).MEAN_POSITIVE.DATA(data_i).value = ...
                                    mean( data_vec_pos) ;  
                              All_data_all_exp( Pair_i ).TOTAL_RATE_mean(Tracenum).STD_POSITIVE.DATA(data_i).value = ...
                                    std( data_vec_pos) ;                             
                              All_data_all_exp( Pair_i ).TOTAL_RATE_mean(Tracenum).MEAN_NEGATIVE.DATA(data_i).value = ...
                                    mean( data_vec_neg ) ;        
                               All_data_all_exp( Pair_i ).TOTAL_RATE_mean(Tracenum).STD_NEGATIVE.DATA(data_i).value = ...
                                    std( data_vec_neg ) ;  
                        end  
                    end
                end 

                    %/////////////////////////////////////////////////////
                    %///// Show histograms of all collected data
%                      Channel_difference_mean  - 7 ;
                    data_i = 7 ; 
                    
                if ~isempty( All_data_all_exp( 1 ).TOTAL_RATE( 1 ).DATA(data_i).data_vector  )
                    TotalRate_num = 1 ;
                    FigureName = [ FigureName_prefix 'Low responses' ] ;
%                     Hist_All_Kpairs_all_characteristics
                    Hist_All_Kpairs_all_characteristics_from_matrix
                    MEAN_All_Kpairs_all_characteristics_from_matrix
                    % Input - TotalRate_num , All_data_all_exp( ).TOTAL_RATE( )
                    % TotalRate_num - 1 , 2 
                    % FigureName = 'Low respones' ...
                end
%                     Channel_difference_mean  - 7 ;
                    data_i = 7 ; 
                    
                    if ~isempty( All_data_all_exp( 1 ).TOTAL_RATE( 2 ).DATA(data_i).data_vector  )
                            TotalRate_num = 2 ;
                            FigureName = [ FigureName_prefix 'High responses' ];
%                             Hist_All_Kpairs_all_characteristics
                            Hist_All_Kpairs_all_characteristics_from_matrix
                            MEAN_All_Kpairs_all_characteristics_from_matrix
                            % Input - TotalRate_num , All_data_all_exp( ).TOTAL_RATE( )
                            % TotalRate_num - 1 , 2 
                            % FigureName = 'Low respones' ...
                    end


                    %/////////////////////////////////////////////////////    
                    %/////////////////////////////////////////////////////