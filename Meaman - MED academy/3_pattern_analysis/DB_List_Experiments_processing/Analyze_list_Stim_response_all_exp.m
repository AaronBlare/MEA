
% Analyze_list_Stim_response_all_exp
normalize_values_Analysis_data  = false;  

s = length( ALL_cell.filenames ) ;

%  Analysis_data_TOTAL_RATE
% Analysis_data_T_act
% Analysis_data_SpikeRate



%  Value_str_to_show_Analysis_data_cell = { 'Total_spikes_number' , 'Number_of_Patterns' , 'BurstDurations' , 'InteBurstInterval' ...
%         , 'Spike_Rates_each_burst' , 'Small_bursts_number'  , 'Small_bursts_Davies_Bouldin_Clustering_index' };


%---- Takes all All_exp_data_matrix.Comp_result_cell at ( 1...Experiments
 %number , fixed file_i , x , y .. ) and stat compare inside data (it may
 %be value, vector or 2d matrix). then store it
 % All_exp_data_matrix.Comp_result_cell_cross_exp( file_i, stat_i , x, y ),
 % where stat_i - statistics measure (is normal, anova different, ...)
    var.Analysis_structure_str = 'Analysis_data_cell' ;
    var.Analysis_structure_fieldnames = 'Analysis_data_cell_field_names' ;
    var.normalize_values = normalize_values_Analysis_data  ;
        normalize_values = var.normalize_values ;
  var.Exp_num = 1 ;      
  var.fix_start_file = 0 ;
  var.Start_file = 1 ;   
  var.End_Ctrl_file = s ;  
  var.End_file =  s ; 
var.Cmp_type_num  = 1 ;
var.Conp_type_data_type  = 1 ;
var.State = 1;
var.Channel =1 ;
var.group2_empty = true ;
var.Analysis_cell_2d = true ;

var.Compare_vector_each_X_limit_val = 0 ;
 var.Compare_vector_each_X_limit_val = Global_flags.Compare_vector_each_X_limit_val ;
 %++++++++++++++++++++++++++++++++++++++++++
[ Analysis_cell ] = MNDB_All_exp_mean_simple( ALL_cell ,  Global_flags ,  var );
% input: All_exp_data_matrix
% output: All_exp_data_matrix
%++++++++++++++++++++++++++++++++++++++++++


    var.Analysis_structure_str = 'Analysis_data_TOTAL_RATE' ;
    var.Analysis_structure_fieldnames = 'Analysis_data_TOTAL_RATE_names' ;
 %++++++++++++++++++++++++++++++++++++++++++
[ Analysis_cell.Analysis_data_TOTAL_RATE ] = MNDB_All_exp_mean_simple( ALL_cell ,  Global_flags ,  var );
% input: All_exp_data_matrix
% output: All_exp_data_matrix
%++++++++++++++++++++++++++++++++++++++++++

    var.Analysis_structure_str = 'Analysis_data_T_act' ;
    var.Analysis_structure_fieldnames = 'Analysis_data_T_act_names' ;
 %++++++++++++++++++++++++++++++++++++++++++
[ Analysis_cell.Analysis_data_T_act ] = MNDB_All_exp_mean_simple( ALL_cell ,  Global_flags ,  var );
% input: All_exp_data_matrix
% output: All_exp_data_matrix
%++++++++++++++++++++++++++++++++++++++++++

% Show results from  Analysis_data_cell
%     Value_str_to_show = Value_str_to_show_Analysis_data_cell  ; 

    
 
    var.show_hist = false ; % instead of data(file) function, plot data hist
     
    var.data_pair_difference = false ; % all data as diff( data );
    var.Barplot_for_2d_data  =  false ;
    var.data2d_make_mean = true ; % plot&compare 2d data by mean values
    var.compare_diff_with_ctrl = true ; % compare pre-ctrl with post-ctrl if true
        
%     figure 
%     Nx = 4 ; Ny = 2 ;  
    %----------------------------------------------------------------
    ALL_stim_exp_show_all_values_script
    %----------------------------------------------------------------
    









