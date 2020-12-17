
%-- Connectiv_compare_results_show

ex_n=1;

Nx = 5 ; Ny = 3 ;
fi = 1 ;
DN = 5 ;

Cmp_type_num = var.Cmp_type_num ;

ex_list = 1 : Global_flags.Files_in_exeperiment   ;
ex_list_ctrl_data = 1 : Global_flags.file_number_of_change   ;
ex_list_ctrl_data_from2nd = 1 : Global_flags.file_number_of_change - 1 ;

Default_StatAsterix = '()' ;

ctrl_exp_bar_color = 'b' ;
if Global_flags.file_number_of_change  > 0
    all_bar_color = 'r' ;
else
    all_bar_color = 'b' ;
end


 Name_index = strmatch( 'Statistical_ANALYSIS' , ALL_cell.All_files_data_TOTAL_cell_filed_names  ) ;
 mean_burst_parameters =cell2mat( ALL_cell.Analysis_data_cell( : , Name_index(1) )' ); 
 mean_burst_parameters = mean_burst_parameters';
           


           figure          
           
           h01 = subplot(Ny,Nx, fi+0 );
           
           Name_index = strmatch( 'Total_spikes_number' , ALL_cell.All_files_data_TOTAL_cell_filed_names  ) ;
           dat =cell2mat( ALL_cell.Analysis_data_cell( : , Name_index ) ); 
           
%            Name_index = strmatch( 'Number_Spikes' , Comp_result_SNames  ) ;
           StatDiff_if_1 = ANALYSIS_cell.cell_statistics{   Name_index } ;
           if StatDiff_if_1 == 1 
               StatAsterix = ' (*)' ;
           else
               StatAsterix = Default_StatAsterix ;
           end
%            dat = cell2mat( ANALYSIS_cell.cell_data(  :  , Name_index(1) ) ) ;   
%            dat = EXP( ex_n ).Number_Spikes ; 

           
           hold on
                bar( dat , all_bar_color )
                if Global_flags.file_number_of_change
                    bar( dat(  ex_list_ctrl_data ) , ctrl_exp_bar_color )                
                end
           hold off     
                xlabel( 'File number')
                xlim( [ 0 n_files+2 ] )
                ylabel('Spikes total number')
                title([ 'Total spikes' StatAsterix ])  
                
                
           %-------------------------------------------------------     
           h02 = subplot(Ny,Nx, fi+1 );
           
           Name_index = strmatch( 'Number_of_bursts' , ALL_cell.All_files_data_TOTAL_cell_filed_names  ) ;
           dat =cell2mat( ALL_cell.Analysis_data_cell( : , Name_index(1) ) ); 
           
%                Name_index = strmatch( 'Burst_rate_number' , Comp_result_SNames  ) ;
               StatDiff_if_1 = ANALYSIS_cell.cell_statistics{   Name_index } ;
               if StatDiff_if_1 == 1 
                   StatAsterix = ' (*)' ;
               else
                   StatAsterix = Default_StatAsterix ;
               end
           
%                 bar( EXP( ex_n ).Burst_rate_b_per_min  )
                hold on
                bar( dat , all_bar_color )  
                if Global_flags.file_number_of_change
                    bar( dat(  ex_list_ctrl_data ) , ctrl_exp_bar_color )                
                end
                hold off
                xlim( [ 0 n_files+2 ] )
                xlabel( 'File number')
                ylabel('Bursts number')
%                 ylabel('Bursts per sec')                
                title( [ 'Burst rate' StatAsterix ] )                    
          
           %-------------------------------------------------------
           h03 = subplot(Ny,Nx, fi+2 );
           
%                Name_index = strmatch( 'BurstDurations_mean' , Comp_result_SNames  ) ;
                
           
%                StatDiff_if_1 = ANALYSIS_cell.cell_statistics{   Name_index } ;
%                if StatDiff_if_1 == 1 
%                    StatAsterix = ' (*)' ;
%                else
%                    StatAsterix = Default_StatAsterix ;
%                end
               
%                 bar( EXP( ex_n ).BurstDurations_mean  )
%                  meanx =   EXP( ex_n ).BurstDurations_mean ;
%                  stdx =    EXP( ex_n ).BurstDurations_std ;
               meanx = mean_burst_parameters( : , 1 ) * 100;
               stdx =   mean_burst_parameters( : , 2 ) * 100;

                handles = barwitherr( stdx     , ex_list  ,meanx , 2 );
                axis( [ min( ex_list ) -  1 max( ex_list )  0  1.2* max( meanx ) + max(stdx)  ]   )
                   xlim( [ 0 n_files+2 ] )  
                  
%                        Global_flags.histogram_bins_number
                 
%                 errorbar_tick(handles.h, 10 )     
                xlabel( 'File number')
                ylabel('Duration, ms')
                title( [ 'Burst durations' StatAsterix ] )   
                
                 
           %-------------------------------------------------------                 
           h04 = subplot(Ny,Nx, fi+3 );
           
%                Name_index = strmatch( 'InteBurstInterval_mean' , Comp_result_SNames  ) ;
%                StatDiff_if_1 = ANALYSIS_cell.cell_statistics{   Name_index } ;
%                if StatDiff_if_1 == 1 
%                    StatAsterix = ' (*)' ;
%                else
%                    StatAsterix = Default_StatAsterix ;
%                end
               
%                 bar( EXP( ex_n ).InteBurstInterval_mean  )
%                 meanx =   EXP( ex_n ).InteBurstInterval_mean ;
%                  stdx =    EXP( ex_n ).InteBurstInterval_std ;
               meanx = mean_burst_parameters( : , 3 ) * 100;
               stdx =   mean_burst_parameters( : , 4 )* 100 ;
               
                handles = barwitherr( stdx     , ex_list  ,meanx , 2 );
                     axis( [ min( ex_list ) -  1 max( ex_list )  0  1.2* max( meanx ) + max(stdx)  ]   )
                     xlim( [ 0 n_files+2 ] )
                errorbar_tick(handles.h, 10 )  
                xlabel( 'File number')
                ylabel('Inter Burst Interval, ms')
                title( [ 'Mean Inter Burst Interval' StatAsterix ] )   
           
           %-------------------------------------------------------                            
           h05 = subplot(Ny,Nx, fi+4 );

%                Name_index = strmatch( 'Spike_Rates_each_burst_mean' , Comp_result_SNames  ) ;
%                StatDiff_if_1 = ANALYSIS_cell.cell_statistics{   Name_index } ;
%                if StatDiff_if_1 == 1 
%                    StatAsterix = ' (*)' ;
%                else
%                    StatAsterix = Default_StatAsterix ;
%                end
%                
               meanx = mean_burst_parameters( : , 7 ) ;
               stdx =   mean_burst_parameters( : , 8 ) ;

%                 bar( EXP( ex_n ).Spike_Rates_each_burst_mean  )
%                 meanx =   EXP( ex_n ).Spike_Rates_each_burst_mean ;
%                  stdx =    EXP( ex_n ).Spike_Rates_each_burst_std ;
                handles = barwitherr( stdx     , ex_list  ,meanx , 2 );
                     axis( [ min( ex_list ) -  1 max( ex_list )  0  1.2* max( meanx ) + max(stdx)  ]   )
                     xlim( [ 0 n_files+2 ] )
                errorbar_tick(handles.h, 10 )                  
                xlabel( 'File number')
                ylabel('Spike rate')
                title( [ 'Burst Spike Rate mean'  StatAsterix ] )    
    
           %-------------------------------------------------------                                            
%              h06 = subplot(Ny,Nx, fi+5 );  
% 
%                 Name_index = strmatch( 'Number_of_Superbursts' , Comp_result_SNames  ) ;
%                StatDiff_if_1 = ANALYSIS_cell.cell_statistics{   Name_index } ;
%                if StatDiff_if_1 == 1 
%                    StatAsterix = ' (*)' ;
%                else
%                    StatAsterix = Default_StatAsterix ;
%                end
%                
%                
%                 hold on
%                 bar( EXP( ex_n ).Number_of_Superbursts  , all_bar_color)
%                 if Global_flags.file_number_of_change
%                     bar( EXP( ex_n ).Number_of_Superbursts(  ex_list_ctrl_data ) , ctrl_exp_bar_color )                
%                 end
%                 hold off
%                 xlim( [ 0 n_files+2 ] )
%                 xlabel( 'File number')
%                 ylabel('Number of Superbursts')
%                 title( [ 'Superbursts in raster'  StatAsterix ] )    
                
              h06 = subplot(Ny,Nx, fi+5 );  
% 
                Name_index = strmatch( 'Active_channels_number' , ALL_cell.All_files_data_TOTAL_cell_filed_names  ) ;
               dat =cell2mat( ALL_cell.Analysis_data_cell( : , Name_index ) ); 

    %            Name_index = strmatch( 'Number_Spikes' , Comp_result_SNames  ) ;
               StatDiff_if_1 = ANALYSIS_cell.cell_statistics{    Name_index } ;
               if StatDiff_if_1 == 1 
                   StatAsterix = ' (*)' ;
               else
                   StatAsterix = Default_StatAsterix ;
               end
    %            dat = cell2mat( ANALYSIS_cell.cell_data(  :  , Name_index(1) ) ) ;   
    %            dat = EXP( ex_n ).Number_Spikes ; 


               hold on
                    bar( dat , all_bar_color )
                    if Global_flags.file_number_of_change
                        bar( dat(  ex_list_ctrl_data ) , ctrl_exp_bar_color )                
                    end
               hold off      
                xlim( [ 0 n_files+2 ] )
                xlabel( 'File number')
                ylabel('Active channels')
                title('Active channels number') 
                
                
                
                
                
                
            %-------------------------------------------------------                                           
            h2 = subplot(Ny,Nx, fi+ DN + 1 );
            
%                Name_index = strmatch( 'Number_of_Connections' , Comp_result_SNames  ) ;
%                StatDiff_if_1 = ANALYSIS_cell.cell_statistics{   Name_index } ;
%                if StatDiff_if_1 == 1 
%                    StatAsterix = ' (*)' ;
%                else
%                    StatAsterix = Default_StatAsterix ;
%                end
               
               
%                 hold on
%                 bar( EXP( ex_n ).Number_of_Connections , all_bar_color )
%                 if Global_flags.file_number_of_change
%                     bar( EXP( ex_n ).Number_of_Connections(  ex_list_ctrl_data ) , ctrl_exp_bar_color )                
%                 end
%                 hold off

%                 Name_index = strmatch( 'Number_of_Connections' , ALL_cell.All_files_data_TOTAL_cell_filed_names  ) ;
               dat = [ALL_cell.Connectiv_data(:).Number_of_Connections] ; 
 
               
               hold on
                    bar( dat , all_bar_color )
                    if Global_flags.file_number_of_change
                        bar( dat(  ex_list_ctrl_data ) , ctrl_exp_bar_color )                
                    end
               hold off 
                xlim( [ 0 n_files+2 ] )
                xlabel( 'File number')
                ylabel('Connections number')
                title([ 'Number of connections'  StatAsterix ] )            
           
            %-------------------------------------------------------                                      
           h3 = subplot(Ny,Nx, fi+ DN +  2 );
          
           
           Name_index = strmatch( 'New_Diss_connes_percent_of_1s_file' , ALL_cell.Comp_type( Cmp_type_num ).Comp_result_Names  ) ; 
           dat = cell2mat( ALL_cell.Comp_type( Cmp_type_num ).Comp_result_cell(: , Name_index ) );
           
            hold on
                bar( dat , all_bar_color)
                if Global_flags.file_number_of_change
                    bar( dat(  ex_list_ctrl_data ) , ctrl_exp_bar_color )   
%                     bar( EXP( ex_n ).New_Diss_connes_percent_of_1s_file_all(  ex_list_ctrl_data ) , ctrl_exp_bar_color )  
                end
                hold off
                
                xlabel( 'File number')
                ylabel('Connections changed, %')
                title('Connectivity change (100*dN/N)')
                
           h4 = subplot(Ny,Nx, fi+ DN +  3 );
                      Name_index = strmatch( 'New_conns_percent_of_1st_file' , ALL_cell.Comp_type( Cmp_type_num ).Comp_result_Names  ) ; 
               dat = cell2mat( ALL_cell.Comp_type( Cmp_type_num ).Comp_result_cell(: , Name_index ) );
         
           
                hold on
                bar( dat , all_bar_color)
                if Global_flags.file_number_of_change
                    bar( dat(  ex_list_ctrl_data ) , ctrl_exp_bar_color )                
                end
                hold off
                xlim( [ 0 n_files+2 ] )
                xlabel( 'File number')
                ylabel('Connections, %')
                title('New connections, %')    
           
           h5 = subplot(Ny,Nx, fi+DN + 4 );
                Name_index = strmatch( 'Dissapeared_conns_percent_of_1st_file' , ALL_cell.Comp_type( Cmp_type_num ).Comp_result_Names  ) ; 
               dat = cell2mat( ALL_cell.Comp_type( Cmp_type_num ).Comp_result_cell(: , Name_index ) );
           
           hold on
                bar( dat , all_bar_color)
                if Global_flags.file_number_of_change
                    bar( dat(  ex_list_ctrl_data ) , ctrl_exp_bar_color )                
                end
                hold off
                
                xlabel( 'File number')
                ylabel('Connections, %')
                title('Dissapeared connections, %')   
                
           h6 = subplot(Ny,Nx, fi+DN + 5 );
                 Name_index = strmatch( 'Mean_M_abs_difference_common_connections' , ALL_cell.Comp_type( Cmp_type_num ).Comp_result_Names  ) ; 

                 
               dat = cell2mat( ALL_cell.Comp_type( Cmp_type_num ).Comp_result_cell(: , Name_index ) );
                  hold on
                bar(  dat , all_bar_color )
                if Global_flags.file_number_of_change
                    bar( dat(  ex_list_ctrl_data ) , ctrl_exp_bar_color )                
                end
                hold off
                xlim( [ 0 n_files+2 ] )
                xlabel( 'File number')
                ylabel('Strength change, %')
                title('Stable connections strength change (abs)')    
%                 title('Stable connections strength change')    
                
           h7 = subplot(Ny,Nx, fi+DN + 6 );
                 Name_index = strmatch( 'Mean_M_difference_common_connections' , ALL_cell.Comp_type( Cmp_type_num ).Comp_result_Names  ) ;                  
%                  Name_index = strmatch( 'Mean_M_abs_difference_unstable_connections' , ALL_cell.Comp_result_Names  ) ; 
               dat = cell2mat( ALL_cell.Comp_type( Cmp_type_num ).Comp_result_cell(: , Name_index ) );
                 hold on
                bar(  dat , all_bar_color )
                if Global_flags.file_number_of_change
                    bar( dat(  ex_list_ctrl_data ) , ctrl_exp_bar_color )                
                end
                hold off           
                xlim( [ 0 n_files+2 ] )
                xlabel( 'File number')
                ylabel('Strength change, %')
%                 title('New & Dissapeared Connections strength change')     
                title('Stable connections strength change')    
                
                
           h8 = subplot(Ny,Nx, fi+DN + 7 );
%                 dat = [ALL_cell.Connectiv_data(:).Number_adequate_channels] ;
%            
%                 hold on
%                 bar(  dat , all_bar_color )
%                 if Global_flags.file_number_of_change
%                     bar( dat(  ex_list_ctrl_data ) , ctrl_exp_bar_color )                
%                 end
%                 hold off  
%                 xlim( [ 0 n_files+2 ] )
%                 xlabel( 'File number')
%                 ylabel('N conn')
%                 title('Number_adequate_channels')

                Name_index = strmatch( 'New_conns_mean_delay' , ALL_cell.Comp_type( Cmp_type_num ).Comp_result_Names  ) ; 
               dat = cell2mat( ALL_cell.Comp_type( Cmp_type_num ).Comp_result_cell(: , Name_index ) );

                 hold on
                bar(  dat , all_bar_color )
                if Global_flags.file_number_of_change
                    bar( dat(  ex_list_ctrl_data ) , ctrl_exp_bar_color )                
                end
                hold off  
                xlim( [ 0 n_files+2 ] )
                xlabel( 'File number')
                ylabel('Mean delay, ms')
                title('New Connections delays mean')                 
%                 
                
                
            h9 = subplot(Ny,Nx, fi+DN + 8 );
            
            %---------- Extract data from Analyzed_dara  for all files -------------
%                     sn = All_files_data_TOTAL_cell_filed_names ;
%                     Name_index = strmatch( 'Active_channels_number' , All_files_data_TOTAL_cell_filed_names  ) ;
%                     dat=[];
%                     for fil =  1 : n_files
%                     c =   All_files_data_TOTAL_cell{ 1 , fil }{ Name_index(1) }          
%                     dat = [dat c ];
%                     end
            %--------------------------------------------------------------
            
            
%                 hold on
%                 bar(  dat , all_bar_color )
%                 if Global_flags.file_number_of_change
%                     bar( dat(  ex_list_ctrl_data ) , ctrl_exp_bar_color )                
%                 end
%                 hold off  
%                 xlim( [ 0 n_files+2 ] )
%                 xlabel( 'File number')
%                 ylabel('Channels #')
%                 title('Active_channels_number')     
 
                 
                Name_index = strmatch( 'Dissapeared_conns_mean_delay' , ALL_cell.Comp_type( Cmp_type_num ).Comp_result_Names  ) ; 
               dat = cell2mat( ALL_cell.Comp_type( Cmp_type_num ).Comp_result_cell(: , Name_index ) );

                 hold on
                bar(  dat , all_bar_color )
                if Global_flags.file_number_of_change
                    bar( dat(  ex_list_ctrl_data ) , ctrl_exp_bar_color )                
                end
                
%                 bar(  EXP( ex_n ).Dissapeared_conns_mean_delay_all , all_bar_color )
%                 if Global_flags.file_number_of_change
%                     bar( EXP( ex_n ).Dissapeared_conns_mean_delay_all(  ex_list_ctrl_data ) , ctrl_exp_bar_color )                
%                 end
%                 hold off  
                xlim( [ -1 n_files+1 ] )
                xlabel( 'File number')
                ylabel('Mean delay, ms')
                title('Dissapeared Connections delay mean')     
                
                
                
            h10 = subplot(Ny,Nx, fi+DN + 9 );
            
            
            
              Name_index = strmatch( 'Mean_tau_max_difference_common_connections' , ALL_cell.Comp_type( Cmp_type_num ).Comp_result_Names  ) ; 
               dat = cell2mat( ALL_cell.Comp_type( Cmp_type_num ).Comp_result_cell(: , Name_index ) );

                 hold on
                bar(  dat , all_bar_color )
                if Global_flags.file_number_of_change
                    bar( dat(  ex_list_ctrl_data ) , ctrl_exp_bar_color )                
                end 
                xlim( [ -1 n_files+1 ] )
                xlabel( 'File number')
                ylabel('Delay increase, ms')
                title('Common conn-s delay change')         
            
%             Name_index = strmatch( 'Small_bursts_number' , ALL_cell.All_files_data_TOTAL_cell_filed_names  ) ;
%            dat =cell2mat( ALL_cell.Analysis_data_cell( : , Name_index ) ); 
%             
% %                 loopIndex =  strmatch( 'Small_bursts_number1' , Comp_type( Cmp_type_num ).Comp_result_SNames  ) ;
% %                 if ~isempty( loopIndex )
% %                 data = ANALYSIS_cell.cell_data(  :  , loopIndex(1) ) ;
% %                 data_ctrl = ANALYSIS_cell.cell_data(  ex_list_ctrl_data  , loopIndex(1) ) ;                
%                 hold on
%                 bar(  dat  , all_bar_color )
%                 if Global_flags.file_number_of_change
%                     bar( dat   , ctrl_exp_bar_color )                
%                 end
%                 hold off  
%                 xlim( [ 0 n_files+2 ] )
%                 xlabel( 'File number')
%                 ylabel('Bursts number')
%                 title('Number of small bursts')                 
                 
            linkaxes( [ h01 h02 h03 h04 h05 h06 h2 h3 h4 h5 h6 h7 h8 h9 h10 ] ,'x' );     
                
            
            
 %======== histogram figure ==========================           
 figure
 
 Ny = 2 ;
 Nx = 3 ;
 
                       Files_N = Global_flags.Files_in_exeperiment   ;
                       x = 1: Files_N ; 
                       y = 1: Global_flags.histogram_bins_number ;
                       bar_y = 1: Global_flags.histogram_bins_number  ;  
 
 
 subplot( Ny , Nx , 1  );
 
                      
                       
                        
                       DataIndex = 1 ; 
                       d2d_hist = zeros( Files_N  , Global_flags.histogram_bins_number );  
                       for file_i = 1 : Files_N
                        for hx_i = 1: Global_flags.histogram_bins_number  
%                             ANALYSIS_cell.cell_histograms{   DataIndex  , file_i , 1 , hx_i } = bar_y( hx_i );
                            d2d_hist(file_i , hx_i ) = ANALYSIS_cell.cell_histograms{  DataIndex  , file_i , 1 , hx_i } ;
%                             xout( hx_i ) = ANALYSIS_cell.cell_histograms{   Name_index  , file_i , 2 , hx_i }  ;
                        end
                       end
                       YStep =  ANALYSIS_cell.cell_histograms{   DataIndex  , 1 , 4 , 1 };
                   
                       d2d_hist = d2d_hist' ;
                       imagesc(  x   , y * YStep  ,  d2d_hist  ); 
                      colorbar    
                      
                       xlabel( 'File number' )
                      ylabel( ANALYSIS_cell.Comp_result_Hist_fieldnames { DataIndex } )                          
                      title( ANALYSIS_cell.Comp_result_Hist_fieldnames { DataIndex })
                      
                      
  subplot( Ny , Nx , 2  ); 
                        
                       DataIndex = 2 ; 
                       d2d_hist = zeros( Files_N  , Global_flags.histogram_bins_number );  
                       for file_i = 1 : Files_N
                        for hx_i = 1: Global_flags.histogram_bins_number   
%                             ANALYSIS_cell.cell_histograms{   DataIndex  , file_i , 1 , hx_i } = bar_y( hx_i );
                            d2d_hist(file_i , hx_i ) = ANALYSIS_cell.cell_histograms{  DataIndex  , file_i , 1 , hx_i } ;
%                             xout( hx_i ) = ANALYSIS_cell.cell_histograms{   Name_index  , file_i , 2 , hx_i }  ;
                        end
                       end
                        YStep =  ANALYSIS_cell.cell_histograms{   DataIndex  , 1 , 4 , 1 };
                       d2d_hist = d2d_hist' ;
                       bb= imagesc(  x   , y * YStep,  d2d_hist  ); 
                      colorbar         
                      xlabel( 'File number' )
                      ylabel( ANALYSIS_cell.Comp_result_Hist_fieldnames { DataIndex } ) 
                   
                      
                    title( ANALYSIS_cell.Comp_result_Hist_fieldnames { DataIndex })
            
            
            
            
  subplot( Ny , Nx , 3  );
  
                        
                       DataIndex = 3 ; 
                       d2d_hist = zeros( Files_N  , Global_flags.histogram_bins_number );  
                       for file_i = 1 : Files_N
                        for hx_i = 1: Global_flags.histogram_bins_number  
%                             ANALYSIS_cell.cell_histograms{   DataIndex  , file_i , 1 , hx_i } = bar_y( hx_i );
                            d2d_hist(file_i , hx_i ) = ANALYSIS_cell.cell_histograms{   DataIndex  , file_i , 1 , hx_i } ;
%                             xout( hx_i ) = ANALYSIS_cell.cell_histograms{   Name_index  , file_i , 2 , hx_i }  ;
                        end
                       end
                        YStep =  ANALYSIS_cell.cell_histograms{   DataIndex  , 1 , 4 , 1 };
                       d2d_hist = d2d_hist' ;
                       bb= imagesc(  x   , y * YStep,  d2d_hist  ); 
                      colorbar               
                      xlabel( 'File number' )
                      ylabel( ANALYSIS_cell.Comp_result_Hist_fieldnames { DataIndex } ) 
                    title( ANALYSIS_cell.Comp_result_Hist_fieldnames { DataIndex })
                    
            
            
            
%   subplot( Ny , Nx , 4  ); 
%   
%                        DataIndex = 7 ; 
%                        d2d_hist = zeros( Files_N  , Global_flags.histogram_bins_number );  
%                        for file_i = 1 : Files_N
%                         for hx_i = 1: Global_flags.histogram_bins_number  
% %                             ANALYSIS_cell.cell_histograms{   DataIndex  , file_i , 1 , hx_i } = bar_y( hx_i );
%                             d2d_hist(file_i , hx_i ) = ANALYSIS_cell.cell_histograms{   DataIndex  , file_i , 1 , hx_i } ;
% %                             xout( hx_i ) = ANALYSIS_cell.cell_histograms{   Name_index  , file_i , 2 , hx_i }  ;
%                         end
%                        end
% 
%                         YStep =  ANALYSIS_cell.cell_histograms{   DataIndex  , 1 , 4 , 1 };
%                        d2d_hist = d2d_hist' ;
%                        if YStep > 0 
%                         bb= imagesc(  x   , y * YStep,  d2d_hist  ); 
%                        end
%                       colorbar               
%                        xlabel( 'File number' )
%                       ylabel( ANALYSIS_cell.Comp_result_Hist_fieldnames { DataIndex } )            
%                       title( 'Spikerate per channel, burst' )       
                      
              
  subplot( Ny , Nx , 4  ); 
  
                       DataIndex = 5 ; 
%                        a=ANALYSIS_cell.cell_histograms;
                       whos a
%                        a{   DataIndex  , 1 , 5 , 1 } 
                       files_N =  ANALYSIS_cell.cell_histograms{   DataIndex  , 1 , 5 , 1 } ;
                       d2d_hist = zeros( files_N   , Global_flags.histogram_bins_number );  
                       for file_i = 1 : files_N 
                        for hx_i = 1: Global_flags.histogram_bins_number  
%                             ANALYSIS_cell.cell_histograms{   DataIndex  , file_i , 1 , hx_i } = bar_y( hx_i );
                            d2d_hist(file_i , hx_i ) = ANALYSIS_cell.cell_histograms{   DataIndex  , file_i , 3 , hx_i } ;
%                             xout( hx_i ) = ANALYSIS_cell.cell_histograms{   Name_index  , file_i , 2 , hx_i }  ;
                        end
                       end

                        YStep =  ANALYSIS_cell.cell_histograms{   DataIndex  , 1 , 4 , 1 };
                       d2d_hist = d2d_hist' ;
                       if YStep > 0 
                        bb= imagesc(  x   , y * YStep,  d2d_hist  ); 
                       end
                      colorbar               
                       xlabel( 'File number' )
                      ylabel( ANALYSIS_cell.Comp_result_Hist_fieldnames { DataIndex } )            
                      title( 'New connections delays' )                 
                    
                    
   subplot( Ny , Nx , 5  );       
                        
                       DataIndex = 6 ; 
                       d2d_hist = zeros( ANALYSIS_cell.cell_histograms{   DataIndex  , 1 , 5 , 1 }   , Global_flags.histogram_bins_number );  
                       for file_i = 1 : ANALYSIS_cell.cell_histograms{   DataIndex  , 1 , 5 , 1 } 
                        for hx_i = 1: Global_flags.histogram_bins_number  
%                             ANALYSIS_cell.cell_histograms{   DataIndex  , file_i , 1 , hx_i } = bar_y( hx_i );
                            buf =  ANALYSIS_cell.cell_histograms{   DataIndex  , file_i , 3 , hx_i } ;
                            d2d_hist(file_i , hx_i ) = buf ;
%                             xout( hx_i ) = ANALYSIS_cell.cell_histograms{   Name_index  , file_i , 2 , hx_i }  ;
                        end
                       end
                        YStep =  ANALYSIS_cell.cell_histograms{   DataIndex  , 1 , 4 , 1 };
                       d2d_hist = d2d_hist' ;
                       if YStep > 0
                       bb= imagesc(  x   , y * YStep,  d2d_hist  );  
                       end
                      colorbar               
                          xlabel( 'File number' )
                      ylabel( ANALYSIS_cell.Comp_result_Hist_fieldnames { DataIndex } )         
                      title( 'Dissapeared connections delays' )                      
                     
                     
                    
    subplot( Ny , Nx , 6  );                  
      DataIndex_hist = 7 ; 
                       d2d_hist = zeros( ANALYSIS_cell.cell_histograms{   DataIndex  , 1 , 5 , 1 }   , Global_flags.histogram_bins_number );  
                       for file_i = 1 : ANALYSIS_cell.cell_histograms{   DataIndex  , 1 , 5 , 1 } 
                        for hx_i = 1: Global_flags.histogram_bins_number  
%                             ANALYSIS_cell.cell_histograms{   DataIndex_hist , file_i , 1 , hx_i } = bar_y( hx_i );
                            d2d_hist(file_i , hx_i ) = ANALYSIS_cell.cell_histograms{   DataIndex_hist  , file_i , 3 , hx_i } ;
%                             xout( hx_i ) = ANALYSIS_cell.cell_histograms{   Name_index  , file_i , 2 , hx_i }  ;
                        end
                       end
                        YStep =  ANALYSIS_cell.cell_histograms{   DataIndex_hist  , 1 , 4 , 1 };
                       d2d_hist = d2d_hist' ;
                       if ~isempty( d2d_hist )
                        bb2= imagesc(  x   , y * YStep,  d2d_hist  ); 
                       end
                      colorbar               
                      xlabel( 'File number' )
                      ylabel( 'Connection delays, ms' ) 
                    title( 'Connection delays histogram' )               
                      
  
%------------- Spike rate compare ---------------------------                      
                      
                      
               
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
            
                