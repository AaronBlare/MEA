  
%-- Analyze_list_files_results_show3

ex_n=1;

Nx = 5 ; Ny = 4 ;
fi = 1 ;
DN = 5 ;

ex_list = 1 : Global_flags.Files_in_exeperiment  ;
ex_list_ctrl_data = 1 : Global_flags.file_number_of_change   ;
ex_list_ctrl_data_from2nd = 1 : Global_flags.file_number_of_change - 1 ;

 Connectiv_data_present = false ;
if isfield( ALL_cell , 'Connectiv_data' ) 
   if ~isempty( ALL_cell.Connectiv_data )
       Connectiv_data_present = true ;
   end
end

Default_StatAsterix = '()' ;

StatAsterix='';

ctrl_exp_bar_color = 'b' ;
if Global_flags.file_number_of_change  > 0
    all_bar_color = 'r' ;
else
    all_bar_color = 'b' ;
end

Name_index = strmatch( 'Statistical_ANALYSIS' , ALL_cell.Analysis_data_cell_field_names  ) ;
 mean_burst_parameters =cell2mat( ALL_cell.Analysis_data_cell( : , Name_index(1) )' ); 
 mean_burst_parameters = mean_burst_parameters';
 
 
 
Value_str_to_show_Comp_result_TOTAL_RATE_cell =  Global_flags.List_Files_burst_parameters_values ;  
 
 
 if Global_flags.Chambers_AB_analysis_show 
     Value_str_to_show_Comp_result_TOTAL_RATE_cell = Global_flags.Chambers_AB_Files_burst_parameters ;
     NN = numel( Value_str_to_show_Comp_result_TOTAL_RATE_cell );
    Nx = round( sqrt( NN )+1) ; Ny = round( NN / Nx) ;
    if Nx* Ny < NN
        Nx = Nx + 1 ;
    end
 end
         
 
           figure          
           fi =1 ;
           h_pict = [] ;
for vi = 1 : length( Value_str_to_show_Comp_result_TOTAL_RATE_cell )
    
     Value_str = Value_str_to_show_Comp_result_TOTAL_RATE_cell{ vi }  ; 
  
           Name_index = strmatch( Value_str ,  ALL_cell.Analysis_data_cell_field_names  ) ; 
           Name_index = Name_index(1);
           dat = cell2mat( ALL_cell.Analysis_data_cell( : , Name_index(1) )  );
           
           h = subplot( Ny , Nx , fi );
           h_pict = [ h_pict h ] ;
            hold on
                bar( dat , all_bar_color)
                if Global_flags.file_number_of_change
                    bar( dat(  ex_list_ctrl_data ) , ctrl_exp_bar_color )   
%                     bar( EXP( ex_n ).New_Diss_connes_percent_of_1s_file_all(  ex_list_ctrl_data ) , ctrl_exp_bar_color )  
                end
%                  xlim( [ 0 n_files+1 ] )
                hold off
%                 xlim( [   1  n_files + 1  ] )
                xlabel( 'File number' ) 
%                 ylabel( strrep(Value_str, '_', ' ') )
                title(  strrep(Value_str, '_', ' ') )        
            fi = fi + 1 ;
            %-------------------------------------------------------      
end 
                
    if ~Global_flags.Chambers_AB_analysis_show             
           %-------------------------------------------------------
           h = subplot(Ny,Nx, fi  );
           h_pict = [ h_pict h ] ;
                meanx = mean_burst_parameters( : , 1   ); % Mean_Burst_Duration
                stdx = mean_burst_parameters( : , 2  ); % STD_Burst_Duration
                 
                handles = barwitherr( stdx     , ex_list  ,meanx , 2 );
                axis( [ min( ex_list ) -  1 max( ex_list )  0  1.2* max( meanx ) + max(stdx)  ]   )
                xlim( [ 0 n_files+1 ] )     
                  
%                        Global_flags.histogram_bins_number
                 
%                 errorbar_tick(handles.h, 10 )     
                xlabel( 'File number')
                ylabel('Duration, s')
                title( [ 'Mean_Burst_Duration' StatAsterix ] )                  
                  fi = fi + 1 ;
           %-------------------------------------------------------                 
           h = subplot(Ny,Nx, fi  );
           h_pict = [ h_pict h ] ;
                meanx = mean_burst_parameters( : ,3   ); % Mean_InterBurstInterval
                stdx = mean_burst_parameters( : ,4  ); % STD_InterBurstInterval
                
                
                handles = barwitherr( stdx     , ex_list  ,meanx , 2 );
                     axis( [ min( ex_list ) -  1 max( ex_list )  0  1.2* max( meanx ) + max(stdx)  ]   )
                     xlim( [ 0 n_files+1 ] )
                errorbar_tick(handles.h, 10 )  
                xlabel( 'File number')
                ylabel('Inter Burst Interval, s')
                title( [ 'Mean Inter Burst Interval' StatAsterix ] )   
            fi = fi + 1 ;
           %-------------------------------------------------------                            
           h = subplot(Ny,Nx, fi  );
h_pict = [ h_pict h ] ;
%                Name_index = strmatch( 'Statistical_ANALYSIS' , ALL_cell.Analysis_data_cell_field_names  ) ;
%                StatDiff_if_1 = ANALYSIS_cell.cell_statistics{    Name_index(1) } ;
%                if StatDiff_if_1 == 1 
%                    StatAsterix = ' (*)' ;
%                else
%                    StatAsterix = Default_StatAsterix ;
%                end
%                
%                 dat = cell2mat( ANALYSIS_cell.cell_data(   :  , Name_index(1) ) ) ;               
%                1 Mean_Burst_Duration
%                2 STD_Burst_Duration
%                3 Mean_InterBurstInterval
%                4 STD_InterBurstInterval
%                5 Mean_Burst_FiringRate
%                6 STD_Burst_FiringRate
%                7 Mean_Spike_Rates_each_burst
%                8 STD_Spike_Rates_each_burst
%                9 Spikes_per_sec
%                10 Nb
%                11 N_SB
%                12 mean_Super_Durations
%                13 Active_channels_number  
                meanx = mean_burst_parameters(: , 7  ); % Mean_Spike_Rates_each_burst
                stdx = mean_burst_parameters( : ,8 ); % STD_Spike_Rates_each_burst
                
                
                
                handles = barwitherr( stdx     , ex_list  ,meanx , 2 );
                     axis( [ min( ex_list ) -  1 max( ex_list )  0  1.2* max( meanx ) + max(stdx)  ]   )
                     xlim( [ 0 n_files+1 ] )
                errorbar_tick(handles.h, 10 )                  
                xlabel( 'File number')
                ylabel('Spike rate')
                title( [ 'Burst Spike Rate'  StatAsterix ] )    
     fi = fi + 1 ;
           %-------------------------------------------------------                                            
            
                 
                
            linkaxes( [ h_pict  ] ,'x' );     
                
            
            
 %======== histogram figure ==========================           
%  figure
 
%  Ny = 2 ;
%  Nx = 3 ;
 
                       n_files = Global_flags.Files_in_exeperiment   ;
                       x = 1: n_files ; 
                       y = 1: Global_flags.histogram_bins_number ;
                       bar_y = 1: Global_flags.histogram_bins_number  ;  
  
 
 subplot( Ny , Nx ,  fi   );
 
                      
%              Comp_result_SNames2{ 1 } = 'BurstDurations' ; 
%              Comp_result_SNames2{ 2 } = 'InteBurstInterval'; 
%              Comp_result_SNames2{ 3 } = 'Spike_Rates_each_burst' ; 
%              Comp_result_SNames2{ 4 } = 'Spike_Rates_each_channel_mean' ;            
%              Comp_result_SNames2{ 5 } = 'New_conns_delays' ;
%              Comp_result_SNames2{ 6 } = 'Dissapeared_conns_delays' ;
%              Comp_result_SNames2{ 7 } = 'Connection_delays' ;
                        
                       DataIndex_hist = 1 ; 
                       d2d_hist = zeros( n_files  , Global_flags.histogram_bins_number );  
                       for file_i = 1 : n_files
                        for hx_i = 1: Global_flags.histogram_bins_number  
                            file_i;
                            hx_i;
%                             ANALYSIS_cell.cell_histograms{    DataIndex_hist , file_i , 1 , hx_i } = bar_y( hx_i );
                            d2d_hist(file_i , hx_i ) = ANALYSIS_cell.cell_histograms{    DataIndex_hist  , file_i , 1 , hx_i } ;
%                             xout( hx_i ) = ANALYSIS_cell.cell_histograms{    Name_index  , file_i , 2 , hx_i }  ;
                        end
                       end
                       YStep =  ANALYSIS_cell.cell_histograms{    DataIndex_hist  , 1 , 4 , 1 };
                   
                       d2d_hist = d2d_hist' ;
                       imagesc(  x   , y * YStep  ,  d2d_hist  ); 
                      colorbar    
                      
                       xlabel( 'File number' )
                      ylabel( Comp_result_SNames2{ DataIndex_hist} )                          
                      title( 'Burst durations' )
                      fi = fi + 1 ;
                      
  subplot( Ny , Nx , fi    ); 
                        
                       DataIndex_hist = 2 ; 
                       d2d_hist = zeros( n_files  , Global_flags.histogram_bins_number );  
                       for file_i = 1 : n_files
                        for hx_i = 1: Global_flags.histogram_bins_number   
%                             ANALYSIS_cell.cell_histograms{    DataIndex_hist , file_i , 1 , hx_i } = bar_y( hx_i );
                            d2d_hist(file_i , hx_i ) = ANALYSIS_cell.cell_histograms{    DataIndex_hist  , file_i , 1 , hx_i } ;
%                             xout( hx_i ) = ANALYSIS_cell.cell_histograms{    Name_index  , file_i , 2 , hx_i }  ;
                        end
                       end
                        YStep =  ANALYSIS_cell.cell_histograms{    DataIndex_hist  , 1 , 4 , 1 };
                       d2d_hist = d2d_hist' ;
                       bb= imagesc(  x   , y * YStep,  d2d_hist  ); 
                      colorbar         
                      xlabel( 'File number' )
                      ylabel( Comp_result_SNames2{ DataIndex_hist } ) 
                   
                      
                    title( 'Inter Burst Interval' )
            fi = fi + 1 ;
            
            
            
  subplot( Ny , Nx , fi   );
   
%                        DataIndex_hist = 3 ; 
%                        d2d_hist = zeros( n_files  , Global_flags.histogram_bins_number );  
%                        for file_i = 1 : n_files
%                         for hx_i = 1: Global_flags.histogram_bins_number  
% %                             ANALYSIS_cell.cell_histograms{    DataIndex_hist , file_i , 1 , hx_i } = bar_y( hx_i );
%                             d2d_hist(file_i , hx_i ) = ANALYSIS_cell.cell_histograms{    DataIndex_hist  , file_i , 1 , hx_i } ;
% %                             xout( hx_i ) = ANALYSIS_cell.cell_histograms{    Name_index  , file_i , 2 , hx_i }  ;
%                         end
%                        end
%                         YStep =  ANALYSIS_cell.cell_histograms{    DataIndex_hist  , 1 , 4 , 1 };
%                        d2d_hist = d2d_hist' ;
%                        bb= imagesc(  x   , y * YStep,  d2d_hist  ); 
%                       colorbar               
%                       xlabel( 'File number' )
%                       ylabel( Comp_result_SNames2{ DataIndex_hist} ) 
%                     title( 'Spike Rates per burst' )
                    
                    
                    
                   DataIndex_hist = 3 ; 
                   Comp_result_SNames2{ DataIndex_hist} 
                       d2d_hist = zeros( n_files  , Global_flags.histogram_bins_number );  
                      
                        dat_mean  = ANALYSIS_cell.cell_mean_total{ DataIndex_hist , 3    } ;
                        dat_std =  ANALYSIS_cell.cell_mean_total{  DataIndex_hist  , 5    } ;  
                       
                        if ~isempty( dat_std )
                       handles = barwitherr( dat_std     , ex_list  ,dat_mean , 2 );
                        end
                       
                      colorbar               
                      xlabel( 'File number' )
                      ylabel( Comp_result_SNames2{ DataIndex_hist} ) 
                    title( 'Spike Rates per burst' )
            fi = fi + 1 ;
            
  if Connectiv_data_present          
  subplot( Ny , Nx ,  fi    ); 
                       DataIndex_hist = 7 ; 
                       d2d_hist = zeros( n_files  , Global_flags.histogram_bins_number );  
                       for file_i = 1 : n_files
                        for hx_i = 1: Global_flags.histogram_bins_number  
%                             ANALYSIS_cell.cell_histograms{    DataIndex_hist , file_i , 1 , hx_i } = bar_y( hx_i );
                            d2d_hist(file_i , hx_i ) = ANALYSIS_cell.cell_histograms{    DataIndex_hist  , file_i , 3 , hx_i } ;
%                             xout( hx_i ) = ANALYSIS_cell.cell_histograms{    Name_index  , file_i , 2 , hx_i }  ;
                        end
                       end
                        YStep =  ANALYSIS_cell.cell_histograms{    DataIndex_hist  , 1 , 4 , 1 };
%                        d2d_hist = d2d_hist' ;
                        if ~isempty( YStep )
                       bb2= imagesc(  x   , y * YStep,  d2d_hist  ); 
                        end
                      colorbar               
                      xlabel( 'File number' )
                      ylabel( 'Connection delays, ms' ) 
                    title( 'Connection delays histogram' )     
                    fi = fi + 1 ;
  end
  
    end
                     
                    
                    
            
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
            
                