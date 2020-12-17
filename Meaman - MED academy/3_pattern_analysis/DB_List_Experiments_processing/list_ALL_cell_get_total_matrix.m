%-- opens every ALL_cell and takes Comp_result then arrange all Comp_
 function All_exp_data_matrix = list_ALL_cell_get_total_matrix( ALL_cell_total , var)
 % output
 % All_exp_data_matrix.Comp_result_cell - same as Comp_result_cell but
 % Comp_result_cell( Exp_i , ... )
 % All_exp_data_matrix.Comp_result_TOTAL_RATE_cell - also 
 All_exp_data_matrix = [] ;
 
 I = var.Cmp_type_num ;
 J = var.Conp_type_data_type ;
 
 Compare_data_present = isfield( ALL_cell_total , 'Comp_type'); 
 
 if Compare_data_present
     Connectiv_data_present = ~isempty( ALL_cell_total( 1 ).Comp_type( I , J ).Comp_result_cell ) ;

     if Compare_data_present
      s = size(ALL_cell_total( 1 ).Comp_type( I , J ).Comp_result_cell );  
      All_exp_data_matrix.Comp_result_cell = cell( var.Exp_num  , s(1) , s(2) ); 
      All_exp_data_matrix.Comp_result_Names = ALL_cell_total( 1 ).Comp_type( I , J ).Comp_result_Names ;
     end

      s = size(ALL_cell_total( 1 ).Comp_type( I , J ).Comp_result_TOTAL_RATE_cell );  
      All_exp_data_matrix.Comp_result_TOTAL_RATE_cell = cell( var.Exp_num  , s(1) , s(2) ); 
      All_exp_data_matrix.Comp_result_Names_TOTAL_RATE = ALL_cell_total( 1 ).Comp_type( I , J ).Comp_result_Names_TOTAL_RATE ;  
  
 end
 
  s = size(ALL_cell_total( 1 ).Analysis_data_cell );  
  All_exp_data_matrix.Analysis_data_cell = cell( var.Exp_num  , s(1) , s(2) ); 
  All_exp_data_matrix.Analysis_data_cell_field_names = ALL_cell_total( 1 ).Analysis_data_cell_field_names ;  
  

  for Exp_i = 1 : var.Exp_num 
    if  Compare_data_present  
      if Connectiv_data_present
          dat =  (ALL_cell_total( Exp_i ).Comp_type( I , J ).Comp_result_cell );  
          All_exp_data_matrix.Comp_result_cell( Exp_i , : , : ) = dat ;  
      end
    
           dat =  (ALL_cell_total( Exp_i ).Comp_type( I , J ).Comp_result_TOTAL_RATE_cell )  ;
          All_exp_data_matrix.Comp_result_TOTAL_RATE_cell( Exp_i , : , : ) = dat ;  
    end
 
  
        dat =  (ALL_cell_total( Exp_i ).Analysis_data_cell );  
        All_exp_data_matrix.Analysis_data_cell( Exp_i , : , : ) = dat ; 
 

  end
    
    
    
    