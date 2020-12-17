
%   Extract_and_adjust_bursts
% Input : index_r TimeBin params
% Output : Bursts characteristics
paramsAWSR.show_figures = false ;

Adjust_bursts = true ; % after burst start and end found, script tunes it on 1st spike in burst, last etc, filters inadequate bursts

if isfield( Search_Params , 'Chamber_analysis_AB' ) && ...
    isfield( Search_Params , 'Chamber_A_electrodes' ) 
 if exist( 'ANALYZED_DATA_A'  )
  if Search_Params.Chamber_analysis_AB
    if  ~Search_Params.Chamber_analysis_BA % A->B
        burst_start = ANALYZED_DATA_A.burst_start   ;
        burst_max = ANALYZED_DATA_A.burst_max   ;
        burst_end = ANALYZED_DATA_A.burst_end  ;  
    else % B->A
        burst_start = ANALYZED_DATA_B.burst_start   ;
        burst_max = ANALYZED_DATA_B.burst_max   ;
        burst_end = ANALYZED_DATA_B.burst_end  ;   
    end
    
    Adjust_bursts = false ; % count only bursts, but not adjust it
    
    for bi = 1 : length( burst_end )- 1 ;
            if burst_start( bi ) + Global_flags.Search_Params.Chambers_Burst_duration_AB ...
                       < burst_start( bi + 1 ) 
            if burst_start( bi ) + Global_flags.Search_Params.Chambers_Burst_duration_AB  ...
                    > burst_end( bi  ) 
                burst_end(bi)  = burst_start(bi) + Global_flags.Search_Params.Chambers_Burst_duration_AB ;
            end
            else
                 ;
            end
    end
     
%      if Search_Params.Chamber_analysis_AB
%         AWSR = AWSR_from_index_r( index_r_A  , TimeBin , paramsAWSR );
%      else
%          AWSR = AWSR_from_index_r( index_r  , TimeBin , paramsAWSR ); 
%      end
    Extract_bursts_from_awsr = false ;
  else
    Extract_bursts_from_awsr = true; 
  end
 else
    Extract_bursts_from_awsr = true; 
 end
else
    Extract_bursts_from_awsr = true; 
%     AWSR = AWSR_from_index_r( index_r  , TimeBin , paramsAWSR );
end

%%---------------------------------------
%%---------------------------------------
%     AWSR = AWSR_from_index_r( index_r  , TimeBin , params );
%%---------------------------------------
%%---------------------------------------

    % [burst_start,burst_max,burst_end,InteBurstInterval , BurstDurations,Spike_Rates_each_burst,Burst_Firing_Rate , Statistical_ANALYSIS , Statistical_ANALYSIS_median_values]  =...
    %     Extract_bursts( AWSR ,TimeBin , AWSR_sig_tres) ;
    if Extract_bursts_from_awsr
        AWSR = AWSR_from_index_r( index_r  , TimeBin , params );
        params0 = params;
        params.show_figures = false ;
        
        Extract_bursts
        
        params  = params0 ;

        burst_start = burst_start * 1000 ;
        burst_max = burst_max * 1000 ;
        burst_end = burst_end * 1000 ;
    end
    
    
    burst_durations = burst_end(:) - burst_start(:) ;    
    Tmax_s = max( index_r( : , 1 ) ) / 1000 ;
    
%     if isfield( Search_Params , 'Chamber_analysis_AB' ) && ...
%     isfield( Search_Params , 'Chamber_analysis_A_electrodes' ) 
%      if Search_Params.Chamber_analysis_AB
%         for bi = 1 : length( burst_end )- 1 ;
%             if burst_start( bi ) + Global_flags.Search_Params.Chambers_Burst_duration_AB ...
%                        < burst_start( bi + 1 ) 
%             if burst_start( bi ) + Global_flags.Search_Params.Chambers_Burst_duration_AB  ...
%                     > burst_end( bi  ) 
%                 burst_end(bi)  = burst_start(bi) + Global_flags.Search_Params.Chambers_Burst_duration_AB ;
%             end
%             else
%                  ;
%             end
%         end
%      end
%     end
 
% SHOW_ISI_HIST = false ;    
    
MAX_SPIKES_PER_CHANNEL_AT_BURST = 10000 ;

    Nb = length( burst_start )  ;         % Number of bursts 
    if Burst_Data_Ver == 1
        bursts = zeros( Nb , N , MAX_SPIKES_PER_CHANNEL_AT_BURST) ;
        bursts_absolute = zeros( Nb , N , MAX_SPIKES_PER_CHANNEL_AT_BURST) ;
        bursts_amps=zeros( Nb ,N, MAX_SPIKES_PER_CHANNEL_AT_BURST );        
    else            
        bursts_cell_absolute_Nb_N = cell( Nb ,1 ) ;
        bursts_cell_Nb_N = cell( Nb ,1 ) ;    
        bursts_cell_amps_Nb_N = cell( Nb ,1 ) ;
    end
%     bursts = zeros( Nb , N ) ;
%     bursts_absolute = zeros( Nb , N ) ;
    burst_start_new = zeros( N ,1 )  ;
    burst_activation = zeros( Nb , N );
    burst_activation_normalized_mean = zeros(   N , 1  );
    burst_activation_normalized = zeros( Nb ,  N );
    burst_activation_mean = zeros( N , 1 );
    Firing_Rates = zeros( Nb ,  N    );
    Spike_Rates  = zeros(  Nb ,  N  );

    
    
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
    
    
     
%---------- Adjust burst starts and ends
index_r_chan_times = cell( N , 1) ;
index_r_chan_amps = cell( N , 1)  ; 
for ch =1 : N
   index_ch = find( index_r( : , 2 ) == ch ) ;
   index_r_chan_times{ch} = index_r( index_ch , 1 )  ;    
   index_r_chan_amps{ch} = index_r( index_ch , 3 )  ; 
end  
  

    for t = 1 : Nb
        Progress = ( t / Nb ) * 100 ;
        Progress;
        bursts_cell_absolute_Nb_N{ t } = cell( N,1);
        bursts_cell_Nb_N{ t } = cell( N,1);
        bursts_cell_amps_Nb_N{ t } = cell( N,1);
         
    if Adjust_bursts
        %-- if  params.Simple_analysis - not adjust spike times
        if  ~ Search_Params.Simple_analysis 
            burst_start_new(:) = burst_start(t) ;
            burst_start_new2=[]; 
            burst_end_new2=[];        
            for ch = 1 : N               
                ss = find( index_r( : , 1 ) >= burst_start( t ) & ...            
                    index_r( : , 1 ) < burst_end( t ) & index_r( : , 2 ) == ch , 1 ) ;
        %        index_r( ss , 1)
                if ~isempty( ss )
                    burst_start_new( ch ) = index_r( ss , 1) ;
                    burst_start_new2= [burst_start_new2 index_r( ss , 1)] ;
                end  

                ss_end = find( index_r( : , 1 ) >= burst_start( t ) & ...            
                    index_r( : , 1 ) < burst_end( t ) & index_r( : , 2 ) == ch   ) ; 
                if ~isempty( ss_end ) 
                    burst_end_new2= [burst_end_new2 index_r( ss_end(end) , 1)] ;
                end  

            end
            burst_start( t ) = min( burst_start_new2 ) - 1 ;    
            burst_end( t ) = max( burst_end_new2 ) - 1 ;   
        end
    end
    
        for ch = 1 : N            

%             index_r_chan_times = {} ;
%             index_r_chan_index = {} ;
            
%             index_spikes_in_burst = ...
%                  find( index_r( : , 1 ) >= burst_start( t ) & ...            
%                 index_r( : , 1 ) < burst_end( t ) & index_r( : , 2 ) == ch  )     ;
            index_spikes_in_burst = ...
                 find( index_r_chan_times{ch} >= burst_start( t ) & ...            
                index_r_chan_times{ch}  < burst_end( t )  )     ;
            
            spn = length( index_spikes_in_burst ) ;
            if spn  <= MAX_SPIKES_PER_CHANNEL_AT_BURST
                Firing_Rates( t , ch ) = length( index_spikes_in_burst ) / ( burst_durations(t) / 1000 ) ;
                Spike_Rates( t , ch )  = length( index_spikes_in_burst ) ;

                if ~isempty( index_spikes_in_burst )   
%                     burst_activation( t , ch )  =   index_r( index_spikes_in_burst(1) , 1) - burst_start( t )   ;
%                     bursts_absolute( t , ch , 1:length(index_spikes_in_burst) ) =   index_r( index_spikes_in_burst , 1) ;
%                     bursts( t , ch , 1:length(index_spikes_in_burst) ) =   index_r( index_spikes_in_burst , 1) - burst_start( t ) ;
%                     burst_activation_amps( t , ch ) =  index_r( index_spikes_in_burst(1) , 3) ;
%                     bursts_amps( t , ch , 1:length(index_spikes_in_burst) ) =  index_r( index_spikes_in_burst , 3) ;
                        burst_activation_amps( t , ch ) =   index_r_chan_amps{ch}( index_spikes_in_burst(1))   ;
                        burst_activation( t , ch )  =   index_r_chan_times{ch}( index_spikes_in_burst(1) ) - burst_start( t )   ;                        
                    if Burst_Data_Ver == 1
                        bursts_absolute( t , ch , 1:length(index_spikes_in_burst) ) =   index_r_chan_times{ch}( index_spikes_in_burst ) ; 
                        bursts( t , ch , 1:length(index_spikes_in_burst) ) = index_r_chan_times{ch}( index_spikes_in_burst(1) ) - burst_start( t ) ;
                        bursts_amps( t , ch , 1:length(index_spikes_in_burst) ) =    index_r_chan_amps{ch}( index_spikes_in_burst(1))    ;
                    else        
                        bursts_cell_absolute_Nb_N{ t }{ ch}  = index_r_chan_times{ch}( index_spikes_in_burst ) ;
                        bursts_cell_Nb_N{ t }{ ch}  = index_r_chan_times{ch}( index_spikes_in_burst ) - burst_start( t ) ;   
                        bursts_cell_amps_Nb_N{ t }{ ch}  = index_r_chan_amps{ch}( index_spikes_in_burst ) ; 
                    end
                    
                end    
            end
        end  
         
             burst_acts = burst_activation( t , : )   ;  
             burst_acts( burst_acts == 0 ) = [];
             min_sp = min( burst_acts  );
                if min_sp > 0 
                    for ch = 1 : N 
                        if burst_activation( t , ch  )>0
                        burst_activation( t , ch  ) = burst_activation( t , ch ) -  min_sp + 1 ;   
                        end
                    end
                end
                     
          
        dur = max( burst_activation( t , : )  ) - min( burst_activation( t , : )  ) ;
        burst_activation_normalized( t , : ) = burst_activation( t , : ) /  dur ;

    end
    
%     Raster.index_r_chan_times=index_r_chan_times;
   
%     Raster.index_r_chan_amps=index_r_chan_amps;
    clear index_r_chan_amps ;
    
%     bursts_absolute_cell_Nb_N_times
    Spike_Rates_each_burst  = zeros( Nb ,1);    
    Firing_Rates_each_burst  = zeros( Nb ,1); 
       for i=1:  Nb 
           Spike_Rates_each_burst(i) = sum( Spike_Rates( i , :)); 
%            Firing_Rates_each_burst(i) = sum( Firing_Rates( i , :)); 
           Firing_Rates_each_burst(i) = Spike_Rates_each_burst(i) /  burst_durations(i) ;
       end 
   
if Adjust_bursts
    % erase bursts where at bin less than MIN_channels_per_burst_max_AWSR spiks
    Burst_to_erase = [];
    for t = 1 : Nb
        Electrodes_in_burst = 0 ;
        for ch = 1 : N  
          Electrodes_in_burst = Electrodes_in_burst +H(  Spike_Rates( t , ch ) );
        end
        if Electrodes_in_burst < Search_Params.MIN_channels_per_burst 
            Burst_to_erase=[Burst_to_erase t ] ;
        end
    end
 
    
    %-----------%-----------%-----------%-----------%-----------
    if ~isempty( Burst_to_erase )
        Erase_defined_bursts 
    end
%     ( index in Burst_to_erase) 
    %-----------%-----------%-----------%-----------%----------- 
end   
     

     %+++++++ SPIKE RATE statistics +++++++++++++++++
    Spike_Rates_each_channel_mean  = zeros(  N , 1 );
    Spike_Rates_each_channel_std  = zeros(  N , 1 );
    Firing_Rates_each_channel_mean  = zeros(  N , 1 );
    Firing_Rates_each_channel_std  = zeros(  N , 1 ); 
    Total_spikes_each_channel   = zeros(  N , 1 );
    Total_firing_rates_each_channel   = zeros(  N , 1 );
       for ch = 1 : N  
           Spike_Rates_each_channel_mean( ch )  = mea_Mean_defined( Spike_Rates(    :, ch ));
           Spike_Rates_each_channel_std( ch )  = mea_Std_defined( Spike_Rates(   :, ch )); 
           Total_spikes_each_channel( ch ) = length( index_r_chan_times{ ch });     
           Total_firing_rates_each_channel( ch ) = Total_spikes_each_channel( ch ) ;
       end
       
       
    BurstDurations = burst_end(:) - burst_start(:) ;
    Total_spikes_number = sum(   Total_spikes_each_channel ) ;
    clear index_r_chan_times ;

    
      for ch = 1 : N   
%            Firing_Rates_each_channel_mean( ch )  = mea_Mean_defined( Firing_Rates( : , ch ));
%            Firing_Rates_each_channel_std( ch )  = mea_Std_defined( Firing_Rates( : , ch ));  
           Firing_Rates_each_channel_mean( ch )  = Spike_Rates_each_channel_mean( ch ) / ( mean( BurstDurations ) / 1000 );
           Firing_Rates_each_channel_std( ch )  = Spike_Rates_each_channel_std( ch ) / ( std( BurstDurations )/ 1000 );
       end

    Number_of_bursts = Nb




