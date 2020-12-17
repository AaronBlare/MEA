

%% meaDB_Main_script
% before run Analysis_2_sets_init_parameters should be loaded
%  close all 
 
Only_process_computed_data = true;
Only_process_computed_data = false ;

%!!!!!!!!!!!!!!!%!!!!!!!!!!!!!!!%!!!!!!!!!!!!!!!%!!!!!!!!!!!!!!!
%% Parameters in Analysis_2_sets_init_parameters.m file
%!!!!!!!!!!!!!!!%!!!!!!!!!!!!!!!%!!!!!!!!!!!!!!!%!!!!!!!!!!!!!!!
GLOBAL_CONSTANTS_load
% Analysis_2_sets_init_parameters
meaDB_Global_init_parameters

    Filename_Analysis_RESULT_ALL = 'ANAlYSIS_List_files_compare_all_SHORT_RESULTS.mat' ; 
    Filename_Analysis_FULL_RESULT_ALL = 'ANAlYSIS_List_files_compare_all_FULL_RESULTS.mat' ;
 
              
            
    %--- Burst analysis parameters --------------------
    Find_bursts_GUI_input
    %     Search_Params.SsuperBurst_scale_sec  
    %     Search_Params.TimeBin  
    %     Search_Params.AWSR_sig_tres 
    %     Search_Params.save_bursts_to_files  
    %     Search_Params.List_files2 
    %     Search_Params.Arg_file 
    %---------------------------------------------------
Global_flags.Find_bursts_GUI_input_Search_Params = Search_Params ;
  
%% -- CompPat_filelistprocess        
if ~Only_process_computed_data
n_files = 2 ;
files_step = 1 ;
 
CompPat_filelistprocess
% out: file_list n_files
end

%% ---------main Cycle
if ~Only_process_computed_data
    processed = false ;
if strcmp(Experiment_type, 'Connectivity_Experiments_average') && Global_flags.All_ExpContaires_reanalyze
    All_ExpContaires_reanalyze = Global_flags.All_ExpContaires_reanalyze;
    Experiment_type = 'Connectivity_compare' ;
    file_list_AA = file_list ;
    Global_flags_init = Global_flags ;
    Search_Params_init = Search_Params ;
   for Exp_i_all = 1 : numel( file_list_AA )
             load(  file_list_AA{ Exp_i_all } )
           close all
             
            file_list =  ALL_cell.filenames;
            n_files= numel(file_list ) ;
            Global_flags =  ALL_cell.Global_flags ;
            if Global_flags.Files_in_exeperiment == 0 ;
                Global_flags.Files_in_exeperiment = n_files(1) ;
            end
             
            Global_flags.Find_bursts_GUI_input_Search_Params = Search_Params_init ;
            Global_flags.original_AA_file = file_list_AA{ Exp_i_all } ;
            ANALYSIS_ARG.Select_pair_of_files = false ;
            ANALYSIS_ARG.Use_3_files = false ;
            ANALYSIS_ARG.file_lists = file_lists ;
            Global_flags.cycle_all_electrodes = false ;
%             Global_flags.Force_Reanalyze_bursts_connectiv = true ;  
            Global_flags.Force_Reanalyze_bursts_connectiv = Global_flags_init.Force_Reanalyze_bursts_connectiv ; 
            Global_flags.Force_Reanalyze_only_bursts = Global_flags_init.Force_Reanalyze_only_bursts ; 
            Global_flags.Force_Reanalyze_only_connectiv = Global_flags_init.Force_Reanalyze_only_connectiv ; 
            Global_flags.Auto_upgrade_bursts_connectiv = Global_flags_init.Auto_upgrade_bursts_connectiv ; 
            Global_flags.All_ExpContaires_reanalyze  = Global_flags_init.All_ExpContaires_reanalyze  ;
            Global_flags.Split_raster_into_intervals_and_analyze = Global_flags_init.Split_raster_into_intervals_and_analyze ; % split raster from DB 
            Global_flags.Split_raster_period_min = Global_flags_init.Split_raster_period_min ;
            Global_flags.Max_raster_time_min = Global_flags_init.Max_raster_time_min ;
            Global_flags.Split_raster_ratio = Global_flags_init.Split_raster_ratio ;
            Global_flags.Take_one_file_pre_post = Global_flags_init.Take_one_file_pre_post ;
            Global_flags.Compare_channel_difference_spikes_min = Global_flags_init.Compare_channel_difference_spikes_min ;
            Global_flags.Min_spikes_per_channel_compare = Global_flags_init.Min_spikes_per_channel_compare ;
            
            Reanalyze_something = Global_flags.Force_Reanalyze_bursts_connectiv | Global_flags.Force_Reanalyze_only_bursts ...
                 |  Global_flags.Force_Reanalyze_only_connectiv | Global_flags.Auto_upgrade_bursts_connectiv ...
                 | Global_flags.Split_raster_into_intervals_and_analyze ;
            % take only few files pre and post if split all rasters
            if  Global_flags.Split_raster_into_intervals_and_analyze && Global_flags.file_number_of_change > 0 ...
                    && Global_flags.Take_one_file_pre_post
%                  file_list_new =   file_list(  Global_flags.file_number_of_change :  Global_flags.file_number_of_change +1  );
%                  Global_flags.file_number_of_change = 1 ;
                 
%                  file_list_new =   file_list(  Global_flags.file_number_of_change -2 : Global_flags.file_number_of_change + 3 );
%                  Global_flags.file_number_of_change = 3 ;
                  
%                  file_list_new =   file_list(  Global_flags.file_number_of_change -1 : Global_flags.file_number_of_change + 2 );
%                  Global_flags.file_number_of_change = 2 ;
                
                 file_list_new =   file_list(  Global_flags.file_number_of_change   : Global_flags.file_number_of_change + 1 );
                 Global_flags.file_number_of_change = 1 ;               
                                  
                 
                 file_list  = file_list_new ;
                 n_files= numel(file_list ) ;
                 
                 Global_flags.Files_in_exeperiment = n_files ;
            end
            
            
%            % init for meaDB_Listfiles_open_process_loop
%             if Exp_i_all == 1
%                 Init_global_var = true ;
%             else 
%                 Init_global_var = false ;
%             end
            Exp_i_all
            if Reanalyze_something
            %//////////////////////////////////////////////////////////////
            meaDB_Listfiles_open_process_loop
            %//////////////////////////////////////////////////////////////
            end
             
             if  Global_flags.Split_raster_into_intervals_and_analyze
                       Global_flags.Files_in_exeperiment = Global_flags.Files_in_exeperiment * ...
                            Global_flags.Split_raster_ratio ;
                       Global_flags.file_number_of_change = Global_flags.file_number_of_change * ...
                           Global_flags.Split_raster_ratio ;
             end
           %-- leave only few file pre-stim and post-stim
           if Global_flags_init.Leave_only_Nfiles_pre_and_post > 0 % && Reanalyze_something
               ASf = Global_flags_init.Leave_only_Nfiles_pre_and_post ;
               Global_flags.Files_in_exeperiment = 2*ASf ;
               Global_flags.file_number_of_change =  ASf ;
                
               leave_files_list = Global_flags.file_number_of_change - ASf + 1: Global_flags.file_number_of_change + ASf ;
               ALL_cell.Analysis_data_cell = ALL_cell.Analysis_data_cell(leave_files_list ,:);
               if ~isempty( ALL_cell.Connectiv_data )
               ALL_cell.Connectiv_data = ALL_cell.Connectiv_data(leave_files_list ,:);
               end
               ALL_cell.filenames = ALL_cell.filenames(leave_files_list ,:);
               
           end
         
            
            %//////////////////////////////////////////////////////////////
            All_files_Connectiv_compare_analyze_save
            %//////////////////////////////////////////////////////////////
            
   end
   Global_flags = Global_flags_init ;
   Experiment_type = 'Connectivity_Experiments_average' ;
   processed = true ;
end
%--------------

if strcmp(Experiment_type, 'Analyzed_Experiments_average') && Global_flags.All_ExpContaires_reanalyze
    All_ExpContaires_reanalyze = Global_flags.All_ExpContaires_reanalyze;
    Experiment_type = 'Analyzed_data_compare' ;
    file_list_AA = file_list ;
    Global_flags_init = Global_flags ;
    Search_Params_init = Search_Params ;
   for Exp_i_all = 1 : numel( file_list_AA )
             load(  file_list_AA{ Exp_i_all } )
           close all
             
            file_list =  ALL_cell.filenames;
            n_files= numel(file_list ) ;
            Global_flags =  ALL_cell.Global_flags ;
            if Global_flags.Files_in_exeperiment == 0 ;
                Global_flags.Files_in_exeperiment = n_files(1) ;
            end
             
            Global_flags.Find_bursts_GUI_input_Search_Params = Search_Params_init ;
            Global_flags.Analyze_bursts_parameters_from_Gui = Global_flags_init.Analyze_bursts_parameters_from_Gui ;
            Global_flags.original_AA_file = file_list_AA{ Exp_i_all } ;
            ANALYSIS_ARG.Select_pair_of_files = false ;
            ANALYSIS_ARG.Use_3_files = false ;
            ANALYSIS_ARG.file_lists = file_lists ;
            Global_flags.cycle_all_electrodes = false ;
%             Global_flags.Force_Reanalyze_bursts_connectiv = true ;  
            Global_flags.Force_Reanalyze_bursts_connectiv = Global_flags_init.Force_Reanalyze_bursts_connectiv ; 
            Global_flags.Force_Reanalyze_only_bursts = Global_flags_init.Force_Reanalyze_only_bursts ; 
            Global_flags.Force_Reanalyze_only_connectiv = Global_flags_init.Force_Reanalyze_only_connectiv ; 
            Global_flags.Auto_upgrade_bursts_connectiv = Global_flags_init.Auto_upgrade_bursts_connectiv ; 
            Global_flags.All_ExpContaires_reanalyze  = Global_flags_init.All_ExpContaires_reanalyze  ;
            Global_flags.Split_raster_into_intervals_and_analyze = Global_flags_init.Split_raster_into_intervals_and_analyze ; % split raster from DB 
            Global_flags.Split_raster_period_min = Global_flags_init.Split_raster_period_min ;
            Global_flags.Max_raster_time_min = Global_flags_init.Max_raster_time_min ;
            Global_flags.Split_raster_ratio = Global_flags_init.Split_raster_ratio ;
            Global_flags.Take_one_file_pre_post = Global_flags_init.Take_one_file_pre_post ;
            Global_flags.Compare_channel_difference_spikes_min = Global_flags_init.Compare_channel_difference_spikes_min ;
            Global_flags.Min_spikes_per_channel_compare = Global_flags_init.Min_spikes_per_channel_compare ;
            
            Reanalyze_something =  Global_flags.Force_Reanalyze_only_bursts ...
                  | Global_flags.Auto_upgrade_bursts_connectiv ; 
            % take only few files pre and post if split all rasters
             
            Exp_i_all
            if Reanalyze_something
            %//////////////////////////////////////////////////////////////
            meaDB_Listfiles_open_process_loop
            %//////////////////////////////////////////////////////////////
            end
              
            %//////////////////////////////////////////////////////////////
             
            %//////////////////////////////////////////////////////////////
            
   end
   Global_flags = Global_flags_init ;
   Experiment_type = 'Analyzed_Experiments_average' ;
   processed = true ;
end

%-----------------------
if ~processed
  %////////////////////////////////////////////////////////////// 
  meaDB_Listfiles_open_process_loop
  %//////////////////////////////////////////////////////////////
  if exist( 'file_list' , 'var' )
  file_list_AA = file_list ;
  end
end
%//////////////////////////////////////////////////////////////
%//////////////////////////////////////////////////////////////

end % Only_process_computed_data

%% -- Process results all experimetns

if ~Only_process_computed_data && exist( 'ALL_EXPERIMENTS_SHORT_RESULT_all' , 'var')
%///////////////////////////////////////////////////////
%//////////// Saving results ///////////////////////////

if ANALYSIS_ARG.FILE_LIST_PROCESS  
    whos ALL_EXPERIMENTS_SHORT_RESULT_all 
    whos ALL_EXPERIMENTS_FULL_RESULTS_all

        Init_dir = cd ;
        up =userpath ; up(end)=[];
        cd(  up  )  
        if strcmp(Experiment_type, 'ElSel_day_by_day')   ||  strcmp(Experiment_type, 'Tetanisation') 
            if Global_flags.Electrode_selection_extract_channel 
                 ANALYSIS_ARG.electrode_sel_param_Strings_files = electrode_sel_param_Strings_files ;
            else
                ANALYSIS_ARG.electrode_sel_param_Strings_files = '' ; 
            end
        end
        eval(['save ' Filename_Analysis_RESULT_ALL ' ALL_EXPERIMENTS_SHORT_RESULT_all -mat']);  
        eval(['save ' Filename_Analysis_FULL_RESULT_ALL ' ALL_EXPERIMENTS_FULL_RESULTS_all Experiment_type ' ...
              ' Nexp  Global_flags ANALYSIS_ARG n_files -mat']); 

        cd( Init_dir )
end
%///////////////////////////////////////////////////////    
%///////////////////////////////////////////////////////    
end
%--------------------------------------------------------------------------

if ANALYSIS_ARG.FILE_LIST_PROCESS 
if Only_process_computed_data
    Init_dir = cd ;
    up =userpath ; up(end)=[];
    cd(  up  )   
     
        load( Filename_Analysis_FULL_RESULT_ALL )
     
      electrode_sel_param_Strings_files =ANALYSIS_ARG.electrode_sel_param_Strings_files ;
    cd( Init_dir )  
    
    EXP = [];
 end
end
 

%--------------------------------------------------------------------------
% Get statistics over all experiments ----------------------------

Global_flags.Max_SR_ratio = Global_Max_SR_ratio ; % Histogram of diff ratio with defined bin step
Global_flags.Bin_hist_ratio = Global_Bin_hist_ratio ;         

%--------------------------------------------------------------------------
%% Analyze_one_file_ElSel --------------------------------------------------------------------------

if strcmp(Experiment_type, 'Analyze_one_file_ElSel') 
    
    whos DATA 
    fullname = [pathname filename ];
      [pathstr, name, ext ] = fileparts(filename) ;
    fullname = [  pathname name '_Responses_extracted.mat' ];
    save( fullname , 'DATA' )
    stop_here
    
end

%--------------------------------------------------------------------------
%% Stim_response_compare--------------------------------------------------------------------------
if strcmp(Experiment_type, 'Stim_response_compare') 
    if ANALYSIS_ARG.FILE_LIST_PROCESS 
%         Analyze_list_files_post_analyze
%         Analyze_list_files_results_show
        
        var.filename_defined = true ;
        var.result_filename = 'Stim_responses_all_files' ;
            meaDB_CompareResults_save(   ANALYSIS_ARG ,[], ALL_cell , Global_flags , var)
        %input var.filename_defined, var.result_filename
        %

        Analyze_list_Stim_response_all_exp

         
        
    end
end
%--------------------------------------------------------------------------
%% Analyzed_Experiments_average ---------------------------------------------------------------------
if strcmp(Experiment_type, 'Analyzed_Experiments_average') 
    if ANALYSIS_ARG.FILE_LIST_PROCESS 
%         Analyze_list_files_post_analyze
%         Analyze_list_files_results_show
        
        Analyze_list_ALL_cell
         
        
    end
end 
%--------------------------------------------------------------------------
%% Connectivity_Experiments_average ---------------------------------------------------------------------
if strcmp(Experiment_type, 'Connectivity_Experiments_average') 
    if ANALYSIS_ARG.FILE_LIST_PROCESS 
%         Analyze_list_files_post_analyze
%         Analyze_list_files_results_show
        
        Analyze_list_ALL_cell
         
        
    end
end 
%% Analyzed_data_compare --------------------------------------------------------------------------
if strcmp(Experiment_type, 'Analyzed_data_compare') 
    if ANALYSIS_ARG.FILE_LIST_PROCESS 
%         Analyze_list_files_post_analyze
%         Analyze_list_files_results_show
        
        Analyze_list_files_post_analyze2
        
%         Analyze_list_files_results_show2
        Analyze_list_files_results_show3
    end
end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%% Connectivity_compare --------------------------------------------------------------------------
if strcmp(Experiment_type, 'Connectivity_compare') 
    All_files_Connectiv_compare_analyze_save
    
end
%% ANALYSIS_ARG.FILE_LIST_PROCESS --------------------------------------------------------------------------

if ANALYSIS_ARG.FILE_LIST_PROCESS 
  if ANALYSIS_ARG.FILE_LIST_PROCESS
   if  Nexp > 0    
          
        if strcmp(Experiment_type, 'ElSel_day_by_day')  
       
          Kpairs = ElSel_files_in_exeperiment - 1 ;
        
          All_data_all_exp  = [];  
          ALL_experiments_file_pars = []; 
          TOTAL_RATE =[]; 
           
          % cycle all files pairs
  % /////////////////  cycle all files pairs for ElSel_day_by_day ////////////////////////
  DATA_collect_type = 2 ;      
  
  EXP.Kpairs = Kpairs ;
  EXP.Nexp=Nexp;
          for Pair_i = 1 : Kpairs
              % 1 , 2
                
              if DATA_collect_type == 1 
                  TOTAL_RATE=[]; 
                  TOTAL_RATE(2).all_exp_diff_mean_ratio = [] ;  
                  TOTAL_RATE(2).all_exp_diff_mean= [] ;  
                  TOTAL_RATE(2).all_exp_diff_std_ratio= [] ;  
                  TOTAL_RATE(2).all_exp_diff_std= [] ;  
                  TOTAL_RATE(2).all_exp_Channels_overlap= [] ;  
                  TOTAL_RATE(2).all_exp_Channel_is_active= [] ;
                  TOTAL_RATE(2).all_exp_diff_mean_ratio_only_active = [] ;  
                  TOTAL_RATE(2).all_exp_diff_mean_only_active= [] ;  
                  TOTAL_RATE(2).all_exp_diff_std_ratio_only_active= [] ;  
                  TOTAL_RATE(2).all_exp_diff_std_only_active= [] ;  
                  TOTAL_RATE(2).all_exp_Channels_overlap_only_active= [] ;                       
                  TOTAL_RATE(2).all_exp_Channel_is_active= [] ;  
              else
                  DATA  = [];
                  TOTAL_RATE=[];
                  for i=1:11
                     DATA(i).data_vector = [];
                  end
                  TOTAL_RATE.DATA = DATA ; 

                  TOTAL_RATE(2).DATA = DATA ; 
              end
             
              exp_num_file_n_fix =0 ;
              % cycle for fixed files pair for all experiments
              for exp_num_file_n = 1 : 1 : Nexp
 
%                   if mod( exp_num_file_n , ElSel_files_in_exeperiment ) ~=0
                     exp_num_file_n_fix = Pair_i * exp_num_file_n  ;
                     % 1 2 3 4
                  % if was enough low patterns in 2 peatterns sets  
                  exp_num_file_n_fix
                  
                  ch_end = 1 ;
                  
                  % if take data from all stim electrodes
                  if Global_flags.cycle_all_electrodes
                      if Global_flags.ElSel_auto_load_protocol   
                       Global_flags.electrode_sel_param =...
                       electrode_sel_param_from_string( electrode_sel_param_Strings_files{ exp_num_file_n } )   ;  
                      end
                      ch_end = Global_flags.electrode_sel_param.Channels_number  ;
                  end
                  EXP( exp_num_file_n ).ExpStage( Pair_i ).ch_end = ch_end ;
                      
                  for ch= 1 : ch_end     
                      
                    HiLo_Patterns1_2_enough_Low_responses  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).HiLo_Patterns1_2_enough_Low_responses ;
                    HiLo_Patterns1_2_enough_High_responses  = ALL_EXPERIMENTS_FULL_RESULTS_all( exp_num_file_n_fix ).FULL_RESULTS_all( ch ).HiLo_Patterns1_2_enough_High_responses ;                     
                     
                    %-------------------------------------
%--------------------------------------------------------------------------                    
                    if DATA_collect_type == 1
                       El_Sel_Day_by_Day_collect_data
                    else
                       El_Sel_Day_by_Day_collect_data_matrix
                    end
                    %-------------------------------------
%--------------------------------------------------------------------------                    
                                    
%                   end
                  end
              end % cycle for fixed files pair for all experiments
               
              TOTAL_RATE_files_in_exp.TOTAL_RATE = TOTAL_RATE ;
              

              All_data_all_exp = [All_data_all_exp  TOTAL_RATE_files_in_exp ];
              
          end % cycle all files pairs - Pair_i = 1 : ElSel_files_in_exeperiment 
         
         
          %////- Draw results for all experimentts///////////////////////////////////////////////  
       
                ALL_DATA.All_data_all_exp = All_data_all_exp ; % all data for all experiment in a vector (for mean ...)
                ALL_DATA.EXP = EXP ; % all data separated for each experiment 
                FigureName_prefix = '' ;
%--------------------------------------------------------------------------                
                if DATA_collect_type == 1
                     Calc_mean_values_for_each_experiment_in_total
                     % Input - All_data_all_exp, Output - figures
                     Patterns_Plot_differencies_Dots_Els_Sel_day_by_Day
                else
                     Calc_mean_values_for_each_experiment_in_total_from_matrix
                     % Input - All_data_all_exp, Output - figures
                     Patterns_Plot_differencies_Dots_Els_Sel_day_by_Day_from_matrix
                end
%--------------------------------------------------------------------------                 
                
                
         
            %---- Plot dots - x-diff pair 1-2 , y - pair 1-N  ////  
          end    
         
          
          
          
          
%////////////////////////////////////////////////////%///////////////////////////////////////////////////
%///////////////////////////////////////////////////%///////////////////////////////////////////////////     
%% Tetanisation///////////////////////////////////////////////////%///////////////////////////////////////////////////         
         
 % /////////////////  cycle all files pairs for ElSel_day_by_day ////////////////////////
         if strcmp(Experiment_type, 'Tetanisation')  
          for filen = 1 : 1
              % 1 , 2
                 
                Kpairs = Tet_files_in_exeperiment - 1 ;
       
              
   %///////// Ctrl electrodes only /////////////////                         
              Summ_all_exp_ctrl_channels = true ; % if true then summ all channels except Tet1 and Tet2
              Tet_channel_number_1_or_2 = 0 ; % sum only data from selected channel
              
                      TOTAL_RATE =[]; 
                      TOTAL_RATE(2).all_exp_diff_mean_ratio = [] ;  
                      TOTAL_RATE(2).all_exp_diff_mean= [] ;  
                      TOTAL_RATE(2).all_exp_diff_std_ratio= [] ;  
                      TOTAL_RATE(2).all_exp_diff_std= [] ;  
                      TOTAL_RATE(2).all_exp_Channels_overlap= [] ;  
                      TOTAL_RATE(2).all_exp_diff_mean_ratio_only_active = [] ;  
                      TOTAL_RATE(2).all_exp_diff_mean_only_active= [] ;  
                      TOTAL_RATE(2).all_exp_diff_std_ratio_only_active= [] ;  
                      TOTAL_RATE(2).all_exp_diff_std_only_active= [] ;  
                      TOTAL_RATE(2).all_exp_Channels_overlap_only_active= [] ;                       
                      TOTAL_RATE(2).all_exp_Channel_is_active= [] ;

                      exp_num_file_n_fix =0 ;
                      All_data_all_exp_ctrl  = [];  
                      All_data_all_exp_Tet1  = [];  
                      All_data_all_exp_Tet2  = [];  
                      ALL_experiments_file_pars = []; 
               
             %---- cycle all electrodes and summ all data for ctrl
             %channels, tet1 and then tet2. Collects only Ctrl1-Ctrl1
              Cycle_chans_collect_data
               
              TOTAL_RATE_files_in_exp.TOTAL_RATE = TOTAL_RATE ;
                     
                     %--- First struct - Control-Control comapre
                      All_data_all_exp_ctrl = [All_data_all_exp_ctrl  TOTAL_RATE_files_in_exp ];
                      
              
                     %/////////////// Take Control2-Post-Tet comapre Tet ///////////////////  
                     %/////////////// Take Control2-Post-Tet comapre Tet ///////////////////  
                      TOTAL_RATE = [] ;   

                      TOTAL_RATE(2).all_exp_diff_mean_ratio = [] ;  
                      TOTAL_RATE(2).all_exp_diff_mean= [] ;  
                      TOTAL_RATE(2).all_exp_diff_std_ratio= [] ;  
                      TOTAL_RATE(2).all_exp_diff_std= [] ;  
                      TOTAL_RATE(2).all_exp_Channels_overlap= [] ;  
                      TOTAL_RATE(2).all_exp_diff_mean_ratio_only_active = [] ;  
                      TOTAL_RATE(2).all_exp_diff_mean_only_active= [] ;  
                      TOTAL_RATE(2).all_exp_diff_std_ratio_only_active= [] ;  
                      TOTAL_RATE(2).all_exp_diff_std_only_active= [] ;  
                      TOTAL_RATE(2).all_exp_Channels_overlap_only_active= [] ;                       
                      TOTAL_RATE(2).all_exp_Channel_is_active= [] ;

              %---- cycle all electrodes and summ all data for ctrl
              %channels, tet1 and then tet2. Collects only Ctrl2-Tet
               Cycle_chans_collect_data2 
               
                    TOTAL_RATE_files_in_exp.TOTAL_RATE = TOTAL_RATE ;
                     
              %--- Second struct in All_data_all_exp - Control2-Post-Tet
              All_data_all_exp_ctrl = [All_data_all_exp_ctrl  TOTAL_RATE_files_in_exp ];  
              %//////+++++++++++++++++++++++++++++++++++++++++/////////////
              %//////+++++++++++++++++++++++++++++++++++++++++////////////
              %//////+++++++++++++++++++++++++++++++++++++++++////////////
 
              
  %///////// Tet1 electrodes only /////////////////     
  
              Summ_all_exp_ctrl_channels = false ; % if true then summ all channels except Tet1 and Tet2
              Tet_channel_number_1_or_2 = 1 ; % sum only data from selected channel
              
                      TOTAL_RATE =[]; 
                      TOTAL_RATE(2).all_exp_diff_mean_ratio = [] ;  
                      TOTAL_RATE(2).all_exp_diff_mean= [] ;  
                      TOTAL_RATE(2).all_exp_diff_std_ratio= [] ;  
                      TOTAL_RATE(2).all_exp_diff_std= [] ;  
                      TOTAL_RATE(2).all_exp_Channels_overlap= [] ;  
                      TOTAL_RATE(2).all_exp_diff_mean_ratio_only_active = [] ;  
                      TOTAL_RATE(2).all_exp_diff_mean_only_active= [] ;  
                      TOTAL_RATE(2).all_exp_diff_std_ratio_only_active= [] ;  
                      TOTAL_RATE(2).all_exp_diff_std_only_active= [] ;  
                      TOTAL_RATE(2).all_exp_Channels_overlap_only_active= [] ;                       
                      TOTAL_RATE(2).all_exp_Channel_is_active= [] ;

               
              %---- cycle all electrodes and summ all data for ctrl
              %channels, tet1 and then tet2
              Cycle_chans_collect_data
               
                    TOTAL_RATE_files_in_exp.TOTAL_RATE = TOTAL_RATE ;
                     
              %--- First struct - Control-Control comapre
              All_data_all_exp_Tet1 = [All_data_all_exp_Tet1  TOTAL_RATE_files_in_exp ];
                      
              
             %/////////////// Take Control2-Post-Tet comapre Tet ///////////////////  
             %/////////////// Take Control2-Post-Tet comapre Tet ///////////////////  
                    TOTAL_RATE = [] ;   
              
                      TOTAL_RATE(2).all_exp_diff_mean_ratio = [] ;  
                      TOTAL_RATE(2).all_exp_diff_mean= [] ;  
                      TOTAL_RATE(2).all_exp_diff_std_ratio= [] ;  
                      TOTAL_RATE(2).all_exp_diff_std= [] ;  
                      TOTAL_RATE(2).all_exp_Channels_overlap= [] ;  
                      TOTAL_RATE(2).all_exp_diff_mean_ratio_only_active = [] ;  
                      TOTAL_RATE(2).all_exp_diff_mean_only_active= [] ;  
                      TOTAL_RATE(2).all_exp_diff_std_ratio_only_active= [] ;  
                      TOTAL_RATE(2).all_exp_diff_std_only_active= [] ;  
                      TOTAL_RATE(2).all_exp_Channels_overlap_only_active= [] ;                       
                      TOTAL_RATE(2).all_exp_Channel_is_active= [] ;

              %---- cycle all electrodes and summ all data for ctrl
                %channels, tet1 and then tet2
               Cycle_chans_collect_data2
               
              TOTAL_RATE_files_in_exp.TOTAL_RATE = TOTAL_RATE ;
                     
              %--- Second struct in All_data_all_exp - Control2-Post-Tet
              All_data_all_exp_Tet1 = [All_data_all_exp_Tet1  TOTAL_RATE_files_in_exp ];  
              %//////+++++++++++++++++++++++++++++++++++++++++/////////////
              %//////+++++++++++++++++++++++++++++++++++++++++////////////
              %//////+++++++++++++++++++++++++++++++++++++++++////////////     
              
              
              
              
    %///////// Tet2 electrodes only /////////////////
    %
              Summ_all_exp_ctrl_channels = false ; % if true then summ all channels except Tet1 and Tet2
              Tet_channel_number_1_or_2 = 2 ; % sum only data from selected channel
              
                  TOTAL_RATE =[]; 
                      TOTAL_RATE(2).all_exp_diff_mean_ratio = [] ;  
                      TOTAL_RATE(2).all_exp_diff_mean= [] ;  
                      TOTAL_RATE(2).all_exp_diff_std_ratio= [] ;  
                      TOTAL_RATE(2).all_exp_diff_std= [] ;  
                      TOTAL_RATE(2).all_exp_Channels_overlap= [] ;  
                      TOTAL_RATE(2).all_exp_diff_mean_ratio_only_active = [] ;  
                      TOTAL_RATE(2).all_exp_diff_mean_only_active= [] ;  
                      TOTAL_RATE(2).all_exp_diff_std_ratio_only_active= [] ;  
                      TOTAL_RATE(2).all_exp_diff_std_only_active= [] ;  
                      TOTAL_RATE(2).all_exp_Channels_overlap_only_active= [] ;                       
                      TOTAL_RATE(2).all_exp_Channel_is_active= [] ;
  
                %---- cycle all electrodes and summ all data for ctrl
                %channels, tet1 and then tet2
              Cycle_chans_collect_data
               
              TOTAL_RATE_files_in_exp.TOTAL_RATE = TOTAL_RATE ;
                     
                     %--- First struct - Control-Control comapre
                      All_data_all_exp_Tet2 = [All_data_all_exp_Tet2  TOTAL_RATE_files_in_exp ];
                      
              
             %/////////////// Take Control2-Post-Tet comapre Tet ///////////////////  
             %/////////////// Take Control2-Post-Tet comapre Tet ///////////////////  
              TOTAL_RATE = [] ;   
              
                       TOTAL_RATE(2).all_exp_diff_mean_ratio = [] ;  
                      TOTAL_RATE(2).all_exp_diff_mean= [] ;  
                      TOTAL_RATE(2).all_exp_diff_std_ratio= [] ;  
                      TOTAL_RATE(2).all_exp_diff_std= [] ;  
                      TOTAL_RATE(2).all_exp_Channels_overlap= [] ;  
                      TOTAL_RATE(2).all_exp_diff_mean_ratio_only_active = [] ;  
                      TOTAL_RATE(2).all_exp_diff_mean_only_active= [] ;  
                      TOTAL_RATE(2).all_exp_diff_std_ratio_only_active= [] ;  
                      TOTAL_RATE(2).all_exp_diff_std_only_active= [] ;  
                      TOTAL_RATE(2).all_exp_Channels_overlap_only_active= [] ;                       
                      TOTAL_RATE(2).all_exp_Channel_is_active= [] ;
              
              %---- cycle all electrodes and summ all data for ctrl
                %channels, tet1 and then tet2
               Cycle_chans_collect_data2
               
                    TOTAL_RATE_files_in_exp.TOTAL_RATE = TOTAL_RATE ;
                     
              %--- Second struct in All_data_all_exp - Control2-Post-Tet
              All_data_all_exp_Tet2 = [All_data_all_exp_Tet2  TOTAL_RATE_files_in_exp ];  
              %//////+++++++++++++++++++++++++++++++++++++++++/////////////
              %//////+++++++++++++++++++++++++++++++++++++++++////////////
              %//////+++++++++++++++++++++++++++++++++++++++++////////////                
              
              
          end % cycle all files pairs - filen = 1 : ElSel_files_in_exeperiment 
          
          
           whos All_data_all_exp_ctrl 
           whos All_data_all_exp_Tet1 
           whos All_data_all_exp_Tet2
         end 
          
      
%          All_data_all_exp.TOTAL_RATE(1) - low responses
%          All_data_all_exp.TOTAL_RATE(2) - high responses       
%
%          All_data_all_exp(1).TOTAL_RATE(1) - low responses at first file
%          pair where all experiments summarized
%          All_data_all_exp(2).TOTAL_RATE(1) - low responses at second file
%          pair where all experiments summarized
%           ....

          
        if  strcmp(Experiment_type, 'Tetanisation')
        if Global_flags.cycle_all_electrodes
          %//CTRL///////////////////////////////////////////////////  
            All_data_all_exp =  All_data_all_exp_ctrl ;
            ALL_experiments_file_pars.All_data_all_exp = All_data_all_exp ;
            
            FigureName_prefix = 'Ctrl electrodes - ' ;
            
                Calc_mean_values_for_each_experiment_in_total
                % Input - All_data_all_exp
                    
            %//TET1///////////////////////////////////////////////////
            All_data_all_exp =  All_data_all_exp_Tet1 ;
            ALL_experiments_file_pars.All_data_all_exp = All_data_all_exp ;
                   
            
            FigureName_prefix = 'Tet1 stimulation responses - ' ;
                Calc_mean_values_for_each_experiment_in_total
                % Input - All_data_all_exp
                    
           %//TET2///////////////////////////////////////////////////
            All_data_all_exp =  All_data_all_exp_Tet2 ;
            ALL_experiments_file_pars.All_data_all_exp = All_data_all_exp ;
                        
            
            FigureName_prefix = 'Tet2 stimulation responses - ' ;
                 Calc_mean_values_for_each_experiment_in_total
                % Input - All_data_all_exp
                    
                
                
                
                Plot_differencies_Dots
                
                
                
                    
        end
        end
      end 
   end
%   end    
       
       
        
% if ~Only_process_computed_data
%////// Save file all results stats ////////////
   if exist( 'ALL_experiments_file_pars' , 'var')
    whos ALL_EXPERIMENTS_FULL_RESULTS_all

        Init_dir = cd ;
        up =userpath ; up(end)=[];
        cd(  up  ) 

        Filename_Analysis_FULL_RESULT_ALL = 'ANAlYSIS_List_files_compare_all_Statistics.mat' ;

        eval(['save ' Filename_Analysis_FULL_RESULT_ALL ' ALL_experiments_file_pars -mat']); 

        cd( Init_dir )
   end
%///////////////////////////////////////////////////////    
% end

%     figure
%         bar(ONE_EXPERIMENT_RESULTS.TOTAL_RATE.Channel_difference_mean_ratio )


end











    
    
    
