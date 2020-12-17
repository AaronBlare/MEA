
% Analyze_list_files_post_analyze2 



if Test_connectiv_list_files
    file_number = n_files ;
    if Global_flags.file_number_of_change > 0
        file_number = Global_flags.file_number_of_change ;
    end
%     Connectiv_Test_all_Nconn_vs_mintau_minM
    
  Optimal_parameters =  Connectiv_Test_all_Nconn_vs_mintau_minM_from_Cell( ALL_cell , file_number ,Global_flags );
    
    
end
cell_filed_names = {} ;
if isfield( ALL_cell , 'Connectiv_data' )
    cell_filed_names = ALL_cell.Connectiv_data ; 
end

var.Cmp_type_num  = 1  ;
var.Conp_type_data_type = 1 ;

Global_flags.ANALYSIS_ARG = ANALYSIS_ARG ;

var.analyze_only_bursts = true ;
%---- Histograms mean t-tests ------------------------------
 [ ANALYSIS_cell Comp_result_SNames2 ] = ALL_files_analysis_hist_mean( ALL_cell , Global_flags , ...
   ALL_cell.Analysis_data_cell_field_names  ,  var ) ; 
%-----------------------------------------------------------
 
var.filename_defined = false ;
 meaDB_CompareResults_save(   ANALYSIS_ARG ,ANALYSIS_cell, ALL_cell , Global_flags , var)
        %input var.filename_defined, var.result_filename










