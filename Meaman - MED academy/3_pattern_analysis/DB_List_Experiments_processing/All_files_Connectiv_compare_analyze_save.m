
% All_files_Connectiv_compare_analyze_save



ALL_experiments_file_pars = [] ;
    if  ~ANALYSIS_ARG.FILE_LIST_PROCESS && ANALYSIS_ARG.Use_3_files 
         
        ALL_EXPERIMENTS_FULL_RESULTS_all = ONE_EXPERIMENTS_FULL_RESULTS_all ;
        N_files = 3 ;
        
        Connectiv_compare_list_files_post_analyze
        
        Connectiv_compare_results_show
    end
    
    if ANALYSIS_ARG.FILE_LIST_PROCESS 
%     if~Global_flags.Force_Reanalyze_bursts_connectiv && ~Global_flags.Force_Reanalyze_only_connectiv
    if 1 > 0      
%         ALL_EXPERIMENTS_FULL_RESULTS_all ;
        N_files = n_files ;
        
%         Global_flags.Files_in_exeperiment = Global_flags.Files_in_exeperiment +1;


        Connectiv_compare_list_files_post_analyze
      
        var.filename_defined = false ;
            meaDB_CompareResults_save(   ANALYSIS_ARG ,ANALYSIS_cell, ALL_cell , Global_flags , var)
        %input var.filename_defined, var.result_filename
        %
        
    end
    end