

            %  Hist_All_Kpairs_all_characteristics_from_matrix
            
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
            
 DataHist_Limit = 1000 ; 
 
 
             f=figure ;
             set(f,'name', FigureName  ,'numbertitle','off')
             Nx = 3 ; Ny = 2 ;
             BINS_NUM = 30  ;  
             
             %---Filter all_exp_diff_mean_ratio all_exp_diff_std_ratio
             %higher or lower than this limit
                  
            
   
                 % --- Mean difference
                 LegendString = {};
                 
%              Channel_difference_mean  - 7 ;                 
                 data_i= 7 ;
                 for k = 1 : Kpairs
                    if ~isempty( All_data_all_exp( k ).TOTAL_RATE( TotalRate_num ).DATA(data_i).data_vector  )
                        Data_Kpairs( k ).data = ( All_data_all_exp( k ).TOTAL_RATE( TotalRate_num ).DATA(data_i).data_vector  );
                    end
                    LegendString{ k}= [   'File pair ' num2str(  k ) ] ;
                 end 
       
%            if ~isempty( Data_Kpairs(:).data )
    
                 
             subplot(Ny,Nx, 1 )
                 Hist_all_Kpairs
                 % Input - Data_Kpairs , BINS_NUM 
                      
                 title( 'SR mean difference')
                 xlabel( 'mean diff.')   
                 ylabel( 'Count, %') 
                 Legend( LegendString )
                 %----------------------
                 
%              Channel_difference_std - 9 ;
                 data_i= 9 ;
                 for k = 1 : Kpairs
                    if ~isempty( All_data_all_exp( k ).TOTAL_RATE( TotalRate_num ).DATA(data_i).data_vector  )
                        Data_Kpairs( k ).data = ( All_data_all_exp( k ).TOTAL_RATE( TotalRate_num ).DATA(data_i).data_vector  );
                    end
                 end  
    
            subplot(Ny,Nx, 2 )
                 Hist_all_Kpairs
                 % Input - Data_Kpairs , BINS_NUM 
                      
                 title( 'SR std difference')
                 xlabel( 'std diff.')   
                 ylabel( 'Count, %') 
                 %----------------------

  %              Channel_difference_mean_ratio - 6   ;
                 data_i= 6 ;
                 for k = 1 : Kpairs
                    if ~isempty( All_data_all_exp( k ).TOTAL_RATE( TotalRate_num ).DATA(data_i).data_vector  )
                        Data_Kpairs( k ).data = ( All_data_all_exp( k ).TOTAL_RATE( TotalRate_num ).DATA(data_i).data_vector  );
                       
%                     Data_Kpairs( k ).data( Data_Kpairs( k ).data > DataHist_Limit ) = [] ;
%                     Data_Kpairs( k ).data( Data_Kpairs( k ).data < -DataHist_Limit ) = [] ;
%                     Data_Kpairs( k ).data( isinf( Data_Kpairs( k ).data) ) = [] ; 

                    %-- Filter "bad" response ratio 
                    Data_Kpairs( k ).data = Data_erase_Bad_values( Data_Kpairs( k ).data , data_i , Global_flags ) ;
                    end
                 end  
    
            subplot(Ny,Nx, 3 )
            
                BINS_NUM = 0  ;
                BINS_fixed = Global_flags.Bin_hist_ratio ;
                 Hist_all_Kpairs
                 % Input - Data_Kpairs , BINS_NUM 
                      
                 title( 'SR mean difference ratio')
                 xlabel( 'mean diff. ratio')   
                 ylabel( 'Count, %') 
                 %----------------------
                 
                 % Channel_difference_std_ratio - 8 ;
                 data_i= 8 ;
                 for k = 1 : Kpairs
                    if ~isempty( All_data_all_exp( k ).TOTAL_RATE( TotalRate_num ).DATA(data_i).data_vector  )
                        Data_Kpairs( k ).data = ( All_data_all_exp( k ).TOTAL_RATE( TotalRate_num ).DATA(data_i).data_vector  );
                     
%                     Data_Kpairs( k ).data( Data_Kpairs( k ).data > DataHist_Limit  ) = [] ;
%                     Data_Kpairs( k ).data( Data_Kpairs( k ).data < -DataHist_Limit ) = [] ;
%                     Data_Kpairs( k ).data( isinf( Data_Kpairs( k ).data)) = [] ;
                    Data_Kpairs( k ).data = Data_erase_Bad_values( Data_Kpairs( k ).data , data_i , Global_flags )   ;
                    end
                 end  
    
            subplot(Ny,Nx, 4 )
                 Hist_all_Kpairs
                 % Input - Data_Kpairs , BINS_NUM 
                      
                 title( 'SR std difference ratio')
                 xlabel( 'std diff. ratio')   
                 ylabel( 'Count, %') 
                 %----------------------
                 
                 % --- Channels_overlap - 10  ;
                 data_i= 10 ;
                 for k = 1 : Kpairs
                    if ~isempty( All_data_all_exp( k ).TOTAL_RATE( TotalRate_num ).DATA(data_i).data_vector  )
                        Data_Kpairs( k ).data = ( All_data_all_exp( k ).TOTAL_RATE( TotalRate_num ).DATA(data_i).data_vector  );
                    end
                 end  
    
           subplot(Ny,Nx, 5 )
                 BINS_NUM = 10  ;  
                 Hist_all_Kpairs
                 % Input - Data_Kpairs , BINS_NUM 
                      
                 title( 'SR Overlaps')
                 xlabel( 'Overlaps')   
                 ylabel( 'Count, %') 
                 %----------------------   
                 
             
                 
                 
                 
                 
                 
                 
                 
                 
                 