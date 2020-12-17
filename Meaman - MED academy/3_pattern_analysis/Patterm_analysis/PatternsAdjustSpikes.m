% adjust spike times to average spike time in pattern
function [A, dur ] = PatternsAdjustSpikes( motif , ADJUST_SPIKES )


siz = size( motif) ;
Nb = siz(1);
N = siz(2);
A = zeros( Nb , N ) ;
dur = [] ;
for t = 1 : Nb
    ch = 0 ;
    y = 0 ;
    for s = 1 : N
        ch = ch + H( motif( t , s ) ) * motif( t , s ) ;
        y = y + H( motif( t , s ) ) ;
    end
    if y == 0 ;
        ch = 0 ;
    else
    ch = ch / y ;
    end
    if ADJUST_SPIKES == true       
        mint =  min(motif( t , : )) ;
    else    
        mint =0 ;
    end
    for s = 1 : N
        A( t , s ) = H( motif( t , s ) ) * ( motif( t , s ) - mint + 1 - ch * 0  ) ;
    end
    
    B = A( t , : );
    B( B==0 ) = []; 
    minB = min(B);
    if isempty( B ) 
        minB = min( A( t , : )); 
    end
%     minB = min( A( t , : ));
    if ADJUST_SPIKES == true       
%         dur = [ dur  max( A( t , : ) ) - min( A( t , : ) )  ] ;
        dur = [ dur  max( A( t , : ) ) - minB  ] ;
    else    
        dur = [ dur  max( A( t , : ) ) ] ;
    end   
   
end
