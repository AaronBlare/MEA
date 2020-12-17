% Extract_bursts_spikes
function [bursts]= Extract_bursts_spikes( burst_start,burst_end, index_r , time_shift )

random_channel = 'n' ;
Nb = length( burst_start ) ;
N = 64 ;
x = time_shift ;

bursts = zeros( Nb , N ) ;

for t = 1 : Nb
rand_CH = RandomArrayN( N );                 
  for ch = 1 : N           
        if random_channel == 'y'
            channel = rand_CH( ch );
        else    
            channel = ch ; % 
        end               
%         if one_burst_part_at_all == 'y'
%             if round(x) > one_burst_from && round(x) <= one_burst_to        
%                    ss = find( index_r( : , 1 ) >= burst_start( 1 ) + round(x) & ...            
%                    index_r( : , 1 ) < burst_end( 1 ) & index_r( : , 2 ) == channel , 1 ) ;       
%                if isempty( ss ) ~= 1
%                   motif( t , ch ) = index_r( ss , 1 )  - burst_start( 1 );  
% %                   burst( t , ch ) = index_r( ss , 1)* 20-  burst_start( 1 )*20;
%                end 
%             else
%                   ss = find( index_r( : , 1 ) >= burst_start( t ) + round(x) & ...            
%                   index_r( : , 1 ) < burst_end( t ) & index_r( : , 2 ) == rand_CH( ch ) , 1 ) ;       
%                 if isempty( ss ) ~= 1
%                    motif( t , ch ) = index_r( ss , 1 )  -  burst_start( t ); 
% %                    burst( t , ch ) = index_r( ss , 1)* 20-  burst_start( t )*20;
%                end 
%             end    
%         else
                
        ss = find( index_r( : , 1 ) >= (burst_start( t ) + round(x)) & ...            
            index_r( : , 1 ) < burst_end( t ) & index_r( : , 2 ) == channel , 1 ) ;       
          if isempty( ss ) ~= 1
              bursts( t , ch ) = index_r( ss , 1 )  -  ( burst_start( t )  + round(x) );
          end
        
        end
      

end