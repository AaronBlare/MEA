
% Connectiv_compare_list_files_post_analyze 
 
  
%     ALL_cell.Analysis_data_cell  
%     ALL_cell.Connectiv_data
%     All_files_data_TOTAL_cell_filed_names
Global_flags.ANALYSIS_ARG = ANALYSIS_ARG ; 
Connectiv_data_present = ~isempty( ALL_cell.Connectiv_data ) ;

if Connectiv_data_present
if Global_flags.Test_connectiv_list_files
    file_number = n_files ;
    if Global_flags.file_number_of_change > 0
        file_number = Global_flags.file_number_of_change ;
    end
%     Connectiv_Test_all_Nconn_vs_mintau_minM 
  Optimal_parameters =  Connectiv_Test_all_Nconn_vs_mintau_minM_from_Cell( ALL_cell , file_number ,Global_flags ); 
  Global_flags.Optimal_connection_parameters = Optimal_parameters ;
  
  Global_flags.Connects_min_M_strength = Optimal_parameters.strength_stable ;
  Global_flags.Connects_min_tau_diff = Optimal_parameters.tau_stable ;
  Global_flags.Connectiv_min_spikes_per_channel = Optimal_parameters.SpBur_stable ; 
  Global_flags.Check_Spike_Rates = true ;
  
      for file_i = 1 : Global_flags.Files_in_exeperiment            
                var.default_params  = false;
                var.Check_Spike_Rates = true ;    
                var.Strength_THR = Optimal_parameters.strength_stable  ;
                var.Connects_min_tau_diff_THR = Optimal_parameters.tau_stable ;
                var.SpBur_thr = Optimal_parameters.SpBur_stable ;
                 [ Number_of_Connections , Connection_delays ] = ...
                     Connectiv_get_N_connections_from_Connectiv( ALL_cell.Connectiv_data( file_i  , :)  , Global_flags , var) ;
                %  input 
                % var.default_params 
                % var.Check_Spike_Rates 
                % ( Connectiv_data , Connects_min_tau_diff_THR , ...
                %         Strength_THR , Total_Spike_Rates_thr )
                % output Number_of_Connections Connection_delays                       
        ALL_cell.Connectiv_data( file_i  , :).Number_of_Connections =  Number_of_Connections ;            
    end
  
end
end



if isempty( Global_flags.Analyze_selected_channels ) 
        
    var.Conp_type_data_type = 1 ; % 1=all data compare, 2=only stimulated channels, 3=only non-stim channels    
   %>>>>>>>>>>>>>>>%>>>>>>>>>>>>>>>%>>>>>>>>>>>>>>> 
   [ALL_cell ANALYSIS_cell]= Compare_files_connectiv_and_Show_results( ALL_cell , Global_flags , var );
   %>>>>>>>>>>>>>>>%>>>>>>>>>>>>>>>%>>>>>>>>>>>>>>> 
   
%     Compare_files_connectiv_and_Show_results
    % input:
    % ALL_cell  Global_flags
    % output:
    % ALL_cell.Comp_result
    % ALL_cell.Comp_result_cell 
else
    
    Global_flags.buffer.Erase_some_channels = [] ;     
    var.Conp_type_data_type = 1 ; % 1=all data compare, 2=only stimulated channels, 3=only non-stim channels    
    %>>>>>>>>>>>>>>>%>>>>>>>>>>>>>>>%>>>>>>>>>>>>>>> 
   [ALL_cell ANALYSIS_cell]= Compare_files_connectiv_and_Show_results( ALL_cell , Global_flags , var );
   %>>>>>>>>>>>>>>>%>>>>>>>>>>>>>>>%>>>>>>>>>>>>>>> 
    
%     Global_flags.Analyze_selected_channels
    ALL_cell_original = ALL_cell ; 
    
    
    
    var.Conp_type_data_type = 2 ; % 1=all data compare, 2=only stimulated channels, 3=only non-stim channels
     
    N = numel( ALL_cell.Analysis_data_cell{ 1 , 9 } ) ;
%     N = N(1) ;
%---------------------------------------------------
    channels_to_erase = 1 : N ;
    channels_to_erase( Global_flags.Analyze_selected_channels  ) = [] ;
    
    % Erase connections in all channels except selected  
        meaDB_ALL_cell_erase_channels_data 
        %    Input : Global_flags ALL_cell channels_to_erase
    %--------------------------------------------------- 
    
    % set channels that will be erased in total rate compare
    Global_flags.buffer.Erase_some_channels = channels_to_erase ;
  %>>>>>>>>>>>>>>>%>>>>>>>>>>>>>>>%>>>>>>>>>>>>>>> 
  [ALL_cell ANALYSIS_cell]= Compare_files_connectiv_and_Show_results( ALL_cell , Global_flags , var );
  %>>>>>>>>>>>>>>>%>>>>>>>>>>>>>>>%>>>>>>>>>>>>>>> 
%         Conp_type_data_type = 1 ; % 1=all data compare, 2=only stimulated channels, 3=only non-stim channels
  
    
         
    var.Conp_type_data_type = 3 ; % 1=all data compare, 2=only stimulated channels, 3=only non-stim channels
    
    %---------------------------------------------------
    ALL_cell.Connectiv_data = ALL_cell_original.Connectiv_data ;
    channels_to_erase  =Global_flags.Analyze_selected_channels ;
        % Erase connections in desired channels
        meaDB_ALL_cell_erase_channels_data 
        %    Input : Global_flags ALL_cell channels_to_erase
    %--------------------------------------------------- 
        
        % set channels that will be erased in total rate compare
    Global_flags.buffer.Erase_some_channels = channels_to_erase ;
    %>>>>>>>>>>>>>>>%>>>>>>>>>>>>>>>%>>>>>>>>>>>>>>> 
      [ALL_cell ANALYSIS_cell]= Compare_files_connectiv_and_Show_results( ALL_cell , Global_flags , var );
    % input:
    % ALL_cell  Global_flags
    % output:
    % ALL_cell.Comp_result
    % ALL_cell.Comp_result_cell       
   %>>>>>>>>>>>>>>>%>>>>>>>>>>>>>>>%>>>>>>>>>>>>>>>  
        
end







%%

Analyze_script = false; 


if Analyze_script

Old_analysis = false ;
        EXP_cell.cell_data = cell( 1 , 1 , 1 );
%         EXP_cell.cell_data2 = cell( 1 , 1 , 1 );
        EXP_cell.cell_statistics =  cell( 1 , 1  );
        EXP_cell.cell_mean_total =  cell( 1 , 1  );        
        EXP_cell.cell_histograms =  cell( 1 , 1 , 1 , 1);   

    

%=============================================
%=============================================
%========= histograms =====================        
             %--- Histogram of data -------------
             Comp_result_SNames2{ 1 } = 'BurstDurations' ;
%              Comp_result_SNames2{ 2 } = 'BurstDurations2' ;
             Comp_result_SNames2{ 2 } = 'InteBurstInterval';
%              Comp_result_SNames2{ 4 } = 'InteBurstInterval2' ;
             Comp_result_SNames2{ 3 } = 'Spike_Rates_each_burst' ;
%              Comp_result_SNames2{ 6 } = 'Spike_Rates_each_burst' ;
             Comp_result_SNames2{ 4 } = 'Spike_Rates_each_channel_mean' ;
%              Comp_result_SNames2{ 8 } = 'Spike_Rates_each_channel_mean2' ;             
             Comp_result_SNames2{ 5 } = 'New_conns_delays' ;
             Comp_result_SNames2{ 6 } = 'Dissapeared_conns_delays' ;
             Comp_result_SNames2{ 7 } = 'Connection_delays' ;
              
             DataIndex_num = 7 ;
             DataIndex_new_delays = 5 ;
             DataIndex_delays = 7 ;
             
%              DataIndex=  1 ; 
       for DataIndex = 1 : DataIndex_num
           
            if  ANALYSIS_ARG.FILE_LIST_PROCESS
              file_to_take = Global_flags.Files_in_exeperiment + 1 ;
              if DataIndex >= DataIndex_new_delays && DataIndex < DataIndex_delays
                 file_to_take = Global_flags.Files_in_exeperiment  ;
              end
              for file_i = 1 : file_to_take
             DataIndex   ;   
                  for e = 1 : 3
                      for hx_i = 1: Global_flags.histogram_bins_number  
                            EXP_cell.cell_histograms{  DataIndex  , file_i , e , hx_i  } = 0 ; 
                      end
                  end
%                     data_for_hist = ALL_EXPERIMENTS_FULL_RESULTS_all( file_i_curr ).FULL_RESULTS_all.Comp_result.( Comp_result_SNames2{ DataIndex_curr } ) ; 
                    if DataIndex  < DataIndex_new_delays
                        Name_index = strmatch( Comp_result_SNames2{DataIndex } , All_files_data_TOTAL_cell_filed_names  ) ;                   
                        a = ALL_cell.Analysis_data_cell( file_i , Name_index  )  ; 
                    end
                    if DataIndex >= DataIndex_new_delays && DataIndex < DataIndex_delays 
                        Name_index = strmatch( Comp_result_SNames2{DataIndex } , Comp_result_Names  ) ;                   
                        a = ALL_cell.Comp_result_cell( file_i , Name_index  )  ; 
                    end
                    if  DataIndex == DataIndex_delays 
                         [ Number_of_Connections , Connection_delays ]= Connectiv_get_N_connections( ALL_cell.Connectiv_data( file_i )  );
                      	Number_of_Connections ;
                        a = { Connection_delays } ;
                    end
                    data_for_hist = cell2mat( a ) ;
%                     data_for_hist = cell2mat( data_for_hist );
 
DataIndex;
                %==== All data from all files =================  
                    if DataIndex  < DataIndex_new_delays
                        Name_index = strmatch( Comp_result_SNames2{DataIndex } , All_files_data_TOTAL_cell_filed_names  ) ;                   
                        a = ALL_cell.Analysis_data_cell( : , Name_index  )  ; 
                        whos a;
                         a;
                        s=size(a{1});
                        if s(1) ==1
                           a=a'; 
                        end
                       a;
                        data_for_hist_all_files = cell2mat( a ) ;
                    end
                    if DataIndex >= DataIndex_new_delays && DataIndex < DataIndex_delays 
                        Name_index = strmatch( Comp_result_SNames2{DataIndex } , Comp_result_Names  ) ;                   
                        a = ALL_cell.Comp_result_cell( : , Name_index  )  ; 
                        whos a;
                        a;
                        data_for_hist_all_files = cell2mat( a ) ;
                        whos data_for_hist_all_files;
                    end
                    if  DataIndex == DataIndex_delays 
                        a= [];
                         for file_i2 = 1 : file_to_take
                            [ Number_of_Connections , Connection_delays ]= Connectiv_get_N_connections( ALL_cell.Connectiv_data( file_i2 )  );
                            Number_of_Connections ;
                            a = [ a Connection_delays ];
                         end
                         whos a;
                         a;
                         data_for_hist_all_files = a ;
                    end
                    
                     
                    
                       
               %==================================     
                   data_for_hist_all_files = abs(data_for_hist_all_files) ; 
                      
                    if ~isempty( data_for_hist ) > 0 
%                     if max( data_for_hist )> 0 && length( data_for_hist ) > 1 
                    if max( abs( data_for_hist ) )> 0 && length( data_for_hist ) > 0                         
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
                            EXP_cell.cell_histograms{   DataIndex  , file_i , 1 , hx_i } = bar_y_norm( hx_i );
                            EXP_cell.cell_histograms{  DataIndex  , file_i , 2 , hx_i } = xout( hx_i );
                            EXP_cell.cell_histograms{ DataIndex  , file_i , 3 , hx_i } = bar_y( hx_i );
                            EXP_cell.cell_histograms{  DataIndex  , 1 , 4 , 1 } = HStep ;
                            EXP_cell.cell_histograms{  DataIndex  , 1 , 5 , 1 } = file_to_take ;
                        end
                    end
                    end 
              end 
            end
            end
            %-----------------------------------       
 %=============================================
 %============================================= 
 %=============================================
 %=============================================
        
 
 
 
 
 %---------- Find mean values -------------------
%  usr = userpath ;
%  usr( end ) = [] ;
%  fileSnames = [ usr '\' 'Comp_result_SNames.mat' ] ;
 
%  All_files_data_TOTAL_cell_filed_names ;
 
 ExcludeIndex = 48 ; % array fo structss
 
%  eval( ['save ' fileSnames ' Comp_result_SNames' ]);
%  eval( ['load ' fileSnames ] );
 
        for loopIndex = 1:numel( All_files_data_TOTAL_cell_filed_names ) 
            if Global_flags.file_number_of_change > 0
                Files_to_take = Global_flags.file_number_of_change ;
            else
                Files_to_take = Global_flags.Files_in_exeperiment  ;
            end
               
%             dat = EXP_cell.cell_data(  :  , loopIndex ) ;            
            dat = ALL_cell.Analysis_data_cell( : , loopIndex ) ; 
            dat = clear_cell_fromNanInfEmpt( dat );  
            
%               Name_index = strmatch( 'Mean_M_abs_difference_common_connections' , Comp_result_SNames  ) ;
%             if loopIndex == Name_index
%                 dat;
%             end
              
            ss = size( dat{1} )  ; 
            if ss(1) == 1
               dat = dat';     
            end
            Total_data = dat;
            
            
        if ~isstruct( Total_data{1} )  && loopIndex ~= ExcludeIndex
                Total_data = cell2mat( Total_data ) ; 
                mean_data = mean( Total_data )  ;
                std_data = std( Total_data ) ;
             
            
            EXP_cell.cell_mean_total{  loopIndex , 1  } = mean_data;
            EXP_cell.cell_mean_total{  loopIndex , 2 } = std_data ;
            Current_SName = All_files_data_TOTAL_cell_filed_names( loopIndex );
            
%              Name_index = strmatch( 'Number_Spikes' , Comp_result_SNames  ) ;
%              if Name_index(1) == loopIndex
%                  dat;
%                  Total_data;
%              end
            
            %--- Take Control experiment data ----------
%             for ctrl_i = 1 : Files_to_take
%                 dat = EXP_cell.cell_data( 1 : Files_to_take , loopIndex ) ;
                dat = ALL_cell.Analysis_data_cell( 1 : Files_to_take , loopIndex ) ;
                ss = size( dat{1} )  ;
                if ss(1) == 1
                   dat = dat';     
                end 
                
%                 if ss(1) == 1 
                    Ctrl_data = cell2mat( dat ) ;
               
                    Data_is_Stat_different_if_1 = 0 ;
                   if Global_flags.file_number_of_change > 0
%                        dat = (  EXP_cell.cell_data(  Global_flags.file_number_of_change +1 : end , loopIndex   )  );
                    dat = (  ALL_cell.Analysis_data_cell( Files_to_take +1 : end  , loopIndex )  );
                       
                       ss = size( dat{1} )  ;
                        if ss(1) == 1
                           dat = dat';     
                        end 
                        Effect_data = cell2mat( dat );
    %                    Effect_data =   rand( 10 , 1 );
                        %     Ctrl_data
                        %     Effect_data
                        %     loopIndex
                        
                        if ~isempty( Ctrl_data ) && ~isempty( Effect_data )
                            s1=size(   Ctrl_data );
                            s2=size( Effect_data );
                            if length( s1)==1 && length( s2)
                           [ p , Data_is_Stat_different_if_1 ] = ranksum( Ctrl_data , Effect_data ); 
                            end
                        end                    
                   end
                   
                   EXP_cell.cell_statistics{  loopIndex }    =  Data_is_Stat_different_if_1  ;
                   
%                 else
%                      Ctrl_data = [0 0 ] ;
%                 end
               
        end
            %------------------------------------------
        end
         
%-----------------------------------------------
        
       
   ex_n = 1 ;     
   
      
   
        
if Old_analysis
        Comp_result_SNames = fieldnames( ALL_EXPERIMENTS_FULL_RESULTS_all( 1 ).FULL_RESULTS_all.Comp_result )  ;
%           Comp_result_SNames_analyzed_data = fieldnames( All_files_data_TOTAL_cell{1,1} )  ;
        %---- take all data from 1st file
        for loopIndex = 1:numel(Comp_result_SNames) 
            EXP_cell.cell_data{ ex_n , 1 , loopIndex } = ...
                ALL_EXPERIMENTS_FULL_RESULTS_all( 1 ).FULL_RESULTS_all.Comp_result.(Comp_result_SNames{ 1 })  ;
        end
        
 
        EXP( ex_n ).New_Diss_connes_percent_of_1s_file_all  = zeros( N_files ,1)  ;
        EXP( ex_n ).New_conns_percent_of_1st_file_all  = zeros( N_files ,1)   ;
        EXP( ex_n ).Dissapeared_conns_percent_of_1st_file_all = zeros( N_files ,1)   ;
        EXP( ex_n ).Mean_M_abs_difference_common_connections_all = zeros( N_files ,1)   ;
        EXP( ex_n ).Mean_M_abs_difference_unstable_connections_all = zeros( N_files ,1)   ;
        EXP( ex_n ).New_conns_mean_delay_all = zeros( N_files ,1)   ;
        EXP( ex_n ).Dissapeared_conns_mean_delay_all = zeros( N_files ,1)   ;
        EXP( ex_n ).Number_Spikes( 1 ) = ALL_EXPERIMENTS_FULL_RESULTS_all( 1 ).FULL_RESULTS_all.Comp_result.Number_Spikes ;
        EXP( ex_n ).Number_of_Superbursts( 1 ) = ALL_EXPERIMENTS_FULL_RESULTS_all( 1 ).FULL_RESULTS_all.Comp_result.Number_of_Superbursts ;
        
        EXP( ex_n ).BurstDurations_mean( 1 ) = ALL_EXPERIMENTS_FULL_RESULTS_all( 1 ).FULL_RESULTS_all.Comp_result.BurstDurations_mean ;
        EXP( ex_n ).BurstDurations_std( 1 ) = ALL_EXPERIMENTS_FULL_RESULTS_all( 1 ).FULL_RESULTS_all.Comp_result.BurstDurations_std ;
        EXP( ex_n ).InteBurstInterval_mean( 1 ) = ALL_EXPERIMENTS_FULL_RESULTS_all( 1 ).FULL_RESULTS_all.Comp_result.InteBurstInterval_mean ;
        EXP( ex_n ).InteBurstInterval_std( 1 ) = ALL_EXPERIMENTS_FULL_RESULTS_all( 1 ).FULL_RESULTS_all.Comp_result.InteBurstInterval_std ;
        EXP( ex_n ).Spike_Rates_each_burst_mean( 1 ) = ALL_EXPERIMENTS_FULL_RESULTS_all( 1 ).FULL_RESULTS_all.Comp_result.Spike_Rates_each_burst_mean ;
        EXP( ex_n ).Spike_Rates_each_burst_std( 1 ) = ALL_EXPERIMENTS_FULL_RESULTS_all( 1 ).FULL_RESULTS_all.Comp_result.Spike_Rates_each_burst_std ;       
        EXP( ex_n ).Firing_Rates_each_burst_mean( 1 ) = ALL_EXPERIMENTS_FULL_RESULTS_all( 1 ).FULL_RESULTS_all.Comp_result.Firing_Rates_each_burst_mean ;
        EXP( ex_n ).Firing_Rates_each_burst_std( 1 ) = ALL_EXPERIMENTS_FULL_RESULTS_all( 1 ).FULL_RESULTS_all.Comp_result.Firing_Rates_each_burst_std ;        
        EXP( ex_n ).Burst_rate_b_per_min( 1 ) = ALL_EXPERIMENTS_FULL_RESULTS_all( 1 ).FULL_RESULTS_all.Comp_result.Burst_rate_b_per_min ;        
        EXP( ex_n ).Burst_rate_b_per_min2( 1 ) = ALL_EXPERIMENTS_FULL_RESULTS_all( 1 ).FULL_RESULTS_all.Comp_result.Burst_rate_b_per_min2 ;                
        EXP( ex_n ).Burst_rate_number( 1 ) = ALL_EXPERIMENTS_FULL_RESULTS_all( 1 ).FULL_RESULTS_all.Comp_result.Burst_rate_number ;             
        
        
        EXP( ex_n ).Number_of_Connections( 1 )  = ALL_EXPERIMENTS_FULL_RESULTS_all( 1 ).FULL_RESULTS_all.Comp_result.Number_of_Connections_file1 ;
        
 
        
        if  ANALYSIS_ARG.FILE_LIST_PROCESS
%             for file_i = 1 : Global_flags.Files_in_exeperiment - 1
            for file_i = 1 : Global_flags.Files_in_exeperiment  
                
                %--- Collect all data from experiment -----------
                for loopIndex = 1:numel(Comp_result_SNames) 
                    dat=  ALL_EXPERIMENTS_FULL_RESULTS_all( file_i  ).FULL_RESULTS_all.Comp_result.(Comp_result_SNames{ loopIndex })  ;
                    EXP_cell.cell_data{ ex_n , file_i  , loopIndex }  = dat ;
                end
                %----------------------------
                
                 
%                 %--- Collect all data from experiment -----------
%                 for loopIndex = 1:numel(Comp_result_SNames_analyzed_data) 
%                     dat=  All_files_data_TOTAL_cell{ 1 , file_i}.(Comp_result_SNames_analyzed_data{ loopIndex })  ;
%                     EXP_cell.cell_data2{ ex_n , file_i  , loopIndex }  = dat ;
%                 end
                %---------------------------- 
            
                
                
                  EXP( ex_n ).New_Diss_connes_percent_of_1s_file_all( file_i + 1 ) = ...
                      ALL_EXPERIMENTS_FULL_RESULTS_all( file_i ).FULL_RESULTS_all.Comp_result.New_Diss_connes_percent_of_1s_file ;
                  
                  EXP( ex_n ).New_conns_percent_of_1st_file_all(  file_i + 1 ) = ...
                      ALL_EXPERIMENTS_FULL_RESULTS_all( file_i  ).FULL_RESULTS_all.Comp_result.New_conns_percent_of_1st_file ;
                  
                  EXP( ex_n ).Dissapeared_conns_percent_of_1st_file_all(  file_i + 1 ) = ...
                      ALL_EXPERIMENTS_FULL_RESULTS_all( file_i  ).FULL_RESULTS_all.Comp_result.Dissapeared_conns_percent_of_1st_file ;
                  EXP( ex_n ).Mean_M_abs_difference_common_connections_all(  file_i + 1 ) = ...
                      ALL_EXPERIMENTS_FULL_RESULTS_all( file_i  ).FULL_RESULTS_all.Comp_result.Mean_M_abs_difference_common_connections ;
                  EXP( ex_n ).Mean_M_abs_difference_unstable_connections_all(  file_i + 1 ) = ...
                      ALL_EXPERIMENTS_FULL_RESULTS_all( file_i   ).FULL_RESULTS_all.Comp_result.Mean_M_abs_difference_unstable_connections ;
                  EXP( ex_n ).New_conns_mean_delay_all( file_i + 1 ) = ...
                      ALL_EXPERIMENTS_FULL_RESULTS_all( file_i ).FULL_RESULTS_all.Comp_result.New_conns_mean_delay ;
                  EXP( ex_n ).Dissapeared_conns_mean_delay_all( file_i + 1 ) = ...
                      ALL_EXPERIMENTS_FULL_RESULTS_all( file_i ).FULL_RESULTS_all.Comp_result.Dissapeared_conns_mean_delay ;  
                  EXP( ex_n ).Number_of_Connections( file_i + 1 )  = ...
                       ALL_EXPERIMENTS_FULL_RESULTS_all( file_i ).FULL_RESULTS_all.Comp_result.Number_of_Connections_file2 ;
                   
                   EXP( ex_n ).Number_of_Connections( file_i + 1 ) 
                   
                     EXP( ex_n ).Number_Spikes( file_i + 1 )  = ...
                       ALL_EXPERIMENTS_FULL_RESULTS_all( file_i ).FULL_RESULTS_all.Comp_result.Number_Spikes2 ;     
        
                     EXP( ex_n ).Number_of_Superbursts( file_i + 1 )  = ...
                       ALL_EXPERIMENTS_FULL_RESULTS_all( file_i ).FULL_RESULTS_all.Comp_result.Number_of_Superbursts2 ;            
                   
                     EXP( ex_n ).BurstDurations_mean( file_i + 1 )  = ...
                       ALL_EXPERIMENTS_FULL_RESULTS_all( file_i ).FULL_RESULTS_all.Comp_result.BurstDurations_mean2 ;  
                     EXP( ex_n ).BurstDurations_std( file_i + 1 )  = ...
                       ALL_EXPERIMENTS_FULL_RESULTS_all( file_i ).FULL_RESULTS_all.Comp_result.BurstDurations_std2 ;   
                   
                     EXP( ex_n ).InteBurstInterval_mean( file_i + 1 )  = ...
                       ALL_EXPERIMENTS_FULL_RESULTS_all( file_i ).FULL_RESULTS_all.Comp_result.InteBurstInterval_mean2 ;  
                     EXP( ex_n ).InteBurstInterval_std( file_i + 1 )  = ...
                       ALL_EXPERIMENTS_FULL_RESULTS_all( file_i ).FULL_RESULTS_all.Comp_result.InteBurstInterval_std2 ;                     
                   
                     EXP( ex_n ).Spike_Rates_each_burst_mean( file_i + 1 )  = ...
                       ALL_EXPERIMENTS_FULL_RESULTS_all( file_i ).FULL_RESULTS_all.Comp_result.Spike_Rates_each_burst_mean2 ;    
                     EXP( ex_n ).Spike_Rates_each_burst_std( file_i + 1 )  = ...
                       ALL_EXPERIMENTS_FULL_RESULTS_all( file_i ).FULL_RESULTS_all.Comp_result.Spike_Rates_each_burst_std2 ;                     
                                  
                     EXP( ex_n ).Firing_Rates_each_burst_mean( file_i + 1 )  = ...
                       ALL_EXPERIMENTS_FULL_RESULTS_all( file_i ).FULL_RESULTS_all.Comp_result.Firing_Rates_each_burst_mean2 ;      
                     EXP( ex_n ).Firing_Rates_each_burst_std( file_i + 1 )  = ...
                       ALL_EXPERIMENTS_FULL_RESULTS_all( file_i ).FULL_RESULTS_all.Comp_result.Firing_Rates_each_burst_std2 ;                      
                   
                     EXP( ex_n ).Burst_rate_b_per_min( file_i + 1 )  = ...
                       ALL_EXPERIMENTS_FULL_RESULTS_all( file_i ).FULL_RESULTS_all.Comp_result.Burst_rate_b_per_min2 ;      
                   
                     EXP( ex_n ).Burst_rate_number( file_i + 1 )  = ...
                       ALL_EXPERIMENTS_FULL_RESULTS_all( file_i ).FULL_RESULTS_all.Comp_result.Burst_rate_number2 ;                    
                   
                   
            end
        else
            for file_i = 1 : 3-1
                
                %--- Collect all data from experiment -----------
                for loopIndex = 1:numel(Comp_result_SNames) 
                    EXP_cell.cell_data{ ex_n , file_i  , loopIndex } =  ALL_EXPERIMENTS_FULL_RESULTS_all( file_i  ).FULL_RESULTS_all.Comp_result.(Comp_result_SNames{ loopIndex })  ;
                end
                %----------------------------
                
                
                  EXP( ex_n ).New_Diss_connes_percent_of_1s_file_all( file_i + 1 ) = ...
                      ALL_EXPERIMENTS_FULL_RESULTS_all( file_i ).Comp_result.New_Diss_connes_percent_of_1s_file ;
                  EXP( ex_n ).New_conns_percent_of_1st_file_all(  file_i + 1 ) = ...
                      ALL_EXPERIMENTS_FULL_RESULTS_all( file_i    ).Comp_result.New_conns_percent_of_1st_file ;
                  EXP( ex_n ).Dissapeared_conns_percent_of_1st_file_all(  file_i + 1 ) = ...
                      ALL_EXPERIMENTS_FULL_RESULTS_all( file_i   ).Comp_result.Dissapeared_conns_percent_of_1st_file ;
                  EXP( ex_n ).Mean_M_abs_difference_common_connections_all(  file_i + 1 ) = ...
                      ALL_EXPERIMENTS_FULL_RESULTS_all( file_i    ).Comp_result.Mean_M_abs_difference_common_connections ;
                  EXP( ex_n ).Mean_M_abs_difference_unstable_connections_all(  file_i + 1 ) = ...
                      ALL_EXPERIMENTS_FULL_RESULTS_all( file_i   ).Comp_result.Mean_M_abs_difference_unstable_connections ;
                  EXP( ex_n ).New_conns_mean_delay_all( file_i + 1 ) = ...
                      ALL_EXPERIMENTS_FULL_RESULTS_all( file_i ).Comp_result.New_conns_mean_delay ;
                  EXP( ex_n ).Dissapeared_conns_mean_delay_all( file_i + 1 ) = ...
                      ALL_EXPERIMENTS_FULL_RESULTS_all( file_i ).Comp_result.Dissapeared_conns_mean_delay ; 
                  EXP( ex_n ).Number_Spikes( file_i + 1 )  = ...
                       ALL_EXPERIMENTS_FULL_RESULTS_all( file_i ).Comp_result.Number_Spikes ;   
                   
                     EXP( ex_n ).Number_of_Superbursts( file_i + 1 )  = ...
                       ALL_EXPERIMENTS_FULL_RESULTS_all( file_i ).FULL_RESULTS_all.Comp_result.Number_of_Superbursts2 ;                      
                   
                     EXP( ex_n ).Number_Spikes( file_i + 1 )  = ...
                       ALL_EXPERIMENTS_FULL_RESULTS_all( file_i ).FULL_RESULTS_all.Comp_result.Number_Spikes2 ;     
                   
                     EXP( ex_n ).BurstDurations_mean( file_i + 1 )  = ...
                       ALL_EXPERIMENTS_FULL_RESULTS_all( file_i ).FULL_RESULTS_all.Comp_result.BurstDurations_mean2 ;  
                     EXP( ex_n ).BurstDurations_std( file_i + 1 )  = ...
                       ALL_EXPERIMENTS_FULL_RESULTS_all( file_i ).FULL_RESULTS_all.Comp_result.BurstDurations_std2 ;                     
                   
                     EXP( ex_n ).InteBurstInterval_mean( file_i + 1 )  = ...
                       ALL_EXPERIMENTS_FULL_RESULTS_all( file_i ).FULL_RESULTS_all.Comp_result.InteBurstInterval_mean2 ;  
                     EXP( ex_n ).InteBurstInterval_std( file_i + 1 )  = ...
                       ALL_EXPERIMENTS_FULL_RESULTS_all( file_i ).FULL_RESULTS_all.Comp_result.InteBurstInterval_std2 ;                     
                   
                     EXP( ex_n ).Spike_Rates_each_burst_mean( file_i + 1 )  = ...
                       ALL_EXPERIMENTS_FULL_RESULTS_all( file_i ).FULL_RESULTS_all.Comp_result.Spike_Rates_each_burst_mean2 ;    
                     EXP( ex_n ).Spike_Rates_each_burst_std( file_i + 1 )  = ...
                       ALL_EXPERIMENTS_FULL_RESULTS_all( file_i ).FULL_RESULTS_all.Comp_result.Spike_Rates_each_burst_std2 ;                     
                                  
                     EXP( ex_n ).Firing_Rates_each_burst_mean( file_i + 1 )  = ...
                       ALL_EXPERIMENTS_FULL_RESULTS_all( file_i ).FULL_RESULTS_all.Comp_result.Firing_Rates_each_burst_mean2 ;      
                     EXP( ex_n ).Firing_Rates_each_burst_std( file_i + 1 )  = ...
                       ALL_EXPERIMENTS_FULL_RESULTS_all( file_i ).FULL_RESULTS_all.Comp_result.Firing_Rates_each_burst_std2 ;                      
                   
                     EXP( ex_n ).Burst_rate_b_per_min( file_i + 1 )  = ...
                       ALL_EXPERIMENTS_FULL_RESULTS_all( file_i ).FULL_RESULTS_all.Comp_result.Burst_rate_b_per_min2 ;    
                   
                     EXP( ex_n ).Burst_rate_number( file_i + 1 )  = ...
                       ALL_EXPERIMENTS_FULL_RESULTS_all( file_i ).FULL_RESULTS_all.Comp_result.Burst_rate_number2 ;                  
                   
            end
        end
end            
        
        
 end       
%         ALL_experiments_file_pars = EXP ;