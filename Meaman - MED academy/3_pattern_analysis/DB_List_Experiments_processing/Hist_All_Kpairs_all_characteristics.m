

            %  Hist_All_Kpairs_all_characteristics
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
                 
                 for k = 1 : Kpairs
                    Data_Kpairs( k ).data = All_data_all_exp( k ).TOTAL_RATE( TotalRate_num ).all_exp_diff_mean  ;  
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
                 
                 % --- Mean difference
                 for k = 1 : Kpairs
                    Data_Kpairs( k ).data = All_data_all_exp( k ).TOTAL_RATE( TotalRate_num ).all_exp_diff_std ;  
                 end  
    
            subplot(Ny,Nx, 2 )
                 Hist_all_Kpairs
                 % Input - Data_Kpairs , BINS_NUM 
                      
                 title( 'SR std difference')
                 xlabel( 'std diff.')   
                 ylabel( 'Count, %') 
                 %----------------------
                 
                 % --- Mean difference
                 for k = 1 : Kpairs
                    Data_Kpairs( k ).data = All_data_all_exp( k ).TOTAL_RATE( TotalRate_num ).all_exp_diff_mean_ratio ;  
                    Data_Kpairs( k ).data( Data_Kpairs( k ).data > DataHist_Limit ) = [] ;
                    Data_Kpairs( k ).data( Data_Kpairs( k ).data < -DataHist_Limit ) = [] ;
                    Data_Kpairs( k ).data( isinf( Data_Kpairs( k ).data)) = [] ; 
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
                 
                 % --- Mean difference
                 for k = 1 : Kpairs
                    Data_Kpairs( k ).data = All_data_all_exp( k ).TOTAL_RATE( TotalRate_num ).all_exp_diff_std_ratio ;  
                    Data_Kpairs( k ).data( Data_Kpairs( k ).data > DataHist_Limit  ) = [] ;
                    Data_Kpairs( k ).data( Data_Kpairs( k ).data < -DataHist_Limit ) = [] ;
                    Data_Kpairs( k ).data( isinf( Data_Kpairs( k ).data)) = [] ;
                 end  
    
            subplot(Ny,Nx, 4 )
                 Hist_all_Kpairs
                 % Input - Data_Kpairs , BINS_NUM 
                      
                 title( 'SR std difference ratio')
                 xlabel( 'std diff. ratio')   
                 ylabel( 'Count, %') 
                 %----------------------
                 
                 % --- Mean difference
                 for k = 1 : Kpairs
                    Data_Kpairs( k ).data = All_data_all_exp( k ).TOTAL_RATE( TotalRate_num ).all_exp_Channels_overlap ;  
                 end  
    
           subplot(Ny,Nx, 5 )
                 BINS_NUM = 10  ;  
                 Hist_all_Kpairs
                 % Input - Data_Kpairs , BINS_NUM 
                      
                 title( 'SR Overlaps')
                 xlabel( 'Overlaps')   
                 ylabel( 'Count, %') 
                 %----------------------   
                 
             
                 
                 
                 
                 
                 
                 
                 
                 
                 