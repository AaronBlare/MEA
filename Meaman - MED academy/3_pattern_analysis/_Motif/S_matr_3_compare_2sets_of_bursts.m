% S_matr_3_compare_2sets_of_bursts
Show_Plots = Show_pattern_dur_hist ;


Noise =   0 ;  % noise amplitude , ms
MIN_SPIKES_PER_PATTERN = N * 0.2 ;

[A, dur ] = PatternsAdjustSpikes( motif) ;
[A2, dur2 ] = PatternsAdjustSpikes( motif2) ;

avg_pattern_duration =  mean( dur)  ;

if Show_Plots == 'y'
figure
hist(  dur ) ;
xlabel( 'Pattern duration, ms' )
Mean_activation_pattern_duration = mean(dur) ;
Std_activation_pattern_duration = std(dur) ;
Mean_activation_pattern_duration  
Std_activation_pattern_duration 
end
 

%for Ts = 0 : 10
Global_R_pattern = [] ;
Global_R_pattern2 = [] ;
Global_R_patternCross = [] ;
Global_R_surr_cross = [] ;
S = zeros( Nb , Nb) ;
S2 = zeros( Nb , Nb) ;
Scross = zeros( Nb , Nb2) ;
M = [] ;
x = [] ;
mean_y = [] ;
mean_yCross = [] ;
mean_y2= [] ;
Curr_burst = 0 ;
Surr_dur = [] ;
Surrogates = zeros( Nt * 2 , N );
sur_num = 1 ;
R = 0;

for t = 1 : Nb
    for s = 1 : Nb
        if t < s                       
                ch = 0 ;
                y = 0 ;
                for k = 1 : N
                    ch = ch + H( motif( t , k ) ) * H( motif( s , k ) ) * ...
                        ( A( t , k ) - A( s , k ) + ( Noise * rand() ) ) ^ 2  ;                    
                    y = y + H( motif( t  , k ) ) * H( motif( s , k ) ) ;
                end
                mean_y = [ mean_y y ] ;
                if ( y > MIN_SPIKES_PER_PATTERN )
                R = sqrt( ch / y ) ;
                S( t , s ) = R ;
                Global_R_pattern = [ Global_R_pattern R ] ;
                end
        end
    end
end



for t = 1 : Nb2
    for s = 1 : Nb2
        if t < s                       
                ch = 0 ;
                y = 0 ;
                for k = 1 : N
                    ch = ch + H( motif2( t , k ) ) * H( motif2( s , k ) ) * ...
                        ( A2( t , k ) - A2( s , k ) + ( Noise * rand() ) ) ^ 2  ;                    
                    y = y + H( motif2( t  , k ) ) * H( motif2( s , k ) ) ;
                end
                mean_y2 = [ mean_y2 y ] ;
                if ( y > MIN_SPIKES_PER_PATTERN )
                R = sqrt( ch / y ) ;
                S2( t , s ) = R ;
                Global_R_pattern2 = [ Global_R_pattern2 R ] ;
                end
        end
    end
end

% Cross motif relations
for t = 1 : Nb
    for s = 1 : Nb2      
        
                ch = 0 ;
                y = 0 ;
                for k = 1 : N
                    ch = ch + H( motif( t , k ) ) * H( motif2( s , k ) ) * ...
                        ( A( t , k ) - A2( s , k ) + ( Noise * rand() ) ) ^ 2  ;                    
                    y = y + H( motif( t  , k ) ) * H( motif2( s , k ) ) ;
                end
                mean_yCross = [ mean_yCross y ] ;
                if ( y > MIN_SPIKES_PER_PATTERN )
                R = sqrt( ch / y ) ;
                Scross( t , s ) = R ;
                Global_R_patternCross = [ Global_R_patternCross R ] ;
                end
        
    end
end

% Cross motif surrogate relations
for t = 1 : Nb
    for s = 1 : Nb2            
                    NBurst_rand_num1 = floor(rand() * (Nb-1)) +1 ;
                    NBurst_rand_num2 = floor(rand() * (Nb2-1)) +1 ;
                                    
                    Y=  RandomArrayN( N );                    
                    Z =  RandomArrayN( N );
                    
                    Surr1 = zeros( N, 1 ) ;
                    Surr2 = zeros( N, 1 );
                    Surr1_s = zeros( N, 1 ) ;
                    Surr2_s = zeros( N, 1 );
                    for k = 1 : N
                        Surr1( k ) =  A( NBurst_rand_num1 , Y(k) ) ;
                        Surr2( k ) =  A2( NBurst_rand_num2 , Z(k) ) ;
                        Surr1_s( k ) =   H( motif( NBurst_rand_num1 , Y(k)) ); 
                          Surr2_s( k )  = H( motif2( NBurst_rand_num2 , Z(k)) ); 
                    end
                    Surrogates( sur_num , : ) = Surr1( : ) ;
                    Surrogates( sur_num + 1 , : ) = Surr2( : ) ;
                    
                    sd1 = max(Surr1( : )) - min(Surr1( : )) ;
                    sd2 = max(Surr2( : )) - min(Surr2( : )) ;
                    Surr_dur = [ Surr_dur  sd1 sd2 ];
                    
                    y = 0 ;
                    ss = 0 ;
                    for k = 1 : N                        
                        ss = ss +  Surr1_s( k )  * Surr2_s( k )  * ...
                        ( Surr1( k ) - Surr2( k ) + ( Noise * rand() )  ) ^ 2 ;
                        y = y + Surr1_s( k )  * Surr2_s( k ) ;
                    end
%                     mean_ch_y = round( mean( mean_y ) ) ;
                    
                    if y > MIN_SPIKES_PER_PATTERN 
                        R = sqrt( ss / y ) ;
                    Global_R_surr_cross = [ Global_R_surr_cross R ] ;                
                    end            
        end
end

ActEl = mean( mean_y ) ;
if isempty( x )
    x = 0 ;
end

% whos Global_R_pattern
% whos Global_R_pattern2
% whos Global_R_patternCrossf

if (  isempty( Global_R_pattern )  ~= 1 && isempty( Global_R_pattern2 ) ~= 1 ...
        && isempty( Global_R_patternCross )~= 1 && isempty( Global_R_surr_cross )~= 1  )
[p_value,h_null_hipothesys] = ranksum(Global_R_pattern,Global_R_patternCross);
[p2 , h_2hipothesys] = ranksum(Global_R_pattern2,Global_R_patternCross);
[p_value_cross,h_cross_hipothesys] = ranksum(Global_R_pattern,Global_R_pattern2);
[p_value_surr_cross,h_surr_cross_hipothesys] = ranksum(Global_R_patternCross,Global_R_surr_cross);
else
    p_value = -1 ;
    h_null_hipothesys = 0 ;
    h_cross_hipothesys = 0 ;
    p2=-1;
    p_value_cross=-1;
    p_value_surr_cross = -1;    
end

P_val = p_value ;
T_val = h_null_hipothesys ;
P_val2 = p2 ;
P_val_cross = p_value_cross ;
P_val_surr_cross =  p_value_surr_cross ;


if Show_Plots == 'y'

mad_R_patterns = mad(Global_R_pattern,1) ;
mad_R_pattern2 = mad(Global_R_pattern2,1) ;
mad_R_cross = mad(Global_R_patternCross,1) ;
mad_R_surr_cross = mad(Global_R_surr_cross,1) ;
c = 1 ;
x1 = median( Global_R_pattern ) - c*mad_R_patterns ;
x2 = median( Global_R_pattern ) + c* mad_R_patterns ;
xn = [ x1 x2 ] ;
yn = [ 0.1  0.1 ];

x1 = median( Global_R_pattern2 ) - c*mad_R_pattern2 ;
x2 = median( Global_R_pattern2 ) + c* mad_R_pattern2 ;
xn2 = [ x1 x2 ] ;
yn2 = [ 0.15  0.15 ];

x1 = median( Global_R_patternCross ) - c*mad_R_cross ;
x2 = median( Global_R_patternCross ) + c* mad_R_cross ;
xnc = [ x1 x2 ] ;
ync = [ 0.2  0.2 ];
x1 = median( Global_R_surr_cross ) - c*mad_R_surr_cross ;
x2 = median( Global_R_surr_cross ) + c* mad_R_surr_cross ;
xnsc = [ x1 x2 ] ;
ynsc = [ 0.25  0.25 ];    
    
    
    
a = [] ;
sh = [] ;
Cross= [] ;
[ a( : , 1 ) , a( : , 2 ) ] = hist( Global_R_pattern , 20 ) ;
[ sh( : , 1 ) , sh( : , 2 ) ] = hist( Global_R_pattern2 , 20 ) ;
[ Cross( : , 1 ) , Cross( : , 2 ) ] = hist( Global_R_patternCross , 20 ) ;
[ SurCross( : , 1 ) , SurCross( : , 2 ) ] = hist( Global_R_surr_cross , 20 ) ;
figure
plot(  a( : , 2 ) , a( : , 1 )/  max( a( : , 1 )) ,  sh( : , 2 ) , sh( : , 1 )/max(sh( : , 1 ) ) ,...
    Cross( : , 2 ) , Cross( : , 1 )/  max( Cross( : , 1 )) ,  SurCross( : , 2 ) , ...
    SurCross( : , 1 )/  max( SurCross( : , 1 )) ,  xn , yn , xn2 , yn2, xnc , ync , xnsc , ynsc); 
title( 'Similarity distributions between data sets')
hleg1 = legend('Set 1','Set 2','Set 1-2', 'Surrogate Set 1-2');
% figure
% subplot( 2 , 1 , 1 ) ;
% hist( M , 20 )

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
end

