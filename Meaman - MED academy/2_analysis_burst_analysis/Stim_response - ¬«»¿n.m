% Stim_response
function [ POST_STIM_RESPONSE ] = Stim_response( Post_stim_interval_start ,Post_stim_interval_end , ...
    Take_all_spikes_after_stim , DT_bin , ...
      Artefact_channel, filename , SHOW_FIGURES , checkbox5msBin , Params )
 AskFileInput = false;
if  filename==0
AskFileInput = true;
end
 
 
Electrode_selection_extract_channel = false ;
     electrode_sel_param.stim_chan_to_extract = 28 ;
     electrode_sel_param.Start_channel = 2; % electrode selection started from
     electrode_sel_param.Stimuli_to_each_channel = 30 ; % stimuli to each channel
     electrode_sel_param.Channel_step = 4 ;
     electrode_sel_param.correct_protocol = false ;
 
Calc_Separated_Responses_and_show = true ;
 Calc_Separated_Responses_and_show_Many_clusters = true ;
 
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
       [pathname,name,ext,versn] = fileparts( filename ) ;
 end
    
 
if filename ~= 0
      
    [pathstr,name,ext,versn] = fileparts( filename ) ;
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
    [pathstr,name,ext,versn] = fileparts( filename ) ;
    Raster_file =[char(name) '_Post_' int2str(Post_stim_interval_start) '_stim_spikes_raster.txt' ] ;
% --/////// LOAD DATA -------------------------------------------------
 
 
if filename_art ~= 0
   
   
   
    if MED_file_raster_input == false
      artefacts = load( char( filename_art ) ) ; 
    end 
    N  = max(index_r( :,2) ); %Number of channels
    if N < 60
        N = 60 ;
    end
   
 
   
   
    extract_channel_index = find( artefacts( : , 2 ) == CHANNEL_art ) ;
    artefacts =  artefacts( extract_channel_index , 1 ) ;
    whos artefacts
   
                   if  Electrode_selection_extract_channel
                        delete_index = 1 : length( artefacts   )  ;
                        Number_of_artifacts = length( artefacts   ) 
                        Stimuli_to_each_channel =  electrode_sel_param.Stimuli_to_each_channel +1
                        Number_channels_in_Electrode_Selection = Number_of_artifacts / (Stimuli_to_each_channel  )
                        El_sel_extract_channel_patterns 
                        delete_index( leave_index ) = [] ;
                        artefacts  = artefacts(leave_index) ;
               end
   
    a= diff( artefacts ) ;
    min_Artefact_interval_ms = min( a) ;
    min_Artefact_interval_ms
   
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
%--- chechk if all artifacts are double=correctly written in NLearn
    if Adjust_artefact_times
      % Adjusts artifact times using 1 ms bin AWSR of raster -> finds max of
      % AWSR around each artifact time +- 1000 ms.
        Adjust_artifact_times_script
    end
 
%    Adjust_artefact_times = false ;
%    double_or_not = [] ;
%    for i =1 : length( artefacts )
%        x =  (mod(artefacts(i),1) == 0 ) ;
%    double_or_not = [ double_or_not  (~x)] ;
%    end
%    Adjust_artefact_times = ~ ( mean(double_or_not)) ;
%     if Adjust_artefact_times
%       % Adjusts artifact times using 1 ms bin AWSR of raster -> finds max of
%       % AWSR around each artifact time +- 1000 ms.
%         Adjust_artifact_times_script
%     end
   
   
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
%----- Extract responses -------------------   
    N_responses = length(artefacts) ;
    N_responses_original = N_responses ;
   
    burst_start = artefacts + Post_stim_interval_start ;
    burst_end = artefacts + Post_stim_interval_end ;   
    
   [ bursts , bursts_absolute , burst_activation , burst_activation_absolute ...
    bursts_amps , burst_activation_amps ,Spike_Rates ,Spike_Rates_each_burst,...
    One_sigma_in_channels , artefacts ] = Get_Responses_in_Interval( N , artefacts ,index_r ,Post_stim_interval_start , ...
    Post_stim_interval_end , Params );   
 
 
Show_random_pattern_responses( N,16 , index_r ,  artefacts , Post_stim_interval_start , Post_stim_interval_end ,DT_step   )
        %=======================================================================
        %=======================================================================
        %==== Check if we have two clusters of responses ====================
        if Calc_Separated_Responses_and_show
            if Calc_Separated_Responses_and_show_Many_clusters
                
                            var.use_selected_artifacts_list = true ;
                            artifact_list = 1 : length( artefacts);
                            var.selected_artifacts = artifact_list ;
                            var.filter_bad_responses = false ;  
                            
                                [ TimeBin_Total_Spikes ,  TimeBin_Total_Spikes_mean , TimeBin_Total_Spikes_std , ...
                               Data_Rate_Patterns1 ,  Data_Rate_Signature1 ,  ... 
                               Data_Rate_Signature1_std , Amps_per_channel_per_bin , Amps_Signature , Amps_Signature_std , TimeBin_Total_Amps , ...
                               TimeBin_Total_Amps_mean  , TimeBin_Total_Amps_std , var , delete_responses_index ]  ...
                                  = Get_PSTH_stats_1_pattern( N ,  length( var.selected_artifacts ) , bursts  ,    Post_stim_interval_start , Post_stim_interval_end  ...
                                    , DT_step , bursts_amps , var , artefacts  );
  
                             var.filter_bad_responses = false;

                %= Clustering - many clusters - Cluster all responses ================
%                     TimeBin_Total_Spikes should be defined
                    var.figure_title = 'Original responses' ;
                    Clustering_many_clusters_TimeBin_Total_Spikes 
                    
                    
                %=---------------- Clustering - many clusters ================
                
                            var.use_selected_artifacts_list = true ;
                            artifact_list = 1 : length( artefacts);
                            var.selected_artifacts = artifact_list ;
                            var.filter_bad_responses = true ;  
                            
                                 [ TimeBin_Total_Spikes ,  TimeBin_Total_Spikes_mean , TimeBin_Total_Spikes_std , ...
                                   Data_Rate_Patterns1 ,  Data_Rate_Signature1 ,  ... 
                                   Data_Rate_Signature1_std , Amps_per_channel_per_bin , Amps_Signature , Amps_Signature_std , TimeBin_Total_Amps , ...
                                   TimeBin_Total_Amps_mean  , TimeBin_Total_Amps_std , var , delete_responses_index ] ...
                                  = Get_PSTH_stats_1_pattern( N ,  length( var.selected_artifacts ) , bursts ,    Post_stim_interval_start , Post_stim_interval_end  ...
                                    , DT_step , bursts_amps , var , artefacts  );

                             artefacts = artefacts(  var.selected_artifacts );
                             responses_index = delete_responses_index ;
                             
                             Filtered_responses_num = length(responses_index)
                                 % responses_index shoulkd be defined
                                 % before call
                             Stimulus_responses_Delete_responses
                             
                             var.filter_bad_responses = false;    
                
                 %= Clustering - many clusters - show after filtering inadequate responses ================
%                     TimeBin_Total_Spikes should be defined
                    var.figure_title = 'Filtered Inadequate responses' ;
                    Clustering_many_clusters_TimeBin_Total_Spikes 
                %=---------------- Clustering - many clusters %================
            end         
                        
                        
                        
         %======================== Clustering - 2 clusters ================   
            
                [centers,clusters,errors,ind] = kmeans_clusters( Spike_Rates_each_burst , 2 , 15 );
                clusters = clusters{2,1};
                clusters_last=clusters ;
                Data1= Spike_Rates_each_burst( clusters == 1);
                Data2= Spike_Rates_each_burst( clusters == 2);
                if max(Data2) > max(Data1)
                    High_Responses_TSR_Threshold = floor((max(Data1)+min(Data2))/2)
                    High_Responses_Percent = 100* length( Data2 ) / length( Data1 )
                    Cluster1 = 1 ; Cluster2 = 2 ; 
                else
                    High_Responses_TSR_Threshold = floor((max(Data2)+min(Data1))/2)
                    High_Responses_Percent = 100* length( Data1 ) / length( Data2 )
                    Cluster1 = 2 ; Cluster2 = 1 ; 
                end
 
                Davies_Bouldin_TSR_Clustering_index = ind(2)
                squared_sum_of_errors_CLUSTERING_Spike_Rates_each_burst = errors(2) /10000
               
                %---- Find PSTH (TimeBin_Total_Spikes_mean) fro High
                %responses and then for low responses
                var.use_selected_artifacts_list = true ;
                artifact_list = 1 : length( artefacts);
                var.selected_artifacts = artifact_list(clusters == Cluster2);
                var.Spike_Rates_each_burst = Spike_Rates_each_burst ;
                
                    [  HIGH_TimeBin_Total_Spikes ,  HIGH_TimeBin_Total_Spikes_mean , HIGH_TimeBin_Total_Spikes_std , ...
                   HIGH_Data_Rate_Patterns1 ,  HIGH_Data_Rate_Signature1 ,  ...
                   HIGH_Data_Rate_Signature1_std , HIGH_Amps_per_channel_per_bin , HIGH_Amps_Signature , HIGH_Amps_Signature_std , HIGH_TimeBin_Total_Amps , ...
                   HIGH_TimeBin_Total_Amps_mean  , HIGH_TimeBin_Total_Amps_std  , var , delete_responses_index ] ...
                                  = Get_PSTH_stats_1_pattern( N ,  length( var.selected_artifacts ) , bursts ,    Post_stim_interval_start , Post_stim_interval_end  ...
                                    , DT_step , bursts_amps , var , artefacts  );
 
                   artifact_list = 1 : length( artefacts);
                var.selected_artifacts = artifact_list(clusters == Cluster1 );
                
                   [  LOW_TimeBin_Total_Spikes ,  LOW_TimeBin_Total_Spikes_mean , LOW_TimeBin_Total_Spikes_std , ...
                   LOW_Data_Rate_Patterns1 ,  LOW_Data_Rate_Signature1 ,  ...
                   LOW_Data_Rate_Signature1_std , LOW_Amps_per_channel_per_bin , LOW_Amps_Signature , LOW_Amps_Signature_std , LOW_TimeBin_Total_Amps , ...
                   LOW_TimeBin_Total_Amps_mean  , LOW_TimeBin_Total_Amps_std  , var , delete_responses_index ] ...
                                  = Get_PSTH_stats_1_pattern( N ,  length( var.selected_artifacts ) , bursts ,    Post_stim_interval_start , Post_stim_interval_end  ...
                                    , DT_step , bursts_amps , var , artefacts  );
                var.use_selected_artifacts_list = false ; 
                 
                 
             figure
             Nx = 2; Ny=2;
                    subplot(Ny,Nx,1)
                    hold on

                        [n, xout] = hist( [ Data1 ; Data2 ] , 30 );
                        bar( xout , n ) 
                        bar( High_Responses_TSR_Threshold , max(n) , 0.5 , 'r')
                        legend( 'Spikes in response', 'Response threshold')
                        hold off
                        title( 'Spike rates histogram')
                   
                    subplot(Ny,Nx,2)
                        hold on
                        plot( Data1 )
                        plot( Data2,'r' )
                        title( 'Separated responses')
                        xlabel('Stimulus ?')
                        ylabel('Spike rate')
                        hold off
 
                  subplot(Ny,Nx,3)
                    DT_bins_number = floor((Post_stim_interval_end - Post_stim_interval_start) / DT_step) ;
                    Start_t =  Post_stim_interval_start ; 
                    TimeBins = 0 : DT_bins_number-1 ; 
                    TimeBins_x = Start_t + TimeBins * DT_step ;
                    barwitherr2( HIGH_TimeBin_Total_Spikes_std , TimeBins_x  , HIGH_TimeBin_Total_Spikes_mean );
                         title( ['High reponses PSTH'  ', bin=' int2str( DT_step ) 'ms' ] )
                        xlabel( 'Post-stimulus time, ms')
                        ylabel( 'Spikes per bin')
                        if max( HIGH_TimeBin_Total_Spikes_mean ) > 1
                            axis( [ min( TimeBins_x  )- DT_step   max( TimeBins_x ) + DT_step   ...
                                0 1.2 * max(   HIGH_TimeBin_Total_Spikes_std) ...
                                 + max(  HIGH_TimeBin_Total_Spikes_mean) ] )
                        end
                  subplot(Ny,Nx,4)          
                    DT_bins_number = floor((Post_stim_interval_end - Post_stim_interval_start) / DT_step) ;
                    Start_t =  Post_stim_interval_start ; 
                    TimeBins = 0 : DT_bins_number-1 ; 
                    TimeBins_x = Start_t + TimeBins * DT_step ;
                    barwitherr2( LOW_TimeBin_Total_Spikes_std , TimeBins_x  , LOW_TimeBin_Total_Spikes_mean );
                         title( ['Low responses PSTH'  ', bin=' int2str( DT_step ) 'ms' ] )
                        xlabel( 'Post-stimulus time, ms')
                        ylabel( 'Spikes per bin')
                        if max( LOW_TimeBin_Total_Spikes_mean ) > 1
                            axis( [ min( TimeBins_x  )- DT_step   max( TimeBins_x ) + DT_step   ...
                                0 1.2 * max(   LOW_TimeBin_Total_Spikes_std) ...
                                 + max(  LOW_TimeBin_Total_Spikes_mean) ] )
                        end                 
                            
        end
        %=======================================================================
        %=======================================================================
        %=======================================================================
 
 
    Spike_Rates_each_channel_mean  = zeros(  N , 1 );
    Spike_Rates_each_channel_std  = zeros(  N , 1 );
    Spike_Rates_each_channel_zero_values_num  = zeros(  N , 1 );
    for ch = 1 : N 
       Spike_Rates_each_channel_mean( ch )  = mean(Spike_Rates(  : , ch ));
       Spike_Rates_each_channel_std( ch )  = std(Spike_Rates(  : , ch  ));
       Spike_Rates_each_channel_zero_values_num( ch ) = length( find( Spike_Rates(  : , ch ) ==0) ); 
    end
     NUMBER_OF_STIMULS = length( artefacts   );
     NUMBER_OF_STIMULS
      
    burst_activation_mean =zeros(  N , 1 ); 
    for CHANNEL_i = 1 :  N
        burst_activation_nonZeros = burst_activation(:,CHANNEL_i )  ;
        burst_activation_nonZeros=burst_activation_nonZeros( burst_activation_nonZeros > 0);
        burst_activation_mean( CHANNEL_i ) = mean(  burst_activation_nonZeros ) ; 
    end
 
     Mean_PostStim_spikes_all_electrodes = mean( Spike_Rates_each_burst  );
     STD_PostStim_spikes_all_electrodes = std( Spike_Rates_each_burst  );
     Mean_PostStim_spikes_all_electrodes ;
     STD_PostStim_spikes_all_electrodes ;
 
 var.Spike_Rates_each_burst = Spike_Rates_each_burst ;
    [  TimeBin_Total_Spikes ,  TimeBin_Total_Spikes_mean , TimeBin_Total_Spikes_std , ...
   Data_Rate_Patterns1 ,  Data_Rate_Signature1 ,  ...
   Data_Rate_Signature1_std , Amps_per_channel_per_bin , Amps_Signature , Amps_Signature_std , TimeBin_Total_Amps , ...
   TimeBin_Total_Amps_mean  , TimeBin_Total_Amps_std  , var , delete_responses_index ] ...
         = Get_PSTH_stats_1_pattern( N ,  length( var.selected_artifacts ) , bursts ,    Post_stim_interval_start , Post_stim_interval_end  ...
             	, DT_step , bursts_amps , var , artefacts  );
 
    fire_bins = floor((Post_stim_interval_end - Post_stim_interval_start) / DT_step) ;
 
    Nb = length( artefacts   ) ;
   
%------------------------------------
%-------------RS values--------------
    Max_pause_for_RSreset_ms = 50000 ; % 200000 = 200 sec;    
    [ RS_values RS_current ]  = Get_RS_Values_from_SpikeRate(  N, Spike_Rates , ...
                artefacts , Max_pause_for_RSreset_ms , Nb  )        ;
 
    RS_values_total = RS_values;
    RS_all_channels_all_responses = RS_current ;
 
    RS_values_mean= zeros( 1 , N  );
    RS_values_std= zeros( 1 , N  );
     for ch = 1 : N 
        RS_values_mean(ch) = mean( RS_current( :,ch));
        RS_values_std(ch) = std( RS_current( :,ch));
     end
%-----------------------------------
%-----------------------------------
 
 
%------ Burst analysis --------------------------
 
if Params.Analyze_preceding_spont_bursts
   
 
   
   
Analyze_preBursts_to_stim
 
end
%------------------------------------------------
PostResp_Flags(1) = 1 ; % Version of POST_STIM_RESPONSE data    
 
 
    POST_STIM_RESPONSE.burst_activation =    burst_activation ;            % first spikes relative to burst begin
    POST_STIM_RESPONSE.burst_activation_mean = burst_activation_mean ;
    POST_STIM_RESPONSE.burst_activation_absolute =burst_activation_absolute;       % first spikes relative to 0 time
    POST_STIM_RESPONSE.bursts_absolute =bursts_absolute;                 %  spikes relative to burst begin
    POST_STIM_RESPONSE.bursts =bursts;                          %  spikes relative to 0
    POST_STIM_RESPONSE.burst_start = burst_start ;
    POST_STIM_RESPONSE.burst_end = burst_end ;
    POST_STIM_RESPONSE.One_sigma_in_channels  =One_sigma_in_channels;          %  sigma value for each channel
    POST_STIM_RESPONSE.burst_activation_amps =burst_activation_amps;           %  spike amps in first spikes
    POST_STIM_RESPONSE.bursts_amps  =bursts_amps;                    %  spike amps in bursts
    POST_STIM_RESPONSE.artefacts  =artefacts;                      %  artefact times
    POST_STIM_RESPONSE.NUMBER_OF_STIMULS =NUMBER_OF_STIMULS;               %  number of artefacts
    POST_STIM_RESPONSE.NUMBER_OF_STIMULS_original  = N_responses_original ;
    POST_STIM_RESPONSE.Number_of_Patterns =NUMBER_OF_STIMULS;               %  number of patternss
    POST_STIM_RESPONSE.N_channels = N ; % Number of channels
   
    POST_STIM_RESPONSE.Amps_per_channel_per_bin = Amps_per_channel_per_bin ;
    POST_STIM_RESPONSE.Amps_Signature = Amps_Signature ;
    POST_STIM_RESPONSE.Amps_Signature_std = Amps_Signature_std ;  
 
    POST_STIM_RESPONSE.RS_values_total =    RS_values_total ;   
    POST_STIM_RESPONSE.RS_all_channels_all_responses = RS_all_channels_all_responses ;
    POST_STIM_RESPONSE.RS_values_mean = RS_values_mean ; % zeros( 1 , N  );
    POST_STIM_RESPONSE.RS_values_std = RS_values_std ; % zeros( 1 , N  );
    POST_STIM_RESPONSE.Spike_Rates = Spike_Rates ; % number of spikes after each stimuli on each electrode 
    POST_STIM_RESPONSE.Spike_Rates_per_channel_per_bin =  Data_Rate_Patterns1 ; % number of spikes in each chennel,bin,burst
    POST_STIM_RESPONSE.Spike_Rates_each_burst   =Spike_Rates_each_burst ;  %  spikes number per burst at all channels   
    POST_STIM_RESPONSE.Spike_Rates_each_burst_mean = Mean_PostStim_spikes_all_electrodes ;
    POST_STIM_RESPONSE.Spike_Rates_each_burst_std = STD_PostStim_spikes_all_electrodes ;
    POST_STIM_RESPONSE.Spike_Rates_each_channel_mean = Spike_Rates_each_channel_mean ;
    POST_STIM_RESPONSE.Spike_Rates_each_channel_std = Spike_Rates_each_channel_std ;
    POST_STIM_RESPONSE.Spike_Rates_each_channel_zero_values_num = Spike_Rates_each_channel_zero_values_num ;
    POST_STIM_RESPONSE.Spike_Rates_Signature = Data_Rate_Signature1 ; % DT_bins number x 64
    POST_STIM_RESPONSE.Spike_Rates_Signature_std = Data_Rate_Signature1_std ; % DT_bins number x 64
   
    POST_STIM_RESPONSE.TimeBin_Total_Amps = TimeBin_Total_Spikes ; % Ns x DT_bins number
    POST_STIM_RESPONSE.TimeBin_Total_Amps_mean = TimeBin_Total_Spikes_mean ;  % 1 x DT_bins number
    POST_STIM_RESPONSE.TimeBin_Total_Amps_std = TimeBin_Total_Amps_std ;
   
    POST_STIM_RESPONSE.TimeBin_Total_Spikes = TimeBin_Total_Spikes ; % Ns x DT_bins number
    POST_STIM_RESPONSE.TimeBin_Total_Spikes_mean = TimeBin_Total_Spikes_mean ;  % 1 x DT_bins number
    POST_STIM_RESPONSE.TimeBin_Total_Spikes_std = TimeBin_Total_Spikes_std ;  % 1 x DT_bins number 
    POST_STIM_RESPONSE.DT_bin = DT_step ; % Used for TimeBin_Total_Spikes_mean, ...
    POST_STIM_RESPONSE.DT_bins_number = fire_bins ; % Used for TimeBin_Total_Spikes_mean, ...
   
    POST_STIM_RESPONSE.Poststim_interval_START =  Post_stim_interval_start ;
    POST_STIM_RESPONSE.Poststim_interval_END = Post_stim_interval_end  ;
    POST_STIM_RESPONSE.Poststim_interval_DURATION = Post_stim_interval_end - Post_stim_interval_start ;
        
    POST_STIM_RESPONSE.Flags = PostResp_Flags ;% additional parameters
 
 %--------------- SAVING FILES ---------------------------------  
     Postfix='';
  if  Electrode_selection_extract_channel 
     
     Postfix = [ '_ElSel_channel_' num2str( electrode_sel_param.stim_chan_to_extract ) ];
  end
  
     [pathstr,name,ext,versn] = fileparts( filename ) ;
finame = [ '_' name '_Post_' int2str(Post_stim_interval_start) '-' int2str(Post_stim_interval_end) 'ms_Stimlus_responses' Postfix '.mat' ] ;
 
eval(['save ' char( finame ) ' POST_STIM_RESPONSE -mat']);
 
 
 
 
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
    [index_r_from_DB , Raster_exists ,Raster_exists_with_other_sigma , Sigma_threshold_exists ] = ...
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
 
 
 
fullname = [pathname  finame];
fullname
FILENAME
%--------------------------
 
 
       
 
 
 
 
 
 
 
 
 
if SHOW_FIGURES
   
   
 
  Post_stim_response_MAIN_analysis_FIGURE_script
   
 
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
      err = Spike_Rates_each_channel_std' ;
      y = Spike_Rates_each_channel_mean' ;
        barwitherr(  err ,chan , y     );
                axis( [ min(chan) max(chan) 0 1.2 * max(err) ...
             + max(y) ] );
        xlabel( 'Electrode #')
        ylabel('Mean, STD spike rate')
       
        subplot(2,1,2)  
       
       
%         Number_of_BINs_SpikeRate_Hist = 20 ;
       
       
        SpikeRates_total = [];
        for CHANNEL_i = 1:N
            SpikeRates_total =[ SpikeRates_total ; Spike_Rates( : , CHANNEL_i) ] ;
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
           handles  = barwitherr2(TimeBin_Total_Spikes_std , TimeBins_x  , TimeBin_Total_Spikes_mean  );
             axis( [ min( TimeBins_x )-DT_step max( TimeBins_x ) + DT_step  ...
                 0 1.2 * max(TimeBin_Total_Spikes_mean) ...
                     + max(TimeBin_Total_Spikes_std) ] )
    %          title( ['PSTH, bin=' int2str( BIN ) 'ms' ] )
         errorbar_tick(handles.h,240 )
         title( ['PSTH, ' int2str( Post_stim_interval_start) '-' int2str( Post_stim_interval_end) 'ms, Bin='  int2str( DT_step ) 'ms' ] )        
            xlabel( 'Post-stimulus time, ms')
 
 
                subplot( 2 , 1 , 2 );
%                 TimeBins = 0 : DT_bins_number-1 ; 
           handles  =  barwitherr2(TimeBin_Total_Amps_std , TimeBins_x  , TimeBin_Total_Amps_mean  );
             axis( [ min( TimeBins_x )-DT_step max( TimeBins_x ) + DT_step  ...
                 min(TimeBin_Total_Amps_mean) ...
                     - 1.2* max(TimeBin_Total_Amps_std) 0 ] )
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
end 
end
   
cd( init_dir ) ;
end
