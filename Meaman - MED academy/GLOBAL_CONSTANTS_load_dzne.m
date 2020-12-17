 
% GLOBAL_CONSTANTS_load

% INIT_COMPARE_VARS
 
%% ------- Burst analysis parameters ------------------------------------
Search_Params.Burst_delete_spikes_burst_tail =  0 ; %if 50 - when found bursts, leave spikes at first 50 ms of burst duration
SHOW_ISI_HIST = false ;
MIN_channels_per_burst = 3 ; % if =4 - burst considered as burst when TSR above threshold 
                             % and at least 4 channels has at least 1 spike during the burst
Search_Params.Simple_analysis = true ; % false - adjust burst start time to first spike timing in the burst                             
                             
Number_of_BIN_in_Hist = 15 ;
% MAX_SPIKES_PER_CHANNEL_AT_BURST = 500 ; % no effect
Global_flags.min_spikes_per_channel  = 4 ; % if channel has small number spikes per burst then exclude it from activation pattern
Global_flags.SpikeRate_profile_1ms_max_duration  = 300 ; % make 1 ms TSR profile of all bursts with duration defined
APPEND_DATA__TO_ORIGINAL_MAT_FILE = true ; % append analysed data to original mat file with raster
DT_step = 5 ; % time bin interval for signature color plot
Save_Burst_analysis_figures = true ;
Global_flags.Calc_Spikerate_profile_1ms_bin = false ; % finds spikerate profile 1ms bin
    Global_flags.Search_Params.Calc_Spikerate_profile_1ms_interp = true ; % Tact smooth will be from interpolated profile
    Global_flags.Search_Params.Calc_Spikerate_profile_1ms_interp_factor = 10 ;  % if 10 - SpikeRate profile -> interp1 0.1 ms 
    Global_flags.Search_Params.Burst_activation_based_smooth_find_all_bursts = false ;  
            % burst_activation_2 = each spikera each burst -> mean Tact_2     
            % else burst_activation_2 = from mean 1ms profile, same as
            % burst_activation_3_smooth_1ms_mean
    Global_flags.Search_Params.T_activation_stat_threshold_param = 2 ; % threshold for activation time calculation, 2 = 20% of max smooth activity     
        Global_flags.Search_Params.Plot_Tact3_diff_levels = false ; 
        
    Global_flags.Search_Params.Spike_Rate_Signature_1ms_smooth = 10 ; % 40 ms smooth for burst profile on each channels
    Global_flags.Search_Params.Spike_Rate_Signature_1ms_max_duration = 300 ; % max duration for 1ms profiles to find smooth Tact    
    Global_flags.Search_Params.Spike_Rate_Signature_max_duration_auto  = false ;
        Global_flags.Search_Params.Spike_Rate_Signature_max_duration = 400 ; % max duration for 1ms profiles to find smooth Tact    
 
    Global_flags.Save_Patterns_1ms_to_file = false ; % if true then save Spike_Rate_Patterns_1ms and Amp_Patterns_1ms to file    
    
    
GLOBAL_const.med64_fix_32channels_delay = 0 ; %if 100 then if data=med64, take 1-32 channel spikes and minus 100 ms    
    
Burst_Data_Ver = 4.7 ; % 1 - save bursts to matrix (large file), 2 - bursts in cell array - compact file
Burst_analysis_Version = 4.7  ; %% 3 - from 10.11.13 
% have effect only if Filter_small_Superbursts == true 
Search_Params.Filter_small_bursts_TYPE = 'Spike_Rates_each_burst' ; % can be 'BurstDurations' or 'Spike_Rates_each_burst'  
Search_Params.Filter_big_bursts =  true  ; %  false - leave big bursts  
Search_Params.Small_bursts_filter_Davies_Bouldin_index_Threshold = 0.65 ; % if its higher ...
            % ... threshold than all bursts cannnot be separated into 2 clusters 
Search_Params.Active_channel_Spike_rate_each_burst_Thr = 1 ; % if some channel has < 1 spikes in average in burst the it will be inactive            
make_Burst_ANALYSIS_RESULTS_file = false;             


GLOBAL_const.Cluster_bursts = false ; % if true - erase allspikes between bursts and merge bursts tightly


Global_flags.Search_Params.Chambers_Separate_analysis_AB = false ;
    Global_flags.Search_Params.Chambers_Burst_duration_AB = 400 ; % duration of new AB burst
    Global_flags.Search_Params.Chamber_A_electrodes =  [1:15 45:60]    ;
    Global_flags.Search_Params.Chamber_B_electrodes =  [ 30  : 45 ] ;
    Global_flags.Search_Params.Chamber_AB_min_delay = 50 ;
     
Global_flags.Show_additional_profiles = false ;
%----------------------------------------------------------------------

%% Spike detection parameteres

handles.par.threshold_use_defined = true ; % use defined spike detection threshold
    handles.par.threshold_one_sigma = 20 / 1000 ; % [mcV] set sigma to 1 and the threshold will be as defined here
handles.par.simple_detection = true ; % if true - find just negative peaks

handles.par.post_stimulus_erase = 1 ; %erase all spike after X ms of stimulus
handles.par.w_pre= 15 ;     %number of pre-spike data points (1 point = 50 mks)
handles.par.w_post= 15  ;   %number of post-spike data points         

handles.par.stdmax = 50 ;         %maximum threshold
handles.par.sr = 20000;                     %sampling frequency, in Hz.
handles.par.detection = 'neg';              %type of threshold
handles.par.thresholdtype = 'md' ; 
min_ref_per=  1 ; %0.8 ; % minimum interspike interval (in ms) = 16 samples at 20 KHz
handles.par.ARTEFACT_threshold = 0.3 ;

handles.par.recalc_threshold_each_block = true ; % if true - for each splitted block calc new thr
 
handles.par.Data_split_max_recording_duration_sec = 6000  ; % if recording length more than this duration, then detect spikes for each channel by splitting it
handles.par.Data_split_Number_of_blocks_channel_split = 14 ; % if record (med64) is too long, then split each channel into blocks
 
%min_ref_per= 0.4 ;
MAX_MEMORY_MB = 16000  ;          % Memory limit for .dat .med load
First_channel_is_0 = 'n' ; % 'y' - number of first channel will be 0, 'n' - will be 1
Save_time_offset = 'n' ;   % add to spike time offset time as in .med file
Raster_file_ext = 'txt' ;  % extension for raster file - 'dat' or 'txt' or any else
Raster_in_ms =  'y' ;            % 'y' - raster time in ms, 'n' - in frames
PLAY_CHANNEL_SOUND = 'n'  ;  % activity of channel as sound wave - play sound 
AWSR_MAKE_AND_SAVE_TO_BMP = 'n'  ;
Raster_with_amp = 'y' ;
 
var.read_one_split_block = false ;

Compressin = 1 ;            % raster compression, if Compressin = 10  then compress 1:10
SIMPLE_RASTER = 'y' ; % 'n' - save spike shapes to separate folder 
handles.par.interpolation = 'y';            %interpolation for alignment
handles.par.int_factor = 2;                 %interpolation factor

low_freq = 550 ;  %  300
hi_freq = 8192  ;  % 8196 3000 

% ENG parameters
% handles.par.sr = 5000 ;
% low_freq = 10 ; %550 ;  %  300 %
% hi_freq = 2300  ;  % 3000 

handles.par.detect_fmin =  low_freq  ;  
%300 - spikes ;  50 - bursts high pass filter for detection
handles.par.detect_fmax =  hi_freq ;             
%3000 - spikes ; 90 - bursts low pass filter for detection
handles.par.sort_fmin =  low_freq  ;                
%300 - spikes ; 50 - bursts high pass filter for sorting
handles.par.sort_fmax =  hi_freq  ;               
%3000 - spikes ; 90 - bursts low pass filter for sorting
handles.par.segments = 1;                   %nr. of segments in which the data is cutted.
 
handles.par.ref = floor(min_ref_per ...
    *handles.par.sr/1000);                  %number of counts corresponding to the dead time

handles.par.save_original = 'n' ;
handles.par.save_filtered = 'n' ;
handles.par.Original_channel_save = 0 ;
handles.par.Filtered_channel_save = 0 ;

%% --- porst-stim response --------------
Global_flags.Cluster_responses = false ;
    Global_flags.Filter_small_responses = true ;
Global_flags.Erase_Inadequate_Patterns  = false ;
Global_flags.Erase_Inadequate_Patterns_preStim  = false ; % analyses 100 ms pre-stim interval is spont burst was before stim
Global_flags.Recalc_PostStim_Interval_responses_for_Classification = false ;
    
GLOBAL_const.Post_stim_Calc_Spikerate_profile_1ms_bin = true ;
GLOBAL_const.Post_stim_activation_based_smooth_find_all_bursts = false ;  % same as Burst_activation_based_smooth_find_all_bursts

GLOBAL_const.leave_or_erase_artifacts = false ; % after load artifact erase or leave only some
    GLOBAL_const.erase_artifacts = false ;
    GLOBAL_const.leave_or_erase_every_artifact_period = 60  ; % if 6 - then erase 6 ,12 ... artifact (or leave)

    %- used in Patterns_get_High_Low_responses -----
    GLOBAL_const.Recalc_PostStim_Interval_responses_for_Classification = true ;     
    GLOBAL_const.Start_Classify = 10 ;
    GLOBAL_const.End_classify = 250 ; 
    GLOBAL_const.DT_classify = 10 ;   
    
Global_flags.Stim_Calc_Spikerate_profile_1ms_bin = true ; % finds spikerate profile 1ms bin
    Global_flags.Stim_Search_Params.Calc_Spikerate_profile_1ms_interp = false ; % Tact smooth will be from interpolated profile
    Global_flags.Stim_Search_Params.Calc_Spikerate_profile_1ms_interp_factor = 10 ;  % if 10 - SpikeRate profile -> interp1 0.1 ms
    
    Global_flags.Stim_Search_Params.Burst_activation_based_smooth_find_all_bursts = false ;  
            % burst_activation_2 = each spikera each burst -> mean Tact_2     
            % else burst_activation_2 = from mean 1ms profile, same as
            % burst_activation_3_smooth_1ms_mean
    Global_flags.Stim_Search_Params.T_activation_stat_threshold_param = 2 ; % threshold for activation time calculation, 2 = 20% of max smooth activity     
        Global_flags.Stim_Search_Params.Plot_Tact3_diff_levels = false ;
    
    Global_flags.Stim_Search_Params.Spike_Rate_Signature_1ms_smooth = 20 ; % 40 ms smooth for burst profile on each channels
    Global_flags.Stim_Search_Params.Spike_Rate_Signature_1ms_max_duration = 300 ; % max duration for 1ms profiles to find smooth Tact    
    Global_flags.Stim_Search_Params.Spike_Rate_Signature_max_duration = 300 ; % max duration for 1ms profiles to find smooth Tact    

    
    
GLOBAL_const.Find_artifacts_from_raster = false ;    
GLOBAL_const.Artifact_threshold_from_max = 25 ; % if 70 - then erase find max awsr of raster and 70% of it will be threshold for artifact detect    

% parameters for low-high responses classification recalc
Global_flags.Global_Poststim_interval_START = 10  ;
Global_flags.Global_Poststim_interval_END = 250 ;
Global_flags.Global_DT_bin = 10 ;

% parameters for low-high responses classification
% Global_flags.Recalc_PostStim_Interval_responses_for_Classification = true ;      
Global_flags.Start_Classify = 10 ;
Global_flags.End_classify = 250; 
Global_flags.DT_classify = 10 ;  

% "Stim response" button parameters
    Global_flags.Stim_response_Elsel_extract_channel = false ; 
    electrode_sel_param.type = 'List' ;
    % Cycle
         electrode_sel_param.stim_chan_to_extract = 2 ;
         electrode_sel_param.Start_channel = 2; % electrode selection started from
         electrode_sel_param.Stimuli_to_each_channel = 30 ; % stimuli to each channel
         electrode_sel_param.Channel_step = 4 ;
         electrode_sel_param.correct_protocol = false ;
    % List
        electrode_sel_param.Stimuli_to_each_channel = 60 ; % stimuli to each channel
        electrode_sel_param.Stimulation_channels = [ 1 2 9 22 32 39 52  ] ; % list of stim channels = [ 1 3 43 2 .. ]
        electrode_sel_param.Stimulation_channels_num  = length( electrode_sel_param.Stimulation_channels ) ;
        electrode_sel_param.Selected_Stimulation_channel = 6 ; % number in sequence ;
        
        Global_flags.Stim_response_Elsel_extract_all_and_show = false ;

%% --- Plotting consts ------------
% after bursts analysis found plot it
GM_Bursts_example_raster_duration = 0.5 ; % take first X ms of raster and plot
GLOBAL_const.Plot8x8Data_cubic_interp = false ; % cubic interpolation of 8x8 color data matrix
GLOBAL_const.Raster_plot_only_AWSR_raster = true ;
%--------------------------------

%% --- Connectivity -------------------------
GLOBAL_const.Connectiv_Analysis_ver = 4.3 ; % 3 - spikerate threshold - total spike rates, 4+ - firing rates threshold 
GLOBAL_const.Connects_min_M_strength = 0.02 ; % compare connection with strength > set here
GLOBAL_const.Connectiv_min_spikes_per_channel = 10 ; % Connectiv_Analysis_ver=3 -> 500 spikes per channel, or if
                % Connectiv_Analysis_ver =4 -> 0.01 = 1 spike per 100 ms or
                % 10 - spikes per bursts threshold
GLOBAL_const.Connects_min_tau_diff = 1  ; %  if delay of connection less than this, then this is not connection 
                % used in Connectiv_matrix_statistics_figures
GLOBAL_const.Connectiv_smooth_spike_transfer_characteristic = 15 ; 
                
                
%-- Optimal stable connections parameters intervals
    min_tau_0 = 3 ; min_tau_max = 6 ; min_tau_step = 1 ;
    min_M_thr = 0.05 ; min_M_thr_max = 0.2 ; min_M_thr_step = 0.05 ;
    min_SpBur_0 = 15 ; min_SpBur_max = 30 ; min_SpBur_step = 5 ;           
                
Show_HUBS_number_figures = 1 ;
   %- Connectiv from DB -----
Connectiv_figure_from_DB_Show_burst_profile = false; 
GLOBAL_const.Connectiv_Analyze_connection_burst_profiles = true ;
%-----------------------------------------------
    
%% --- time when read this paramters ----------------
           DateTime_created.Analysis_TimeAndDateAsVector = clock ;
           DateTime_created.Analysis_DateAsString = date ;           
           GLOBAL_const.DateTime_used = DateTime_created ;
%-----------------------------------------------------------------------

 %% --- Superbursts detection parameters 
    Search_Params.Superburst_threshold_coeff = 0.3 ; % X * sigma coefficient for SB detection 
    Search_Params.SB_min_duration = 100 ;  

 %% ----- Patterns analysis: stimulus response classification ------------                
    %-- for Patterns_Check_if_responses_Adequate
    % define interval where spikes # should be more than in the rest PSTH
    % interval
     Start_Significant_spikes_interval  = 10 ;
     End_Significant_spikes_interval  = 150 ; % -- main PSTH hill should be before this time
     Ksecond_part=1.2 ; 
    %   if mean( FirstPart_spikes_from_all_resp ) < Ksecond_part * mean(SecondPart_spikes_from_all_resp)  
    %                              All_responses_Bad = true ;
   
    % for Patterns_Check_if_responses_Adequate
    % d(PSTH)/ max(PSTH)  should be more than this value [%]
    GLOBAL_const.PSTH_relative_Amplitude_threshold = 20 ;
    %  the code for using this const :  PSTH_rel_Amp = max( TimeBin_Total_Spikes_mean_in_each_bin ) / median(TimeBin_Total_Spikes_mean_in_each_bin_non_zers);
                %                          if PSTH_rel_Amp < PSTH_relative_Amplitude_threshold 
                                 %             All_responses_Bad
    GLOBAL_const.pause_on_cluster_figs  = false ;  % Patterns_Check_if_responses_Adequate                                    
    GLOB.pause_on_tet_channel_analysis = false ;     
%     MINIMUM_PATTERNS_PER_RECORD = 10 ;
    %   if exist( 'GLOB' )                          
    %      if isfield( GLOB , 'pause_on_cluster_figs' )
    %         pause                                
    %      end   
    %   end                             
%-----------------------------------------------------------------------   

%% ---- DB -------------------
DB_dir_name = 'DB_meadata';      
MATLAB_folder = userpath; if ~isempty(MATLAB_folder)  MATLAB_folder(end)=[] ; end;
 %-- Folder with DB mat files for recursive analysis
ANALYSIS_ARG.Path_with_DB_matfiles  = [ MATLAB_folder  '\' DB_dir_name ];
ANALYSIS_ARG.DB_dir  = [ MATLAB_folder  '\' DB_dir_name ];
% ANALYSIS_ARG.Path_with_DB_matfiles = []; 
% ANALYSIS_ARG.Path_with_DB_matfiles = 'S:\MATLAB_DB\DB_meadata_Vuglu_1dec_2013\IN_PROCESS\megatet' ;
% ANALYSIS_ARG.DB_dir  = [ 'S:\MATLAB_DB\' DB_dir_name ];

%--------------------------------------------------
%% -- Patterns classification - High + Low bursts

Global_flags.High_responses_Threshold = 100 ; %-- If some responses exceed this threshold 
                            % then there is some such responses then we
                            % have High reponses 
Global_flags.autosave_to_DB = false ;  % false


