          
% Patterns_Plot_differencies_Dots_Els_Sel_day_by_Day_from_matrix 
%---- Plot dots - x-diff pair 1-2 , y - pair 1-N  //// 
% //////  diff_mean_only_active


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
            %????????????????????????????????

SR_ratio_limit = 300 ;            
            
cmap = hsv(Kpairs -1 );  %# Creates a 6-by-3 set of colors from the HSV colormap

            figure
            TotalRate_num = 1 ; % low responses
            
            hold on
            legend_str_all = [] ;
            
            % collect all data where x axis elements lower than threshold
            Data_threshold = inf ;
            
            
            for filen = 2 : Kpairs
%                 Channel_difference_mean  - 7 ;
                data_i = 7 ;
                 
                Collect_all_data_to_vectors 
                      
                 legend_str =  [ 'Pair #' num2str( filen )] ;
                 legend_str_all = [ legend_str_all ; legend_str ] ;
                          
%                       plot( All_data_all_exp( 1 ).TOTAL_RATE( TotalRate_num ).DATA(data_i).data_vector , ...
%                               All_data_all_exp( filen ).TOTAL_RATE( TotalRate_num ).DATA(data_i).data_vector , '*' , 'Color' , cmap( filen-1,:) )   ;
%                          legend_str =  [ 'Pair #' num2str( filen )] ;
%                           legend_str_all = [ legend_str_all ; legend_str ] ;
                 
            end
            legend_str_all = cellstr(legend_str_all);
                
                grid on
                hold off
                
              legend( legend_str_all )
            xlabel( 'Mean Difference')
            ylabel( 'Mean Difference')
            title('Low responses. One dot-one channel. Mean difference ')  
           %------------------------------ Plot dots
           
 % //////  diff_mean_only_active
            figure
            TotalRate_num = 1 ; % low responses
            
            % collect all data where x axis elements lower than threshold   
            Data_threshold = inf ;
            Data_threshold = Global_flags.Channel_difference_mean_ratio_StableCTRL_thres ;
            
            hold on
%             legend_str = ''; 
            for filen = 2 : Kpairs
%                 Channel_difference_mean_ratio - 6   ;
                     data_i = 6 ;
                     
                     Collect_all_data_to_vectors
                     
%                     plot( All_data_all_exp( 1 ).TOTAL_RATE( TotalRate_num ).DATA(data_i).data_vector  , ...
%                           All_data_all_exp( filen ).TOTAL_RATE( TotalRate_num ).DATA(data_i).data_vector  , '*'  , 'Color' , cmap( filen-1,:) )   ;
%                       legend_str = [ legend_str ' Pair #' num2str( filen ) ] ;
            end
            
                
                grid on
                hold off
                legend( legend_str_all )
            xlabel( 'Mean Difference ratio')
            ylabel( 'Mean Difference ratio')
            title('Low responses. One dot-one channel. Mean difference ratio') 
            axis( [ -SR_ratio_limit  SR_ratio_limit -SR_ratio_limit SR_ratio_limit ]) 
           %------------------------------ Plot dots          
           
           
           
           
% //////  diff_mean_only_active
            figure
            TotalRate_num = 2 ; % low responses
            
            % collect all data where x axis elements lower than threshold   
            Data_threshold = inf ; 
            
            hold on
%             legend_str = ''; 
            for filen = 2 : Kpairs
                   %                 Channel_difference_mean  - 7 ;
                data_i = 7 ;
                
                Collect_all_data_to_vectors
                
%                     plot( All_data_all_exp( 1 ).TOTAL_RATE( TotalRate_num ).DATA(data_i).data_vector , ...
%                           All_data_all_exp( filen ).TOTAL_RATE( TotalRate_num ).DATA(data_i).data_vector , '*' , 'Color' , cmap( filen-1,:) )   ;
                   
%                       legend_str = [ legend_str ' Pair #' num2str( filen ) ] ;
            end
            
                
                grid on
                hold off
                legend( legend_str_all )
            xlabel( 'Mean Difference')
            ylabel( 'Mean Difference')
            title('High responses. One dot-one channel. Mean difference ') 
           %------------------------------ Plot dots           
           
           
 % //////  diff_mean_only_active
            figure
            TotalRate_num = 2 ; % low responses
            
            % collect all data where x axis elements lower than threshold
            % 
            Data_threshold = Global_flags.Channel_difference_mean_ratio_StableCTRL_thres ;
            
            hold on
%             legend_str = ''; 
            for filen = 2 : Kpairs
%                     Channel_difference_mean_ratio - 6   ;
                     data_i = 6 ;
                     
                     Collect_all_data_to_vectors
                     
%                     plot( All_data_all_exp( 1 ).TOTAL_RATE( TotalRate_num ).DATA(data_i).data_vector  , ...
%                           All_data_all_exp( filen ).TOTAL_RATE( TotalRate_num ).DATA(data_i).data_vector  , '*'  , 'Color' , cmap( filen-1,:) )   ;
%                      legend_str = [ legend_str ' Pair #' num2str( filen ) ] ;
            end
            
                
                grid on
                hold off
                legend( legend_str_all )
            xlabel( 'Mean Difference ratio')
            ylabel( 'Mean Difference ratio')
            title('High responses. One dot-one channel. Mean difference ratio') 
            axis( [ -SR_ratio_limit  SR_ratio_limit -SR_ratio_limit SR_ratio_limit ]) 
           %------------------------------ Plot dots                 
           
           
           
           
           
           
           
           
           