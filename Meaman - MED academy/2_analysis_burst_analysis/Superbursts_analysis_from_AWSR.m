%-----------%-----------%-----------%-----------%----------- 
%-----------% Superbursts_analysis_from_AWSR %-----------%----------- 
%   if ~Search_Params.use6well_raster

    % Superbursts detection %-----------%-----------%----------- 
    % Tsuper_sec = 50 ; % Superburst length , sec
    Tsuper_sec = Search_Params.SsuperBurst_scale_sec ; % Superburst length , sec
    Tsuper = (Tsuper_sec / 10 )   *  1000 / TimeBin  ;
    params.Search_Params = Search_Params ;
    SB_min_duration = Search_Params.SB_min_duration ;
    SB_max_duration = Search_Params.SB_max_duration ;    
    
    if Search_Params.Binary_burst_coding
        AWSR  = AWSR_to_binary( TimeBin , (numel(AWSR)-1)*TimeBin , burst_max ) ;
    end
    
    [ SB_start , SB_end , bursts_per_super_bursts] = SuperBurst( AWSR  ,  Tsuper , 5 , TimeBin , params );
    N_SB = length( SB_start ); %Number of superbursts
    %-------------
    % Check number of usual bursts inside Superb, filter if its number < 2
    MIN_burst_per_Superburst = 2 ;

    burst_in_superbursts = [];
    burst_index_in_Superbursts = []; 
    burst_index_in_each_Superbursts = {}; 
    for si = 1 : N_SB
        NB_in_SB = find( SB_start( si ) < burst_start &  burst_start <  SB_end( si )  );
        burst_index_in_Superbursts= [ burst_index_in_Superbursts  NB_in_SB ] ;
        burst_index_in_each_Superbursts = [burst_index_in_each_Superbursts NB_in_SB] ;
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
            
%             SB_max_duration = 50000 ;

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
    mean_Super_Durations_sec = mean_Super_Durations / 1000 ;
    
    N_SB = length( SB_start ); 
    Number_of_Superbursts = N_SB 
    Superbrsts.burst_in_superbursts = burst_in_superbursts ;
    Superbrsts.burst_index_in_Superbursts =  burst_index_in_Superbursts ;
    Superbrsts.burst_index_in_each_Superbursts = burst_index_in_each_Superbursts ;
    Superbrsts.SB_start = SB_start ;
    Superbrsts.SB_end = SB_end ;
    Superbrsts.SB_InterSBurstInterval = SB_InterSBurstInterval ;
    Superbrsts.Number_of_Superbursts = Number_of_Superbursts ;
    Superbrsts.SB_duration = SB_duration ;
    Superbrsts.SB_duration_sec = SB_duration / 1000 ;
    SUPERBURSTS = Superbrsts ;

    mean_Super_Durations_sec
    
%-----------%-----------%-----------%-----------%-----------