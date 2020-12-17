% Analyze_preBursts_to_stim2
% input: filename or index_r_spont
% output: Bad_artefacts_filt


% burst_start - responses starts
% ANALYZED_DATA.burst_start - spont bursts

Analyze_pre_bursts = false ;
Analyze_pre_bursts = true ;
Show_marked_artefacts_after_analysis = Global_flags.Erase_Inadequate_Patterns_preStim_show_raster ;
 
%-------------------------------------------------------------------------
%---- Find correlation between slow spont. activity and response ---------

A_dt = Global_flags.Erase_Inadequate_Patterns_preStim_delay ;  
pre_art_thres = Global_flags.Erase_Inadequate_Patterns_preStim_SpikesThr  ; % spikes ;

% if ~isempty( filename )
%     index_r = load( char( filename ) ) ;  
%     [pathstr,name,ext] = fileparts( filename ) ; 
%      if  ext == '.mat'  
%          index_r = RASTER_data.index_r ;
%      end
% end
    
    % start analyse from first response
    start_time =  Patterns.artefacts(1);
%     index_r(  : ,1 ) = index_r(  : ,1 ) - start_time;
%     artefacts_2 = artefacts - start_time ;
    
    Median_Inter_Artifact_Interval_sec = median( diff( Patterns.artefacts))/ 1000 
    dT = Median_Inter_Artifact_Interval_sec ;
    Median_Inter_Artifact_Interval_ms = Median_Inter_Artifact_Interval_sec * 1000 ;

    
    Tdim = 0 ; % ms
    Tmax =  max(index_r_spont(:,1) )   ; % ms
    Nt = floor(Tmax / dT) +1; 
    N = max( index_r_spont( : , 2 ));  
    if N < 60
        N = 60 ;
    end

    ASDR = zeros(1,length( Patterns.artefacts )) ;
    Bad_artefacts_filt= [] ;
    
    check = 0 ;
    for ai = 1 : length( Patterns.artefacts )
%      if  index_r_spont(  :  ,1 )  >  0 
%          Asdr_ti = floor( index_r(  ti  ,1 ) / dT )+1  ;
%          spikes_in_interval = find(( index_r(  :  ,1 ) >= artefacts( ai ) - ( Median_Inter_Artifact_Interval_ms - A_dt ) &  ...
%          (index_r(  :  ,1 ) < artefacts( ai   ))));
     
          spikes_in_interval = find(( index_r_spont(  :  ,1 ) >= Patterns.artefacts( ai ) -    A_dt   &  ...
         (index_r_spont(  :  ,1 ) < Patterns.artefacts( ai   ) - 5 )));
     
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
    
 
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------

if Analyze_pre_bursts
 
    %% Raster with arts
  if Show_marked_artefacts_after_analysis
    
%     Art = artefacts_origin      ;
       Art = Patterns.artefacts       ;
       
if Bad_artefacts_filt > 0
    SA_starts = Art ; 
SA_starts( Bad_artefacts_filt ) = [] ;  
else
    SA_starts =Art ; 
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

