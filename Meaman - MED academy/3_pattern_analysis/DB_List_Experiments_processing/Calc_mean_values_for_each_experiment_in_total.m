



% Calc_mean_values_for_each_experiment_in_total
% Input - All_data_all_exp
                for Tracenum = 1 : 2 
                    for filen = 1 : Kpairs
                        ALL_experiments_file_pars.TOTAL_RATE_mean(Tracenum).MEAN_all_exp_diff_mean_ratio( filen ) = mean( All_data_all_exp( filen ).TOTAL_RATE( Tracenum ).all_exp_diff_mean_ratio );
                        ALL_experiments_file_pars.TOTAL_RATE_mean(Tracenum).MEAN_all_exp_diff_mean( filen ) = mean( All_data_all_exp( filen ).TOTAL_RATE( Tracenum ).all_exp_diff_mean );
                        ALL_experiments_file_pars.TOTAL_RATE_mean(Tracenum).MEAN_all_exp_diff_mean_std_ratio( filen ) = mean( All_data_all_exp( filen ).TOTAL_RATE(Tracenum ).all_exp_diff_std_ratio );
                        ALL_experiments_file_pars.TOTAL_RATE_mean(Tracenum).MEAN_all_exp_diff_mean_std( filen ) = mean( All_data_all_exp( filen ).TOTAL_RATE(Tracenum ).all_exp_diff_std );
                        ALL_experiments_file_pars.TOTAL_RATE_mean(Tracenum).MEAN_all_exp_Channels_overlap( filen ) = mean( All_data_all_exp( filen ).TOTAL_RATE(Tracenum ).all_exp_Channels_overlap );

                        ALL_experiments_file_pars.TOTAL_RATE_mean(Tracenum).STD_all_exp_diff_mean_ratio( filen ) = std( All_data_all_exp( filen ).TOTAL_RATE(Tracenum).all_exp_diff_mean_ratio );
                        ALL_experiments_file_pars.TOTAL_RATE_mean(Tracenum).STD_all_exp_diff_mean( filen ) = std( All_data_all_exp( filen ).TOTAL_RATE(Tracenum).all_exp_diff_mean );
                        ALL_experiments_file_pars.TOTAL_RATE_mean(Tracenum).STD_all_exp_diff_mean_std_ratio( filen ) = std( All_data_all_exp( filen ).TOTAL_RATE(Tracenum).all_exp_diff_std_ratio );
                        ALL_experiments_file_pars.TOTAL_RATE_mean(Tracenum).STD_all_exp_diff_mean_std( filen ) = std( All_data_all_exp( filen ).TOTAL_RATE(Tracenum).all_exp_diff_std );
                        ALL_experiments_file_pars.TOTAL_RATE_mean(Tracenum).STD_all_exp_Channels_overlap( filen ) = std( All_data_all_exp( filen ).TOTAL_RATE(Tracenum).all_exp_Channels_overlap );
                    end   
                end 

                    %/////////////////////////////////////////////////////
                    %///// Show histograms of all collected data
                if ~isempty( All_data_all_exp( 1 ).TOTAL_RATE( 1 ).all_exp_diff_mean  )
                    TotalRate_num = 1 ;
                    FigureName = [ FigureName_prefix 'Low responses' ] ;
                    Hist_All_Kpairs_all_characteristics
                    % Input - TotalRate_num , All_data_all_exp( ).TOTAL_RATE( )
                    % TotalRate_num - 1 , 2 
                    % FigureName = 'Low respones' ...
                end

                    if ~isempty( All_data_all_exp( 1 ).TOTAL_RATE( 2 ).all_exp_diff_mean  )
                            TotalRate_num = 2 ;
                            FigureName = [ FigureName_prefix 'High responses' ];
                            Hist_All_Kpairs_all_characteristics
                            % Input - TotalRate_num , All_data_all_exp( ).TOTAL_RATE( )
                            % TotalRate_num - 1 , 2 
                            % FigureName = 'Low respones' ...
                    end


                    %/////////////////////////////////////////////////////    
                    %/////////////////////////////////////////////////////