




% MNDB_Analysis_data_cell_mean_stat_script
% input: Analysis_data_cell EXP_cell
% output: EXP_cell

analyze_2d_data = false ; % analyze stats if each parameter is 2d data

group1=  Start_file : End_Ctrl_file ;
group2 = End_Ctrl_file +1 : End_file ;
Snames = ALL_cell.Analysis_data_cell_field_names ;
State =1;  Channel =1 ;

for loopIndex = 1 : numel(  Snames )  
                   
             dat = ALL_cell.Analysis_data_cell( Start_file : End_file , loopIndex , State , Channel   )  ; 
%             dat = clear_cell_fromNanInfEmpt( dat );   
%               Name_index = strmatch( 'Mean_M_abs_difference_common_connections' , Comp_result_SNames  ) ;
%             if loopIndex == Name_index
%                 dat;
%             end
            Name  = Snames( loopIndex  )
            whos dat
            
            single_dat = ALL_cell.Analysis_data_cell( 1 , loopIndex , State , Channel   );
            single_dat_size = size( single_dat{1} )   
            single_dat_first_el =  single_dat{1} ;
%             whos single_dat_first_el
            
%             check length of all line
           size_all_elements = cellfun(@numel , dat ) 
           all_equal_size_if_0 = std( size_all_elements );
           
           size_all_elements=[];
           for i=1:numel( dat)
               single_dat_size = size( dat{i} )  ;
               size_all_elements = [ size_all_elements ; single_dat_size ];               
           end
           std_all_elements_sizes = std( size_all_elements );
           all_equal_size_if_0 = sum( std_all_elements_sizes );
           
           % if data to average is nor cell array
           if ~iscell( single_dat_first_el )
           % all data structs are equal sizes, so analyze them           
           if all_equal_size_if_0 == 0 && ~ischar( cell2mat( single_dat ) ) && ~isstruct( cell2mat( single_dat ) )   
               
%                whos dat 
                Total_data = dat ;  
                
                if iscell( single_dat )
                    whos Total_data
                    if strcmp( Name , 'Timebin_BA_A_srprofile' )
                        f=0;
                    end
                Total_data = cell2mat( Total_data ) ;  
                end
               
               %-------------------------------------
               % if analyzing single value for aech file
               if mean( single_dat_size ) == 1 
                   a= 1
                    %--- ttest Group1-Group2 single values ---------- 
                    dat =   ALL_cell.Analysis_data_cell( group1 , loopIndex , State , Channel  )   ; 
                    Group1_vals =   dat  ; 
                    
               
                   Data_is_Stat_different_if_1 = 0 ;
                   if End_Ctrl_file > 0 
                       dat =     ALL_cell.Analysis_data_cell( group2  , loopIndex , State , Channel   )   ;  
                       Group2_vals =  dat  ;
                       
                       if iscell( single_dat ) 
                        Group1_vals = cell2mat( Group1_vals ) ;  
                        Group2_vals = cell2mat( Group2_vals ) ;  
                        end
                       
                       EXP_cell.cell_mean_total{  loopIndex , 3 , State , Channel   } = mean( Group1_vals ) ;
                       EXP_cell.cell_mean_total{  loopIndex , 4 , State , Channel   } = mean( Group2_vals ) ;
                        
                       if ~isempty( Group1_vals ) && ~isempty( Group2_vals ) &&  std( Group1_vals)>0 && ...
                                std( Group2_vals) > 0
                          s1=size(  Group1_vals );
                          s2=size( Group2_vals );
%                           if length( s1)==1 && length( s2)==1
                         
                            x1 = (Group1_vals-mean( Group1_vals) )/ std( Group1_vals) ;
                            h1_norm_if_0 = kstest( x1 );
                            x2 = (Group2_vals-mean( Group2_vals) )/ std( Group2_vals) ;
                            h2_norm_if_0 = kstest( x2 ); 
                            Data_is_Stat_different_if_1=0;
%                             if h1_norm_if_0 == 0 && h2_norm_if_0 == 0
%                               [  Data_is_Stat_different_if_1 , p ] =ttest2( Group1_vals , Group2_vals );
%                             end    
                           [ p , Data_is_Stat_different_if_1 ] = ranksum( Group1_vals , Group2_vals ); 
%                           end
                       end                    
                   end
                   
                   EXP_cell.cell_statistics{  loopIndex , 1 , State , Channel   }    =  Data_is_Stat_different_if_1  ;
                 
               end
               
               %------------------------------------
               % if analyzing vector for aech file
               if min( single_dat_size ) == 1 && max( single_dat_size)>1 
                   
                   single_dat_mat = cell2mat(single_dat) ;  
                   
                   a=2
                   % single_dat should be line
                   line_length = size_all_elements(1) 
                   
                   % if single data is column but not row
                   if single_dat_size(2) == 1
                       dat=dat';
                       if iscell( single_dat )
                            Total_data = cell2mat( dat ) ;  
                            Total_data = Total_data' ;
                        end
                   end
                    
                   Total_data;
                   
                   whos Total_data
                   whos dat
                   
%                    if iscolumn( Total_data )
%                        Total_data=Total_data';
%                    end
                   
%                    whos Total_data
                   
                   Stat_diff_line = zeros( 1 ,line_length );
                   Mean_Group1_line = mean( Total_data( group1 , : ) ) ;
                   Std_Group1_line = std( Total_data( group1 , : ) ) ;
                   Mean_Group2_line = mean( Total_data( group2 , : ) ) ;
                   Std_Group2_line = std( Total_data( group2 , : ) ) ;
                       
                   % stat compare each column
                   for i = 1 : line_length
                       Group1_vals = Total_data( group1 , i );  
                       Group2_vals = Total_data( group2 , i ); 
                        
                       Data_is_Stat_different_if_1 = 0 ;
                       if ~isempty( Group1_vals ) && ~isempty( Group2_vals ) &&  std( Group1_vals)>0 && ...
                                std( Group2_vals) > 0 
                            x1 = (Group1_vals-mean( Group1_vals) )/ std( Group1_vals) ;
                            h1_norm_if_0 = kstest( x1 );
                            x2 = (Group2_vals-mean( Group2_vals) )/ std( Group2_vals) ;
                            h2_norm_if_0 = kstest( x2 ); 
                            Data_is_Stat_different_if_1=0;
%                             if h1_norm_if_0 == 0 && h2_norm_if_0 == 0
%                               [  Data_is_Stat_different_if_1 , p ] =ttest2( Group1_vals , Group2_vals );
%                             end    
                           [ p , Data_is_Stat_different_if_1 ] = ranksum( Group1_vals , Group2_vals ); 
%                           end
                       end 
                       Stat_diff_line( i ) = Data_is_Stat_different_if_1  ;
                   end
                   
                   EXP_cell.cell_mean_total{  loopIndex , 3 , State , Channel   } = Mean_Group1_line ;
                   EXP_cell.cell_mean_total{  loopIndex , 4 , State , Channel   } = Mean_Group2_line ;  
                   EXP_cell.cell_mean_total{  loopIndex , 5 , State , Channel   } = Std_Group1_line ;
                   EXP_cell.cell_mean_total{  loopIndex , 6 , State , Channel   } = Std_Group2_line ;  
                   EXP_cell.cell_statistics{  loopIndex , 1 , State , Channel   }    =  Stat_diff_line  ;
                %-------------------------------    
                   
               end
               
               %------------------------------------
               % if analyzing 2d array for aech file
               if min( single_dat_size ) > 1 && analyze_2d_data
                   a=3
                   size_all_elements
                   
                    line_length = size_all_elements(1);
                    
%                     Start_file = 1 ; 
%                     End_Ctrl_file = Global_flags.ctrl_n_files ;  
%                     End_file
                    
                   Stat_diff_matrix = zeros( single_dat_size ); 
                   Norm_distr_matrix = zeros( single_dat_size ); 
                   Mean_Group1_matrix = zeros( single_dat_size ); 
                   Mean_Group2_matrix = zeros( single_dat_size ); 
                   Std_Group1_matrix = zeros( single_dat_size ); 
                   Std_Group2_matrix = zeros( single_dat_size ); 
                       
                   group1_files =( group1 - 1)* single_dat_size(1)    ;
                   group2_files =( group2 - 1)* single_dat_size(1)    ;
                   for i = 1 : single_dat_size(1)
                       
                       for j = 1 : single_dat_size(2) 
                           Group1_vals = Total_data( i + group1_files , j );
                           Group2_vals = Total_data( i + group2_files , j );
                           
                           use_mean_stat = true ;% true-mean,std, false-median,mad
                           
                           if use_mean_stat
                               Mean_Group1_matrix( i , j ) = mean( Group1_vals ); 
                               Mean_Group2_matrix( i , j ) = mean( Group2_vals ); 
                               Std_Group1_matrix( i , j ) = std( Group1_vals ); 
                               Std_Group2_matrix( i , j ) = std( Group2_vals );  
                           else                           
                               Mean_Group1_matrix( i , j ) = median( Group1_vals ); 
                               Mean_Group2_matrix( i , j ) = median( Group2_vals ); 
                               Std_Group1_matrix( i , j ) = mad( Group1_vals ); 
                               Std_Group2_matrix( i , j ) = mad( Group2_vals ); 
                           end
                           
                           Data_is_Stat_different_if_1 = 0 ;
                           Data_is_Norm_dist_if_1 = 0 ;
                           if ~isempty( Group1_vals ) && ~isempty( Group2_vals ) &&  std( Group1_vals)>0 && ...
                                    std( Group2_vals) > 0 
                                x1 = (Group1_vals-mean( Group1_vals) )/ std( Group1_vals) ;
                                h1_norm_if_0 = kstest( x1 );
                                x2 = (Group2_vals-mean( Group2_vals) )/ std( Group2_vals) ;
                                h2_norm_if_0 = kstest( x2 ); 
                                Data_is_Stat_different_if_1=0;
%                                 if h1_norm_if_0 == 0 && h2_norm_if_0 == 0
%                                     Data_is_Norm_dist_if_1 = 1 ;
%                                   [ Data_is_Stat_different_if_1 , p ] =ttest2( Group1_vals , Group2_vals );
%                                 end    
                               [ p , Data_is_Stat_different_if_1 ] = ranksum( Group1_vals , Group2_vals ); 
%                                Data_is_Stat_different_if_1 = p ;
    %                           end
                           end 
                           Stat_diff_matrix( i , j ) = Data_is_Stat_different_if_1  ;
                           Norm_distr_matrix( i , j ) = Data_is_Norm_dist_if_1  ;
                       end
                   end
                   
                   % stat compare each column  
                   
                   EXP_cell.cell_mean_total{  loopIndex , 3 , State , Channel   } = Mean_Group1_matrix ;
                   EXP_cell.cell_mean_total{  loopIndex , 4 , State , Channel   } = Mean_Group2_matrix ;  
                   EXP_cell.cell_mean_total{  loopIndex , 5 , State , Channel   } = Std_Group1_matrix ;
                   EXP_cell.cell_mean_total{  loopIndex , 6 , State , Channel   } = Std_Group2_matrix ;   
                   
                   EXP_cell.cell_statistics{  loopIndex , 1 , State , Channel   }    =  Stat_diff_matrix  ;
                   EXP_cell.cell_statistics{  loopIndex , 2 , State , Channel   }    =  Norm_distr_matrix  ;
                %-------------------------------    
                   
               end
                   
                
                
            mean_data = mean( Total_data )  ;
            std_data = std( Total_data ) ; 
            
            EXP_cell.cell_mean_total{  loopIndex , 1 , State , Channel   } = mean_data;
            EXP_cell.cell_mean_total{  loopIndex , 2 , State , Channel  } = std_data ;
            
           end
           end
 end
            %------------------------------------------
            
            
            
            
            
            