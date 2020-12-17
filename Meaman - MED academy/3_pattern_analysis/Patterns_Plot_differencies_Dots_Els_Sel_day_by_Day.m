          
% Patterns_Plot_differencies_Dots_Els_Sel_day_by_Day 
%---- Plot dots - x-diff pair 1-2 , y - pair 1-N  //// 
% //////  diff_mean_only_active


cmap = hsv(Kpairs -1 );  %# Creates a 6-by-3 set of colors from the HSV colormap

            figure
            TotalRate_num = 1 ; % low responses
            
            hold on
            legend_str_all = [] ;
            
            for filen = 2 : Kpairs
                    plot( All_data_all_exp( 1 ).TOTAL_RATE( TotalRate_num ).all_exp_diff_mean , ...
                          All_data_all_exp( filen ).TOTAL_RATE( TotalRate_num ).all_exp_diff_mean , '*' , 'Color' , cmap( filen-1,:) )   ;
                     legend_str =  [ 'Pair #' num2str( filen )] ;
                      legend_str_all = [ legend_str_all ; legend_str ] ;
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
            
            hold on
%             legend_str = ''; 
            for filen = 2 : Kpairs
                    plot( All_data_all_exp( 1 ).TOTAL_RATE( TotalRate_num ).all_exp_diff_mean_ratio , ...
                          All_data_all_exp( filen ).TOTAL_RATE( TotalRate_num ).all_exp_diff_mean_ratio , '*'  , 'Color' , cmap( filen-1,:) )   ;
%                       legend_str = [ legend_str ' Pair #' num2str( filen ) ] ;
            end
            
                
                grid on
                hold off
                legend( legend_str_all )
            xlabel( 'Mean Difference ratio')
            ylabel( 'Mean Difference ratio')
            title('Low responses. One dot-one channel. Mean difference ratio') 
           %------------------------------ Plot dots          
           
           
           
           
% //////  diff_mean_only_active
            figure
            TotalRate_num = 2 ; % low responses
            
            hold on
%             legend_str = ''; 
            for filen = 2 : Kpairs
                    plot( All_data_all_exp( 1 ).TOTAL_RATE( TotalRate_num ).all_exp_diff_mean , ...
                          All_data_all_exp( filen ).TOTAL_RATE( TotalRate_num ).all_exp_diff_mean , '*'  , 'Color' , cmap( filen-1,:) )   ;
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
            
            hold on
%             legend_str = ''; 
            for filen = 2 : Kpairs
                    plot( All_data_all_exp( 1 ).TOTAL_RATE( TotalRate_num ).all_exp_diff_mean_ratio , ...
                          All_data_all_exp( filen ).TOTAL_RATE( TotalRate_num ).all_exp_diff_mean_ratio, '*'  , 'Color' , cmap( filen-1,:) )   ;
%                       legend_str = [ legend_str ' Pair #' num2str( filen ) ] ;
            end
            
                
                grid on
                hold off
                legend( legend_str_all )
            xlabel( 'Mean Difference ratio')
            ylabel( 'Mean Difference ratio')
            title('High responses. One dot-one channel. Mean difference ratio') 
           %------------------------------ Plot dots                 
           
           
           
           
           
           
           
           
           