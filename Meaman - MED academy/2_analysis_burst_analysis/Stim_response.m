% Stim_response
function [ POST_STIM_RESPONSE ] = Stim_response( Post_stim_interval_start ,Post_stim_interval_end , ...
    Take_all_spikes_after_stim , DT_bin , ...
      Artefact_channel, filename , SHOW_FIGURES , checkbox5msBin , Params )
 AskFileInput = false;
if  filename==0
AskFileInput = true;
end
 
params.detect_spont_bursts = false ;
Cycle_Poststim_interval_END_and_HiLo_classify = false ;

Search_Params = Params  ;
% Electrode_selection_extract_channel = false ;
%      electrode_sel_param.stim_chan_to_extract = 2 ;
%      electrode_sel_param.Start_channel = 2; % electrode selection started from
%      electrode_sel_param.Stimuli_to_each_channel = 30 ; % stimuli to each channel
%      electrode_sel_param.Channel_step = 4 ;
%      electrode_sel_param.correct_protocol = false ;


 
 GLOBAL_CONSTANTS_load
 
  %--- Save POSTSTIM RESPONSE  to DB original (not filtered) responses
Params.Save_not_filtered_responses = Global_flags.Save_not_filtered_responses_to_files_and_DB ;
 Erase_Prestim_artifacts_Patterns = Global_flags.Erase_Inadequate_Patterns_preStim ;

 Search_Params.Chambers_Separate_analysis_AB = Global_flags.Stim_Search_Params.Chambers_Separate_analysis_AB ;

 
Calc_Separated_Responses_and_show = false ;
 if isfield( Global_flags , 'Cluster_responses' ) 
    Calc_Separated_Responses_and_show = Global_flags.Cluster_responses ;
 end
 if isfield( Global_flags , 'Erase_Inadequate_Patterns' ) 
    Erase_Inadequate_Patterns = Global_flags.Erase_Inadequate_Patterns ;
 end
 


  if isfield( Global_flags , 'Filter_small_responses' ) 
    Filter_small_responses = Global_flags.Filter_small_responses ;
  end
 
   Shuffle_test = Global_flags.Stim_Search_Params.Shuffle_test     ;
 
   Calc_Separated_Responses_and_show_Many_clusters = true ;
   
 if Global_flags.Stim_response_Elsel_extract_all_and_show  
 Calc_Separated_Responses_and_show_Many_clusters = false ;
 Shuffle_test = false ;
  Erase_Inadequate_Patterns = false ;
 end
 
 
Take_all_spikes_after_stim= true ;
FIND_ALL_SPIKES_AFTER_STIM = Take_all_spikes_after_stim ;
if nargin == 9
    Adjust_artefact_times = Params.Adjust_artefact_times ;
else
    Adjust_artefact_times = false ;
end
 
SHOW_RS_figure = false ;
Analyze_preceding_spont_bursts = Params.Analyze_preceding_spont_bursts ;
 
EMPTY_SPIKE_TIME = 0 ; % maybe 0 or NaN, NaN not tested
chan_Prcnt_Respomded = 0.0 ;
isDrawSpikeRateSignature =false ;
CHANNEL = 1 ;
CHANNEL_art = Artefact_channel ;
 
N = 64 ;
NNN = 60 ;
BBB = 2 ;
BIN= 10 ;% bin for post stim response, ms
MIN_INTER_ARTEFACT_INTERVAL = 10 ;  %ms
        Number_of_BINs_SpikeRate_Hist = 20 ; % Spike rate hist for each electrode each response
 
PostResp_Flags = zeros( 40 , 1); % additional info       
       
DT_step = DT_bin ;
 
 
 
% -- LOAD DATA --------------------------------------------------------
 if AskFileInput
    [filename, pathname] = uigetfile('*.*','Select file') ;
 else
    [pathname,name,ext] = fileparts( filename ) ;
 end
    
 
if filename ~= 0
      
    [pathstr,name,ext] = fileparts( filename ) ;
    FILENAME = name ;
    ext   
 init_dir = cd ;
 if length( pathname ) > 0
   cd( pathname ) ;
 end
 Full_File_name = [ pathname filename ];
Full_File_name
 
MED_file_raster_input = false ;
 
% Load artifacts
if  ext == '.mat'  
    MED_file_raster_input = true ;
    filename_art = 1 ;
    load( char( filename ) ) ;
    index_r = RASTER_data.index_r ;
    artefacts = RASTER_data.artefacts ;
else
   [filename_art, pathname_art] = uigetfile('*.*','Select file') ;
    index_r = load( char( filename ) ) ;
end 
 


           




 Full_File_name = [ pathname filename ];
    [pathstr,name,ext] = fileparts( filename ) ;
    Raster_file =[char(name) '_Post_' int2str(Post_stim_interval_start) '_stim_spikes_raster.txt' ] ;
     Experiment_name = name ;
% --/////// LOAD DATA -------------------------------------------------
 
 
if filename_art ~= 0
   
   
    %% Sigma_filter
 
    
  
    
% 606.850  22  -0.0487 -0.0148
% 608.350  22  -0.1628 -0.0148 

%   Sigma_amp_filter = 3 ; 
% new_sigma = Sigma_amp_filter * index_r( : , 4) ; 
% spikes = index_r( : , 3)   ;
% 
% low_spikes_ind = find( spikes >  new_sigma ) ;
% index_r( low_spikes_ind , : ) = [] ;
%  
           
    
   
    if MED_file_raster_input == false
      artefacts = load( char( [ pathname_art filename_art ]) ) ; 
    end 
    N  = max(index_r( :,2) ); %Number of channels
    if N < 60
        N = 60 ;
    end
   


 % --- OLD version of artefacts load
%     extract_channel_index = find( artefacts( : , 2 ) == CHANNEL_art ) ;
%     artefacts =  artefacts( extract_channel_index , 1 ) ;
 
 % --- NEW version of artefacts load    
    artefacts =  artefacts( : , 1 )  ;
     
    artefacts_origin = artefacts ; 
 
%%  if artifacts file is bad then find artifacts from 1ms SpikeRate plot
    
        if     GLOBAL_const.Find_artifacts_from_raster
            artefacts = [] ;
            Find_artifact_times_from_raster_script
           % Find artifact times using 1 ms bin AWSR of raster  
            % output: artefacts
        else
                    BIN = 1 ;
            Min_inter_artifact_time_ms = 100 ;
 
         artefacts_new = artefacts ;
         params.show_figures = false ;
         AWSR = AWSR_from_index_r( index_r  , BIN  ,params  );
          AWSR_art = AWSR   ;
          AWSR_art( : ) = 0 ; 
          AWSR_art( floor( artefacts ) )  = max(AWSR) ;
          
       if   SHOW_FIGURES   
          
            figure 
         hold on
         
         plot( AWSR); 
         plot( AWSR_art , 'r' )
%          plot( artefacts , max(AWSR) * ones( 1,length( artefacts)) , 'r*' );
         legend( 'Spikerate original' ,  'artifacts' )
         hold off
       end
        end
 %%---------------------------------------------------  
        
    % parametes from GLOBAL_CONSTANTS_load
    
%% Erase or leave some artifacts ( with defined period )
     if  Params.leave_or_erase_artifacts    
         
         % if artifact step = 6 then articats to erase(leave) 6:12:18....
        artifact_index = Params.leave_or_erase_every_artifact_period : Params.leave_or_erase_every_artifact_period : length( artefacts   )  ;
%         artifact_index(1) = 1;
         if Params.erase_artifacts
              artefacts( artifact_index  ) = [];  
         else
           artefacts = artefacts( artifact_index  ) ; 
         end 
         
         figure 
         hold on
%          plot( AWSR_0 , 'g' )
%          plot( AWSR); 
         plot( artefacts , ones( 1 , length(artefacts) ),  'r*' );
         xlabel( 'time. ms')
%          legend( 'Spikerate original' , 'filtered' , 'artifacts' )
        title( 'Artifact times')
         hold off
    end
    
    whos artefacts 
   
%% Extract stim channel
    if  Global_flags.Stim_response_Elsel_extract_channel
         if strcmp( electrode_sel_param.type , 'Cycle' )
                        delete_index = 1 : length( artefacts   )  ;
                        Number_of_artifacts = length( artefacts   ) 
                        Stimuli_to_each_channel =  electrode_sel_param.Stimuli_to_each_channel +1
                        Number_channels_in_Electrode_Selection = Number_of_artifacts / (Stimuli_to_each_channel  )
                        El_sel_extract_channel_patterns 
%                         delete_index( leave_index ) = [] ;
%                         artefacts  = artefacts(leave_index) ;
         end
            leave_index = [] ;
          if strcmp( electrode_sel_param.type , 'List' )               
%                 electrode_sel_param.Stimuli_to_each_channel = 30 ; % stimuli to each channel
%                 electrode_sel_param.Stimulation_channels = [ 1 2 4 5 ] ; % list of stim channels = [ 1 3 43 2 .. ]
%                 electrode_sel_param.Stimulation_channels_num  = length( electrode_sel_param.Stimulation_channels ) ; % stimuli to each channel
%                 electrode_sel_param.Selected_Stimulation_channel ;
                leave_index = 1 : electrode_sel_param.Stimuli_to_each_channel ;
                leave_index = leave_index + ( electrode_sel_param.Selected_Stimulation_channel - 1 )*electrode_sel_param.Stimuli_to_each_channel ;
                
          end
          
          if ~Global_flags.Stim_response_Elsel_extract_all_and_show
              delete_index = 1 : length( artefacts   )  ;
              delete_index( leave_index ) = [] ;
              artefacts  = artefacts(leave_index) ;
          end
    end
   
   %% Artifacts characteristics 
    a = diff( artefacts ) ;
    min_Artefact_interval_ms = min( a) ;
    min_Artefact_interval_ms
    mean_interartifact_interval = mean( a )
    std_interartifact_interval = std( a )
   
    if min_Artefact_interval_ms < MIN_INTER_ARTEFACT_INTERVAL
       ERASE = [];
       if length( artefacts   ) >1
       for i=2:  length( artefacts   ) 
          if artefacts(i)- artefacts(i-1) < MIN_INTER_ARTEFACT_INTERVAL
              ERASE=[ERASE i];
          end
       end
       artefacts( ERASE ) = [];
       end
    end
   
%     Adjust_artefact_times = true ;

artefacts_origin = artefacts ; 

%% check if all artifacts are double=correctly written in NLearn
    if Adjust_artefact_times
      % Adjusts artifact times using 1 ms bin AWSR of raster -> finds max of
      % AWSR around each artifact time +- 1000 ms.
        Adjust_artifact_times_script
    end
    
      
%         FFF = 6;
%     artefacts( FFF: end  ) = [];
%         artefacts( end - FFF : end ) = [];
   
%     FFF = 6;
%     artefacts( FFF : end ) = [];
% artefacts( 1 : FFF ) = [];
% %     artefacts( FFF : end ) = [];
%     artefacts( 300 : end ) = [];
 
 
    %     artefacts = sort( artefacts , 1 );
   
%------------------------------------------

%% Global Cycle for chamber analysis

Cycle_rasters_num = 1 ;

index_r_spont = index_r ;
         
if  Global_flags.Stim_response_Elsel_extract_all_and_show
    Search_Params.Chambers_Separate_analysis_AB = false ;
else
        if Global_flags.Stim_Search_Params.Chambers_Separate_analysis_AB
            name_original = name ;
            Cycle_rasters_num = 3 ;
            Extract_rasters_chambers

            % Eaxtract rasters A B AB
            % input : RASTER_data.index_r 
            % Global_flags.Search_Params.chamber_A_electrodes
            % Global_flags.Search_Params.chamber_B_electrodes
            % output : RASTER_data.index_r RASTER_data.index_rA RASTER_data.index_rB
            original_dir = cd ;
            
        end 
end
        
for Raster_number_stim = 1 : Cycle_rasters_num 
Save_to_DB_local = true ;
            % extract on eacg cycle  raster form 6well raster
params.show_figures = true ;
            
            
%             if Global_flags.Search_Params.Chambers_Separate_analysis_AB
            if Search_Params.Chambers_Separate_analysis_AB
                
                params.show_figures = false ;
                Search_Params.Chamber_analysis_AB = false;   
                Search_Params.Chamber_analysis_BA = false;
                Write_file_in_separate_dir = true ;
               switch (Raster_number_stim)
                   
                   case 1 
                       index_r = Chambers.RASTER_data.index_rA ;
                       artefacts = artefacts_origin ;
                       Chamber_str = 'Chamber A ' ;
                       Anallysis_Figure_title = Chamber_str ;
                       Write_file_in_separate_dir = true ;
                       params.show_detection_bursts = true ;
                       params.show_figures = true ;
                       Save_to_DB_local = false ;
                       params.detect_spont_bursts = false ;
                       params.ChambersStim_A_spont_analyzed = params.detect_spont_bursts ;
                   case 2 
                       index_r = Chambers.RASTER_data.index_rB ;
                       Chamber_str = 'Chamber B ' ;
                       artefacts = artefacts_origin ;
%                        N = max( index_r(:,2) );
                       Anallysis_Figure_title = Chamber_str ;
                       Write_file_in_separate_dir = true ;
                       params.show_detection_bursts = true ;
                       params.show_figures = false ;
                       Save_to_DB_local = false ;  
                       params.detect_spont_bursts = Global_flags.Stim_Search_Params.Chambers_Separate_analysis_AB_spont_in_B ;
                       params.ChambersStim_B_spont_analyzed = params.detect_spont_bursts ;
                       
                       Calc_Separated_Responses_and_show = ...
                           Global_flags.Stim_Search_Params.Chambers_Separate_analysis_AB_cluster_resp_B ;
                        % true - when ...
                % clustering high low responses in chambers A, now
                % clustering in B will be done. To find only Low(A)->B
                % responses or High(A)->B responses.
                         
                  case 3     % Channels                      
                       index_r = Chambers.RASTER_data.index_rChan ;
                       Chamber_str = 'Channels ' ;
%                        N = max( index_r(:,2) ); 
                       Anallysis_Figure_title = Chamber_str;
                       Write_file_in_separate_dir = true ;                                               
                       params.show_detection_bursts = false ;
                       params.show_figures = false ;
                       Save_to_DB_local = false ; 
%                        Search_Params.Filter_small_bursts_origin = Search_Params.Filter_small_bursts ;
%                        Search_Params.Filter_small_bursts = false ;
                       params.detect_spont_bursts = false ;
                       params.show_detection_bursts = false  ; 
                       params.ChambersStim_chan_spont_analyzed = params.show_detection_bursts ;
                       
                       Calc_Separated_Responses_and_show = false ;
                       Erase_Inadequate_Patterns = false ;
                       Erase_Prestim_artifacts_Patterns = false ;
                       
%                    case 4  % A->B
%                        params.show_detection_bursts = false ;
%                        index_r = Chambers.RASTER_data.index_r ;
%                        Save_to_DB_local = false ;
% %                      N = max( index_r(:,2) ); 
%                        Write_file_in_separate_dir = true ; 
%                        Chamber_str = 'AB' ;
%                        Anallysis_Figure_title = 'A->B' ;
%                        Search_Params.Chamber_analysis_AB = true ;
%                        Search_Params.Chamber_analysis_BA = false ; 
%                    case 5 % all spikes
%                        Search_Params.Filter_small_bursts = Search_Params.Filter_small_bursts_origin ;
%                        index_r = Chambers.RASTER_data.index_r ; 
%                        N = max( index_r(:,2) );
%                        Search_Params.Chamber_analysis_AB = false ;
%                        Search_Params.Chamber_analysis_BA = false ; 
%                        Anallysis_Figure_title = 'Normal raster' ;
%                        Write_file_in_separate_dir = false ;
%                        Experiment_name =  Experiment_name0 ; 
%                        Save_to_DB_local = true ;
%                        cd( original_dir );
%                end  
               end  
            end
        
%% ----- Extract responses -------------------   
artefacts = artefacts_origin ;
    N_responses = length(artefacts_origin) ;
    N_responses_original = N_responses ;
   
    burst_start = artefacts + Post_stim_interval_start ;
    burst_end = artefacts + Post_stim_interval_end ;   
    flags.Burst_Data_Ver = Burst_Data_Ver ; 
    flags.par.Amp_sigma_threshold =  handles.par.Stim_response_Amp_sigma_threshold  ;
    flags.par.Stim_response_Amp_as_AmpSigma = handles.par.Stim_response_Amp_as_AmpSigma ;
%     fire_bins = floor(( Post_stim_interval_end -  Post_stim_interval_start) /  DT_bin) ; 
    fire_bins = round(( Post_stim_interval_end  ) /  DT_bin) ; 

         %//////////////////////////////////////////    
         [ Patterns ] = Patterns_Get_Responses_in_Interval_from_Raster( N , artefacts ,index_r ,Post_stim_interval_start , ...
           Post_stim_interval_end  , DT_bin ,flags );
          % index_r, intervals post stim -> bursts burst_activation
          % One_sigma_in_channels ... 
         %//////////////////////////////////////////
            Patterns.Normalize_responses = false; 
            % Patterns_get_Total_rates_Tactivation_from_bursts
            % Patterns.bursts -> Patterns.Spike_Rates Patterns.burst_activation ...
%             var.simple_activation_patterns = true ;
            var.simple_activation_patterns = Global_flags.simple_activation_patterns ;
            Patterns_get_Total_rates_Tactivation_from_bursts 

            % Patterns_get_BIN_rates_from_bursts
             % Patterns.bursts -> Patterns.Spike_Rates_per_channel_per_bin ,
             % Patterns.Amps_per_channel_per_bin
              Patterns_get_BIN_rates_from_bursts
               
             % Patterns_get_TimeBin_Total_Spikes
            %  Spike_Rates_per_channel_per_bin - > TimeBin_Total_Spikes
            % Amps_per_channel_per_bin -> TimeBin_Total_Amps     
%               Patterns_get_TimeBin_Total_Spikes         
              
%% Save_not_filtered_responses / Patterns_original_raw = Patterns ; 
 if Params.Save_not_filtered_responses 
    Patterns_original_raw = Patterns ; 
 end
 
%% Show_random_pattern_responses
if SHOW_FIGURES
Show_random_pattern_responses( N,25 , index_r ,  artefacts , Post_stim_interval_start , Post_stim_interval_end ,DT_step   )
end
        %=======================================================================
        %=======================================================================
%% Calc_Separated_Responses_and_show

        if Calc_Separated_Responses_and_show
            if Calc_Separated_Responses_and_show_Many_clusters
                         
%                 Patterns.TimeBin_Total_Spikes Already calculated

                %= Clustering - many clusters - Cluster all responses ================
%                     TimeBin_Total_Spikes should be defined
                    var.figure_title = 'Original responses' ;
                    Clustering_many_clusters_TimeBin_Total_Spikes 
                    
                %=---------------- Clustering - many clusters ================
                
                          %----- Patterns_Delete_Inadequate_responses
                            % TimeBin_Total_Spikes -> delete_responses_index
                            Nb0 = Patterns.Number_of_Patterns ;
                            
                            if  Global_flags.Leave_only_high_patterns || Global_flags.Leave_only_low_patterns
                                Global_flags.Filter_small_responses = Filter_small_responses ;
                               flags.SHOW_FIGURES_low_hi_responses = true ;
                               Patterns_Cluster_Low_High_Responses_and_Separate
%                                Patterns = Patterns.Patterns_high ;
                            end
%                             
%                              responses_index = delete_responses_index ;
%                              
%                              Filtered_responses_num = length(responses_index)
%                              Patterns.Filtered_responses_number =   Filtered_responses_num ;
%                              Patterns.Filtered_responses_percent = 100 *(  Filtered_responses_num/ Nb0 ) ;
%                                  % responses_index shoulkd be defined
%                                  % before call
%                              Stimulus_responses_Delete_responses 

            end
        end
          if Erase_Inadequate_Patterns
                    [ Patterns number_of_Inadequate_Patterns Percent_adequate_patterns  ]...
                                = Erase_Inadequate_Patterns_2( Patterns  ) ;                             
         end
                
           if Erase_Prestim_artifacts_Patterns
               if Patterns.Number_of_Patterns > 0 
                    Analyze_preBursts_to_stim2
                    % input: filename
                    % output: Bad_artefacts_filt
                    
                    responses_index = Bad_artefacts_filt ;
                    
                    
                    'Erasing_Prestim_artifacts_Patterns...'
                    
                    Deleted_responses_with_prestim =  length(responses_index)             
             
                    EraseIf_tru_otherwise_put_Zero = true ;
                    % responses_index EraseIf_tru_otherwise_put_Zero=true/false shoulkd be defined
                                 % before call
                             Stimulus_responses_Delete_responses
               end
            end

    if Calc_Separated_Responses_and_show
       if Calc_Separated_Responses_and_show_Many_clusters         
                 %= Clustering - many clusters - show after filtering inadequate responses ================
%                     TimeBin_Total_Spikes should be defined
                if Patterns.Number_of_Patterns >0
                    var.figure_title = 'Filtered Inadequate responses' ;
                    Clustering_many_clusters_TimeBin_Total_Spikes 
                end
                %=---------------- Clustering - many clusters %================
       end
     
                        
                        
                        
         %======================== Clustering - 2 clusters of High Low responses ================   
            flags.SHOW_FIGURES_low_hi_responses = true ;
            
                % Patterns.Spike_Rates_each_burst -> High_responses_index ,
                % Low_responses_index ...
                % flags.SHOW_FIGURES_low_hi_responses should be defined before
%                 Patterns_get_High_Low_responses
            
         
                if Cycle_Poststim_interval_END_and_HiLo_classify 
  %========== Cycle  Poststim_interval_END and check how classification Ho Lo works out             
 
            Davies_Bouldin_all = [] ;
            Post_stim_durations  = []; 
            squared_sum_of_errors_all = [];
            HiLo_Low_Responses_Spike_Rates_Relative_Range_all = [];
            HiLo_High_Responses_Spike_Rates_Relative_Range_all = [];
            HiLo_Low_Responses_Spike_Rates_Relative_STD_all = [];
            HiLo_High_Responses_Spike_Rates_Relative_STD_all = [];
%                 Patterns.HiLo_squared_sum_of_errors_CLUSTERING_Spike_Rates_each_burst  
%                 Patterns.HiLo_High_Responses_Spike_Rates_Relative_Range 
%                 Patterns.HiLo_High_Responses_Spike_Rates_Relative_STD 
%                 Patterns.HiLo_Low_Responses_Spike_Rates_Relative_Range        
%                 Patterns.HiLo_Low_Responses_Spike_Rates_Relative_STD    

            for DTi_end = 30 : 10 :300
                
                  Patterns.Poststim_interval_END  = DTi_end ;
                
                        %====== Recalc all data ===============
                            % Patterns_get_Total_rates_Tactivation_from_bursts
                            % Patterns.bursts -> Patterns.Spike_Rates Patterns.burst_activation ...
                            Patterns_get_Total_rates_Tactivation_from_bursts


                            % Patterns_get_BIN_rates_from_bursts
                             % Patterns.bursts -> Patterns.Spike_Rates_per_channel_per_bin ,
                             % Patterns.Amps_per_channel_per_bin
                              Patterns_get_BIN_rates_from_bursts


                             % Patterns_get_TimeBin_Total_Spikes
                            %  Spike_Rates_per_channel_per_bin - > TimeBin_Total_Spikes
                            % Amps_per_channel_per_bin -> TimeBin_Total_Amps     
                            var.use_selected_patterns = false;
%                               Patterns_get_TimeBin_Total_Spikes
                         %=======================================
                         
                % Patterns.Spike_Rates_each_burst -> High_responses_index ,
                % Low_responses_index ...
                % flags.SHOW_FIGURES_low_hi_responses should be defined before
                Patterns_get_High_Low_responses
                
                  Post_stim_durations  = [ Post_stim_durations Patterns.Poststim_interval_END - Patterns.Poststim_interval_START ];
                  Davies_Bouldin_all = [Davies_Bouldin_all  Patterns.HiLo_Davies_Bouldin_TSR_Clustering_index   ];
                  squared_sum_of_errors_all = [ squared_sum_of_errors_all Patterns.HiLo_squared_sum_of_errors_CLUSTERING_Spike_Rates_each_burst  ] ;
                  HiLo_Low_Responses_Spike_Rates_Relative_Range_all = [HiLo_Low_Responses_Spike_Rates_Relative_Range_all ...
                      Patterns.HiLo_Low_Responses_Spike_Rates_Relative_Range      ];
                  HiLo_High_Responses_Spike_Rates_Relative_Range_all = [ HiLo_High_Responses_Spike_Rates_Relative_Range_all ...
                      Patterns.HiLo_High_Responses_Spike_Rates_Relative_Range ]; 
                  HiLo_Low_Responses_Spike_Rates_Relative_STD_all = [HiLo_Low_Responses_Spike_Rates_Relative_STD_all ...
                      Patterns.HiLo_Low_Responses_Spike_Rates_Relative_STD      ];
                  HiLo_High_Responses_Spike_Rates_Relative_STD_all = [ HiLo_High_Responses_Spike_Rates_Relative_STD_all ...
                      Patterns.HiLo_High_Responses_Spike_Rates_Relative_STD ];                   
                
            end
            
            figure
            Nx= 3 ; Ny= 2 ;
            subplot( Ny , Nx , 1)
               plot( Post_stim_durations , Davies_Bouldin_all )
               title( 'Davies Bouldin  ') 
            subplot( Ny , Nx , 2)
               plot( Post_stim_durations , squared_sum_of_errors_all )
               title( 'squared sum of errors ')
               
            subplot( Ny , Nx , 3)
               plot( Post_stim_durations , HiLo_Low_Responses_Spike_Rates_Relative_Range_all )
               title( ' Low Responses Spike Rates Relative Range ')
             subplot( Ny , Nx , 4)
               plot( Post_stim_durations , HiLo_Low_Responses_Spike_Rates_Relative_STD_all )
               title( ' Low Responses Spike Rates Relative STD ')              
               
            subplot( Ny , Nx , 5)
               plot( Post_stim_durations , HiLo_High_Responses_Spike_Rates_Relative_Range_all )
               title( 'HiLo High Responses Spike Rates Relative Range ') 
            subplot( Ny , Nx , 6)
               plot( Post_stim_durations , HiLo_High_Responses_Spike_Rates_Relative_STD_all )
               title( 'HiLo High Responses Spike Rates Relative STD ')
 
            
  %===================================================
            
            
                end
        
        end
        %=======================================================================
        %=======================================================================
        %=======================================================================
  
%% Patterns_get_Statistsic_all_parameters     
% Patterns.TimeBin_Total_Spikes  ... -> TimeBin_Total_Spikes_mean
if Patterns.Number_of_Patterns > 0
Patterns_get_Statistsic_all_parameters
end

%% If ElSel and show all stim response signatures
if Global_flags.Stim_response_Elsel_extract_all_and_show
    
    
     if strcmp( electrode_sel_param.type , 'List' )               
         
         
        %--------------------------------
        Stim_response_Elsel_Extract_all_resp_and_show
        %--------------------------------
        
       
    end
end

%% --- Here all responses analyzed and filtered responses in ------------------------------------------------------------------------------

%% -- Spont burst analysis

% if Global_flags.Stim_Search_Params.Shuffle_test   
 if params.detect_spont_bursts 
    
    
 %------ find all bursts from raster  
 ba = artefacts_origin ; 
 artefacts_origin = artefacts ;
    ready_to_analyze = true ;
    Arg_file.Use_meaDB_raster = false ;
    buf3 = Global_flags.autosave_to_DB  ;
    buf2 = Search_Params.save_bursts_to_files  ;
    buf = Search_Params.Chambers_Separate_analysis_AB ;

    Search_Params.Chambers_Separate_analysis_AB = false ;
    Global_flags.autosave_to_DB = false ;
    Search_Params.save_bursts_to_files = false ;
    Search_Params.Show_figures = true ;
    params.show_detection_bursts = true ;
    
    
    % prepare raster for spont bursts analysis -------------
    
    Edit_from = artefacts_origin(1);
    Edit_to = artefacts_origin( end ) + Global_flags.Global_Poststim_interval_END ;
    ss = find( index_r_spont( : , 1 ) < Edit_from );
       if ~isempty( ss )
            index_r_spont( ss , : ) = [] ;
       end 
     ss = find( index_r_spont( : , 1 ) >= Edit_to );
       if ~isempty( ss )
            index_r_spont( ss , : ) = [] ;
       end   
      
       DTs = 10  ;
       for ai = 1 : length(artefacts_origin)
           ss = find( (index_r_spont( : , 1 ) > artefacts_origin(ai) - DTs )&  ...
                      (index_r_spont( : , 1 ) < artefacts_origin( ai) + DTs) );
           if ~isempty( ss )
                index_r_spont( ss , : ) = [] ;
           end 
       end
 
       Anallysis_Figure_title_buf = Anallysis_Figure_title ;
       Anallysis_Figure_title = 'Spont in stim response' ;
    %---------
    Find_bursts_main_script
    %---------
    % Now ANALYZED_DATA contain spont bursts
 
    Anallysis_Figure_title = Anallysis_Figure_title_buf ;
    Global_flags.autosave_to_DB = buf3 ;
    Search_Params.Chambers_Separate_analysis_AB = buf ;
    Search_Params.save_bursts_to_files = buf2 ;
 artefacts_origin = ba ;
 end
% end
 
%% -- Suffle test analyse responses

if Shuffle_test     
    ChamberAB_shuffle_result.artefacts_evoked_index = [];
    ChamberAB_shuffle_result.artefacts_evoked_percent = 0 ;
    ChamberAB_shuffle_result.artefacts_evoked_number = 0;
    ChamberAB_shuffle_result.artefacts_evoked_bursts =0 ; 
    
if Patterns.Number_of_Patterns > 0

%        Patterns.burst_start
   E1 = artefacts_origin ; 
   E1_d = artefacts_origin ; 
   E1_d(:) = Post_stim_interval_end ;
   E2 = Patterns.burst_start + Post_stim_interval_start ;
%    E2 = Patterns.burst_start_Tact_mean + Post_stim_interval_start ;
%    E2 = Patterns.artefacts + Post_stim_interval_start ;
   E2_d = E2 ; E2_d( : ) = E1_d( 1 )  ;
%    Patterns_get_smooth_profiles_Tact;
%    Patterns.burst_max_rate_delay_ms 
ChamberAB_shuffle_result = [];
 [ result ]= Events_delays_analysis_with_shuffling( E1 ,E1_d , E2 ,E2_d  ) ;
 ChamberAB_shuffle_result = result ;
 
 if ~isempty( E2 )
% Stimuli evoked bursts :

ChamberAB_shuffle_result.artefacts_evoked_index  = [] ;
if result.Chambers_A_B_connection_exist 
    ChamberAB_shuffle_result.artefacts_evoked_index =   result.Chambers_A_B_evoked_burst_index( : , 1 ) ;
end
% Number of stimuli evoked bursts
    ChamberAB_shuffle_result.artefacts_evoked_percent = result.Chambers_A_B_evoked_percent ; 
% Number of stimuli evoked bursts
    ChamberAB_shuffle_result.artefacts_evoked_number = result.Chambers_A_B_evoked_burst_number ;     
% Did stimuli evoked bursts
    ChamberAB_shuffle_result.artefacts_evoked_bursts = result.Chambers_A_B_connection_exist  ;
 else 

 end
    
end
end

%% Burst analysis - pre stim activity --------------------------
 
% if Params.Analyze_preceding_spont_bursts
%    artefacts = Patterns.artefacts;
%    if ~isempty( artefacts )
%     Analyze_preBursts_to_stim
%     end
%  
% end
%% POST_STIM_RESPONSE = Patterns ------------------------------------------------
PostResp_Flags(1) = 1 ; % Version of POST_STIM_RESPONSE data    
Patterns.Flags = PostResp_Flags ;% additional parameters
POST_STIM_RESPONSE = Patterns ;
 
% bursts_absolute = POST_STIM_RESPONSE.bursts_absolute; 
% Chambers_axon_signal_analysis

%% Analyze connectivity
 % POST_STIM_RESPONSE , but in Patterns_original_raw we have raw respones
  if Params.Analyze_Connectivity 
   % if connectivity will be foind to just filterd data   
   if Params.Analyze_Connectivity_only_filtered_responses
    
       bursts_absolute = POST_STIM_RESPONSE.bursts_absolute ; 
       Spike_Rates  = POST_STIM_RESPONSE.Spike_Rates;
       Spike_Rates_each_channel_mean = POST_STIM_RESPONSE.Spike_Rates_each_channel_mean ;
       
         Patterns_analysis_connectivity 
        % >>> Input: bursts or bursts_absolute , Spike_Rates  
        % Output >>>: 
        % Connectiv_data struct :
        POST_STIM_RESPONSE.Connectiv_data = Connectiv_data ;
        
        if Global_flags.Connectiv_chambersAB 
            Stim_resp_Connectiv_analyze_AB
        end
   end     
 end
    
%% Analyze_Connectivity_only_filtered_responses
if Params.Analyze_Connectivity 
   % if connectivity will be foind to just filterd data   
   if Params.Analyze_Connectivity_only_filtered_responses
    
      % connectivity already found :
        POST_STIM_RESPONSE.Connectiv_data = Connectiv_data ; 
   end     
end
 
 %% SHOW_FIGURES
if SHOW_FIGURES
   
   
  if Patterns.Number_of_Patterns > 0
  Post_stim_response_MAIN_analysis_FIGURE_script
  end
 
%   %--- Normalized responses statistics ------------------
%   flags.normalize = true ;
%   POST_STIM_RESPONSE = Recalc_all_Post_stim_data(  POST_STIM_RESPONSE , flags  );
%   Post_stim_response_MAIN_analysis_FIGURE_script
%   %------------------------------------------------------
 
 
%%%------ 8x8 figures ----------
 
% [psth_dx , psth , psth_norm ]  = PSTH_calc( bursts , length( artefacts ) , BIN  , Post_stim_interval_end , N ) ;
% MMMM = (max(psth)/ N )*0.5;             
%              
%              BINS = floor( Post_stim_interval_end / BIN ) ;
%              psth_ALL_CHANNELS = zeros( N , BINS  );
%              Median_delay_ALL_CHANNELS = zeros(1,N);
%              for CHANNEL_i = 1 :  N
%                [psth_dx , psth , psth_norm ] = PSTH_calc_channel( bursts , length( artefacts ) , BIN  , Post_stim_interval_end , N ,CHANNEL_i ) ;
%                ps=psth ;
%                ps_median = mean( ps );
%                bin_median = 1 ;
%                ps_median = MMMM ;
%                for bi = 1 : length(ps)-1
%                  if  ps_median > ps( bi )  && ps_median <= ps( bi+1 )
%                      bin_median = bi ;
%                  end
%                end
% %                bin_median = find( ps == ps_median );
% %                ps
% %                ps_median
% %                if CHANNEL_i == 54
% % %                    ps
% %                end
% %                ps_median
% %                bin_median = bin_median(1) ;
% %                bin_median
%                   Median_delay_channel = bin_median * BIN ;
%                   if ps_median == 0 Median_delay_channel=0 ; end                     
%                   Median_delay_ALL_CHANNELS( CHANNEL_i ) = Median_delay_channel ;
% %                   Median_delay_channel
 
       
       
end         
   
   
   
%  Plot8x8Data( response_s )
% xlabel( 'Electrode #' )
% ylabel( 'Electrode #' )
% title( 'Number of spikes after stimulus' )
% colorbar ;
 
    
% %     hist( all_index_after_art ,20 ) ;   
%     [n,xout] = hist( all_index_after_art , NNN ) ;
%     n(1: BBB ) = 0 ;
%     mean_spikes_per_bin_after_stimul = mean( n );
% %     mean_spikes_per_bin_after_stimul
%     n2 = n / length( all_index_after_art ) ;   
% %     n2 = n ;
% %         n2 = n / length( artefacts ) ;   
%         bar(xout , n2 )
 
 
% ---- PSTH -----
       
 
%      
%         bar(TimeBins * DT_step , TimeBin_Total_Spikes_mean )
%        
%         title( 'PSTH' )
%         xlabel( 'Post-stim time, ms')
       
       
       
 
 
 
 
%     hist( all_index_after_art ,20 ) ; 
 
  if SHOW_FIGURES
%      figure
%        errorbar( Spike_Rates_each_burst _channel_mean  , Spike_Rates_each_burst _channel_std  , 'xr')
%       title( 'Mean Firing rate per electrode' )
% %       barweb(Spike_Rates_each_burst _channel_mean, Spike_Rates_each_burst _channel_std, [], [], [], [], [], bone, [], [], 1, 'axis')
 
   %------------ spike rate each channel   
   
   if Global_flags.Stim_response_show_spikes_hist
      figure
      subplot( 2 , 1 , 1)
%         bar( Spike_Rates_each_channel_mean )
%             ylabel('Mean spikes')
%             xlabel( 'Electrode #')
%         title( 'Post-stim spikes per electrode' )
%       subplot( 3 , 1 , 2)
%         bar( Spike_Rates_each_channel_std )
%             ylabel( 'STD spikes')
           
      chan = 1:N ;
      err = Patterns.Spike_Rates_each_channel_std' ;
      y = Patterns.Spike_Rates_each_channel_mean' ;
        barwitherr(  err ,chan , y     );
                axis( [ min(chan) max(chan) 0 1.2 * max(err) ...
             + max(y) ] );
        xlabel( 'Electrode #')
        ylabel('Mean, STD spike rate')
       
        subplot(2,1,2)  
       
       
%         Number_of_BINs_SpikeRate_Hist = 20 ;
       
       
        SpikeRates_total = [];
        for CHANNEL_i = 1:N
            SpikeRates_total =[ SpikeRates_total ; Patterns.Spike_Rates( : , CHANNEL_i) ] ;
        end
%         whos SpikeRates_total
        if max(SpikeRates_total  ) > Number_of_BINs_SpikeRate_Hist * 2
             HStep = floor( max(SpikeRates_total  )/Number_of_BINs_SpikeRate_Hist );
        else
            HStep = 1 ;
        end
            xxx =  0 : HStep : max(SpikeRates_total  ) ;
            [h,p] = hist(SpikeRates_total   ,xxx) ;
           
            if length( p) >0
               h = 100 * (h / length( SpikeRates_total ));
             bar(p,h)
               xlabel('Spikes #')
               ylabel('Electrodes, %')
             title( 'Spike rate on electrode histogram' )
            end
 
   end
%     figure
%        subplot( 2 , 1 , 1);
%         bar( TimeBin_Total_Spikes_mean )
%      title( 'Mean & STD of Post-stim spikes in 20 ms bins') 
%      xlabel( 'Bin number')   
%      ylabel('Means pikes')
%     
%        subplot( 2 , 1 , 2 );
%         bar( TimeBin_Total_Spikes_std )   
%     xlabel( 'Bin number')    
%     ylabel( 'STD spikes')
   
 
%++++++ if show small step PSTH
 if checkbox5msBin 
     
%     BIN_small = 10  ;
    BIN_small = Params.Small_PSTH_bin  ;
    % %         [psth_dx , psth , psth_norm , psth_std_err  ]  = PSTH_calc( bursts , length( artefacts ) , BIN  , Post_stim_interval_end , N ) ;
    %       [psth_dx , psth , psth_norm , psth_std_err  ]  = PSTH_calc( bursts , length( artefacts ) ,BIN_small  , Post_stim_interval_end , N ) ;
    %         psth( 1 : floor( Post_stim_interval_start / BIN ))=0;
 
    %     bar( psth_dx , psth  )
    % %     barwitherr(psth_std_err , psth , psth_dx );
    %      title( ['Post-stim profile, ' int2str( Post_stim_interval_start) '-' int2str( Post_stim_interval_end) 'ms, Bin=' int2str( BIN_small )] )
    %      xlabel( 'Post-stimulus time, ms');
    %      ylabel( 'Spikes per bin');
    %     
        DT_bins_number=  fire_bins  ;
        Start_t =  Post_stim_interval_start ; 
        TimeBins = 0 : DT_bins_number-1 ; 
           TimeBins_x = Start_t + TimeBins * DT_step ;
       
               figure
               subplot( 2 , 1 , 1);
           handles  = barwitherr2(Patterns.TimeBin_Total_Spikes_std , TimeBins_x  , Patterns.TimeBin_Total_Spikes_mean  );
             axis( [ min( TimeBins_x )-DT_step max( TimeBins_x ) + DT_step  ...
                 0 1.2 * max(Patterns.TimeBin_Total_Spikes_mean) ...
                     + max(Patterns.TimeBin_Total_Spikes_std) ] )
    %          title( ['PSTH, bin=' int2str( BIN ) 'ms' ] )
         errorbar_tick(handles.h,240 )
         title( ['PSTH, ' int2str( Post_stim_interval_start) '-' int2str( Post_stim_interval_end) 'ms, Bin='  int2str( DT_step ) 'ms' ] )        
            xlabel( 'Post-stimulus time, ms')
 
 
                subplot( 2 , 1 , 2 );
%                 TimeBins = 0 : DT_bins_number-1 ; 
           handles  =  barwitherr2(Patterns.TimeBin_Total_Amps_std , TimeBins_x  , Patterns.TimeBin_Total_Amps_mean  );
             axis( [ min( TimeBins_x )-DT_step max( TimeBins_x ) + DT_step  ...
                 min(Patterns.TimeBin_Total_Amps_mean) ...
                     - 1.2* max(Patterns.TimeBin_Total_Amps_std) 0 ] )
    %          title( ['PSTH, bin=' int2str( BIN ) 'ms' ] )
         errorbar_tick(handles.h,240 )
         title( ['Amps, ' int2str( Post_stim_interval_start) '-' int2str( Post_stim_interval_end) 'ms, Bin='  int2str( DT_step ) 'ms' ] )        
            xlabel( 'Post-stimulus time, ms')         
     
 
%           [psth_dx , psth , psth_norm , psth_std_err  ]  = PSTH_calc( bursts , length( artefacts ) , BIN_small  , Post_stim_interval_end , N ) ;
%             psth( 1 : floor( Post_stim_interval_start / BIN_small ))=[];
%             psth_std_err( 1 : floor( Post_stim_interval_start / BIN_small ))=[];
%             psth_dx( 1 : floor( Post_stim_interval_start / BIN_small ))=[];
%            
%             subplot( 2 , 1 , 2);
%     %     bar( psth_dx , psth  )   
%          handles  = barwitherr2( psth_std_err , psth_dx , psth   );
%          axis( [ 0.3*min( psth_dx ) 1.2* max( psth_dx ) 0 1.1 * max( psth ) ...
%                 + max( psth_std_err ) ] )
%          title( ['PSTH, ' int2str( Post_stim_interval_start) '-' int2str( Post_stim_interval_end) 'ms, Bin='  int2str( BIN_small ) 'ms' ] )
%          xlabel( 'Post-stimulus time, ms');
%          ylabel( ['Spikes per ' num2str(BIN_small) ' ms bin' ] );
% 
%     errorbar_tick(handles.h,240 )
 
    
 end   
   
       cascade  
  end  
  
 
         
%     figure
% %     hist( all_index_after_art ,20 ) ;   
%     [n,xout] = hist( all_index_after_time , NNN ) ;
%     n(1: BBB ) = 0 ;
%     mean_spikes_per_bin_after_time = mean( n );
%     mean_spikes_per_bin_after_time
%     n2 = n / length( all_index_after_time ) ;
% %     n2 = n ;
% %     n2 = n / length( artefacts ) ;   
%         bar(xout , n2 )       
%                title( 'Spikes after stimulus + defined delay' )
% 
              
% figure
% subplot(2,1,1)
% plot(  artefacts / 1000 , Spike_Rates_each_burst  , '-*')
% title( 'Number of post-stimulus spikes')
% xlabel( 'Stimulus time, s')
% ylabel('Spikes #')
% subplot(2,1,2)
% hist( Spike_Rates_each_burst  , 10 );
% title( 'Spikes # histogram')
% ylabel( 'Counts, %')
% xlabel( 'Spikes #')
 
 
isDrawSpikeRateSignature  = checkbox5msBin  ;
 
% if isDrawSpikeRateSignature              
% [ Data_Rate_Signature1 , bb ] = DrawSpikeRateSignature(  length( artefacts   )   ,  bursts , Post_stim_interval_end , 10 );
% %  saveas( bb ,  'SpikeRateSignature.fig' ,'fig');
% % DrawSpikeRateSignature(  length( artefacts   )   ,  bursts_not_filtered , Post_stim_interval_end * 0.5 );
% end
      
 
% RS values for all electrodes-------------------------------------------
% [ RS_values  Spike_Rates Firing_Rates RS_current ] = Get_RS_Values(   N  , bursts , Post_stim_interval_start , Post_stim_interval_end - Post_stim_interval_start  , length( artefacts   ) , false ) ;    
% RS_values_total = RS_values;
%  RS_all_channels_all_responses = RS_current ;
 
 
 
 
 
 
%  subplot(3,1,1)
%  bar( RS_values_mean,'hist' )
% %  xlabel('Electrode')
%   ylabel('RS value')
%   xlabel('Electrode')
%  title( ['Response to stimulus in interval(RS) ' int2str(Post_stim_interval_start) '-' int2str(Post_stim_interval_end) ' ms' ])
% 
% 
%   subplot(3,1,2) 
%    bar( RS_values_std,'hist' )
%  xlabel('Electrode')
%   ylabel('std( RS )')
 
 
 if SHOW_RS_figure
         RS_values_mean= zeros( 1 , N  );
          RS_values_std= zeros( 1 , N  );
         for ch = 1 : N 
        RS_values_mean(ch) = mean( RS_current( :,ch));
        RS_values_std(ch) = std( RS_current( :,ch));
         end
 
         LowRS_electrodes_01 = find(   RS_values_mean  <= 0.1 & RS_values_mean  > 0 );
         LowRS_electrodes_01
         LowRS_electrodes_lower_1 = find(   RS_values_mean  <= 1 & RS_values_mean  > 0 );
         LowRS_electrodes_lower_1
 
         name
 
     figure
          ch = 1 : N  ;
           subplot(2,1,1)
               barwitherr( RS_values_std , ch, RS_values_mean  );
                           axis( [ min(ch) max(ch) 0 1.2 * max(RS_values_mean) ...
                             + max(RS_values_std) ] )
 
 
          subplot(2,1,2)  
        %   if  max(RS_values_total)  > Number_of_BINs_SpikeRate_Hist * 2
              HStep =   max(RS_values_total) / Number_of_BINs_SpikeRate_Hist ;
        %   else
        %       HStep = 1 ;
        %   end
        xxx =  0 : HStep: max(RS_values_total) ;
        [h,p] = hist(RS_values_total ,xxx) ;
         bar(p,h)
           xlabel('RS value')
           ylabel('Count, %')
         title( 'RS on electrodes histogram' )
 end
%  RS_values_sort = sort( RS_values_mean,'descend');
 
 
%   bar( RS_values_sort,'hist' )
%   xlabel('Electrode')
%   ylabel('RS value')
%  title( ['RS in interval ' int2str(Post_stim_interval_start) '-' int2str(Post_stim_interval_end) ' ms (Sorted)' ])
%    x=0:1:20 ;
 
 
 
 
 
% COLOR PLOT, post stim spikes all channels all artefacts, RS -"--"--  --------------------------------------------  
%     imax = floor( artefacts(end) / 1000 );
%     mmm = zeros( imax , N );
%     mmm(:,:)=NaN;
%  for CHANNEL_i = 1 : N
%      for i=1:  length( artefacts   ) 
%         mmm( floor( 1+ (artefacts( i )  / 1000) ) , CHANNEL_i )= ...
%             Spike_Rates( i , CHANNEL_i ) ;
%      end
%  end
%      mmm = mmm';
%     figure
% %      subplot(1,2,1)
%       x = 1:length( artefacts   ) ;
%       y = 1:N ;
% %        imagesc(  x  , y ,  num_poststim_spikes_on_electrode_i'  )
%         bb = imagesc(  x , y ,  Spike_Rates'   ) ;
% %         set( bb ,'alphadata',~isnan(mmm))
%         title( 'Post-stimulus spikes #' )
%         xlabel('Stimulus nummber')
%         ylabel('Electrode #')
%     colorbar
   
   
% imax = floor( artefacts(end) / 1000 );
%     mmm = zeros( imax , N );
%     mmm(:,:)=NaN;
%  for CHANNEL_i = 1 : N
%      for i=1:  length( artefacts   ) 
%         mmm( floor( 1+ (artefacts( i )  / 1000) ) , CHANNEL_i )= ...
%             RS_current( i , CHANNEL_i ) ;
%      end
%  end
%      mmm = mmm';
% %     figure
%      subplot(1,2,2)
%       x = 1:length( artefacts   ) ; y = 1:N ;
% %        imagesc(  x  , y ,  num_poststim_spikes_on_electrode_i'  )
%         bb = imagesc(  x   , y ,  RS_current'   ) ;
% %         set( bb ,'alphadata',~isnan(mmm))
%         title( 'RS values' )
%          xlabel('Stimulus nummber')
%          ylabel('Electrode #')
%     colorbar
   
 %------------------------------------------------------

 %% Global  cycle end 
 
 if Search_Params.Chambers_Separate_analysis_AB
   
     switch (Raster_number_stim)
                   
       case 1   % A
           if params.detect_spont_bursts
            ANALYZED_DATA.bursts_absolute = [] ;
            ANALYZED_DATA.bursts = [] ;
            ANALYZED_DATA.bursts_amps = [] ;  
             ANALYZED_DATA_A = ANALYZED_DATA ;
             whos ANALYZED_DATA_A
            end
            
            
    
         
             POST_STIM_RESPONSE_A = POST_STIM_RESPONSE ;
             
           if Search_Params.Chambers_Separate_analysis_AB  
            Chambers_A.artefacts_evoked_number = Patterns.Number_of_Patterns ;
           
            if Shuffle_test 
             Chambers_A = ChamberAB_shuffle_result ;
             Chambers_A.artefacts_evoked_number = ChamberAB_shuffle_result.Chambers_A_B_evoked_burst_number ;
             Chambers_A.artefacts_evoked_percent = ChamberAB_shuffle_result.Chambers_A_B_evoked_percent ;
             Chambers_A.artefacts_evoked_index = [] ;
             if ChamberAB_shuffle_result.Chambers_A_B_connection_exist
             Chambers_A.artefacts_evoked_index = ChamberAB_shuffle_result.Chambers_A_B_evoked_burst_index( : , 1 ) ; 
             end
             
             Chambers_A.Timebin_srprofile = Patterns.TimeBin_Total_Spikes_mean ;
              timebins= 1 :  Patterns.DT_bins_number ;
                timebins = (timebins-1) * Patterns.DT_bin ;
             Chambers_A.Timebin_x = timebins;
            end
           end
            
 
         case 2 % B
             
             if params.detect_spont_bursts
            ANALYZED_DATA.bursts_absolute = [] ;
            ANALYZED_DATA.bursts = [] ;
            ANALYZED_DATA.bursts_amps = [] ;  
            ANALYZED_DATA_B = ANALYZED_DATA ;
             end
            
           POST_STIM_RESPONSE_B = POST_STIM_RESPONSE ;
           
           if Search_Params.Chambers_Separate_analysis_AB
            Chambers_B.artefacts_evoked_number = Patterns.Number_of_Patterns ;
             
            if Shuffle_test 
                 Chambers_B = ChamberAB_shuffle_result ;
                 Chambers_B.artefacts_evoked_number = ChamberAB_shuffle_result.Chambers_A_B_evoked_burst_number ;
                 Chambers_B.artefacts_evoked_percent = ChamberAB_shuffle_result.Chambers_A_B_evoked_percent ;
                 Chambers_B.artefacts_evoked_index = [] ;
                 if ChamberAB_shuffle_result.Chambers_A_B_connection_exist
                 Chambers_B.artefacts_evoked_index = ChamberAB_shuffle_result.Chambers_A_B_evoked_burst_index( : , 1 ) ; 
                 end
                 
                 Chambers_B.Timebin_srprofile = Patterns.TimeBin_Total_Spikes_mean ; 
               timebins= 1 :  Patterns.DT_bins_number ;
                timebins = (timebins-1) * Patterns.DT_bin ;
             Chambers_B.Timebin_x = timebins ;
            end
           end
            
              
         case 3 % chan   
             if params.detect_spont_bursts
           ANALYZED_DATA.bursts_absolute = [] ;
            ANALYZED_DATA.bursts = [] ;
            ANALYZED_DATA.bursts_amps = [] ;  
            ANALYZED_DATA_Chan = ANALYZED_DATA ; 
             end
             
            if Search_Params.Chambers_Separate_analysis_AB
            POST_STIM_RESPONSE_chan = POST_STIM_RESPONSE ;
             
            
%             Patterns_original_raw.bursts_absolute = [] ;
%             Patterns_original_raw.bursts = [] ;
%             Patterns_original_raw.bursts_amps = [] ;
%             POST_STIM_RESPONSE_all_stim = Patterns_original_raw ;

         
             Chambers_cham.Timebin_srprofile = Patterns.TimeBin_Total_Spikes_mean ; 
               timebins= 1 :  Patterns.DT_bins_number ;
                timebins = (timebins-1) * Patterns.DT_bin ;
             Chambers_cham.Timebin_x = timebins ;
             
             
             Stim_response_Chambers_A_B_analyze_and_add
             
             

        if Shuffle_test 
            
            
            
            Stim_response_ChambersAS_plot_results
            
                        % Stimuli evoked bursts :
%                 ChambersStim_A.artefacts_evoked_index  
%             % Number of stimuli evoked bursts
%                 ChambersStim_A.artefacts_evoked_percent  
%             % Number of stimuli evoked bursts
%                 ChambersStim_A.artefacts_evoked_number  
%             % Did stimuli evoked bursts
%                 ChambersStim_A.artefacts_evoked_bursts  
            
        end
      end 
             
     end
  
end
 
end

 %% SAVING FILES ---------------------------------  


 
%% Save to mat file in cur directory -------------


           Parameters.Experiment_name = Experiment_name ;
           if exist( 'Original_filename')
            Parameters.Original_filename = Original_filename ;
            [pathstr,name,ext] = fileparts( Original_filename ) ; 
            Parameters.Original_path  = pathstr ;
           end
           Parameters.Burst_Data_Ver = Burst_Data_Ver ; 
           Parameters.N_channels = N ;
            DateTime_created.Analysis_TimeAndDateAsVector = clock ;
            DateTime_created.Analysis_DateAsString = date ;
           Parameters.DateTime_created = DateTime_created ;
           Parameters.Search_Params = Search_Params ;
           Parameters.Global_flags = Global_flags ;
                      
           
      Postfix='';
  if  Global_flags.Stim_response_Elsel_extract_channel 
     
     Postfix = [ '_ElSel_channel_' num2str( electrode_sel_param.stim_chan_to_extract ) ];
  end
  
     [pathstr,name,ext] = fileparts( filename ) ;
finame = [ '_' name '_Post_' int2str(Post_stim_interval_start) '-' int2str(Post_stim_interval_end) 'ms_Stimlus_responses' Postfix '.mat' ] ;
 
eval(['save ' char( finame ) ' POST_STIM_RESPONSE Parameters -mat']);
 %-----------------------------------
 
     
 %% --- Save to DB ---------------
  if Params.Save_not_filtered_responses
     
     POST_STIM_RESPONSE_buf = POST_STIM_RESPONSE ;
        Patterns = Patterns_original_raw ;  

             %----------Patterns_get_Statistsic_all_parameters     
            % Patterns.TimeBin_Total_Spikes  ... -> TimeBin_Total_Spikes_mean
            Patterns_get_Statistsic_all_parameters
    
     POST_STIM_RESPONSE = Patterns ;
     eval(['save ' char( finame ) ' POST_STIM_RESPONSE Parameters -mat']);
 end
 
if MED_file_raster_input  
    filename
    eval(['save ' char( filename )...
        ' POST_STIM_RESPONSE  -mat -append ']);    
    Sigma_threshold =   RASTER_data.Sigma_threshold ;
    Experiment_name = RASTER_data.Experiment_name ;
else
    Sigma_threshold = 0 ;
end
Experiment_name = name ;
    %--------------- database write   
    if Global_flags.autosave_to_DB
    [index_r_from_DB , Raster_exists ,Raster_exists_with_other_sigma , Sigma_threshold_exists , RASTER_data , Result_MAT_path_file_DB] = ...
           Load_raster_from_RASTER_DB( Experiment_name ,  Sigma_threshold );
     if Raster_exists         
        Add_PostStim_response_data_RASTER_DB( Experiment_name ,  Sigma_threshold , POST_STIM_RESPONSE )
     else
         RASTER_data.Raster_Flags = zeros( 40 , 1 ) ; 
         RASTER_data.Raster_Flags( RASTER_FLAG_Artefacts_included ) = 1 ;
         RASTER_data.artefacts = artefacts ;
         if  MED_file_raster_input            
           RASTER_data.Raster_Flags( RASTER_FLAG_all_data_included ) = 1 ; 
           [Raster_exists ,Raster_exists_with_other_sigma ] = Add_new_Raster_RASTER_DB( Experiment_name , ...
                RASTER_data.Sigma_threshold , RASTER_data);
           Add_PostStim_response_data_RASTER_DB( Experiment_name , RASTER_data.Sigma_threshold , POST_STIM_RESPONSE );
         else
            RASTER_data.index_r = index_r;
                  % c == 0 - empty RASTER_DATA
                  % c == 1 - all data fine
                  % c == 2 - only index_r
                  % c == 3 - artifacts also
                  RASTER_data.Raster_Flags( RASTER_FLAG_all_data_included ) = 2 ;
                  RASTER_data.Raster_file = [ name ext ];
                    
            [Raster_exists ,Raster_exists_with_other_sigma ] = Add_new_Raster_RASTER_DB( Experiment_name , ...
                  0 , RASTER_data);  
             
            Add_PostStim_response_data_RASTER_DB( Experiment_name , 0 , POST_STIM_RESPONSE );             
         end
     end
    end
     
%      if Result_MAT_path_file_DB ~= 0
%          [DBpathstr,DBname,DBext] = fileparts( Result_MAT_path_file_DB ) ;  
%          copyfile(Result_MAT_path_file_DB , [ DBname '.mat' ] );
%      end
 
 
fullname = [pathname  finame];
fullname
FILENAME
%--------------------------
 
 if Params.Save_not_filtered_responses
          POST_STIM_RESPONSE =POST_STIM_RESPONSE_buf; 
 end
  
end 
end
   
cd( init_dir ) ;
end
