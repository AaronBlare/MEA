function [ result ]= Events_delays_analysis_with_shuffling( E1 ,E1_d , E2 ,E2_d  )
% input E1  E2 - times
%  E1_d  E2_d - durations
% output - result structure with fields

GLOBAL_CONSTANTS_load
% ChambersAB_max_lag =   12500 ; % Global_flags.ChambersAB_max_lag  ;
% ChambersAB_lag_bin =    120 ; % Global_flags.ChambersAB_lag_bin  ;
ChambersAB_max_lag =     Global_flags.ChambersAB_max_lag  ;
ChambersAB_lag_bin =     Global_flags.ChambersAB_lag_bin  ;
ChambersAB_shuffling_loops=    Global_flags.ChambersAB_shuffling_loops ;
ChambersAB_figure_title =    Global_flags.ChambersAB_figure_title ;

% Initialize
result.Chambers_A_B_connection_exist = false ;
result.Chambers_A_B_delays_test_bins_x = [] ;
result.Chambers_A_B_delays_test_bins_shuffle = [] ;
result.Chambers_A_B_delays_test_bins = [] ;     

result.Chambers_A_B_evoked_burst_number =  0  ;  
result.Chambers_A_B_evoked_percent = 0 ;
result.Chambers_A_B_evoked_burst_index = [] ; % [ ai -> bi ], ai - from result_A, bi - from result_B ;
result.Chambers_A_B_evoked_delays = [] ; % delays between A start and B start [ 100 150 ... ] ;
result.Chambers_A_B_evoked_mean_delay = 0 ;

result.Chambers_B_A_connection_exist = false ;     
result.Chambers_B_A_evoked_burst_number =  0  ; % [ ai -> bi ], ai - from result_A, bi - from result_B ;
result.Chambers_B_A_evoked_percent = 0 ;
result.Chambers_B_A_evoked_burst_index = [] ; % [ ai -> bi ], ai - from result_A, bi - from result_B ;
result.Chambers_B_A_evoked_delays = [] ; % delays between A start and B start [ 100 150 ... ] ;
result.Chambers_B_A_evoked_mean_delay = [] ;
%-------------------

if ~isempty( E2) && ~isempty( E1) 
if length( E1)>0 && length(  E2)>0 
    
[ Edelays , AB_index ] = Events_2sets_delays( E1 ,E1_d , E2 ,E2_d , ChambersAB_max_lag );
AB_index_0 = AB_index ;
Edelays_0 = Edelays ;

binx = -ChambersAB_max_lag : ChambersAB_lag_bin : ChambersAB_max_lag ;
[Ebincounts,ind]=  hist( Edelays , binx );
% Ebincounts = 100 * Ebincounts / length( Edelays ) ;
Ebincounts = 100 * Ebincounts / length( E1 ) ;
% Ebincounts = Ebincounts / 1 ;

Ebincounts0 = Ebincounts ;


% Suffle events times of Es with Ed durations
Ebincounts(:)=0;
Ebincounts_shuffle = Ebincounts ;
Ebincounts_shuffle_stack = [] ;
Edelays_size = 0 ;
MinT = min( [ min( E2) min( E2) ]);
MaxT = max( [ max( E2) min( E2) ]) + max( [ max( E1_d) min( E1_d) ]) ;

for i = 1 : ChambersAB_shuffling_loops
 [ Es_rand , Ee_rand ] = SuffleEvents( E2 , E2_d , MinT , MaxT ); 
[ Edelays , AB_index ] = Events_2sets_delays( E1 , E1_d , Es_rand , E2_d , ChambersAB_max_lag );
 [Ebincounts,ind]=  hist( Edelays , binx );
 nanall = isnan( Ebincounts );
 isnanall = sum( nanall ) == 0  ;
 if  ~isnan( Ebincounts(1 ) )
 if ~isempty( Ebincounts )
     if length( Edelays )>0
%   Ebincounts_shuffle = Ebincounts_shuffle + Ebincounts ;
%    Edelays_size = Edelays_size + length( E1 ) ;
   
     Ebincounts = 100 * ( Ebincounts /  length( Edelays ))  ; 
        Ebincounts_shuffle_stack = [ Ebincounts_shuffle_stack ; Ebincounts ] ;
     end
 end
 end
end
%    Ebincounts_shuffle = 100 * Ebincounts_shuffle / Edelays_size ; 
%    Ebincounts_shuffle =  Ebincounts_shuffle / 1 ; 

  Ebincounts_shuffle = 100 * Ebincounts_shuffle / Edelays_size ; 
  Ebincounts_shuffle_mean =  Global_flags.ChambersAB_shuffling_mean_coeff  *  mean( Ebincounts_shuffle_stack ) ;
  Ebincounts_shuffle_std = Global_flags.ChambersAB_shuffling_sigma  *  std( Ebincounts_shuffle_stack ) ;
  
  if isempty( Ebincounts_shuffle_stack )
      Ebincounts_shuffle_mean = 0 ;
      Ebincounts_shuffle_std = 0 ;
  end
  
%    sigma = std( Ebincounts_shuffle -mean( Ebincounts_shuffle ));
%    threshold =  5 * sigma  + mean( Ebincounts_shuffle ) ;
   Delay_Stat_diff = [] ;  
   for i = 1 : length( Ebincounts_shuffle )
       if ~isempty( Ebincounts_shuffle_stack )
       threshold = Ebincounts_shuffle_mean( i ) + Ebincounts_shuffle_std( i ) ;
       else
          threshold = 0 ; 
       end
      if   Ebincounts0( i ) > threshold
          Delay_Stat_diff  = [ Delay_Stat_diff i ] ;  
      end
   end
   
  Significant_delays = binx(Delay_Stat_diff)  ;
  Significant_delays_percent = Ebincounts0(Delay_Stat_diff)  ;  
  
  AB_i = find( Significant_delays >= 0 );
  BA_i = find( Significant_delays < 0 ); 
  Significant_delays_AB_i  = Significant_delays( AB_i ) ;
  Significant_delays_BA_i  = Significant_delays( BA_i ) ;
  A_B_significant_delay_AB_mean = mean( Significant_delays( AB_i )) ;
  if isnan( A_B_significant_delay_AB_mean ) A_B_significant_delay_AB_mean=0; end
  A_B_significant_delay_BA_mean = mean( Significant_delays( BA_i )) ;
  if isnan( A_B_significant_delay_BA_mean ) A_B_significant_delay_BA_mean=0; end
  A_B_significant_trans_AB_percent = sum( Significant_delays_percent( AB_i )) ;
  A_B_significant_trans_BA_percent = sum( Significant_delays_percent( BA_i )) ;
  
  % leave only significant delays in AB transfer bursts index
  AB_index_0_filt = [] ;
  Delays_AB_all = [];
  if ~isempty( AB_i )
   for i=1:length( Edelays_0 )
    for j =1:length(Significant_delays_AB_i)        
     if Edelays_0( i )> Significant_delays_AB_i(j)-ChambersAB_lag_bin/2 &&...
         Edelays_0( i )<= Significant_delays_AB_i(j)+ChambersAB_lag_bin/2    
     
         Delays_AB_all = [ Delays_AB_all    Edelays_0( i ) ];
         AB_index_0_filt = [ AB_index_0_filt ; AB_index_0( i,:)];
     end
    end
  end
  A_B_evoked_burst_index_AB = AB_index_0_filt ;
  else
      A_B_evoked_burst_index_AB = [] ;
  end
  Delays_AB_all_mean = mean( Delays_AB_all ) ;
  
    % leave only significant delays in BA transfer bursts index
 AB_index_0_filt = [] ;
 Delays_BA_all = [];
  if ~isempty( BA_i )
   for i=1:length( Edelays_0 )
    for j =1:length(Significant_delays_BA_i)        
     if Edelays_0( i )> Significant_delays_BA_i(j)-ChambersAB_lag_bin/2 &&...
         Edelays_0( i )<= Significant_delays_BA_i(j)+ChambersAB_lag_bin/2    
     
        Delays_BA_all = [ Delays_BA_all    Edelays_0( i ) ];
         AB_index_0_filt = [ AB_index_0_filt ; AB_index_0( i,:)];
     end
    end
  end
  A_B_evoked_burst_index_BA = AB_index_0_filt ;
  else
      A_B_evoked_burst_index_BA = [] ;
  end
    Delays_BA_all_mean = mean( Delays_BA_all ) ;

  %------------------
  s=size(A_B_evoked_burst_index_AB);
  A_B_evoked_burst_number_AB=s(1);
   s=size(A_B_evoked_burst_index_BA);
  A_B_evoked_burst_number_BA=s(1);
  
  if Global_flags.Stim_Search_Params.Shuffle_test_show_figure  
   if ~isempty( Ebincounts )
    f=figure ;
	set(f, 'name', ChambersAB_figure_title  ,'numbertitle','off' )
    hold on
    plot( binx , Ebincounts0  , 'Linewidth' , 2 );
	plot( binx , Ebincounts_shuffle  , 'r' , 'Linewidth' , 2 );
	plot( binx(Delay_Stat_diff) , Ebincounts0(Delay_Stat_diff) ,  'g*' ,'Linewidth' , 2);
	legend( 'Real' , 'Surrogates', 'Stat. different')
	xlabel( 'Delay A > B, ms')
    ylabel('Probability, %')
   end
  end

 Chambers_A_B_connection_exist = (A_B_evoked_burst_number_AB > 0 ) ;
     
result.Chambers_A_B_delays_test_bins_x = binx ;
result.Chambers_A_B_delays_test_bins_shuffle = Ebincounts_shuffle ;
result.Chambers_A_B_delays_test_bins = Ebincounts0 ;     

result.Chambers_A_B_connection_exist = Chambers_A_B_connection_exist ;
result.Chambers_A_B_evoked_burst_number =  A_B_evoked_burst_number_AB  ;  
result.Chambers_A_B_evoked_percent = A_B_significant_trans_AB_percent ;
result.Chambers_A_B_evoked_burst_index = A_B_evoked_burst_index_AB ; % [ ai -> bi ], ai - from result_A, bi - from result_B ;
result.Chambers_A_B_evoked_delays = Delays_AB_all ; % delays between A start and B start [ 100 150 ... ] ;
result.Chambers_A_B_evoked_mean_delay = Delays_AB_all_mean ;

 Chambers_B_A_connection_exist = ( A_B_evoked_burst_number_BA > 0 ) ;

result.Chambers_B_A_connection_exist = Chambers_B_A_connection_exist ;     
result.Chambers_B_A_evoked_burst_number =  A_B_evoked_burst_number_BA  ; % [ ai -> bi ], ai - from result_A, bi - from result_B ;
result.Chambers_B_A_evoked_percent = A_B_significant_trans_BA_percent ;
result.Chambers_B_A_evoked_burst_index = A_B_evoked_burst_index_BA ; % [ ai -> bi ], ai - from result_A, bi - from result_B ;
result.Chambers_B_A_evoked_delays = Delays_BA_all ; % delays between A start and B start [ 100 150 ... ] ;
result.Chambers_B_A_evoked_mean_delay = Delays_BA_all_mean ;

end
end

