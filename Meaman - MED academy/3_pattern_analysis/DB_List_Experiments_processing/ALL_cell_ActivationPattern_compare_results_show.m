
%%-- Connectiv_compare_results_show
function ALL_cell_ActivationPattern_compare_results_show( ALL_cell ,  Global_flags , var)
 


ex_n=1;



Cmp_type_num  = var.Cmp_type_num ;
Data_type = var.Conp_type_data_type ;

figure_title = [ 'Compare sequence = ' num2str( Cmp_type_num ) ', Compare type = ' num2str( Data_type ) ] ;

ex_list = 1 : Global_flags.Files_in_exeperiment   ;
ex_list_ctrl_data = 1 : Global_flags.file_number_of_change   ;
ex_list_ctrl_data_from2nd = 1 : Global_flags.file_number_of_change - 1 ;
n_files = Global_flags.Files_in_exeperiment  ;


Default_StatAsterix = '()' ;

ctrl_exp_bar_color = 'b' ;
if Global_flags.file_number_of_change  > 0
    all_bar_color = 'r' ;
else
    all_bar_color = 'b' ;
end

 
if isfield( var , 'show_all_activation_patterns' )
   show_all_activation_patterns = var.show_all_activation_patterns ;
else
    show_all_activation_patterns = false ;
end
    
  
%%--- show only all action patterns ---------------------------
if show_all_activation_patterns 
    
  Nx = ceil( sqrt( n_files ));
  Ny = Nx ; 
  if Nx + Ny < n_files
      Ny = Ny + 1 ;
  end

           f=figure ; 
             set(f, 'name',  figure_title ,'numbertitle','off' )          
           %-------------------------------------------------------
           for fi = 1 : n_files
               subplot(Ny  ,  Nx  , fi  +  0  ); 
               Value_data_string = 'burst_activation_3_smooth_1ms_mean' ;
               Name_index = strmatch( Value_data_string , ALL_cell.Analysis_data_cell_field_names  ) ;
               dat =cell2mat( ALL_cell.Analysis_data_cell( fi , Name_index ) ); 

               Plot8x8Data( dat , false );
               if Global_flags.file_number_of_change  >0 
                   if fi <= Global_flags.file_number_of_change 
                      title( 'Ctrl' )
                   else
                      title( 'Effect')
                   end
               end
           end
          
else  
    
end
%%----------------                      
                      
                      
                      
                      
                      
                      
                      
                      
            
                