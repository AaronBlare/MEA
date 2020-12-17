

            %  MEAN_All_Kpairs_all_characteristics_from_matrix
            
            % Input - TotalRate_num , All_data_all_exp( ).TOTAL_RATE( )
            % TotalRate_num - 1 , 2 
            % FigureName = 'Low respones' ...
            %/////////////////////////////////////////////////////
            %///// Show histograms of all collected data
            
            %-----------?????????????????????????????
%             %???? plot 2d - x axis - diff ctrl1-ctrl2 , y axis - diff
%             %ctrl2-tet
%             figure
%             plot( All_data_all_exp( 1 ).TOTAL_RATE( TotalRate_num ).all_exp_diff_mean , ...
%                     All_data_all_exp( 2 ).TOTAL_RATE( TotalRate_num ).all_exp_diff_mean , '*r' )
%             xlabel( 'Difference Ctrl1-Ctrl2')
%             ylabel( 'Difference Ctrl2-Tet')
%             title('Each point-one channel characteristic')
            
            
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
            
            
             f=figure ;
             set(f,'name', FigureName  ,'numbertitle','off')
             Nx = 3 ; Ny = 2 ;
             BINS_NUM = 30  ;  
             
             %---Filter all_exp_diff_mean_ratio all_exp_diff_std_ratio
             %higher or lower than this limit
                DataHist_Limit = 1000 ;  
            
   
                 % --- Mean difference
                 LegendString = {};
                 
%              Channel_difference_mean  - 7 ;     
                Data_Kpairs_mean = zeros( Kpairs,1);
                Data_Kpairs_std = zeros( Kpairs,1); 
                 data_i= 7 ;
                 for k = 1 : Kpairs
                    Data_Kpairs_mean( k )=  All_data_all_exp( k ).TOTAL_RATE_mean( TotalRate_num ).MEAN_ABS.DATA(data_i).value   ;  
                    LegendString{ k}= [   'File pair ' num2str(  k ) ] ;
                 end 
                 
       %        Channel_difference_std - 9 ;
                 data_i= 9 ;
                 for k = 1 : Kpairs
                    Data_Kpairs_std( k )=  All_data_all_exp( k ).TOTAL_RATE_mean( TotalRate_num ).STD_ABS.DATA(data_i).value   ;  
                 end  
%            if ~isempty( Data_Kpairs(:).data )
    
                 XXX = 1 : Kpairs ;
       subplot(Ny,Nx, 1 )
                 barwitherr( Data_Kpairs_std , XXX , Data_Kpairs_mean);
                 % Input - Data_Kpairs , BINS_NUM 
                      
                 title( 'Mean abs difference')
                 xlabel( 'Pair #')   
                 ylabel( 'Mean difference, spikes') 
%                  Legend( LegendString )
                 %----------------------
                 

                 
              
                    
%               Channel_difference_mean  - 7 ;     
                 data_i= 7 ;
                 for k = 1 : Kpairs
                    Data_Kpairs_mean( k )=  All_data_all_exp( k ).TOTAL_RATE_mean( TotalRate_num ).MEAN_POSITIVE.DATA(data_i).value   ;  
                    LegendString{ k}= [   'File pair ' num2str(  k ) ] ;
                 end 
                 
       %        Channel_difference_std - 9 ;
                 data_i= 9 ;
                 for k = 1 : Kpairs
                    Data_Kpairs_std( k )=  All_data_all_exp( k ).TOTAL_RATE_mean( TotalRate_num ).STD_POSITIVE.DATA(data_i).value   ;  
                 end  
%            if ~isempty( Data_Kpairs(:).data )
    
                 XXX = 1 : Kpairs ;
    subplot(Ny,Nx, 2 )
                 barwitherr( Data_Kpairs_std , XXX , Data_Kpairs_mean);
                 % Input - Data_Kpairs , BINS_NUM 
                      
                 title( 'Mean Positive difference')
                 xlabel( 'Pair #')   
                 ylabel( 'Mean difference, spikes') 
%                  Legend( LegendString )
                 %---------------------- 
                 
                 
                 
                 
                 
                      
%               Channel_difference_mean  - 7 ;       
                 data_i= 7 ;
                 for k = 1 : Kpairs
                    Data_Kpairs_mean( k )=  All_data_all_exp( k ).TOTAL_RATE_mean( TotalRate_num ).MEAN_NEGATIVE.DATA(data_i).value   ;  
                    LegendString{ k}= [   'File pair ' num2str(  k ) ] ;
                 end 
                 
       %        Channel_difference_std - 9 ;
                 data_i= 9 ;
                 for k = 1 : Kpairs
                    Data_Kpairs_std( k )=  All_data_all_exp( k ).TOTAL_RATE_mean( TotalRate_num ).STD_NEGATIVE.DATA(data_i).value   ;  
                 end  
%            if ~isempty( Data_Kpairs(:).data )
    
                 XXX = 1 : Kpairs ;
     subplot(Ny,Nx, 3 )
                 barwitherr( Data_Kpairs_std , XXX , Data_Kpairs_mean);
                 % Input - Data_Kpairs , BINS_NUM 
                      
                 title( 'Mean Negative difference')
                 xlabel( 'Pair #')   
                 ylabel( 'Mean difference, spikes') 
%                  Legend( LegendString )
                 %---------------------- 
                 
                 
                 
                 
     
                 
                 
                 
%               Channel_difference_mean_ratio - 6;      
                 data_i= 6 ;
                 for k = 1 : Kpairs
                    Data_Kpairs_mean( k )=  All_data_all_exp( k ).TOTAL_RATE_mean( TotalRate_num ).MEAN_ABS.DATA(data_i).value   ;  
                    LegendString{ k}= [   'File pair ' num2str(  k ) ] ;
                 end 
                 
       %        Channel_difference_std_ratio - 8 ;
                 data_i= 8 ;
                 for k = 1 : Kpairs
                    Data_Kpairs_std( k )=  All_data_all_exp( k ).TOTAL_RATE_mean( TotalRate_num ).STD_ABS.DATA(data_i).value   ;  
                 end  
%            if ~isempty( Data_Kpairs(:).data )
    
                 XXX = 1 : Kpairs ;
     subplot(Ny,Nx, 4 )
                 barwitherr( Data_Kpairs_std , XXX , Data_Kpairs_mean);
                 % Input - Data_Kpairs , BINS_NUM 
                      
                 title( 'Mean abs difference ratio')
                 xlabel( 'Pair #')   
                 ylabel( 'Mean difference ratio, %') 
%                  Legend( LegendString )
                 %---------------------- 
                 
             
                 
                 
                  
                    
%               Channel_difference_mean_ratio - 6;      
                 data_i= 6 ;
                 for k = 1 : Kpairs
                    Data_Kpairs_mean( k )=  All_data_all_exp( k ).TOTAL_RATE_mean( TotalRate_num ).MEAN_POSITIVE.DATA(data_i).value   ;  
                    LegendString{ k}= [   'File pair ' num2str(  k ) ] ;
                 end 
                 
       %        Channel_difference_std_ratio - 8 ;
                 data_i= 8 ;
                 for k = 1 : Kpairs
                    Data_Kpairs_std( k )=  All_data_all_exp( k ).TOTAL_RATE_mean( TotalRate_num ).STD_POSITIVE.DATA(data_i).value   ;  
                 end  
%            if ~isempty( Data_Kpairs(:).data )
    
                 XXX = 1 : Kpairs ;
     subplot(Ny,Nx, 5 )
                 barwitherr( Data_Kpairs_std , XXX , Data_Kpairs_mean);
                 % Input - Data_Kpairs , BINS_NUM 
                      
                 title( 'Mean Positive difference ratio')
                 xlabel( 'Pair #')   
                 ylabel( 'Mean difference ratio, %') 
%                  Legend( LegendString )
                 %---------------------- 
                 
                 
                 
                 
                 
                      
%               Channel_difference_mean_ratio - 6;      
                 data_i= 6 ;
                 for k = 1 : Kpairs
                    Data_Kpairs_mean( k )=  All_data_all_exp( k ).TOTAL_RATE_mean( TotalRate_num ).MEAN_NEGATIVE.DATA(data_i).value   ;  
                    LegendString{ k}= [   'File pair ' num2str(  k ) ] ;
                 end 
                 
       %        Channel_difference_std_ratio - 8 ;
                 data_i= 8 ;
                 for k = 1 : Kpairs
                    Data_Kpairs_std( k )=  All_data_all_exp( k ).TOTAL_RATE_mean( TotalRate_num ).STD_NEGATIVE.DATA(data_i).value   ;  
                 end  
%            if ~isempty( Data_Kpairs(:).data )
    
                 XXX = 1 : Kpairs ;
    subplot(Ny,Nx, 6 )
                 barwitherr( Data_Kpairs_std , XXX , Data_Kpairs_mean);
                 % Input - Data_Kpairs , BINS_NUM 
                      
                 title( 'Mean Negative difference ratio')
                 xlabel( 'Pair #')   
                 ylabel( 'Mean difference ratio, %') 
%                  Legend( LegendString )
                 %---------------------- 
                   
              
                 
                 