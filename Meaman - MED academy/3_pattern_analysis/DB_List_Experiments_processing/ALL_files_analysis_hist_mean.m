

function [ EXP_cell Comp_result_SNames2 ] = ALL_files_analysis_hist_mean( ALL_cell , Global_flags , ...
    Comp_result_Names , var ) 
%cell_statistics Cell_mean_total <-  Analysis_data_cell
 

Old_analysis = false ;

Connectiv_data_present = isfield( ALL_cell , 'Connectiv_data' );
%         EXP_cell.cell_data = cell( 1 , 1 , 1 );
%         EXP_cell.cell_data2 = cell( 1 , 1 , 1 );
        EXP_cell.cell_statistics =  cell( 1 , 1  );
        EXP_cell.cell_mean_total =  cell( 1 , 1  );        
        EXP_cell.cell_histograms =  cell( 1 , 1 , 1 , 1);   

    Cmp_type_num  =  var.Cmp_type_num  ;
    Data_type     =  var.Conp_type_data_type ;
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
             
%              if Global_flags.ANALYSIS_ARG.analyze_only_bursts
%                  DataIndex_num = 4 ;
%              end
             
%              DataIndex=  1 ; 
       for DataIndex = 1 : DataIndex_num
           ANALYZE = true ;
           if Global_flags.ANALYSIS_ARG.analyze_only_bursts
               if  DataIndex >= DataIndex_new_delays && DataIndex < DataIndex_delays
                   ANALYZE = false ;
               end
           end
           if ANALYZE      
            if  Global_flags.ANALYSIS_ARG.FILE_LIST_PROCESS
              file_to_take = Global_flags.Files_in_exeperiment   ;
%               if DataIndex >= DataIndex_new_delays && DataIndex < DataIndex_delays
%                  file_to_take = Global_flags.Files_in_exeperiment - 1  ;
%               end
              for file_i = 1 : file_to_take
             DataIndex   ;   
                  for e = 1 : 3
                      for hx_i = 1: Global_flags.histogram_bins_number  
                            EXP_cell.cell_histograms{  DataIndex  , file_i , e , hx_i  } = 0 ; 
                      end
                  end
%                     data_for_hist = ALL_EXPERIMENTS_FULL_RESULTS_all( file_i_curr ).FULL_RESULTS_all.Comp_result.( Comp_result_SNames2{ DataIndex_curr } ) ; 
                    if DataIndex  < DataIndex_new_delays
                        Name_index = strmatch( Comp_result_SNames2{DataIndex } , ALL_cell.Analysis_data_cell_field_names  ) ;                   
                        a = ALL_cell.Analysis_data_cell( file_i , Name_index  )  ; 
                    end
                    if DataIndex >= DataIndex_new_delays && DataIndex < DataIndex_delays 
                        Name_index = strmatch( Comp_result_SNames2{DataIndex } , Comp_result_Names  ) ;        
                        Name_index
                        if ~isempty( Name_index )
                        a = ALL_cell.Comp_type( Cmp_type_num , Data_type ).Comp_result_cell( file_i , Name_index  )  ; 
                        data_for_hist_new = cell2mat( a ) 
                        end
                    end
                    if  DataIndex == DataIndex_delays 
                        if Connectiv_data_present && length( ALL_cell.Connectiv_data ) == file_to_take  
                         [ Number_of_Connections , Connection_delays ]= Connectiv_get_N_connections( ALL_cell.Connectiv_data( file_i )  );
                      	Number_of_Connections ;
                        a = { Connection_delays } ;
                        else
                            a = [] ;
                        end
                    end
                    data_for_hist = cell2mat( a ) ;
%                     data_for_hist = cell2mat( data_for_hist );
 
DataIndex;
                %==== All data from all files =================  
                    if DataIndex  < DataIndex_new_delays
                        Name_index = strmatch( Comp_result_SNames2{DataIndex } , ALL_cell.Analysis_data_cell_field_names  ) ;                   
                        Comp_result_SNames2{ DataIndex  }
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
                        if ~isempty( Name_index )
                        a = ALL_cell.Comp_type( Cmp_type_num , Data_type ).Comp_result_cell( : , Name_index  )  ; 
                        whos a;
                        a
                        data_for_hist_all_files = cell2mat( a ) 
                        whos data_for_hist_all_files;
                        end
                    end
                    if  DataIndex == DataIndex_delays 
                        a= [];
                        if Connectiv_data_present
                            if length( ALL_cell.Connectiv_data ) == file_to_take  
                             for file_i2 = 1 : file_to_take
                                [ Number_of_Connections , Connection_delays ]= Connectiv_get_N_connections( ALL_cell.Connectiv_data( file_i2 )  );
                                Number_of_Connections ;
                                a = [ a Connection_delays ];
                             end
                             whos a;
                             a;
                            end
                        end
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
  
                        
                         
                            HStep = (max( data_for_hist_all_files )+1) / Global_flags.histogram_bins_number ;
                          xxx =  0 : HStep : max( data_for_hist_all_files )+1 ;  
                      
                        
                        
                        
                        [bar_y,xout] = histc( data_for_hist  ,xxx ) ;
                        %- Normalized histogram ---
                            bar_y_norm = 100* bar_y / length( data_for_hist ) ;
                        %----------------------------
                        xout = xxx ; 
                        if length( bar_y_norm ) > 1 
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
%  fileSnames = [ usr '\' 'Comp_result_SNames.mat' ]  
%  ALL_cell.Analysis_data_cell_field_names ;
 
 ExcludeIndex = 33 ; % array fo structss
 
%  eval( ['save ' fileSnames ' Comp_result_SNames' ]);
%  eval( ['load ' fileSnames ] );




Start_file = 1 ;
End_Ctrl_file = 1 ;
if Global_flags.file_number_of_change > 0
  End_Ctrl_file = Global_flags.file_number_of_change ; 
end 
End_file = Global_flags.Files_in_exeperiment  ;


MNDB_Analysis_data_cell_mean_stat_script
% input: Analysis_data_cell EXP_cell
% output: EXP_cell


  
%         for loopIndex = 1 : numel( ALL_cell.Analysis_data_cell_field_names ) - 10
%                    
%             dat = ALL_cell.Analysis_data_cell( Start_file : End_file  , loopIndex ) ; 
%             dat = clear_cell_fromNanInfEmpt( dat );   
%             ss = size( dat{1} )  ; 
%            
%             s=[];
%             for fi=1:numel( dat )
%                si=size(  dat{ fi } );
%                s=[s si(1)];
%             end
%             maxs= max( s(:,1)) ;
%              if maxs == 1
%                dat = dat';     
%              end
%             ALL_cell.Analysis_data_cell_field_names( loopIndex );
%             Total_data = dat ;
%             Total_data(1);
%             whos Total_data;
%             
%              
%             
%         if ~isstruct( Total_data{1} )  && loopIndex ~= ExcludeIndex
%               Total_data = cell2mat( Total_data ) ; 
% %                 a=[];
% %                 for fi=1: length( Files_to_take )
% %                    a = [ a ; cell2mat(  Total_data{ fi } ) ];
% % %                  s=[s si(1)];
% %                 end
%                 
%                 mean_data = mean( Total_data )  ;
%                 std_data = std( Total_data ) ;
%              
%             
%             EXP_cell.cell_mean_total{  loopIndex , 1  } = mean_data;
%             EXP_cell.cell_mean_total{  loopIndex , 2 } = std_data ;
% %             Current_SName = ALL_cell.Analysis_data_cell_field_names( loopIndex );
%             
% %              Name_index = strmatch( 'Number_Spikes' , Comp_result_SNames  ) ;
% %              if Name_index(1) == loopIndex
% %                  dat;
% %                  Total_data;
% %              end
%             
%             %--- Take Control experiment data ----------
% %             for ctrl_i = 1 : Files_to_take
% %                 dat = EXP_cell.cell_data( 1 : Files_to_take , loopIndex ) ;
%                 dat = ALL_cell.Analysis_data_cell( Start_file : End_Ctrl_file , loopIndex ) ;
%                 ss = size( dat{1} )  ;
%                 if ss(1) == 1
%                    dat = dat';     
%                 end 
%                 
%                 Ctrl_data = cell2mat( dat ) ;
%                
%                     Data_is_Stat_different_if_1 = 0 ;
%                    if Global_flags.file_number_of_change > 0 
%                        dat = (  ALL_cell.Analysis_data_cell( End_Ctrl_file +1 : End_file  , loopIndex )  ); 
%                        ss = size( dat{1} )  ;
%                        if ss(1) == 1
%                            dat = dat';     
%                        end 
%                        Effect_data = cell2mat( dat );
%                        
%                        EXP_cell.cell_mean_total{  loopIndex , 3  } = mean( Ctrl_data );
%                        EXP_cell.cell_mean_total{  loopIndex , 4  } = mean( Effect_data ) ;
%                         
%                        if ~isempty( Ctrl_data ) && ~isempty( Effect_data )
%                           s1=size(   Ctrl_data );
%                           s2=size( Effect_data );
%                           if length( s1)==1 && length( s2)==1
%                            [ p , Data_is_Stat_different_if_1 ] = ranksum( Ctrl_data , Effect_data ); 
%                           end
%                        end                    
%                    end
%                    
%                    EXP_cell.cell_statistics{  loopIndex }    =  Data_is_Stat_different_if_1  ;
%                    
%                
%         end
%             %------------------------------------------
%         end
        
        
        
        
        
         EXP_cell.Comp_result_Hist_fieldnames = Comp_result_SNames2 ;
%-----------------------------------------------
 
 
 
 
 
 
 
 
 
 
 
 
 
 