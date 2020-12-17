

% Analyze_list_ALL_cell



%  var.Conp_type_data_type = 1 ; % 1 - all channels, 2- stim channels, 3-non-stim channels
%  var.Cmp_type_num = 1 ; % 1 - sequence pairs, 2 - compare to 1st file 
%  var.State = 1 ; 
%  var.Channel = 1 ;
 
 var.Conp_type_data_type =  Global_flags.All_exp_compare_var.Conp_type_data_type ; % 1 - all channels, 2- stim channels, 3-non-stim channels
 var.Cmp_type_num = Global_flags.All_exp_compare_var.Cmp_type_num ; % 1 - sequence pairs, 2 - compare to 1st file 
 var.State = Global_flags.All_exp_compare_var.State ; 
 var.Channel =  Global_flags.All_exp_compare_var.Channel  ;
 
 var = Global_flags.All_exp_compare_var ; 
 
 
 
%  normalize_values = false ; 
%  normalize_values = true ;  
 
%  normalize_values_Compare_connectiv_data = false ;
%  data2d_make_mean_Compare_connectiv_data = false ;
%  normalize_values_Total_Rate_compare = false ;
%  Barplot_for_2d_data_Total_Rate_compare = false ;
 
 normalize_values_Analysis_data = Global_flags.All_exp_compare_var.normalize_values_Analysis_data  ;
 
%  Compare_connectiv_data
 normalize_values_Compare_connectiv_data = Global_flags.All_exp_compare_var.Norm_values_CompConnectiv  ;
 data2d_make_mean_Compare_connectiv_data = Global_flags.All_exp_compare_var.data2d_make_mean_CompConnectiv ;
 Boxplot_data_Compare_connectiv_data = Global_flags.All_exp_compare_var.Boxplot_data_CompConnectiv ;
  
%  Total_Rate_compare
 normalize_values_Total_Rate_compare = Global_flags.All_exp_compare_var.Norm_values_Total_Rate  ;
 data2d_make_mean_Total_Rate_compare = Global_flags.All_exp_compare_var.data2d_make_mean_Rate_compare ;
 Barplot_for_2d_data_Total_Rate_compare = Global_flags.All_exp_compare_var.Boxplot_data_Total_Rate ;
 
 
 var.Compare_vector_each_X_limit_val = Global_flags.Compare_vector_each_X_limit_val ;
 var.Compare_vector_each_X_low_limit_val = Global_flags.Compare_vector_each_X_low_limit_val ;
 
 % plot all data representation
 var.Plot_data_each_file = Global_flags.Analyzed_Experiments_Plot_data_type ;
 
%  normalize_values_compare_values  = true ;

 Value_str_to_show_Analysis_data_cell = Global_flags.Experiments_average_Analysis_data_cell_fields ; 
%  { 'Total_spikes_number' , 'Number_of_Patterns' , 'BurstDurations' , 'InteBurstInterval' ...
%         , 'Spike_Rates_each_burst' , 'Small_bursts_number'  , 'Small_bursts_Davies_Bouldin_Clustering_index' };

 Value_str_to_show_Comp_result_cell = { 'Number_of_Connections_file2' , 'New_Diss_connes_percent_of_1s_file' , 'New_conns_percent_of_1st_file' , ...
        'Dissapeared_conns_percent_of_1st_file' , 'Mean_M_abs_difference_common_connections' , 'Mean_M_difference_common_connections' ,...
        'Mean_tau_max_difference_common_connections' };
 
 Value_str_to_show_Comp_result_TOTAL_RATE_cell = ...
         { 'psth_diff_precent' , 'Channel_difference_increase_abs' , ...
         'Channel_difference_decrease_abs' , 'Channel_difference_mean_ratio_one_value' , ...
         'Channel_difference_increase_mean_ratio_one_value' , ...
     'Channel_difference_decrease_mean_ratio_one_value' , 'Max_corr_delay_diff_vector' , ...  ...
                'Channel_difference_mean' , 'Channels_overlap' , 'Activation_mean_Interchan_diff_vector' , ... 
                'Activation_3_smooth_1ms_mean_Interchan_diff_vector' , 'burst_max_rate_delay_Interchan_diff_vector' ,...
                 'Mean_distance_burst_activation_mean' , 'Mean_distance_burst_activation_2_mean' ,  ...
     'Mean_distance_burst_activation_3_smooth_1ms_mean' , 'Mean_distance_Spike_Rates_each_channel_mean' ...
                };
             
 
%              Value_str_to_show_Comp_result_TOTAL_RATE_cell = ...
%      { 'psth_diff_precent' , 'Channel_difference_mean_one_value' , 'Channel_difference_mean_ratio_one_value' , 'Channel_difference_increase_mean_ratio_one_value' , ...
%      'Channel_difference_decrease_mean_ratio_one_value' , 'Mean_distance_burst_activation_mean' , 'Mean_distance_burst_activation_2_mean' ,  ...
%      'Mean_distance_burst_activation_3_smooth_1ms_mean' , 'Mean_distance_Spike_Rates_each_channel_mean' ...
%                 };
            
            
%  'Channel_difference_mean_one_value' ,
            
            
file_list

ALL_cell_total = [] ;
% Exp_num = n_files ;

file_list = file_list_AA ; 
Exp_num = numel( file_list ) ;

Leave_only_Nfiles_pre_and_post = Global_flags.Leave_only_Nfiles_pre_and_post ;

for Exp_i = 1 : Exp_num
    
   file_path =  [ path_lists{ Exp_i } '\' file_list{ Exp_i } ] ;
   load(  file_path )
   
   %-- Cut files from ALL_Cell list
           if  Leave_only_Nfiles_pre_and_post > 0 % && Reanalyze_something
               ASf =  Leave_only_Nfiles_pre_and_post ;
 
               leave_files_list = ALL_cell.Global_flags.file_number_of_change - ASf + 1: ALL_cell.Global_flags.file_number_of_change + ASf ;
               Global_flags.Files_in_exeperiment = 2*ASf ;
               Global_flags.file_number_of_change =  ASf ;
               ALL_cell.Global_flags.Files_in_exeperiment = Global_flags.Files_in_exeperiment ;
               ALL_cell.Global_flags.file_number_of_change = Global_flags.file_number_of_change ;
               
               ALL_cell.Analysis_data_cell = ALL_cell.Analysis_data_cell(leave_files_list ,:);
               if ~isempty( ALL_cell.Connectiv_data )
               ALL_cell.Connectiv_data = ALL_cell.Connectiv_data(leave_files_list ,:);
               end
               ALL_cell.filenames = ALL_cell.filenames(leave_files_list ,:);
               
               s= size(  ALL_cell.Comp_type );
%                leave_files_list = leave_files_list( 2 : end - 1 ) ;
               for i = 1 : s( 1 )
                   for j = 1 : s( 2 )
                       
                       ALL_cell.Comp_type( i , j ).Comp_result_cell  =  ALL_cell.Comp_type( i , j ).Comp_result_cell(leave_files_list ,:)  ;
                       ALL_cell.Comp_type( i , j ).Comp_result_TOTAL_RATE_cell  =  ALL_cell.Comp_type( i , j ).Comp_result_TOTAL_RATE_cell(leave_files_list ,:)  ;
                   end
               end
               
           end
  %------------------------------
  
   ALL_cell_total = [ALL_cell_total ALL_cell ] ;
end




var.All_exp_2d_data_Hist_bins_num = Global_flags.All_exp_compare_var.All_exp_2d_data_Hist_bins_num ;
 var.Exp_num = Exp_num ;
 
 %-- opens every ALL_cell and takes Comp_result then arrange all Comp_
 All_exp_data_matrix = list_ALL_cell_get_total_matrix( ALL_cell_total , var );
 % output
 % All_exp_data_matrix.Comp_result_cell - same as Comp_result_cell but
 % Comp_result_cell( Exp_i , ... )
 % All_exp_data_matrix.Comp_result_TOTAL_RATE_cell - also 

 %++++++++++++++++++++++++++++++++++++++++++
%   MeaDB_ExpTotal_analyze_connectiv_all_exp( ALL_cell_total , Exp_num  , var  )
%+++ Spike_Rate_Signature +++++++++++++++++++++++++++++++++++++++
%  meaDB_ExpTotal_analyze_one_file_each_exp( All_exp_data_matrix , Exp_num , var)
 %++++++++++++++++++++++++++++++++++++++++++
 
 %---- Takes all All_exp_data_matrix.Comp_result_cell at ( 1...Experiments
 %number , fixed file_i , x , y .. ) and stat compare inside data (it may
 %be value, vector or 2d matrix). then store it
 % All_exp_data_matrix.Comp_result_cell_cross_exp( file_i, stat_i , x, y ),
 % where stat_i - statistics measure (is normal, anova different, ...)
    var.Analysis_structure_str = 'Analysis_data_cell' ;
    var.Analysis_structure_fieldnames = 'Analysis_data_cell_field_names' ;
    var.normalize_values = normalize_values_Analysis_data  ;
        normalize_values = var.normalize_values ;
        
  var.fix_start_file = 0 ;
  var.Start_file = 1 ;   
  var.End_Ctrl_file = 1 ;
if ALL_cell_total(1).Global_flags.file_number_of_change > 0
  var.End_Ctrl_file = ALL_cell_total(1).Global_flags.file_number_of_change ; 
  var.End_file = ALL_cell_total(1).Global_flags.file_number_of_change * 2  ;
else
  var.End_file = ALL_cell_total(1).Global_flags.Files_in_exeperiment  ;  
end
% var.End_file = Global_flags.Files_in_exeperiment  ;


[ Analysis_cell ] = MNDB_All_exp_stat_each_file_script( All_exp_data_matrix , ALL_cell_total(1).Global_flags ,  var );
% input: All_exp_data_matrix
% output: All_exp_data_matrix
 
 
 LD= 1 ;
 
legend_str = cell( Exp_num , 1);
for Exp_i = 1 : Exp_num
legend_str{ Exp_i } = [ 'Exp ' num2str( Exp_i ) ] ;
end

if ALL_cell.Global_flags.file_number_of_change > 0 
   file_number_of_change =  ALL_cell.Global_flags.file_number_of_change ;
else
   file_number_of_change  =0 ;
end


df = 0.5;
file_number_of_change = file_number_of_change + df  ;
%----------------------------------------------------------------
%---------Analysis_data_cell--------------------------------
%----------------------------------------------------------------

% Show results from  Analysis_data_cell
    Value_str_to_show = Value_str_to_show_Analysis_data_cell  ;
    Analysis_structure_str = 'Analysis_data_cell' ;
    Analysis_structure_fieldnames = 'Analysis_data_cell_field_names' ;

    
 
    var.show_hist = false ; % instead of data(file) function, plot data hist
     
    var.data_pair_difference = false ; % all data as diff( data );
    var.Barplot_for_2d_data  =  false ;
    var.data2d_make_mean = true ; % plot&compare 2d data by mean values
    var.compare_diff_with_ctrl = true ; % compare pre-ctrl with post-ctrl if true
        
    figure 
    Nx = 4 ; Ny = 2 ;  
    %----------------------------------------------------------------
    ALL_exp_show_all_values_script
    %----------------------------------------------------------------
    
%----------------------------------------------------------------
%---------Comp_result_cell----------------------------------------
%----------------------------------------------------------------
% Show results from  Analysis_data_cell
    Value_str_to_show = Value_str_to_show_Comp_result_cell ;
    Analysis_structure_str = 'Comp_result_cell' ;
    
 if isfield( All_exp_data_matrix , Analysis_structure_str )
    Analysis_structure_fieldnames = 'Comp_result_Names' ;
    file_number_of_change   = file_number_of_change -2*df ;
 

var.normalize_values = normalize_values_Compare_connectiv_data ;
    normalize_values = var.normalize_values ;
var.data2d_make_mean = data2d_make_mean_Compare_connectiv_data ; % plot&compare 2d data by mean values
var.compare_diff_with_ctrl = false ; % compare pre-ctrl with post-ctrl if true
    

  var.fix_start_file = 1;
  var.Start_file = 1 ;   
  var.End_Ctrl_file = 1 ;
if ALL_cell_total(1).Global_flags.file_number_of_change > 0
  var.End_Ctrl_file = ALL_cell_total(1).Global_flags.file_number_of_change   ; 
end   
var.End_file = ALL_cell_total(1).Global_flags.file_number_of_change * 2      ;  
 



%------------------




     
 %---- Takes all All_exp_data_matrix.Comp_result_cell at ( 1...Experiments
 %number , fixed file_i , x , y .. ) and stat compare inside data (it may
 %be value, vector or 2d matrix). then store it
 % All_exp_data_matrix.Comp_result_cell_cross_exp( file_i, stat_i , x, y ),
 % where stat_i - statistics measure (is normal, anova different, ...)
     var.Analysis_structure_str = Analysis_structure_str  ;
    var.Analysis_structure_fieldnames = Analysis_structure_fieldnames  ;
[ Analysis_cell ] = MNDB_All_exp_stat_each_file_script( All_exp_data_matrix , ALL_cell_total(1).Global_flags ,  var );
% input: All_exp_data_matrix
% output: All_exp_data_matrix

 var.Barplot_for_2d_data  =  Boxplot_data_Compare_connectiv_data ;
    
    figure 
    Nx = 4 ; Ny = 2  ;  
    
     
     
    ALL_exp_show_all_values_script

 end

%----------------------------------------------------------------
%-------Comp_result_TOTAL_RATE_cell------------------------------
%----------------------------------------------------------------
% Show results from  Analysis_data_cell
    Value_str_to_show = Value_str_to_show_Comp_result_TOTAL_RATE_cell ;
    Analysis_structure_str = 'Comp_result_TOTAL_RATE_cell' ;
    
 if isfield( All_exp_data_matrix , Analysis_structure_str )
     
    Analysis_structure_fieldnames = 'Comp_result_Names_TOTAL_RATE' ;
     
    var.normalize_values = normalize_values_Total_Rate_compare ;
    normalize_values = var.normalize_values ;
    var.data2d_make_mean = data2d_make_mean_Total_Rate_compare ; % plot&compare 2d data by mean values
    var.compare_diff_with_ctrl = false ; % compare pre-ctrl with post-ctrl if true
    
    var.fix_start_file = 1;
  var.Start_file = 1 ;   
  var.End_Ctrl_file = 1 ;
if ALL_cell_total(1).Global_flags.file_number_of_change > 0
  var.End_Ctrl_file = ALL_cell_total(1).Global_flags.file_number_of_change   ; 
end   
var.End_file = ALL_cell_total(1).Global_flags.file_number_of_change * 2      ;  
     
%      normalize_values_only_for_some_vals = [ 1 2 3 4 5 6 7 ] ;
    normalize_values_only_for_some_vals = [ ] ;
         
 %---- Takes all All_exp_data_matrix.Comp_result_cell at ( 1...Experiments
 %number , fixed file_i , x , y .. ) and stat compare inside data (it may
 %be value, vector or 2d matrix). then store it
 % All_exp_data_matrix.Comp_result_cell_cross_exp( file_i, stat_i , x, y ),
 % where stat_i - statistics measure (is normal, anova different, ...)
     var.Analysis_structure_str = Analysis_structure_str  ;
    var.Analysis_structure_fieldnames = Analysis_structure_fieldnames  ;
[ Analysis_cell ] = MNDB_All_exp_stat_each_file_script( All_exp_data_matrix , ALL_cell_total(1).Global_flags ,  var );
% input: All_exp_data_matrix
% output: All_exp_data_matrix

    
    figure 
    Nx = 4 ; Ny = 4  ;  
    
     var.Barplot_for_2d_data  = Barplot_for_2d_data_Total_Rate_compare  ;
     var.data_2d_take_negative =false ; 
    var.data_2d_take_positive =false;
     
    ALL_exp_show_all_values_script
    
    figure 
    Nx = 4 ; Ny = 4  ; 
    var.Barplot_for_2d_data  = true ;
    var.data_2d_take_negative =false ; 
    var.data_2d_take_positive =true;
     
    ALL_exp_show_all_values_script

    figure 
    Nx = 4 ; Ny = 4  ; 
    var.data_2d_take_negative =true ; 
    var.data_2d_take_positive =false;
     
    ALL_exp_show_all_values_script


 end

