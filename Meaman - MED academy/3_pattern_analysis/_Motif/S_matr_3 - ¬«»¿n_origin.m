% S_matr_3
Nbs =     200 ;  % total number of bursts
Nt =       20 ;  % number of simulation bursts
Noise =   0 ;  % noise amplitude , ms
Ts =        8 ;  % threshold for similarity , ms
Noise = Noise  ;
Ts = Ts  ;
maxlen = 100000 ;
MIN_SPIKES_PER_PATTERN = N * 0.2 ;

Show_Plots = Show_pattern_dur_hist ;

Nb;
Nt = Nb   ;
Nbs = Nt + Nb ;
% whos motif


A = zeros( Nb , N ) ;
ss = 0 ;
dur = [] ;
for t = 1 : Nb
    ch = 0 ;
    y = 0 ;
    for s = 1 : N
        ch = ch + H( motif( t , s ) ) * motif( t , s ) ;
        y = y + H( motif( t , s ) ) ;
    end
    ch = ch / y ;
    for s = 1 : N
        A( t , s ) = H( motif( t , s ) ) * ( motif( t , s ) - ch ) ;
    end
    ss = ss + max( A( t , : ) ) - min( A( t , : ) ) ;
    dur = [ dur  max( A( t , : ) ) - min( A( t , : ) )  ] ;
end
if Show_Plots == 'y'
figure
hist(  dur ) ;
xlabel( 'Pattern duration, ms' )
Mean_activation_pattern_duration = mean(dur) ;
Std_activation_pattern_duration = std(dur) ;
Mean_activation_pattern_duration  
Std_activation_pattern_duration 
end
window =  mean( dur)  ; % time window for burst simulation , ms
%  max( dur ) / 23
%  min( dur ) / 20
avg_pattern_dur_ms = window  ;
avg_pattern_duration = avg_pattern_dur_ms   ;


%for Ts = 0 : 10
Global_R_pattern = [] ;
Global_R_surr = [] ;
S = zeros( Nbs ) ;
M = [] ;
x = [] ;
mean_y = [] ;
Curr_burst = 0 ;
Surr_dur = [] ;
Surrogates = zeros( Nt * 2 , N );
sur_num = 1 ;
for t = 1 : Nbs
    for s = 1 : Nbs
        if t < s
            if s <= Nbs - Nt               
                
                ch = 0 ;
                y = 0 ;
                mx = max( A( t , : ) );
                mn = min( A( t , : ) );
                for k = 1 : N
%                     ch = ch + H( motif( mod( t , Nb ) + 1 , k ) ) * H( motif( mod( s , Nb ) + 1 , k ) ) * ...
%                         round( ( A( mod( t , Nb ) + 1 , k ) - A( mod( s , Nb ) + 1 , k ) + ( Noise * rand() ) ) ^ 2 ) ;

                    ch = ch + H( motif( t , k ) ) * H( motif( s , k ) ) * ...
                        ( A( t , k ) - A( s , k ) + ( Noise * rand() ) ) ^ 2  ;
                    
                    y = y + H( motif( t  , k ) ) * H( motif( s , k ) ) ;
                end
                mean_y = [ mean_y y ] ;
                if ( y > MIN_SPIKES_PER_PATTERN )
                S( t , s ) = sqrt( ch / y ) ;
                M = [ M S(t,s) ] ;
                S( s , t ) = S( t , s ) ;
                Global_R_pattern = [ Global_R_pattern S( t , s ) ] ;
                end
                
            else
%                 if t > Nbs - Nt
                    ss = 0 ;
                    
         
                    NBurst_rand_num1 = floor(rand() * (Nb-1)) +1 ;
                    NBurst_rand_num2 = floor(rand() * (Nb-1)) +1 ;
                    while NBurst_rand_num2 == NBurst_rand_num1 
                    NBurst_rand_num2 = floor(rand() * (Nb-1)) +1 ;
                    end   
                    
                    
                    Y=  RandomArrayN( N );                    
                    Z =  RandomArrayN( N );
                    
                    Surr1 = zeros( N, 1 ) ;
                    Surr2 = zeros( N, 1 );
                    Surr1_s = zeros( N, 1 ) ;
                    Surr2_s = zeros( N, 1 );
                    for k = 1 : N
%                         randch1 = floor(rand()*(N-1) )+1 ;
%                         randch2 = floor(rand()*(N-1) )+1 ;
%                         Surr1( k ) =  A( NBurst_rand_num1 , randch1 ) ;
%                         Surr2( k ) =  A( NBurst_rand_num2 , randch2 ) ;
                        Surr1( k ) =  A( NBurst_rand_num1 , Y(k) ) ;
                        Surr2( k ) =  A( NBurst_rand_num2 , Z(k) ) ;
                        Surr1_s( k ) =   H( motif( NBurst_rand_num1 , Y(k)) ); 
                          Surr2_s( k )  = H( motif( NBurst_rand_num2 , Z(k)) ); 
                    end
                    Surrogates( sur_num , : ) = Surr1( : ) ;
                    Surrogates( sur_num + 1 , : ) = Surr2( : ) ;
                    
%                     dur1 = round(max( A( NBurst_rand_num1 , : ) ) - min( A( NBurst_rand_num1 , : ))) ;
%                     Surr1 = round( rand( N , 1 ) * dur1 ) ;
%                     
%                      dur2 = round(max( A( NBurst_rand_num2 , : ) ) - min( A( NBurst_rand_num2 , : ))) ;                       
%                     Surr2 = round( rand( N , 1 ) * dur2   ) ;              
                    
                    sd1 = max(Surr1( : )) - min(Surr1( : )) ;
                    sd2 = max(Surr2( : )) - min(Surr2( : )) ;
                    Surr_dur = [ Surr_dur  sd1 sd2 ];
%                     surr_dur =  max( dur )- min( dur );
%                     meandurr = mean( dur ) ;
%                     dur1 = round( randn()*surr_dur / 6 +surr_dur/2+ min( dur )) ;
%                     Surr1 = round( randn( N , 1 ) * surr_dur /3 ) ;

%                     dur1 = round(randn()*surr_dur / 6 +surr_dur/2+ min( dur )) ;
%                     Surr2 = round( randn( N , 1 ) * surr_dur /3 );                    
                    y = 0 ;
                    for k = 1 : N
%                         randch1 = floor(rand()*(N-1) )+1 ;
%                         randch2 = floor(rand()*(N-1) )+1 ;
%                           randch1 =  Y(k) ;
%                           randch2 = Z(k)  ;
%                         ss = ss +  H( motif( NBurst_rand_num1 , randch1 ) ) * H( motif(NBurst_rand_num2 , randch2 ) )* ...
%                         ( Surr1( k ) - Surr2( k ) + ( Noise * rand() )  ) ^ 2 ;
%                         y = y + H( motif( NBurst_rand_num1  , randch1 ) ) * H( motif( NBurst_rand_num2 , randch2 ) ) ;
                        
                         ss = ss +  Surr1_s( k )  * Surr2_s( k )  * ...
                        ( Surr1( k ) - Surr2( k ) + ( Noise * rand() )  ) ^ 2 ;
                        y = y + Surr1_s( k )  * Surr2_s( k ) ;
                    end
                    mean_ch_y = round( mean( mean_y ) ) ;
                    
                    if y > MIN_SPIKES_PER_PATTERN 
                    S( t , s ) = sqrt( ss / y ) ;
                    x = [ x sqrt(ss/y) ] ;
                    S( s , t ) = S( t , s ) ;
                    
                    Global_R_surr = [ Global_R_surr S( t , s ) ] ;
                
                    end
%                 else
%                  ss = 0 ;
%                  for k = 1 : N
%                      ss = ss + H( motif( mod( s , Nb ) + 1 , k ) ) * round( ( A( mod( s , Nb ) + 1 , k ) - window * randn( 1 ) / 6 ) ^ 2 ) ;
%                  end
%                  S( t , s ) = sqrt( ss / N ) ;                 
%                  x = [ x sqrt(ss/N) ] ;
%                  S( s , t ) = S( t , s ) ;
%                  end
            end
        end
    end
end
% figure
%  hist( mean_y ) 
ActEl = mean( mean_y ) ;
if isempty( x )
    x = 0 ;
end
t = ( H( max( M ) - max( x ) ) * max( M ) + H( max( x ) - max( M ) ) * max( x ) )  ;


% whos Global_R_pattern
% whos Global_R_surr

% [h_null_hipothesys , p_value ]= ttest2(Global_R_pattern , Global_R_surr );
[p_value,h_null_hipothesys] = ranksum(Global_R_pattern,Global_R_surr);
% h_null_hipothesys
% p_value

P_val = p_value ;
T_val = h_null_hipothesys ;

f=0;
% for i = 1 : length(Global_R_pattern)
%   f=f+ttest2( Global_R_surr , Global_R_pattern(i) );  
% %     [p,h]=ranksum( Global_R_surr , Global_R_pattern(i));
% %     f=f+ h ;
% end
f = length( find( Global_R_pattern(:) < min(Global_R_surr) ) );
f=f/length(Global_R_pattern) ;
Not_random_pairs = f ;


mean_Global_R_pattern = mean( Global_R_pattern )  ;
mean_Global_R_surr = mean( Global_R_surr )  ;
std_Global_R_pattern = std( Global_R_pattern )  ;
std_Global_R_surr = std( Global_R_surr )  ;
% mean_Global_R_pattern
% std_Global_R_pattern
% mean_Global_R_surr 
% std_Global_R_surr

% save motif2

% figure( 2 )
% imagesc( S )
% colorbar( 'vert' )

% figure
% mean_ch = zeros(  N,1) ;
%  for k = 1 : N
% mean_ch( k ) = mean( A(:, k) );
%  end
%  hist( mean_ch / 20 ) ;
%  xlabel( 'Real pattern spike histogram' )

 
% figure
% mean_ch = zeros(  N,1) ;
%  for k = 1 : N
% mean_ch( k ) = mean( Surrogates(:, k) );
%  end
%  hist( mean_ch / 20 ) ;
%  xlabel( 'Surrogates spike histogram' )
 
%  
%  
%  Surrogates( 1 , : )
%  A(1,:) 
 
 
% figure
% hist( Surr_dur/20 , 20 );
% xlabel( 'Surrogate duration, ms' )


if Show_Plots == 'y'
a = [] ;
sh = [] ;
% figure
% subplot( 2 , 1 , 1 ) ;
% hist( M , 20 )
[ a( : , 1 ) , a( : , 2 ) ] = hist( M , 20 ) ;
[ sh( : , 1 ) , sh( : , 2 ) ] = hist( x , 20 ) ;
% axis( [ 0 t 0 max(a(:,1)) ] )
% subplot( 2 , 1 , 2 ) 
% if Nt > 0
%     hist( x , 20 )
% %     [ sh( : , 1 ) , sh( : , 2 ) ] = hist( x , 50 ) ;
%     axis( [ 0 t 0 max(sh(:,1)) ] )
% else
%     plot( x ) ;
% end
% figure
plot(  a( : , 2 ) , a( : , 1 )/  max( a( : , 1 )) ,  sh( : , 2 ) , sh( : , 1 )/max(sh( : , 1 ) ) ); 
title( 'Similarity distributions for real and surrogate data')
end


if ( 1 < 0 )

S1 = S ;
x = [] ;
ch = [ 0 0 ] ;
M = [] ;
for t = 1 : Nbs
    S1( t , t ) = max( max( S ) ) ;
    M( t ) = t ;
end
Nmotif = 1 ;
Nset = 2 ;

k = find( S == min( min( S1 ) ) , 1 ) ;
y = S( k ) ;
x = [ x ; H(k-floor(k/Nbs)*Nbs)*(k-floor(k/Nbs)*Nbs)+H(floor(k/Nbs)*Nbs-k)*Nbs S(k) ; ceil(k/Nbs) S(k) ] ;
S1( H( k - floor( k / Nbs ) * Nbs ) * ( k - floor( k / Nbs ) * Nbs ) + H( floor( k / Nbs ) * Nbs - k ) * Nbs , : ) = [] ;
S1( : , H( k - floor( k / Nbs ) * Nbs ) * ( k - floor( k / Nbs ) * Nbs ) + H( floor( k / Nbs ) * Nbs - k ) * Nbs ) = [] ;
M( H( k - floor( k / Nbs ) * Nbs ) * ( k - floor( k / Nbs ) * Nbs ) + H( floor( k / Nbs ) * Nbs - k ) * Nbs ) = [] ;
k = ceil( k / Nbs ) ;
while length( S1 ) > 1
    t = find( S1( : , k ) == min( S1( : , k ) ) , 1 ) ;
    x = [ x ; M(t) S1(t,k) ] ;
    if S1( t , k ) > Ts && y < Ts && S1( t , k ) - y > Ts - Noise / 4
        Nset = [ Nset 0 ] ;
        Nmotif = Nmotif + 1 ;
    end
    if S1( t , k ) < Ts && y > Ts && S1( t , k ) - y < Noise / 4 - Ts
        Nset( Nmotif ) = 1 ;
    end
    Nset( Nmotif ) = Nset( Nmotif ) + 1 ;
    ch = [ ch S1(t,k)-y ] ;
    y = S1( t , k ) ;
    S1( k , : ) = [] ;
    S1( : , k ) = [] ;
    M( k ) = [] ;
    t = t - H( t - k ) ;
    k = t ;
end
Nmotif = Nmotif - 1 ;
Nset( Nmotif + 1 ) = [] ;

Nset
Nmotif
figure
subplot( 2 , 1 , 1 ) ; plot( x(:,2) )
subplot( 2 , 1 , 2 ) ; plot( ch , 'r' )



% M = [] ;
% y = 0 ;
% for t = 1 : Nb
%     s = find( Nset == max( Nset ) , 1 ) ;
%     y = y + Nset( s ) * Nb / ( Nbs - Nt ) ;
%     Nset( s ) = [] ;
% end
% M = [ M y ] ;
% end
% figure( 5 )
% bar( M )

end 