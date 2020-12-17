window =   1000 ; % large time window, ms
dT =        100 ; % small time window, ms
IBI =      1000 ; % min interval between nearby birsts, ms
t_pre =     100 ; % Interval between start of burst and 'timing'
t_post =    200 ; % -''-''-  between 'timing' and finish
window = window * 20 ;
dT = dT * 20 ;
IBI = IBI * 20 ;
t_pre = t_pre * 20 ;
t_post = t_post * 20 ;
k = window / dT ;
Nt = ceil( Tmax / window ) * k ;

Nb = 0 ;              % Number of bursts
M = zeros( k , 2 ) ;  % Coupled values - time in 'window' and number of active neurons
timing = [] ;         % Time moment with max active neurons in each burst
t = 0 ;
s = 0 ;
sh = 0 ;

while t < 2 * Nt - k
    T1 = ( t - sh ) * dT ;
    t = t + 1 ;
    s = s + 1 ;
    M( s , 1 ) = T1 ;
    M( s , 2 ) = 0 ;
    for ch = 1 : N
        channel_index = find( index_r( : , 2 ) == ch ) ;
        ss = length( channel_index ) ;
        if ss ~= 0
            y = 1 ;
            while ( index_r( channel_index( y ) , 1 ) < T1 || index_r( channel_index( y ) , 1 ) >= T1 + dT ) && y < ss
                y = y + 1 ;
            end
            if y ~= ss || ( y == ss && index_r( channel_index( y ) , 1 ) >= T1 && index_r( channel_index( y ) , 1 ) < T1 + dT )
                M( s , 2 ) = M( s , 2 ) + 1 ;
            end
        end
    end
    if s == k
        y = find( M( : , 2 ) == max( M( : , 2 ) ) , 1 ) ;
        if max( M( : , 2 ) ) >= 20 && ( Nb == 0 || M( y , 1 ) - timing( Nb ) > IBI )
            Nb = Nb + 1 ;
            timing( Nb ) = M( y , 1 ) ;
            t = t + IBI / dT ;
            sh = sh + window / 2 / dT ;
        end
        s = 0 ;
        sh = sh + k / 2 ;
    end
end

timing
Nb
%burst = [] ;
motif = zeros( Nb , N ) ;
motif = motif - 1 ;

for t = 1 : Nb
    for ch = 1 : N
        ss = find( index_r( : , 1 ) >= timing( t ) - t_pre & index_r( : , 1 ) < timing( t ) + t_post & index_r( : , 2 ) == ch , 1 ) ;
        if ~isempty( ss )
            motif( t , ch ) = index_r( ss , 1 ) *20;
        end
%         for s = 1 : k
%             burst( t , ss( k - s + 1 ) , : ) = index_r( ss( k - s + 1 ) , : ) ;
%             index_r( ss( k - s + 1 ) , : ) = [] ;
%         end
    end
end
