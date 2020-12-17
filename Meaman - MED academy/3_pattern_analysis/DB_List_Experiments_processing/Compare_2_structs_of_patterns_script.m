% Compare_2_structs_of_patterns_script
% Compare two sets of responses
% input should be   burst_activation, Spike_Rates_each_burst... from
% ANALYZED_DATA or POST_STIM_RESPONSE and stored in "Patterns" struct.
% output - a list of output variables should be processed outside of this
% script (ex. Compare_Pattern_pairs).

%--- MAIN parameters---------------

% Analysis_2_sets_init_parameters
meaDB_Global_init_parameters
%--------Global parameters to local -----------------------------    
MINIMUM_PATTERNS_PER_RECORD = Global_flags.MINIMUM_PATTERNS_PER_RECORD ;
%---------------------------------------------------------------------



Testing = false ; % first channel pattern1 random near 3 and patterns2 random near 9

flags.normalize = false ; % Normalized patterns to total spike rate in the response

Recalc_all_patterns = true ;
    Global_Poststim_interval_START = 10  ;
    Global_Poststim_interval_END = 300 ;
    Global_DT_bin = 40 ;

%--------Global parameters to local -----------------------------    
    Global_Poststim_interval_START =  Global_flags.Global_Poststim_interval_START  ;
    Global_Poststim_interval_END = Global_flags.Global_Poststim_interval_END ;
    Global_DT_bin = Global_flags.Global_DT_bin ;    
%---------------------------------------------------------------------    
    
% if patterns contain responses from stim of sequence of electrodes
stim_channel = 0 ;
Electrode_selection_extract_channel = false ;
     electrode_sel_param.stim_chan_to_extract = 4 ;
     electrode_sel_param.Start_channel = 2; % electrode selection started from
     electrode_sel_param.Stimuli_to_each_channel = 30 ; % stimuli to each channel
     electrode_sel_param.Channel_step = 4 ;
     electrode_sel_param.correct_protocol = false ;
% 2 4 8 12 16 20 24 26
% Delete channel manually

%--------Global parameters to local -----------------------------
%/////////// set parameters from global cycle of comapre 2 file
if Global_flags.Electrode_selection_extract_channel
    Electrode_selection_extract_channel = true ;  
     electrode_sel_param = Global_flags.electrode_sel_param ;
end

if Global_flags.cycle_all_electrodes 
    Electrode_selection_extract_channel = true ;  
     electrode_sel_param = Global_flags.electrode_sel_param ;
     electrode_sel_param.stim_chan_to_extract = Global_flags.EL_SEL_stim_chan_to_extract  ;
end 
%---------------------------------------------------------------------

ERASE_CHANNELS_NUMBER = false ;
   CHANNELStoErase = [ 30 32 ] ; 
   
   % primary filtering of bad responsees
STIM_RESPONSE_BOTH_INPUTS = 0.6 ; % each pattern should be "adequate" which is checked by is_pattern_adequate()
% Spikes_per_burst_cut_Threshold_precent = 20 ; % Threshold for small bursts, % from Maximum burst
  
% Count_zero_values - if true erases silent channels,
% makes the not active. silent - if channel has more than
ANALYSIS_ARG.High_Resp_Thr_percent  ;  % Threshold for high bursts, % from Maximum burst
ANALYSIS_ARG.Low_Resp_Thr_percent ; % Threshold for small bursts, % from Maximum burst
Pattern_filtering_settings.High_Resp_Thr_percent = ANALYSIS_ARG.High_Resp_Thr_percent  ;
Pattern_filtering_settings.Low_Resp_Thr_percent = ANALYSIS_ARG.Low_Resp_Thr_percent ;
% if Pattern_filtering_settings.Low_Resp_Thr_percent > 0
    Filter_Small_Inadequate_Responses = true ;
    Cluster_Low_High_Responses = true ; 
% end
ANALYSE_SIMILARITY_Tactivation = false ;
OVERLAP_TRESHOLD = 25 ;
PvalRanksum = 0.05 ;
random_channel = 'n' ;  
Analazyng_responses = true ; % analysis of responses or bursts
BUILD_SURROGATES_T_ACTIVATION = false ;
REBUILD_ACTIVATION_PATTERNS = false ;
      DT_Tact_shift = 80 ;
 

ERASE_CHANNELS_WITH_UNIQUE_DATA = false ; % erases number (CHANNELS_NUMBER_to_erase) of channels with lowest or      1
                                         % highest overlap
%     CHANNELS_NUMBER_to_erase = 20 ; 
LEAVE_CHANNELS_WITH_UNIQUE_DATA = false ;
LEAVE_LOWEST_OVERLAP = false ;
%     CHANNELS_NUMBER_to_analyze = 10 ;
       
CHECK_SPIKES_NUM_IN_BOTH_RASTERS = 'n' ;
MOTIF_AS_RATE = 'n' ; % Patterns as spike rate on each electrode
CYCLE_NUM_SIGNIFICANT_ELECTRODES = 'n' ;
MAIN_PSTH_DIFFERENCE_TIME_BIN = 20 ; % bin for PSTH difference - 10 ms default
 
one_burst_part_at_all = 'n' ;
Show_pattern_dur_hist = 'n';
one_burst_from = 2000 ;
one_burst_to = 2300 ;
ONE_EXPERIMENT_RESULTS = [] ;
RESULT = [] ;

 SHOW_FIGURES = ANALYSIS_ARG.SHOW_FIGURES ;
tic
if ~isempty( ANALYSIS_ARG  )
    COMPARE_ONLY_TOTAL_SPIKE_RATES  = ANALYSIS_ARG.COMPARE_ONLY_TOTAL_SPIKE_RATES ;
    Count_zero_values = ANALYSIS_ARG.Count_zero_values ;
else 
  COMPARE_ONLY_TOTAL_SPIKE_RATES = true ;
  Count_zero_values = true ;  
end 



%---------------------------------------------------------------------
%---------------------------------------------------------------------%----
%-----------------------------------------------------------------
  INIT_COMPARE_VARS 
%---------------------------------------------------------------------
%---------------------------------------------------------------------



%---------------------------------------------------------------------
% ----- ERASE NUMBER OF CHANNELS ------------------------------------------
if ERASE_CHANNELS_NUMBER 
 [ Patterns1  ] = Erase_Some_Channels_inPatterns( Patterns1 ,  CHANNELStoErase );
 [ Patterns2  ] = Erase_Some_Channels_inPatterns( Patterns2 ,  CHANNELStoErase );
 if ANALYSIS_ARG.Use_3_files
     [ Patterns3  ] = Erase_Some_Channels_inPatterns( Patterns3 ,  CHANNELStoErase );
 end
end

%------ Extract patterns of stimulation certain channel, if patterns
%contain responses to more than 1 stim channel ----------
if Electrode_selection_extract_channel

    % draw colored spikerates_each burst for 3 patterns
    if ANALYSIS_ARG.Use_3_files
%     Color_responses_all_stim_channels
    end
    
%     electrode_sel_param.stim_chan_to_extract = 1; 
    electrode_sel_param.stim_chan_to_extract
    Patterns1_Number_of_Patterns  = Patterns1.Number_of_Patterns 
    Patterns2_Number_of_Patterns  = Patterns2.Number_of_Patterns 
    electrode_sel_param
    Patterns1 = EL_SEL_Extract_responses_from_stim_channel( Patterns1 , electrode_sel_param ) ;
    Patterns2 = EL_SEL_Extract_responses_from_stim_channel( Patterns2 , electrode_sel_param ) ;
    if ANALYSIS_ARG.Use_3_files
        Patterns3_Number_of_Patterns  = Patterns3.Number_of_Patterns 
        Patterns3 = EL_SEL_Extract_responses_from_stim_channel( Patterns3 , electrode_sel_param ) ; 
    end
end
% ---------------------------------------   


%---------------------------------------------------------------------
%+++++++ Recalc all post stim stats for different intervals ++++++++++

if Recalc_all_patterns 
         Patterns1.Poststim_interval_START = Global_Poststim_interval_START ;
         Patterns1.Poststim_interval_END = Global_Poststim_interval_END ;
         Patterns1.Normalize_responses = flags.normalize ;
         Patterns1.DT_bin = Global_DT_bin ;
         
         Patterns2.Poststim_interval_START =Global_Poststim_interval_START;
         Patterns2.Poststim_interval_END = Global_Poststim_interval_END;
         Patterns2.Normalize_responses = flags.normalize ;
         Patterns2.DT_bin = Global_DT_bin ; 
         
        Patterns1 = Recalc_all_Post_stim_data(  Patterns1 , flags  ); 
        Patterns2 = Recalc_all_Post_stim_data(  Patterns2 , flags  ); 
        
        if ANALYSIS_ARG.Use_3_files
            Patterns3.Poststim_interval_START =Global_Poststim_interval_START;
            Patterns3.Poststim_interval_END = Global_Poststim_interval_END ;  
            Patterns3.DT_bin = Global_DT_bin ; 
            Patterns3.Normalize_responses = flags.normalize ;
            
            Patterns3 = Recalc_all_Post_stim_data(  Patterns3 , flags  ); 
        end 
end
%---------------------------------------------------------------------
%---------------------------------------------------------------------

        
        
%----------------------
Cycle_close_all = false ; % if true - close all plots in each entry of cycle mane experiments
  
   % set all channels active
    N = Patterns1.N_channels  ;
        Channels_a = ones(  N , 1) ;  
        Patterns1.Channels_active = Channels_a ;  
        Patterns2.Channels_active = Channels_a ;
        Patterns1.NUMBER_OF_STIMULS_original = Patterns1.Number_of_Patterns ;
        Patterns2.NUMBER_OF_STIMULS_original = Patterns2.Number_of_Patterns ;
        
        
        Patterns1.Number_of_Inadequate_Patterns = 0;
        Patterns1.Number_of_Inadequate_Patterns_percent = 0 ;
        Patterns1.Number_of_Adequate_Patterns =  Patterns1.Number_of_Patterns  ;
        Patterns1.Number_of_Adequate_Patterns_percent = 100 ;
        Patterns1.Number_of_Patterns_original =  Patterns1.Number_of_Patterns  ;
        
        
        Patterns2.Number_of_Inadequate_Patterns = 0;
        Patterns2.Number_of_Inadequate_Patterns_percent = 0 ;
        Patterns2.Number_of_Adequate_Patterns =    Patterns2.Number_of_Patterns  ;
        Patterns2.Number_of_Adequate_Patterns_percent = 100 ;        
        Patterns2.Number_of_Patterns_original =  Patterns2.Number_of_Patterns  ;  
        
        Patterns1.Spike_Rates_each_channel_Sub_Threshold_responses_num = zeros(  N , 1) ; 
        Patterns2.Spike_Rates_each_channel_Sub_Threshold_responses_num = zeros(  N , 1) ;  
 
        if ANALYSIS_ARG.Use_3_files
           Patterns3.Channels_active = Channels_a ;   
           
        Patterns3.Number_of_Inadequate_Patterns = 0;
        Patterns3.Number_of_Inadequate_Patterns_percent = 0 ;
        Patterns3.Number_of_Adequate_Patterns =  Patterns3.Number_of_Patterns  ;
        Patterns3.Number_of_Adequate_Patterns_percent = 100 ;
           
           Patterns3.Spike_Rates_each_channel_Sub_Threshold_responses_num = zeros(  N , 1) ; 
           Patterns3.NUMBER_OF_STIMULS_original = Patterns3.Number_of_Patterns ;
           Patterns3.Number_of_Patterns_original =  Patterns3.Number_of_Patterns  ;
        end        
        
    
        
        
        
if ANALYSIS_ARG.Use_3_files        
    flags.Selectivity_figure_title = 'All Responses' ;
    Patterns1_to_draw = Patterns1 ;
    Patterns2_to_draw = Patterns2 ;
    Patterns3_to_draw = Patterns3 ;
    flags.Draw_in_parent_figure = false ;
    flags.Draw_3_patterns = true ;
    if SHOW_FIGURES
        draw_PSTH_SPIKE_RATES_2_or_3_patterns_from_buf 
    end
else
    flags.Selectivity_figure_title = 'All Responses' ;
    Patterns1_to_draw = Patterns1 ;
    Patterns2_to_draw = Patterns2 ; 
    flags.Draw_in_parent_figure = false ;
    flags.Draw_3_patterns = false ;
    if SHOW_FIGURES
        draw_PSTH_SPIKE_RATES_2_or_3_patterns_from_buf 
    end
end





        

        
% ---------------------------------------
Nb = length( Patterns1.artefacts )          % Number of bursts
Nb2 = length( Patterns2.artefacts )          % Number of bursts
% N = length( Patterns1.Spike_Rates_each_channel_mean  );
xx = [] ;
I = 0 ;
 


CYCLE_NUM_SIGNIFICANT_ELECTRODES = 'n' ;
% ---------------------------------------
if CYCLE_NUM_SIGNIFICANT_ELECTRODES == 'y' 

 CYCLE_NUM_SIGNIFICANT_ELECTRODES_script
end
 % --------------------------------------- 

%  Patterns1.burst_activation =Patterns1burstactivation_reserv ;
%  Patterns2.burst_activation =Patterns2burstactivation_reserv ;
%  Sense_CH  = [   4    17    37    49    54    64 ];
%  f= 1 :64 ;
%  f(  Sense_CH ) = [] ;
%  Patterns1.burst_activation( : , f ) = 0 ;    
%  Patterns2.burst_activation( : , f ) = 0 ;
 
% DDT= 20 ;
%      Patterns2.burst_activation( : , :) =   Patterns2.burst_activation( : , :) +DDT ;
%      Patterns2.bursts( : , :, : ) =   Patterns2.bursts( : , : , :) +DDT ;
%  
%      Patterns2.burst_activation( Patterns2.burst_activation == DDT ) =  0 ;
%      Patterns2.bursts(  Patterns2.bursts == DDT  ) =  0 ; 
%  Nb2=Nb;
 

  

        %----FILTER Inactive channels----------------
        total_number_of_active_channels = Patterns1.N_channels ;
        total_number_of_active_channels_precent=100 * total_number_of_active_channels / N ;
        
        
        % function erases  bursts burst_activation Spike_Rates if some channels ...
        % of Spike_Rates has zeros more than STIM_RESPONSE_BOTH_INPUTS for each of
        % both input Patterns.
        CHANNELS_ERASED=[];        
        
        if Count_zero_values == false
         [ Patterns1  , Patterns2 , total_number_of_active_channels  ,CHANNELS_ERASED ] = ...
                Erase_Inactive_Channels_inPatterns( Patterns1 , Patterns2 ,   STIM_RESPONSE_BOTH_INPUTS , 0 ) ;
        
        
            if ANALYSIS_ARG.Use_3_files
             [ Patterns2  , Patterns3 , total_number_of_active_channels  ,CHANNELS_ERASED ] = ...
                    Erase_Inactive_Channels_inPatterns( Patterns2 , Patterns3 ,   STIM_RESPONSE_BOTH_INPUTS , 0 ) ;            
            end
        end

        % ----- FILTER Inadequate responses ------------------------------------------
        if Filter_Small_Inadequate_Responses
             
 
        Pattern_filtering_settings.use_defined_threshold = false ;
        [ Patterns1 number_of_Inadequate_Patterns Percent_adequate_patterns  ]...
            = Erase_Inadequate_Patterns_2( Patterns1  );

        
        
        [ Patterns2 number_of_Inadequate_Patterns Percent_adequate_patterns  ]...
            = Erase_Inadequate_Patterns_2( Patterns2 );
        
                 
                %===== 3rd file analysis ==================================  
                if ANALYSIS_ARG.Use_3_files
                    
                  [ Patterns3 number_of_Inadequate_Patterns Percent_adequate_patterns  ]...
                     = Erase_Inadequate_Patterns_2( Patterns3 );
               
                end  
                %==========================================================
                                 
                  
        end
        %-----------------------------------------------------------------     
        
        %==========================================================
        if Cluster_Low_High_Responses
            
            flags.SHOW_FIGURES_low_hi_responses = true ;
            
                Patterns = Patterns1 ; 
                Patterns_Cluster_Low_High_Responses_and_Separate
                % finds Low & High patterns (Patterns_get_High_Low_responses)
                % and assigns 'Low' to Patterns and 'High' to
                % Patterns_out.Patterns_high
                % Patterns.HiLo_High_Responses_number  
                % Patterns.HiLo_Low_Responses_number 
                Patterns1 = Patterns ;
                
                Patterns = Patterns2 ;
                Patterns_Cluster_Low_High_Responses_and_Separate
                % finds Low & High patterns (Patterns_get_High_Low_responses)
                % and assigns 'Low' to Patterns and 'High' to
                % Patterns_out.Patterns_high
                % Patterns.HiLo_High_Responses_number  
                % Patterns.HiLo_Low_Responses_number 
                Patterns2 = Patterns ;
            
                 %===== 3rd file analysis ==================================  
                if ANALYSIS_ARG.Use_3_files
                    
                    Patterns = Patterns3 ;
                    Patterns_Cluster_Low_High_Responses_and_Separate
                    % finds Low & High patterns (Patterns_get_High_Low_responses)
                    % and assigns 'Low' to Patterns and 'High' to
                    % Patterns_out.Patterns_high
                    % Patterns.HiLo_High_Responses_number  
                    % Patterns.HiLo_Low_Responses_number 
                    Patterns3 = Patterns ;
                end
                %==========================================================
        end 
      %==========================================================
      
      
      %==========================================================
      %==========================================================
      %==========================================================
      %======== Check if enough Patterns in experiments =============
      
%         Hi_Lo_Patterns1_2_enough_Low_responses
%         Hi_Lo_Patterns2_3_enough_Low_responses
%         Hi_Lo_Patterns1_2_enough_High_responses
%         Hi_Lo_Patterns2_3_enough_High_responses
        
        %========Low responses 
          Hi_Lo_Patterns1_2_enough_Low_responses = false ;
          if Patterns1.HiLo_Low_Responses_number > MINIMUM_PATTERNS_PER_RECORD && ...
             Patterns2.HiLo_Low_Responses_number > MINIMUM_PATTERNS_PER_RECORD 
                Hi_Lo_Patterns1_2_enough_Low_responses = true ;
          end 
          
            if ANALYSIS_ARG.Use_3_files
                 Hi_Lo_Patterns2_3_enough_Low_responses = false ;
                 if Patterns2.HiLo_Low_Responses_number > MINIMUM_PATTERNS_PER_RECORD && ...
                    Patterns3.HiLo_Low_Responses_number > MINIMUM_PATTERNS_PER_RECORD 
                      Hi_Lo_Patterns2_3_enough_Low_responses = true ;
                 end
            end
            
         %========High responses 
          Hi_Lo_Patterns1_2_enough_High_responses = false ;
          if Patterns1.HiLo_High_Responses_number > MINIMUM_PATTERNS_PER_RECORD && ...
             Patterns2.HiLo_High_Responses_number > MINIMUM_PATTERNS_PER_RECORD 
                Hi_Lo_Patterns1_2_enough_High_responses = true ;
          end 
          
            if ANALYSIS_ARG.Use_3_files
                 Hi_Lo_Patterns2_3_enough_High_responses = false ;
                 if Patterns2.HiLo_High_Responses_number > MINIMUM_PATTERNS_PER_RECORD && ...
                    Patterns3.HiLo_High_Responses_number > MINIMUM_PATTERNS_PER_RECORD 
                      Hi_Lo_Patterns2_3_enough_High_responses = true ;
                 end
            end           
      %==========================================================
      %==========================================================
      %==============================================================
      
      
      
      %=== All filtering done === now get stat characteristics ===
                        if ~Patterns1.No_patterns
                                Patterns = Patterns1 ;
                              %----------Patterns_get_Statistsic_all_parameters     
                                % Patterns.TimeBin_Total_Spikes  ... -> TimeBin_Total_Spikes_mean
                                Patterns_get_Statistsic_all_parameters
                                Patterns1 = Patterns ;
                        end
                        
                        if ~Patterns2.No_patterns
                            Patterns = Patterns2 ;
                                           %----------Patterns_get_Statistsic_all_parameters     
                                % Patterns.TimeBin_Total_Spikes  ... -> TimeBin_Total_Spikes_mean
                                Patterns_get_Statistsic_all_parameters
                                Patterns2 = Patterns ;
                        end
                %===== 3rd file analysis ==================================  
                if ANALYSIS_ARG.Use_3_files
                     if ~Patterns3.No_patterns
                                Patterns = Patterns3 ;
                                %----------Patterns_get_Statistsic_all_parameters     
                                % Patterns.TimeBin_Total_Spikes  ... -> TimeBin_Total_Spikes_mean
                                Patterns_get_Statistsic_all_parameters
                                Patterns3 = Patterns ; 
                     end
                end
                %==========================================================
                
       %==========================================================
       
   
      
%---- Compare responses total by ranksum after filtering inadequate
%responses
if length( Patterns1.Spike_Rates_each_burst ) > 1  && length(Patterns2.Spike_Rates_each_burst) > 1 
    [p, TOTAL_RATE.TOTAL_RATE_stat_different_if_1 ] = ... 
        ranksum(Patterns1.Spike_Rates_each_burst , Patterns2.Spike_Rates_each_burst ) ;
else
 TOTAL_RATE.TOTAL_RATE_stat_different_if_1 = 0 ;  
end
%  TOTAL_RATE.TOTAL_RATE_stat_different_if_1;
 
 TOTAL_RATE_High.TOTAL_RATE_High_Responses_stat_different_if_1 = 0 ;
 % if Analysis of High responses separatly
 if Hi_Lo_Patterns1_2_enough_High_responses
        if length( Patterns1.Patterns_high.Spike_Rates_each_burst ) > 1  && length(Patterns2.Patterns_high.Spike_Rates_each_burst) > 1 
            [p, TOTAL_RATE_High.TOTAL_RATE_High_Responses_stat_different_if_1 ] = ... 
                ranksum(Patterns1.Patterns_high.Spike_Rates_each_burst , Patterns2.Patterns_high.Spike_Rates_each_burst ) ;
        else
          TOTAL_RATE_High.TOTAL_RATE_High_Responses_stat_different_if_1 = 0 ;  
        end
          TOTAL_RATE_High.TOTAL_RATE_High_Responses_stat_different_if_1 ; 
 end

 
                 %===== 3rd file analysis ==================================  
                if ANALYSIS_ARG.Use_3_files
                     if length( Patterns2.Spike_Rates_each_burst ) > 1  && length(Patterns3.Spike_Rates_each_burst) > 1 
                        [p, TOTAL_RATE_3files.Ctrl2_Eff_TOTAL_RATE_High_stat_diff_if_1 ] = ... 
                            ranksum(Patterns2.Spike_Rates_each_burst , Patterns3.Spike_Rates_each_burst ) ;
                    else
                      TOTAL_RATE_3files.Ctrl2_Eff_TOTAL_RATE_High_stat_diff_if_1 = 0 ;  
                     end           
                     
                      % if Analysis of High responses separatly
                     if Hi_Lo_Patterns2_3_enough_High_responses 
                            if length( Patterns2.Patterns_high.Spike_Rates_each_burst ) > 1  && length(Patterns3.Patterns_high.Spike_Rates_each_burst) > 1 
                                [p, TOTAL_RATE_3files_High.TOTAL_RATE_stat_different_if_1_HighResp_3files ] = ... 
                                    ranksum(Patterns2.Patterns_high.Spike_Rates_each_burst , Patterns3.Patterns_high.Spike_Rates_each_burst ) ;
                            else
                              TOTAL_RATE_3files_High.TOTAL_RATE_stat_different_if_1_HighResp_3files = 0 ;  
                            end                         
                     end
                     
                end
                %==========================================================                     
 %------------------------------

%==========================================================
%==========================================================
% ----- PSTH analysis------------------------------------------
if Analazyng_responses
% [psth_dx1 , psth1 , psth_norPatterns1] = PSTH_calc( Patterns1.bursts , Nb , MAIN_PSTH_DIFFERENCE_TIME_BIN ,Total_burst_len , N );
% [psth_dx2 , psth2 , psth_norPatterns2] = PSTH_calc( Patterns2.bursts , Nb2 , MAIN_PSTH_DIFFERENCE_TIME_BIN ,Total_burst_len, N );
 
%  TOTAL_RATE.psth_diff_rms =  rms( Patterns1.TimeBin_Total_Spikes_mean - Patterns2.TimeBin_Total_Spikes_mean )  ;
%  TOTAL_RATE.psth_diff_precent = 100* (sum( Patterns2.TimeBin_Total_Spikes_mean ) / sum( Patterns1.TimeBin_Total_Spikes_mean )) ; 

%  psth_diff_precent = TOTAL_RATE.psth_diff_precent ;
  
%  ---draw PSTH of 2 patterns
DT_step = Patterns1.DT_bin     ;
DT_bins_number = Patterns1.DT_bins_number ;
TimeBins = 1 : DT_bins_number ;
 
                %===== 3rd file analysis ==================================  
                if ANALYSIS_ARG.Use_3_files
%                      TOTAL_RATE_3files.Ctrl_effect_psth_diff_rms =  rms( Patterns2.TimeBin_Total_Spikes_mean - Patterns3.TimeBin_Total_Spikes_mean )  ;
%                      TOTAL_RATE_3files.Ctrl_effect_psth_diff_precent = 100* (sum( Patterns3.TimeBin_Total_Spikes_mean ) / sum( Patterns2.TimeBin_Total_Spikes_mean )) ; 
            
%                      draw_PSTH_SPIKE_RATES_3_patterns      
                else
%                    draw_PSTH_SPIKE_RATES_2_patterns 
                end
      
end
%   -----------------------------------------------------------------      




%-----------------------------------------------------------------      
% -----------   SURROGATES of the T activation
if BUILD_SURROGATES_T_ACTIVATION == true
 X = RandomArrayN( Nb + Nb2 ); 
 PATTERNS = [ Patterns1.burst_activation ; Patterns2.burst_activation ];
X = RandomArrayN( Nb + Nb2 );
 for i = 1 : Nb 
 Patterns1.burst_activation( i , : ) = PATTERNS(  X(i)   , : );
 end  
 
 for i = 1 : Nb2  
  Patterns2.burst_activation( i , : ) = PATTERNS(  X(i + Nb )   , : );
 end
end
% ------------------------------------------- 


%----vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv--------------      
%------------------------- T act - make new from bursts with delay
if REBUILD_ACTIVATION_PATTERNS == true  
  Start_t = 20 ;
  for k = 1 : N             
    for t = 1 : Nb                         
       si = find( Patterns1.bursts( t , k ,: )>= Start_t + DT_Tact_shift & Patterns1.bursts( t , k ,: )<  DT_Tact_shift + Start_t + DT_Tact_shift * 3  ) ;
         if ~isempty( si)
            Patterns1.burst_activation( t , k ) =    Patterns1.bursts( t , k , si(1) )   ;
         else
             Patterns1.burst_activation( t , k ) =   0  ;
         end
    end
    
    ch2 = 0 ;
    for t = 1 : Nb2                      
        si = find( Patterns2.bursts( t , k ,: )>=  Start_t + DT_Tact_shift & Patterns2.bursts( t , k ,: )<  DT_Tact_shift + Start_t + DT_Tact_shift * 3  ) ;
         if ~isempty( si)
            Patterns2.burst_activation( t , k ) =    Patterns2.bursts( t , k , si(1) )   ;
         else
             Patterns2.burst_activation( t , k ) =   0  ;
         end
    end 
  end  
end 
%------------------------------------------------------------------


 %==========================================================
 %==========================================================       
% How much electrodes sensitive to Spike rate
  % takes two sets of patterns and compares difference of Spike_Rates
  % Low active channels should be erased before this . 
if ANALYSIS_ARG.Use_3_files == false  % Ana;ysis of 2 patterns sets
    
    
%         Hi_Lo_Patterns1_2_enough_Low_responses
%         Hi_Lo_Patterns2_3_enough_Low_responses
%         Hi_Lo_Patterns1_2_enough_High_responses
%         Hi_Lo_Patterns2_3_enough_High_responses 

    if Hi_Lo_Patterns1_2_enough_Low_responses
        
                    if Testing 
                       Patterns1.Spike_Rates(  : , 1 ) = floor(1+3*rand( Patterns1.Number_of_Patterns , 1));
                       Patterns2.Spike_Rates(  : , 1 ) = floor(12+3*rand( Patterns2.Number_of_Patterns , 1));
                    end
                flags.Selectivity_figure_title = 'Normal Responses' ;
                Patterns1_to_draw = Patterns1 ;
                Patterns2_to_draw = Patterns2 ;
%                 draw_PSTH_SPIKE_RATES_2_patterns_from_buf ;

                flags.Draw_in_parent_figure = false ;
                flags.Draw_3_patterns = false ;
                if SHOW_FIGURES
                    draw_PSTH_SPIKE_RATES_2_or_3_patterns_from_buf
                end
    
        flags.Selectivity_figure_title = 'Normal Responses' ;
        flags.TOTAL_RATE = TOTAL_RATE;
        [ TOTAL_RATE  ] ...
            = Selective_Channels_by_Rate_in_Patterns(Patterns1 , Patterns2 , OVERLAP_TRESHOLD , STIM_RESPONSE_BOTH_INPUTS , SHOW_FIGURES , ...
            Count_zero_values , flags );
%         TOTAL_RATE_total_number_of_active_electrodes
%         TOTAL_RATE_Stat_selective_electrodes_num
%         TOTAL_RATE_Stat_Selective_electrodes_percent
%         TOTAL_RATE_Selective_electrodes_lin_div_percent 
%         TOTAL_RATE_Overlaps = Overlaps_lin_div';
%         TOTAL_RATE_Overlaps ;

    end
    
%      if Analysis of High responses separatly
    if Hi_Lo_Patterns1_2_enough_High_responses
        
                flags.Selectivity_figure_title = 'High Responses' ;
                Patterns1_to_draw = Patterns1.Patterns_high ;
                Patterns2_to_draw = Patterns2.Patterns_high ;
%                 draw_PSTH_SPIKE_RATES_2_patterns_from_buf ;
                flags.Draw_in_parent_figure = false ;
                flags.Draw_3_patterns = false ;
                draw_PSTH_SPIKE_RATES_2_or_3_patterns_from_buf
 
        flags.TOTAL_RATE =TOTAL_RATE_High;        
         flags.Selectivity_figure_title = 'High Responses' ;
       [ TOTAL_RATE_High ] ...
        = Selective_Channels_by_Rate_in_Patterns(Patterns1.Patterns_high , Patterns2.Patterns_high , OVERLAP_TRESHOLD , STIM_RESPONSE_BOTH_INPUTS , SHOW_FIGURES , ...
            Count_zero_values , flags ); 
     end
end
                %===== 3rd file analysis ==================================  
                if ANALYSIS_ARG.Use_3_files
                    if Hi_Lo_Patterns2_3_enough_Low_responses
                    
                            if Testing 
                               Patterns1.Spike_Rates(  : , 1 ) = floor(1+3*rand( Patterns1.Number_of_Patterns , 1));
                               Patterns3.Spike_Rates(  : , 1 ) = floor(5+3*rand( Patterns3.Number_of_Patterns , 1));
                            end
                                            flags.Selectivity_figure_title = 'Normal Responses' ;
                                            Patterns1_to_draw = Patterns1 ;
                                            Patterns2_to_draw = Patterns2  ;
                                            Patterns3_to_draw = Patterns3  ;
                                            flags.Draw_in_parent_figure = false ;
                                            flags.Draw_3_patterns = true ;
        %                                     draw_PSTH_SPIKE_RATES_2_or_3_patterns_from_buf

                            flags.Selective_Channels_Results = TOTAL_RATE_3files ;
                            flags.Selectivity_figure_title = 'Normal Responses' ;
                            
                            GLOBAL_CONSTANTS_load
                            flags.Tet_channel_stim = false ;
                            if GLOB.pause_on_tet_channel_analysis 
                                if isfield( electrode_sel_param , 'Tet1' )
                                   if electrode_sel_param.Tet1 == electrode_sel_param.stim_chan_to_extract || ...
                                      electrode_sel_param.Tet2 == electrode_sel_param.stim_chan_to_extract     

                                        flags.Selectivity_figure_title = [ 'TET channel, ' flags.Selectivity_figure_title ];
                                        flags.Tet_channel_stim = true ;
                                   end
                                end
                                
                            end
                            flags.electrode_sel_param = electrode_sel_param  ;
                            flags.TOTAL_RATE  = TOTAL_RATE_3files ;
                          [ TOTAL_RATE_3files ]= ...
                                    Selective_Channels_by_Rate_in_3_Patterns(  Patterns1 , Patterns2 , Patterns3 , OVERLAP_TRESHOLD , ...
                              STIM_RESPONSE_BOTH_INPUTS ,SHOW_FIGURES , Count_zero_values , flags); 
        %=================================================================================================                        
        
                    end
                    
%                          if Analysis of High responses separatly
                        if Hi_Lo_Patterns1_2_enough_High_responses && Hi_Lo_Patterns2_3_enough_High_responses 
                            
                                    flags.Selectivity_figure_title = 'High Responses' ;
                                    Patterns1_to_draw = Patterns1.Patterns_high  ;
                                    Patterns2_to_draw = Patterns2.Patterns_high  ;
                                    Patterns3_to_draw = Patterns3.Patterns_high  ;
                                    flags.Draw_in_parent_figure = false ;
                                    flags.Draw_3_patterns = true ;
%                                     draw_PSTH_SPIKE_RATES_2_or_3_patterns_from_buf
                            
                                 flags.Selective_Channels_Results = TOTAL_RATE_High_3files ;
                                 flags.Selectivity_figure_title = 'High Responses' ;
                                 
                                    GLOBAL_CONSTANTS_load
                                    flags.Tet_channel_stim = false ;
                                    if GLOB.pause_on_tet_channel_analysis 
                                        if isfield( electrode_sel_param , 'Tet1' )
                                           if electrode_sel_param.Tet1 == electrode_sel_param.stim_chan_to_extract || ...
                                              electrode_sel_param.Tet2 == electrode_sel_param.stim_chan_to_extract     

                                                flags.Selectivity_figure_title = [ 'TET channel, ' flags.Selectivity_figure_title ];
                                                flags.Tet_channel_stim = true ;
                                           end
                                        end

                                    end
                                    flags.electrode_sel_param = electrode_sel_param  ;                                 
                                 
                                  flags.TOTAL_RATE  = TOTAL_RATE_High_3files ;
    %                            [ TOTAL_RATE_total_number_of_active_electrodes , TOTAL_RATE_Stat_selective_electrodes_num ,...
    %                             TOTAL_RATE_Stat_Selective_electrodes_percent , TOTAL_RATE_Selective_electrodes_lin_div_num ...
    %                             ,TOTAL_RATE_Selective_electrodes_lin_div_percent , Overlaps_lin_div , Channels_overlap , Channels_is_selective , Channel_is_active ] ...
    %                             = Selective_Channels_by_Rate_in_3_Patterns(Patterns1.Patterns_high , Patterns2.Patterns_high , Patterns3.Patterns_high ...
    %                             , OVERLAP_TRESHOLD , STIM_RESPONSE_BOTH_INPUTS , SHOW_FIGURES , ...
    %                                 Count_zero_values , flags ); 
                               [ TOTAL_RATE_High_3files  ]= ...
                                   Selective_Channels_by_Rate_in_3_Patterns(Patterns1.Patterns_high , Patterns2.Patterns_high , Patterns3.Patterns_high ...
                                , OVERLAP_TRESHOLD , STIM_RESPONSE_BOTH_INPUTS , SHOW_FIGURES , ...
                                    Count_zero_values , flags ); 
        %//////////////////////////////////////////////////////////////////
        %
                         end    
                        
                end
                
                
                
 %==========================================================               
%---------------------------- ERASE number of channels with lowest or
%---------------------------- highest  overlap of Total spike rate
 if ERASE_CHANNELS_WITH_UNIQUE_DATA
%    sort(Channels_overlap, 'descend')
    [B, index_chan_ascend ]=sort(Channels_overlap) ; %index_chan_ascend(1) -index of channel with lowest overlap
    CHANNELStoErase = index_chan_ascend( 1 : CHANNELS_NUMBER_to_erase  );
    CHANNELStoErase 
     [ Patterns1  ] = Erase_Some_Channels_inPatterns( Patterns1 ,  CHANNELStoErase );
     [ Patterns2  ] = Erase_Some_Channels_inPatterns( Patterns2 ,  CHANNELStoErase );  
end
%--------------------------------------------------------------------------

%==========================================================
%---------------------------- LEAVE or Erase number of channels with lowest or
%---------------------------- highest overlap of Total spike rate and erase
%---- the rest
if LEAVE_CHANNELS_WITH_UNIQUE_DATA 
%    sort(Channels_overlap, 'descend')
if TOTAL_RATE_total_number_of_active_electrodes >= CHANNELS_NUMBER_to_analyze
    [B, index_chan_ascend ]=sort(Channels_overlap) ; %index_chan_ascend(1) -index of channel with lowest overlap
    index_chan_ascend=index_chan_ascend';
    CHANNELStoErase = index_chan_ascend( TOTAL_RATE_total_number_of_active_electrodes +1:N);
    CHANNELStoErase
    if TOTAL_RATE_total_number_of_active_electrodes > CHANNELS_NUMBER_to_analyze
        if LEAVE_LOWEST_OVERLAP 
        CHANNELStoErase=[CHANNELStoErase index_chan_ascend((CHANNELS_NUMBER_to_analyze+1):N)];
        else
        CHANNELStoErase=[CHANNELStoErase  index_chan_ascend(1:( -CHANNELS_NUMBER_to_analyze)) ];            
        end
    end 
else
    CHANNELStoErase = 1:N;
end
    CHANNELStoErase
%      [Data1_new , Data2_new] = Erase_Specified_Channels( Patterns1.bursts , Patterns2.bursts ,  CHANNELStoErase );
%     Patterns1.bursts = Data1_new; Patterns2.bursts = Data2_new ;
%      [Data1_new , Data2_new] = Erase_Specified_Channels( Patterns1.burst_activation , Patterns2.burst_activation ,  CHANNELStoErase );
%     Patterns1.burst_activation = Data1_new; Patterns2.burst_activation = Data2_new ;
     [ Patterns1  ] = Erase_Some_Channels_inPatterns( Patterns1 ,  CHANNELStoErase );
     [ Patterns2  ] = Erase_Some_Channels_inPatterns( Patterns2 ,  CHANNELStoErase );
    
end
Nb = Patterns1.Number_of_Patterns ;
Nb2 = Patterns2.Number_of_Patterns ;
%--------------------------------------------------------------------------

 
 
if ~COMPARE_ONLY_TOTAL_SPIKE_RATES
%----------------------------------------------------------------------
%---- Compare spike rates total and in bin by <<<< Clustering analysis >>>>---------------------    
comp_flags.Count_zero_values = Count_zero_values ;
[ SpikeRate , TOTAL_RATE ] =...
    compare_activity_in_Patterns( Patterns1 , Patterns2 ,  STIM_RESPONSE_BOTH_INPUTS ,...
    OVERLAP_TRESHOLD , PvalRanksum, CHANNELS_ERASED , File_name_x , SHOW_FIGURES , TOTAL_RATE , comp_flags );
%---------------------------------------------------------              
%--------------------------------------------------------------------------
end


x=0;
x_last = 0 ;
       
  for x = 0: 10 : x_last
 
    xx = [ xx x ];
    I = I + 1 ;
    I;
    
%     
%    
% motif = zeros( Nb , N ) ;
% motif2 = zeros( Nb2 , N ) ;
% for t = 1 : Nb
% %     x = 0 ; % rand() * mmnn ;  
% rand_CH = RandomArrayN( N );                   
%     
%   for ch = 1 : N   
%         
%         if random_channel == 'y'
% %             channel = floor( rand()*(N-1) +1);
%             channel = rand_CH( ch );
%         else    
%             channel = ch ; % 
%         end
%                
%         if one_burst_part_at_all == 'y'
%             if round(x) > one_burst_from && round(x) <= one_burst_to        
%                    ss = find( index_r( : , 1 ) >= burst_start( 1 ) + round(x) & ...            
%                    index_r( : , 1 ) < burst_end( 1 ) & index_r( : , 2 ) == channel , 1 ) ;       
%                if isempty( ss ) ~= 1
%                   motif( t , ch ) = index_r( ss , 1 )  - burst_start( 1 );  
% %                   burst( t , ch ) = index_r( ss , 1)* 20-  burst_start( 1 )*20;
%                end 
%             else
%                   ss = find( index_r( : , 1 ) >= burst_start( t ) + round(x) & ...            
%                   index_r( : , 1 ) < burst_end( t ) & index_r( : , 2 ) == rand_CH( ch ) , 1 ) ;       
%                 if isempty( ss ) ~= 1
%                    motif( t , ch ) = index_r( ss , 1 )  -  burst_start( t ); 
% %                    burst( t , ch ) = index_r( ss , 1)* 20-  burst_start( t )*20;
%                end 
%             end    
%         else
%                 
%         ss = find( index_r( : , 1 ) >= (burst_start( t ) + round(x)) & ...            
%             index_r( : , 1 ) < burst_end( t ) & index_r( : , 2 ) == channel , 1 ) ;       
%           if isempty( ss ) ~= 1
%               motif( t , ch ) = index_r( ss , 1 )  -  ( burst_start( t )  + round(x) );
% %               burst( t , ch ) = index_r( ss , 1)* 20-  burst_start( t )*20;
%           end
%         
%         end
%                 
%         
% %         for s = 1 : k
% %             burst( t , ss( k - s + 1 ) , : ) = index_r( ss( k - s + 1 ) , : ) ;
% %             index_r( ss( k - s + 1 ) , : ) = [] ;
% %         end
%     end
% %     motif( t , : ) = burst( t , : ) - min( motif( t , : ) ) ;
% % 
% %     figure
% %     chh = 1:64 ;
% %         plot(  motif( t , :) , chh(:) ,'.','MarkerEdgeColor' ,[.04 .52 .78] )
% % %         
% 
% end
% 
% % /////////////////////////// 2nd set
% for t = 1 : Nb2
% %     x = 0 ; % rand() * mmnn ;  
% rand_CH = RandomArrayN( N );                   
%     
%   for ch = 1 : N   
%         
%         if random_channel == 'y'
% %             channel = floor( rand()*(N-1) +1);
%             channel = rand_CH( ch );
%         else    
%             channel = ch ; % 
%         end
%                
%         if one_burst_part_at_all == 'y'
%             if round(x) > one_burst_from && round(x) <= one_burst_to        
%                    ss = find( index_r( : , 1 ) >= burst_start( 1 ) + round(x) & ...            
%                    index_r( : , 1 ) < burst_end( 1 ) & index_r( : , 2 ) == channel , 1 ) ;       
%                if isempty( ss ) ~= 1
%                   motif( t , ch ) = index_r( ss , 1 )  - burst_start( 1 );  
% %                   burst( t , ch ) = index_r( ss , 1)* 20-  burst_start( 1 )*20;
%                end 
%             else
%                   ss = find( index_r( : , 1 ) >= burst_start( t ) + round(x) & ...            
%                   index_r( : , 1 ) < burst_end( t ) & index_r( : , 2 ) == rand_CH( ch ) , 1 ) ;       
%                 if isempty( ss ) ~= 1
%                    motif( t , ch ) = index_r( ss , 1 )  -  burst_start( t ); 
% %                    burst( t , ch ) = index_r( ss , 1)* 20-  burst_start( t )*20;
%                end 
%             end    
%         else
%                 
%         ss = find( index_r2( : , 1 ) >= (burst_start2( t ) + round(x)) & ...            
%             index_r2( : , 1 ) < burst_end2( t ) & index_r2( : , 2 ) == channel , 1 ) ;       
%           if isempty( ss ) ~= 1
%               motif2( t , ch ) = index_r2( ss , 1 )  -  ( burst_start2( t )  + round(x) );
% %               burst( t , ch ) = index_r( ss , 1)* 20-  burst_start( t )*20;
%           end
%         
%         end
%                         
% %         for s = 1 : k
% %             burst( t , ss( k - s + 1 ) , : ) = index_r( ss( k - s + 1 ) , : ) ;
% %             index_r( ss( k - s + 1 ) , : ) = [] ;
% %         end
%     end
% %     motif( t , : ) = burst( t , : ) - min( motif( t , : ) ) ;
% % 
% %     figure
% %     chh = 1:64 ;
% %         plot(  motif( t , :) , chh(:) ,'.','MarkerEdgeColor' ,[.04 .52 .78] )
% % %         
% 
% end

%--------------------------------------------------------------------------
%-----Activation times Tact Pattern similarity ----------------------------------------

 
if ANALYSE_SIMILARITY_Tactivation 
    
 %--------------------------------------------------------------------------
%---- Compare Activation times Tact ---------------------------------------

    if ~COMPARE_ONLY_TOTAL_SPIKE_RATES
        
       if Hi_Lo_Patterns1_2_enough_Low_responses 
           
         % How much electrodes sesitive to T activation 
        [ T_act ]...
            = Selective_Channels_Tactivation_in_Patterns( Patterns1 , Patterns2 , 0 , OVERLAP_TRESHOLD , true );
        % Stat and linear (by clustering) difference of activation times in all
        % channels independently  
        
             [ T_act.SVM_accuracy , T_act.Clustering_error_precent_SVM , T_act.Not_distinguishable_points_num_SVM ] = SVM_check_accuracy_1D_data( ... 
              Patterns1.burst_activation , Patterns2.burst_activation,  Patterns1.Number_of_Patterns  , Patterns2.Number_of_Patterns  , N );
          
            Tact_SVM_accuracy = T_act.SVM_accuracy
            
             
            T_act_Pattern_similarity
            % Patterns1.burst_activation Patterns2.burst_activation ->
            % Tact_Clustering_error_precent_KMEANS ...   
       end
       
       
       if Hi_Lo_Patterns1_2_enough_High_responses 
           
         % How much electrodes sesitive to T activation 
        [ T_act_High ]...
            = Selective_Channels_Tactivation_in_Patterns( Patterns1 , Patterns2 , 0 , OVERLAP_TRESHOLD , true );
        % Stat and linear (by clustering) difference of activation times in all
        % channels independently  
        
             [ T_act_High.SVM_accuracy , T_act_High.Clustering_error_precent_SVM , T_act_High.Not_distinguishable_points_num_SVM ] = SVM_check_accuracy_1D_data( ... 
              Patterns1.Patterns_high.burst_activation , Patterns2.Patterns_high.burst_activation,  Patterns1.Patterns_high.Number_of_Patterns  , Patterns2.Patterns_high.Number_of_Patterns  , N );
          
            Tact_SVM_accuracy = T_act_High.Patterns_high.SVM_accuracy
             
            
            burst_activation1_buf = Patterns1.burst_activation ;
            burst_activation2_buf = Patterns2.burst_activation ;
            Patterns1.burst_activation  = Patterns1.Patterns_high.burst_activation ;
            Patterns2.burst_activation  = Patterns2.Patterns_high.burst_activation ;           
            T_act_buf = T_act ;
            T_act = T_act_High ;
            
            T_act_Pattern_similarity
            % Patterns1.burst_activation Patterns2.burst_activation ->
            % Tact_Clustering_error_precent_KMEANS ...   
            
            T_act_High = T_act ;
            T_act = T_act_buf ;
            Patterns1.burst_activation =burst_activation1_buf ;
            Patterns2.burst_activation =burst_activation2_buf ;          
       end
       
    end 

        %//////////////////////////////////////////////////////////////////
                    %===== 3rd file analysis ==================================  
                if ANALYSIS_ARG.Use_3_files
                    if Hi_Lo_Patterns2_3_enough_Low_responses
                    [ T_act_3files ]...
                        = Selective_Channels_Tactivation_in_Patterns( Patterns2 , Patterns3 , 0 , OVERLAP_TRESHOLD , true );
                    % Stat and linear (by clustering) difference of activation times in all
                    % channels independently  
                    
                    
                    [ T_act_3files.Ctrl2_Eff_Tact_SVM_accuracy , T_act_3files.Ctrl2_Eff_Tact_Clustering_error_precent_SVM , ...
                        T_act_3files.Ctrl2_Eff_Tact_Not_distinguishable_points_num_SVM ] = SVM_check_accuracy_1D_data( ... 
                          Patterns2.burst_activation , Patterns3.burst_activation,  Nb2 , Nb3 , N );

                    end 
                    
                   if Hi_Lo_Patterns1_2_enough_High_responses 
           
                             % How much electrodes sesitive to T activation 
                            [ T_act_3files_High ]...
                                = Selective_Channels_Tactivation_in_Patterns( Patterns1 , Patterns2 , 0 , OVERLAP_TRESHOLD , true );
                            % Stat and linear (by clustering) difference of activation times in all
                            % channels independently  

                                 [ T_act_3files_High.SVM_accuracy , T_act_3files_High.Clustering_error_precent_SVM , ...
                                     T_act_3files_High.Not_distinguishable_points_num_SVM ] = SVM_check_accuracy_1D_data( ... 
                                  Patterns2.Patterns_high.burst_activation , Patterns3.Patterns_high.burst_activation, ...
                                        Patterns2.Patterns_high.Number_of_Patterns  , Patterns3.Patterns_high.Number_of_Patterns  , N );

                                Tact_SVM_accuracy = T_act_3files_High.Patterns_high.SVM_accuracy 

                                burst_activation1_buf = Patterns1.burst_activation ;
                                burst_activation2_buf = Patterns2.burst_activation ;
                                Patterns1.burst_activation  = Patterns2.Patterns_high.burst_activation ;
                                Patterns2.burst_activation  = Patterns3.Patterns_high.burst_activation ;    
                                
                                T_act_buf = T_act_3files ;
                                T_act = T_act_3files_High  ;

                                T_act_Pattern_similarity
                                % Patterns1.burst_activation Patterns2.burst_activation ->
                                % Tact_Clustering_error_precent_KMEANS ...   

                                T_act_3files_High = T_act ;
                                T_act_3files = T_act_buf ;
                                
                                Patterns1.burst_activation =burst_activation1_buf ;
                                Patterns2.burst_activation =burst_activation2_buf ;          
                    end
                    
                    
                    
                    
                end
       
    % ONE_EXPERIMENT_RESULTS.SVM_accuracy_activation_P1vsP2 = SVM_accuracy_activation_P1vsP2 ;
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
   

end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

% ONE_EXPERIMENT_RESULTS.Patterns1_artefacts = Patterns1.artefacts ;
%/////////////////////////////////////////////// 
 ONE_EXPERIMENT_RESULTS.total_number_of_active_channels =total_number_of_active_channels ;
 ONE_EXPERIMENT_RESULTS.total_number_of_active_channels_precent =total_number_of_active_channels_precent;

 %--------------------------
 ONE_EXPERIMENT_RESULTS.Number_of_Patterns1_original = Patterns1.Number_of_Patterns_original  ;
 ONE_EXPERIMENT_RESULTS.Number_of_Patterns2_original =  Patterns2.Number_of_Patterns_original  ; 
         if ANALYSIS_ARG.Use_3_files
            ONE_EXPERIMENT_RESULTS.Number_of_Patterns3_original =  Patterns3.Number_of_Patterns_original  ; 
         end 
 %--------------------------
      
    ONE_EXPERIMENT_RESULTS.HiLo_Patterns1_2_enough_Low_responses=Hi_Lo_Patterns1_2_enough_Low_responses;
    ONE_EXPERIMENT_RESULTS.HiLo_Patterns1_2_enough_High_responses=Hi_Lo_Patterns1_2_enough_High_responses;
    
ONE_EXPERIMENT_RESULTS.HiLo_Patterns1_Low_Responses_number  = Patterns1.HiLo_Low_Responses_number   ;
 ONE_EXPERIMENT_RESULTS.HiLo_Patterns2_Low_Responses_number  =  Patterns2.HiLo_Low_Responses_number ; 

ONE_EXPERIMENT_RESULTS.HiLo_Patterns1_High_Responses_number =Patterns1.HiLo_High_Responses_number  ;
ONE_EXPERIMENT_RESULTS.HiLo_Patterns2_High_Responses_number = Patterns2.HiLo_High_Responses_number ;

ONE_EXPERIMENT_RESULTS.HiLo_Patterns1_Davies_Bouldin_TSR_Clustering_index =Patterns1.HiLo_Davies_Bouldin_TSR_Clustering_index  ;
ONE_EXPERIMENT_RESULTS.HiLo_Patterns2_Davies_Bouldin_TSR_Clustering_index = Patterns2.HiLo_Davies_Bouldin_TSR_Clustering_index ;    
    
        if ANALYSIS_ARG.Use_3_files
        ONE_EXPERIMENT_RESULTS.HiLo_Patterns2_3_enough_Low_responses =Hi_Lo_Patterns2_3_enough_Low_responses;
        ONE_EXPERIMENT_RESULTS.HiLo_Patterns2_3_enough_High_responses =Hi_Lo_Patterns2_3_enough_High_responses ;
        
         ONE_EXPERIMENT_RESULTS.HiLo_Patterns3_Low_Responses_number  =  Patterns3.HiLo_Low_Responses_number ;  
         ONE_EXPERIMENT_RESULTS.HiLo_Patterns3_High_Responses_number =  Patterns3.HiLo_High_Responses_number  ;
         
         ONE_EXPERIMENT_RESULTS.HiLo_Patterns3_Davies_Bouldin_TSR_Clustering_index = Patterns3.HiLo_Davies_Bouldin_TSR_Clustering_index ;    
        end
         
    
  
 %///////////////////////////////////////////////
 ONE_EXPERIMENT_RESULTS.TOTAL_RATE = TOTAL_RATE; 
 ONE_EXPERIMENT_RESULTS.TOTAL_RATE_High = TOTAL_RATE_High; 
 
         if ANALYSIS_ARG.Use_3_files
            ONE_EXPERIMENT_RESULTS.TOTAL_RATE_3files = TOTAL_RATE_3files ;
            ONE_EXPERIMENT_RESULTS.TOTAL_RATE_High_3files = TOTAL_RATE_High_3files ; 
        end
 %///////////////////////////////////////////////   
          

%------ Tactivation selectivity
        ONE_EXPERIMENT_RESULTS.T_act = T_act;  
        ONE_EXPERIMENT_RESULTS.T_act_High = T_act_High ;
        
        if ANALYSIS_ARG.Use_3_files
            ONE_EXPERIMENT_RESULTS.T_act_3files = T_act_3files ;
            ONE_EXPERIMENT_RESULTS.T_act_3files_High = T_act_3files_High ; 
        end
       %--- if analyzing 3 files -----------
%        
%                     ONE_EXPERIMENT_RESULTS.Ctrl2_Eff_Tact_total_number_of_active_electrodes 
%                     ONE_EXPERIMENT_RESULTS.Ctrl2_Eff_Tact_Stat_selective_electrodes_num  
%                     ONE_EXPERIMENT_RESULTS.Ctrl2_Eff_Tact_Stat_Selective_electrodes_precent
%                     ONE_EXPERIMENT_RESULTS.Ctrl2_Eff_Tact_Selective_electrodes_lin_div_num
%                     ONE_EXPERIMENT_RESULTS.Ctrl2_Eff_Tact_Selective_electrodes_lin_div_precent
%                     ONE_EXPERIMENT_RESULTS.Ctrl2_Eff_Tact_Overlaps_lin_div 
%  
%                     ONE_EXPERIMENT_RESULTS.Ctrl2_Eff_Tact_SVM_accuracy                     
%                     ONE_EXPERIMENT_RESULTS.Ctrl2_Eff_Tact_Clustering_error_precent_SVM 
%                     ONE_EXPERIMENT_RESULTS.Ctrl2_Eff_Tact_Not_distinguishable_points_num_SVM 

 
         
 
         
ONE_EXPERIMENT_RESULTS.SpikeRate = SpikeRate ;

ONE_EXPERIMENT_RESULTS.EL_SEL_stim_chan_to_extract = electrode_sel_param.stim_chan_to_extract  ;
 

RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.total_number_of_active_channels  ];
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.total_number_of_active_channels_precent ];
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.Number_of_Patterns1_original ];
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.Number_of_Patterns2_original ]; 

RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.HiLo_Patterns1_2_enough_Low_responses ];
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.HiLo_Patterns1_2_enough_High_responses ]; 
         if ANALYSIS_ARG.Use_3_files 
            RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.HiLo_Patterns2_3_enough_Low_responses ]; 
            RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.HiLo_Patterns2_3_enough_High_responses ];
         end        

RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.HiLo_Patterns1_Low_Responses_number ];
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.HiLo_Patterns2_Low_Responses_number ];  

         if ANALYSIS_ARG.Use_3_files
            RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.HiLo_Patterns3_Low_Responses_number ];  
         end          
         
         
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.HiLo_Patterns1_High_Responses_number ];
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.HiLo_Patterns2_High_Responses_number ];  

         if ANALYSIS_ARG.Use_3_files
            RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.HiLo_Patterns3_High_Responses_number ];  
         end        
         
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.HiLo_Patterns1_Davies_Bouldin_TSR_Clustering_index ]; 
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.HiLo_Patterns2_Davies_Bouldin_TSR_Clustering_index ]; 
            

         if ANALYSIS_ARG.Use_3_files  
            RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.HiLo_Patterns3_Davies_Bouldin_TSR_Clustering_index  ]; 
         end 
         
         
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.TOTAL_RATE.total_number_of_active_electrodes ];
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.TOTAL_RATE.TOTAL_RATE_stat_different_if_1 ];
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.TOTAL_RATE.psth_diff_rms ] ;
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.TOTAL_RATE.psth_diff_precent ] ;
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.TOTAL_RATE.Stat_selective_electrodes_num ];
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.TOTAL_RATE.Stat_Selective_electrodes_precent ] ;
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.TOTAL_RATE.Selective_electrodes_lin_div_num  ];

RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.TOTAL_RATE.Intersimilarity_Dissimilar_patterns_precent ];
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.TOTAL_RATE.Centroid_Error_precent ];
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.TOTAL_RATE.Clustering_error_precent_KMEANS  ];
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.TOTAL_RATE.Clustering_error_precent_SVM  ]; 





RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.TOTAL_RATE_High.total_number_of_active_electrodes ];
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.TOTAL_RATE_High.TOTAL_RATE_stat_different_if_1 ];
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.TOTAL_RATE_High.psth_diff_rms ] ;
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.TOTAL_RATE_High.psth_diff_precent ] ;
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.TOTAL_RATE_High.Stat_selective_electrodes_num ];
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.TOTAL_RATE_High.Stat_Selective_electrodes_precent ] ;
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.TOTAL_RATE_High.Selective_electrodes_lin_div_num  ];

RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.TOTAL_RATE_High.Intersimilarity_Dissimilar_patterns_precent ];
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.TOTAL_RATE_High.Centroid_Error_precent ];
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.TOTAL_RATE_High.Clustering_error_precent_KMEANS  ];
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.TOTAL_RATE_High.Clustering_error_precent_SVM  ]; 



RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.T_act.total_number_of_active_electrodes  ];
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.T_act.Stat_selective_channels_num_Tact  ];  
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.T_act.Stat_Selective_channels_percent_Tact  ];   
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.T_act.Selective_electrodes_lin_div_num  ];

RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.T_act.Intersimilarity_Dissimilar_patterns_precent];
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.T_act.Centroid_accuracy_precent ];
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.T_act.Clustering_accuracy_precent_KMEANS ];  
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.T_act.Clustering_error_precent_SVM ];
 
 


% RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.TOTAL_RATE.SVM_accuracy ];


RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.SpikeRate.Total_bins  ];
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.SpikeRate.STAT_Selectivity_Nbins_total ];
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.SpikeRate.STAT_Selectivity_Nbins_precent ];
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.SpikeRate.LINEARY_Selectivity_Nbins_total ];
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.SpikeRate.LINEARY_Selectivity_Nbins_precent ]; 
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.SpikeRate.SPIKE_RATE_1stBin_Centroid_Error_precent ];
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.SpikeRate.SPIKE_RATE_1stBin_Clustering_error_precent_KMEANS ];
RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.SpikeRate.SPIKE_RATE_1stBin_Clustering_error_precent_SVM  ];

RESULT=[RESULT  ONE_EXPERIMENT_RESULTS.SpikeRate.SPIKE_RATE_1stBin_Clustering_error_precent_SVM  ];
 
if Global_flags.cycle_all_electrodes 
RESULT=[RESULT  electrode_sel_param.stim_chan_to_extract ] ;
end

TOTAL_RATE_Overlaps_lin_div = ONE_EXPERIMENT_RESULTS.TOTAL_RATE.Channels_overlap'   ;
Tact_Overlaps_lin_div =ONE_EXPERIMENT_RESULTS.T_act.Channels_overlap';
LENGTH_TOTAL_RATE_Overlaps_lin_div = length( ONE_EXPERIMENT_RESULTS.TOTAL_RATE.Channels_overlap );
LENGTH_Tact_Overlaps_lin_div = length( ONE_EXPERIMENT_RESULTS.T_act.Channels_overlap );
% TOTAL_RATE_Overlaps_lin_div
% Tact_Overlaps_lin_div
%  SPIKE_RATE_OVERLAPS
 
 [ countsTOTAL_RATE_Overlaps_lin_div , xTOTAL_RATE ] = hist_desired( TOTAL_RATE.Channels_overlap ,5 ) ;
 [ countsTact_Overlaps_lin_div , xTact_Overlaps ] = hist_desired( T_act.Channels_overlap  ,5) ; 
 [ countsSPIKE_RATE_OVERLAPS , xSPIKE_RATE_OVERLAPS ] = hist_desired( SpikeRate.SPIKE_RATE_OVERLAPS ,5 ) ;
  [ countsFirstBIN_SPIKERATE_OVERLAPS , xFirstBIN_SPIKERATE_OVERLAPS ] = hist_desired( SpikeRate.SPIKE_RATE_OVERLAPS ,5 ) ;
  [ countsTOTAL_RATE_Overlaps_lin_div_bin2 , xTOTAL_RATE_bin2 ] = hist_desired( TOTAL_RATE.Channels_overlap ,2 ) ;
 [ countsTact_Overlaps_lin_div_bin2 , xTact_Overlaps_bin2 ] = hist_desired( T_act.Channels_overlap  ,2) ; 
 [ countsSPIKE_RATE_OVERLAPS_bin2 , xSPIKE_RATE_OVERLAPS_bin2 ] = hist_desired( SpikeRate.SPIKE_RATE_OVERLAPS ,2 ) ;
  [ countsFirstBIN_SPIKERATE_OVERLAPS_bin2 , xSPIKE_RATE_OVERLAPS_bin2 ] = hist_desired( SpikeRate.SPIKE_RATE_OVERLAPS ,2 ) ;
 
 countsSPIKE_RATE_OVERLAPS
 countsFirstBIN_SPIKERATE_OVERLAPS
countsTOTAL_RATE_Overlaps_lin_div
 countsTact_Overlaps_lin_div
 xTact_Overlaps
RESULT = RESULT';
RESULT 
Nb = Patterns1.Number_of_Patterns 
Nb2 = Patterns2.Number_of_Patterns  

eval(['save ANAlYSIS_2sets_compare_total_v2.mat ONE_EXPERIMENT_RESULTS -mat']); 




  end
  
  
if Nb < 4 & Nb2 < 4 
    RESULT(1)=0;
end    
  
       
              
 


toc




