% S_matr_3
Show_Plots = Show_pattern_dur_hist ;


Noise =   0 ;  % noise amplitude , ms
MIN_SPIKES_PER_PATTERN = 2 ;



DELTA_D = 20 ;



Nb;
Nt = Nb   ;
Nb_rand = Nb*15 ;
Nb
Nb_rand

[A, dur ] = PatternsAdjustSpikes( motif , ADJUST_SPIKES ) ;
avg_dur = mean( dur) ;
avg_dur = 1 ;


avg_pattern_duration =  mean( dur)  ;

if Show_Plots == 'y'
figure
hist(  dur ) ;
xlabel( 'Pattern duration, ms' )
Mean_activation_pattern_duration = mean(dur) ;
Std_activation_pattern_duration = std(dur) ;
Mean_activation_pattern_duration  
Std_activation_pattern_duration 

figure
xxx=0:20:floor( max(dur) ) ;
d2=dur(dur>0);
hist(  d2,xxx ) ;
xlabel( 'Pattern duration, ms' )
Mean_activation_pattern_duration = mean(dur) ;
Std_activation_pattern_duration = std(dur) ;
end
 

%for Ts = 0 : 10
Global_R_pattern = [] ;
Pair_Duration_mean=[];
Pair_Similar = []; 
Global_R_surr = [] ;
S = zeros( Nb , Nb) ;
M = [] ;
x = [] ;
mean_y = [] ;
Curr_burst = 0 ;
sur_num = 1 ;
R = 0;
DD1 = 1 ;
DD2 = 1 ;

Surr_dur = [] ;
Surrogates = zeros( Nt * 2 , N );
Surr1 = zeros( N, 1 ) ;
Surr2 = zeros( N, 1 );
Surr1_s = zeros( N, 1 ) ;
Surr2_s = zeros( N, 1 );
     Dist_div = 1 ;
%   if PHASE == true 
%      Dist_div = sqrt( 64 ) ;
%   end

      
      
for t = 1 : Nb
    for s = 1 : Nb
        if t < s                       
                ch = 0 ;
                y = 0 ;
                if PHASE == true 
                    DD1 = avg_dur /dur( s);
                    DD2 = avg_dur /dur(t)  ; 
                end      
                for k = 1 : N
                    ch = ch + H( motif( t , k ) ) * H( motif( s , k ) ) * ...
                        ( DD2 * A( t , k ) - DD1 * A( s , k ) + ( Noise * rand() ) ) ^ 2  ;             
                         y = y + H( motif( t  , k ) ) * H( motif( s , k ) ) ;
                end
                mean_y = [ mean_y y ] ;
                if ( y > MIN_SPIKES_PER_PATTERN )
                R = sqrt( ch  ) / Dist_div  ;
                S( t , s ) = R ;
                Global_R_pattern = [ Global_R_pattern R ] ;
                
                Pair_Similar = [ Pair_Similar [ dur(s) dur(t)] ;
                Pair_Duration_mean=[ Pair_Duration_mean  mean( [dur(s) (dur(t)] )  ] ; 
                end
        end
    end
end



for t = 1 : Nb_rand
    for s = 1 : Nb_rand
        if t < s                     
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
                        Surr1( k ) =  A( NBurst_rand_num1 , Y(k) ) ;
                        Surr2( k ) =  A( NBurst_rand_num2 , Z(k) ) ;
                        Surr1_s( k ) =   H( motif( NBurst_rand_num1 , Y(k)) ); 
                          Surr2_s( k )  = H( motif( NBurst_rand_num2 , Z(k)) ); 
                    end
%                     Surrogates( sur_num , : ) = Surr1( : ) ;
%                     Surrogates( sur_num + 1 , : ) = Surr2( : ) ;
                    
                    if PHASE == true 
%                         DD = dur(NBurst_rand_num1 + N1_s)/dur2( NBurst_rand_num2 + N2_s );
                        DD1 = avg_dur /dur( NBurst_rand_num1  );
                        DD2 = avg_dur /dur( NBurst_rand_num2 ) ;
                    end
                    
                    sd1 = max(Surr1( : )) - min(Surr1( : )) ;
                    sd2 = max(Surr2( : )) - min(Surr2( : )) ;
                    Surr_dur = [ Surr_dur  sd1 sd2 ];
                    
                    y = 0 ;
                    ss = 0 ;
                    for k = 1 : N%                       
                        ss = ss +  Surr1_s( k )  * Surr2_s( k )  * ...
                        ( DD1* Surr1( k ) - DD2 * Surr2( k ) + ( Noise * rand() )  ) ^ 2 ;
                        y = y + Surr1_s( k )  * Surr2_s( k ) ;
                    end
%                     mean_ch_y = round( mean( mean_y ) ) ;
                    
                    if y > MIN_SPIKES_PER_PATTERN 
                        R = sqrt( ss  ) / Dist_div  ;
%                          R = sqrt( ss  )/ y ;
                    Global_R_surr = [ Global_R_surr R ] ;                
                    end            
        end
    end
end



[center_mass , dur_mass , mot_mass ] = center_mass_calc( 1, Nb,  motif  ,  ADJUST_SPIKES) ;
Global_R_set1_to_center_mass = [] ;

for s = 1 : Nb
                ch = 0 ;
                y = 0 ;             
                if PHASE == true 
                    DD1 = avg_dur /dur( s);
                    DD2 = avg_dur / mean(dur_mass)  ;
                end
                for k = 1 : N
                    ch = ch + H( mot_mass( k ) ) * H( motif( s , k ) ) * ...
                       ( DD2 * center_mass( k) - DD1 * A( s , k ) + ( Noise * rand() ) ) ^ 2  ;                    
                    y = y + H( mot_mass( k ) ) * H( motif( s , k ) ) ;
                end
                if ( y > MIN_SPIKES_PER_PATTERN )
%                     y =1 ;
                R =  sqrt( ch  ) / Dist_div ;
%                 R =  sqrt( ch  )/ y ;
                Global_R_set1_to_center_mass = [ Global_R_set1_to_center_mass R ] ;
                end                             
end

% figure
%  hist( mean_y ) 
ActEl = mean( mean_y )/ N  ;
macActEl = max( mean_y );
if isempty( x )
    x = 0 ;
end

 if PHASE == true 
     Global_R_pattern = Global_R_pattern / sqrt( macActEl ) ;
     Global_R_surr = Global_R_surr  / sqrt( macActEl ) ; 
     Global_R_set1_to_center_mass = Global_R_set1_to_center_mass / sqrt( macActEl ) ;
  end


whos Global_R_pattern
whos Global_R_surr




figure
plot(Pair_Duration_mean , Global_R_pattern , 'b+')
Title( 'duration vs similarity')
                


% Global_R_pattern'
% 
% Global_R_surr'

if (  isempty( Global_R_pattern )  ~= 1 && isempty( Global_R_surr ) ~= 1 )
[p_value,h_null_hipothesys] = ranksum(Global_R_pattern,Global_R_surr);
else
    p_value = -1 ;
    h_null_hipothesys = 0 ;
end

P_val = p_value ;
T_val = h_null_hipothesys ;


median_Global_R_pattern = median( Global_R_pattern )  ;
median_Global_R_surr = median( Global_R_surr )  ;
mad_Global_R_pattern = mad( Global_R_pattern,1 )  ;
mad_Global_R_surr = mad( Global_R_surr,1 )  ;

% DIFF_i =(median_Global_R_surr - median_Global_R_pattern) - ...
%      (mad_Global_R_pattern + mad_Global_R_surr) ;

 
x = 0  ; LGS = length(Global_R_surr ) ; LGRP = length(Global_R_pattern ) ;
Rstep = ( max(max(Global_R_pattern),max(Global_R_surr) - min(min(Global_R_pattern),min(Global_R_surr) )))/ DELTA_D ;
% Rstep = mad_Global_R_pattern/ DELTA_D  ; 
% Rstep = 0.05 ;
di =0 ;glob = 0;
% if LGS > 10 && LGRP > 10 
for Ri = 0 : Rstep : max(max(Global_R_pattern),max(Global_R_surr))
    x = length( find( Global_R_surr > Ri & Global_R_surr <= Ri+Rstep )) / LGS ;
    y = length( find( Global_R_pattern > Ri & Global_R_pattern <= Ri+Rstep ))/ LGRP ;
    x;
    y;
    di = di+min(x,y);
    glob = glob +max(x,y);    
end
% end
if glob > 0
Ndiff_DistancesSet1Set2_similarity = di / glob ;
else
    Ndiff_DistancesSet1Set2_similarity = -1 ;
end
Ndiff_DistancesSet1Set2_similarity 
 DIFF_i = Ndiff_DistancesSet1Set2_similarity ;

% for i = 1 : length(Global_R_pattern)
%   f=f+ttest2( Global_R_surr , Global_R_pattern(i) );  
% %     [p,h]=ranksum( Global_R_surr , Global_R_pattern(i));
% %     f=f+ h ;
% end

% f=0;
% f = length( find( Global_R_pattern(:) < min(Global_R_surr) ) );
% f=f/length(Global_R_pattern) ;
% Not_random_pairs = f ;



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
    
    mad_R_patterns = mad(Global_R_pattern,1) ;
mad_R_surr = mad(Global_R_surr,1) ;
c = 1 ;
x1 = median( Global_R_pattern ) - c*mad_R_patterns ;
x2 = median( Global_R_pattern ) + c* mad_R_patterns ;
xn = [ x1 x2 ] ;
yn = [ 0.1  0.1 ];

x1 = median( Global_R_surr ) - c*mad_R_surr ;
x2 = median( Global_R_surr ) + c* mad_R_surr ;
xn2 = [ x1 x2 ] ;
yn2 = [ 0.15  0.15 ];
    
    
    


    
a = [] ;
sh = [] ;
[ a( : , 1 ) , a( : , 2 ) ] = hist( Global_R_pattern , 25 ) ;
[ sh( : , 1 ) , sh( : , 2 ) ] = hist( Global_R_surr , 25 ) ;
x_r_m = median( Global_R_pattern ) ;
x_s_m = median( Global_R_surr ) ;
xn2 = [ x_r_m x_r_m ] ;
yn2 = [ 0  100*max(a( : , 1 ))/length(Global_R_pattern) ]; 
xnS = [ x_s_m x_s_m ] ;
ynS = [ 0  100* max(sh( : , 1 ))/length(Global_R_surr) ];

figure
% plot(  a( : , 2 ) , a( : , 1 )/length(Global_R_pattern) ,  sh( : , 2 ) ,sh( : , 1 )/ length(Global_R_surr) , xn , yn , xn2 , yn2 ); 
plot(  a( : , 2 ) , 100*a( : , 1 )/length(Global_R_pattern) ,  sh( : , 2 ) ,100*sh( : , 1 )/ length(Global_R_surr), ...
            xn2,yn2, xnS,ynS   ); 
title( 'Similarity distributions for real and surrogate data')


y_meadian_patterns_to_center_mass = [ median(Global_R_set1_to_center_mass)  ] ;
e_MAD_pattern_to_center_mass = [ mad(Global_R_set1_to_center_mass,1)  ];
figure
errorbar(y_meadian_patterns_to_center_mass,e_MAD_pattern_to_center_mass,'xr')
title( 'median and MAD distance from patterns to average pattern')
% y_meadian_patterns_to_center_mass
% e_MAD_pattern_to_center_mass

y_meadian_patterns_to_center_mass = [ median(Global_R_pattern) median(Global_R_surr)  ] ;
e_MAD_pattern_to_center_mass = [ mad(Global_R_pattern,1)  mad(Global_R_surr,1)   ];
figure
errorbar(y_meadian_patterns_to_center_mass,e_MAD_pattern_to_center_mass,'xr')
title( 'median and MAD.1)distance between patterns.2)distance between surrogates')
 
M_real =  median(Global_R_pattern)
M_surr = median(Global_R_surr)
MAD_real = mad(Global_R_pattern,1)
MAD_surr = mad(Global_R_surr,1)

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

