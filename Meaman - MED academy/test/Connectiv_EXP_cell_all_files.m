
%   Connectiv_EXP_cell_all_files.m

% Input:
%   Files with analysis of many connectivity DB files
% Output:
%  compare characteristics of files


 usr = userpath ;
 usr( end ) = [] ;
 fileSnames = [ usr '\' 'Comp_result_SNames.mat' ] ;
 
 eval( ['load ' fileSnames ] );
% eval( 'loadComp_result_SNames.mat' );


files = { 'ANAlYSIS_List_files_compare_connectivity_600.mat'
          'ANAlYSIS_List_files_compare_connectivity_1200.mat' ; 
          'ANAlYSIS_List_files_compare_connectivity_2400.mat' ;
          'ANAlYSIS_List_files_compare_connectivity_4800.mat'     
} ;


% files = { 'ANAlYSIS_List_files_compare_connectivity_4800.mat' ;  
%           'ANAlYSIS_List_files_compare_connectivity_4800.mat'     
% } ;

% files = { 'ANAlYSIS_List_files_compare_connectivity_600.mat'
%           'ANAlYSIS_List_files_compare_connectivity_1200.mat' ; 
%           'ANAlYSIS_List_files_compare_connectivity_2400.mat' ;
%           'ANAlYSIS_List_files_compare_connectivity_4800.mat' ;
%            'ANAlYSIS_List_files_compare_connectivity_9600.mat'    
% } ;
bin_title = '10-20-40-80' ;

 
% EXP_cell_all = [];
load( files{ 1 } )
EXP_cell_all = EXP_cell ;
ex_n = 1 ;

        
for loopIndex = 1:numel(Comp_result_SNames)       
    
%     if loopIndex == strmatch( 'Burst_rate_number' , Comp_result_SNames  ) ; 
%        files_to_analyze = length( files ) ;
%     else
%        files_to_analyze = length( files ) ; 
%     end
    
        for fi = 1 : length( files )
             load( files{ fi } )
                               
            dat = EXP_cell.cell_data( ex_n ,  :  , loopIndex ) ;
            ss = size( dat{1} ) ;
            ss ;
            if ss(1) == 1
%                 
%                 if  loopIndex == 48
                if  loopIndex >0                    
                    dat;
                    loopIndex;
%                     Total_data = clear_cell_mat( dat );

                    Total_data = clear_cell_fromNanInfEmpt( dat );
                    Total_data = cell2mat( Total_data )  ;
%                     Total_data = cell2mat( dat ) ;  
                else
                  Total_data = cell2mat( dat ) ;  
                end
                
                % if now analyze connections from file1 then add from file
                % 2
               if  loopIndex ==  strmatch( 'Number_of_Connections_file1' , Comp_result_SNames  ) ;
                   Index2 =   strmatch( 'Number_of_Connections_file2' , Comp_result_SNames  ) ;
                    DataFile2 = EXP_cell.cell_data( ex_n ,  end  , Index2 ) ;
                    DataFile2 = clear_cell_fromNanInfEmpt( DataFile2 );
                    DataFile2 = cell2mat( DataFile2 )  ;
                   Total_data = [ Total_data DataFile2 ] ;
               end
                
                EXP_cell_all.cell_mean_total{ fi ,  loopIndex   , 1 } = mean( Total_data ) ;
                EXP_cell_all.cell_mean_total{ fi ,  loopIndex   , 2 } = std( Total_data ) ;
                Current_SName = Comp_result_SNames( loopIndex );           
            end
             
        end
end

ex_list = 1 :  length( files )   ;
% ex_list= [ 10 20 40 80 160 ]; 


figure
Nx = 4 ; Ny = 2 ;
fi = 0 ;

%	Number_of_Connections_file1 
%	Number_of_dissappear_Connections 
%	Number_of_appear_Connections 
%	Mean_M_abs_difference_common_connections 

                
         
                
  subplot(Ny,Nx, 1 );
 
%                Name_index = strmatch( 'BurstDurations_mean1' , Comp_result_SNames  ) ; 
               Name_index = strmatch(  'Burst_rate_number'   , Comp_result_SNames  ) ; 
                               
                data_mean_cell = EXP_cell_all.cell_mean_total( : ,  Name_index(1)  , 1 ) ;
                data_mean = clear_cell_mat( data_mean_cell ) ;
                  
                data_std_cell = EXP_cell_all.cell_mean_total( : ,  Name_index(1)  , 2 ) ;           
                data_std = clear_cell_mat( data_std_cell  ) ;
             
               
                if ~isempty( data_mean )
                    handles = barwitherr( data_std    , ex_list  ,  data_mean , 2 );
                    if max( data_std ) > 0 
                        axis( [ min( ex_list ) -  1 max( ex_list )+1  0  1.2* max( data_mean ) + max(data_std)  ]   )
                    end
                end
                xlabel( 'File number')
                ylabel('Duration, ms')
%                 title( [ 'Burst durations'  ] ) 
                title( [ bin_title ', Number of Bursts'  ] )  
                
                

subplot(Ny,Nx, 2 ); 
%                Name_index = strmatch( 'BurstDurations_mean1' , Comp_result_SNames  ) ; 
               Name_index = strmatch( 'BurstDurations_mean' , Comp_result_SNames  ) ; 
                               
                data_mean_cell = EXP_cell_all.cell_mean_total( : ,  Name_index(1)  , 1 ) ;
                data_mean = clear_cell_mat( data_mean_cell ) ;
                  
                data_std_cell = EXP_cell_all.cell_mean_total( : ,  Name_index(1)  , 2 ) ;           
                data_std = clear_cell_mat( data_std_cell  ) ;
             
               
                if ~isempty( data_mean )
                    handles = barwitherr( data_std    , ex_list  ,  data_mean , 2 );
                    if max( data_std ) > 0 
                        axis( [ min( ex_list ) -  1 max( ex_list )+1  0  1.2* max( data_mean ) + max(data_std)  ]   )
                    end
                end
                xlabel( 'File number')
                ylabel('Duration, ms')
%                 title( [ 'Burst durations'  ] ) 
                title( [ 'Bursts durations'  ] )  
                
                
                
  subplot(Ny,Nx, 3 );

               Name_index = strmatch( 'Number_of_Connections_file1' , Comp_result_SNames  ) ;
%                Name_index = 2 ;

                data_mean_cell = EXP_cell_all.cell_mean_total( : ,  Name_index(1)  , 1 ) ;
                data_mean = clear_cell_mat( data_mean_cell ) ;
                  
                data_std_cell = EXP_cell_all.cell_mean_total( : ,  Name_index(1)  , 2 ) ;           
                data_std = clear_cell_mat( data_std_cell  ) ;
             
               
                if ~isempty( data_mean )
                    handles = barwitherr( data_std    , ex_list  ,  data_mean , 2 );
                    if max( data_std ) > 0 
                        axis( [ min( ex_list ) -  1 max( ex_list )+1  0  1.2* max( data_mean ) + max(data_std)  ]   )
                    end
                end
                xlabel( 'File number')
%                 ylabel('Duration, ms')
                title( [ 'Number of Connections file1'   ] ) 
                
                
                 

      
                
                
  subplot(Ny,Nx, 4 ); 
  
               Name_index = strmatch( 'Mean_M_abs_difference_common_connections' , Comp_result_SNames  ) ;

                data_mean_cell = EXP_cell_all.cell_mean_total( : ,  Name_index(1)  , 1 ) ;
                data_mean = clear_cell_mat( data_mean_cell ) ;
                  
                data_std_cell = EXP_cell_all.cell_mean_total( : ,  Name_index(1)  , 2 ) ;           
                data_std = clear_cell_mat( data_std_cell  ) ;
             
                data_mean=data_mean(~isnan(data_mean(:)),:);
                data_std=data_std(~isnan(data_std(:)),:);
                if ~isempty( data_mean )
                    handles = barwitherr( data_std    , ex_list  ,  data_mean , 2 );
                    if max( data_std ) > 0 
                        axis( [ min( ex_list ) -  1 max( ex_list )+1  0  1.2* max( data_mean ) + max(data_std)  ]   )
                    end
                end
                xlabel( 'File number')
%                 ylabel('Duration, ms')
                title( [ 'difference common connections'   ] )    
                
                
  subplot(Ny,Nx, 5 ); 
  
               Name_index = strmatch( 'New_Diss_connes_percent_of_1s_file' , Comp_result_SNames  ) ;

                data_mean_cell = EXP_cell_all.cell_mean_total( : ,  Name_index(1)  , 1 ) ;
                data_mean = clear_cell_mat( data_mean_cell ) ;
                  
                data_std_cell = EXP_cell_all.cell_mean_total( : ,  Name_index(1)  , 2 ) ;           
                data_std = clear_cell_mat( data_std_cell  ) ;
                
                if ~isempty( data_mean )
                    handles = barwitherr( data_std    , ex_list  ,  data_mean , 2 );
                    if max( data_std ) > 0 
                        axis( [ min( ex_list ) -  1 max( ex_list )+1  0  1.2* max( data_mean ) + max(data_std)  ]   )
                    end
                end
                xlabel( 'File number')
%                 ylabel('Duration, ms')
                title( [ 'New Diss connes percent of 1s file'   ] )                  
                
  subplot(Ny,Nx, 6 );

               Name_index = strmatch( 'New_conns_percent_of_1st_file' , Comp_result_SNames  ) ;
 
                data_mean_cell = EXP_cell_all.cell_mean_total( : ,  Name_index(1)  , 1 ) ;
                data_mean = clear_cell_mat( data_mean_cell ) ;
                  
                data_std_cell = EXP_cell_all.cell_mean_total( : ,  Name_index(1)  , 2 ) ;           
                data_std = clear_cell_mat( data_std_cell  ) ;
             
               
                if ~isempty( data_mean )
                    handles = barwitherr( data_std    , ex_list  ,  data_mean , 2 );
                    if max( data_std ) > 0 
                        axis( [ min( ex_list ) -  1 max( ex_list )+1  0  1.2* max( data_mean ) + max(data_std)  ]   )
                    end
                end
                
                xlabel( 'File number')
%                 ylabel('Duration, ms')
                title( [ '% of appear Connections'   ] )    
                
                
                
                
  subplot(Ny,Nx, 7 );

               Name_index = strmatch( 'Dissapeared_conns_percent_of_1st_file' , Comp_result_SNames  ) ;
 
                data_mean_cell = EXP_cell_all.cell_mean_total( : ,  Name_index(1)  , 1 ) ;
                data_mean = clear_cell_mat( data_mean_cell ) ;
                  
                data_std_cell = EXP_cell_all.cell_mean_total( : ,  Name_index(1)  , 2 ) ;           
                data_std = clear_cell_mat( data_std_cell  ) ;
             
               data_mean = abs(data_mean);
                if ~isempty( data_mean )
                    handles = barwitherr( data_std    , ex_list  ,  data_mean , 2 );
                    if max( data_std ) > 0 
                        axis( [ min( ex_list ) -  1 max( ex_list )+1  0  1.2* max( data_mean ) + max(data_std)  ]   )
                    end
                end
                
                xlabel( 'File number')
%                 ylabel('Duration, ms')
                title( [ '% of dissappear Connections'   ] )                    
                
                


%-----------------------------------------------