

function ALL_cell = Compare_connective_all_files_from_cell( ALL_cell , Global_flags , var )
% output:
% ALL_cell.Comp_type( 1 ).Comp_result
% ALL_cell.Comp_type( 1 ).Comp_result_cell
% Comp_type( 1 ) - sequental compare, 2 - 1st file to next

Data_type = var.Conp_type_data_type ;

show_figures_channle_spikerate_compare = false ;

ALL_cell.Comp_type( 1 , Data_type ).Comp_result = [];
ALL_cell.Comp_type( 1 , Data_type).Comp_result_cell = [];
ALL_cell.Comp_type( 2 , Data_type ).Comp_result = [];
ALL_cell.Comp_type( 2 , Data_type).Comp_result_cell = [];
% ALL_cell.Comp_type( 2 ).Comp_result = [];
% ALL_cell.Comp_type( 2 ).Comp_result = [];

ALL_cell.Comp_type( 1 , Data_type).Comp_result_TOTAL_RATE  = [];
ALL_cell.Comp_type( 1 , Data_type).Comp_result_TOTAL_RATE_cell = [];
ALL_cell.Comp_type( 2 , Data_type).Comp_result_TOTAL_RATE  = [];
ALL_cell.Comp_type( 2 , Data_type).Comp_result_TOTAL_RATE_cell = [];
% ALL_cell.Comp_type( 2 ).Comp_result_TOTAL_RATE = [];
% ALL_cell.Comp_type( 2 ).Comp_result_TOTAL_RATE = [];

Connectiv_data_present = ~isempty( ALL_cell.Connectiv_data ) ;

n_files = Global_flags.Files_in_exeperiment - 1;
for file_i = 1 : n_files   
    % compare sequental pairs of files
%     if Global_flags.Comp_sequence_pairs 

        if Connectiv_data_present
        %+++++++++++++++++++++++++++++
         Comp_result = Connectiv_Compare_2_connectiv_data( ALL_cell.Connectiv_data( file_i  , :) , ALL_cell.Connectiv_data( file_i+1 , :) , ...
                ALL_cell.Analysis_data_cell( file_i , : )  , ...
                ALL_cell.Analysis_data_cell( file_i+1  , :) , ALL_cell.Analysis_data_cell_field_names ,  Global_flags );
        %+++++++++++++++++++++++++++++ 
         Comp_result_Names = fieldnames(  Comp_result )  ;  
         Comp_result_cell =  struct2cell(  Comp_result ) ;
         ALL_cell.Comp_type( 1 , Data_type ).Comp_result_cell = [ ALL_cell.Comp_type( 1 , Data_type).Comp_result_cell ; Comp_result_cell' ] ; 
         ALL_cell.Comp_type( 1 , Data_type).Comp_result = [ ALL_cell.Comp_type( 1 , Data_type).Comp_result ; Comp_result' ] ;
        end
        %+++++++++++++++++++++++++++++
        Global_flags.show_figures_channle_spikerate_compare = show_figures_channle_spikerate_compare ;
        Comp_result_TOTAL_RATE = CONN_LIST_EX_Total_rate_Compare_2_data_sets( ALL_cell , file_i , file_i+1   ,   Global_flags );
        %+++++++++++++++++++++++++++++ 
         Comp_result_Names_TOTAL_RATE = fieldnames(  Comp_result_TOTAL_RATE )  ;  
         Comp_result_TOTAL_RATE_cell =  struct2cell(  Comp_result_TOTAL_RATE ) ;
         ALL_cell.Comp_type( 1 , Data_type).Comp_result_TOTAL_RATE_cell = [ ALL_cell.Comp_type( 1 , Data_type).Comp_result_TOTAL_RATE_cell ; Comp_result_TOTAL_RATE_cell' ] ; 
         ALL_cell.Comp_type( 1 , Data_type).Comp_result_TOTAL_RATE  = [ ALL_cell.Comp_type( 1 , Data_type).Comp_result_TOTAL_RATE  ; Comp_result_TOTAL_RATE' ] ;
        
    % compare 1st file to others --------------------------------------------------   
     if Connectiv_data_present
        %+++++++++++++++++++++++++++++
         Comp_result  = Connectiv_Compare_2_connectiv_data( ALL_cell.Connectiv_data( 1  , :) , ALL_cell.Connectiv_data( file_i+1 , :) , ...
                ALL_cell.Analysis_data_cell( 1 , : )  , ...
                ALL_cell.Analysis_data_cell( file_i+1  , :) , ALL_cell.Analysis_data_cell_field_names ,  Global_flags );      
        %+++++++++++++++++++++++++++++
        
         Comp_result_cell  =  struct2cell(  Comp_result  ) ;
         ALL_cell.Comp_type( 2 , Data_type).Comp_result_cell = [ ALL_cell.Comp_type( 2 , Data_type).Comp_result_cell ;  Comp_result_cell' ] ; 
         ALL_cell.Comp_type( 2 , Data_type).Comp_result = [ ALL_cell.Comp_type( 2 , Data_type).Comp_result ;  Comp_result' ] ;         
     end
       %+++++++++++++++++++++++++++++
        Global_flags.show_figures_channle_spikerate_compare = false ;
        Comp_result_TOTAL_RATE = CONN_LIST_EX_Total_rate_Compare_2_data_sets( ALL_cell , 1 , file_i+1   ,   Global_flags );
        %+++++++++++++++++++++++++++++ 
         Comp_result_Names_TOTAL_RATE = fieldnames(  Comp_result_TOTAL_RATE )  ;  
         Comp_result_TOTAL_RATE_cell =  struct2cell(  Comp_result_TOTAL_RATE ) ;
         ALL_cell.Comp_type( 2 , Data_type).Comp_result_TOTAL_RATE_cell = [ ALL_cell.Comp_type( 2 , Data_type).Comp_result_TOTAL_RATE_cell ; Comp_result_TOTAL_RATE_cell' ] ; 
         ALL_cell.Comp_type( 2 , Data_type).Comp_result_TOTAL_RATE  = [ ALL_cell.Comp_type( 2 , Data_type).Comp_result_TOTAL_RATE ; Comp_result_TOTAL_RATE' ] ;
end
 if Connectiv_data_present
 Comp_result_cell_0 =  Comp_result_cell' ;
 Comp_result_cell_0( :) = {0} ; 
ALL_cell.Comp_type( 1 , Data_type).Comp_result_cell = [  Comp_result_cell_0 ; ALL_cell.Comp_type( 1 , Data_type).Comp_result_cell ] ;
ALL_cell.Comp_type( 2 , Data_type).Comp_result_cell = [  Comp_result_cell_0 ; ALL_cell.Comp_type( 2 , Data_type).Comp_result_cell ] ;
ALL_cell.Comp_type( 1 , Data_type).Comp_result_Names =   Comp_result_Names ;
ALL_cell.Comp_type( 2 , Data_type).Comp_result_Names =   Comp_result_Names ;
 end
 Comp_result_TOTAL_RATE_cell_0 =  Comp_result_TOTAL_RATE_cell' ;
 Comp_result_TOTAL_RATE_cell_0( :) = {0} ; 
ALL_cell.Comp_type( 1 , Data_type).Comp_result_TOTAL_RATE_cell = [ Comp_result_TOTAL_RATE_cell_0 ; ALL_cell.Comp_type( 1 , Data_type).Comp_result_TOTAL_RATE_cell ] ;
ALL_cell.Comp_type( 2 , Data_type).Comp_result_TOTAL_RATE_cell = [  Comp_result_TOTAL_RATE_cell_0 ; ALL_cell.Comp_type( 2 , Data_type).Comp_result_TOTAL_RATE_cell ] ;
ALL_cell.Comp_type( 1 , Data_type).Comp_result_Names_TOTAL_RATE =   Comp_result_Names_TOTAL_RATE ;
ALL_cell.Comp_type( 2 , Data_type).Comp_result_Names_TOTAL_RATE =   Comp_result_Names_TOTAL_RATE ;

%-- Compare spike rates --------------------

 
%-------------------------------------------







