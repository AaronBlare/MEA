
% Stim_response_Chambers_A_B_analyze_and_add

%   ChambersStim_A.artefacts_evoked_number = Patterns.Number_of_Patterns ;
%            ChambersStim_A.artefacts_evoked_index = [] ; 
%             if Global_flags.Stim_Search_Params.Shuffle_test 
%              ChambersStim_A = ChamberAB_shuffle_result ;
%              ChambersStim_A.artefacts_evoked_number = result.Chambers_A_B_evoked_burst_number ;
%              
%              ChambersStim_A.Timebin_srprofile = Patterns.TimeBin_Total_Spikes_mean ;
%               timebins= 1 :  Patterns.DT_bins_number ;
%                 timebins = (timebins-1) * Patterns.DT_bin ;
%              ChambersStim_A.Timebin_x = timebins;
%             end
% 
%             
%  ChambersStim_B.artefacts_evoked_number = Patterns.Number_of_Patterns ; 
%              ChambersStim_B.artefacts_evoked_index = [] ;
%              
%             if Global_flags.Stim_Search_Params.Shuffle_test 
%                  ChambersStim_B = ChamberAB_shuffle_result ;
%                  ChambersStim_B.artefacts_evoked_number = result.Chambers_A_B_evoked_burst_number ;
%                  
%                  ChambersStim_B.Timebin_srprofile = Patterns.TimeBin_Total_Spikes_mean ; 
%                timebins= 1 :  Patterns.DT_bins_number ;
%                 timebins = (timebins-1) * Patterns.DT_bin ;
%              ChambersStim_B.Timebin_x = timebins ;
%             end
            
%    POST_STIM_RESPONSE_A
%    POST_STIM_RESPONSE_B
%    POST_STIM_RESPONSE_chan
         
%         ANALYZED_DATA_A
%         ANALYZED_DATA_B
%         ANALYZED_DATA_Chan
 

%   new A-B shuffling analysis
% if Global_flags.Stim_Search_Params.Shuffle_test   
%  if params.ChambersStim_B_spont_analyzed
%    E1 = artefacts_origin ; 
%    E1_d = artefacts_origin ; E1_d(:) = Post_stim_interval_end ;
%    
%  % shuffle adequate responses only as stimulus artifacts
% %    E2 = Patterns.artefacts + Post_stim_interval_start ;
% %    E2_d = E1_d ;
%     
%     E2 = ANALYZED_DATA_B.burst_start   ;
%     E2_d = ANALYZED_DATA_B.BurstDurations;
%     
%     E2 = [ E2   POST_STIM_RESPONSE_B.artefacts' + Post_stim_interval_start ];
%     E2_d = [ E2_d  ;  E1_d  ];
%     % Now E1 = original artifacts (stimuli) and E2 - all spont and evoked
%     % bursts in the raster.
%     
%    %--------------------- 
%    
%    
%    %-------------------------------------
%  [ result ]= Events_delays_analysis_with_shuffling( E1 ,E1_d , E2 ,E2_d  ) ;
%  ChamberAB_shuffle_result = result ;
%  %-------------------------------------
%  
%  
% % A = struct('f1', 1, 'f2', 2, 'f3', 3);
% % B = struct('f1', 4, 'f2', 5);
% Chamber_analysis_struct = [] ;
% for fn = fieldnames(result)'
%    Chamber_analysis_struct.(fn{1}) = result.(fn{1});
% end
% 
% 
%  
%     ChamberAB_shuffle_result.artefacts_evoked_index = [];
%     ChamberAB_shuffle_result.artefacts_evoked_percent = 0 ;
%     ChamberAB_shuffle_result.artefacts_evoked_number = 0;
%     ChamberAB_shuffle_result.artefacts_evoked_bursts = []  ; 
%     
%  if ~isempty( E2 ) 
%     ChamberAB_shuffle_result.artefacts_evoked_index = [] ;
%     ChamberAB_shuffle_result.artefacts_evoked_percent = 0 ;
%     ChamberAB_shuffle_result.artefacts_evoked_number = 0 ;
%     ChamberAB_shuffle_result.artefacts_evoked_bursts = false  ; 
%     
% if result.Chambers_A_B_connection_exist
%     ChamberAB_shuffle_result.artefacts_evoked_index =   result.Chambers_A_B_evoked_burst_index( : , 1 ) ;
% % Number of stimuli evoked bursts
%     ChamberAB_shuffle_result.artefacts_evoked_percent = result.Chambers_A_B_evoked_percent ; 
% % Number of stimuli evoked bursts
%     ChamberAB_shuffle_result.artefacts_evoked_number = result.Chambers_A_B_evoked_burst_number ;     
% % Did stimuli evoked bursts
%     ChamberAB_shuffle_result.artefacts_evoked_bursts = result.Chambers_A_B_connection_exist  ; 
% end
%  end
%     
%  end
% end


%

%% A>B analysis------------------- 
         [Chambers_A_B_evoked ,ia,ib] = intersect( Chambers_A.artefacts_evoked_index , Chambers_B.artefacts_evoked_index ) ;  
         Chambers_A_B_evoked_number = length( Chambers_A_B_evoked ) ;
         Chambers_A_B_evoked_percent = 100 * length( Chambers_A_B_evoked ) / Chambers_A.artefacts_evoked_number ;
         if isnan( Chambers_A_B_evoked )
             Chambers_A_B_evoked = 0 ;
             Chambers_A_B_evoked_percent = 0 ;
         end
         
         if Chambers_A_B_evoked
         Sab_A = Chambers_A.Chambers_A_B_evoked_burst_index( ia , 2 ) ;         
         % Sab_A - index of AB evoked in artefacts of POST_STIM_RESPONSE_A
%          AB_i_A = Chambers_A.artefacts_evoked_index( Sia_A ) ;
         Sab_B = Chambers_B.Chambers_A_B_evoked_burst_index( ib , 2 ) ;
         % Sab_B - index of AB evoked in artefacts of POST_STIM_RESPONSE_B
%          AB_i_B = Chambers_B.artefacts_evoked_index( Sib_B ) ;

        Chambers_A_B_evoked_index_of_A_artefacts = Sab_A ; % index of AB responses in A artefacts
         if iscolumn( Sab_A)
             Sab_A = Sab_A' ;
         end
         
                  if iscolumn( Sab_B)
             Sab_B = Sab_B' ;
                  end
         
                  Sab_A = ia ;
                  Sab_B = ib ;
                  
         A_B_evoked_delays_A = Chambers_A.Chambers_A_B_evoked_delays( Sab_A );
         A_B_evoked_delays_B = Chambers_B.Chambers_A_B_evoked_delays( Sab_B );
         AB_delays_diff = A_B_evoked_delays_B - A_B_evoked_delays_A ;
         AB_delays_diff_mean = mean( AB_delays_diff );
         
         Chambers_A.artefacts_evoked_index_mod = Chambers_A.Chambers_A_B_evoked_burst_index( : , 2 ) ;
         Chambers_B.artefacts_evoked_index_mod = Chambers_B.Chambers_A_B_evoked_burst_index( : , 2 ) ;  
         
         SA = Chambers_A.Chambers_A_B_evoked_burst_number ;
         SB = Chambers_B.Chambers_A_B_evoked_burst_number ;
         Unique_AandB = unique( [Chambers_A.artefacts_evoked_index ; Chambers_B.artefacts_evoked_index] ) ;
         Chambers_AB_Nresponses_withoutAB = length(  Unique_AandB ) - Chambers_A_B_evoked_number ;
         Chambers_AB_Nresponses_withoutAB_percent = 100 * Chambers_AB_Nresponses_withoutAB / ( ...
             length( artefacts_origin )) ;
         else
             Chambers_A.artefacts_evoked_index_mod = [] ;
        	Chambers_B.artefacts_evoked_index_mod= [] ;
            Chambers_B.Chambers_A_B_evoked_burst_number = 0 ;
            Chambers_A_B_evoked_index_of_A_artefacts = [] ;
            AB_delays_diff = [] ;
            AB_delays_diff_mean = 0 ;
             Chambers_AB_Nresponses_withoutAB = 0 ;
            Chambers_AB_Nresponses_withoutAB_percent = 0 ; 
         
         end
         Chambers_A_div_B_responses = 0 ;
         if Chambers_B.Chambers_A_B_evoked_burst_number > 0
             Chambers_A_div_B_responses = Chambers_A.Chambers_A_B_evoked_burst_number  / ...
                 Chambers_B.Chambers_A_B_evoked_burst_number ; 
         end
         
         
%%  Timebins A B chan
 %----- save some chamber data to final data ------------
 
 %    POST_STIM_RESPONSE_A
%    POST_STIM_RESPONSE_B
%    POST_STIM_RESPONSE_chan
  
  
 % Stim response in A and B characteristics
%  Timebin_A_srprofile = POST_STIM_RESPONSE_A.TimeBin_Total_Spikes_mean ;
%  Timebin_A_srprofile_std = POST_STIM_RESPONSE_A.TimeBin_Total_Spikes_std ;
%               timebins= 1 :  POST_STIM_RESPONSE_A.DT_bins_number ;
%                 timebins = (timebins-1) * POST_STIM_RESPONSE_A.DT_bin ;
%  Timebin_x_ms = timebins;
%  
%  Timebin_B_srprofile = POST_STIM_RESPONSE_B.TimeBin_Total_Spikes_mean ;
%  Timebin_B_srprofile_std    = POST_STIM_RESPONSE_B.TimeBin_Total_Spikes_std ;
% Timebin_Axon_srprofile = POST_STIM_RESPONSE_chan.TimeBin_Total_Spikes_mean ;
%  Timebin_Axon_srprofile_std = POST_STIM_RESPONSE_chan.TimeBin_Total_Spikes_std ;
%  
  
 
  
 %    POST_STIM_RESPONSE_A
%    POST_STIM_RESPONSE_B
%    POST_STIM_RESPONSE_chan

 sr_div  =  POST_STIM_RESPONSE_A.DT_bin / 1000  ; % find firing rate each bin
 sr_div_A = sr_div * length( Global_flags.Search_Params.Chamber_A_electrodes );
 sr_div_ax = sr_div * numel( Global_flags.Search_Params.Chamber_channels_electrodes );
 sr_div_B = sr_div * numel( Global_flags.Search_Params.Chamber_B_electrodes );
     
  
 
  if Chambers_A_B_evoked_number > 0
All_srprofile = POST_STIM_RESPONSE_A.Spike_Rate_Patterns( : , : , ...
            Sab_A) ;
%  whos All_srprofile
 
 
A_srprofile = All_srprofile ;
% N_not_ax = 1 : N ;  
% N_not_ax( reshape( Global_flags.Search_Params.Chamber_A_electrodes , 1 , []) ) = [] ;
% A_srprofile( : , N_not_ax , : ) = 0 ;
A_srprofile = sum( A_srprofile , 2 );
A_srprofile = squeeze( A_srprofile );
A_srprofile_std = std( A_srprofile ,0 ,2 );
 A_srprofile = mean( A_srprofile ,2 );
 A_srprofile = A_srprofile( 1 : POST_STIM_RESPONSE_A.DT_bins_number ) ;
 A_srprofile_std = A_srprofile( 1 : POST_STIM_RESPONSE_A.DT_bins_number ) ;
 Chambers_A.A_srprofile = A_srprofile ;
        
All_srprofile = POST_STIM_RESPONSE_B.Spike_Rate_Patterns( : , : , ...
            Sab_B) ;
        B_srprofile = All_srprofile ;
% N_not_ax = 1 : N ;  
% N_not_ax( reshape( Global_flags.Search_Params.Chamber_B_electrodes , 1 , []) ) = [] ;
% B_srprofile( : , N_not_ax , : ) = 0 ;
B_srprofile = sum( B_srprofile , 2 );
B_srprofile = squeeze( B_srprofile );
B_srprofile_std = std( B_srprofile ,0 ,2 );
 B_srprofile = mean( B_srprofile ,2 );
 B_srprofile = B_srprofile( 1 : POST_STIM_RESPONSE_B.DT_bins_number ) ;
 Chambers_B.B_srprofile = B_srprofile ;
 
 All_srprofile = POST_STIM_RESPONSE_chan.Spike_Rate_Patterns( : , : , ...
            Chambers_A.artefacts_evoked_index) ;        
 ax_srprofile = All_srprofile ;
%  N_not_ax = 1 : N ;
%  N_not_ax( reshape( Global_flags.Search_Params.Chamber_channels_electrodes , 1 , []) ) = [] ;
%  ax_srprofile( : , N_not_ax , : ) = 0 ;
 ax_srprofile = sum( ax_srprofile , 2 );
 ax_srprofile = squeeze( ax_srprofile );
 ax_srprofile_std = std( ax_srprofile ,0 ,2 );
 ax_srprofile = mean( ax_srprofile ,2 );
 ax_srprofile = ax_srprofile( 1 : POST_STIM_RESPONSE_B.DT_bins_number ) ;
 Chambers_cham.ax_srprofile = ax_srprofile ;
 else
  B_srprofile = zeros(  POST_STIM_RESPONSE_B.DT_bins_number , 1 ); 
  ax_srprofile = zeros(  POST_STIM_RESPONSE_B.DT_bins_number , 1 );
  A_srprofile = zeros(  POST_STIM_RESPONSE_B.DT_bins_number , 1);
  A_srprofile_std = [];
 B_srprofile_std = [];
 ax_srprofile_std = [];
end
       
        Timebin_x_ms= 1 :  POST_STIM_RESPONSE_B.DT_bins_number ;
        Timebin_x_ms = (Timebin_x_ms-1) * POST_STIM_RESPONSE_B.DT_bin ;
 Timebin_A_srprofile = A_srprofile' ;
 Timebin_B_srprofile = B_srprofile' ;
 Timebin_Axon_srprofile = ax_srprofile' ;
 
 Timebin_A_srprofile_std = A_srprofile_std' ;
 Timebin_B_srprofile_std = B_srprofile_std' ;
 Timebin_Axon_srprofile_std = ax_srprofile_std' ;
 
 %% Responses compare
 % Only for A > B responses
 Chambers_A_B_Peak_A_ms = 0 ;
 Chambers_A_B_Peak_A_Hz= 0 ;
 Chambers_A_B_Peak_Chan_ms= 0 ;
 Chambers_A_B_Peak_Chan_Hz= 0 ;
 Chambers_A_B_Peak_B_ms= 0 ;
 Chambers_A_B_Peak_B_Hz= 0 ;
     Timebin_A_srprofile_firing_HZ = 0 * Timebin_A_srprofile / sr_div_A ;
     Timebin_Axon_srprofile_firing_HZ =0 *  Timebin_Axon_srprofile / sr_div_ax ;
     Timebin_B_srprofile_firing_HZ = 0 * Timebin_B_srprofile / sr_div_B ; 
     
 
 if Chambers_A_B_evoked_number > 0
     Timebin_A_srprofile_firing_HZ = Timebin_A_srprofile / sr_div_A ;
     Timebin_Axon_srprofile_firing_HZ = Timebin_Axon_srprofile / sr_div_ax ;
     Timebin_B_srprofile_firing_HZ = Timebin_B_srprofile / sr_div_B ;
     
      [A_srprofile_max , A_srprofile_max_i] = max( Timebin_A_srprofile_firing_HZ );
      Chambers_A_B_Peak_A_ms = Timebin_x_ms( A_srprofile_max_i );
      Chambers_A_B_Peak_A_Hz = Timebin_A_srprofile_firing_HZ( A_srprofile_max_i );
      
      [Axon_srprofile_max , Axon_srprofile_max_i] = max( Timebin_Axon_srprofile );
      if ~isempty( Axon_srprofile_max_i )
      Chambers_A_B_Peak_Chan_ms = Timebin_x_ms( Axon_srprofile_max_i );
      Chambers_A_B_Peak_Chan_Hz = Timebin_Axon_srprofile_firing_HZ( Axon_srprofile_max_i );end
      
      [B_srprofile_max , B_srprofile_max_i] = max( Timebin_B_srprofile );
      Chambers_A_B_Peak_B_ms = Timebin_x_ms( B_srprofile_max_i );
      Chambers_A_B_Peak_B_Hz = Timebin_B_srprofile_firing_HZ( B_srprofile_max_i );
 end
% A or B responses to stim
Chambers_A_Peak_ms= 0 ;
Chambers_Chan_Peak_ms= 0 ;
Chambers_B_Peak_ms= 0 ;

      [A_max , A_max_i] = max( POST_STIM_RESPONSE_A.TimeBin_Total_Spikes_mean );
      if ~isempty( A_max_i )
      Chambers_A_Peak_ms = Timebin_x_ms( A_max_i );  end
      
      [Chan_max , Chan_max_i] = max( POST_STIM_RESPONSE_B.TimeBin_Total_Spikes_mean );
      if ~isempty( Chan_max_i )
      Chambers_Chan_Peak_ms = Timebin_x_ms( Chan_max_i );  end

      [B_max , B_max_i] = max( POST_STIM_RESPONSE_B.TimeBin_Total_Spikes_mean );
      if ~isempty( B_max_i )
      Chambers_B_Peak_ms = Timebin_x_ms( B_max_i );  end
      
      Chambers_A_B_Peak_AandB_difference_ms = Chambers_B_Peak_ms - Chambers_A_Peak_ms ;
         
 %% Final results -------------------        
 
    % Only for A-B responses
    POST_STIM_RESPONSE.Chambers_A_B_evoked_number = Chambers_A_B_evoked_number ;
    POST_STIM_RESPONSE.Chambers_A_B_evoked_percent = Chambers_A_B_evoked_percent ;
    POST_STIM_RESPONSE.Chambers_A_B_evoked_index_of_A_artefacts = Chambers_A_B_evoked_index_of_A_artefacts ; % index of AB responses in A artefacts
    POST_STIM_RESPONSE.Chambers_A_B_evoked_delays_differencies = AB_delays_diff ; % Delay( stim-B) - Delay( stim-A)
    POST_STIM_RESPONSE.Chambers_A_B_evoked_delays_diff_mean = AB_delays_diff_mean ;
    POST_STIM_RESPONSE.Chambers_A_B_Nresponses_withoutAB = Chambers_AB_Nresponses_withoutAB ;
    POST_STIM_RESPONSE.Chambers_A_B_Nresponses_withoutAB_percent = Chambers_AB_Nresponses_withoutAB_percent;
    
    POST_STIM_RESPONSE.Chambers_A_B_Peak_A_ms = Chambers_A_B_Peak_A_ms ;
    POST_STIM_RESPONSE.Chambers_A_B_Peak_A_Hz = Chambers_A_B_Peak_A_Hz;
    POST_STIM_RESPONSE.Chambers_A_B_Peak_Chan_ms = Chambers_A_B_Peak_Chan_ms ;
    POST_STIM_RESPONSE.Chambers_A_B_Peak_Chan_Hz = Chambers_A_B_Peak_Chan_Hz ;
    POST_STIM_RESPONSE.Chambers_A_B_Peak_B_ms = Chambers_A_B_Peak_B_ms ;
    POST_STIM_RESPONSE.Chambers_A_B_Peak_B_Hz = Chambers_A_B_Peak_B_Hz ;
    POST_STIM_RESPONSE.Chambers_A_B_Peak_AtoB_difference_ms = Chambers_A_B_Peak_B_ms - Chambers_A_B_Peak_A_ms ; % only for A-B responses
    POST_STIM_RESPONSE.Chambers_A_B_Peak_AandB_difference_ms = Chambers_A_B_Peak_AandB_difference_ms ; % all B and A responses (may include AtoB
    
     % Chambers_A analyzed in Stim_response
     POST_STIM_RESPONSE.Chambers_A_shuffling_result = Chambers_A ; % in this struct A_B means Stim->A
%      POST_STIM_RESPONSE.Chambers_A_artefacts_evoked = Chambers_A.Chambers_A_B_connection_exist ;
     POST_STIM_RESPONSE.Chambers_A_artefacts_evoked_number = Chambers_A.Chambers_A_B_evoked_burst_number  ;
     POST_STIM_RESPONSE.Chambers_A_artefacts_evoked_percent = Chambers_A.Chambers_A_B_evoked_percent ;
%      POST_STIM_RESPONSE.Chambers_A_artefacts_evoked_index = in Chambers_A.Chambers_A_B_evoked_burst_index( : , 1 ) ; 
     POST_STIM_RESPONSE.Chambers_A_artefacts_evoked_index = Chambers_A.artefacts_evoked_index_mod ; % S-A in this patterns
  
     POST_STIM_RESPONSE.Chambers_B_shuffling_result = Chambers_B ; % in this struct A_B means Stim->A
%      POST_STIM_RESPONSE.Chambers_B_artefacts_evoked = Chambers_B.Chambers_A_B_connection_exist ;
     POST_STIM_RESPONSE.Chambers_B_artefacts_evoked_number = Chambers_B.Chambers_A_B_evoked_burst_number  ;
     POST_STIM_RESPONSE.Chambers_B_artefacts_evoked_percent = Chambers_B.Chambers_A_B_evoked_percent ;
%      POST_STIM_RESPONSE.Chambers_B_artefacts_evoked_index = in Chambers_B.Chambers_A_B_evoked_burst_index( : , 1 ) ; 
     POST_STIM_RESPONSE.Chambers_B_artefacts_evoked_index = Chambers_B.artefacts_evoked_index_mod ;
    POST_STIM_RESPONSE.Chambers_A_div_B_responses = Chambers_A_div_B_responses ;
     
    POST_STIM_RESPONSE.Timebin_x_ms = Timebin_x_ms ;
    POST_STIM_RESPONSE.Timebin_A_srprofile = Timebin_A_srprofile ;
    POST_STIM_RESPONSE.Timebin_B_srprofile = Timebin_B_srprofile ;
    POST_STIM_RESPONSE.Timebin_Axon_srprofile = Timebin_Axon_srprofile ;
    POST_STIM_RESPONSE.Timebin_A_srprofile_std = Timebin_A_srprofile_std ;
    POST_STIM_RESPONSE.Timebin_B_srprofile_std = Timebin_B_srprofile_std ;
    POST_STIM_RESPONSE.Timebin_Axon_srprofile_std = Timebin_Axon_srprofile_std ;
    
    POST_STIM_RESPONSE.Timebin_A_srprofile_firing_HZ = Timebin_A_srprofile_firing_HZ ;
    POST_STIM_RESPONSE.Timebin_B_srprofile_firing_HZ = Timebin_B_srprofile_firing_HZ  ;
    POST_STIM_RESPONSE.Timebin_Axon_srprofile_firing_HZ = Timebin_Axon_srprofile_firing_HZ ;      
     
     
  POST_STIM_RESPONSE.Chambers_chan = Chambers_cham ;
            
  POST_STIM_RESPONSE.POST_STIM_RESPONSE_A = POST_STIM_RESPONSE_A ;   
  POST_STIM_RESPONSE.POST_STIM_RESPONSE_B = POST_STIM_RESPONSE_B ;
  POST_STIM_RESPONSE.POST_STIM_RESPONSE_chan = POST_STIM_RESPONSE_chan ;
     
     
% Spont analysis characteristics of stim response             
 POST_STIM_RESPONSE.Chambers_A_spont_analyzed = params.ChambersStim_A_spont_analyzed  ;
 POST_STIM_RESPONSE.Chambers_B_spont_analyzed = params.ChambersStim_B_spont_analyzed  ;
%  POST_STIM_RESPONSE.Chambers_chan_spont_analyzed = params.ChambersStim_chan_spont_analyzed  ;
 
         if params.ChambersStim_A_spont_analyzed 
          ANALYZED_DATA_A   = Erase_big_data_from_ANALYZED_DATA( ANALYZED_DATA_A ) ;
          POST_STIM_RESPONSE.ANALYZED_DATA_A = ANALYZED_DATA_A ;
         end
        if params.ChambersStim_B_spont_analyzed          
            ANALYZED_DATA_B   = Erase_big_data_from_ANALYZED_DATA( ANALYZED_DATA_B ) ;
            POST_STIM_RESPONSE.ANALYZED_DATA_B = ANALYZED_DATA_B ;
        end
        
        if params.ChambersStim_chan_spont_analyzed 
          ANALYZED_DATA_Chan   = Erase_big_data_from_ANALYZED_DATA( ANALYZED_DATA_Chan ) ; 
        POST_STIM_RESPONSE.ANALYZED_DATA_Chan = ANALYZED_DATA_Chan ;
        end
        %-------------------------------------


        
        
        
        
        
        
