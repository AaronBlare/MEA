
%  MED_AWSR_Find_Bursts
function ANALYZED_DATA = MED_AWSR_Find_Bursts( filename ,  Search_Params)
% function MED_AWSR_Find_Bursts( filename , TimeBin , AWSR_sig_tres , save_bursts_to_files  , Arg_file , Search_Params)
if nargin == 0
% if TimeBin == null
% TimeBin = 1000 ; % super burst
TimeBin = 50 ; % burst
AWSR_sig_tres = 1 ;
end
TimeBin = Search_Params.TimeBin ;
AWSR_sig_tres = Search_Params.AWSR_sig_tres ;
save_bursts_to_files = Search_Params.save_bursts_to_files ;
Arg_file = Search_Params.Arg_file ;

SHOW_ISI_HIST = false ;
MIN_channels_per_burst = 4 ;
Number_of_BIN_in_Hist = 10 ;
MAX_SPIKES_PER_CHANNEL_AT_BURST = 500 ;
APPEND_DATA__TO_ORIGINAL_MAT_FILE = true ; % append analysed data to original mat file with raster
N = 64 ;
DT_step = 50 ; % time bint interval

SHOW_FIGURES = Search_Params.Show_figures ;

% [filename, pathname] = uigetfile('*.*','Select file') ;
% if filename ~= 0 
% 
% Init_dir = cd ;
% cd( pathname ) ;    
MED_file_raster_input  =false;
if filename == 0
    if Arg_file.Use_meaDB_raster %----------- load raster from DB
        [index_r , Raster_exists ,Raster_exists_with_other_sigma , Sigma_threshold_exists , RASTER_data ]...
            = Load_raster_from_RASTER_DB( Arg_file.Experiment_name , Arg_file.Sigma_threshold ); 
    else  %----------- load raster from file     
      MED_file_raster_input  =false;
    end
else
    Raster_exists = true ;
end 
        
       [pathstr,name,ext,versn] = fileparts( filename ) ; 
       if  ext == '.mat'  %----Load from MAT_raster.mat file
         load( char( filename ) ) ;  
         index_r = RASTER_data.index_r ;
         MED_file_raster_input  = true ;
       else
         index_r = load( char( filename ) ) ;  
         Experiment_name = name ;
         Sigma_threshold = 0 ;
       end  
    Raster_exists = true ;
  


if Raster_exists %------------------------------------------ 

[pathstr,name,ext,versn] = fileparts ( filename ) ;
   

% if using 6well raster then make 6 directories with split analysis results
Cycle_rasters_num = 1 ;
if Search_Params.use6well_raster
    name_original = name ;
    Cycle_rasters_num = 6 ;
    Extract_6well_rasters ;
    original_dir = cd ;
end

%=========================================================================
%=========================================================================
for Raster_number = 1 : Cycle_rasters_num 
    
    % extract on eacg cycle  raster form 6well raster
    if Search_Params.use6well_raster
        index_r  = index_r_6well_all.RASTER_data( Raster_number ).index_r ;
        New_dir = [ name '_6well_raster_number_'  num2str( Raster_number ) ] ;
        cd( original_dir );
        mkdir(  New_dir  ); 
        cd( New_dir );
    end
        
% Start analysis of the raster index_r
%--------------------------------------------------------------

    N = max( index_r( : , 2 ))
    AWSR = AWSR_from_index_r( index_r  , TimeBin );

    % [burst_start,burst_max,burst_end,InteBurstInterval , BurstDurations,Spikes_per_Burst,Burst_Firing_Rate , Statistical_ANALYSIS , Statistical_ANALYSIS_median_values]  =...
    %     Extract_bursts( AWSR ,TimeBin , AWSR_sig_tres) ;
    Extract_bursts


    % if ext == '.txt'
    % index_r = load(  char( filename )  ) ; 
    % else
    %   load(  char( filename )  ) ; 
    %    MED_file_raster_input  = true ;
    % end

 
    index_r_size = size( index_r ); 
    spikes_num_total = index_r_size(1) ;
    last_spike = index_r( end , 1 ) / 1000 ; % last spike time in sec
    Spikes_per_sec = spikes_num_total / last_spike ;
    Spikes_per_sec

    burst_start = burst_start * 1000 ;
    burst_max = burst_max * 1000 ;
    burst_end = burst_end * 1000 ;
    burst_durations = burst_end(:) - burst_start(:) ;
    Tmax_s = max( index_r( : , 1 ) ) / 1000 ;


    % burst_start(1)
    % burst_end(1)


    Nb = length( burst_start )  ;         % Number of bursts
    Nb
    bursts = zeros( Nb , N , MAX_SPIKES_PER_CHANNEL_AT_BURST) ;
    bursts_absolute = zeros( Nb , N ) ;
    burst_start_new = zeros( N ,1 )  ;
    burst_activation = zeros( Nb , N );
    burst_activation_normalized_mean = zeros(   N );
    burst_activation_normalized = zeros( Nb ,  N );
    burst_activation_mean = zeros( N , 1 );
    Firing_Rates = zeros( Nb ,  N    );
    Spike_Rates  = zeros(  Nb ,  N  );

    bursts_amps=zeros( Nb ,N, 1000);    
    burst_activation_amps =zeros( Nb ,N);


    if SHOW_ISI_HIST 
    ISI = []; 
    ch = 2 ;
    HIST_STEP = 2 ;
    channel_s_times = [];
     for ch = 1 : N    
    index_ch = find( index_r( : , 2 ) == ch );
    channel_s_times1 =  index_r( index_ch ,1 ) ; 
    channel_s_times1( channel_s_times1 == 0 ) = [];
    channel_s_times = [ channel_s_times channel_s_times1' ];
     end
    ISI = diff( channel_s_times ) ; 
    xxx = 0 : HIST_STEP : max( ISI );
     [counts,x] = histc(ISI , xxx  ); 
      counts=100* counts/ length( ISI );
      figure
      whos x
      whos counts
      bar(   xxx ,counts) 
     mean_isi = mean( ISI ) ;
    end
 

    for t = 1 : Nb
        Progress = ( t / Nb ) * 100 ;
        Progress;
        burst_start_new(:) = burst_start(t) ;
        burst_start_new2=[];
        for ch = 1 : N               
            ss = find( index_r( : , 1 ) >= burst_start( t ) & ...            
                index_r( : , 1 ) < burst_end( t ) & index_r( : , 2 ) == ch , 1 ) ;
    %        index_r( ss , 1)
            if ~isempty( ss )
                burst_start_new( ch ) = index_r( ss , 1) ;
                burst_start_new2= [burst_start_new2 index_r( ss , 1)] ;
            end        
        end
        burst_start( t ) = min( burst_start_new2 ) - 1 ;    

        for ch = 1 : N            

            index_spikes_in_burst = ...
                 find( index_r( : , 1 ) >= burst_start( t ) & ...            
                index_r( : , 1 ) < burst_end( t ) & index_r( : , 2 ) == ch  )     ;
            Firing_Rates( t , ch ) = length( index_spikes_in_burst ) / burst_durations(t) ;
            Spike_Rates( t , ch )  = length( index_spikes_in_burst ) ;

            if ~isempty( index_spikes_in_burst )
                burst_activation( t , ch )  =   index_r( index_spikes_in_burst(1) , 1) - burst_start( t )   ;
                bursts_absolute( t , ch , 1:length(index_spikes_in_burst) ) =   index_r( index_spikes_in_burst , 1) ;
                bursts( t , ch , 1:length(index_spikes_in_burst) ) =   index_r( index_spikes_in_burst , 1) - burst_start( t ) ;
                burst_activation_amps( t , ch ) =  index_r( index_spikes_in_burst(1) , 3) ;
                bursts_amps( t , ch , 1:length(index_spikes_in_burst) ) =  index_r( index_spikes_in_burst , 3) ;
            end        
        end  

        dur = max( burst_activation( t , : )  ) - min( burst_activation( t , : )  ) ;
        burst_activation_normalized( t , : ) = burst_activation( t , : ) /  dur ;

    end

    % erase bursts where at bin less than MIN_channels_per_burst_max_AWSR spiks
    Burst_to_erase = [];
    for t = 1 : Nb
        Electrodes_in_burst = 0 ;
        for ch = 1 : N  
          Electrodes_in_burst = Electrodes_in_burst +H(  Spike_Rates( t , ch ) );
        end
        if Electrodes_in_burst < MIN_channels_per_burst 
            Burst_to_erase=[Burst_to_erase t ] ;
        end
    end

    %+++++++ SPIKE RATE statistics +++++++++++++++++
    Spike_Rates_each_channel_mean  = zeros(  N , 1 );
    Spike_Rates_each_channel_std  = zeros(  N , 1 );
    Firing_Rates_each_channel_mean  = zeros(  N , 1 );
    Firing_Rates_each_channel_std  = zeros(  N , 1 ); 
       for ch = 1 : N  
           Spike_Rates_each_channel_mean( ch )  = mean( Spike_Rates(    :, ch ));
           Spike_Rates_each_channel_std( ch )  = std( Spike_Rates(   :, ch ));
           Firing_Rates_each_channel_mean( ch )  = mean( Firing_Rates( : , ch ));
           Firing_Rates_each_channel_std( ch )  = std( Firing_Rates( : , ch )); 
       end
   
    Spike_Rates_each_burst  = zeros( Nb ,1);       
       for i=1:  Nb 
           Spike_Rates_each_burst(i) = sum( Spike_Rates( i , :)); 
       end
    %-----------%-----------%-----------%-----------%----------- 

    % Nb
    % erase non bursts
    Spike_Rates( Burst_to_erase , :) = [] ;
    Nb = Nb - length( Burst_to_erase );
    burst_start( Burst_to_erase ) =[];
    burst_durations( Burst_to_erase ) =[];
    burst_end( Burst_to_erase ) = [] ;
    bursts( Burst_to_erase , : , : ) = []; 
    bursts_absolute( Burst_to_erase , : , : ) = []; 
    burst_activation( Burst_to_erase ,  : ) = [];  
    burst_activation_normalized( Burst_to_erase ,  : ) = []; 
    % Spikes_per_electrodeNb( Burst_to_erase ,  : ) = [];  
    index_max( Burst_to_erase  ) = [];  
    index( Burst_to_erase  ) = [];  
    Spike_Rates_each_burst( Burst_to_erase  ) = [];   
    Durations( Burst_to_erase  ) = [];   
    %-----------------------------

 
    max_ISI = diff( index_max ) ;
    % max_ISI = b_ISI ;
    InteBurstInterval = max_ISI *dT / 1000  ;
    Median_InterBurstInterval = median( max_ISI ) *dT / 1000  ;
    MAD_InterBurstInterval = mad( max_ISI ,1) *dT / 1000  ;
    Mean_InterBurstInterval = mean( max_ISI ) *dT / 1000  ;
    STD_InterBurstInterval = std( max_ISI ) *dT / 1000  ;
    Mean_Spikes_per_Burst = mean( Spikes_per_Burst );
    STD_Spikes_per_Burst = std( Spikes_per_Burst );
    Median_Spikes_per_Burst = median( Spikes_per_Burst );
    MAD_Spikes_per_Burst = mad( Spikes_per_Burst );
    Mean_Burst_Duration = Mean( Durations ) *dT / 1000  ;
    STD_Burst_Duration = std( Durations ) *dT / 1000  ;
    Median_Burst_Duration = Median( Durations ) *dT / 1000  ;
    MAD_Burst_Duration = mad( Durations ,1  ) *dT / 1000  ;

    % Spike_Rates_in_Burst = Spikes_per_Burst(:) / ( Durations(:) *dT / 1000 ) ;
    % Median_Burst_FiringRate =  Median(Spike_Rates_in_Burst ) ;
    % MAD_Burst_FiringRate =  mad(Spike_Rates_in_Burst , 1 ) ; 

 
    Mean_Burst_FiringRate = mean( Spike_Rates_each_burst ) ;
    STD_Burst_FiringRate = std( Spike_Rates_each_burst ,1) ;
    Median_Burst_FiringRate = median( Spike_Rates_each_burst ) ;
    MAD_Burst_FiringRate = mad( Spike_Rates_each_burst ,1) ;
    Bursts_number = length( index );

    Bursts_number  

    Median_Burst_Duration 
    MAD_Burst_Duration

    Median_InterBurstInterval
    MAD_InterBurstInterval

    Median_Burst_FiringRate  
    MAD_Burst_FiringRate

    Median_Spikes_per_Burst
    MAD_Spikes_per_Burst


    Mean_Burst_Duration
    STD_Burst_Duration

    Mean_InterBurstInterval
    STD_InterBurstInterval

    Mean_Burst_FiringRate
    STD_Burst_FiringRate

    Mean_Spikes_per_Burst 
    STD_Spikes_per_Burst 

    Statistical_ANALYSIS = [ Mean_Burst_Duration ; STD_Burst_Duration ;Mean_InterBurstInterval ;STD_InterBurstInterval; ...
          Mean_Burst_FiringRate; STD_Burst_FiringRate; Mean_Spikes_per_Burst ;STD_Spikes_per_Burst  ] ;

    Statistical_ANALYSIS_median_values= [ Median_Burst_Duration ; MAD_Burst_Duration ;Median_InterBurstInterval ;MAD_InterBurstInterval; ...
          Median_Burst_FiringRate; MAD_Burst_FiringRate; Median_Spikes_per_Burst ;MAD_Spikes_per_Burst  ] ;



 
    if ~isempty( burst_durations)

    % [ Data_Rate_Signature , DT_BIN_ms , DT_BINS_number ,  bb ] = DrawSpikeRateSignature( Nb ,  bursts , mean(burst_durations) , 20 );

    var.Spike_Rates_each_burst = Spike_Rates_each_burst ; 

       [   TimeBin_Total_Spikes ,  TimeBin_Total_Spikes_mean , TimeBin_Total_Spikes_std , ...
       Data_Rate_Patterns1 ,  Data_Rate_Signature1 ,  ... 
       Data_Rate_Signature1_std ] ...
          = Get_Electrodes_Rates_at_TimeBins_1pattern( N ,Nb  ,bursts , ...
          0 ,  median(burst_durations)  , DT_step  ,bursts_amps ,var );


    fire_bins = floor(max(burst_durations) / DT_step) ;
    DT_BINS_number=fire_bins;
    DT_BIN_ms = DT_step;
    else
       Data_Rate_Signature1 = [] ; 
       DT_BIN_ms  = 0 ;
       DT_BINS_number  = 0 ;   
       fire_bins= 0 ;
    end


    %---------- Statistics in each bin - PSTH
    fire_bins = floor(median(burst_durations) / DT_step) ; 

      TimeBin_Total_Spikes = zeros( Nb , fire_bins );  
      TimeBin_Total_Spikes_mean = zeros(1,fire_bins);
      TimeBin_Total_Spikes_std = zeros(1,fire_bins);
      Nb
      fire_bins
      whos Data_Rate_Patterns1
      for ti=1:fire_bins
          for R = 1 : Nb      
               TimeBin_Total_Spikes( R , ti )= sum( Data_Rate_Patterns1( ti , : , R   )) ; 
          end

          TimeBin_Total_Spikes_mean( ti ) = mean( TimeBin_Total_Spikes( : , ti ));
          TimeBin_Total_Spikes_std( ti ) = std( TimeBin_Total_Spikes( : , ti ));
      end
    %-----------%-----------%-----------%-----------%-----------   



  if ~Search_Params.use6well_raster
    % Superbursts detection %-----------%-----------%----------- 
    % Tsuper_sec = 50 ; % Superburst length , sec
    Tsuper_sec = Search_Params.SsuperBurst_scale_sec ; % Superburst length , sec
    Tsuper = (Tsuper_sec / 10 )   *  1000 / TimeBin  ;

    [ SB_start , SB_end , bursts_per_super_bursts] = SuperBurst( AWSR,  Tsuper , 5 , TimeBin );
    N_SB = length( SB_start ); %Number of superbursts
    %-------------
    % Check number of usual bursts inside Superb, filter if its number < 2
    MIN_burst_per_Superburst = 2 ;

    burst_in_superbursts = [];
    for si = 1 : N_SB
        NB_in_SB = find( SB_start( si ) < burst_start &  burst_start <  SB_end( si )  );
        NB_in_SB = length( NB_in_SB );
        burst_in_superbursts = [ burst_in_superbursts NB_in_SB ];    
    end
    tiny_SB = find( burst_in_superbursts < MIN_burst_per_Superburst );
    % N_SB = length( SB_start )
    % burst_start(1)
    % SB_start(1)
    SB_start( tiny_SB ) = [];
    SB_end( tiny_SB ) = [];
    burst_in_superbursts( tiny_SB ) = [];

    SB_duration = [];
    for i = 1 : length( SB_end )
    SB_duration( i )  = SB_end( i ) - SB_start( i );
    end


% filter hort superbursts
            SB_min_duration = 10000 ;
            SB_max_duration = 50000 ;

            if length( SB_duration ) >1 
                del = find( SB_duration < SB_min_duration ) ;
                if ~isempty( del ) 
                        SB_start( del ) = [];
                        SB_end( del ) = [];
                        burst_in_superbursts( del ) = [];
                        SB_duration( del ) = [];
                end
                del = find( SB_duration > SB_max_duration ) ;
                if ~isempty( del )
                        SB_start( del ) = [];
                        SB_end( del ) = [];
                        burst_in_superbursts( del ) = [];
                end
            end
            
            N_SB = length( SB_start );
    %----------------------------------            
    SB_InterSBurstInterval = [];
    if length( SB_end ) > 1
        for i = 1 : length( SB_end ) -1
        SB_InterSBurstInterval = SB_start( i+1 ) - SB_end( i );
        end
    end

    SB_duration = [] ;
    if ~isempty( SB_end ) 
        for i = 1 : length( SB_end )
        SB_duration( i )  = SB_end( i ) - SB_start( i );
        end
    end
    mean_Super_Durations = mean( SB_duration ) ;

    N_SB = length( SB_start ); 
    Number_of_Superbursts = N_SB 
    Superbrsts.burst_in_superbursts = burst_in_superbursts ;
    Superbrsts.SB_start = SB_start ;
    Superbrsts.SB_end = SB_end ;
    Superbrsts.SB_InterSBurstInterval = SB_InterSBurstInterval ;
    Superbrsts.Number_of_Superbursts = Number_of_Superbursts ;
    Superbrsts.SB_duration = SB_duration ;
    SUPERBURSTS = Superbrsts ;

    mean_Super_Durations
  else
      SUPERBURSTS = [] ;
  end
    %-----------%-----------%-----------%-----------%-----------

    % Statistical_ANALYSIS = [ Statistical_ANALYSIS ; Mean_Burst_Duration ; STD_Burst_Duration ;Mean_InterBurstInterval ;STD_InterBurstInterval; ...
    %       Mean_Burst_FiringRate; STD_Burst_FiringRate; Mean_Spikes_per_Burst ;STD_Spikes_per_Burst  N_SB ] ;
    % Statistical_ANALYSIS = [ Statistical_ANALYSIS ;   N_SB ] ;

    if save_bursts_to_files == 'y'

            Statistical_ANALYSIS = [ Statistical_ANALYSIS ; Spikes_per_sec ; Nb ; N_SB ; mean_Super_Durations] ;
        %         figure
        %         plot( curr_BURST( : , 1)  , curr_BURST( : , 2) ,
        %         '.','MarkerEdgeColor' ,[.04 .52 .78] )
%         [pathstr,name,ext,versn] = fileparts( filename ) ;
	if Search_Params.use6well_raster
       name =  [ name_original '_6well_number_' num2str( Raster_number ) ];
    end
        finame = [ name '_BURSTS_spikes' int2str(TimeBin) 'ms_TimeBin.mat' ] ;
        InteBurstInterval=InteBurstInterval';
        Spikes_per_Burst=Spikes_per_Burst';
        % eval(['save ' char( finame ) ...
        %  ' burst_activation bursts_absolute bursts burst_start burst_max
        %  burst_end InteBurstInterval BurstDurations Spikes_per_Burst  -mat']); 

           ANALYZED_DATA.Statistical_ANALYSIS = Statistical_ANALYSIS;
           ANALYZED_DATA.Statistical_ANALYSIS_median_values=Statistical_ANALYSIS_median_values;
           ANALYZED_DATA.burst_activation=burst_activation;
           ANALYZED_DATA.bursts_absolute=bursts_absolute;
           ANALYZED_DATA.bursts=bursts;
           ANALYZED_DATA.burst_start=burst_start;
           ANALYZED_DATA.burst_max=burst_max;
           ANALYZED_DATA.burst_end=burst_end;
           ANALYZED_DATA.burst_activation_amps =burst_activation_amps;           %  spike amps in first spikes
           ANALYZED_DATA.bursts_amps  =bursts_amps;                    %  spike amps in bursts

           ANALYZED_DATA.Number_of_bursts = Nb ;       
           ANALYZED_DATA.Number_of_Patterns = Nb ;  

           ANALYZED_DATA.InteBurstInterval=InteBurstInterval;
           ANALYZED_DATA.BurstDurations=BurstDurations;

           ANALYZED_DATA.Spike_Rates = Spike_Rates ;       
           ANALYZED_DATA.Spike_Rates_each_burst = Spike_Rates_each_burst ;
           ANALYZED_DATA.Spike_Rates_each_channel_mean = Spike_Rates_each_channel_mean ; %( 64 x 1 )
           ANALYZED_DATA.Spike_Rates_each_channel_std = Spike_Rates_each_channel_std ; %( 64 x 1 )
           ANALYZED_DATA.Spike_Rates_Signature = Data_Rate_Signature1;% DT_bins number x 64
           ANALYZED_DATA.Spike_Rates_Signature_std = Data_Rate_Signature1_std ; % DT_bins number x 64

           ANALYZED_DATA.Firing_Rates = Firing_Rates ;         
           ANALYZED_DATA.Firing_Rates_each_channel_mean = Firing_Rates_each_channel_mean ; 
           ANALYZED_DATA.Firing_Rates_each_channel_std = Firing_Rates_each_channel_std ; 

           POST_STIM_RESPONSE.TimeBin_Total_Spikes = TimeBin_Total_Spikes ; % Ns x DT_bins number 
           POST_STIM_RESPONSE.TimeBin_Total_Spikes_mean = TimeBin_Total_Spikes_mean ;  % 1 x DT_bins number 
           POST_STIM_RESPONSE.TimeBin_Total_Spikes_std = TimeBin_Total_Spikes_std ;  % 1 x DT_bins number  
           ANALYZED_DATA.DT_bin = DT_BIN_ms ; % Used for TimeBin_Total_Spikes_mean, ..      
           ANALYZED_DATA.DT_BINS_number=DT_BINS_number;  


           % Superburstrs
           ANALYZED_DATA.Superbrsts  = Superbrsts ; 
           ANALYZED_DATA.Number_of_Superbursts = N_SB ;
           ANALYZED_DATA.SB_start  = SB_start ;
           ANALYZED_DATA.SB_end  = SB_end ; 
           ANALYZED_DATA.burst_in_superbursts = burst_in_superbursts ;  

           % Awsr
           ANALYZED_DATA.AWSR_TimeBin = TimeBin ;
           ANALYZED_DATA.AWSR_sig_tres=AWSR_sig_tres;
           ANALYZED_DATA.Flags = zeros( 30 , 1);

           bursts_analyzed = true ;

    Spike_Rates_Signature = Data_Rate_Signature1;   
    DT_bin = DT_BIN_ms ; 
        eval(['save ' char( finame ) ...
            ' Statistical_ANALYSIS Statistical_ANALYSIS_median_values burst_activation bursts_absolute '...
            ' bursts burst_start burst_max burst_end InteBurstInterval'...
           ' BurstDurations Spike_Rates_each_burst Spike_Rates_Signature DT_BINS_number' ...
           ' DT_bin Spike_Rates Spike_Rates_each_channel_mean Spike_Rates_each_channel_std '...
           'Firing_Rates Firing_Rates_each_channel_mean  Firing_Rates_each_channel_std  ANALYZED_DATA  -mat']); 

        finame = [ name '_Burst_ANALYSIS_RESULTS_' int2str(TimeBin) 'ms_TimeBin.mat' ] ;
        eval(['save ' char( finame ) ' Statistical_ANALYSIS Statistical_ANALYSIS_median_values  InteBurstInterval BurstDurations Spikes_per_Burst SUPERBURSTS -mat']); 

        %---- End bursts analysis of the raster -------------

   
    
 if ~Search_Params.use6well_raster   
        
        if  MED_file_raster_input  && APPEND_DATA__TO_ORIGINAL_MAT_FILE

                eval(['save ' char( filename )...
            ' ANALYZED_DATA bursts_analyzed  -mat -append ']);      

        end
         if  MED_file_raster_input 
             Sigma_threshold = RASTER_data.Sigma_threshold ;
         end
        if Arg_file.Use_meaDB_raster
            Sigma_threshold = Arg_file.Sigma_threshold ;
            Experiment_name = Arg_file.Experiment_name ;
        end
    
    
    %-------- Add bursts to DB 
           [index_r_from_DB , Raster_exists ,Raster_exists_with_other_sigma , Sigma_threshold_exists , RASTER_data_from_DB ] = ...
                   Load_raster_from_RASTER_DB( Experiment_name ,  Sigma_threshold );
             if Raster_exists  
                 RASTER_data  = RASTER_data_from_DB ;
                Add_Analyzed_data_RASTER_DB( Experiment_name , RASTER_data.Sigma_threshold , ANALYZED_DATA )
            % [Raster_exists ,Raster_exists_with_other_sigma ] = Add_new_Raster_RASTER_DB( Experiment_name , ...
            %         Sigma_number_threshold , RASTER_data)
            % [index_r , Raster_exists ,Raster_exists_with_other_sigma , Sigma_threshold_exists ] = ...
            %        Load_raster_from_RASTER_DB( Experiment_name , Sigma_number_threshold )
             else
                 if  MED_file_raster_input
                     [Raster_exists ,Raster_exists_with_other_sigma ] = Add_new_Raster_RASTER_DB( Experiment_name , ...
                        RASTER_data.Sigma_threshold , RASTER_data);
                    Add_Analyzed_data_RASTER_DB( Experiment_name , RASTER_data.Sigma_threshold , ANALYZED_DATA );
                 else
                     RASTER_data.index_r = index_r;
                     RASTER_data.Raster_Flags = zeros( 40 , 1 ) ; 
                     RASTER_data.Raster_Flags( RASTER_FLAG_Artefacts_included ) = false ;
                                 % c == 0 - empty RASTER_DATA
                                 % c == 1 - all data fine 
                                 % c == 2 - only index_r 
                                 % c == 3 - artifacts also 
                                 RASTER_data.Raster_Flags( RASTER_FLAG_all_data_included ) = 2 ;
                     
                     [Raster_exists ,Raster_exists_with_other_sigma ] = Add_new_Raster_RASTER_DB( Experiment_name , ...
                        0 , RASTER_data);
                    Add_Analyzed_data_RASTER_DB( Experiment_name , 0 , ANALYZED_DATA );                     
                     
                 end
             end
   %----------------------------
     end
    
    end
    
end

%%%%%%-----------ANALYSIS----------------------



%%%%%%%%%%-------------------------------------

% burst_durations

for ch = 1 : N   
burst_activation_mean( ch  ) = mean( burst_activation( : , ch ));
Spike_Rate_per_electrode( ch ) = length( find( index_r( : , 2 ) == ch ) ) / Tmax_s ;
% Spike_Rate_per_electrode_per_burst( ch ) = mean( Spikes_per_electrodeNb( : , ch ) ) ;
 
burst_activation_normalized_mean( ch) = mean( burst_activation_normalized( : , ch ));
% burst_activation(ch) = burst(1,ch);
end

%--- FIGURES ------------------------------

if SHOW_FIGURES
    
    
    
figure
% % xh = 0:1:1.1*max( max_ISI );
% [n,xout] = hist( max_ISI , 90 ) ;
% ibi_1 = bar(xout*DimenM,n/length(max_ISI) );
% xlabel(['Inter Burst Interval, ' tdim ])
% ylabel('Bursts %')
% h = findobj(ibi_1,'Type','patch');
% set(h,'FaceColor',[.04 .52 .78])


subplot( 3,3,1:2)
%   if  max(max_ISI)  > Number_of_BIN_in_Hist * 2 
      HStep =   max(max_ISI) / Number_of_BIN_in_Hist ;
%   else
%       HStep = 1 ;
%   end
    xxx =  0 : HStep: max(max_ISI) ;
    % [h,p] = hist(RS_values_total ,xxx) ;
    %  bar(p,h) 
    [h,p] = histc(max_ISI ,xxx) ;
%      bar(xxx, h)
     ibi_1 = bar(xxx*DimenM,100*(h/length(max_ISI)) );
    xlabel(['Inter Burst Interval, ' tdim ])
    ylabel('Bursts, %')
    h = findobj(ibi_1,'Type','patch');
    set(h,'FaceColor',[.04 .52 .78])
     
% figure
% % xh = 0:1:1.1*max( Durations );
% % xh = xh *dT / 1000  ;
% [n,xout] = hist( Durations ) ;
% bdur =bar(xout*DimenM,n/length(Durations) );
% % axis( [ 0 1.1*max( Durations )*(dT / 1000) 0 1.1*max(n) ] )
% xlabel([ 'Burst duration, ' tdim ])
% ylabel('Bursts %')
% h = findobj(bdur,'Type','patch');
% set(h,'FaceColor',[.04 .52 .78])

subplot( 3,3,4:5)  
%   if  max(Durations)  > Number_of_BIN_in_Hist * 2 
      HStep =   max(Durations) / Number_of_BIN_in_Hist ;
%   else
%       HStep = 1 ;
%   end
  xxx =  0 : HStep: max(Durations) ;
  xout = xxx ;
  [h,p] = histc(Durations ,xxx) ; 
  n = h ; 
    bdur =bar(xout * 1000 * DimenM ,100* (n/length(Durations)) ); 
%     xlabel([ 'Burst duration, ' tdim ])
    xlabel(  'Burst duration, ms'  )
    ylabel('Bursts, %')
    h = findobj(bdur,'Type','patch');
    set(h,'FaceColor',[.04 .52 .78])

% figure
% % xh = 0:1:1.1*max( Spikes_per_Burst );
% [n,xout] = hist( Spike_Rates_in_Burst ) ;
% nospb = bar(xout ,n/length(Spike_Rates_in_Burst)  );
% xlabel('Burst spike rate, spikes/s.')
% ylabel('Bursts')
% h = findobj(nospb,'Type','patch');
% set(h,'FaceColor',[.04 .52 .78])
 
subplot( 3,3,7:8)  
%   if  max(Spikes_per_Burst)  > Number_of_BIN_in_Hist * 2 
      HStep =   max(Spikes_per_Burst) / Number_of_BIN_in_Hist ;
%   else
%       HStep = 1 ;
%   end
  xxx =  0 : HStep: max(Spikes_per_Burst) ;
  xout = xxx ;
  [h,p] = histc(Spikes_per_Burst ,xxx) ; 
  n = h ;
    nospb =bar(xout  ,100* (n/length(Spikes_per_Burst)) ); 
    xlabel('Burst spike rate, spikes/s.')
    ylabel('Bursts, %')
    h = findobj(nospb,'Type','patch');
    set(h,'FaceColor',[.04 .52 .78])
    
    
subplot( 3,3,[ 3 6 9 ] )      
    x=1:fire_bins; y = 1:N;
    Data_Rate_Signature1 = Data_Rate_Signature1';
    bb= imagesc(  x *DT_step  , y ,  Data_Rate_Signature1  ); 
    title( ['Burst profile, spikes/bin (' num2str(DT_step) ' ms)'] );
    xlabel( 'Time offset, ms' )
    ylabel( 'Electrode #' )
    colorbar
    
% x = [ 1 : (Nt )  ] ;
% x = x *TimeBin / 1000  ;
% y = AWSR ;
% figure
% % set(gcf,'position');
% plot( x ,  y  , x , ASDRburst ,  x , ASDRburst ) , grid on
% xlabel('Time, s')
% ylabel(['Burst rate, spikes per bin']) 

if SAVE_PLOT_TO_FILE == 'y' 
saveas(gcf,'AWSR.fig','fig');
end

end







figure

subplot(2,2,1)
 Plot8x8Data( burst_activation_mean , false)
xlabel( 'Electrode #' )
ylabel( 'Electrode #' )
title( 'Burst activation, ms' )
colorbar ;

if 1 > 0
[pathstr,name,ext,versn] = fileparts( filename ) ;
figname = [ name '_Burst_activation_' int2str(TimeBin) 'ms_TimeBin.fig' ] ;
saveas(gca,  figname ,'fig');
end

%  Plot8x8Data( burst_activation_normalized_mean )
% xlabel( 'Electrode #' )
% ylabel( 'Electrode #' )
% title( 'Average spike time in burst activation' )
% colorbar ;



subplot(2,2,2)
 Plot8x8Data( Spike_Rate_per_electrode , false );
xlabel( 'Electrode #' )
ylabel( 'Electrode #' )
title( 'Electrode spike rate , spikes/s' )
colorbar ;

if 1 > 0
figname = [ name '_SpieRate_' int2str(TimeBin) 'ms_TimeBin.fig' ] ;
% saveas(gca,  figname ,'fig');
end

subplot(2,2,3)
 Plot8x8Data( Firing_Rates_each_channel_mean , false );
xlabel( 'Electrode #' )
ylabel( 'Electrode #' )
title( 'Burst firing rate, spikes/s' )
colorbar ;
% colormap hot

if 1 > 0
figname = [ name '_SpikePerBurst_' int2str(TimeBin) 'ms_TimeBin.fig' ] ;
% saveas(gca,  figname ,'fig');
end

if 1 > 0
[pathstr,name,ext,versn] = fileparts( filename ) ;
figname = [ name '_AWSR_Bursts_' int2str(TimeBin) 'ms_TimeBin.fig' ] ;
% saveas(gcf,  figname ,'fig');
 
figname2 = [ name '_AWSR_data' int2str(TimeBin) 'ms_TimeBin.mat' ] ;
% saveas(  ,  figname2 ,'mat');
eval(['save ' char(figname2) ' AWSR -mat']); 
end
% cd( Init_dir ) ;

end