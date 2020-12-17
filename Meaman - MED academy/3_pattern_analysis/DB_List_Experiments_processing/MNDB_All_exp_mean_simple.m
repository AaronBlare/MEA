


function [ Analysis_cell ] = MNDB_All_exp_mean_simple( All_exp_data_matrix ,  Global_flags , var) 
% input: All_exp_data_matrix
% output: Analysis_cell

p_val_threshold = 0.05 ;

Analysis_cell_2d  = false ; 

        Analysis_cell.cell_statistics =  cell( 1 , 1  );
        Analysis_cell.cell_mean_total =  cell( 1 , 1  );        
        Analysis_cell.cell_histograms =  cell( 1 , 1 , 1 , 1);   

    Analysis_structure_str = var.Analysis_structure_str ;
    Analysis_structure_fieldnames = var.Analysis_structure_fieldnames ;
         
    
%  ssize = size(    All_exp_data_matrix.Analysis_data_cell );
%  files_num = ssize(1) ;
 
 normalize_values = var.normalize_values ;
      
 

Snames = All_exp_data_matrix.(Analysis_structure_fieldnames)  ; 

for loopIndex = 1 : numel(  Snames )  
    for fi = 1 : 1
             loopIndex 
                 dat = All_exp_data_matrix.(Analysis_structure_str)(  : , loopIndex   )  ; 
               
            
            emptyIndex = cellfun(@isempty,dat);       %# Find indices of empty cells
            dat(emptyIndex) = {0};                    %# Fill empty cells with 0
            
            Name  = Snames( loopIndex  )
            whos dat
            
            single_dat = All_exp_data_matrix.(Analysis_structure_str)( 1 , loopIndex     );
            single_dat_size = size( single_dat{1} )    
            single_dat_first_el =  single_dat{1} ;
%             whos single_dat_first_el
            
%             check length of all line
           size_all_elements = cellfun(@numel , dat );
           all_equal_size_if_0 = std(std( size_all_elements ));
           
           % if data to average is nor cell array
           if ~iscell( single_dat_first_el )
           % all data structs are equal sizes, so analyze them           
           if  ~ischar( cell2mat( single_dat ) ) && ~isstruct( cell2mat( single_dat ) )   
               
%                whos dat 
                Total_data = dat ;  
%                 if iscell( single_dat )
%                 Total_data = cell2mat( Total_data ) ;  
%                 end
                
                if mean( single_dat_size ) == 1 
                    
                    d=cellfun(@size, Total_data  ,'uni',0);
                    e=cell2mat(d);
                    f=all( all(e==1) )
                    if f
                      Total_data = cell2mat( Total_data ) ;  
                    else
                      single_dat_size = 0 ;  
                    end
                end
               
               %-------------------------------------
               %-------------------------------------
               %-------------------------------------
               %-------------------------------------
               %-------------------------------------
               % if analyzing single value for aech file
               if mean( single_dat_size ) == 1 
%--------------- 1 VALUE COMPARE-----------------------------------                   
                   a= 1
                    %--- ttest Group1-Group2 single values ---------- 
%                     dat =   All_exp_data_matrix.(Analysis_structure_str)( : , group1 , loopIndex , State , Channel  )   ; 
                     
                       
                       if normalize_values && ~islogical(Total_data( 1  ))
                           for ei = 1:    size_all_elements(2)
%                            for ei = 1:   files_num
%                             data_matrix( sy , : ) = data_matrix( sy , : )/ data_matrix( sy , 1 );
%                             data_matrix( sy , : ) = data_matrix( sy , : ) - data_matrix( sy , 1 ) ;       
                            Total_data
                             Total_data( ei  ) = 100 * ( Total_data( ei  ) ...
                                            / Total_data( ei , 1 ))    ;  % percent of change from 1st file
                           end
                       end
             
                        Group1_vals =  Total_data( :   )   ;    
                       Group1_vals = reshape(Group1_vals,[],1);  
                       
                       Group1_vals(isnan(Group1_vals)) =  0 ; 
                       Total_data(isnan( Total_data )) =  0 ; 
                       
                       Analysis_cell.cell_mean_total{  loopIndex , 3    } = mean( Group1_vals ) ; 
                       Analysis_cell.cell_mean_total{  loopIndex , 5    } = std( Group1_vals ) ; 
                       
                       %-- Test if all group 1 values from al exp are
                       %normal
                         
                        total_data_0_if_normal = jbtest(Group1_vals) ;
                        Group1_is_normal_if_0 = total_data_0_if_normal == 0 ;
                        Analysis_cell.cell_mean_total{  loopIndex , 7   } = ~total_data_0_if_normal ;
                         
                       
                       p =1; 
                        
                     
                 
               end
               
               %------------------------------------
               %-------------------------------------
               %-------------------------------------
               %-------------------------------------
               %-------------------------------------
               %-------------------------------------
               %-------------------------------------
               % if analyzing vector for aech file
               if min( single_dat_size ) == 1 && max( single_dat_size)>1 
 %--------------- VECTOR COMPARE-----------------------------------                                     
                   single_dat_mat = cell2mat(single_dat) ;  
                   
                   a=2
                   
                   single_dat
                   
                   skipit = false ; 
                   
                   if ~skipit
                       
                    d=cellfun(@numel, Total_data  ,'uni',0);
                    e=cell2mat(d);
                    all_2d_data_equal_size =all( all(e==e(1)) );
                    
                    
                   if all_2d_data_equal_size ~= 1
                       if iscell( single_dat )
%                             data = cell2mat( Total_data(1) ) ;  
                            ;
%                             Total_data( : , 1   )  
                       end
                       
                   else
                    
                       
                       if iscell( single_dat )
                            Total_data = cell2mat( Total_data' ) ;  
                       end
                       
%                    whos Total_data    
                        
                   
                   Total_data( abs( Total_data ) > var.Compare_vector_each_X_limit_val  ) = NaN ;
                    
                       Group1_vals =  Total_data( :    )   ;   
%                        Group1_vals = reshape(Group1_vals,[],1);  
                       
                       Analysis_cell.cell_mean_total{  loopIndex , 3   } = mean( Total_data , 2) ; 
                       Analysis_cell.cell_mean_total{  loopIndex , 5     } = std( Total_data , 0 , 2) ; 
                       
                       %-- Test if all group 1 values from al exp are
                       %normal
                         
                        
                       
%                         total_data_0_if_normal = jbtest(Group1_vals) ;
%                         Group1_is_normal = total_data_0_if_normal == 0 ;
%                         Analysis_cell.cell_mean_total{  loopIndex , 7    } =Group1_is_normal ;
                         
                       
%                        p =1; 
                        
                 
                     
                   end
                   end
               end
               
               %------------------------------------
               % if analyzing 2d array for aech file
               if min( single_dat_size ) > 1
                   a=3
                   size_all_elements
                   
                    skipit = false ; 
                   
                   if  skipit
                       
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
                   for i = 1 : single_dat_size(1)
                       
                       for j = 1 : single_dat_size(2) 
                           Group1_vals = Total_data( i  , j );  
                           use_mean_stat = true ;% true-mean,std, false-median,mad
                           
                           if use_mean_stat
                               Mean_Group1_matrix( i , j ) = mean( Group1_vals );  
                               Std_Group1_matrix( i , j ) = std( Group1_vals );  
                           else                           
                               Mean_Group1_matrix( i , j ) = median( Group1_vals );  
                               Std_Group1_matrix( i , j ) = mad( Group1_vals );  
                           end 
                       end
                   end
                   
                   % stat compare each column  
                   
                   Analysis_cell.cell_mean_total{  loopIndex , 3     } = Mean_Group1_matrix ; 
                   Analysis_cell.cell_mean_total{  loopIndex , 5     } = Std_Group1_matrix ; 
                    
                %-------------------------------    
                   end
               end
                   
                
                
%             mean_data = mean( Total_data )  ;
%             std_data = std( Total_data ) ;  
            mean_data = NaN  ;
            std_data = NaN ; 
            
            Analysis_cell.cell_mean_total{  loopIndex , 1   } = mean_data;
            Analysis_cell.cell_mean_total{  loopIndex , 2   } = std_data ;
            
            analyze_whola_data = false ;
            % test normality for Total_data as one vector
            if analyze_whola_data 
            x=reshape(Total_data,[],1);
            total_data_is_normal = false; 
            if ~isempty( x )
                total_data_0_if_normal = jbtest( x ) ;
                total_data_is_normal = total_data_0_if_normal == 0 ;
            end
            end
%             Analysis_cell.cell_mean_total{  loopIndex , 8    } = total_data_is_normal ;
            
           end
           end
           
    end 
 end
            %------------------------------------------
            
            
            
            
            
            