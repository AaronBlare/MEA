
% Plot_Detailed_Raster
% create figure before this script

hold on    
                        % Raster plot
                        vertHexX=[  0 0     ] ;
                        vertHexY=[  0 0.5       ] ; 
                        plotCustMark(  index_r(:,1)/1000  , index_r(:,2) ,vertHexX,vertHexY, 1.5)
                        % -------
 
                        if ~isempty( x )
                plot( x ,  y  ,'MarkerEdgeColor',[.04 .52 .78]) , grid on
                        end
                        if ~isempty( xt )
                plot( xt ,  yt  , 'r' )
                        end

                if exist( 'burst_start' , 'var')
                    if ~isempty( burst_start )
                    for bi = 1  : length( burst_end )
                       xbi_start =   burst_start(bi)/1000 ;
                       xbi_end =   burst_end(bi)/1000 ;

                       plot( [ xbi_start xbi_start ]  ,  [ 0 60]  , '--*r' )
                       plot( [ xbi_end xbi_end ]  ,  [ 0 60  ]  , '--*r' )

                    end
                    end
                end

                hold off
                title( 'Detected bursts')
                xlabel('Time, s')
                ylabel('TSR, spikes per bin (% of max TSR)')  
                legend( 'Spikes', 'TSR' , 'Detection threshold', 'Burst start, end')