%  Two_sets_compare_similarity
function [P_val1 ,P_val2 , P_val_cross,P_val_surr_cross, mR_difference,R1,R2,R3,R4,R5,R6 , ResCell ] = Two_sets_compare_similarity( ... 
           motif , motif2 , N1_s,N1_e,N2_s,N2_e , Show_pattern_dur_hist ,...
           PHASE , ADJUST_SPIKES, MIN_SPIKES_PER_PATTERN , ResCell_input)

if N1_s == 0 N1_s = 1; end
if N2_s == 0 N2_s = 1; end
if N1_e == 0 q = size(motif); N1_e = q(1) ; end       
if N2_e == 0 q = size(motif2); N2_e = q(1)  ; end   

% PHASE = true ;

ResCell = ResCell_input ;

Nb = N1_e - N1_s + 1 ;
Nb2 = N2_e - N2_s + 1 ;

s = size( motif ) ;
N= s(2)  ;

Show_Plots = Show_pattern_dur_hist ;

Noise =   0 ;  % noise amplitude , ms
% MIN_SPIKES_PER_PATTERN = 2 ; %N * 0.00 ;

[A, dur ] = PatternsAdjustSpikes( motif , ADJUST_SPIKES) ;
[A2, dur2 ] = PatternsAdjustSpikes( motif2 , ADJUST_SPIKES) ;

% adjust = ADJUST_SPIKES ;

% avg_dur =  mean(dur) ;
% avg_dur2 = mean(dur2) ;
avg_dur = 1;

if Show_Plots == 'y'
figure
hist(  dur ) ;
xlabel( 'Pattern duration, ms' )
Mean_activation_pattern_duration = mean(dur) ;
Std_activation_pattern_duration = std(dur) ;
Mean_activation_pattern_duration  ;
Std_activation_pattern_duration  ;
end
 
Number_of_nonzero_pairs_S2toS1centr = 0;
Number_of_nonzero_pairs_S1toS1centr = 0;
Global_R_pattern = [] ;
Global_R_pattern2 = [] ;
Global_R_patternCross = [] ;
Global_R_surr_cross = [] ;

S = zeros( Nb , Nb) ;
S2 = zeros( Nb2 , Nb2 ) ;
Scross = zeros( Nb , Nb2) ;
M = [] ;
x = [] ;
mean_y = [] ;
mean_yCross = [] ;
mean_y2= [] ;
mean_yS1C1= [] ;
mean_yS2C1 = [] ;
Curr_burst = 0 ;
Surr_dur = [] ;
Surrogates = zeros( Nb2 + Nb , N );
sur_num = 1 ;
R = 0;
DD1 = 1 ;
DD2 = 1 ;
POW_ = 1 ;

% 
% N1_s
% N1_e

for t = N1_s : N1_e
    for s = N1_s : N1_e
        if t < s                       
                ch = 0 ;
                y = 0 ;
                if PHASE == true 
                    DD1 = avg_dur /dur( s);
                    DD2  =avg_dur /dur(t)  ; 
                end    
                for k = 1 : N
                    ch = ch + H( motif( t , k ) ) * H( motif( s , k ) ) * ...
                        ( DD2 * A( t , k ) - DD1 * A( s , k ) + ( Noise * rand() ) ) ^ 2  ;                    
                    y = y + H( motif( t  , k ) ) * H( motif( s , k ) ) ;
                end
                mean_y = [ mean_y y ] ;
                if ( y >= MIN_SPIKES_PER_PATTERN )
                    y=1;
                R = sqrt( ch ^ POW_ ) ;
%                R = sqrt( ch  )/y ;
                S( t , s ) = R ;
                Global_R_pattern = [ Global_R_pattern R ] ;
                end
        end
    end
end


for t = N2_s : N2_e
    for s = N2_s : N2_e
        if t < s                       
                ch = 0 ;
                y = 0 ;
                if PHASE == true 
                    DD1 = avg_dur /dur2( s);
                    DD2  =avg_dur /dur2(t)  ;  
                end
                for k = 1 : N
                    ch = ch + H( motif2( t , k ) ) * H( motif2( s , k ) ) * ...
                        ( DD2 * A2( t , k ) - DD1 * A2( s , k ) + ( Noise * rand() ) ) ^ 2  ;                    
                    y = y + H( motif2( t  , k ) ) * H( motif2( s , k ) ) ;
                end
                mean_y2 = [ mean_y2 y ] ;
                if ( y >= MIN_SPIKES_PER_PATTERN )
                    y=1;
                R = sqrt( ch ^ POW_ )  ;
%               R = sqrt( ch  )/y ;
                S2( t , s ) = R ;
                Global_R_pattern2 = [ Global_R_pattern2 R ] ;
                end
        end
    end
end

% Cross motif relations
for t = N1_s : N1_e
    for s = N2_s : N2_e             
                ch = 0 ;
                y = 0 ;             
                if PHASE == true 
                    DD1 = avg_dur /dur2( s);
                    DD2 = avg_dur /dur(t) ;
                end
                for k = 1 : N
                    ch = ch + H( motif( t , k ) ) * H( motif2( s , k ) ) * ...
                       ( DD2 * A( t , k ) - DD1 * A2( s , k ) + ( Noise * rand() ) ) ^ 2  ;                    
                    y = y + H( motif( t  , k ) ) * H( motif2( s , k ) ) ;
                end
                mean_yCross = [ mean_yCross y ] ;
                if ( y >= MIN_SPIKES_PER_PATTERN )
%                     y=1;
                R =  sqrt( ch ^ POW_ )  ;
%                 R =  sqrt( ch  ) /y;
                Scross( t , s ) = R ;
                Global_R_patternCross = [ Global_R_patternCross R ] ;
                end
        
    end
end

% Cross motif surrogate relations
for t = N1_s : N1_e
    for s = N2_s : N2_e             
                    NBurst_rand_num1 = floor(rand() * (Nb-1))  ;
                    NBurst_rand_num2 = floor(rand() * (Nb2-1))   ;
                                    
                    Y=  RandomArrayN( N );                    
                    Z =  RandomArrayN( N );
                    
                    Surr1 = zeros( N, 1 ) ;
                    Surr2 = zeros( N, 1 );
                    Surr1_s = zeros( N, 1 ) ;
                    Surr2_s = zeros( N, 1 );
                    for k = 1 : N
                        Surr1( k ) =  A( NBurst_rand_num1 + N1_s     , Y(k) ) ;
                        Surr2( k ) =  A2( NBurst_rand_num2 + N2_s     , Z(k) ) ;
                        Surr1_s( k ) =   H( motif( NBurst_rand_num1 + N1_s  , Y(k)) ); 
                          Surr2_s( k )  = H( motif2( NBurst_rand_num2 + N2_s   , Z(k)) ); 
                    end
                    Surrogates( sur_num , : ) = Surr1( : ) ;
                    Surrogates( sur_num + 1 , : ) = Surr2( : ) ;
                    
                    if PHASE == true 
%                         DD = dur(NBurst_rand_num1 + N1_s)/dur2( NBurst_rand_num2 + N2_s );
                        DD1 = avg_dur /dur( NBurst_rand_num1 + N1_s);
                        DD2 = avg_dur /dur2( NBurst_rand_num2 + N2_s) ;
                    end
            
                    sd1 = max(Surr1( : )) - min(Surr1( : )) ;
                    sd2 = max(Surr2( : )) - min(Surr2( : )) ;
                    Surr_dur = [ Surr_dur  sd1 sd2 ];               
                    
                    y = 0 ;
                    ss = 0 ;
                    for k = 1 : N                        
                        ss = ss +  Surr1_s( k )  *   Surr2_s( k )  * ...
                        ( DD1* Surr1( k ) - DD2 * Surr2( k ) + ( Noise * rand() )  ) ^ 2 ;
                        y = y + Surr1_s( k )  * Surr2_s( k ) ;
                    end
%                     mean_ch_y = round( mean( mean_y ) ) ;
                    
                    if y >= MIN_SPIKES_PER_PATTERN 
%                         y=1;
                        R = sqrt( ss ^ POW_ )  ;
%                         R = sqrt( ss  ) /y;
                    Global_R_surr_cross = [ Global_R_surr_cross R ] ;                
                    end            
        end
end


if isempty( x )
    x = 0 ;
end

% % [center_mass, dur_mass ] = PatternsAdjustSpikes( c_mass) ;
% dur_mass = max( center_mass( : )) - min( center_mass( : ) ) ;
Global_R_set2_to_center_mass = [] ;Global_R_set1_to_center_mass = [] ;
Global_R_set1_to_center_mass_buf = [] ; % patterns  from N2_e to N2_s 
Global_R_set2_to_center_mass2 = [] ;
S1_C1 = zeros(   Nb,1) ;
S1_C2 = zeros(   Nb,1) ;
S2_C1 = zeros(  Nb2,1 ) ;
S2_C2 = zeros(   Nb2,1 ) ; 

[center_mass , dur_mass , mot_mass ] = center_mass_calc( N1_s , N1_e ,  motif , ADJUST_SPIKES  ) ;
[center_mass2 , dur_mass2 , mot_mass2 ] = center_mass_calc( N2_s , N2_e ,  motif2 , ADJUST_SPIKES  ) ;

% distance from set1-center to set2-center

Set1center_to_set2center = 0 ;
                 ch = 0 ;  y = 0 ;              
                if PHASE == true 
                    DD1 = avg_dur / mean(dur_mass2) ;
                    DD2 = avg_dur / mean(dur_mass)  ;
                end
                for k = 1 : N
                    ch = ch + H( mot_mass( k ) ) * H( mot_mass2( k ) ) * ...
                       ( DD2 * center_mass( k) - DD1 * center_mass2( k ) + ( Noise * rand() ) ) ^ 2  ;                    
                    y = y + H( mot_mass( k ) ) * H( mot_mass2( k ) ) ;         
                end 
                if ( y >= MIN_SPIKES_PER_PATTERN )
                    y=1; 
                R =  sqrt( ch ^ POW_ ) ;
                Set1center_to_set2center = R   ;
                end 
% S1 -> C1
for s = N1_s : N1_e 
                ch = 0 ;  y = 0 ;
                               
                if PHASE == true 
                    DD1 = avg_dur /dur( s);
                    DD2 = avg_dur / mean(dur_mass)  ;
                end
                for k = 1 : N
                    ch = ch + H( mot_mass( k ) ) * H( motif( s , k ) ) *   ( DD2 * center_mass( k) - DD1 * A( s , k ) + ( Noise * rand() ) ) ^ 2  ;                    
                    y = y + H( mot_mass( k ) ) * H( motif( s , k ) ) ;   
                end 
                if ( y >= MIN_SPIKES_PER_PATTERN )  
                R =  sqrt( ch ^ POW_ )   ; 
                S1_C1( s  ) = R ;
                Global_R_set1_to_center_mass = [ Global_R_set1_to_center_mass R ]  ;
                Number_of_nonzero_pairs_S1toS1centr = Number_of_nonzero_pairs_S1toS1centr+1; 
                end 
end

% S1 -> C2
for s = N1_s : N1_e 
                ch = 0 ; y = 0 ; 
                if PHASE == true 
                    DD1 = avg_dur /dur( s);
                    DD2 = avg_dur / mean(dur_mass)  ;
                end
                for k = 1 : N
                    ch = ch + H( mot_mass2( k ) ) * H( motif( s , k ) ) *   ( DD2 * center_mass2( k) - DD1 * A( s , k ) + ( Noise * rand() ) ) ^ 2  ;                    
                    y = y + H( mot_mass2( k ) ) * H( motif( s , k ) ) ;   
                end 
                if ( y >= MIN_SPIKES_PER_PATTERN )  
                R =  sqrt( ch ^ POW_ )   ; 
                S1_C2( s  ) = R ; 
                end 
end 

% S2 -> C1
for s = N2_s : N2_e
                ch = 0 ; y = 0 ;
                if PHASE == true 
                    DD1 = avg_dur /dur2( s);
                    DD2 = avg_dur / mean(dur_mass)  ;
                end
                for k = 1 : N
                    ch = ch + H( mot_mass( k ) ) * H( motif2( s , k ) ) * ( DD2 * center_mass( k) - DD1 * A2( s , k ) + ( Noise * rand() ) ) ^ 2  ;                    
                    y = y + H( mot_mass( k ) ) * H( motif2( s , k ) ) ;       
                end
                if ( y >= MIN_SPIKES_PER_PATTERN )
                R =  sqrt( ch ^ POW_ )   ;
                S2_C1( s ) = R ;
                Global_R_set2_to_center_mass = [ Global_R_set2_to_center_mass R ]  ;
                Number_of_nonzero_pairs_S2toS1centr = Number_of_nonzero_pairs_S2toS1centr+1;
                end   
end

% S2 -> C2
for s = N2_s : N2_e
                ch = 0 ;   y = 0 ;
                if PHASE == true 
                    DD1 = avg_dur /dur2( s);
                    DD2 = avg_dur / mean(dur_mass)  ;
                end
                for k = 1 : N
                    ch = ch + H( mot_mass2( k ) ) * H( motif2( s , k ) ) * ( DD2 * center_mass2( k) - DD1 * A2( s , k ) + ( Noise * rand() ) ) ^ 2  ;                    
                    y = y + H( mot_mass2( k ) ) * H( motif2( s , k ) ) ;             
                end
                if ( y >= MIN_SPIKES_PER_PATTERN )
                R =  sqrt( ch ^ POW_ )   ;
                S2_C2( s ) = R ;
                Global_R_set2_to_center_mass2 = [ Global_R_set2_to_center_mass2 R ]  ;
                end   
end

% S1 (part) -> C1
for s = N2_s : N2_e
    if s < N1_e
                ch = 0 ;  y = 0 ;
                if PHASE == true 
                    DD1 = avg_dur /dur( s);
                    DD2 = avg_dur / mean(dur_mass)  ;
                end
                for k = 1 : N
                    ch = ch + H( mot_mass( k ) ) * H( motif( s , k ) ) * ( DD2 * center_mass( k) - DD1 * A( s , k ) + ( Noise * rand() ) ) ^ 2  ;                    
                    y = y + H( mot_mass( k ) ) * H( motif( s , k ) ) ;          
                end
                if ( y >= MIN_SPIKES_PER_PATTERN )
                R =  sqrt( ch ^ POW_ )   ;
                Global_R_set1_to_center_mass_buf = [ Global_R_set1_to_center_mass_buf R ]  ; 
                end 
    end
end
 %%%---------------------------------- S ----------------------------------


ActEl = mean( mean_yS1C1 ) ;
ActEl2 = mean( mean_yS2C1 ) ;
Act_el_both = mean( [ ActEl  ActEl2] ) ; 

Active_Patterns_to_centroid1 = ...
    ( Number_of_nonzero_pairs_S1toS1centr / Nb + Number_of_nonzero_pairs_S2toS1centr / Nb2 )/2 ;
% R6 = Active_Patterns_to_centroid1 ;


    
%   [Not_distinguishable_points_numA_A2 , Clustering_error_precentA_A2 ]= ...
%     Clustering_accuracy_2clusters( A  , A2  );
% Not_distinguishable_points_numA_A2
% Clustering_error_precentA_A2

SIMILARITIES = zeros(  Nb + Nb2 , Nb +Nb2) ;
SIMILARITIES( 1 : Nb , 1 : Nb )=S;  
SIMILARITIES( Nb+1 :  Nb + Nb2  , Nb+1 :  Nb + Nb2  )=S2 ;
SIMILARITIES( 1 : Nb  , Nb+1 :  Nb + Nb2       )=Scross ;
for i=1:Nb + Nb2
   for j=1:Nb + Nb2 
       if i>j
   SIMILARITIES(   i ,j ) =  SIMILARITIES( j , i );
    
       end
   end
end

if Show_Plots  
  
    PlotColoredMatrixData( SIMILARITIES );
    title( 'A1 A2');
end  
     Matrix_Similarities( A , A2 );     
     title( 'A1 A2-basic euclidean');
     [  overlapped_values , overlapped_valuse_precent , Optimal_Threshold ,...
    Tact_Intersimilarity_Dissimilar_patterns_precent , Tact_Intersimilarity_Dissimilar_patterns ] ...
      =Matrix_Similarities_overlap( A , A2, false , SIMILARITIES )  ;
     Tact_Intersimilarity_Dissimilar_patterns_precent
     Tact_Intersimilarity_Dissimilar_patterns
     
    
%  [ overlapped_values , overlapped_valuse_precent , Optimal_Threshold , eC1_total_precent ,eC1_total]  = Overlapping_Values( S2_C1 , S1_C1 , false  );
% eC1_total;
% eC1_total_precent
%  [ overlapped_values , overlapped_valuse_precent , Optimal_Threshold , eC2_total_precent ,eC2_total]  = Overlapping_Values( S1_C2 , S2_C2 , false  );
% eC2_total;
%  eC2_total_precent
S1_C1
S1_C2
S2_C2
S2_C1
 ss =length( find(  S1_C1 >= S1_C2 ) ) ;
 if ~isempty( ss )  Tact_Centroid_Error_points = ss ; end
  ss =length( find(  S2_C2 >= S2_C1 ) ) ;
 if ~isempty( ss )  Tact_Centroid_Error_points = Tact_Centroid_Error_points + ss ; end
 Tact_Centroid_Error_precent = 100 * Tact_Centroid_Error_points/ (length( S1_C2) + length( S2_C2)  );
 Tact_Centroid_Error_points
 Tact_Centroid_Error_precent
 
     figure
     hold on 
     plot(   [ S1_C1 ; S2_C1 ] ) 
     plot(   [ S1_C2 ; S2_C2 ], 'r' ) 
          title( 'T activation Dist to centroids')
     hold off
%      
%      A
%      A2
       [ Tact_Not_distinguishable_points_num_KMEANS  , Tact_Clustering_error_precent_KMEANS ]= ...
    Clustering_accuracy_2clusters( A , A2  ) ;
Tact_Not_distinguishable_points_num_KMEANS = Tact_Not_distinguishable_points_num_KMEANS ;
Tact_Clustering_error_precent_KMEANS = Tact_Clustering_error_precent_KMEANS ;
Tact_Clustering_error_precent_KMEANS

% ResCell.Tact_Intersimilarity_Dissimilar_patterns_precent=Tact_Intersimilarity_Dissimilar_patterns_precent;
% ResCell.Tact_Centroid_Error_precent=100 - Tact_Centroid_Error_precent;
% ResCell.Tact_Clustering_error_precent_KMEANS= 100 - Tact_Clustering_error_precent_KMEANS;
% ResCell.Tact_Centroid_Error_points=Tact_Centroid_Error_points ;
% ResCell.Tact_Intersimilarity_Dissimilar_patterns=Tact_Intersimilarity_Dissimilar_patterns;

ResCell.Tact_Intersimilarity_Dissimilar_patterns_precent=Tact_Intersimilarity_Dissimilar_patterns_precent;
ResCell.Tact_Centroid_Error_precent=100 - Tact_Centroid_Error_precent;
ResCell.Tact_Clustering_error_precent_KMEANS= 100 - Tact_Clustering_error_precent_KMEANS;
ResCell.Tact_Centroid_Error_points=Tact_Centroid_Error_points ;


%   [Not_distinguishable_points_numC1 , Clustering_error_precentC1 ]= ...
%     Clustering_accuracy_2clusters( Global_R_set1_to_center_mass'  , Global_R_set2_to_center_mass'     );
% Not_distinguishable_points_numC1
%     Clustering_error_precentC1
    

  


R5 = -1 ;
R6 = - 1 ;
Activation_Patterns_different_if1_P1C1vsP2C1 = -1 ;
if (  isempty( Global_R_set1_to_center_mass )  ~= 1 && isempty( Global_R_set2_to_center_mass ) ~= 1 )
[p,Activation_Patterns_different_if1_P1C1vsP2C1] = ranksum(Global_R_set1_to_center_mass,Global_R_set2_to_center_mass, 0.05);
 Activation_Patterns_different_if1_P1C1vsP2C1 ;
R5 = Activation_Patterns_different_if1_P1C1vsP2C1;
end

if (  isempty( Global_R_pattern )  ~= 1 && isempty( Global_R_pattern2 ) ~= 1 ...
        && isempty( Global_R_patternCross )~= 1 && isempty( Global_R_surr_cross )~= 1  )
[p_value,h_null_hipothesys] = ranksum(Global_R_pattern,Global_R_patternCross);
[p2 , h_2hipothesys] = ranksum(Global_R_pattern2,Global_R_patternCross);
[p_value_cross,h_cross_hipothesys] = ranksum(Global_R_pattern,Global_R_pattern2);
% [p_value_surr_cross,h_surr_cross_hipothesys] = ranksum(Global_R_patternCross,Global_R_surr_cross);
else
    p_value = -1 ;
    h_null_hipothesys = 0 ;
    h_cross_hipothesys = 0 ;
    p2=-1;
    p_value_cross=-1;
%     p_value_surr_cross = -1;    
end

P_val1 = p_value ;
T_val = h_null_hipothesys ;
P_val2 = p2 ;
P_val_cross = p_value_cross ;
P_val_surr_cross = -1 ; % p_value_surr_cross ;

% c = 1 ;
% mad_R_patterns = mad(Global_R_pattern,1) ;
% mad_R_pattern2 = mad(Global_R_pattern2,1) ;
% mad_R_cross = mad(Global_R_patternCross,1) ;
% % mad_R_cross_surr = mad(Global_R_surr_cross,1) ;
% x1 = median( Global_R_pattern ) + c* mad_R_patterns ;
% x2 = median( Global_R_pattern2 ) + c* mad_R_pattern2 ;
% xc = median( Global_R_patternCross ) - c*mad_R_cross ;
% rightt =max(x1,x2);

mR_difference = 0 ; %xc - x1 ;
R1 = median( Global_R_set1_to_center_mass) +mad(Global_R_set1_to_center_mass,1)  ;
R2 = median( Global_R_set1_to_center_mass_buf );
% R3 = -1 ;
% if isempty( Global_R_set2_to_center_mass ) ~= 1
R3 = median( Global_R_set2_to_center_mass );
% end
% R4 = median( Global_R_surr_cross );

% R1 = median( Global_R_pattern)  ;
% R2 = median( Global_R_pattern2 );
% R3 = median( Global_R_patternCross );
% R4 = 0 ;
% R4 = median( Global_R_surr_cross );



 
% Ndis_Precision = 5 ;
% DELTA_D = 20 ;
% % Rstep = (median(Global_R_set1_to_center_mass)  +mad(Global_R_set1_to_center_mass,1)) / Ndis_Precision ; 
% Rstep = ( max(max(Global_R_set1_to_center_mass),max(Global_R_set2_to_center_mass) - ...
%     min(min(Global_R_set1_to_center_mass),min(Global_R_set2_to_center_mass) )))/ DELTA_D ;
% di =0 ;glob = 0; glob_2 =0 ;
% for Ri = 1 : Rstep : max(max(Global_R_set1_to_center_mass),max(Global_R_set2_to_center_mass))
%     x = length( find( Global_R_set1_to_center_mass > Ri & Global_R_set1_to_center_mass <= Ri+Rstep ));
%     y = length( find( Global_R_set2_to_center_mass > Ri & Global_R_set2_to_center_mass <= Ri+Rstep ));
%     di = di+min(x,y);
%     glob = glob +max(x,y);    
%     glob_2 = glob_2 + y ;    
% end
% Jaccard_DistancesSet1Set2_similarity = di / glob ;
% Pattern_Dissimilarity_Jaccard_S1crossS2byS2 = di / glob_2 ;
JaccardI_P1C1_P2C1  = JaccardIndex(  Global_R_set1_to_center_mass , Global_R_set2_to_center_mass , 20 );
R4 = JaccardI_P1C1_P2C1 ;
JaccardI_P1P1_P2P1  = JaccardIndex(  Global_R_pattern , Global_R_patternCross , 20 );
JaccardI_P2P2_P2P1  = JaccardIndex(  Global_R_pattern2 , Global_R_patternCross , 20 );
JaccardI_P1_P2 = mean( [ JaccardI_P1P1_P2P1 JaccardI_P2P2_P2P1]) ; 
R6 = JaccardI_P1_P2;


% R5 = Dissimilarity_Norm_Distance ;


% DistancesSet2_close_to_centroid

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if Show_Plots == 'y'
    
Activation_Patterns_different_if1_P1C1vsP2C1

JaccardI_P1C1_P2C1
JaccardI_P1_P2
mad_R_patterns = mad(Global_R_pattern,1) ;
mad_R_pattern2 = mad(Global_R_pattern2,1) ;
mad_R_cross = mad(Global_R_patternCross,1) ;
mad_R_surr_cross = mad(Global_R_surr_cross,1) ;


x1 = 0 ; x2  = median(Global_R_set1_to_center_mass)+ mad(Global_R_set1_to_center_mass,1)/2 ; 
xnMASS = [ x1 x2 ] ;
ynMASS = [ 0.2  0.2 ];

c=1;
x1 = median( Global_R_pattern ) - c*mad_R_patterns ;
x2 = median( Global_R_pattern ) + c* mad_R_patterns ;
xn = [ x1 x2 ] ;
yn = [ 0.1  0.1 ];

x1 = median( Global_R_pattern2 ) - c*mad_R_pattern2 ;
x2 = median( Global_R_pattern2 ) + c* mad_R_pattern2 ;
xn2 = [ x1 x2 ] ;
yn2 = [ 0.11  0.11 ];

x1 = median( Global_R_patternCross ) - c*mad_R_cross ;
x2 = median( Global_R_patternCross ) + c* mad_R_cross ;
xnc = [ x1 x2 ] ;
ync = [ 0.12  0.12 ];
x1 = median( Global_R_surr_cross ) - c*mad_R_surr_cross ;
x2 = median( Global_R_surr_cross ) + c* mad_R_surr_cross ;
xnsc = [ x1 x2 ] ;
ynsc = [ 0.13  0.13 ];    
    
a = [] ;
sh = [] ;
Cross= [] ;
CHIST = 20 ;
[ a( : , 1 ) , a( : , 2 ) ] = hist( Global_R_pattern , CHIST ) ;
[ sh( : , 1 ) , sh( : , 2 ) ] = hist( Global_R_pattern2 , CHIST ) ;
[ Cross( : , 1 ) , Cross( : , 2 ) ] = hist( Global_R_patternCross , CHIST ) ;
[ SurCross( : , 1 ) , SurCross( : , 2 ) ] = hist( Global_R_surr_cross , CHIST ) ;
[ Mass( : , 1 ) , Mass( : , 2 ) ] = hist( Global_R_set2_to_center_mass , CHIST ) ;
[ Mass_Set1( : , 1 ) , Mass_Set1( : , 2 ) ] = hist( Global_R_set1_to_center_mass , CHIST ) ;
[ Mass_Set2( : , 1 ) , Mass_Set2( : , 2 ) ] = hist( Global_R_set2_to_center_mass2 , CHIST ) ;

figure
plot(  a( : , 2 ) , a( : , 1 )/length(Global_R_pattern) ,  sh( : , 2 ) , sh( : , 1 )/length(Global_R_pattern2),...
    Cross( : , 2 ) , Cross( : , 1 )/length(Global_R_patternCross)  ,  SurCross( : , 2 ) , ...
    SurCross( : , 1 )/length( Global_R_surr_cross ) ,  ...
         xn , yn , xn2 , yn2, xnc , ync , xnsc , ynsc); 
title( 'Similarity distributions between data sets')
hleg1 = legend('Set 1','Set 2','Set 1-2', 'Surrogate Set 1-2');
% figure
% plot( Mass_Set1( : , 2 ) , Mass_Set1( : , 1 )/length(Global_R_set1_to_center_mass),Mass( : , 2 ) ...
%     , Mass( : , 1 )/length(Global_R_set2_to_center_mass) ,...
%     Mass_Set2( : , 2 ) , Mass_Set2( : , 1 )/length(Global_R_set2_to_center_mass2) , ... 
%          xnMASS,ynMASS );
% title( '1-Set1->c1,2-Set2->c1,3-Set2->c2')
% hleg1 = legend('Distance Set1 to Center Mass','Distance Set2 to Center Mass','Center Mass median');

y = [ median(Global_R_pattern) median(Global_R_pattern2) median(Global_R_patternCross) ] ;
e = [ mad(Global_R_pattern,1) mad(Global_R_pattern2,1)  mad(Global_R_patternCross,1) ];
% y = [ median(Global_R_set1_to_center_mass) median(Global_R_set2_to_center_mass) ] ;
% e = [ mad(Global_R_set1_to_center_mass,1) mad(Global_R_set2_to_center_mass)  ];
% figure
% errorbar(y,e,'xr')
% title( 'median distance set 1(1), set 2(2), cross sets(3)')


y = [ median(Global_R_set1_to_center_mass) median(Global_R_set2_to_center_mass) ] ;
e = [ mad(Global_R_set1_to_center_mass,1) mad(Global_R_set2_to_center_mass,1)  ];
% figure
% errorbar(y,e,'xr')
% title( 'median distance set1(1), set2(2) to set1 center')

y = [ median(Global_R_set1_to_center_mass) (Set1center_to_set2center -median(Global_R_set2_to_center_mass2))  ] ;
e = [ mad(Global_R_set1_to_center_mass,1) mad(Global_R_set2_to_center_mass2,1)  ];
% figure
% errorbar(y,e,'xr')
% title( '(1)-median set1->centroid1,(2)-centroid2->centroid1')
 
Dc1c2 = Set1center_to_set2center - ...
      ( median(Global_R_set1_to_center_mass) + median(Global_R_set2_to_center_mass2)) - ...
      (mad(Global_R_set1_to_center_mass,1) + mad(Global_R_set2_to_center_mass2,1)   ) ; 
Cluster_distance = Dc1c2 ;     

y = [ median(dur) median(dur2) ] ;
e = [ mad(dur,1) mad(dur2,1)  ];
% figure
% errorbar(y,e,'xr')
% title( 'median set1(1) set2(2) duration')
mean_pattern1_duration =  mean(dur) ;
mean_pattern2_duration = mean(dur2) ;
mean_pattern1_duration
mean_pattern2_duration
mean_active_electrodes_in_both_set_patterns = Act_el_both ;
mean_active_electrodes_in_both_set_patterns ; 
% Cluster_distance

 
end

end