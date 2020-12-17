

% meaDB_Listfiles_open_process_loop


if ANALYSIS_ARG.Use_3_files && ~strcmp(Experiment_type, 'Connectivity_compare')
    files_step = 3 ;
else
    if  ~strcmp(Experiment_type, 'Connectivity_compare')
%         Global_flags.Force_Reanalyze_bursts_connectiv
        files_step = 2 ;
    end
end 

 if strcmp(Experiment_type, 'ElSel_day_by_day')
        files_step = 1 ;
        n_files= n_files -1;  
 end 
 
  if strcmp(Experiment_type, 'Stim_response_compare')
      files_step = 1 ;
      if ~ Global_flags.ElSel_auto_load_protocol        
        n_files= n_files / 2;  
      end
 end 
 
 if strcmp(Experiment_type, 'Connectivity_compare') &&  ~ANALYSIS_ARG.FILE_LIST_PROCESS
        files_step = 1 ;
        n_files= 1 ;  
         ANALYSIS_ARG.Select_pair_of_files = true ;
         ANALYSIS_ARG.Use_3_files = true ;
         Global_flags.cycle_all_electrodes = false ;
 end  

 if strcmp( Experiment_type , 'Analyzed_data_compare' )
     files_step = 1 ;
 end
 
  if strcmp( Experiment_type , 'Analyze_one_file_ElSel' )
     files_step = 1 ;
 end

% if exist( 'Init_global_var' , 'var' )
%     if Init_global_var
        ONE_EXPERIMENTS_FULL_RESULTS_all = [];
        ALL_EXPERIMENTS_FULL_RESULTS_all = [];
        ALL_EXPERIMENTS_FULL_RESULTS_all_chain  = []; 
        ALL_EXPERIMENTS_SHORT_RESULT_all = [];
        All_files_data_TOTAL_cell = cell(1,1);

        ALL_cell = {};
        ALL_cell.Analysis_data_cell = [];
        ALL_cell.Analysis_data = [];
       ALL_cell.Analysis_data_TOTAL_RATE  = [];
       ALL_cell.Analysis_data_T_act  = [];
       ALL_cell.Analysis_data_SpikeRate = [];
        
        ALL_cell.Connectiv_data =[];
        ALL_cell.filenames = {} ;
        
        DATA = {}; 

        ALL_experiments_file_pars = []; 
        RESULT_all = []; 
%     end
% end
ElSel_day_by_day_First_file_in_ex = 1 ;
Tetanisation_First_file_in_ex= 1 ;
Experiment_type


%% Main cycle all experiments
%//////////////%//////////////
%//////////////%//////////////%//////////////%//////////////
%//////////////%//////////////%//////////////%//////////////
%//////////////%//////////////%//////////////%//////////////%//////////////
Cycle_load_files_and_analyze = true ;
if strcmp(Experiment_type, 'Connectivity_Experiments_average')
    Cycle_load_files_and_analyze = false ;
end

if Cycle_load_files_and_analyze
for fi = 1 : files_step : n_files 
    Take_files = true ;
    
   %/////////DEcide to take or not files from current filelist position
   CompPat_TakeFiles_nowornot
   %///////////////////////////      
        
        
        
if Take_files
    
  %//////////////////////////////////////  
    CompPat_Take_Filenames_and_Load_Data
  %//////////////////////////////////////
 
           if   strcmp(Experiment_type, 'Stim_response_compare')
                 Patterns1_origin_load = Patterns1 ;
           end

            
        GLOB_cycle_end = 1;   
        GLOB_cycle_step=1;
        GLOB_cycle_start= 1 ;
        GLOB_cycle_end2 = 1;   
        GLOB_cycle_step2=1; GLOB_cycle_start2=1;
        
        if Global_flags.cycle_all_electrodes 
            
            Patterns1_origin = Patterns1 ;
            if   ~strcmp(Experiment_type, 'Stim_response_compare')
                if exist( 'Patterns2' , 'var' )
                Patterns2_origin = Patterns2 ;
                end
            end
            if ANALYSIS_ARG.Use_3_files
                Patterns3_origin = Patterns3 ;
            end  
            
            if   strcmp(Experiment_type, 'Stim_response_compare') || strcmp(Experiment_type, 'Tetanisation')                 
                GLOB_cycle_end = Global_flags.electrode_sel_param.Channels_number ;
                GLOB_cycle_step = 1 ;
                GLOB_cycle_end = GLOB_cycle_end ;
                GLOB_cycle_end2 = GLOB_cycle_end ;   
                GLOB_cycle_step2=1; GLOB_cycle_start2=1;        
                if strcmp(Experiment_type, 'Tetanisation')  
                    GLOB_cycle_end2 = 1 ;
                end
            end
            
            if strcmp(Experiment_type, 'Analyze_one_file_ElSel')   
                GLOB_cycle_end = Global_flags.electrode_sel_param.Channels_number ;
                GLOB_cycle_step = 1 ; 
            end
        end
        
        
%        GLOB_cycle_end = 2 ; 
        
        
    for  Global_loop_var = GLOB_cycle_start : GLOB_cycle_step : GLOB_cycle_end
        
      if  strcmp(Experiment_type, 'Stim_response_compare')
          GLOB_cycle_start2 = Global_loop_var + 1 ;
      end
    for  Global_loop_var2 = GLOB_cycle_start2 : GLOB_cycle_step2 : GLOB_cycle_end2    
        
        if Global_flags.cycle_all_electrodes 
            if ~strcmp(Experiment_type, 'Stim_response_compare')
                    Patterns1= Patterns1_origin  ;
                    if exist( 'Patterns2_origin' , 'var' )
                    Patterns2= Patterns2_origin  ;
                    end
                    if ANALYSIS_ARG.Use_3_files
                       Patterns3 = Patterns3_origin ;
                    end
                    
                 Global_flags.EL_SEL_stim_chan_to_extract = Elsel_get_channel_number( Global_loop_var ,Global_flags) ; 
                 Global_flags.electrode_sel_param.Selected_Stimulation_channel =  Global_loop_var  ;
            end
        else
%           if   ~strcmp(Experiment_type, 'Analyzed_data_compare')  
%             Global_flags.EL_SEL_stim_chan_to_extract = Elsel_get_channel_number( Global_flags.extract_one_stim_channel ,Global_flags) ; 
%             Global_flags.electrode_sel_param.Selected_Stimulation_channel =  Global_flags.extract_one_stim_channel  ;
%           end 
        end
        
        %-- Load responses for stim respones analysis
        if Global_flags.cycle_all_electrodes
            if   strcmp(Experiment_type, 'Stim_response_compare')
                Patterns1= Patterns1_origin_load  ;
                Analyze_current_loop = true ;
                CH1 = Global_loop_var  
                CH2 = Global_loop_var2
                 
%                 CH1 = 13  
%                 CH2 = 7  
                
                Global_flags.EL_SEL_stim_chan_to_extract1 = Elsel_get_channel_number( CH1 ,Global_flags) ;     
                Global_flags.EL_SEL_stim_chan_to_extract2 = Elsel_get_channel_number( CH2 ,Global_flags) ;    
                
                 dist = MEA_channels_dist( Global_flags.EL_SEL_stim_chan_to_extract1 ,  Global_flags.EL_SEL_stim_chan_to_extract2 ) ;
                 
                 % if stim electrodes are very close
                if dist < Global_flags.stim_response_min_dist_electrodes 
                 Analyze_current_loop = false ;
                end
            end
        end
%//////////////////////////////////////////////////////////////
%//////////////////////////////////////////////////////////////
%//////////////////////////////////////////////////////////////
%//////////////////////////////////////////////////////////////      
RESULT = [];
ONE_EXPERIMENT_RESULTS=[];

if strcmp(Experiment_type, 'Tetanisation') || strcmp(Experiment_type, 'ElSel_day_by_day') 
                % Compare two sets of responses
                % input should be   burst_activation, Spike_Rates_each_burst... from
                % ANALYZED_DATA or POST_STIM_RESPONSE and stored in "Patterns" struct.
                % output - a list of output variables should be processed outside of this
                % script (ex. Compare_Pattern_pairs).
%                  Compare_2_structs_of_patterns_script ;
    if ~Global_flags.cycle_all_electrodes 
        if Global_flags.extract_one_stim_channel > 0 
            Global_flags.EL_SEL_stim_chan_to_extract = Elsel_get_channel_number( Global_flags.extract_one_stim_channel ,Global_flags) ; 
        else
           Global_flags.EL_SEL_stim_chan_to_extract = 0 ; 
        end
            Global_flags.electrode_sel_param.Selected_Stimulation_channel =  Global_flags.extract_one_stim_channel  ;
    end
                 Compare_2_structs_of_patterns_script_2 ;
                  
    if Hi_Lo_Patterns1_2_enough_High_responses && Hi_Lo_Patterns2_3_enough_High_responses
      
      Result_cell = struct2cell( ONE_EXPERIMENT_RESULTS );
      Result_cell_field_names =   fieldnames( ONE_EXPERIMENT_RESULTS  );
       ALL_cell.Analysis_data_cell = [ ALL_cell.Analysis_data_cell ;  Result_cell' ];
       ALL_cell.Analysis_data  = [ ALL_cell.Analysis_data  ;  ONE_EXPERIMENT_RESULTS' ];
       ALL_cell.Analysis_data_cell_field_names  = Result_cell_field_names ;
       
       Result_cell_field_names =   fieldnames( ONE_EXPERIMENT_RESULTS.TOTAL_RATE );
       Result_cell = struct2cell( ONE_EXPERIMENT_RESULTS.TOTAL_RATE );
       ALL_cell.Analysis_data_TOTAL_RATE = [ ALL_cell.Analysis_data_TOTAL_RATE ;  Result_cell' ];
       ALL_cell.Analysis_data_TOTAL_RATE_names = Result_cell_field_names ;
       
       Result_cell_field_names =   fieldnames( ONE_EXPERIMENT_RESULTS.T_act );
       Result_cell = struct2cell( ONE_EXPERIMENT_RESULTS.T_act );
       ALL_cell.Analysis_data_T_act = [ ALL_cell.Analysis_data_T_act ;  Result_cell' ];
       ALL_cell.Analysis_data_T_act_names = Result_cell_field_names ;
       
       Result_cell_field_names =   fieldnames( ONE_EXPERIMENT_RESULTS.SpikeRate );
       Result_cell = struct2cell( ONE_EXPERIMENT_RESULTS.SpikeRate );
       ALL_cell.Analysis_data_SpikeRate = [ ALL_cell.Analysis_data_SpikeRate ;  Result_cell' ];
       ALL_cell.Analysis_data_SpikeRate_names = Result_cell_field_names ;
       

       ALL_cell.filenames = [ ALL_cell.filenames ; filename ] ; 
                   
                
               %++++++++++++++++++++ 
%                ALL_cell.filenames = [ ALL_cell.filenames ; filename  ] ;
%                ALL_cell.Analysis_data_cell_field_names  =  Result_cell_field_names ;
     if Global_flags.pause_after_each_compare && Global_flags.cycle_all_electrodes
         
         pause
     end
         a=0;
    end
     if Global_flags.cycle_all_electrodes
     close all   
     end
%//////////////////////////////////////////////////////////////
end

%% Analyze_one_file_ElSel //////////////////////////////////////////////////////////////
if strcmp(Experiment_type, 'Analyze_one_file_ElSel') 
 
    if POST_STIM_RESPONSE_exists
%       
        Global_loop_var
        Global_flags.electrode_sel_param.stim_chan_to_extract = Elsel_get_channel_number( Global_loop_var ,Global_flags) ; 
        Patterns = EL_SEL_Extract_responses_from_stim_channel( Patterns1 , Global_flags.electrode_sel_param ) ;
        DATA= [ DATA ; Patterns ]
         
         
    end

end

%% Analyzed_data_compare //////////////////////////////////////////////////////////////
if strcmp(Experiment_type, 'Analyzed_data_compare') 
%     All_files_data_TOTAL_cell{ 1 , fi } = ANALYZED_DATA ;
%     All_files_data_TOTAL_cell_filed_names  = ANALYZED_DATA.Analysis_data_cell_field_names ;
%     if Test_connectiv_list_files
%        All_files_data_TOTAL_cell{ 2 , fi } = ANALYZED_DATA.Connectiv_data ;   
%     end
    
     % add file data to cell
     size( ANALYZED_DATA.Analysis_data_cell)
     size( ALL_cell.Analysis_data_cell)
               ALL_cell.Analysis_data_cell = [ ALL_cell.Analysis_data_cell ;  ANALYZED_DATA.Analysis_data_cell' ];
               if ~Global_flags.Split_raster_into_intervals_and_analyze   
                   if isfield( ANALYZED_DATA , 'Connectiv_data' ) 
                       ANALYZED_DATA.Connectiv_data.Connectiv_matrix_M_on_tau_not_fitted = []; 
                       ANALYZED_DATA.Connectiv_data.Connectiv_matrix_M_on_tau = []; 
%                        Connectiv_data.Connectiv_matrix_M_on_tau_not_fitted = []; 
%                        Connectiv_data.Connectiv_matrix_M_on_tau = [];                        
                   end
               end
               if isfield( ANALYZED_DATA , 'Connectiv_data' )
                    ALL_cell.Connectiv_data = [ ALL_cell.Connectiv_data ; ANALYZED_DATA.Connectiv_data' ]; 
               end
               ALL_cell.Analysis_data_cell_field_names  = ANALYZED_DATA.Analysis_data_cell_field_names ;
               ALL_cell.filenames = [ ALL_cell.filenames ; filename ] ;
end

%//////////////////////////////////////////////////////////////
if strcmp(Experiment_type, 'Stim_response_compare')  && Analyze_current_loop
     % add file data to cell
     var = [] ;
     
     %----------------------------------
%       Result = Poststim_response_compare_2_patterns( Patterns1 , Patterns2 , var );
 
      
%        Patterns1 = m1  ;
%        Patterns2 = m2;
ANALYSIS_ARG
      ANALYSIS_ARG.Use_3_files 
      Compare_2_structs_of_patterns_script_2
        % Compare two sets of responses
        % input should be   burst_activation, Spike_Rates_each_burst... from
        % ANALYZED_DATA or POST_STIM_RESPONSE and stored in "Patterns" struct.
        % output - a list of output variables should be processed outside of this
        % script (ex. Compare_Pattern_pairs).
      
     %----------------------------------  
     
     
     if Hi_Lo_Patterns1_2_enough_High_responses
      
      
      Result_cell = struct2cell( ONE_EXPERIMENT_RESULTS );
      Result_cell_field_names =   fieldnames( ONE_EXPERIMENT_RESULTS  );
       ALL_cell.Analysis_data_cell = [ ALL_cell.Analysis_data_cell ;  Result_cell' ];
       ALL_cell.Analysis_data  = [ ALL_cell.Analysis_data  ;  ONE_EXPERIMENT_RESULTS' ];
       ALL_cell.Analysis_data_cell_field_names  = Result_cell_field_names ;
       
       Result_cell_field_names =   fieldnames( ONE_EXPERIMENT_RESULTS.TOTAL_RATE );
       Result_cell = struct2cell( ONE_EXPERIMENT_RESULTS.TOTAL_RATE );
       ALL_cell.Analysis_data_TOTAL_RATE = [ ALL_cell.Analysis_data_TOTAL_RATE ;  Result_cell' ];
       ALL_cell.Analysis_data_TOTAL_RATE_names = Result_cell_field_names ;
       
       Result_cell_field_names =   fieldnames( ONE_EXPERIMENT_RESULTS.T_act );
       Result_cell = struct2cell( ONE_EXPERIMENT_RESULTS.T_act );
       ALL_cell.Analysis_data_T_act = [ ALL_cell.Analysis_data_T_act ;  Result_cell' ];
       ALL_cell.Analysis_data_T_act_names = Result_cell_field_names ;
       
       Result_cell_field_names =   fieldnames( ONE_EXPERIMENT_RESULTS.SpikeRate );
       Result_cell = struct2cell( ONE_EXPERIMENT_RESULTS.SpikeRate );
       ALL_cell.Analysis_data_SpikeRate = [ ALL_cell.Analysis_data_SpikeRate ;  Result_cell' ];
       ALL_cell.Analysis_data_SpikeRate_names = Result_cell_field_names ;
       

       ALL_cell.filenames = [ ALL_cell.filenames ; filename ] ; 
                   
                
               %++++++++++++++++++++ 
%                ALL_cell.filenames = [ ALL_cell.filenames ; filename  ] ;
%                ALL_cell.Analysis_data_cell_field_names  =  Result_cell_field_names ;
     if Global_flags.pause_after_each_compare
         
         pause
     end
         a=0;
     end
     close all   
end



%//////////////////////////////////////////////////////////////
if strcmp(Experiment_type, 'Connectivity_compare') 
    
%     if ~Global_flags.Force_Reanalyze_bursts_connectiv &&   ~Global_flags.Force_Reanalyze_only_connectiv  
    if 1 > 0
%            Connectiv_data1 = Connectiv_data1_0 ;
%            Connectiv_data2 = Connectiv_data2_0 ;
             
%            if ~Global_flags.Force_Reanalyze_bursts_connectiv
           if 1 > 0
%                All_files_data_TOTAL_cell{ 1 , fi } = ANALYZED_DATA_1.Analysis_data_cell ;
               
 
                 ALL_cell.Analysis_data_cell = [ ALL_cell.Analysis_data_cell ;   Analysis_data_cell' ];
 
                %++++++++++++++++++++
               if ~Global_flags.Split_raster_into_intervals_and_analyze 
                   if ~isempty( Connectiv_data )
                   Connectiv_data.Connectiv_matrix_M_on_tau_not_fitted = []; 
                   Connectiv_data.Connectiv_matrix_M_on_tau = []; 
                   end
               else 
                   filename_all_splitted = [];
                   s = size( Analysis_data_cell ) ;
                   files_num_splitted = s(2);
                   filename_all_splitted = cell( files_num_splitted , 1 ) ;
                   for i=1 : files_num_splitted
                        filename_all_splitted{i} = filename ;
                   end
                   filename = filename_all_splitted ;
               end
               %++++++++++++++++++++
               ALL_cell.Connectiv_data = [ ALL_cell.Connectiv_data ; Connectiv_data' ];  
               ALL_cell.filenames = [ ALL_cell.filenames ; filename  ] ;
               ALL_cell.Analysis_data_cell_field_names  =  Analysis_data_cell_field_names ;
%              end




%              if fi == 1 % add last file data
%                  ALL_cell.Analysis_data_cell = [ ALL_cell.Analysis_data_cell ;   Analysis_data_cell' ];
% %                ALL_cell.Analysis_data_cell = [ ALL_cell.Analysis_data_cell ;  ANALYZED_DATA_1.Analysis_data_cell' ];
%                 %++++++++++++++++++++
%                if ~Global_flags.Split_raster_into_intervals_and_analyze   
%                    Connectiv_data1_0.Connectiv_matrix_M_on_tau_not_fitted = []; 
%                    Connectiv_data1_0.Connectiv_matrix_M_on_tau = []; 
%                    filename_all_splitted = [];
%                    s = size( Analysis_data_cell ) ;
%                    files_num_splitted = s(2);
%                    filename_all_splitted = cell( files_num_splitted ) ;
%                    filename_all_splitted{:} = filename ;
%                    filename = filename_all_splitted ;
%                end
%                %++++++++++++++++++++
%                ALL_cell.Connectiv_data = [ ALL_cell.Connectiv_data ; Connectiv_data1_0' ];  
%                ALL_cell.filenames = [ ALL_cell.filenames ; filename  ] ;
%              end
% 
%                % add file data to cell
% %                ALL_cell.Analysis_data_cell = [ ALL_cell.Analysis_data_cell ;  ANALYZED_DATA_2.Analysis_data_cell' ];
%                ALL_cell.Analysis_data_cell = [ ALL_cell.Analysis_data_cell ;  Analysis_data_cell2' ];
%                
%                %++++++++++++++++++++
%                % reduce size of connectiv_daata
%                if ~Global_flags.Split_raster_into_intervals_and_analyze   
%                Connectiv_data2_0.Connectiv_matrix_M_on_tau_not_fitted = []; 
%                Connectiv_data2_0.Connectiv_matrix_M_on_tau = []; 
%                end
%                %++++++++++++++++++++
%                
%                ALL_cell.Connectiv_data = [ ALL_cell.Connectiv_data ; Connectiv_data2_0' ];
%              
% %                ALL_cell.Analysis_data_cell_field_names  = ANALYZED_DATA_2.Analysis_data_cell_field_names ;
%                ALL_cell.Analysis_data_cell_field_names  =  Analysis_data_cell_field_names ;
%                ALL_cell.filenames = [ ALL_cell.filenames ; filename2 ] ;
           end
           
%            Connectiv_Compare_2_connectiv_data_script
            % Input : Connectiv_data1, Connectiv_data2 , Global_flags
            % Output: Comp_result
 
%            ONE_EXPERIMENT_RESULTS.Comp_result = Comp_result ;
           ONE_EXPERIMENT_RESULTS.Comp_result = [] ;           
%              ONE_EXPERIMENT_RESULTS_new.Comp_result=Comp_result;
%              ONE_EXPERIMENT_RESULTS = [ ONE_EXPERIMENT_RESULTS ONE_EXPERIMENT_RESULTS_new ];
            % Connectiv_data struct :
            % Connectiv_matrix_M_on_tau ( N x N x Connectiv_data.params.tau_number ) 
            % Connectiv_matrix_max_M (NxN) , 
            % Connectiv_matrix_tau_of_max_M ( NxN )
            % max_M - Maximum % of spikes transferred , tau - delay of max_M
            % Connectiv_matrix_tau_of_max_M_vector 
            % Connectiv_matrix_tau_of_max_M_vector_non_zeros
            % Connectiv_matrix_max_M_vector
            % Connectiv_matrix_max_M_vector_non_zeros
            % Connectiv_data.params
           if ANALYSIS_ARG.Use_3_files
               Connectiv_data1 = Connectiv_data2_0 ;
               Connectiv_data2 = Connectiv_data3_0 ;

               Connectiv_Compare_2_connectiv_data_script 
               % Input : Connectiv_data1, Connectiv_data2 , Global_flags
               % Output: Comp_result
               ONE_EXPERIMENT_RESULTS_new.Comp_result=Comp_result;
               ONE_EXPERIMENT_RESULTS = [ ONE_EXPERIMENT_RESULTS ONE_EXPERIMENT_RESULTS_new ];
           end
    end
           
           close all             
           RESULT = [];
end


    
 
 
% if ~strcmp(Experiment_type, 'Connectivity_compare') 
                ALL_EXPERIMENTS_SHORT_RESULT_all = [ALL_EXPERIMENTS_SHORT_RESULT_all   RESULT ] ;
                ONE_EXPERIMENTS_FULL_RESULTS_all = [ ONE_EXPERIMENTS_FULL_RESULTS_all ONE_EXPERIMENT_RESULTS ];     
                ALL_EXPERIMENTS_FULL_RESULTS_all_chain = [ ALL_EXPERIMENTS_FULL_RESULTS_all_chain ONE_EXPERIMENT_RESULTS ] ;
            % GLOB_cycle - scan all electrodes  EL_SEL !!!
             %------- Record all results when GLOB_cycle 
                  if Global_flags.cycle_all_electrodes
%                         k = waitforbuttonpress ;
  
                        close all  
                  end
          %----------------------------------------------------------
% end                 
                 
    end %  for  Global_loop_var = GLOB_cycle_start 
    end
                   
    %//////////////////////////////////////////////////////////////
    %////////// After pair (3 files) processed ///////////////////// 
                      if ANALYSIS_ARG.FILE_LIST_PROCESS && Global_flags.Force_Reanalyze_bursts_connectiv == false
                         if  n_files > 0 
                             if Global_flags.cycle_all_electrodes
                                 close all
                             end
                             
                             if Nexp > 1
                                 close all
                             end
                            
                            % memory RESULT_ALL and FULL_RESULTS_all
                             RESULT_Expereiment_delimiter = zeros( length( RESULT ),1);
                             ALL_EXPERIMENTS_SHORT_RESULT_all =  [ALL_EXPERIMENTS_SHORT_RESULT_all RESULT_Expereiment_delimiter     ] ;
                             ONE_EXPERIMENT_FULL.FULL_RESULTS_all = ONE_EXPERIMENTS_FULL_RESULTS_all ;
                             ALL_EXPERIMENTS_FULL_RESULTS_all =[ ALL_EXPERIMENTS_FULL_RESULTS_all   ONE_EXPERIMENT_FULL ];
                             ONE_EXPERIMENTS_FULL_RESULTS_all = [];
                         end
                         %-- if not already added data
                         if    Global_flags.Electrode_selection_extract_channel 
%                              ONE_EXPERIMENTS_FULL_RESULTS_all = [ ONE_EXPERIMENTS_FULL_RESULTS_all ONE_EXPERIMENT_RESULTS ];     
                         end
                      end
 end
    %//////////////////////////////////////////////////////////////
    %//////////////////////////////////////////////////////////////               
 
 
                  
end % fi = 1 : files_step : n_files 
end