% Analyze_preBursts_to_stim



% burst_start - responses starts
% ANALYZED_DATA.burst_start - spont bursts

Analyze_pre_bursts = false ;
Analyze_pre_bursts = true ;
Show_marked_artefacts_after_analysis = false ;

%-------------------------------------------------------------------------
%---- Find correlation between slow spont. activity and response ---------

A_dt = Global_flags.Erase_Inadequate_Patterns_preStim_delay ;  
pre_art_thres = Global_flags.Erase_Inadequate_Patterns_preStim_SpikesThr  ; % spikes ;

    index_r = load( char( filename ) ) ;  
    [pathstr,name,ext] = fileparts( filename ) ; 
     if  ext == '.mat'  
         index_r = RASTER_data.index_r ;
     end
    
    % start analyse from first response
    start_time =  artefacts(1);
%     index_r(  : ,1 ) = index_r(  : ,1 ) - start_time;
%     artefacts_2 = artefacts - start_time ;
    
    Median_Inter_Artifact_Interval_sec = median( diff( artefacts))/ 1000 
    dT = Median_Inter_Artifact_Interval_sec ;
    Median_Inter_Artifact_Interval_ms = Median_Inter_Artifact_Interval_sec * 1000 ;

    
    Tdim = 0 ; % ms
    Tmax =  max(index_r(:,1) )   ; % ms
    Nt = floor(Tmax / dT) +1; 
    N = max( index_r( : , 2 ));  
    if N < 60
        N = 60 ;
    end

    ASDR = zeros(1,length( artefacts )) ;
    Bad_artefacts_filt= [] ;
    
    check = 0 ;
    for ai = 1 : length( artefacts )
%      if  index_r(  :  ,1 )  >  0 
%          Asdr_ti = floor( index_r(  ti  ,1 ) / dT )+1  ;
%          spikes_in_interval = find(( index_r(  :  ,1 ) >= artefacts( ai ) - ( Median_Inter_Artifact_Interval_ms - A_dt ) &  ...
%          (index_r(  :  ,1 ) < artefacts( ai   ))));
     
          spikes_in_interval = find(( index_r(  :  ,1 ) >= artefacts( ai ) -    A_dt   &  ...
         (index_r(  :  ,1 ) < artefacts( ai   ) - 5 )));
     
         if ~isempty( spikes_in_interval )
              ASDR( ai ) =   ASDR( ai ) + length( spikes_in_interval ) ;  
              if length( spikes_in_interval ) > pre_art_thres
                 Bad_artefacts_filt = [ Bad_artefacts_filt ai ];
              end
         end
         
%      end
    end
%     check
%     ASDR(1)
    
    figure
    subplot( 2,1,1)
    title( 'Spontaneous activity vs. Responses')
    hold on
    x = 1:length( Patterns.artefacts);
    plot(x , Patterns.Spike_Rates_each_burst , '-*r' )
    plot(x - 0.5 , ASDR  ,'-*' )
    xlabel( 'artifact number')
    ylabel( 'Spikes #')
    legend( 'Spikes in response' , 'Spont. activity' )
    
    subplot( 2,1,2)
     
    [xc,lags] = xcorr( Patterns.Spike_Rates_each_burst, ASDR , 4  , 'none');
     plot( lags ,xc  , '-*' )
     xlabel( 'lag, intervals between stimuli (>0 Spont++)')
    ylabel( 'Correlation')
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------

if Analyze_pre_bursts

%     ANALYZED_DATA = MED_AWSR_Find_Bursts( filename ,  Params.Search_Params )  ;

%----------------------------------------------
%% find all bursts from raster  
%     ready_to_analyze = true ;
%     Arg_file.Use_meaDB_raster = false ;
%     buf3 = Global_flags.autosave_to_DB  ;
%     buf2 = Search_Params.save_bursts_to_files  ;
%     buf = Search_Params.Chambers_Separate_analysis_AB ;
% 
%     Search_Params.Chambers_Separate_analysis_AB = false ;
%     Global_flags.autosave_to_DB = false ;
%     Search_Params.save_bursts_to_files = false ;
%     Search_Params.Show_figures = true ;
%     params.show_detection_bursts = true ;
%     index_r_buf = index_r ;
%     
%     % prepare raster for spont bursts analysis -------------
%     
%     Edit_from = artefacts_origin(1);
%     Edit_to = artefacts_origin( end ) + Global_flags.Global_Poststim_interval_END ;
%     ss = find( index_r( : , 1 ) < Edit_from );
%        if ~isempty( ss )
%             index_r( ss , : ) = [] ;
%        end 
%      ss = find( index_r( : , 1 ) >= Edit_to );
%        if ~isempty( ss )
%             index_r( ss , : ) = [] ;
%        end   
%       
%        DTs = 10  ;
%        for ai = 1 : length(artefacts_origin)
%            ss = find( (index_r( : , 1 ) > artefacts_origin(ai,1) - DTs )&  ...
%                       (index_r( : , 1 ) < artefacts_origin( ai,1) + DTs) );
%            if ~isempty( ss )
%                 index_r( ss , : ) = [] ;
%            end 
%        end
%  
% %        Anallysis_Figure_title_buf = Anallysis_Figure_title ;
%        Anallysis_Figure_title = 'Spont in stim response' ;
%     %---------
%     Find_bursts_main_script
%     %---------
%     % Now ANALYZED_DATA contain spont bursts
%  
% %     Anallysis_Figure_title = Anallysis_Figure_title_buf ;
%     Global_flags.autosave_to_DB = buf3 ;
%     Search_Params.Chambers_Separate_analysis_AB = buf ;
%     Search_Params.save_bursts_to_files = buf2 ;
    
    %----------------------------------------------
%% ----------------------------------------------

%     preStim_burst_DELAYS = [] ;
%     preStim_burst_Magnitude = [] ;
%     Stim_resp_Magnitude = [] ;
%     Bad_artefacts = [] ;
%     Bad_artefacts_filt =[   ] ;
% 
%     for i=1:  length( artefacts )  
%       preBursts_i = find( Patterns.artefacts( i ) > ANALYZED_DATA.burst_end  );
%     %   bursts_predelays = burst_start( i ) - ANALYZED_DATA.burst_start( preBursts_i ) ;
%       if ~isempty( preBursts_i )
%         preBurst_index = preBursts_i(end) ;  
%         preStim_burst_delay = Patterns.artefacts( i ) - ANALYZED_DATA.burst_end( preBurst_index )   ;
%         preStim_burst_magnitude = ANALYZED_DATA.Spike_Rates_each_burst( preBurst_index ) ;
%         
%         Bad_artefacts =[ Bad_artefacts i ] ;
%        preStim_burst_DELAYS = [ preStim_burst_DELAYS preStim_burst_delay ];
%       preStim_burst_Magnitude = [preStim_burst_Magnitude  preStim_burst_magnitude ] ; 
%       Stim_resp_Magnitude = [Stim_resp_Magnitude Patterns.Spike_Rates_each_burst( i ) ];
%       
%       if preStim_burst_delay > 0  && preStim_burst_delay < 500 
%         if preStim_burst_magnitude > 10 
%              Bad_artefacts_filt =[ Bad_artefacts_filt i ] ;
%         end
%       end
%       
%         if i > 1
%          %
%          if  ANALYZED_DATA.burst_start( preBurst_index ) < burst_start( i - 1 )  
%             preStim_burst_delay = 0 ;
%          end 
%          if  ANALYZED_DATA.burst_start( preBurst_index ) < artefacts( i - 1 )  
%             preStim_burst_delay = 0 ;
%          end 
%          
%         end
%       else
%         preStim_burst_delay = 0 ;
%         preStim_burst_magnitude = 0 ;
%       end
% 
% 
% 
%     end
%     preStim_burst_DELAYS = preStim_burst_DELAYS / 1000 ;
% 
%     figure
%     % subplot( 2,1,1)
%     % plot( Stim_resp_Magnitude , preStim_burst_DELAYS , '*');
%     % xlabel( 'Spikes in response' );
%     % ylabel( 'Spont. Burst predelay, s');
%     % 
%     % subplot( 2,1,2)
%     % plot( Stim_resp_Magnitude , preStim_burst_Magnitude , '*' );
%     % xlabel( 'Spikes in response' );
%     % ylabel( 'Spont. Burst spikes');
% 
%     subplot( 2,1,1) 
%     scatter(Stim_resp_Magnitude,preStim_burst_DELAYS,[], preStim_burst_Magnitude,'filled')
%     xlabel( 'Spikes in response' );
%     ylabel( 'Spont. Burst predelay, s');
%     legend( 'Color-spikes in burst');
%     colorbar
% 
%     subplot( 2,1,2) 
%     scatter(Stim_resp_Magnitude,preStim_burst_Magnitude,[],preStim_burst_DELAYS ,'filled')
%     xlabel( 'Spikes in response' );
%     ylabel(  'Spont. Burst spikes');
%     legend( 'Color-Burst predelay, s');
%     colorbar
% 
%     x=0;
%     
    %% Raster with arts
  if Show_marked_artefacts_after_analysis
    
    Art = artefacts_origin      ;
      
if Bad_artefacts_filt > 0
    SA_starts = artefacts_origin ; 
SA_starts( Bad_artefacts_filt ) = [] ;  
else
    SA_starts =artefacts_origin ; 
end



%  index_r  = index_r_buf ;
 
f = figure;
figure_title  = 'Raster' ;
 set(f, 'name', figure_title , 'numbertitle','off' )
 x = [  ]; y = [  ]; 
 xt= [  ]; yt = [  ]; 
 burst_start = [] ; 
 
Plot_Detailed_Raster
 
hold on 

dy = 0.5;
plot( Art /1000  ,  61 + dy  , 'v', 'Linewidth' , 1  )
 
if ~isempty(SA_starts)
plot( SA_starts /1000  ,  62+ dy   , 'x', 'Linewidth' , 1  )
end


legend( 'v - Original artifacts', 'x - Clean responses' )  
 
hold off     
           

  end
end

