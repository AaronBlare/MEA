 
function [ SpikeRate , TOTAL_RATE ] =...
compare_activity_in_Patterns( Patterns1 , Patterns2 ,  STIM_RESPONSE_BOTH_INPUTS ,OVERLAP_TRES , ...
      PvalRanksum, CHANNELS_ERASED , File_name_x , SHOW_FIGURES , TOTAL_RATE , comp_flags )
% OUTPUT :
%     SpikeRate.STAT_Selectivity_Nbins_total 
%     SpikeRate.STAT_Selectivity_Nbins_precent
%     SpikeRate.LINEARY_Selectivity_Nbins_precent 
%     SpikeRate.LINEARY_Selectivity_Nbins_total 
%     TOTAL_RATE.Intersimilarity_Dissimilar_patterns_precent 
%     TOTAL_RATE.Intersimilarity_Dissimilar_patterns 
%     TOTAL_RATE.Centroid_Error_points
%     TOTAL_RATE.Centroid_Error_precent 
%     TOTAL_RATE.Clustering_error_precent_KMEANS 
%     TOTAL_RATE.Clustering_error_precent_SVM  
%     TOTAL_RATE.SVM_accuracy 
%     SpikeRate.Total_bins 
%     SpikeRate.SPIKE_RATE_OVERLAPS
%     SpikeRate.SPIKE_RATE_OVERLAPS_STABLE
%     SpikeRate.SPIKE_RATE_1stBin_Centroid_Error_precent
%     SpikeRate.Bins_overlaps_mean
%     SpikeRate.SPIKE_RATE_1stBin_Clustering_error_precent_KMEANS 
%     SpikeRate.SPIKE_RATE_1stBin_KMEANS_accuracy 
%     SpikeRate.FirstBIN_SPIKERATE_OVERLAPS 
%     SpikeRate.SPIKE_RATE_1stBin_SVM_accuracy

Count_zero_values = comp_flags.Count_zero_values ;
stim_channels_numbers = comp_flags.stim_channels_numbers ;

 N = length( Patterns1.Spike_Rates_each_channel_mean  );
Nb = Patterns1.Number_of_Patterns  ;
Nb2 = Patterns2.Number_of_Patterns  ;
% N=64;
% PSTH_BIN= 10 ;

 Burst_len = Patterns1.Poststim_interval_END - Patterns1.Poststim_interval_START  ;
 Start_t = Patterns1.Poststim_interval_START;
 DT_step = Patterns1.DT_bin   ;

 DT = DT_step ;
%  OVERLAP_TRES = 15 ;
  
fire_bins = floor(  (Burst_len ) / DT) ;

  SPIKE_RATE_OVERLAPS = []; 
  FirstBIN_SPIKERATE_OVERLAPS = [] ;
  SecondBIN_SPIKERATE_OVERLAPS =[];
  SPIKE_RATE_OVERLAPS_STABLE=[];
  
%     [ Data_total_rates1,  Data_total_rates2 ,  Data_total_rates_signature1 , Data_total_rates_signature2  ...
%    Data_Rate_Patterns1 ,  Data_Rate_Patterns2 ,Data_Rate_Signature1 , Data_Rate_Signature2 ,...
%    Data_Rate_Signature1_std , Data_Rate_Signature2_std  ] ...
%       = Get_Electrodes_Rates_at_TimeBins( N ,Nb ,Nb2, Data1 , Data2  , Start_t , Pattern_length_ms ,DT_step );
  
   

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



% Data_total_rates_signature = Patterns1.Spike_Rates_Signature' ;
% Data_total_rates = Patterns1.Spike_Rates_each_burst' ;
% Data_total_rates_signature
% Data_total_rates

 [ TOTAL_RATE_Centroid_Error_points , TOTAL_RATE_Centroid_Error_precent ] = ...
    K_Means_defined_centers( Patterns1.Spike_Rates  , Patterns2.Spike_Rates  , Patterns1.Spike_Rates_each_channel_mean ...
    , Patterns2.Spike_Rates_each_channel_mean , SHOW_FIGURES ) ;

   
%%%----- Compare just patterns - matrix - how similar far and close any pairs
%%%of points
if SHOW_FIGURES
  
  subplot( 2 ,2 , 2)
end
  
    Matrix_Similarities( Patterns1.Spike_Rates_each_burst   , Patterns2.Spike_Rates_each_burst , false ) ;
    axis square
title( [ 'Spike total rates patterns - basic dist, Ns1=' num2str(Nb) ', Ns2=' num2str(Nb2) ]  ); 
     [  overlapped_values , overlapped_valuse_precent , Optimal_Threshold ,...
    TOTAL_RATE_Intersimilarity_Dissimilar_patterns_precent , TOTAL_RATE_Intersimilarity_Dissimilar_patterns ] ...
      =Matrix_Similarities_overlap( Patterns1.Spike_Rates_each_burst  ,Patterns2.Spike_Rates_each_burst , false  )  ;
     TOTAL_RATE_Intersimilarity_Dissimilar_patterns_precent
     TOTAL_RATE_Intersimilarity_Dissimilar_patterns  
%%%-----------------------    
    
    
%----- Plot each spike rate in each channel each peattern in 2d plot - patterns1 VS patterns2
%  if SHOW_FIGURES
%      
%      figure 
%      
%       if Nb2>Nb
%              Nb2_e = Nb ;
%              Nb_e=Nb;
%          else
%              Nb_e=Nb2; 
%              Nb2_e = Nb2 ;
%          end
% %          c = colormap(jet(Nb_e*N)) ;
% 
%          Spike_Rates1 =Patterns1.Spike_Rates( 1 : Nb , :);
%          Spike_Rates2 =Patterns2.Spike_Rates( 1 : Nb2 , :);
%          all_spike_rates1_1_dim = Spike_Rates1(:)' ;
%          all_spike_rates2_1_dim = Spike_Rates2(:)' ;
% 
%          
%           hold on
%              for ii = 1:Nb_e*N
%             
% %               plot(Spike_Rates1( ii) , Spike_Rates2( ii), 'Color',c(ii,:)');
%               plot(all_spike_rates1_1_dim( ii) , all_spike_rates2_1_dim( ii) , '*','MarkerSize' ,10 );
%              end
%             xlabel( 'Patterns 1');
%             ylabel( 'Patterns 2');
%             hold off
% 
%     %          plot( all_spike_rates1_1_dim ,all_spike_rates2_1_dim ,'*') 
%              title('Spike rates all channels in 2 sets')
%                 axis square
%  end  
    
    
    
%--------Compare distances KMEANS --- TOTAL RATES-------- 
 PATTERNS=[ Patterns1.Spike_Rates  ; Patterns2.Spike_Rates  ] ; 
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



%+++++++++++++ Clustering_accuracy +++++++++++++++++++
whos Patterns1.Spike_Rates
whos Patterns2.Spike_Rates
[  TOTAL_RATE_Not_distinguishable_points_num_KMEANS  ,  TOTAL_RATE_Clustering_error_precent_KMEANS , TOTAL_RATE_KMEANS_accuracy]= ...
    Clustering_accuracy_2clusters( Patterns1.Spike_Rates , Patterns2.Spike_Rates , true  , Count_zero_values) ;
 TOTAL_RATE_Not_distinguishable_points_num_KMEANS =  TOTAL_RATE_Not_distinguishable_points_num_KMEANS ;
 TOTAL_RATE_Clustering_error_precent_KMEANS =  TOTAL_RATE_Clustering_error_precent_KMEANS ;
 TOTAL_RATE_Clustering_error_precent_KMEANS
 TOTAL_RATE_KMEANS_accuracy
% ------------------------------------------- 
%  save bububu.mat
 
%--------------

%--------  SVM clustering --- TOTAL RATES--------  
[ TOTAL_RATE_SVM_accuracy , TOTAL_RATE_Clustering_error_precent_SVM , TOTAL_RATE_Not_distinguishable_points_num_SVM ] = ...
    SVM_check_accuracy_1D_data(  Patterns1.Spike_Rates , Patterns2.Spike_Rates  , Nb , Nb2 , N );
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
       Data_Rate_Patterns1_1stBin( i , ch)  =  Patterns1.Spike_Rate_Patterns(  1 , ch , i  ) ; 
       for ti=1: fire_bins
          Data_Rate_Patterns1_2D(i , ch * ti) = Patterns1.Spike_Rate_Patterns(  ti , ch , i ) ; 
       end
   end  
end
for i=1:Nb2  
   for ch = 1 : N 
       Data_Rate_Patterns2_1stBin( i , ch)  =  Patterns2.Spike_Rate_Patterns(  1 , ch , i ) ; 
       for ti=1: fire_bins
          Data_Rate_Patterns2_2D(i , ch * ti) = Patterns2.Spike_Rate_Patterns( ti , ch , i ) ; 
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

   
     [  overlapped_values , overlapped_valuse_precent , Optimal_Threshold ,...
   SPIKE_RATE_Intersimilarity_Dissimilar_patterns_precent , SPIKE_RATE_Intersimilarity_Dissimilar_patterns ] ...
      =Matrix_Similarities_overlap( Data_Rate_Patterns1_2D,Data_Rate_Patterns2_2D , false  )  ;
     SPIKE_RATE_Intersimilarity_Dissimilar_patterns_precent
     SPIKE_RATE_Intersimilarity_Dissimilar_patterns  
%%%---------------------------

%%%----- Compare just patterns - matrix - how similar far and close any pairs
% %%%of points
%       Matrix_Similarities( Data_Rate_Patterns1_1stBin,Data_Rate_Patterns2_1stBin  ) ;
% title( '1st bin spikerates - basic dist'); 

%--------Compare Centroid distance SPIKE RATES 1 -ST BIN -------- 
%      D1 = [ Data_total_rates_signature1_1D ; Data_Rate_Patterns1_2D ];

 [ SPIKE_RATE_1stBin_Centroid_Error_points , SPIKE_RATE_1stBin_Centroid_Error_precent ] = ...
    K_Means_defined_centers( Data_Rate_Patterns1_1stBin  , Data_Rate_Patterns2_1stBin , Data_total_rates_signature1_1stBin' ...
    , Data_total_rates_signature2_1stBin' , SHOW_FIGURES ) ;

 
            
%      figure
if SHOW_FIGURES 
         title( 'SPIKE RATES 1st BIN Dist to centroids') 
     
     figure
        
%     subplot( 2 ,2 , 4)
    
    %     Matrix_Similarities( Data_Rate_Patterns1_2D , Data_Rate_Patterns2_2D  ) ;
        Matrix_Similarities( Data_Rate_Patterns1_1stBin , Data_Rate_Patterns2_1stBin , false  ) ;
            axis square
%     title( [ 'Spike Rates patterns - basic dist, Ns1=' num2str(Nb) ', Ns2=' num2str(Nb2) ]  ); 
       title( ['1st '  num2str( Patterns1.DT_bin )  'ms bin - basic dist']); 
end
      
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
    Clustering_accuracy_2clusters( Data_Rate_Patterns1_1stBin , Data_Rate_Patterns2_1stBin  ) ;
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

%----------------------- %----------------------- %----------------------- 
%----------------------- %----------------------- %----------------------- 
%------------SPIKE RATES Information bits - selective bins and electrodes ----------
%----------------------- %----------------------- %----------------------- 

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
%     a=[];
%     b=[];
%     for i=1:Nb 
%         a(i)= Patterns1.Spike_Rate_Patterns( ti , ch,  i   ) ; 
%     end
%     for i=1:Nb2 
%         b(i)= Patterns2.Spike_Rate_Patterns( ti , ch,  i ) ; 
%     end 
    a=zeros( 1, Nb);
    b=zeros( 1, Nb2);
        a(:)  =  Patterns1.Spike_Rate_Patterns( ti , ch,  :  )  ;  
        b(:)  =  Patterns2.Spike_Rate_Patterns( ti , ch,  :  )    ; 
%         a=a';
%         b=b';
   Bit_good_for_analysis = false ;    
   
  if Count_zero_values == false
    
              chan_rates1_zero_values = find(a==0);
              chan_rates1_zero_values = length( chan_rates1_zero_values );
              chan_rates2_zero_values= find(b==0); 
              chan_rates2_zero_values = length( chan_rates2_zero_values );

                  chan_rates1_zero_NONvalues_fraction = (length( a ) - chan_rates1_zero_values)  / length( a ) ;
                  chan_rates2_zero_NONvalues_fraction =(length( b ) - chan_rates2_zero_values) / length( b ) ;



           if  chan_rates1_zero_NONvalues_fraction   >= STIM_RESPONSE_BOTH_INPUTS & ...
                                chan_rates2_zero_NONvalues_fraction   >= STIM_RESPONSE_BOTH_INPUTS & ... 
                                Patterns1.Channels_active( ch ) == 1 & Patterns2.Channels_active( ch ) == 1
                     Bit_good_for_analysis = true ;
           end
  else% if bit before OR after is not silent then use it
             if  mean(a) > 0
                 Bit_good_for_analysis = true ;
             end

             if  mean(b) > 0
                 Bit_good_for_analysis = true ;
             end

  end
     
  %//////////////////////////////////////////////    
  %//////////////////////////////////////////////    
    %//////////////////////////////////////////////       
   if Bit_good_for_analysis        
       
       
        [ StatisitcallyDifferent_if1 , LinearyDifferent_if1 , overlap_values_Optim_Thres_precent ,Zero_values_total_precent ...
            ,Zero_values_in_Data1_precent,Zero_values_in_Data2_precent ,overlap_val_STABLE_Optim_Thres_precent , is_Stable_response ]= ...
              SelectiveValues( a ,b , PvalRanksum , OVERLAP_TRES , Count_zero_values  ,STIM_RESPONSE_BOTH_INPUTS ) ; 
%            if LinearyDifferent_if1 == 1 
%              if  overlap_values_Optim_Thres_precent < OVERLAP_TRES
              if LinearyDifferent_if1 == 1 && plots_num < 7 && SHOW_FIGURES 
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
                title(  ['selective bin Spike Rates, overlap=' int2str(overlap_values_Optim_Thres_precent) ])
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
%     if is_Stable_response
        Total_bins = Total_bins + 1 ;
 
           SPIKE_RATE_OVERLAPS= [ SPIKE_RATE_OVERLAPS overlap_val_STABLE_Optim_Thres_precent ];
           Channel_rate_stable_both( ch , ti)  = 1; 
 
%     end
       Channel_rate_different_if1_STAT_DIFF( ch , ti) = StatisitcallyDifferent_if1 ;  
       Channel_rate_different_if1_LINEARY_DIFF( ch , ti) = LinearyDifferent_if1   ; 
       Channel_rate_different_mean_rate_diff( ch , ti) = abs( mean( a) -mean(b) )   ;   
    %    overlap_values_Optim_Thres_precent
    %    Channel_rate_different_OVERLAP_RATES( ch , ti) = overlap_values_Optim_Thres_precent ; 
          Channel_rate_different_OVERLAP_RATES( ch , ti) = overlap_val_STABLE_Optim_Thres_precent ;  
       STABLE_Channel_rate_different_OVERLAP_RATES( ch , ti) = overlap_val_STABLE_Optim_Thres_precent ; 
       c= find(ch == CHANNELS_ERASED );
       if isempty( c  ) % take spike rates only of responding electrodes to both inputs      
    %       SPIKE_RATE_OVERLAPS= [ SPIKE_RATE_OVERLAPS overlap_values_Optim_Thres_precent ];

          SPIKE_RATE_OVERLAPS_STABLE=[SPIKE_RATE_OVERLAPS_STABLE overlap_val_STABLE_Optim_Thres_precent];
       end
    %     SPIKE_RATE_OVERLAPS= [ SPIKE_RATE_OVERLAPS overlap_values_Optim_Thres_precent ];
       SpikeRate_STAT_Selectivity_Nbins_total=SpikeRate_STAT_Selectivity_Nbins_total + StatisitcallyDifferent_if1;
       SpikeRate_LINEARY_Selectivity_Nbins_total=SpikeRate_LINEARY_Selectivity_Nbins_total + LinearyDifferent_if1 ;
   else  % Bit_good_for_analysis
       
       
      STABLE_Channel_rate_different_OVERLAP_RATES( ch , ti)  = 100;
      Channel_rate_different_OVERLAP_RATES( ch , ti) = 100  ;   
   end
   
   
end
end 
% SPIKE_RATE_OVERLAPS =SPIKE_RATE_OVERLAPS ;
whos SPIKE_RATE_OVERLAPS
SpikeRate_STAT_Selectivity_Nbins_precent = 100 * SpikeRate_STAT_Selectivity_Nbins_total / Total_bins ;
SpikeRate_LINEARY_Selectivity_Nbins_precent = 100 * SpikeRate_LINEARY_Selectivity_Nbins_total / Total_bins ;
 
Total_bins
SpikeRate_STAT_Selectivity_Nbins_total
SpikeRate_STAT_Selectivity_Nbins_precent
SpikeRate_LINEARY_Selectivity_Nbins_precent
  


Bins_overlaps_mean = zeros(1,fire_bins);
Bins_overlaps_error = zeros(1,fire_bins);
Overlap_y=[];
Overlap_x=[];
for ti=1: fire_bins
   ss= find( Channel_rate_different_OVERLAP_RATES( : , ti ) <= 100 );
   Overlap_x = [ Overlap_x ones(1,length(ss))*ti ];
   bb= Channel_rate_different_OVERLAP_RATES( ss , ti ) ;
   whos bb
   Overlap_y = [ Overlap_y bb' ];
   Bins_overlaps_mean( ti) = median(Channel_rate_different_OVERLAP_RATES( ss , ti ));
   Bins_overlaps_error( ti ) = mad( Channel_rate_different_OVERLAP_RATES( ss , ti ));
end
 
ss= find( Channel_rate_different_OVERLAP_RATES( : , 1 ) <= 100 );
FirstBIN_SPIKERATE_OVERLAPS = [ FirstBIN_SPIKERATE_OVERLAPS   Channel_rate_different_OVERLAP_RATES( ss , 1 ) ] ;

[c , min_ti ] = min( Bins_overlaps_mean ) ;
ss= find( Channel_rate_different_OVERLAP_RATES( : , min_ti ) <= 100 );
min_tiBIN_SPIKERATE_OVERLAPS = Channel_rate_different_OVERLAP_RATES( ss , min_ti );

% figure
% Nx = 2 ; Ny = 1;
% subplot( Ny,Nx,1)
%    hist( FirstBIN_SPIKERATE_OVERLAPS )
%    title( 'FirstBIN_SPIKERATE_OVERLAPS')
% subplot( Ny,Nx,2)
%    hist( min_tiBIN_SPIKERATE_OVERLAPS )
%    title( 'min_tiBIN_SPIKERATE_OVERLAPS')

min_bin = find( Bins_overlaps_mean == min( Bins_overlaps_mean ));
BIN_SPIKERATE_OVERLAPS_min_overlap =  Channel_rate_different_OVERLAP_RATES( : , min_bin )   ;
 %++++++++++++++++++++++++++++++++++++++++++++++++++
%++++++++++++++++++++++++++++++++++++++++++++++++++
%++++++++++++++++++++++++++++++++++++++++++++++++++

 

TOTAL_RATE.Intersimilarity_Dissimilar_patterns_precent =TOTAL_RATE_Intersimilarity_Dissimilar_patterns_precent;
TOTAL_RATE.Intersimilarity_Dissimilar_patterns =TOTAL_RATE_Intersimilarity_Dissimilar_patterns;
TOTAL_RATE.Centroid_Error_points = TOTAL_RATE_Centroid_Error_points;
TOTAL_RATE.Centroid_Error_precent =  TOTAL_RATE_Centroid_Error_precent;
TOTAL_RATE.Clustering_error_precent_KMEANS =  TOTAL_RATE_Clustering_error_precent_KMEANS;
TOTAL_RATE.Clustering_error_precent_SVM  = TOTAL_RATE_Clustering_error_precent_SVM; 
TOTAL_RATE.SVM_accuracy =TOTAL_RATE_SVM_accuracy;

SpikeRate.STAT_Selectivity_Nbins_total = SpikeRate_STAT_Selectivity_Nbins_total;
SpikeRate.STAT_Selectivity_Nbins_precent = SpikeRate_STAT_Selectivity_Nbins_precent;
SpikeRate.LINEARY_Selectivity_Nbins_precent = SpikeRate_LINEARY_Selectivity_Nbins_precent;
SpikeRate.LINEARY_Selectivity_Nbins_total = SpikeRate_LINEARY_Selectivity_Nbins_total;
SpikeRate.Total_bins =Total_bins;
SpikeRate.SPIKE_RATE_OVERLAPS =SPIKE_RATE_OVERLAPS;
SpikeRate.SPIKE_RATE_OVERLAPS_STABLE =SPIKE_RATE_OVERLAPS_STABLE;
SpikeRate.SPIKE_RATE_OVERLAPS_2d_signature = Channel_rate_different_OVERLAP_RATES ;
SpikeRate.SPIKE_RATE_1stBin_Centroid_Error_precent =  SPIKE_RATE_1stBin_Centroid_Error_precent;
SpikeRate.Bins_overlaps_mean = Bins_overlaps_mean;
SpikeRate.SPIKE_RATE_1stBin_Clustering_error_precent_KMEANS  = SPIKE_RATES_1stBin_Clustering_error_precent_KMEANS;
SpikeRate.SPIKE_RATE_1stBin_KMEANS_accuracy =   SPIKE_RATES_1stBin_KMEANS_accuracy;
SpikeRate.SPIKE_RATE_1stBin_SPIKERATE_OVERLAPS = FirstBIN_SPIKERATE_OVERLAPS ; %FirstBIN_SPIKERATE_OVERLAPS ;
SpikeRate.SPIKE_RATE_1stBin_SVM_accuracy = SPIKE_RATE_1stBin_SVM_accuracy;
SpikeRate.SPIKE_RATE_1stBin_Clustering_error_precent_SVM = SPIKE_RATE_1stBin_Clustering_error_precent_SVM ;
SpikeRate.SPIKE_RATE_optimal_tbin_number = min_ti ;
SpikeRate.SPIKE_RATE_optimal_tbin_OVERLAPS = min_tiBIN_SPIKERATE_OVERLAPS ;











%++++++++++++++++++++++++++++++++++++++++++++++++++
%++++++++++++++++++++++++++++++++++++++++++++++++++
%++++++++++++++++++++++++++++++++++++++++++++++++++
%++++++++++++++++++++++++++++++++++++++++++++++++++
%+++++ FIGURES ++++++++++++++++++++++++++++++++++++



%---- SPIKE_RATE_OVERLAPS histogram ----------
x=1:fire_bins; y = 1:N;


     xxx =  0 : 5 : 100 ;
 [n,x] = histc(SPIKE_RATE_OVERLAPS ,xxx); 
  n=100* n/ length( SPIKE_RATE_OVERLAPS );
  
  if SHOW_FIGURES
      
  figure  
   
  subplot( 2 , 4, 1  )
  
    bar(   xxx   ,  n     )
%                 axis( [ min(xxx) - 3 max(xxx )+3 0 1.2 * max(n) ] )
     title( 'SPIKE RATE overlaps histogram, %' )
     ylabel( 'Count, %')
     xlabel( 'Overlap')
 %-------------------------



%------Analyze only BINs & FIRST BINS, channels averaging

% FirstBIN_SPIKERATE_OVERLAPS

%      figure
%  errorbar( mean(FirstBIN_SPIKERATE_OVERLAPS ) , std(FirstBIN_SPIKERATE_OVERLAPS)  )
%       title( 'Overlaps in 1st bin' )

x=1:fire_bins;  
subplot( 2 , 4, 2 )
 hold on
 errorbar( x *DT , Bins_overlaps_mean  , Bins_overlaps_error , 'LineWidth'       , 2    )
     xlabel('Time delay')
    ylabel('Electrode #')
    
%      Channel_rate_different_OVERLAP_RATES( : , : )
%     plot( Overlap_x *DT , Overlap_y , 'LineStyle'       , 'none'    ,'Marker'          , '.'         ,  'Color'           , [.3 .3 .3] );
    boxplot(  Channel_rate_different_OVERLAP_RATES ,'plotstyle','compact')
    hold off
%     legend( 'Median overlap' , 'Overlap')
      title( 'Overlaps in bins' )



      subplot( 2 , 4, 3 )
        ALL_channels_FirstBIN_SPIKERATE_OVERLAPS  = Channel_rate_different_OVERLAP_RATES( : , 1 ) ;
        ALL_channels_FirstBIN_SPIKERATE_OVERLAPS  = Channel_rate_different_OVERLAP_RATES( : , min_ti ) ;        
              Plot8x8Data( ALL_channels_FirstBIN_SPIKERATE_OVERLAPS , false )
            xlabel('Electrode #')
            ylabel('Electrode #')
                  title( 'Overlaps spike rate first bin' )
       
       subplot( 2 , 4, 4 )   
%               ALL_channels_FirstBIN_SPIKERATE_STAT_SELECTIVE  = Channel_rate_different_if1_STAT_DIFF( : , 1 ) ;
%           Plot8x8Data( ALL_channels_FirstBIN_SPIKERATE_STAT_SELECTIVE , false )
%         xlabel('Electrode #')
%         ylabel('Electrode #')
%               title( 'Stat. diff. first bin' )
            Stim_channels  = zeros( N , 1 ) ;
            Stim_channels( stim_channels_numbers ) = 1 ;
          Plot8x8Data( Stim_channels , false )
        xlabel('Electrode #')
        ylabel('Electrode #')
              title( 'Stat. diff. first bin' )
%                colormap gray
          

% figure
x=1:fire_bins; y = 1:N;

% subplot(1,4,1);
 subplot( 2 , 4, 5 )
        x=1:fire_bins; y = 1:N;
        imagesc(  x *DT , y , Patterns1.Spike_Rates_Signature' )
        % title( 'Difference between 2 pattern:1-stat diff,2-rates overlap %,3-mean rate diff');
        title( 'Spike Rate signature 1');
        xlabel( 'Offset, ms')
        ylabel( 'Channel')
        colorbar 

% subplot(1,4,2);
subplot( 2 , 4, 6 )
        x=1:fire_bins; y = 1:N;
        imagesc(  x *DT , y , Patterns2.Spike_Rates_Signature' )
        % title( 'Difference between 2 pattern sets (mean rate diff)');
        title( 'Spike Rate signature 2');
        xlabel( 'Offset, ms')
        colorbar 

% subplot(1,4,3);
subplot( 2 , 4, 7 )
        h1 = imagesc(  x*DT   , y , Channel_rate_different_if1_STAT_DIFF );
        % title( 'Difference between 2 pattern:1-stat diff,2-rates overlap %,3-mean rate diff');
        title( '1-stat diff');
        xlabel( 'Offset, ms')
        colorbar 
 

% figure
% subplot(1,4,4);
subplot( 2 , 4, 8 )
        x=1:fire_bins; y = 1:N;
        h1  = imagesc(  x*DT   , y , Channel_rate_different_OVERLAP_RATES )
        title( '3-rates overlap %');
        % title( 'Difference between 2 pattern sets (percent of overlap)');
        colorbar 
        colormap jet
        xlabel( 'Offset, ms')

         saveas(h1 ,['spike_rate_difference_' File_name_x  '.fig']); 




% ALL_channels_minBIN_SPIKERATE_OVERLAPS  = Channel_rate_different_OVERLAP_RATES( : , min_bin ) ;
%       Plot8x8Data( ALL_channels_minBIN_SPIKERATE_OVERLAPS )
%     xlabel('Electrode #')
%     ylabel('Electrode #')
%           title( 'Rate Overlaps in min overlap bin' )          
           
          
      
%      figure

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




%----------------------
% figure
% subplot(1,2,1);
% 
% x=1:fire_bins; y = 1:N;
% imagesc(  x *DT , y , Patterns1.Spike_Rates_Signature' )
% % title( 'Difference between 2 pattern:1-stat diff,2-rates overlap %,3-mean rate diff');
% title( 'Spike Rate signature 1');
% colorbar
% % colormap bone
% 
% subplot(1,2,2);
% x=1:fire_bins; y = 1:N;
% imagesc(  x *DT , y , Patterns2.Spike_Rates_Signature' )
% % title( 'Difference between 2 pattern sets (mean rate diff)');
% title( 'Spike Rate signature 2');
% colorbar 
% % colormap hot
% 
% %%% ---- draw std of the signature ------
% figure
% subplot(1,2,1);
% x=1:fire_bins; y = 1:N;
% imagesc(  x *DT , y , Patterns1.Spike_Rates_Signature_std' ) 
% title( 'Spike Rate STD 1');
% colorbar 
% subplot(1,2,2);
% x=1:fire_bins; y = 1:N;
% imagesc(  x *DT , y , Patterns2.Spike_Rates_Signature_std' ) 
% title( 'Spike Rate STD 2');
% colorbar 
% colormap hot

%---------------------


%------------------------



%---  Draw difference between 2 sets ------------------------------


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




figure 

subplot(1,2,1);
h1 = imagesc(  x*DT   , y , Channel_rate_different_if1_STAT_DIFF );
% title( 'Difference between 2 pattern:1-stat diff,2-rates overlap %,3-mean rate diff');
title( '1-stat diff');
ylabel( 'Channel #')
colorbar 

subplot(1,2,2);
Channel_rate_different_OVERLAP_RATES(1,end) = 0 ;
x=1:fire_bins; y = 1:N;
h = imagesc(  x*DT   , y , Channel_rate_different_OVERLAP_RATES );
% axis square
colorbar
xlabel( 'Offset, ms')
title( 'SpikeRate overlaps %');
saveas(h ,['Spike_rate_overlaps_signatures' File_name_x  '.bmp']); 
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

  end % SHOW_FIGURES
  
 
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

    
    
    