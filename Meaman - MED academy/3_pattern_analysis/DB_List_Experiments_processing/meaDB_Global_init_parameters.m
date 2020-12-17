% meaDB_Global_init_parameters

% Analyze_list_ALL_cell - after all experiments analyzed, this function
% averages all

%===============================================================
%===============================================================
%=== Parameters for 2 file sets compare ========================
%===============================================================
 Global_Bin_hist_ratio = 10 ; % Histogram of diff ratio with defined bin step
 Global_Max_SR_ratio = 300 ;
 
 ANALYSIS_ARG.Select_pair_of_files = false ;
 ANALYSIS_ARG.Use_3_files = false ; 
 
        Global_flags.COMPARE_ONLY_TOTAL_SPIKE_RATES = false ;   
        Global_flags.SHOW_FIGURES = true ;
        Global_flags.SHOW_FIGURES_sample = true ;
        Global_flags.High_Resp_Thr_percent = 0 ; 
        Global_flags.Low_Resp_Thr_percent = 100 ; 
        % ANALYSIS_ARG.Use_Small_response = false ;
        Global_flags.Count_zero_values = true ; %  
        Global_flags.Use_3_files = ANALYSIS_ARG.Use_3_files  ;
        
        Global_flags.Filter_Small_Inadequate_Responses  = false ;
        Global_flags.Erase_Patterns_filter = false  ; % erase responses manualy (spikerate bounds)
            Global_flags.Erase_Patterns_Min_TSR = 100 ;
            Global_flags.Erase_Patterns_Max_TSR = 1000 ;
                
        Global_flags.Cluster_Low_High_Responses = false ;
        Global_flags.ANALYSE_SIMILARITY_Tactivation = true ;
        
  Global_flags.cycle_all_electrodes  = false ;
  Global_flags.Electrode_selection_extract_channel = false ;
  Global_flags.EL_SEL_stim_chan_to_extract = 0 ;
  Global_flags.Use_one_Elsel_file = false ;       
  Global_flags.Erase_low_responses = false  ; 
  
  Global_flags.Recalc_all_patterns = false ;
           Global_flags.recalc_Global_Poststim_interval_START  = 10 ;
           Global_flags.recalc_Global_Poststim_interval_END = 60 ;
           Global_flags.recalc_Global_DT_bin  = 5 ;
           Global_flags.Electrode_selection_extract_channel = false ;
           Global_flags.OVERLAP_TRESHOLD =  25 ;
           Global_flags.PvalRanksum = 0.05  ;
           Global_flags.random_channel = 'n' ;  
           Global_flags.Analazyng_responses = true ;
           
           Global_flags.MINIMUM_PATTERNS_PER_RECORD = 10 ;
    
           Start_t = 20 ;
           Pattern_length_ms = 300 ; 
           Total_burst_len =300 ;
           DT_step= 20 ;
           Global_flags.STIM_RESPONSE_BOTH_INPUTS = 0.5 ; % each pattern should be "adequate" which is checked by is_pattern_adequate()
           Global_flags.Leave_only_clean_responses = false ;
            ANALYSE_SIMILARITY = true ;
            OVERLAP_TRESHOLD = 15 ;
            PvalRanksum = 0.05 ;
            Spike_Rates_each_burst_cut_Threshold_precent = 10 ; % Threshold for small bursts, % from Maximum burst
            %----------------------
            Cycle_close_all = false ; % if true - close all plots in each entry of cycle mane experiments
            ANALYSE_ONE_EXPERIMENT =  1  ; % [1,7, 15 - is good]if > 0 will analyse only exepiment from list with number ANALYSE_ONE_EXPERIMENT
            Exclude_experiments_list = []; %[10 13 14 22 23 25];
            GLOB_cycle_start =1 ; %2
            GLOB_cycle_step =1;   % 1
            GLOB_cycle_end =1;   % 64
            
            
         Global_flags.ElSel_auto_load_protocol = true ; % for each experiment load ElSel 
        Global_flags.ElSel_stim_chan_to_extract = 8 ; % if cycle_all_electrodes == false & ElSel_auto_load_protocol == true 
 
        
        
        
        
%==================================================
Experiment_type = 'ElSel_day_by_day' ;
        ElSel_files_in_exeperiment = 3 ;  
        Global_flags.Channel_difference_mean_ratio_StableCTRL_thres = 30  ; % plot results only if in ctrl1-ctrl2 change lower than thresh
%==================================================%         
Experiment_type = 'Tetanisation' ;

        
%       Analyzed_data_compare 
%==================================================
Experiment_type = 'Analyzed_data_compare' ;
    Test_connectiv_list_files = false ;
    ANALYSIS_ARG.analyze_only_bursts = false ;
    
    % default burst parameters to show on plots
    Global_flags.List_Files_burst_parameters_values = ...
     { 'Active_channels_number' ,  'Spikes_per_sec' ,'Firing_rate_per_channel  '  ...
       'Amps_mean_all_spikes '   ,   'Bursts_per_min' ,  };
     
    % burst parameters to show on plots for Chamber AB analysis
    Global_flags.Chambers_AB_analysis_show = false ;
        Global_flags.Chambers_AB_Files_burst_parameters =  { 'Active_channels_number' , ...
         'Chambers_A_Nbursts' , 'Chambers_B_Nbursts' , 'Chambers_A_B_evoked_percent'  ...
        , 'Chambers_B_A_evoked_percent' , 'Chambers_A_B_evoked_mean_delay' , 'Chambers_B_A_evoked_mean_delay' , ...
        'Chambers_chan_div_AB_Firing_rate_per_electrode_Hz' , ...
        'Chambers_Amps_chan_div_AB_all_spikes' ...
        } ; % take list files from DB and shw this parameters   'Chambers_A_Nbursts_per_min' , 'Chambers_B_Nbursts_per_min' 
        
        Chambers_AB_Experiments_average_fields = Global_flags.Chambers_AB_Files_burst_parameters ; % when average experiments with multiple files
%        { 'Total_spikes_number' , 'Number_of_Patterns' , 'BurstDurations' , 'InteBurstInterval' ...
%         , 'Spike_Rates_each_burst' , 'Small_bursts_number'  , 'Small_bursts_Davies_Bouldin_Clustering_index' };
%==================================================
Experiment_type = 'Analyzed_Experiments_average' ;  
    Global_flags.All_ExpContaires_reanalyze = false  ;
   Global_flags.Analyze_bursts_parameters_from_Gui = false ;
   Global_flags.Analyzed_Experiments_Plot_data_type = 'Boxplot' ; % Plot data from all files using one of selected types :
%                 'Line-errorbar'  'Bar-errorbar' 'Boxplot' 'All data, meean'
   
    All_ExpContaires_reanalyze = false ;
%==================================================
Experiment_type = 'Connectivity_Experiments_average' ;    
    Global_flags.Compare_vector_each_X_limit_val = 3000 ; % when compare vectors (values at each channel for each X, some channels has inf values,
     Global_flags.Compare_vector_each_X_low_limit_val = 3 ; % same as previous ... data_matrix( abs( data_matrix ) <=    var.Compare_vector_each_X_low_limit_val  ) = NaN ;
%             , then replace them with NaN if their abs value greater then this limit,

    Global_flags.All_ExpContaires_reanalyze = false  ; % files Compare_analysis_AA_....mat reanalyze according to filenames inside
    
    Global_flags.Take_one_file_pre_post = false ; % - takes only one file pre and one - post. 
    Global_flags.Leave_only_Nfiles_pre_and_post = 0 ; 
            % 3 - after split then leave only 3 files pre-stim and 3 files post stimm, 0 -do nothing
    Global_flags.Min_spikes_per_channel_compare = 5 ;
    Global_flags.Compare_channel_difference_spikes_min = 1  ; 
    
         %===== Parameters for Compareing all experiments ======================================== 
         Global_flags.All_exp_compare_var.Conp_type_data_type = 1 ; % 1 - all channels, 2- stim channels, 3-non-stim channels
         Global_flags.All_exp_compare_var.Cmp_type_num = 1 ; % 1 - sequence pairs, 2 - compare to 1st file 
         Global_flags.All_exp_compare_var.State = 1 ; 
         Global_flags.All_exp_compare_var.Channel = 1 ;
 
          %  Compare burst characteristics data
         Global_flags.All_exp_compare_var.normalize_values_Analysis_data = false ; % Normalize values

        %  Compare_connectiv_data
         Global_flags.All_exp_compare_var.Norm_values_CompConnectiv = false ; % Normalize values
         Global_flags.All_exp_compare_var.data2d_make_mean_CompConnectiv = false;
         Global_flags.All_exp_compare_var.Boxplot_data_CompConnectiv = false ;

        %  Total_Rate_compare
         Global_flags.All_exp_compare_var.Norm_values_Total_Rate = false ; % Normalize values
         Global_flags.All_exp_compare_var.data2d_make_mean_Rate_compare = false ;
         Global_flags.All_exp_compare_var.Boxplot_data_Total_Rate = false ;

        Global_flags.All_exp_compare_var.All_exp_2d_data_Hist_bins_num  = 50 ;
 
        Default_Experiments_average_fields = ...
           { 'Total_spikes_number' , 'Number_of_Patterns' , 'BurstDurations' , 'InteBurstInterval' ...
            , 'Spike_Rates_each_burst' , 'Small_bursts_number'  , 'Small_bursts_Davies_Bouldin_Clustering_index' };

%==================================================        
Experiment_type = 'Connectivity_compare' ;
   Global_flags.Connects_min_M_strength = 0.05 ; % compare connection with strength > set here
   Global_flags.Connects_min_tau_diff = 3   ; % if delay of connection less than this, then this is not connection
   Global_flags.Connectiv_min_spikes_per_channel = 15 ;
   Global_flags.Check_Spike_Rates = false ; % used in connectiv compare when measure is_connection_ok - test if 
%                 spikes per channel is enough (>=   Global_flags.Connectiv_min_spikes_per_channel
   Global_flags.Files_in_exeperiment = 0 ;   % if 0 then all files is one experemint
   Global_flags.file_number_of_change = 0  ; % if 4 then first 4 data bars will be blue and next bars will be red       
   Global_flags.Comp_sequence_pairs = true ; % if true, then analyze consequrnt pairs of files, if false - 1st with others
    %    Compare sequence = 1 - sequence, 2 - first file compare
    %    Compare type = 1=all data compare, 2=only stimulated channels, 3=only non-stim channels     
   
   Global_flags.Show_compare_figure = false ; % show connectivity matrix of files during analysis
   Global_flags.histogram_bins_number = 30 ; % Color histograms number of bins
   Global_flags.Test_connectiv_list_files = false ;
   Global_flags.Analyze_selected_channels = [  ] ; % if []-analyze all channels, if [1 2]-first analyze connectivity of them, then all others
   
   % split raster from DB 
   Global_flags.Split_raster_into_intervals_and_analyze = false ; % split raster from DB 
        Global_flags.Split_raster_period_min = 20 ;
        Global_flags.Max_raster_time_min = 60 ;
        Global_flags.Split_raster_ratio =  Global_flags.Max_raster_time_min / Global_flags.Split_raster_period_min ; 
        
        % if raster was 60 min and new raster is 3 x 20 min then value = 3
    
        
        
        %-- Process list of files with names from DB
        ANALYSIS_ARG.FILE_LIST_PROCESS  = true ;
        ANALYSIS_ARG.FILE_LIST_PROCESS_defined  = true ;
        ANALYSIS_ARG.FILE_LIST_PROCESS_filename = '_Compare2sets_listfiles_DBnames.txt' ;
        ANALYSIS_ARG.FILE_LIST_list_files = false ;
        %-- Analyze  all mat files in foledr ANALYSIS_ARG.FILE_LIST_PROCESS_filename
        ANALYSIS_ARG.Take_all_DB_matfiles  = false ;

        ANALYSIS_ARG.Analyze_one_file  = false ;
        %---- Select mat files from DB for Ctrl-Effect analysis
        ANALYSIS_ARG.FILE_LIST_PROCESS_ask_2file_sets = true ;
%         ANALYSIS_ARG.FILE_LIST_PROCESS_ask_2file_sets = false ;

        %----- Reanalyze bursts and connectivity when processsing list of files
           Global_flags.Force_Reanalyze_bursts_connectiv = false ;   
           Global_flags.Force_Reanalyze_only_bursts = false ; % false ;  
           Global_flags.Force_Reanalyze_only_connectiv = false ;
           Global_flags.Auto_upgrade_bursts_connectiv = false ; 
            
 
 %==================================================
Experiment_type = 'Stim_response_compare' ;            
           %--- MAIN parameters---------------
           DEFINED_FILE_LIST = true ;
           Global_flags.ElSel_auto_load_protocol = true ; % for each experiment load ElSel 
           Global_flags.ElSel_stim_chan_to_extract = 8 ; % if cycle_all_electrodes == false & ElSel_auto_load_protocol == true 
           Tet_files_in_exeperiment = 3 ;
           ElSel_files_in_exeperiment = 3 ;
           Global_flags.Electrode_selection_extract_channel = true ;
           Global_flags.electrode_sel_param_channel1 = 4  ;
           Global_flags.electrode_sel_param_channel2 = 5 ; 
           
           Global_flags.cycle_all_electrodes = true ;
           Global_flags.stim_response_min_dist_electrodes  = 4 ;
           Global_flags.pause_after_each_compare = true ;
           
 %--------------------------------------  
%---Experiment_type selection -----------------------------------           
% Experiment_type = 'Tetanisation' ;  % 'Connectivity_compare'  'Analyze_one_file_ElSel'   'Tetanisation' ;
% Experiment_type = 'Analyze_one_file_ElSel' ; 
% Experiment_type = 'Connectivity_Experiments_average' ;
Experiment_type = 'Tetanisation' ;
% Experiment_type = 'Analyzed_data_compare'
% Experiment_type = 'Analyzed_Experiments_average' ;
%--------------------------------------
%--------------------------------------

switch Experiment_type
    case 'Tetanisation'
        Tet_files_in_exeperiment = 3 ;

        Global_flags.Use_3_files= true ; 
        ANALYSIS_ARG.Use_3_files= true ;   
        Global_flags.Electrode_selection_extract_channel = false ;    
        Global_flags.ElSel_stim_chan_to_extract = 0 ; % if cycle_all_electrodes == false & ElSel_auto_load_protocol == true 
        
        Global_flags.ElSel_auto_load_protocol = false ; % for each experiment load ElSel 
        
        Global_flags.cycle_all_electrodes  = false ; % protocol from text line in file list
           Global_flags.extract_one_stim_channel =  0  ; % number in sequence of stim electrodes , 0 - no extraction
           
           % Reanalyze stim response with new post-stim interval :
             Global_flags.Recalc_all_patterns = true ;
           Global_flags.recalc_Global_Poststim_interval_START  = 10 ;
           Global_flags.recalc_Global_Poststim_interval_END =  150 ;
           Global_flags.recalc_Global_DT_bin  = 5 ;
           
        Global_flags.Filter_Small_Inadequate_Responses  = false ;
        Global_flags.Erase_Patterns_filter = false ; % erase responses manualy (spikerate bounds)
            Global_flags.Erase_Patterns_Min_TSR = 100 ;
            Global_flags.Erase_Patterns_Max_TSR = 500 ; 
            
        % cluster High-Low responses    
        Global_flags.Cluster_Low_High_Responses = false ;
            Global_flags.Erase_low_responses = true ; %  
            Global_flags.High_patterns_as_default = true ; % no effect
            Global_flags.Leave_only_clean_responses = false  ; % true  false 
        
        % Compare connection between electrodes in different chambers AB
        Global_flags.Connectiv_Only_between_chanbers = false ; 
        
        % Erase selected channels for analysis    
        Global_flags.CompareFiles_erase_channels = true ; % Erase spikes from channels for analysis  
%         Global_flags.CompareFiles_erase_channels_number = [  15 16 ; 14 17 ; 13 18 ; 4 27 ; 57 34; 48 43 ; 47 44 ; 46 45  ]  ;
        Global_flags.CompareFiles_erase_channels_number = [ 10 12 15 16 19 21  7 9 11 14 17 20 22 24 5 2 59  6 1 60  8 3 58  13 4 57  18 27 34  23 28 33  25 30 31  26 29 32  ] ; 
%          Global_flags.CompareFiles_erase_channels_number = [ 57 58 60  ] ; 
       
       
 
        Global_flags.ANALYSE_SIMILARITY_Tactivation = true ;
        Global_flags.COMPARE_ONLY_TOTAL_SPIKE_RATES = true ;
        ANALYSIS_ARG.FILE_LIST_list_files = true ;
    case 'Stim_response_compare'
        Tet_files_in_exeperiment = 1 ; 
        Global_flags.Use_one_Elsel_file = true ; % load from one elsel stim_responses 2 set of patterns
        Global_flags.Erase_low_responses = true ;
    case 'Analyze_one_file_ElSel'    
        ANALYSIS_ARG.Analyze_one_file  = true ; 
        ANALYSIS_ARG.FILE_LIST_PROCESS  = false ;
        ANALYSIS_ARG.FILE_LIST_PROCESS_defined  = false ;
         Global_flags.electrode_sel_param_string = ...
         'Start=1 Step=4 Last=60 Stimuli=30 Correct_protocol=0 Tet1=1 Tet2=20' ;
         Global_flags.electrode_sel_param =...
                       electrode_sel_param_from_string(  Global_flags.electrode_sel_param_string )   ;
    case 'Connectivity_Experiments_average'                
         
        
    case  'Analyzed_Experiments_average'     
        if Global_flags.Chambers_AB_analysis_show 
            Global_flags.Experiments_average_Analysis_data_cell_fields =  ...
            Chambers_AB_Experiments_average_fields ;
        else
            Global_flags.Experiments_average_Analysis_data_cell_fields =  ...
             Default_Experiments_average_fields ;
        end
        
      Global_flags.All_ExpContaires_reanalyze =All_ExpContaires_reanalyze ;
      if All_ExpContaires_reanalyze
        Global_flags.Force_Reanalyze_only_bursts = true ;
      end
end
         
     MEA_DB_parameters_load      
ANALYSIS_ARG.FILE_LIST_PROCESS_filename = [ MATLAB_folder  '\' ANALYSIS_ARG.FILE_LIST_PROCESS_filename ];            

   
 Global_flags.ElSel_files_in_exeperiment = ElSel_files_in_exeperiment ;
 Global_flags.Tet_files_in_exeperiment = Tet_files_in_exeperiment ;


%===============================================================                
%===============================================================