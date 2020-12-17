% Chambers_A_B_analyze_and_add
% input ANALYZED_DATA ANALYZED_DATA_A ANALYZED_DATA_B
% output : ANALYZED_DATA
 
show_figures = SHOW_FIGURES ;
 
% delay_thresh =  Global_flags.Search_Params.Chamber_AB_min_delay ;
%  
% A_B_evoked = 0 ;
% A_B_evoked_delays = [] ;
% A_B_or_B_A_delays = [] ;
% A_B_evoked_burst_index = [];
% for ai = 1 :  ANALYZED_DATA_A.Number_of_Patterns
%     delays = [] ;
%     found_post = false ;
%     found_pre = false ;
%     for bi = 1 :  ANALYZED_DATA_B.Number_of_Patterns
%         if ~found_post
%            ai_s = ANALYZED_DATA_A.burst_start( ai ) ;
%            ai_e = ANALYZED_DATA_A.burst_end( ai ) ;
%            bi_s = ANALYZED_DATA_B.burst_start( bi ) ;
%         if bi_s > ai_s+ delay_thresh && bi_s < ai_e + delay_thresh
%             A_B_evoked = A_B_evoked + 1 ;
%             ai_bi_pair = [ ai bi ] ;
%             A_B_evoked_delays = [A_B_evoked_delays bi_s - ai_s ] ;
%             A_B_or_B_A_delays =[ A_B_or_B_A_delays bi_s - ai_s ] ;
%             A_B_evoked_burst_index = [ A_B_evoked_burst_index ; ai_bi_pair ] ;
%             found_post = true ;
%         end 
%         end
%         
%         if ~found_pre
%            ai_s = ANALYZED_DATA_A.burst_start( ai ) ;
%            ai_e = ANALYZED_DATA_A.burst_end( ai ) ;
%            bi_e = ANALYZED_DATA_B.burst_end( bi ) ;
%         if ai_s > bi_s+ delay_thresh && ai_s < bi_e + delay_thresh  
%             A_B_or_B_A_delays =[ A_B_or_B_A_delays ai_s - bi_s  ] ; 
%             found_pre = true ;
%         end 
%         end
%         
%     end
% end
%  
% %- B-A evoked
% B_A_evoked = 0 ;
% B_A_evoked_delays = [] ;
% B_A_evoked_burst_index = [];
% for ai = 1 :  ANALYZED_DATA_A.Number_of_Patterns
%     delays = [] ;
%     found = false ;
%     for bi = 1 :  ANALYZED_DATA_B.Number_of_Patterns
%         if ~found
%        ai_s = ANALYZED_DATA_A.burst_start( ai ) ;
%        ai_e = ANALYZED_DATA_A.burst_end( ai ) ;
%        bi_s = ANALYZED_DATA_B.burst_start( bi ) ;
%        bi_e = ANALYZED_DATA_B.burst_end( bi ) ;
%         if ai_s > bi_s+ delay_thresh && ai_s < bi_e + delay_thresh
%             B_A_evoked = B_A_evoked + 1 ;
%             bi_ai_pair = [  ai bi ] ;
%             B_A_evoked_delays = [B_A_evoked_delays ai_s - bi_s    ] ;
%             B_A_evoked_burst_index = [ B_A_evoked_burst_index ; bi_ai_pair ] ;
%             found = true ;
%         end 
%         end
%     end
% end


%% Analyze connectivity in chaanels

if  Global_flags.Search_Params.Chambers_analyzeConnectivty
Bursts_AB_analyze_connectivity
end

%% Evoked bursts delays analysis with shuffling

Bursts_AB_delays_analysis_with_shuffling
%  A_B_evoked_burst_index = A_B_evoked_burst_index_AB ;
%  B_A_evoked_burst_index = A_B_evoked_burst_index_BA ;
 
 %% Axon signal analysis
 
% Chambers_axon_signal_analysis
 
 
%     Spike_Rate_Signature = Spike_Rate_Signature';
if exist( 'Spike_Rate_Signature_1ms_smooth' , 'var')
    Spike_Rate_Signature = Spike_Rate_Signature_1ms_smooth' ;
    DT_step_plot = 1 ;
else
    Spike_Rate_Signature = Spike_Rate_Signature' ;
    DT_step_plot = DT_BIN_ms ;
end
%     Spike_Rate_Signature = Spike_Rate_Signature_1ms';
 
%-- A->B axons
    Spike_Rate_Signature = ANALYZED_DATA_AB.Spike_Rates_Signature   ;
   
    s=size( Spike_Rate_Signature ) ;
    if s(2) == N
        Spike_Rate_Signature = Spike_Rate_Signature' ;
        s=size( Spike_Rate_Signature ) ;
    end
   
   
Axon_chan = Global_flags.Search_Params.Chamber_channels_electrodes ;
sa = size( Axon_chan );
N_axons = sa(1);
Chan_per_axon = sa(2);
 
Bins_num = s(2);
Bins_num =6  ;
 
% figure 'Bursts A->B, Axon spikes' ;
Nx =  3 ; Ny = 3  ;
if ~isempty( Spike_Rate_Signature ) 
f = figure ;
figure_title  = 'Bursts A->B, Axon spikes' ;
 set(f, 'name', figure_title , 'numbertitle','off' )


for ai = 1 : N_axons
    Axon_Signature=[];
%     ai = 1 ;
 xa= 1: Bins_num ; ya = 1:Chan_per_axon;
    for cha = 1 : Chan_per_axon
    Axon_Signature = [Axon_Signature ; Spike_Rate_Signature( Axon_chan( ai , cha ) , :)];
    end
 
        xa= 1: Bins_num ; ya = 1:Chan_per_axon;
      subplot( Ny , Nx , ai )
        imagesc(  xa *DT_step_plot  , ya ,  Axon_Signature( : , xa )  );
        title( [ 'Axon #(' num2str(ai) ' ' ] );
        xlabel( 'Time offset, ms' )
        ylabel( 'Electrode #' )
        colorbar
       
end
end
% B->A axons
 
    Spike_Rate_Signature = ANALYZED_DATA_BA.Spike_Rates_Signature   ;
   
    s=size( Spike_Rate_Signature ) ;
    if s(2) == N
        Spike_Rate_Signature = Spike_Rate_Signature' ;
        s=size( Spike_Rate_Signature ) ;
    end
   
   
Axon_chan = Global_flags.Search_Params.Chamber_channels_electrodes ;
sa = size( Axon_chan );
N_axons = sa(1);
Chan_per_axon = sa(2);
 
Bins_num = s(2);
Bins_num =6  ;

% figure 'Bursts B->A, Axon spikes' ;

Nx =  3 ; Ny = 3  ;
if ~isempty( Spike_Rate_Signature ) 
f = figure ;
figure_title  = 'Bursts B->A, Axon spikes' ;
 set(f, 'name', figure_title , 'numbertitle','off' )
 
for ai = 1 : N_axons
    Axon_Signature= [];
%     ai = 1 ;
 xa= 1: Bins_num ; ya = 1:Chan_per_axon;
    for cha = 1 : Chan_per_axon
    Axon_Signature = [Axon_Signature ; Spike_Rate_Signature( Axon_chan( ai , cha ) , :)];
    end
 
        xa= 1: Bins_num ; ya = 1:Chan_per_axon;
      subplot( Ny , Nx , ai )
        imagesc(  xa *DT_step_plot  , ya ,  Axon_Signature( : , xa )  );
        title( [ 'Axon #(' num2str(ai) ' ' ] );
        xlabel( 'Time offset, ms' )
        ylabel( 'Electrode #' )
        colorbar
       
end
end
 
%% results
% ANALYZED_DATA.ANALYZED_DATA_A = ANALYZED_DATA_A ;
% ANALYZED_DATA.ANALYZED_DATA_B = ANALYZED_DATA_B ;
% ANALYZED_DATA.ANALYZED_DATA_AB = ANALYZED_DATA_AB ;
% ANALYZED_DATA.ANALYZED_DATA_BA = ANALYZED_DATA_BA ;

% Firing rate
ANALYZED_DATA.Chambers_A_Spikes_per_sec   = ANALYZED_DATA_A.Spikes_per_sec ;
ANALYZED_DATA.Chambers_B_Spikes_per_sec  = ANALYZED_DATA_B.Spikes_per_sec ;
ANALYZED_DATA.Chambers_AB_Spikes_per_sec   = ANALYZED_DATA_A.Spikes_per_sec +  ANALYZED_DATA_B.Spikes_per_sec ;
ANALYZED_DATA.Chambers_chan_Spikes_per_sec  = ANALYZED_DATA_Chan.Spikes_per_sec ;
 
ANALYZED_DATA.Chambers_AB_Firing_rate_per_electrode_Hz   = (ANALYZED_DATA_A.Firing_rate_per_channel ...
        +  ANALYZED_DATA_B.Firing_rate_per_channel )/2 ;
ANALYZED_DATA.Chambers_chan_Firing_rate_per_electrode_Hz  = ANALYZED_DATA_Chan.Firing_rate_per_channel ;  

AdivB = 0 ;
if ANALYZED_DATA.Chambers_AB_Spikes_per_sec  ~= 0 
AdivB = ANALYZED_DATA.Chambers_chan_Firing_rate_per_electrode_Hz / ...
    ANALYZED_DATA.Chambers_AB_Firing_rate_per_electrode_Hz ;
end

ANALYZED_DATA.Chambers_chan_div_AB_Firing_rate_per_electrode_Hz =  AdivB ;

% Amps all spikes
ANALYZED_DATA.Chambers_A_Amps_mean_all_spikes = ANALYZED_DATA_A.Amps_mean_all_spikes ;
ANALYZED_DATA.Chambers_B_Amps_mean_all_spikes = ANALYZED_DATA_B.Amps_mean_all_spikes ;
ANALYZED_DATA.Chambers_A_Amps_median_all_spikes = ANALYZED_DATA_A.Amps_median_all_spikes ;
ANALYZED_DATA.Chambers_B_Amps_median_all_spikes = ANALYZED_DATA_B.Amps_median_all_spikes ;
 
ANALYZED_DATA.Chambers_AB_Amps_mean_all_spikes = (ANALYZED_DATA_A.Amps_mean_all_spikes + ...
                                                ANALYZED_DATA_B.Amps_mean_all_spikes ) / 2; 
                                            
ANALYZED_DATA.Chambers_chan_Amps_mean_all_spikes = ANALYZED_DATA_Chan.Amps_mean_all_spikes ;

ANALYZED_DATA.Chambers_Amps_chan_div_AB_all_spikes = ANALYZED_DATA.Chambers_chan_Amps_mean_all_spikes / ...
            ANALYZED_DATA.Chambers_AB_Amps_mean_all_spikes ;

%  Bursts per min
ANALYZED_DATA.Chambers_B_Nbursts =  ANALYZED_DATA_B.Number_of_Patterns ;
ANALYZED_DATA.Chambers_A_Nbursts =  ANALYZED_DATA_A.Number_of_Patterns ;
ANALYZED_DATA.Chambers_chan_Nbursts  = ANALYZED_DATA_Chan.Number_of_Patterns ;  
  Chambers_AB_Nbursts_withoutAB = ( ANALYZED_DATA_A.Number_of_Patterns + ANALYZED_DATA_B.Number_of_Patterns ... 
    - ANALYZED_DATA.Chambers_B_A_evoked_number  - ANALYZED_DATA.Chambers_A_B_evoked_number ) ;
ANALYZED_DATA.Chambers_AB_Nbursts_withoutAB = Chambers_AB_Nbursts_withoutAB ;

ANALYZED_DATA.Chambers_A_Nbursts_per_min =  ANALYZED_DATA_A.Bursts_per_min ;
ANALYZED_DATA.Chambers_B_Nbursts_per_min =  ANALYZED_DATA_B.Bursts_per_min ;
ANALYZED_DATA.Chambers_chan_Nbursts_per_min =  ANALYZED_DATA_Chan.Bursts_per_min ;
ANALYZED_DATA.Chambers_AB_Nbursts_per_min_withoutAB = ANALYZED_DATA.Chambers_AB_Nbursts_withoutAB / ...
        ( ANALYZED_DATA.Raster_duration_sec/ 60 ) ; 

AdivB = 0 ;
if ANALYZED_DATA_B.Bursts_per_min ~= 0 
AdivB = ANALYZED_DATA_A.Bursts_per_min / ANALYZED_DATA_B.Bursts_per_min;
end

ANALYZED_DATA.Chambers_A_div_B_Nbursts_per_min =  AdivB ;


% Amps peer bursts
ANALYZED_DATA.Chambers_A_Amp_mean_bursts  = ANALYZED_DATA_A.Amps_mean_burst ;
ANALYZED_DATA.Chambers_B_Amp_mean_bursts  = ANALYZED_DATA_B.Amps_mean_burst ;
ANALYZED_DATA.Chambers_AB_Amp_mean_bursts  = ...
            (ANALYZED_DATA_A.Amps_mean_burst + ANALYZED_DATA_B.Amps_mean_burst)/2 ;
ANALYZED_DATA.Chambers_chan_Amp_mean_bursts  = ANALYZED_DATA_Chan.Amps_mean_burst ; 
if ~isempty( ANALYZED_DATA.Chambers_AB_Amp_mean_bursts )
    if ANALYZED_DATA.Chambers_AB_Amp_mean_bursts > 0
ANALYZED_DATA.Chambers_Amps_chan_div_AB_bursts = ANALYZED_DATA.Chambers_chan_Amp_mean_bursts / ...
            ANALYZED_DATA.Chambers_AB_Amp_mean_bursts ;
    end
end

% ANALYZED_DATA.  = ANALYZED_DATA_A.
% ANALYZED_DATA.  = ANALYZED_DATA_A.
% ANALYZED_DATA.  = ANALYZED_DATA_A.
% ANALYZED_DATA.  = ANALYZED_DATA_A.
% ANALYZED_DATA.  = ANALYZED_DATA_A.
% ANALYZED_DATA.  = ANALYZED_DATA_A.

% ANALYZED_DATA.Chambers_A_B_connection_exist = true ;
% ANALYZED_DATA.Chambers_A_B_evoked = A_B_evoked ; % number of A evoked B
% ANALYZED_DATA.Chambers_A_B_evoked_percent = 100 * A_B_evoked  / ANALYZED_DATA_A.Number_of_Patterns ; % percent of A evoked B
% ANALYZED_DATA.Chambers_A_B_evoked_burst_index = A_B_evoked_burst_index ; % [ ai -> bi ], ai - from ANALYZED_DATA_A, bi - from ANALYZED_DATA_B ;
% ANALYZED_DATA.Chambers_A_B_evoked_delays = A_B_evoked_delays ; % delays between A start and B start [ 100 150 ... ] ;
% ANALYZED_DATA.Chambers_A_B_evoked_mean_delay = mean( A_B_evoked_delays ) ; % mean delays between A->B
%  
% ANALYZED_DATA.Chambers_B_A_connection_exist = true ;
% ANALYZED_DATA.Chambers_B_A_evoked = B_A_evoked ; % number of A evoked B
% ANALYZED_DATA.Chambers_B_A_evoked_percent = 100 * B_A_evoked  / ANALYZED_DATA_A.Number_of_Patterns ; % percent of A evoked B
% ANALYZED_DATA.Chambers_B_A_evoked_burst_index = B_A_evoked_burst_index ; % [ ai <- bi ], ai - from ANALYZED_DATA_A, bi - from ANALYZED_DATA_B ;
% ANALYZED_DATA.Chambers_B_A_evoked_delays = B_A_evoked_delays ; % delays between A start and B start [ 100 150 ... ] ;
% ANALYZED_DATA.Chambers_B_A_evoked_mean_delay = mean( B_A_evoked_delays ) ; % mean delays between A->B
 
 
 
%% A->B spikerate profile
 sr_div  =  ANALYZED_DATA_A.DT_bin / 1000  ; % find firing rate each bin
 sr_div_A = sr_div * length( Global_flags.Search_Params.Chamber_A_electrodes );
 sr_div_ax = sr_div * numel( Global_flags.Search_Params.Chamber_channels_electrodes );
 sr_div_B = sr_div * numel( Global_flags.Search_Params.Chamber_B_electrodes );
 
  if ANALYZED_DATA.Chambers_A_B_evoked_percent > 0
All_srprofile = ANALYZED_DATA_AB.Spike_Rate_Patterns( : , : , ...
            ANALYZED_DATA.Chambers_A_B_evoked_burst_index( : , 1 )) ;
 whos All_srprofile
 
 
A_srprofile = All_srprofile ;
N_not_ax = 1 : N ;  
N_not_ax( reshape( Global_flags.Search_Params.Chamber_A_electrodes , 1 , []) ) = [] ;
A_srprofile( : , N_not_ax , : ) = 0 ;
A_srprofile = sum( A_srprofile , 2 );
A_srprofile = squeeze( A_srprofile );
A_srprofile_std = std( A_srprofile ,0 ,2 );
 A_srprofile = mean( A_srprofile ,2 );
 A_srprofile = A_srprofile( 1 : ANALYZED_DATA_A.DT_BINS_number ) ;
 A_srprofile_std = A_srprofile( 1 : ANALYZED_DATA_A.DT_BINS_number ) ;
        
B_srprofile = All_srprofile ;
N_not_ax = 1 : N ;  
N_not_ax( reshape( Global_flags.Search_Params.Chamber_B_electrodes , 1 , []) ) = [] ;
B_srprofile( : , N_not_ax , : ) = 0 ;
B_srprofile = sum( B_srprofile , 2 );
B_srprofile = squeeze( B_srprofile );
B_srprofile_std = std( B_srprofile ,0 ,2 );
 B_srprofile = mean( B_srprofile ,2 );
 B_srprofile = B_srprofile( 1 : ANALYZED_DATA_A.DT_BINS_number ) ;
 
 ax_srprofile = All_srprofile ;
 N_not_ax = 1 : N ;
 N_not_ax( reshape( Global_flags.Search_Params.Chamber_channels_electrodes , 1 , []) ) = [] ;
 ax_srprofile( : , N_not_ax , : ) = 0 ;
 ax_srprofile = sum( ax_srprofile , 2 );
 ax_srprofile = squeeze( ax_srprofile );
 ax_srprofile_std = std( ax_srprofile ,0 ,2 );
 ax_srprofile = mean( ax_srprofile ,2 );
 ax_srprofile = ax_srprofile( 1 : ANALYZED_DATA_A.DT_BINS_number ) ;
 else
  B_srprofile = zeros(  ANALYZED_DATA_A.DT_BINS_number , 1 ); 
  ax_srprofile = zeros(  ANALYZED_DATA_A.DT_BINS_number , 1 );
  A_srprofile = zeros(  ANALYZED_DATA_A.DT_BINS_number , 1);
  A_srprofile_std = [];
 B_srprofile_std = [];
 ax_srprofile_std = [];
end
       
        timebins= 1 :  ANALYZED_DATA_A.DT_BINS_number ;
        timebins = (timebins-1) * ANALYZED_DATA_A.DT_bin ;
ANALYZED_DATA.Timebin_A_srprofile = A_srprofile' ;
ANALYZED_DATA.Timebin_B_srprofile = B_srprofile' ;
ANALYZED_DATA.Timebin_Axon_srprofile = ax_srprofile' ;
 
ANALYZED_DATA.Timebin_A_srprofile_std = A_srprofile_std' ;
ANALYZED_DATA.Timebin_B_srprofile_std = B_srprofile_std' ;
ANALYZED_DATA.Timebin_Axon_srprofile_std = ax_srprofile_std' ;
 
    % --------------  test if A->B is random
%      rel_Amp = 100 * (max( B_srprofile ) - median( B_srprofile )) / max( B_srprofile );
%      if rel_Amp < Global_flags.Search_Params.Chambers_Profile_relative_thr  % then All A->B is random
%         first_bins_firing = mean( B_srprofile( 1:2) )/ sr_div_B ;
%         if first_bins_firing > Global_flags.Search_Params.Chambers_Profile_FirstBinFiring_thr
%             ANALYZED_DATA.Chambers_A_B_evoked = 0 ; % number of A evoked B
%             ANALYZED_DATA.Chambers_A_B_evoked_percent = 0 ;
%             ANALYZED_DATA.Chambers_A_B_evoked_mean_delay = 0 ;
%             ANALYZED_DATA.Chambers_A_B_connection_exist = false ;
%         end
%      end
    %------------------------------------
   
% B->A spikerate profile
if ANALYZED_DATA.Chambers_B_A_evoked_percent > 0
All_srprofile = ANALYZED_DATA_BA.Spike_Rate_Patterns( : , : , ...
            ANALYZED_DATA.Chambers_B_A_evoked_burst_index( : , 2 )) ;
%         All_srprofile = ANALYZED_DATA_BA.Spike_Rate_Patterns ;
A_srprofile = All_srprofile ;
N_not_ax = 1 : N ;  
N_not_ax( reshape( Global_flags.Search_Params.Chamber_A_electrodes , 1 , []) ) = [] ;
A_srprofile( : , N_not_ax , : ) = 0 ;
A_srprofile = sum( A_srprofile , 2 );
A_srprofile = squeeze( A_srprofile );
 A_srprofile = mean( A_srprofile ,2 );
 A_srprofile = A_srprofile( 1 : ANALYZED_DATA_A.DT_BINS_number )  ;
        
B_srprofile = All_srprofile ;
N_not_ax = 1 : N ;  
N_not_ax( reshape( Global_flags.Search_Params.Chamber_B_electrodes , 1 , []) ) = [] ;
B_srprofile( : , N_not_ax , : ) = 0 ;
B_srprofile = sum( B_srprofile , 2 );
B_srprofile = squeeze( B_srprofile );
 B_srprofile = mean( B_srprofile ,2 );
 B_srprofile = B_srprofile( 1 : ANALYZED_DATA_A.DT_BINS_number ) ;
 
 ax_srprofile = All_srprofile ;
 N_not_ax = 1 : N ;
 N_not_ax( reshape( Global_flags.Search_Params.Chamber_channels_electrodes , 1 , []) ) = [] ;
 ax_srprofile( : , N_not_ax , : ) = 0 ;
 ax_srprofile = sum( ax_srprofile , 2 );
 ax_srprofile = squeeze( ax_srprofile );
 ax_srprofile = mean( ax_srprofile ,2 );
 ax_srprofile = ax_srprofile( 1 : ANALYZED_DATA_A.DT_BINS_number ) ;
else
  B_srprofile = zeros( ANALYZED_DATA_A.DT_BINS_number ,1); 
  ax_srprofile = zeros( ANALYZED_DATA_A.DT_BINS_number ,1);
  A_srprofile = zeros( ANALYZED_DATA_A.DT_BINS_number ,1);
    A_srprofile_std = [];
 B_srprofile_std = [];
 ax_srprofile_std = [];
end
        timebins= 1 :  ANALYZED_DATA_A.DT_BINS_number ;
        timebins = (timebins-1) * ANALYZED_DATA_A.DT_bin ;
       
%--- Store data       
    ANALYZED_DATA.Timebin_BA_A_srprofile = A_srprofile' ;
    ANALYZED_DATA.Timebin_BA_B_srprofile = B_srprofile'  ;
    ANALYZED_DATA.Timebin_BA_Axon_srprofile = ax_srprofile' ;
 
    % --------------  test if B->A is random
     rel_Amp = 100 * (max( A_srprofile ) - median( A_srprofile )) / max( A_srprofile );
     if rel_Amp < Global_flags.Search_Params.Chambers_Profile_relative_thr % then All A->B is random
        first_bins_firing = mean( A_srprofile( 1:2) )/ sr_div_A ;
%         if first_bins_firing > Global_flags.Search_Params.Chambers_Profile_FirstBinFiring_thr
            ANALYZED_DATA.Chambers_B_A_evoked = 0 ; % number of A evoked B
            ANALYZED_DATA.Chambers_B_A_evoked_percent = 0 ;
            ANALYZED_DATA.Chambers_B_A_evoked_mean_delay = 0 ;
            ANALYZED_DATA.Chambers_B_A_connection_exist = false ;
%         end
     end
    %------------------------------------
%-----
 
       
        ANALYZED_DATA.Timebin_A_srprofile_firing_HZ = ANALYZED_DATA.Timebin_A_srprofile / sr_div_A ;
        ANALYZED_DATA.Timebin_Axon_srprofile_firing_HZ = ANALYZED_DATA.Timebin_Axon_srprofile / sr_div_ax ;
        ANALYZED_DATA.Timebin_B_srprofile_HZ = ANALYZED_DATA.Timebin_B_srprofile / sr_div_B ;
        ANALYZED_DATA.Timebin_BA_A_srprofile_firing_HZ = ANALYZED_DATA.Timebin_BA_A_srprofile / sr_div_A ;
        ANALYZED_DATA.Timebin_BA_Axon_srprofile_firing_HZ = ANALYZED_DATA.Timebin_BA_Axon_srprofile / sr_div_ax ;
        ANALYZED_DATA.Timebin_BA_B_srprofile_HZ = ANALYZED_DATA.Timebin_BA_B_srprofile / sr_div_B ;
       
        %----- save some chamber data to final data ------------
          ANALYZED_DATA_A   = Erase_big_data_from_ANALYZED_DATA( ANALYZED_DATA_A ) ;
          ANALYZED_DATA_B   = Erase_big_data_from_ANALYZED_DATA( ANALYZED_DATA_B ) ;
          ANALYZED_DATA_Chan   = Erase_big_data_from_ANALYZED_DATA( ANALYZED_DATA_Chan ) ;
        ANALYZED_DATA.ANALYZED_DATA_A = ANALYZED_DATA_A ;
        ANALYZED_DATA.ANALYZED_DATA_B = ANALYZED_DATA_B ;
        ANALYZED_DATA.ANALYZED_DATA_Chan = ANALYZED_DATA_Chan ;
        %-------------------------------------
       
 
ANALYZED_DATA = rmfield(ANALYZED_DATA ,  'Analysis_data_cell');
ANALYZED_DATA = rmfield(ANALYZED_DATA ,  'Analysis_data_cell_field_names' );
Analysis_data_cell = struct2cell( ANALYZED_DATA );
ANALYZED_DATA_field_names = fieldnames( ANALYZED_DATA );
Analysis_data_cell_field_names = ANALYZED_DATA_field_names ;
 
       
%======== Convert all structure to cell ============================
            ANALYZED_DATA.Analysis_data_cell = Analysis_data_cell;
            ANALYZED_DATA.Analysis_data_cell_field_names = Analysis_data_cell_field_names ;
 
 if isfield(  Search_Params , 'Chambers_AB_saving_to_DB_only_ABburst' )
     Chambers_AB_saving_to_DB_only_ABburst = Search_Params.Chambers_AB_saving_to_DB_only_ABburst ;
 else
    if isfield( Global_flags , 'Global_flags.Search_Params.Chambers_AB_saving_to_DB_only_ABburst' )
    Chambers_AB_saving_to_DB_only_ABburst=  Global_flags.Search_Params.Chambers_AB_saving_to_DB_only_ABburst ;
    else
        Chambers_AB_saving_to_DB_only_ABburst = false ;
    end
 end
            
 if Chambers_AB_saving_to_DB_only_ABburst 
 if exist( 'index_r' , 'var' ) && ANALYZED_DATA.Chambers_A_B_evoked > 0
    
     ss = find(   index_r( : , 1 ) < ANALYZED_DATA_A.burst_start( A_B_evoked_burst_index( 1 , 1 ) )) ;
       index_r( ss , : ) =[];
      
     for bi = 1 : A_B_evoked-1
       deleteto = ANALYZED_DATA_A.burst_start( A_B_evoked_burst_index( bi+1 , 1 ) ) ;
       deletefrom = ANALYZED_DATA_B.burst_end( A_B_evoked_burst_index( bi , 2 ) ) ;
      
       ss = find( index_r( : , 1 ) >= deletefrom & ...           
                    index_r( : , 1 ) < deleteto ) ;
       index_r( ss , : ) =[];
      
     end
    
       ss = find(   index_r( : , 1 ) > ANALYZED_DATA_B.burst_end( A_B_evoked_burst_index( A_B_evoked , 2 ) )) ;
       index_r( ss , : ) =[];
    
 end
 end         
           
           
%% --- Chambers analysis A B axons - SR profiles   
  if show_figures   
%       if exists( 'Raster_number' , 'var' )
%       if Raster_number == 5 % A-B analysis
         
      if exist( 'ANALYZED_DATA_A' , 'var' ) &&  exist( 'ANALYZED_DATA_B' , 'var')
       
        timebins= 1 :  ANALYZED_DATA_A.DT_BINS_number ;
        timebins = (timebins-1) * ANALYZED_DATA_A.DT_bin ;
       
%         bb1 =  subplottight(Ny , Nx , 6 ) ;
 
        figure_title = 'Spikerate profiles in A,axons and B';
        f = figure ;
        set(f, 'name',  figure_title ,'numbertitle','off' )
       
        Nx =2;Ny=1;
        
     subplot( Ny, Nx , 1 )
        hold on
        plot(timebins , ANALYZED_DATA.Timebin_A_srprofile / sr_div_A, 'LineWidth' , 2 );
        plot(timebins , ANALYZED_DATA.Timebin_Axon_srprofile / sr_div_ax, 'r' , 'LineWidth' , 2 );       
        plot(timebins , ANALYZED_DATA.Timebin_B_srprofile / sr_div_B , 'g' , 'LineWidth' , 2 );
%         errorbar( timebins,  ANALYZED_DATA.Timebin_A_srprofile , ANALYZED_DATA.Timebin_A_srprofile_std);
%         errorbar(timebins , ANALYZED_DATA.Timebin_Axon_srprofile , ...
%             ANALYZED_DATA.Timebin_Axon_srprofile_std , 'r' , 'LineWidth' , 2 );  
%         errorbar(timebins , ANALYZED_DATA.Timebin_B_srprofile ,...
%              ANALYZED_DATA.Timebin_B_srprofile_std , 'g' , 'LineWidth' , 2 );
       
        legend( 'Chamber A' , 'Axons' , 'Chamber B' )
        xlim( [ 1   timebins( end)-3*ANALYZED_DATA_A.DT_bin])
 
        title( [ 'Burst propagation A > B,(P=' num2str(ANALYZED_DATA.Chambers_A_B_evoked_percent) '%)' ]);
        xlabel( 'Burst time offset, ms' )
%         ylabel( 'Mean spikes' ) 
        ylabel( 'Firing rate, Hz' ) 
       
      subplot( Ny, Nx , 2) 
        hold on
        plot(timebins , ANALYZED_DATA.Timebin_BA_A_srprofile / sr_div_A  , 'LineWidth' , 2 );
        plot(timebins , ANALYZED_DATA.Timebin_BA_Axon_srprofile / sr_div_ax , 'r' , 'LineWidth' , 2 );       
        plot(timebins , ANALYZED_DATA.Timebin_BA_B_srprofile / sr_div_B , 'g' , 'LineWidth' , 2 );
        legend( 'Chamber A' , 'Axons' , 'Chamber B' )
        xlim( [ 1   timebins( end)-3*ANALYZED_DATA_A.DT_bin])
 
         title( [ 'Burst propagation B > A,(P=' num2str(ANALYZED_DATA.Chambers_B_A_evoked_percent) '%)' ]);
        xlabel( 'Burst time offset, ms' )
%         ylabel( 'Mean spikes' )
        ylabel( 'Firing rate, Hz' ) 
%       end
      end
%       end

% Plot raster and mark A>B and B>A bursts

if ~isempty( B_A_evoked_burst_index)&&  ~isempty( ANALYZED_DATA_B.burst_start )  
BA_starts = ANALYZED_DATA_B.burst_start( B_A_evoked_burst_index( : ,2 ) );
else
    BA_starts =[];
end
if ~isempty( A_B_evoked_burst_index) &&  ~isempty( ANALYZED_DATA_A.burst_start )  
AB_starts = ANALYZED_DATA_A.burst_start( A_B_evoked_burst_index( : ,1 ) );
else
    AB_starts = [] ;
end

f = figure;
figure_title  = 'Raster, A-B bursts marked' ;
 set(f, 'name', figure_title , 'numbertitle','off' )
Plot_Detailed_Raster
hold on 
if ~isempty(AB_starts)
plot( AB_starts /1000  ,  65  , '*b', 'Linewidth' , 3  )
end
if ~isempty(BA_starts)
plot( BA_starts/1000  ,  65  , '*g','Linewidth' , 3  )
end
legend( 'Spikes', 'TSR' , 'Detection threshold', 'Burst start, end', 'blue A->B', 'green B->A')
 
hold off

  end          
  
