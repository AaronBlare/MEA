

% Raster_cut_outside_interval
% input: index_r Edit_from Edit_to (ms)

ss = find( index_r( : , 1 ) >= Edit_from & index_r( : , 1 ) < Edit_to ) ;
       if ~isempty( ss )
            index_r( ss , : ) = [] ;
       end 
       
       
 mint = min( index_r(:,1) );
 maxt = max(  index_r(:,1) );
 if maxt - mint < mint 
    index_r(:,1) = index_r(:,1) - mint + 100 ;  
 end      
       









