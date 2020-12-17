
 function [ALL_cell ANALYSIS_cell]= Compare_files_connectiv_and_Show_results( ALL_cell , Global_flags , var )
%         Conp_type_data_type = 1 ; % 1=all data compare, 2=only stimulated channels, 3=only non-stim channels
 

% Compare_files_connectiv_and_Show_results
% input:
% ALL_cell  Global_flags
% output:
% ALL_cell.Comp_result
% ALL_cell.Comp_result_cell

Connectiv_data_present = ~isempty( ALL_cell.Connectiv_data ) ;

%-----------------------------------
%-----------------------------------
%-----------------------------------
% var.Conp_type_data_type 
ALL_cell = Compare_connective_all_files_from_cell( ALL_cell , Global_flags , var );
% output:
% ALL_cell.Comp_type( 1 ).Comp_result
% ALL_cell.Comp_type( 1 ).Comp_result_cell
% Comp_type( 1 ) - sequental compare, 2 - 1st file to next
%-----------------------------------
%-----------------------------------
%-----------------------------------
 
Global_flags.ANALYSIS_ARG.analyze_only_bursts = false ;
var.Cmp_type_num = 1 ;

ALL_cell.Global_flags = Global_flags ;


ANALYSIS_cell = [] ;
if Connectiv_data_present
%---- Histograms mean t-tests ----------------------------
 [ ANALYSIS_cell Comp_result_SNames2 ] = ALL_files_analysis_hist_mean( ALL_cell , Global_flags , ...
   ALL_cell.Comp_type( 1 , var.Conp_type_data_type).Comp_result_Names , var ) ; 
%-----------------------------------
end

%-----------------------------------
%-----------------------------------
%-----------------------------------
var.Cmp_type_num = 1 ; % 1 - sequence, 2 - first file compare
if Connectiv_data_present
ALL_cell_Connectiv_compare_results_show( ALL_cell , ANALYSIS_cell , Global_flags , var    )
end

ALL_cell_TotalRate_compare_results_show( ALL_cell ,  Global_flags , var    )

var.show_all_activation_patterns = true ;
ALL_cell_ActivationPattern_compare_results_show( ALL_cell ,  Global_flags , var    )


%-----------------------------------
%-----------------------------------
%-----------------------------------
var.Cmp_type_num = 2 ; % 1 - sequence, 2 - first file compare
if Connectiv_data_present
ALL_cell_Connectiv_compare_results_show( ALL_cell ,ANALYSIS_cell , Global_flags , var    )
end

ALL_cell_TotalRate_compare_results_show( ALL_cell ,  Global_flags , var    )

%-----------------------------------

% a = [ (ALL_cell.Comp_type( 1 ).Comp_result( : ).Number_of_Connections_file1) ];
% a = [ (ALL_cell.Comp_type( 1 ).Comp_result_TOTAL_RATE( : ).Channel_difference_mean) ]




