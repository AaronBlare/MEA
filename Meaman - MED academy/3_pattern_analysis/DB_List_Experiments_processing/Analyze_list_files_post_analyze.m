
% Analyze_list_files_post_analyze 

All_data_all_exp = [] ;

EXP = [];
 
ex_n = 1 ;



if Test_connectiv_list_files
    file_number = n_files ;
    if Global_flags.file_number_of_change > 0
        file_number = Global_flags.file_number_of_change ;
    end
%     Connectiv_Test_all_Nconn_vs_mintau_minM
    
  Optimal_parameters =  Connectiv_Test_all_Nconn_vs_mintau_minM_from_Cell( ALL_cell , file_number ,Global_flags );
    
    
end

        EXP_cell.cell_data = cell( 1 , 1 , 1 );
        EXP_cell.cell_statistics =  cell( 1 , 1  );
        EXP_cell.cell_mean_total =  cell( 1 , 1  );        
        EXP_cell.cell_histograms =  cell( 1 , 1 , 1 , 1);   
        Comp_result_SNames = fieldnames( All_files_data_TOTAL_cell{1,1} )  ;
         
        %---- take all data from 1st file
  
        if  ANALYSIS_ARG.FILE_LIST_PROCESS
%             for file_i = 1 : Global_flags.Files_in_exeperiment - 1
            for file_i = 1 : n_files   
                %--- Collect all data from experiment -----------
                for loopIndex = 1:numel(Comp_result_SNames) 
                    dat=  All_files_data_TOTAL_cell{ 1 , file_i}.(Comp_result_SNames{ loopIndex })  ;
                    EXP_cell.cell_data{ ex_n , file_i  , loopIndex }  = dat ;
                end
                %---------------------------- 
            end        
        end
        

%=============================================
%=============================================
%========= histograms =====================        
             %--- Histogram of data -------------
             Comp_result_SNames2{ 1 } = 'BurstDurations' ;
             Comp_result_SNames2{ 2  } = 'InteBurstInterval';
             Comp_result_SNames2{ 3 } = 'Spike_Rates_each_burst' ;
%              Comp_result_SNames2{ 7 } = 'New_conns_delays' ;
%              Comp_result_SNames2{ 8 } = 'Dissapeared_conns_delays' ;
             DataIndex_num = 3 ;
             
       for DataIndex = 1 : DataIndex_num
            if  ANALYSIS_ARG.FILE_LIST_PROCESS
              for file_i = 1 : n_files
                  
                  for hx_i = 1: Global_flags.histogram_bins_number  
                            EXP_cell.cell_histograms{ ex_n ,  DataIndex  , file_i , 1 , hx_i } = 0 ;
                            EXP_cell.cell_histograms{ ex_n ,  DataIndex  , file_i , 2 , hx_i } = 0 ;
                            EXP_cell.cell_histograms{ ex_n ,  DataIndex  , file_i , 3 , hx_i } = 0 ;
                  end
                  
                  DataIndex_curr = DataIndex ;
                  file_i_curr = file_i  ; 
                  
                  DataIndex_curr;
                  file_i_curr;
                    data_for_hist = All_files_data_TOTAL_cell{ 1 , file_i}.(Comp_result_SNames2{ DataIndex_curr }) ;
%                     data_for_hist = cell2mat( data_for_hist );

                %==== All data from all files =================
                    data_for_hist_all_files = []; 
%                     if 0 < 7 %  
                        for file_i_int = 1 : n_files
                            
                             DataIndex_curr_int = DataIndex ;
                             
                              data_to_add =  All_files_data_TOTAL_cell{ 1 , file_i}.(Comp_result_SNames2{ DataIndex_curr_int }) ;                   
                              data_to_add = reshape( data_to_add , [] , 1 );
                              data_for_hist_all_files = [ data_for_hist_all_files ;  data_to_add ] ; 
                        end
%                     end
               %==================================     
                   data_for_hist_all_files = abs(data_for_hist_all_files) ; 
                   
                    if ~isempty( data_for_hist ) > 0 
%                     if max( data_for_hist )> 0 && length( data_for_hist ) > 1 
                    if max( abs( data_for_hist ) )> 0 && length( data_for_hist ) > 1                         
                        hx = 1: Global_flags.histogram_bins_number  ;
                        Min_value = 0 ;
    %                     Min_value = min( data_for_hist) ;
%                         HStep = max( data_for_hist ) / Global_flags.histogram_bins_number ;  
                        data_for_hist = abs( data_for_hist ) ;
                        
                        HStep = max( data_for_hist_all_files ) / Global_flags.histogram_bins_number ;
                        xxx =  0 : HStep : max( data_for_hist_all_files ) ;
                        [bar_y,xout] = histc( data_for_hist  ,xxx ) ;
                        %- Normalized histogram ---
                            bar_y_norm = 100* bar_y / length( data_for_hist ) ;
                        %----------------------------
                        xout = xxx ; 
                        
                        for hx_i = 1: Global_flags.histogram_bins_number  
                            EXP_cell.cell_histograms{ ex_n ,  DataIndex  , file_i , 1 , hx_i } = bar_y_norm( hx_i );
                            EXP_cell.cell_histograms{ ex_n ,  DataIndex  , file_i , 2 , hx_i } = xout( hx_i );
                            EXP_cell.cell_histograms{ ex_n ,  DataIndex  , file_i , 3 , hx_i } = bar_y( hx_i );
                            EXP_cell.cell_histograms{ ex_n ,  DataIndex  , 1 , 4 , 1 } = HStep ;
                        end
                    end
                    end
                    
              end
            end
            end
            %-----------------------------------       
 %=============================================
 
 DataIndex = DataIndex_num + 1 ;
%  DataIndex = 4 ;
 
  for file_i = 1 : n_files 
                  for hx_i = 1: Global_flags.histogram_bins_number  
                            EXP_cell.cell_histograms{ ex_n ,  DataIndex  , file_i , 1 , hx_i } = 0 ;
                            EXP_cell.cell_histograms{ ex_n ,  DataIndex  , file_i , 2 , hx_i } = 0 ;
                            EXP_cell.cell_histograms{ ex_n ,  DataIndex  , file_i , 3 , hx_i } = 0 ;
                  end
                  
                  DataIndex_curr = DataIndex ;
                  file_i_curr = file_i  ; 
                   [ Number_of_Connections , Connection_delays ]= Connectiv_get_N_connections( All_files_data_TOTAL_cell{ 2 , file_i} );
                       Number_of_Connections ;
                    data_for_hist = Connection_delays ;

                %==== All data from all files =================
                    data_for_hist_all_files = [];  
                        for file_i_int = 1 : n_files  
                              [ Number_of_Connections , Connection_delays ]= Connectiv_get_N_connections( All_files_data_TOTAL_cell{ 2 , file_i} );                 
                              data = Connection_delays ;
                              data_to_add = data' ;
                              data_for_hist_all_files = [ data_for_hist_all_files ;  data_to_add ] ; 
                        end 
               %==================================     
                   data_for_hist_all_files = abs(data_for_hist_all_files) ; 
                   
                    if ~isempty( data_for_hist ) > 0 
%                     if max( data_for_hist )> 0 && length( data_for_hist ) > 1 
                    if max( abs( data_for_hist ) )> 0 && length( data_for_hist ) > 1                         
                        hx = 1: Global_flags.histogram_bins_number  ;
                        Min_value = 0 ;
    %                     Min_value = min( data_for_hist) ;
%                         HStep = max( data_for_hist ) / Global_flags.histogram_bins_number ;  
                        data_for_hist = abs( data_for_hist ) ;
                        
                        HStep = max( data_for_hist_all_files ) / Global_flags.histogram_bins_number ;
                        xxx =  0 : HStep : max( data_for_hist_all_files ) ;
                        [bar_y,xout] = histc( data_for_hist  ,xxx ) ;
                        %- Normalized histogram ---
                            bar_y_norm = 100* bar_y / length( data_for_hist ) ;
                        %----------------------------
                        xout = xxx ; 
                        
                        for hx_i = 1: Global_flags.histogram_bins_number  
                            EXP_cell.cell_histograms{ ex_n ,  DataIndex  , file_i , 1 , hx_i } = bar_y_norm( hx_i );
                            EXP_cell.cell_histograms{ ex_n ,  DataIndex  , file_i , 2 , hx_i } = xout( hx_i );
                            EXP_cell.cell_histograms{ ex_n ,  DataIndex  , file_i , 3 , hx_i } = bar_y( hx_i );
                            EXP_cell.cell_histograms{ ex_n ,  DataIndex  , 1 , 4 , 1 } = HStep ;
                        end
                    end
                    end
                    
              end
              
 
 %=============================================
        
 
 
 
 
 %---------- Find mean values -------------------
 usr = userpath ;
 usr( end ) = [] ;
 fileSnames = [ usr '\' 'Comp_result_SNames.mat' ] ;
 
 eval( ['save ' fileSnames ' Comp_result_SNames' ]);
 eval( ['load ' fileSnames ] );
 
 max_names = numel(Comp_result_SNames) ;
 max_names = 38 ;
 
        for loopIndex = 1: max_names
            if Global_flags.file_number_of_change > 0
                Files_to_take = Global_flags.file_number_of_change ;
            else
                Files_to_take = n_files  ;
            end 
            
            dat = EXP_cell.cell_data( ex_n ,  :  , loopIndex ) ;
            dat(1);
            ss = size( dat{1} ) ;
            ss ;
            
%          if ~iscell( dat ) 
%          if ~isstruct( dat )
            
            dat = clear_cell_fromNanInfEmpt( dat );
            
              Name_index = strmatch( 'SB_start' , Comp_result_SNames  ) ;
            if loopIndex == Name_index
                dat=dat';
            end
             
            dat;
            Comp_result_SNames( loopIndex );
            
            if ss(1) == 1
               Total_data = cell2mat( dat ) ;    
            else
               Total_data = [0 0 0 ] ; 
            end
            
          if ~isstruct( dat{1} )   
            dat1 = dat{1} ;
            whos dat1
            if ~isstruct(  Total_data )
                mean_Total_data = mean( Total_data ) ;
                std_Total_data = std( Total_data );
            else 
                std_Total_data  = 0 ;
                mean_Total_data   = 0 ;
            end
            
            
            
            EXP_cell.cell_mean_total{ ex_n ,  loopIndex , 1  } = mean_Total_data ;
            EXP_cell.cell_mean_total{ ex_n ,  loopIndex , 2 } = std_Total_data ;
            Current_SName = Comp_result_SNames( loopIndex );
            
%              Name_index = strmatch( 'Number_Spikes' , Comp_result_SNames  ) ;
%              if Name_index(1) == loopIndex
%                  dat;
%                  Total_data;
%              end
            
            %--- Take Control experiment data ----------
%             for ctrl_i = 1 : Files_to_take
                dat = EXP_cell.cell_data( ex_n , 1 : Files_to_take , loopIndex ) ;
                if ss(1) == 1 
                    dat;
                    dat = clear_cell_fromNanInfEmpt( dat );
                    if loopIndex == Name_index
                         dat=dat';
                    end
                    Ctrl_data = cell2mat( dat );
               
                    Data_is_Stat_different_if_1 = 0 ;
                   if Global_flags.file_number_of_change > 0
                       Effect_data = ( ( EXP_cell.cell_data( ex_n ,  Global_flags.file_number_of_change +1 : end , loopIndex ) )  );
                       Effect_data = clear_cell_fromNanInfEmpt( Effect_data );
                        if loopIndex == Name_index
                             Effect_data=Effect_data';
                        end
                       Effect_data = cell2mat( Effect_data ) ;
    %                    Effect_data =   rand( 10 , 1 );
                        %     Ctrl_data
                        %     Effect_data
                        %     loopIndex
                        
                        if ~isempty( Ctrl_data ) && ~isempty( Effect_data )
                           [ p , Data_is_Stat_different_if_1 ] = ranksum( Ctrl_data , Effect_data ); 
                        end                    
                   end
                   
                   EXP_cell.cell_statistics{ ex_n ,  loopIndex }    =  Data_is_Stat_different_if_1  ;
                   
                else
                     Ctrl_data = [0 0 ] ;
                end
               
         end
%          end
            %------------------------------------------
        end
         
%-----------------------------------------------
        
        
        
        
        
%         ALL_experiments_file_pars = EXP ;