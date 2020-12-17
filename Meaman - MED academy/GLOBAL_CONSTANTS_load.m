 
% GLOBAL_CONSTANTS_load
 
% INIT_COMPARE_VARS
%% Spike detection parameteres
MED_edition = true ; 
% MED_edition = false; 

handles.par.MED_Convert_file_Channels_num = 60 ;


handles.par.threshold_use_defined = false ; % use defined spike detection threshold
handles.par.threshold_one_sigma = 20 / 1000 ; % [mcV] set sigma to 1 and the threshold will be as defined here
handles.par.simple_detection = false ; % if true - find just negative peaks


handles.par.collect_sigma_from = 0 ; % For spike detection estimate sigma in interval 
 handles.par.collect_sigma_to  = 6;

handles.par.threshold_fromFit_method = true ; 
    handles.par.threshold_fromFit_signal_hist_x = -0.09:0.0002:0.09 ; 
    handles.par.threshold_fromFit_fitting_bounds_sample = 0.008 ;% if 0.004 then gauss will be estimated from -0.004 to 0.004
    handles.par.threshold_fromFit_fitting_bounds_Gaussfit = 0.09 ;% if 0.05 then Gauss model fit will be built -0.05 to 0.05
    handles.par.threshold_fromFit_percentile_GaussFit = 0.001 ; % if 0.001 then 0.1 % of fitted gauss hist will be used as thresh (similar to Gauss width)
    handles.par.threshold_fromFit_show_hists = false ; % shows estimations
    
    
%     handles.par.threshold_fromFit_signal_hist_x = -0.03:0.0002:0.03 ; 
%     handles.par.threshold_fromFit_fitting_bounds_sample = 0.004 ;% if 0.004 then gauss will be estimated from -0.004 to 0.004
%     handles.par.threshold_fromFit_fitting_bounds_Gaussfit = 0.03 ;% if 0.05 then Gauss model fit will be built -0.05 to 0.05
%     handles.par.threshold_fromFit_percentile_GaussFit = 0.001 ; % if 0.001 then 0.1 % of fitted gauss hist will be used as thresh (similar to Gauss width)
%     handles.par.threshold_fromFit_show_hists = true ; % shows estimations

 CHANNEL_MEA_LETTER = 'A' ; % 'A' or 'B' MEA - only for Analyze raw channel
 handles.par.analyze_A_mea =  true ; % fro Detect spikes
 handles.par.analyze_B_mea = false ; % fro Detect spikes

 
handles.par.post_stimulus_erase = 1 ; %erase all spike after X ms of stimulus
handles.par.w_pre= 15 ;     %number of pre-spike data points (1 point = 50 mks)
handles.par.w_post= 15  ;   %number of post-spike data points        
 
handles.par.stdmax = 50 ;         %maximum threshold
handles.par.sr = 20000;                     %sampling frequency, in Hz.
handles.par.detection = 'neg';   %type of spikes to find 'neg' - negative, 'pos' - positive, 'both' - all spikes
handles.par.thresholdtype = 'gf' ;
min_ref_per=  0.6 ; %0.8 ; % minimum interspike interval (in ms) = 16 samples at 20 KHz
handles.par.ARTEFACT_threshold =  -0.051 ; % threshold of signal derrivative [ V ]
% handles.par.ARTEFACT_threshold = 1.2489 ; % 0.0189 ; threshold of signal derrivative [ V ]

handles.par.ARTEFACT_threshold =  -0.0031 ; % threshold of signal derrivative [ V ]

 handles.par.ARTEFACT_threshold_Polarity_autosearch = true ; 

% ARTEFACT_thr_search
 
handles.par.Art_auto_search_global = true ;
     handles.par.Art_auto_search_thres_AMP = 2 ;

 handles.par.ARTEFACT_threshold_A0 = -0.5 ; % interval for auto thr search [ A0 : A1 ], [V in dV/dt]
 handles.par.ARTEFACT_threshold_A1 = 0.5 ; % interval for auto thr search [  A0 : A1 ], [V in dV/dt]
 handles.par.ARTEFACT_minimum_median_thr = 0.005 ; % 0.013 - minimum absolute ...
%             signal threshold for automatic search  [V in dV/dt]
% handles.par.ARTEFACT_threshold = -0.04 ; % threshold of signal derrivative [V in dV/dt]
handles.par.ARTEFACT_threshold_sigma_min =  6 ; % sigma threshold for dV/dt
handles.par.ARTEFACT_deviation_sec = 0.505 ; 
handles.par.Max_interArtifact_interval_sec = 20 ;
handles.par.Art_num_all_minimum = 10 ;
handles.par.Art_auto_search_if_no_ISI = true ;

handles.par.Art_freq_Interval_sec_Minimum = 0 ;


handles.par.ARTEFACT_maximum_arts_per_channel = 2000 ;
handles.par.Good_interArtifact_interval_sec = 0  ; % from GUI
handles.par.Stim_chan_prefix_str = '_z'  ; % '_z' == ..stim_z52... ;  '15_2018_06_04_h1h5_d13_stim_z52_z67_minus800_p30' 
% handles.par.Stim_chan_prefix_str = '_el'  ; % '_el' == 02_2018_06_12_h5_el43_h6s_el35_d37_minus800_p30_3sek_Details
handles.par.Stim_ISI_prefix_str = '_isi' ;

    handles.par.ARTEFACT_thr_search_max_artefacts = 600 ; 
    handles.par.ARTEFACT_thr_search_expected = 1 ;  % % Expected ISI (sec)
    handles.par.ARTEFACT_split_into_files = false ; 
        handles.par.ARTEFACT_split_into_files_art_num = 30 ; 

handles.par.ARTEFACT_search_around_selected_elec = false ; % scans 3x3 electrodes around selected one
    handles.par.ARTEFACT_search_around_always_test_all_channels = false ;
         handles.par.ARTEFACT_search_around_radius = 1 ; % if 1 then scans 3x3 electrodes around selected one
    

    
handles.par.Find_one_correct_artefact = false ;
    handles.par.Find_artefact_rem_module = 20 ;

    
 
 
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
 

low_freq =  550  ;  %  300

hi_freq = 0  ;  % 8196 3000

handles.par.Filter_50Hz_of_signal = true ;
handles.par.sig_50Hz_iirnotch = 0.5 ;
 
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
handles.par.save_filtered = 'y' ;
handles.par.Original_channel_save = false ;
handles.par.Filtered_channel_save = false  ;
handles.par.Details_Options1chan_signal_hist = false  ;
     handles.par.Details_Options1chan_signal_hist_x = -0.05:0.0005:0.05 ; % mV
handles.par.Details_Options1chan_include_amps = false  ;
    handles.par.Details_Options1chan_include_amps_show_hist = false ;
    handles.par.Details_Options1chan_amps_hist_x = -0.01 : 0.0002 :0  ; % mV
    
handles.par.detect_Show_any_figures = true ; % used in amp_detect3_artefacts.m

% Save filtered signals to mat file:
handles.par.save_filtered_signals_to_mat_file = false ;    
 

%% ------- Burst analysis parameters ------------------------------------
Burst_Data_Ver = 4.92 ; % 1 - save bursts to matrix (large file), 2 - bursts in cell array - compact file
Burst_Data_Ver_original_file_reanalyze = 4.92 ;

N_origin = 60 ;
Global_flags.Search_Params.Burst_delete_spikes_burst_tail =  0 ; %if 50 - when found bursts, leave spikes at first 50 ms of burst duration
SHOW_ISI_HIST = false ;
Global_flags.Search_Params.MIN_channels_per_burst = 10 ; % if =4 - burst considered as burst when TSR above threshold
                             % and at least 4 channels has at least 1 spike during the burst                    
Global_flags.Search_Params.Simple_analysis = false ; % false - adjust burst start time to first spike timing in the burst                                               
Number_of_BIN_in_Hist = 15 ;
% MAX_SPIKES_PER_CHANNEL_AT_BURST = 500 ; % no effect
Global_flags.min_spikes_per_channel  = 12 ; % if channel has small number spikes per burst then exclude it from activation pattern

Global_flags.Search_Params.SpikeRate_profile_1ms_max_duration  = 300 ; % make 1 ms TSR profile of all bursts with duration defined

APPEND_DATA__TO_ORIGINAL_MAT_FILE = true ; % append analysed data to original mat file with rasterSave_Burst_analysis_figures = true ;
%%%%
DT_step = 5 ; % time bin interval for signature color plot
Save_Burst_analysis_figures = true ;
% Search_Params.Calc_Spikerate_profile_1ms_bin = true ; % finds spikerate profile 1ms bin
%     GLOBAL_const.Calc_Spikerate_profile_1ms_interp = true ; % Tact smooth will be from interpolated profile
%     GLOBAL_const.Calc_Spikerate_profile_1ms_interp_factor = 10 ;  % if 10 - SpikeRate profile -> interp1 0.1 ms
%     
%     Search_Params.Burst_activation_based_smooth_find_all_bursts = fales ; 
%%%%
Global_flags.Search_Params.Calc_Spikerate_profile_1ms_bin = false ; % finds spikerate profile 1ms bin
    Global_flags.Search_Params.Calc_Spikerate_profile_1ms_interp = false ; % Tact smooth will be from interpolated profile
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
        Global_flags.Search_Params.Spike_Rate_Signature_max_duration = 1000 ; % max duration for 1ms profiles to find smooth Tact   
 
    Global_flags.Search_Params.Save_Patterns_1ms_to_file = false ; % if true then save Spike_Rate_Patterns_1ms and Amp_Patterns_1ms to file   
   
   
GLOBAL_const.med64_fix_32channels_delay = 0 ; %if 100 then if data=med64, take 1-32 channel spikes and minus 100 ms   
   
% have effect only if Filter_small_Superbursts == true
 
% Search_Params.Filter_small_bursts from GUI
Search_Params.Filter_bursts_clasterisation = true ;
Search_Params.Filter_small_bursts_TYPE = 'Spike_Rates_each_burst' ; % can be 'BurstDurations' or 'Spike_Rates_each_burst' 
Search_Params.Filter_big_bursts =  false  ; %  false - analyze big bursts, true - small
Search_Params.Small_bursts_filter_Davies_Bouldin_index_Threshold = 0.65 ; % if its higher ...
            % ... threshold than all bursts cannnot be separated into 2 clusters
           
Search_Params.Active_channel_Spike_rate_each_burst_Thr = 3 ; % if some channel has < 1 spikes in average in burst the it will be inactive           
      Search_Params.Active_channel_By_burst_Thr= false ; % if true - active channel will be if Mean Spike_Rate on channel > Active_channel_Spike_rate_each_burst_Thr 
%                                                             false - .. Total_spikes_each_channel >  ...Spike_rate_each_burst_Thr      
       


Global_flags.Search_Params.make_Burst_ANALYSIS_RESULTS_file = false;            
 
 
GLOBAL_const.Cluster_bursts = false ; % if true - erase allspikes between bursts and merge bursts tightly
 
 Global_flags.Search_Params.Show_additional_profiles = true ;
  Global_flags.Search_Params.save_bursts_to_files = true ;
   
  
% ---------------------- Med Academy ___________________

if MED_edition
Global_flags.min_spikes_per_channel  = 1 ; % if channel has small spikes per burst then exclude it from activation pattern
Global_flags.SpikeRate_profile_1ms_max_duration  = 1000 ; % make 1 ms awsr profile of all bursts with duration set
 Global_flags.Search_Params.MIN_channels_per_burst = 4 ; % if =4 - burst considered as burst when TSR above threshold
Search_Params.Active_channel_Spike_rate_each_burst_Thr = 1 ; % if some channel has < 1 spikes in average in burst the it will be inactive            
      Search_Params.Active_channel_By_burst_Thr= true ; % if true - active channel will be if Mean Spike_Rate on channel > Active_channel_Spike_rate_each_burst_Thr 
%                                                             false - .. Total_spikes_each_channel >  ...Spike_rate_each_burst_Thr      
 Global_flags.Search_Params.Show_additional_profiles = false ;

 handles.par.threshold_fromFit_method = false ; 
end
% ---------------------- Med Academy ___________________

%% Chamber AB analysis
Global_flags.Search_Params.Chambers_Separate_analysis_AB = false ; % for burst analysis
    Global_flags.Search_Params.Chambers_Burst_duration_AB = 1000 ; % duration of new AB burst
    Global_flags.Search_Params.Chambers_AB_BA_bursts_erase_in_analysis = false ; % saves storage space
    Global_flags.Search_Params.Chambers_AB_saving_to_DB_only_ABburst = false; % true - save to DB raster (inde_r ) only with spikes in A+B
 
 Global_flags.Search_Params.Chambers_analyzeConnectivty = false ;
 
%      Global_flags.Search_Params.Burst_threshold_separateAB = true ;
%     Global_flags.Search_Params.Burst_threshold_chamberA = 12; 
%     Global_flags.Search_Params.Burst_threshold_chamberB = 12 ;
%     Global_flags.Search_Params.Burst_threshold_channels = 15 ;
 Global_flags.Search_Params.Burst_threshold_separateAB =true; % if true - then for each chamber burst detection threshold will be used from here: 
    Global_flags.Search_Params.MIN_channels_per_burstA = 7;  % burst detection threshold for chamber A
    Global_flags.Search_Params.MIN_channels_per_burstB = 9 ; % burst detection threshold for chamber B
    Global_flags.Search_Params.MIN_channels_per_burst_channels = 13 ; % burst detection threshold for channels
    
    
% % % Horizontal wall, Channel - 2 electrode lines.
%     Global_flags.Search_Params.Chamber_A_electrodes =  [ 7 5 2 59 56 54 10 9 6 1 60 55 52 51 12 11 8 3 58 53 50 49 ] ;
%     Global_flags.Search_Params.Chamber_B_electrodes =  [ 19 20 23 28 33 38 41 42 21 22 25 30 31 36 39 40 24 26 29 32 35 37 ] ;
%     Global_flags.Search_Params.Chamber_channels_electrodes =  [  15 16 ; 14 17 ; 13 18 ; 4 27 ; 57 34; 48 43 ; 47 44 ; 46 45  ] ;
% % % % % %    
% %    % Horizontal wall, Channel - 2 electrode lines. A<->B
% %     Global_flags.Search_Params.Chamber_A_electrodes =  [ 19 20 23 28 33 38 41 42 21 22 25 30 31 36 39 40 24 26 29 32 35 37 ] ;
% %     Global_flags.Search_Params.Chamber_B_electrodes =  [ 7 5 2 59 56 54 10 9 6 1 60 55 52 51 12 11 8 3 58 53 50 49 ] ;
% %     Global_flags.Search_Params.Chamber_channels_electrodes =  [  15 16 ; 14 17 ; 13 18 ; 4 27 ; 57 34; 48 43 ; 47 44 ; 46 45  ] ;
% % % % %    
% %%% Horizontal wall, Channel - 4 electrode lines.
%     Global_flags.Search_Params.Chamber_A_electrodes =  [ 7 5 2 59 56 54   10 9 6 1 60 55 52 51   12 11 8 3 58 53 50 49 ] ;
%     Global_flags.Search_Params.Chamber_B_electrodes =  [  24 26 29 32 35 37 ] ;
%     Global_flags.Search_Params.Chamber_channels_electrodes =  [  15 16 19 21 ; 14 17 20 22 ; 13 18 23 25 ; 4 27 28 30;  57 34 3 31; 48 43 38 36 ; 47 44 41 39 ; 46 45 42 40 ] ;
% %    
% %    %% Horizontal wall A<->B, Channel - 4 electrode lines.
%    Global_flags.Search_Params.Chamber_A_electrodes =  [ 24 26 29 32 35 37  ] ;
%    Global_flags.Search_Params.Chamber_B_electrodes =  [ 7 5 2 59 56 54   10 9 6 1 60 55 52 51   12 11 8 3 58 53 50 49  ] ;
%    Global_flags.Search_Params.Chamber_channels_electrodes =  [  15 16 19 21 ; 14 17 20 22 ; 13 18 23 25 ; 4 27 28 30;  57 34 3 31; 48 43 38 36 ; 47 44 41 39 ; 46 45 42 40 ] ;
% % % % %    
 %  %%   ertical wall, Channel - 3 electrode lines 2- 3-3
    Global_flags.Search_Params.Chamber_A_electrodes =  [ 10 12 15 16 19 21  7 9 11 14 17 20 22 24 ] ;
    Global_flags.Search_Params.Chamber_B_electrodes =  [  51 49 46 45 42 40  54 52 50 47 44 41 39 37  56 55 53 48 43 38 36 35 ] ;
    Global_flags.Search_Params.Chamber_channels_electrodes =  [ 5 2 59 ; 6 1 60 ; 8 3 58 ; 13 4 57 ; 18 27 34 ; 23 28 33 ; 25 30 31 ; 26 29 32  ] ;

% % Vertical wall, Channel - 3 electrode lines 2- 3-3 wrong
%     Global_flags.Search_Params.Chamber_A_electrodes =  [ 24 22 20 17 14 11 9 7 26 25 23 18 14 13 7 6 5 ]  ;
%     Global_flags.Search_Params.Chamber_B_electrodes =  [  35 36 38 43 48 53 55 56 ] ;
%     Global_flags.Search_Params.Chamber_channels_electrodes =  [ 29 32 ; 30 31 ; 28 33 ; 27 34 ; 4 57 ; 3 58 ; 1 60 ; 2 59 ] ;
% % % 
% % % %     % %    
% % %   % Vertical wall, Channel - 3 electrode lines 2- 3-3 B<->A
%     Global_flags.Search_Params.Chamber_A_electrodes =  [ 51 49 46 45 42 40  54 52 50 47 44 41 39 37  56 55 53 48 43 38 36 35  ] ;
%     Global_flags.Search_Params.Chamber_B_electrodes =  [ 10 12 15 16 19 21  7 9 11 14 17 20 22 24  ] ;
%     Global_flags.Search_Params.Chamber_channels_electrodes =  [ 5 2 59 ; 6 1 60 ; 8 3 58 ; 13 4 57 ; 18 27 34 ; 23 28 33 ; 25 30 31 ; 26 29 32  ] ;
% %    
% % %      % Vertical wall, Channel - 2 electrode lines. 3- 2 -3 
% %     Global_flags.Search_Params.Chamber_A_electrodes =  [ 10 12 15 16 19 21  7 9 11 14 17 20 22 24  5 6 8 13 18 23 25 26 ] ;
% %     Global_flags.Search_Params.Chamber_B_electrodes =  [  51 49 46 45 42 40  54 52 50 47 44 41 39 37  56 55 53 48 43 38 36 35 ] ;
% %    Global_flags.Search_Params.Chamber_channels_electrodes =  [  2 59 ; 1 60 ;  3 58 ;  4 57 ;  27 34 ;  28 33 ;  30 31 ;  29 32  ] ;
%    
% % % % %    Vertical wall, Channel - 2 electrode lines. 2- 2 -4 
% %      Global_flags.Search_Params.Chamber_A_electrodes =  [10 12 15 16 19 21  7 9 11 14 17 20 22 24  5 6 8 13 18 23 25 26] ;
%      Global_flags.Search_Params.Chamber_B_electrodes =  [ 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 ] ;
%      Global_flags.Search_Params.Chamber_channels_electrodes =  [ 2 59 ; 1 60 ;  3 58 ; 4 57 ;   ...
%              27 34 ; 28 33 ; 30 31 ; 29 32 ] ;

% % %    Vertical wall, Channel - 2 electrode lines. 2- 4 -2 
%      Global_flags.Search_Params.Chamber_A_electrodes =  [10 12 15 16 19 21  7 9 11 14 17 20 22 24] ;
%      Global_flags.Search_Params.Chamber_B_electrodes =  [ 37 39 41 44 47 50 52 54 40 42 45 46 49 51 ] ;
%      Global_flags.Search_Params.Chamber_channels_electrodes =  [ 5 2 59 56; 6 1 60 55; 8 3 58 53; 13 4 57 48;   ...
%              18 27 34 43; 23 28 33 38; 25 30 31 36; 26 29 32 35] ;
 
% % % %    Vertical wall, Channel - 2 electrode lines. 1->5->2 
%      Global_flags.Search_Params.Chamber_A_electrodes =  [10 12 15 16 19 21 ] ;
%      Global_flags.Search_Params.Chamber_B_electrodes =  [ 37 39 41 44 47 50 52 54 40 42 45 46 49 51 ] ;
%      Global_flags.Search_Params.Chamber_channels_electrodes =  [ 7 5 2 59 56; 9 6 1 60 55; 11 8 3 58 53; 14 13 4 57 48;   ...
%              17 18 27 34 43; 20 23 28 33 38; 22 25 30 31 36; 24 26 29 32 35] ;

% %    Vertical wall, Channel - 2 electrode lines. 2- 4 -2 A<-->B
%      Global_flags.Search_Params.Chamber_A_electrodes =  [ 37 39 41 44 47 50 52 54 40 42 45 46 49 51 ] ;
%      Global_flags.Search_Params.Chamber_B_electrodes =  [ 10 12 15 16 19 21  7 9 11 14 17 20 22 24  ] ;
%      Global_flags.Search_Params.Chamber_channels_electrodes =  [ 5 2 59 56; 6 1 60 55; 8 3 58 53; 13 4 57 48;   ...
%              18 27 34 43; 23 28 33 38; 25 30 31 36; 26 29 32 35] ;
% % % %          
%     Global_flags.Search_Params.Chamber_A_electrodes =  [7 9 10 11 12 14 16 17 19 20 21 22 24] ;
%     Global_flags.Search_Params.Chamber_B_electrodes =  [ 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 ] ;
%     Global_flags.Search_Params.Chamber_channels_electrodes =  [ 1 2 3 4 5 6  8 13 18 23 25 26 27 28 29 30 ] ;

%     Global_flags.Search_Params.Chamber_A_electrodes =  [7 9 10 11 12 14 16 17 19 20 21 22 24] ;
%     Global_flags.Search_Params.Chamber_B_electrodes =  [ 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 ] ;
%     Global_flags.Search_Params.Chamber_channels_electrodes =  [ 1 2 3 4 5 6  8 13 18 23 25 26 27 28 29 30 31 32 33 34 57 58 59 60 ] ;
   Global_flags.Search_Params.Chamber_AB_min_delay = 0 ;
   Global_flags.Search_Params.Chambers_Profile_relative_thr = 20 ; % if profile is not a "hill" then it's random response
    %  the code for using this const :  rel_Amp = 100 * (max( profile ) - median( profile ))/max(profile);
                %                          if PSTH_rel_Amp < PSTH_relative_Amplitude_threshold then All A->B is random
   Global_flags.Search_Params.Chambers_Profile_FirstBinFiring_thr = 10 ; % if first bins of profile in B is higher then 10Hz then its not response                              %            
                                
   
   %% Shuffle test parameters
   Global_flags.ChambersAB_max_lag = 1000  ;
   Global_flags.ChambersAB_lag_bin = 20  ;
   Global_flags.ChambersAB_shuffling_loops= 1000 ;
   Global_flags.ChambersAB_figure_title = 'A > B delays' ;
   Global_flags.ChambersAB_shuffling_sigma = 0.1  ; % [1 - 3 ]   Shuffle threshold =  ChambersAB_shuffling_sigma *  std( Ebincounts_shuffle  + Global_flags.ChambersAB_shuffling_mean_coef f*   mean( Ebincounts_shuffle ) ;
   Global_flags.ChambersAB_shuffling_mean_coeff =  1.0  ; % [ 0 or 1  ]   Shuffle threshold =  ChambersAB_shuffling_sigma *  std( Ebincounts_shuffle  +Global_flags.ChambersAB_shuffling_mean_coef f*  mean( Ebincounts_shuffle ) ;
 %----------------------------------------------------------------------
%----------------------------------------------------------------------
 
%% --- porst-stim response --------------
Global_flags.simple_activation_patterns = true ; % take 1ms bin profiles
    Global_flags.figure_Tact_smooth_3types = false ; % show figure for 3 types of Tact
   
GLOBAL_const.Post_stim_Calc_Spikerate_profile_1ms_bin = false ;
    GLOBAL_const.Post_stim_activation_based_smooth_find_all_bursts = false ;  % same as Burst_activation_based_smooth_find_all_bursts
 
    handles.par.Stim_response_Amp_sigma_threshold = 0 ; % Take only spikes which Amp / one_sigma_threshold (estimated during spike detection) is > than this value
    handles.par.Stim_response_Amp_as_AmpSigma = false ; % if true - then spike amplitude = Amp (uV) / one sigma ;
    
    handles.par.Build_FFT_of_signal = false ;
    handles.par.DF_smooth_parameter = 1.0 ; % smooth of FFT, 3 - 3Hz smooth
    handles.par.FFT_min_freq_show = 0 ; 
    handles.par.FFT_max_freq_show = 180 ; 
    
    handles.par.Artefacts_find = false  ;  % true - if selected checkbox in GUI
    handles.par.Artifact_low_freq = 0 ;  %  300 [Hz]
    
%-------- [GUI] ----------------    
            handles.par.Detect_spikes_LFP = false ;
            handles.par.Detect_spikes_when_collectingLFP = true;
%             handles.par.Post_stim_potentials_collect = false ; % [GUI] take all artifacts and collect post sti signals to matrix
                handles.par.Post_stim_potentials_external_artifact =  false ; % take all artifacts and collect post sti signals to matrix
                handles.par.Post_stim_potentials_external_artifact_file = '' ; %  
                handles.par.Post_stim_potentials_start_interval = -10  ; % ms
                handles.par.Post_stim_potentials_end_interval = 80  ; % ms
                handles.par.Post_stim_potentials_Filter_during_collect = false ; % filter signals when collecting to file       
                        handles.par.Post_stim_potentials_LowFreq = 0 ; % Hz
                        handles.par.Post_stim_potentials_HighFreq = 0  ; % Hz
                        handles.par.Post_stim_potentials_50Hz_filter = false ;
                % parameters of LFP when showing after it collected in file
                    handles.par.Post_stim_potentials_SHOW_LowFreq = 550 ; % Hz
                    handles.par.Post_stim_potentials_SHOW_HighFreq = 5000  ; % Hz
                    handles.par.Post_stim_potentials_SHOW_50Hz_filter = true ;
                        handles.par.Post_stim_potentials_SHOW_50Hz_iirnotch = 0.5 ;

                    Search_Params.LFP_stim_num = [ 0 ] ;
  %-------- //// [GUI] ----------------    
          handles.plot_multiple_signals_derrivative = true ;

Global_flags.Cluster_responses = false ; % separate High Low responses
    Global_flags.Filter_small_responses = false ;
    Global_flags.Leave_only_high_patterns = true; % After clustering leave only High responses
    Global_flags.Leave_only_low_patterns =  false ; % After clustering leave only Low responses
 
%----------------Inadequate_Patterns-------   
Global_flags.Erase_Inadequate_Patterns  = false ; % delete not adequate patterns in responses
    % for Patterns_Check_if_responses_Adequate
    % d(PSTH)/ max(PSTH)  should be more than this value [%]
    GLOBAL_const.PSTH_relative_Amplitude_threshold =5 ; % default = 20 [%],100*(max( Patterns.TimeBin_Total_Spikes( R , : ) ) - median(Patterns.TimeBin_Total_Spikes( R , : )))...
%                            /max( Patterns.TimeBin_Total_Spikes( R , : ) );
    GLOBAL_const.PSTH_spikes_threshold  = 30 ;
    %  the code for using this const :  PSTH
%     rel_Amp = max( TimeBin_Total_Spikes_mean_in_each_bin ) / median(TimeBin_Total_Spikes_mean_in_each_bin_non_zers);
                %                          if PSTH_rel_Amp < PSTH_relative_Amplitude_threshold
                                 %             All_responses_Bad
    GLOBAL_const.pause_on_cluster_figs  = false ;  % Patterns_Check_if_responses_Adequate, show debug figures
    GLOB.pause_on_tet_channel_analysis = false ;
%----------------Inadequate_Patterns-------
 
Global_flags.Erase_Inadequate_Patterns_preStim  = false  ; % analyses 100 ms pre-stim interval is spont burst was before stim
        Global_flags.Erase_Inadequate_Patterns_preStim_delay = 50  ;   % delay before artefact
        Global_flags.Erase_Inadequate_Patterns_preStim_SpikesThr = 20 ; % spikes in pre-artifact to filter
        Global_flags.Erase_Inadequate_Patterns_preStim_show_raster = true ;
       
Global_flags.Recalc_PostStim_Interval_responses_for_Classification = false ;
 
 
% Stim response Chambers
Global_flags.Stim_Search_Params.Chambers_Separate_analysis_AB =false ;
    Global_flags.Stim_Search_Params.Chambers_Separate_analysis_AB_cluster_resp_B = false ; % true - when ...
                % clustering high low responses in chambers A, now
                % clustering in B will be done. To find only Low(A)->B
                % responses or High(A)->B responses.
    Global_flags.Stim_Search_Params.Chambers_Separate_analysis_AB_spont_in_B = false ; % detect spont bursts in B              
 
Global_flags.Connectiv_chambersAB = false; % analyze connectivity between chambers 
 
% Shuffle test Stim response. to find out if stiimuli evoked or not
Global_flags.Stim_Search_Params.Shuffle_test = false  ;
    Global_flags.Stim_Search_Params.Shuffle_test_show_figure = true ;
 
GLOBAL_const.leave_or_erase_artifacts = false; % after load artifact erase or leave only some
    GLOBAL_const.erase_artifacts = true ;
    GLOBAL_const.leave_or_erase_every_artifact_period = 70  ; % if 6 - then erase 6 ,12 ... artifact (or leave)
 
    %- used in Patterns_get_High_Low_responses -----
    GLOBAL_const.Recalc_PostStim_Interval_responses_for_Classification = true ;   
    GLOBAL_const.Start_Classify = 10 ;
    GLOBAL_const.End_classify = 250 ;
    GLOBAL_const.DT_classify = 10 ; 
  
Global_flags.Stim_Calc_Spikerate_profile_1ms_bin = false ; % finds spikerate profile 1ms bin
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
 
  
  
GLOBAL_const.Find_artifacts_from_raster = false;  
GLOBAL_const.Artifact_threshold_from_max = 70 ; % if 70 - then erase find max awsr of raster and 70% of it will be threshold for artifact detect  
 
% parameters for low-high responses classification recalc
Global_flags.Global_Poststim_interval_START = 10  ;
Global_flags.Global_Poststim_interval_END = 250 ;
Global_flags.Global_DT_bin = 10 ;
 
% parameters for low-high responses classification
% Global_flags.Recalc_PostStim_Interval_responses_for_Classification = true ;    
Global_flags.Start_Classify = 10 ;
Global_flags.End_classify = 250;
Global_flags.DT_classify = 10 ;
 
% Extract artifacts. "Stim response" button parameters
    Global_flags.Stim_response_Elsel_extract_channel = false ;
   
    Global_flags.Stim_response_Elsel_extract_all_and_show = false; % If Elsel, show average responses of all Stim electrodes
   
    electrode_sel_param.type = 'List' ;
    % Cycle
         electrode_sel_param.stim_chan_to_extract = 2 ;
         electrode_sel_param.Start_channel = 2; % electrode selection started from
         electrode_sel_param.Stimuli_to_each_channel = 30 ; % stimuli to each channel
         electrode_sel_param.Channel_step = 4 ;
         electrode_sel_param.correct_protocol = false ;
    % List
        electrode_sel_param.Stimuli_to_each_channel = 60 ; % stimuli to each channel
        electrode_sel_param.Stimulation_channels = [ 16 9 13 3 48 51] ; % list of stim channels = [ 1 3 43 2 .. ]
        electrode_sel_param.Stimulation_channels_num  = length( electrode_sel_param.Stimulation_channels ) ;
        electrode_sel_param.Selected_Stimulation_channel = 6 ; % number in sequence ;
      
 
 
       
Global_flags.Stim_response_show_spikes_hist = false ;  
Global_flags.Stim_response_show_Signature_SignatureSTD_fig = false ;
Global_flags.Save_not_filtered_responses_to_files_and_DB = true ; % after Stim response analysis, saves original all responses to DB

%% ----- Patterns analysis: stimulus response classification ------------               
    %-- for Patterns_Check_if_responses_Adequate
    % define interval where spikes # should be more than in the rest PSTH
    % interval
    Global_flags.Stim_Search_Params.Adequate_show_results = true ;
     Start_Significant_spikes_interval  = 10 ;
     End_Significant_spikes_interval  = 150 ; % -- main PSTH hill should be before this time
     Ksecond_part=1.2 ;
    %   if mean( FirstPart_spikes_from_all_resp ) < Ksecond_part * mean(SecondPart_spikes_from_all_resp) 
    %                              All_responses_Bad = true ;
  
   
    MINIMUM_PATTERNS_PER_RECORD = 10 ;
    %   if exist( 'GLOB' )                         
    %      if isfield( GLOB , 'pause_on_cluster_figs' )
    %         pause                               
    %      end  
    %   end                            
%-----------------------------------------------------------------------         

%% --- Plotting consts ------------
% after bursts analysis found plot it
GM_Bursts_example_raster_duration = 0.5 ; % take first X ms of raster and plot
GLOBAL_const.Plot8x8Data_cubic_interp = false ; % cubic interpolation of 8x8 color data matrix
GLOBAL_const.Raster_plot_only_AWSR_raster = true ;
GLOBAL_const.Raster_show_color_amplitudes = false ;
    GLOBAL_const.Raster_show_color_amplitudes_minAmp = -0.3 ;
%--------------------------------
 
%% --- Connectivity -------------------------
GLOBAL_const.Connectiv_Analysis_ver = 4.3 ; % 3 - spikerate threshold - total spike rates, 4+ - firing rates threshold
GLOBAL_const.Connects_min_M_strength = 0.02 ; % compare connection with strength > set here
GLOBAL_const.Connectiv_min_spikes_per_channel = 5 ; % Connectiv_Analysis_ver=3 -> 500 spikes per channel, or if
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
    Search_Params.Superburst_threshold_coeff = 0.8 ; % X * sigma coefficient for SB detection
    Search_Params.Binary_burst_coding = false ;
    Search_Params.SB_min_duration = 100 ;   % [ms]
    Search_Params.SB_max_duration = 2000000 ; % [ms]
 
%% -- Patterns classification - High + Low bursts
 
Global_flags.High_responses_Threshold = false ; %-- If some responses exceed this threshold
                            % then there is some such responses then we
                            % have High reponses
Global_flags.autosave_to_DB = false ;  % false
  
 Global_flags.Davies_Bouldin_TSR_Clustering_index_Threshold = 0.9 ; %0.48 ,if its higher threshold than all responses are high
  
 
 %% -- Window titles
 
 GLOBAL_const.Burst_detect_result_title= 'Burst detection results' ; % after bursts found show raster with markers
 
 
