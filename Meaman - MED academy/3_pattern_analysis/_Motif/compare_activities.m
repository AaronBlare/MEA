 
function [ SpikeRate_STAT_Selectivity_Nbins_total ,SpikeRate_STAT_Selectivity_Nbins_precent , ...
     SpikeRate_LINEARY_Selectivity_Nbins_precent , SpikeRate_LINEARY_Selectivity_Nbins_total ...
TOTAL_RATE_Intersimilarity_Dissimilar_patterns_precent , TOTAL_RATE_Intersimilarity_Dissimilar_patterns , TOTAL_RATE_Centroid_Error_points , ...
TOTAL_RATE_Centroid_Error_precent ,TOTAL_RATE_Clustering_error_precent_KMEANS ,TOTAL_RATE_Clustering_error_precent_SVM  , TOTAL_RATE_SVM_accuracy , ...
Total_bins , SPIKE_RATE_OVERLAPS, SPIKE_RATE_OVERLAPS_STABLE , ...
  SPIKE_RATE_1stBin_Centroid_Error_precent,Bins_overlaps_mean ,   ...
SPIKE_RATES_1stBin_Clustering_error_precent_KMEANS , SPIKE_RATES_1stBin_KMEANS_accuracy , FirstBIN_SPIKERATE_OVERLAPS , ...
SPIKE_RATE_1stBin_SVM_accuracy ] =...
compare_activities( Data1 , Data2 ,  Nb , Nb2 , Pattern_length_ms , Start_t , DT_step , STIM_RESPONSE_BOTH_INPUTS ,OVERLAP_TRES , PvalRanksum, CHABBELS_ERASED , File_name_x)
 
 
N=64;
PSTH_BIN= 10 ;

 DT = DT_step ;
%  OVERLAP_TRES = 15 ;
 
Burst_len = Pattern_length_ms ;
fire_bins = floor(  (Burst_len ) / DT) ;

  SPIKE_RATE_OVERLAPS = []; 
  FirstBIN_SPIKERATE_OVERLAPS = [] ;
  SecondBIN_SPIKERATE_OVERLAPS =[];
  SPIKE_RATE_OVERLAPS_STABLE=[];
  
    [ Data_total_rates1,  Data_total_rates2 ,  Data_total_rates_signature1 , Data_total_rates_signature2  ...
   Data_Rate_Patterns1 ,  Data_Rate_Patterns2 ,Data_Rate_Signature1 , Data_Rate_Signature2 ,...
   Data_Rate_Signature1_std , Data_Rate_Signature2_std  ] ...
      = Get_Electrodes_Rates_at_TimeBins( N ,Nb ,Nb2, Data1 , Data2  , Start_t , Pattern_length_ms ,DT_step );
  
  

  
%%%----- Compare just patterns - matrix - how similar far and close any pairs
%%%of points
  
    Matrix_Similarities( Data_total_rates1,Data_total_rates2  ) ;
title( 'Spike total rates patterns - basic dist'); 
     [  overlapped_values , overlapped_valuse_precent , Optimal_Threshold ,...
    TOTAL_RATE_Intersimilarity_Dissimilar_patterns_precent , TOTAL_RATE_Intersimilarity_Dissimilar_patterns ] ...
      =Matrix_Similarities_overlap( Data_total_rates1,Data_total_rates2, false  )  ;
     TOTAL_RATE_Intersimilarity_Dissimilar_patterns_precent
     TOTAL_RATE_Intersimilarity_Dissimilar_patterns  
%%%-----------------------

%--------Compare Centroid distance TOTAL RATES-------- 

% % % -----------   SURROGATES of the Data_total_rates1
%  PATTERNS=[ Data_total_rates1 ; Data_total_rates2 ] ; 
%  X = RandomArrayN( Nb + Nb2 );
%  PATTERNS2=[];
%  PATTERNS2= PATTERNS( X , : ); 
% X = RandomArrayN( Nb + Nb2 );
%  for i = 1 : Nb 
%  Data_total_rates1( i , : ) = PATTERNS2(  X(i)   , : );
%  end
%   
%  for i = 1 : Nb2 
%  Data_total_rates2( i , :) = PATTERNS2( X(i + Nb )  , : );
%  end
% %  ------------



Data_total_rates_signature = Data_total_rates_signature1' ;
Data_total_rates = Data_total_rates1' ;
% Data_total_rates_signature
% Data_total_rates
     D1 = [ Data_total_rates_signature1 ; Data_total_rates1 ];
     D = pdist(D1,'euclidean');
     Similarity_matrix = squareform( D ) ;
     s = size( size( Similarity_matrix )) ; 
     DIM = s(2) ; 
     Patterns_more_than2 = false ;
     if DIM >= 2 Patterns_more_than2 = true ; end
     if Patterns_more_than2
     S1_C1 = Similarity_matrix( 1 , 2:end) ;
     S1_C1=S1_C1';
     else S1_C1 =0 ; end 
        
     D1 = [ Data_total_rates_signature2 ; Data_total_rates1 ];
     D = pdist(D1,'euclidean');
     Similarity_matrix = squareform( D ) ;
%      S1_C2 = Similarity_matrix( 1 , 2:end)';
     if Patterns_more_than2
     S1_C2 = Similarity_matrix( 1 , 2:end)';
     else S1_C2 =0 ; end
     
     D1 = [ Data_total_rates_signature2 ; Data_total_rates2 ];
     D = pdist(D1,'euclidean');
     Similarity_matrix = squareform( D ) ;
%      S2_C2 = Similarity_matrix( 1 , 2:end)';
     if Patterns_more_than2
     S2_C2 = Similarity_matrix( 1 , 2:end)';
     else S2_C2 =0 ; end
        
     D1 = [ Data_total_rates_signature1 ; Data_total_rates2 ];
     D = pdist(D1,'euclidean');
     Similarity_matrix = squareform( D ) ;
%      S2_C1 = Similarity_matrix( 1 , 2:end)';
     if Patterns_more_than2
     S2_C1 = Similarity_matrix( 1 , 2:end)';
     else S2_C1 =0 ; end
            

     
     figure
     hold on 
     h1 = plot(   [ S1_C1 ; S2_C1 ] ) ;
     h2 = plot(   [ S1_C2 ; S2_C2 ], 'r' ) ;
          hNextStim = plot(  [ Nb Nb ] ,[ 0 1.2*max( max(S1_C2),max(S2_C2))  ] ) ;
     set(h1,'Marker'          , '.'    )
      set(h2,'Marker'          , '.'    )
     set(hNextStim                         , ...
                  'Color'           , [0 .5 0] , ...
                  'LineWidth'       , 2      ); 
     
     
     title( 'TOTAL RATES Dist to centroids')
     hold off
     
 ss =length( find(  S1_C1 >= S1_C2 ) ) ;
 if ~isempty( ss )  TOTAL_RATE_Centroid_Error_points = ss ; else TOTAL_RATE_Centroid_Error_points = 0 ; end
 ss =length( find(  S2_C2 >= S2_C1 ) ) ;
    if ~isempty( ss )  TOTAL_RATE_Centroid_Error_points = TOTAL_RATE_Centroid_Error_points + ss ; end
    TOTAL_RATE_Centroid_Error_precent = 100 * TOTAL_RATE_Centroid_Error_points/ (  Nb+Nb2  );
    TOTAL_RATE_Centroid_Error_points
    TOTAL_RATE_Centroid_Error_precent     
    
    
%--------Compare distances KMEANS --- TOTAL RATES-------- 
 PATTERNS=[ Data_total_rates1 ; Data_total_rates2 ] ; 
%  X = RandomArrayN( Nb + Nb2 );
%  X
%  PATTERNS2=[];
%  PATTERNS2= PATTERNS( X , : ); 
% whos PATTERNS2
%  Data_total_rates1 = PATTERNS2( 1:Nb , : );
%  Data_total_rates2 = PATTERNS2( Nb+1:Nb2+Nb , : );
% 
%  for i = 1 : Nb 
%  Data_total_rates1( i , : ) = PATTERNS2( round( (Nb + Nb2 -1) * rand() ) +1 , : );
%  end
%   
%  for i = 1 : Nb2 
%  Data_total_rates2( i , :) = PATTERNS2( round( (Nb + Nb2 -1) * rand() ) +1 , : );
%  end

% % -----------   SURROGATES of the Data_total_rates1
%  X = RandomArrayN( Nb + Nb2 );
%  PATTERNS2=[];
%  PATTERNS2= PATTERNS( X , : ); 
% X = RandomArrayN( Nb + Nb2 );
%  for i = 1 : Nb 
%  Data_total_rates1( i , : ) = PATTERNS2(  X(i)   , : );
%  end  
%  for i = 1 : Nb2 
%  Data_total_rates2( i , :) = PATTERNS2( X(i + Nb )  , : );
%  end
% % ------------------------------------------- 

whos Data_total_rates1
whos Data_total_rates2
[  TOTAL_RATE_Not_distinguishable_points_num_KMEANS  ,  TOTAL_RATE_Clustering_error_precent_KMEANS , TOTAL_RATE_KMEANS_accuracy]= ...
    Clustering_accuracy_2clusters( Data_total_rates1 , Data_total_rates2  ) ;
 TOTAL_RATE_Not_distinguishable_points_num_KMEANS =  TOTAL_RATE_Not_distinguishable_points_num_KMEANS ;
 TOTAL_RATE_Clustering_error_precent_KMEANS =  TOTAL_RATE_Clustering_error_precent_KMEANS ;
 TOTAL_RATE_Clustering_error_precent_KMEANS
 TOTAL_RATE_KMEANS_accuracy
 
%  save bububu.mat
 
%--------------

%--------  SVM clustering --- TOTAL RATES--------  
[ TOTAL_RATE_SVM_accuracy , TOTAL_RATE_Clustering_error_precent_SVM , TOTAL_RATE_Not_distinguishable_points_num_SVM ] = SVM_check_accuracy_1D_data( ... 
       Data_total_rates1 , Data_total_rates2 , Nb , Nb2 , N );
%     Clustering_accuracy_2clusters( Data_total_rates1 , Data_total_rates2  ) ;
 TOTAL_RATE_Not_distinguishable_points_num_SVM  
  TOTAL_RATE_Clustering_error_precent_SVM  
 TOTAL_RATE_SVM_accuracy
%--------------

%--------------%--------------%--------------
%%%----- SPIKE RATE PATTERNS
%--------------%--------------%--------------


%%%----- SPIKE RATE PATTERNS Compare just patterns - matrix - how similar far and close any pairs
%%%of points 
Data_Rate_Patterns1_2D = zeros( Nb , N * fire_bins );
Data_Rate_Patterns2_2D = zeros( Nb2 , N * fire_bins  );
  Data_total_rates_signature1_1D =zeros( 1, N * fire_bins );
  Data_total_rates_signature2_1D = zeros( 1,N * fire_bins );
Data_Rate_Patterns1_1stBin  = zeros( Nb , N );
Data_Rate_Patterns2_1stBin  = zeros( Nb2 , N );
  Data_total_rates_signature1_1stBin =zeros( 1, N );
  Data_total_rates_signature2_1stBin =zeros( 1, N );

for i=1:Nb  
   for ch = 1 : N 
       Data_Rate_Patterns1_1stBin( i , ch)  =  Data_Rate_Patterns1(  i , ch , 1  ) ; 
       for ti=1: fire_bins
          Data_Rate_Patterns1_2D(i , ch * ti) = Data_Rate_Patterns1(  i , ch, ti  ) ; 
       end
   end  
end
for i=1:Nb2  
   for ch = 1 : N 
       Data_Rate_Patterns2_1stBin( i , ch)  =  Data_Rate_Patterns2(  i , ch , 1  ) ; 
       for ti=1: fire_bins
          Data_Rate_Patterns2_2D(i , ch * ti) = Data_Rate_Patterns2(  i , ch, ti  ) ; 
       end
   end  
end 
    for chf = 1 : N * fire_bins 
          Data_total_rates_signature1_1D(  chf  ) = Calc_Centroid_value_1D(  Data_Rate_Patterns1_2D( :  , chf  ) ) ; 
          Data_total_rates_signature2_1D(  chf  ) = Calc_Centroid_value_1D(  Data_Rate_Patterns2_2D( :  , chf  ) ) ;           
    end 
   for chf = 1 : N 
        Data_total_rates_signature1_1stBin(chf) = Calc_Centroid_value_1D(  Data_Rate_Patterns1_2D( :  , chf  ) ) ;
       Data_total_rates_signature2_1stBin(chf) = Calc_Centroid_value_1D(  Data_Rate_Patterns2_2D( :  , chf  ) ) ;     
   end 
    
%     Matrix_Similarities( Data_Rate_Patterns1_2D , Data_Rate_Patterns2_2D  ) ;
    Matrix_Similarities( Data_Rate_Patterns1_1stBin , Data_Rate_Patterns2_1stBin  ) ;
title( 'Spike Rates patterns  1st bin- basic dist'); 
     [  overlapped_values , overlapped_valuse_precent , Optimal_Threshold ,...
    SPIKE_RATE_Intersimilarity_Dissimilar_patterns_precent , SPIKE_RATE_Intersimilarity_Dissimilar_patterns ] ...
      =Matrix_Similarities_overlap( Data_Rate_Patterns1_1stBin,Data_Rate_Patterns2_1stBin, false  )  ;
     SPIKE_RATE_Intersimilarity_Dissimilar_patterns_precent
     SPIKE_RATE_Intersimilarity_Dissimilar_patterns  
%%%---------------------------

%%%----- Compare just patterns - matrix - how similar far and close any pairs
% %%%of points
%       Matrix_Similarities( Data_Rate_Patterns1_1stBin,Data_Rate_Patterns2_1stBin  ) ;
% title( '1st bin spikerates - basic dist'); 

%--------Compare Centroid distance SPIKE RATES 1 -ST BIN -------- 
%      D1 = [ Data_total_rates_signature1_1D ; Data_Rate_Patterns1_2D ];
     D1 = [ Data_total_rates_signature1_1stBin ; Data_Rate_Patterns1_1stBin ];
     D = pdist(D1,'euclidean');
     Similarity_matrix = squareform( D ) ;
          s = size( size( Similarity_matrix )) ; 
     DIM = s(2) ; 
     Patterns_more_than2 = false ;
     if DIM >= 2 Patterns_more_than2 = true ; end
     if Patterns_more_than2
     S1_C1 = Similarity_matrix( 1 , 2:end)';
     else S2_C1 =0 ; end
     
%      D1 = [ Data_total_rates_signature2_1D ; Data_Rate_Patterns1_2D ];
 D1 = [ Data_total_rates_signature2_1stBin ; Data_Rate_Patterns1_1stBin ];
     D = pdist(D1,'euclidean');
     Similarity_matrix = squareform( D ) ;
     S1_C2 = Similarity_matrix( 1 , 2:end)';
     if Patterns_more_than2
     S1_C2 = Similarity_matrix( 1 , 2:end)';
     else S1_C2 =0 ; end
     
%      D1 = [ Data_total_rates_signature2_1D ; Data_Rate_Patterns2_2D ];
       D1 = [ Data_total_rates_signature2_1stBin ; Data_Rate_Patterns2_1stBin ];
     D = pdist(D1,'euclidean');
     Similarity_matrix = squareform( D ) ;
     S2_C2 = Similarity_matrix( 1 , 2:end)';
     if Patterns_more_than2
     S2_C2 = Similarity_matrix( 1 , 2:end)';
     else S2_C2 =0 ; end
        
%      D1 = [ Data_total_rates_signature1_1D ; Data_Rate_Patterns2_2D ];
   D1 = [ Data_total_rates_signature1_1stBin ; Data_Rate_Patterns2_1stBin ];
     D = pdist(D1,'euclidean');
     Similarity_matrix = squareform( D ) ;
     S2_C1 = Similarity_matrix( 1 , 2:end)';
     if Patterns_more_than2
     S2_C1 = Similarity_matrix( 1 , 2:end)';
     else S2_C1 =0 ; end
            
     figure
     hold on 
     h1=plot(   [ S1_C1 ; S2_C1 ] ,'MarkerSize'      , 6 ) ;
     h2 = plot(   [ S1_C2 ; S2_C2 ], 'r','MarkerSize'      , 6  ) ;
     hNextStim = plot(  [ Nb Nb ] ,[ 0 1.2*max( max(S1_C2),max(S2_C2))  ] ) ;
     set(h1,'Marker'          , '.'    )
      set(h2,'Marker'          , '.'    )
     set(hNextStim                         , ...
                  'Color'           , [0 .5 0] , ...
                  'LineWidth'       , 2      );
     title( 'SPIKE RATES 1st BIN Dist to centroids')
     hold off
     
 ss =length( find(  S1_C1 >= S1_C2 ) ) ;
 if ~isempty( ss )  SPIKE_RATE_1stBin_Centroid_Error_points = ss ; else SPIKE_RATE_1stBin_Centroid_Error_points =0 ;  end
 ss =length( find(  S2_C2 >= S2_C1 ) ) ;
    if ~isempty( ss )  SPIKE_RATE_1stBin_Centroid_Error_points = SPIKE_RATE_1stBin_Centroid_Error_points + ss ; end
    SPIKE_RATE_1stBin_Centroid_Error_precent = 100* SPIKE_RATE_1stBin_Centroid_Error_points/ ( Nb+Nb2  );
    SPIKE_RATE_1stBin_Centroid_Error_points
    SPIKE_RATE_1stBin_Centroid_Error_precent    
%--------------

%--------  SVM clustering --- SPIKE_RATE_1stBin -----------
[ SPIKE_RATE_1stBin_SVM_accuracy , SPIKE_RATE_1stBin_Clustering_error_precent_SVM , TOTAL_RATE_Not_distinguishable_points_num_SVM ] = SVM_check_accuracy_1D_data( ... 
       Data_Rate_Patterns1_1stBin , Data_Rate_Patterns2_1stBin , Nb , Nb2 , N );
%----------------------------------------------------------   
   
   
%%---- K_MEANS for 1st bin spike rates ------
%----------TOTAL RATES K-MEANS
%    [Not_distinguishable_points_numRate , Clustering_error_precentRate ]= ...
%     Clustering_accuracy_2clusters( Data_total_rates1  , Data_total_rates2  );
% Not_distinguishable_points_numRate
% Clustering_error_precentRate
whos Data_Rate_Patterns1_1stBin
whos Data_Rate_Patterns2_1stBin
[  SPIKE_RATES_1stBin_Not_distinguishable_points_num_KMEANS  ,  SPIKE_RATES_1stBin_Clustering_error_precent_KMEANS , SPIKE_RATES_1stBin_KMEANS_accuracy]= ...
    Clustering_accuracy_2clusters( Data_total_rates1 , Data_total_rates2  ) ;
 SPIKE_RATES_1stBin_Clustering_error_precent_KMEANS
 SPIKE_RATES_1stBin_KMEANS_accuracy


%----------------------------


%%%----------------------- 
%     figure
%  bar( [ Data_Rate_Signature1(1,:)' Data_Rate_Signature2(1,:)' ] ) 
% title( 'Firing rate in 1st bin at electrodes (2 patern sets)' )
% % end      
% figure  
% hold on
%    errorbar( Data_Rate_Signature1(1,:) , Data_Rate_Signature1_std(1,:) , 'x' )  
%       errorbar( Data_Rate_Signature2(1,:) , Data_Rate_Signature2_std(1,:) , 'xr')
%       title( 'Firing rate in 1st bin at electrodes (2 patern sets)' )
% hold off 


%------------SPIKE RATES Information bits - selective bins and electrodes ----------

Channel_rate_different_OVERLAP_RATES = zeros(   N ,fire_bins);
STABLE_Channel_rate_different_OVERLAP_RATES = zeros(   N ,fire_bins);
Channel_rate_different_if1_STAT_DIFF = zeros(   N ,fire_bins);
Channel_rate_different_if1_LINEARY_DIFF = zeros(   N ,fire_bins);
Channel_rate_different_if1_mean_rate_diff = zeros(   N ,fire_bins);
Channel_rate_stable_both = zeros(   N ,fire_bins);
   
SpikeRate_STAT_Selectivity_Nbins_total=0;
SpikeRate_LINEARY_Selectivity_Nbins_total=0;
Total_bins = 0 ;
plots_num = 0 ;
whos Data_Rate_Patterns1
for ti=1: fire_bins
for ch = 1 : N    
    a=[];
    b=[];
    for i=1:Nb 
        a(i)= Data_Rate_Patterns1(  i , ch, ti  ) ; 
    end
    for i=1:Nb2 
        b(i)= Data_Rate_Patterns2( i , ch, ti ) ; 
    end 
    
    [ StatisitcallyDifferent_if1 , LinearyDifferent_if1 , overlap_values_Optim_Thres_precent ,Zero_values_total_precent ...
        ,Zero_values_in_Data1_precent,Zero_values_in_Data2_precent ,overlap_val_STABLE_Optim_Thres_precent , is_Stable_response ]= ...
          SelectiveValues( a ,b , PvalRanksum , OVERLAP_TRES , true ,STIM_RESPONSE_BOTH_INPUTS ) ;
      
%            if LinearyDifferent_if1 == 1 
%              if  overlap_values_Optim_Thres_precent < OVERLAP_TRES
          if LinearyDifferent_if1 == 1 & plots_num < 5
               plots_num=plots_num+1;
               xxxm=max(max(a),max(b));
               xxx = 0: xxxm/10 :xxxm;
            a'
            b'
            [n,x] = hist(a , xxx); 
            n=100* n/ length( a );
            [n2,x2] = hist(b ,xxx ); 
             n2=100* n2/ length( b );
            figure  
            subplot( 3,1,1);
            bar( [ x' x2' ],[ n' n2' ])        
            title(  ['selective bit Rates, overlap=' int2str(overlap_values_Optim_Thres_precent) ])
             subplot( 3,1,2); 
            hold on
%             bar( a , 'BarWidth',0.6)
%             bar( b, 'r','BarWidth',0.3)
            plot( a ,  '--'  ,'MarkerSize'      , 6 ,'Marker'          , '.'  )
            plot( b, 'r','MarkerSize'      , 6 ,'Marker'          , '.'  )
            xlabel( 'Stimulus #');
            ylabel( 'Spike rate, spikes/bin');
            title( ['Values,channel-' int2str(ch) ',bin-' int2str(ti) ] )
            hold off
            subplot( 3,1,3); 
              bar( [ Zero_values_in_Data1_precent'  Zero_values_in_Data2_precent' ])
              title( 'Zero values in Data1 precent, Data2')
              Zero_values_in_Data1_precent;
              Zero_values_in_Data2_precent;
%               pause
           end
         
      
%!!!!!! is_Stable_response
    if is_Stable_response
        Total_bins = Total_bins + 1 ;
        SPIKE_RATE_OVERLAPS= [ SPIKE_RATE_OVERLAPS overlap_val_STABLE_Optim_Thres_precent ];
        Channel_rate_stable_both( ch , ti)  = 1; 
    end
   Channel_rate_different_if1_STAT_DIFF( ch , ti) = StatisitcallyDifferent_if1 ;  
   Channel_rate_different_if1_LINEARY_DIFF( ch , ti) = LinearyDifferent_if1   ; 
   Channel_rate_different_mean_rate_diff( ch , ti) = abs( mean( a) -mean(b) )   ;   
%    overlap_values_Optim_Thres_precent
%    Channel_rate_different_OVERLAP_RATES( ch , ti) = overlap_values_Optim_Thres_precent ; 
      Channel_rate_different_OVERLAP_RATES( ch , ti) = overlap_val_STABLE_Optim_Thres_precent ;  
   STABLE_Channel_rate_different_OVERLAP_RATES( ch , ti) = overlap_val_STABLE_Optim_Thres_precent ; 
   c= find(ch == CHABBELS_ERASED );
   if isempty( c  ) % take spike rates only of responding electrodes to both inputs      
%       SPIKE_RATE_OVERLAPS= [ SPIKE_RATE_OVERLAPS overlap_values_Optim_Thres_precent ];
      
      SPIKE_RATE_OVERLAPS_STABLE=[SPIKE_RATE_OVERLAPS_STABLE overlap_val_STABLE_Optim_Thres_precent];
   end
%     SPIKE_RATE_OVERLAPS= [ SPIKE_RATE_OVERLAPS overlap_values_Optim_Thres_precent ];
   SpikeRate_STAT_Selectivity_Nbins_total=SpikeRate_STAT_Selectivity_Nbins_total + StatisitcallyDifferent_if1;
   SpikeRate_LINEARY_Selectivity_Nbins_total=SpikeRate_LINEARY_Selectivity_Nbins_total + LinearyDifferent_if1 ;
   
end
end 
% SPIKE_RATE_OVERLAPS =SPIKE_RATE_OVERLAPS ;
whos SPIKE_RATE_OVERLAPS
SpikeRate_STAT_Selectivity_Nbins_precent = 100 * SpikeRate_STAT_Selectivity_Nbins_total / Total_bins ;
SpikeRate_LINEARY_Selectivity_Nbins_precent = 100 * SpikeRate_LINEARY_Selectivity_Nbins_total / Total_bins ;
 

  
%---- SPIKE_RATE_OVERLAPS histogram ----------
     xxx =  0 : 5 : 50 ;
 [n,x] = hist(SPIKE_RATE_OVERLAPS ,xxx); 
  n=100* n/ length( SPIKE_RATE_OVERLAPS );
  figure  
    bar(   x   ,  n     )
     title( 'SPIKE RATE overlaps Distribution, %' )
     
%      SPIKE_RATE_OVERLAPS_STABLE( SPIKE_RATE_OVERLAPS_STABLE==60) =[];
%  [n,x] = hist(SPIKE_RATE_OVERLAPS_STABLE ,xxx); 
%   n=100* n/ length( SPIKE_RATE_OVERLAPS_STABLE );
%   figure  
%     bar(   x   ,  n     )
%      title( 'SPIKE RATE STABLE overlaps Distribution, %' )
 %-------------------------


Total_bins
SpikeRate_STAT_Selectivity_Nbins_total
SpikeRate_STAT_Selectivity_Nbins_precent
SpikeRate_LINEARY_Selectivity_Nbins_precent
%---------------------------------------
 

%------Analyze only BINs & FIRST BINS, channels averaging
Bins_overlaps_mean = zeros(1,fire_bins);
Bins_overlaps_error = zeros(1,fire_bins);
Overlap_y=[];
Overlap_x=[];
for ti=1: fire_bins
   ss= find( Channel_rate_different_OVERLAP_RATES( : , ti ) <= 50 );
   Overlap_x = [ Overlap_x ones(1,length(ss))*ti ];
   bb= Channel_rate_different_OVERLAP_RATES( ss , ti ) ;
   whos bb
   Overlap_y = [ Overlap_y bb' ];
   Bins_overlaps_mean( ti) = mean(Channel_rate_different_OVERLAP_RATES( ss , ti ));
   Bins_overlaps_error( ti ) = std( Channel_rate_different_OVERLAP_RATES( ss , ti ));
end
 

ss= find( Channel_rate_different_OVERLAP_RATES( : , 1 ) <= 50 );
FirstBIN_SPIKERATE_OVERLAPS = [ FirstBIN_SPIKERATE_OVERLAPS   Channel_rate_different_OVERLAP_RATES( ss , 1 ) ] ;


min_bin = find( Bins_overlaps_mean == min( Bins_overlaps_mean ));
BIN_SPIKERATE_OVERLAPS_min_overlap =  Channel_rate_different_OVERLAP_RATES( : , min_bin )   ;
 
% FirstBIN_SPIKERATE_OVERLAPS

%      figure
%  errorbar( mean(FirstBIN_SPIKERATE_OVERLAPS ) , std(FirstBIN_SPIKERATE_OVERLAPS)  )
%       title( 'Overlaps in 1st bin' )
      
ALL_channels_FirstBIN_SPIKERATE_OVERLAPS  = Channel_rate_different_OVERLAP_RATES( : , 1 ) ;
      Plot8x8Data( ALL_channels_FirstBIN_SPIKERATE_OVERLAPS )
    xlabel('Electrode #')
    ylabel('Electrode #')
          title( 'Rate Overlaps in first bin' )
          
          ALL_channels_FirstBIN_SPIKERATE_STAT_SELECTIVE  = Channel_rate_different_if1_STAT_DIFF( : , 1 ) ;
      Plot8x8Data( ALL_channels_FirstBIN_SPIKERATE_STAT_SELECTIVE )
    xlabel('Electrode #')
    ylabel('Electrode #')
          title( 'Rate Stat selective in first bin' )
           colormap gray
          
% ALL_channels_minBIN_SPIKERATE_OVERLAPS  = Channel_rate_different_OVERLAP_RATES( : , min_bin ) ;
%       Plot8x8Data( ALL_channels_minBIN_SPIKERATE_OVERLAPS )
%     xlabel('Electrode #')
%     ylabel('Electrode #')
%           title( 'Rate Overlaps in min overlap bin' )          
           
          
      
     figure
 hold on
 errorbar( Bins_overlaps_mean  , Bins_overlaps_error , 'LineWidth'       , 2    )
     xlabel('Time delay')
    ylabel('Electrode #')
    
     Channel_rate_different_OVERLAP_RATES( : , : )
    plot( Overlap_x, Overlap_y , 'LineStyle'       , 'none'    ,'Marker'          , '.'         ,  'Color'           , [.3 .3 .3] );
    hold off
      title( 'Overlaps in bins' )
%-----------------------------





%------Draw aet1 and set2 signatures-----------------


%         [psth_dx , psth , psth_norm] = PSTH_calc( Data1 , Nb , PSTH_BIN  , Pattern_length_ms , N ) ;      
%            figure
% subplot(1,2,1);
%     plot( psth_dx , psth  )    
%            [psth_dx , psth , psth_norm] = PSTH_calc( Data2 , Nb2 , PSTH_BIN  , Pattern_length_ms , N ) ;
% subplot(1,2,2);
%     plot( psth_dx , psth  )    
%      title( ['Spikes after stimulus, ' int2str( Pattern_length_ms) 'ms, Bin=' int2str( PSTH_BIN )] )


figure
subplot(1,2,1);

x=1:fire_bins; y = 1:N;
imagesc(  x *DT , y , Data_Rate_Signature1' )
% title( 'Difference between 2 pattern:1-stat diff,2-rates overlap %,3-mean rate diff');
title( 'Spike Rate signature 1');
colorbar
% colormap bone

subplot(1,2,2);
x=1:fire_bins; y = 1:N;
imagesc(  x *DT , y , Data_Rate_Signature2' )
% title( 'Difference between 2 pattern sets (mean rate diff)');
title( 'Spike Rate signature 1');
colorbar 
% colormap hot

%%% ---- draw std of the signature ------
figure
subplot(1,2,1);
x=1:fire_bins; y = 1:N;
imagesc(  x *DT , y , Data_Rate_Signature1_std' ) 
title( 'Spike Rate STD 1');
colorbar 
subplot(1,2,2);
x=1:fire_bins; y = 1:N;
imagesc(  x *DT , y , Data_Rate_Signature2_std' ) 
title( 'Spike Rate STD 2');
colorbar 
colormap hot

%---------------------


%------------------------



%---  Draw difference between 2 sets ------------------------------
figure
x=1:fire_bins; y = 1:N;

% subplot(1,4,1);
% imagesc(  x*DT   , y , Channel_rate_different_if1_STAT_DIFF )
% % title( 'Difference between 2 pattern:1-stat diff,2-rates overlap %,3-mean rate diff');
% title( '1-stat diff');
% colorbar
% colormap bone
% 
% subplot(1,4,2);
% x=1:fire_bins; y = 1:N;
% imagesc(  x*DT   , y , Channel_rate_different_if1_LINEARY_DIFF )
% % title( 'Difference between 2 pattern sets (mean rate diff)');
% title( '2-lineary diff');
% colorbar 
% colormap hot
% 
% % figure
% subplot(1,4,3);
% x=1:fire_bins; y = 1:N;
% imagesc(  x*DT   , y , Channel_rate_different_OVERLAP_RATES )
% title( '3-rates overlap %');
% % title( 'Difference between 2 pattern sets (percent of overlap)');
% colorbar 
% colormap hot
% 
% % figure
% subplot(1,4,4);
% x=1:fire_bins; y = 1:N;
% imagesc(  x*DT   , y , Channel_rate_different_mean_rate_diff )
% % title( 'Difference between 2 pattern sets (mean rate diff)');
% title( '4-mean rate diff');
% colorbar 
% colormap hot

subplot(1,4,1);

x=1:fire_bins; y = 1:N;
imagesc(  x *DT , y , Data_Rate_Signature1' )
% title( 'Difference between 2 pattern:1-stat diff,2-rates overlap %,3-mean rate diff');
title( 'Spike Rate signature 1');
colorbar 

subplot(1,4,2);
x=1:fire_bins; y = 1:N;
imagesc(  x *DT , y , Data_Rate_Signature2' )
% title( 'Difference between 2 pattern sets (mean rate diff)');
title( 'Spike Rate signature 1');
colorbar 

subplot(1,4,3);
h1 = imagesc(  x*DT   , y , Channel_rate_different_if1_STAT_DIFF );
% title( 'Difference between 2 pattern:1-stat diff,2-rates overlap %,3-mean rate diff');
title( '1-stat diff');
colorbar 
 

% figure
subplot(1,4,4);
x=1:fire_bins; y = 1:N;
h1  = imagesc(  x*DT   , y , Channel_rate_different_OVERLAP_RATES )
title( '3-rates overlap %');
% title( 'Difference between 2 pattern sets (percent of overlap)');
colorbar 
colormap jet

 saveas(h1 ,['spike_rate_difference_' File_name_x  '.bmp']); 


figure 

subplot(1,2,1);
h1 = imagesc(  x*DT   , y , Channel_rate_different_if1_STAT_DIFF );
% title( 'Difference between 2 pattern:1-stat diff,2-rates overlap %,3-mean rate diff');
title( '1-stat diff');
colorbar 

subplot(1,2,2);
Channel_rate_different_OVERLAP_RATES(1,end) = 0 ;
x=1:fire_bins; y = 1:N;
h = imagesc(  x*DT   , y , Channel_rate_different_OVERLAP_RATES );
% axis square
colorbar
title( 'SpikeRate overlaps %');
saveas(h ,['spike_rate_overlaps_' File_name_x  '.bmp']); 
% title( 'Difference between 2 pattern sets (percent of overlap)');
 
% colormap hot

% figure 
% x=1:fire_bins; y = 1:N;
% imagesc(  x*DT   , y , STABLE_Channel_rate_different_OVERLAP_RATES )
% title( 'SpikeRate overlaps STABLE, %');
% % title( 'Difference 2 pattern sets (percent of overlap)');
% colorbar 
% colormap hot
%------------------------

  
  
 
%   for ch = 1 : N             
%  
%     ch_r =0 ;
%     for t = 1 : Nb    
%          si = find( Data1( t , ch ,: )>= Start_t & Data1( t , ch ,: )< Burst_len +Start_t ) ;
%        ch_r = ch_r + H( length( si )) ;    
%     end
%      
%     ch_r2 =0 ;
%     for t = 1 : Nb2                      
%        si = find( Data2( t , ch ,: )>= Start_t & Data2( t , ch ,: )< Burst_len +Start_t ) ;
%        ch_r2 = ch_r2 + H( length( si )) ;  
%     end
%     
%     % Если есть мало успешных ответов (есть спайк после стим) на электроде
%     % то убрать электрод из анализа 
%     if ch_r/Nb < STIM_RESPONSE_BOTH_INPUTS   
%        Data1( : , ch , : ) = 0 ;        Data2( : , ch , :) = 0 ;
%     end
%     if ch_r2/Nb2 < STIM_RESPONSE_BOTH_INPUTS  
%        Data1( : , ch , : ) = 0 ;        Data2( : , ch , :) = 0 ;
%     end
%   end



% %%% Erase channels that were stimulated
% CHANNELS = [49 57  ];
% [Data1_new , Data2_new] = Erase_Specified_Channels( Data1 , Data2 ,  CHANNELS  );
%  Data1 = Data1_new ;
% Data2 = Data2_new ;
% %%%-----



%  chan_firing1 = zeros( 1 , fire_bins   );
%  chan_firing2 = zeros( 1 , fire_bins   );
%  Chan_Corrs = zeros( 1 , N );
%  Chan_Corrs_cross = zeros( 1 , N );
% %  for ch = 1 : N 
%        
%    ch = 13 ;
%     
%       hh=0;
%       hh2 = 0;
%       for t = 1 :   Nb    
%           chan_firing_buf=zeros( 1 , fire_bins   );
%           for ti=1: fire_bins
%             dti = DT*ti ;
%             si = find( Data1( t , ch ,: )>= dti+Start_t & Data1( t , ch ,: )< dti+DT+Start_t  ) ;
%             chan_firing_buf( ti ) =  length( si ) ;
%           end
%           si = find( Data1( t , ch ,: )>= Start_t & Data1( t , ch ,: )< fire_bins*DT +Start_t ) ;
%           chan_firing1( : ) = chan_firing1( : ) + chan_firing_buf( : )/length( si )  ; 
%       end
%       chan_firing1( : ) = chan_firing1( : )/ Nb ;
%       
%         for t = 1 : Nb2       
%           chan_firing_buf=zeros( 1 , fire_bins   );
%           for ti=1: fire_bins
%             dti = DT*ti ;
%             si = find(  Data2( t , ch ,: )>= dti+Start_t &  Data2( t , ch ,: )< dti+DT+Start_t  ) ;
%             chan_firing_buf( ti ) =  length( si ) ;
%           end
%            si = find( Data2( t , ch ,: )>= Start_t & Data2( t , ch ,: )< fire_bins*DT +Start_t ) ;
%           chan_firing2( : ) = chan_firing2( : ) + chan_firing_buf( : )/length( si )  ; 
%       end
%       chan_firing2( : ) = chan_firing2( : )/ Nb2 ; 
      
      
      
%        for t = 1 : floor( Nb/2 )   
%            chan_firing_buf=zeros( 1 , fire_bins   );
%           for ti=1: fire_bins
%             dti = DT*ti ;
%             si = find( Data1( t , ch ,: )>= dti+Start_t & Data1( t , ch ,: )< dti+DT +Start_t ) ;
%             chan_firing_buf( ti ) =  length( si ) ;
%           end
%           si = find( Data1( t , ch ,: )>= Start_t & Data1( t , ch ,: )< fire_bins*DT +Start_t ) ;
%           chan_firing1( : ) = chan_firing1( : ) + chan_firing_buf( : )  ;
%       end
%       chan_firing1( : ) = chan_firing1( : )/ Nb ;
%       
%       
%       for t = floor( Nb / 2)  : Nb    
%           chan_firing_buf=zeros( 1 , fire_bins   );
%           for ti=1: fire_bins
%             dti = DT*ti ;
%             si = find(  Data1( t , ch ,: )>= dti+Start_t &  Data1( t , ch ,: )< dti+DT+Start_t  ) ;
%             chan_firing_buf( ti ) = length( si ) ;
%           end
%           si = find( Data1( t , ch ,: )>= Start_t & Data1( t , ch ,: )< fire_bins*DT +Start_t ) ;
%           chan_firing2( : ) = chan_firing2( : ) + chan_firing_buf( : ) ;
%       end
%       chan_firing2( : ) = chan_firing2( : )/ Nb ;
%   for ch = 1 : N   
% 





% Rtotal = [] ;
% Rtotal_cross = [] ;
%   for t = 1 :  Nb    
%     for s = 1 :  Nb  
%         if t < s        
%             
%           chan_firing_buf1=zeros( 1 , fire_bins   );
%           for ti=1: fire_bins
%             dti = DT*ti ;
%             si = find( Data1( t , ch ,: )>= dti+Start_t & Data1( t , ch ,: )< dti+DT +Start_t ) ;
%             chan_firing_buf1( ti ) =  length( si ) ; if ~isfinite(chan_firing_buf1  )  chan_firing_buf1( ti )= 0 ;end
%           end
%           si = find( Data1( t , ch ,: )>= Start_t & Data1( t , ch ,: )< fire_bins*DT +Start_t ) ;
%           Spikes = length( si ) ; if ~isfinite(Spikes) || Spikes==0 Spikes=1 ;end
%           chan_firing_buf1( : ) = chan_firing_buf1( : ) / Spikes ;
%           
%           
%            chan_firing_buf2=zeros( 1 , fire_bins   );
%           for ti=1: fire_bins
%             dti = DT*ti ;
%             si = find( Data1( s , ch ,: )>= dti+Start_t & Data1( s , ch ,: )< dti+DT +Start_t ) ;
%             chan_firing_buf2( ti ) =  length( si ) ;if ~isfinite( chan_firing_buf2  )  chan_firing_buf2( ti )= 0 ;end
%           end
%           s2 = find( Data1( s , ch ,: )>= Start_t & Data1( s , ch ,: )< fire_bins*DT +Start_t ) ;    
%           Spikes = length( s2 ) ; if ~isfinite(Spikes) || Spikes==0 Spikes=1 ;end
%           chan_firing_buf2( : ) = chan_firing_buf2( : ) / Spikes ;
%           
%           
%           cora = corr( chan_firing_buf1',chan_firing_buf2') ;
%       if  isfinite( cora )  Rtotal = [Rtotal  cora   ]; end 
%       
%            
%           
%            
%     end
%   end    
%   end  
%     Chan_Corrs( ch )  = mean( Rtotal )  ;
%   
%  
%     for t = 1 :  Nb    
%     for s = 1 :  Nb2  
%          
%            chan_firing_buf1=zeros( 1 , fire_bins   );
%           for ti=1: fire_bins
%             dti = DT*ti ;
%             si = find( Data1( t , ch ,: )>= dti+Start_t & Data1( t , ch ,: )< dti+DT +Start_t ) ;
%             chan_firing_buf1( ti ) =  length( si ) ;if ~isfinite( chan_firing_buf1  )   chan_firing_buf1( ti )= 0 ;end
%           end
%           si = find( Data1( t , ch ,: )>= Start_t & Data1( t , ch ,: )< fire_bins*DT +Start_t ) ; 
%           Spikes = length( si ) ; if ~isfinite(Spikes) || Spikes==0 Spikes=1 ;end
%           chan_firing_buf1( : ) = chan_firing_buf1( : ) / Spikes  ;
%           
%            chan_firing_buf2=zeros( 1 , fire_bins   );
%           for ti=1: fire_bins
%             dti = DT*ti ;
%             si = find( Data2( s , ch ,: )>= dti+Start_t & Data2( s , ch ,: )< dti+DT +Start_t ) ;
%             chan_firing_buf2( ti ) =  length( si ) ;if ~isfinite(chan_firing_buf2  )  chan_firing_buf2( ti )= 0 ;end
%           end
%           s2 = find( Data2( s , ch ,: )>= Start_t & Data2( s , ch ,: )< fire_bins*DT +Start_t ) ;          
%           Spikes = length( s2 ) ; if ~isfinite(Spikes) || Spikes==0 Spikes=1 ;end
%           chan_firing_buf2( : ) = chan_firing_buf2( : ) / Spikes ;
%           
%           cora = corr( chan_firing_buf1',chan_firing_buf2') ;
%           if  isfinite(cora)  Rtotal_cross = [Rtotal_cross  cora     ]; end 
%            
%           
%     end
%      
%     end  
%     Chan_Corrs_cross( ch )  = mean( Rtotal_cross )  ;
%  end 




% 
% %%%----------Чатсота на разных задежках - корреляция для разных стимулов
%  for ti=1: fire_bins
%      Rtotal = [] ;
%   for t = 1 :  Nb    
%     for s = 1 :  Nb  
%         if t < s        
%             
%             Chan_Corrs = zeros( 1 , N ); 
%             Chan_Corrs2 = zeros( 1 , N ); 
%           for ch = 1 : N      
%           
%          
%             dti = DT*ti ;
%             si = find( Data1( t , ch ,: )>= dti+Start_t & Data1( t , ch ,: )< dti+DT +Start_t ) ;
%             Chan_Corrs( ch ) =  length( si ) ; if ~isfinite(  Chan_Corrs( ch )  )   Chan_Corrs( ch )= 0 ;end
%           
%           sirate = find( Data1( t , ch ,: )>= Start_t & Data1( t , ch ,: )< fire_bins*DT +Start_t ) ;
%           Spikes = length( sirate ) ; if ~isfinite(Spikes) || Spikes==0 Spikes=1 ;end
%           Chan_Corrs( ch ) = Chan_Corrs( ch )  / Spikes ;
%        
%             dti = DT*ti ;
%             si = find( Data1( s , ch ,: )>= dti+Start_t & Data1( s , ch ,: )< dti+DT +Start_t ) ;
%             Chan_Corrs2( ch ) =  length( si ) ; if ~isfinite(  Chan_Corrs2( ch )  )   Chan_Corrs2( ch )= 0 ;end
%            
%           s2 = find( Data1( s , ch ,: )>= Start_t & Data1( s , ch ,: )< fire_bins*DT +Start_t ) ;    
%           Spikes = length( s2 ) ; if ~isfinite(Spikes) || Spikes==0 Spikes=1 ;end
%           Chan_Corrs2( ch ) = Chan_Corrs2( ch )  / Spikes ;
%           
%           end
%           cora = corr( Chan_Corrs',Chan_Corrs2') ;
%            if  isfinite( cora )  Rtotal = [Rtotal  cora   ]; 
%              
%            end
%            
%     end
%     end    
%   end
%   
%   chan_firing1( ti )  = mean( Rtotal );
% end    
%          
%     for ti=1: fire_bins
%         Rtotal_cross = [] ;
%   for t = 1 :  Nb    
%     for s = 1 :  Nb2     
%             
%             Chan_Corrs = zeros( 1 , N ); 
%             Chan_Corrs2 = zeros( 1 , N ); 
%           for ch = 1 : N      
%           
%          
%             dti = DT*ti ;
%             si = find( Data1( t , ch ,: )>= dti+Start_t & Data1( t , ch ,: )< dti+DT +Start_t ) ;
%             Chan_Corrs( ch ) =  length( si ) ; if ~isfinite(  Chan_Corrs( ch )  )   Chan_Corrs( ch )= 0 ;end
%           
%           sirate = find( Data1( t , ch ,: )>= Start_t & Data1( t , ch ,: )< fire_bins*DT +Start_t ) ;
%           Spikes = length( sirate ) ; if ~isfinite(Spikes) || Spikes==0 Spikes=1 ;end
%           Chan_Corrs( ch ) = Chan_Corrs( ch )  / Spikes ;
%           
%           
%            
%           
%             dti = DT*ti ;
%             si = find( Data2( s , ch ,: )>= dti+Start_t & Data2( s , ch ,: )< dti+DT +Start_t ) ;
%             Chan_Corrs2( ch ) =  length( si ) ; if ~isfinite(  Chan_Corrs2( ch )  )   Chan_Corrs2( ch )= 0 ;end
%            
%           s2 = find( Data2( s , ch ,: )>= Start_t & Data2( s , ch ,: )< fire_bins*DT +Start_t ) ;    
%           Spikes = length( s2 ) ; if ~isfinite(Spikes) || Spikes==0 Spikes=1 ;end
%           Chan_Corrs2( ch ) = Chan_Corrs2( ch )  / Spikes ;
%           
%           end
%           cora = corr( Chan_Corrs',Chan_Corrs2') ;
%            if  isfinite( cora )  Rtotal_cross = [Rtotal_cross  cora   ]; 
%                 
%            end
%            
%     end
%   end    
%       chan_firing2( ti )  = mean( Rtotal_cross );
%   end
%   
% figure
% bar( chan_firing1 )
% figure
% bar( chan_firing2 )       
%      figure
%   bar( [ chan_firing1' chan_firing2' ]  )
%     
%   %%%---------------
  

%%%----Spike rate signatures
%   
% chan_firing1 = zeros( fire_bins  , N ); 
% chan_firing1_mean = zeros( fire_bins  , N ); chan_firing1_std = zeros( fire_bins  , N ); 
% chan_firing2 = zeros( fire_bins  , N ); 
% chan_firing2_mean = zeros( fire_bins  , N ); chan_firing2_std = zeros( fire_bins  , N ); 
% all_chan_firing1 = zeros( fire_bins ,N , Nb);
% all_chan_firing2 = zeros( fire_bins , N , Nb2);
% 
% chan_firing_buf1=zeros( 1 , fire_bins   );
% %  for ti=1: fire_bins 
     
%    for ch = 1 : N          
%       for ti=1: fire_bins
%         chan_firing1_total = [];  
%         for t = 1 :  Nb   
%             dti = DT*(ti-1) ;
%             si = find( Data1( t , ch ,: )>= dti+Start_t & Data1( t , ch ,: )< dti+DT +Start_t ) ;
%             rate =length( si ) ;if ~isfinite(  rate  )  rate= 0 ;end
%             chan_firing1(ti, ch ) = chan_firing1( ti,ch ) + rate ; 
%             chan_firing1_total = [chan_firing1_total rate];
%             all_chan_firing1( ti, ch , t ) = rate ;
%             
%             sirate = find( Data1( t , ch ,: )>= Start_t & Data1( t , ch ,: )< fire_bins*DT +Start_t ) ;
%             Spikes = length( sirate ) ; if ~isfinite(Spikes) || Spikes==0 Spikes=1 ;end
% %           Chan_Corrs( ch ) = Chan_Corrs( ch )  / Spikes ;  
%         end      
%         chan_firing1_mean( ti , ch ) = mean( chan_firing1_total );
%         chan_firing1_std( ti ,  ch ) = std( chan_firing1_total    );
%           
%       end
%       chan_firing1( :, ch ) = chan_firing1( :, ch ) /Nb ;
%   end 
%   
%   
%       
%   for ch = 1 : N    
%      for ti=1: fire_bins
%            chan_firing2_total = [];    
%            for t = 1 :  Nb2     
%             dti = DT*(ti-1) ;
%             si = find( Data2( t , ch ,: )>= dti+Start_t & Data2( t , ch ,: )< dti+DT +Start_t ) ;
%             rate =length( si ) ;if ~isfinite(  rate  )  rate= 0 ;end
%             chan_firing2( ti, ch ) = chan_firing2( ti, ch ) + rate ; 
%             chan_firing2_total = [chan_firing2_total rate];
%           all_chan_firing2( ti, ch , t ) = rate ;
%             
%           sirate = find( Data2( t , ch ,: )>= Start_t & Data2( t , ch ,: )< fire_bins*DT +Start_t ) ;
%           Spikes = length( sirate ) ; if ~isfinite(Spikes) || Spikes==0 Spikes=1 ;end
% %           Chan_Corrs( ch ) = Chan_Corrs( ch )  / Spikes ;  
%           end    
%           
%           chan_firing2_mean( ti,  ch ) = mean( chan_firing2_total );
%           chan_firing2_std( ti, ch ) = std( chan_firing2_total  );
%      end   
%      chan_firing2( :, ch ) = chan_firing2( :, ch ) /Nb2 ;
%   end  
   %%%%%%-------------------
  

    
    
    
%       figure
%     hist(   aa   );
%     figure
%     hist(   bb   );
    
%  figure
%  bar( chan_firing1 )
%  figure
%   bar( chan_firing2 )

%  end 

    
    
    