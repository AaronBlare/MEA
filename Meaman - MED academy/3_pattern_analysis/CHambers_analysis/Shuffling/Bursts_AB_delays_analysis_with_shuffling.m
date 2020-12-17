% Bursts_AB_delays_analysis_with_shuffling

% ANALYZED_DATA_A.burst_start
% ANALYZED_DATA_A.burst_end
%  BurstDurations
% ANALYZED_DATA_B.burst_start
% ANALYZED_DATA_B.burst_end


ChambersAB_max_lag =    Global_flags.ChambersAB_max_lag  ;
ChambersAB_lag_bin =    Global_flags.ChambersAB_lag_bin  ;
ChambersAB_shuffling_loops=    Global_flags.ChambersAB_shuffling_loops ;
ChambersAB_figure_title =    Global_flags.ChambersAB_figure_title ;

% initialize
ANALYZED_DATA.Chambers_A_B_delays_test_bins_x = [] ;
ANALYZED_DATA.Chambers_A_B_delays_test_bins_shuffle = [] ;
ANALYZED_DATA.Chambers_A_B_delays_test_bins = [] ;     

ANALYZED_DATA.Chambers_A_B_connection_exist = (false > 0 ) ;

ANALYZED_DATA.Chambers_A_B_evoked_number = 0 ; % [ ai -> bi ], ai - from ANALYZED_DATA_A, bi - from ANALYZED_DATA_B ;
ANALYZED_DATA.Chambers_A_B_evoked_percent = 0 ;
ANALYZED_DATA.Chambers_A_B_evoked_burst_index = [] ; % [ ai -> bi ], ai - from ANALYZED_DATA_A, bi - from ANALYZED_DATA_B ;
ANALYZED_DATA.Chambers_A_B_evoked_delays = [] ; % delays between A start and B start [ 100 150 ... ] ;
ANALYZED_DATA.Chambers_A_B_evoked_mean_delay = 0 ;

ANALYZED_DATA.Chambers_B_A_connection_exist = false ;

ANALYZED_DATA.Chambers_B_A_evoked_number = 0  ;
ANALYZED_DATA.Chambers_B_A_evoked_percent = 0 ;
ANALYZED_DATA.Chambers_B_A_evoked_burst_index = [] ; % [ ai -> bi ], ai - from ANALYZED_DATA_A, bi - from ANALYZED_DATA_B ;
ANALYZED_DATA.Chambers_B_A_evoked_delays = [] ; % delays between A start and B start [ 100 150 ... ] ;
ANALYZED_DATA.Chambers_B_A_evoked_mean_delay = 0 ;
B_A_evoked_burst_index = [] ;
A_B_evoked_burst_index = [] ;
%----------------

E1 = ANALYZED_DATA_A.burst_start ;
A_N = length( E1 ) ;
E1_d = ANALYZED_DATA_A.BurstDurations ;
%  
E2 = ANALYZED_DATA_B.burst_start ;
B_N = length( E2 ) ;
E2_d = ANALYZED_DATA_B.BurstDurations ;
if length( E1 ) > 0 &&  length( E2 ) > 0  

%---------------------------------%---------------------------------%---------------------------------
[ Edelays , AB_index ] = Events_2sets_delays( E1 ,E1_d , E2 ,E2_d , ChambersAB_max_lag );
%---------------------------------%---------------------------------%---------------------------------

AB_index_0 = AB_index ;
Edelays_0 = Edelays ;

binx = -ChambersAB_max_lag : ChambersAB_lag_bin : ChambersAB_max_lag ;
Edelays( abs( Edelays ) > ChambersAB_max_lag ) = [] ;
[Ebincounts,ind]=  hist( Edelays , binx );
Ebincounts = 100 * Ebincounts / length( Edelays ) ;
% Ebincounts = 100 * Ebincounts / length( E1 ) ;
% Ebincounts = Ebincounts / 1 ;

Ebincounts0 = Ebincounts ;


% Suffle events times of Es with Ed durations
Ebincounts(:)=0;
Ebincounts_shuffle = Ebincounts ;
Ebincounts_shuffle_stack = [] ;
Edelays_size = 0 ;
for i = 1 : ChambersAB_shuffling_loops
 [ Es_rand , Ee_rand ] = SuffleEvents( E2 , E2_d ); 
[ Edelays , AB_index ] = Events_2sets_delays( E1 , E1_d , Es_rand , E2_d , ChambersAB_max_lag );

Edelays( abs( Edelays ) > ChambersAB_max_lag ) = [] ;
Edelays(  isnan( Edelays )) = 0 ; 
if sum( abs( Edelays ) ) > 0
if length( Edelays ) > 0
 [Ebincounts,ind]=  hist( Edelays , binx );
     if ~isempty( Ebincounts )
      Ebincounts_shuffle = Ebincounts_shuffle + Ebincounts ;
    %   Edelays_size = Edelays_size + length( Edelays ) ;
      Edelays_size = Edelays_size + length( E1 ) ;
      Ebincounts = 100 * ( Ebincounts /  length( Edelays ))  ; 
      Ebincounts_shuffle_stack = [ Ebincounts_shuffle_stack ; Ebincounts ] ;
     end
end
end
end

%    Ebincounts_shuffle = 100 * Ebincounts_shuffle / Edelays_size ; 
%    Ebincounts_shuffle_mean =  mean( Ebincounts_shuffle_stack ) ;
%    Ebincounts_shuffle_std =  std( Ebincounts_shuffle_stack ) ;
%   Ebincounts_shuffle = Ebincounts_shuffle_mean ;

  
  Ebincounts_shuffle = 100 * Ebincounts_shuffle / Edelays_size ; 
  Ebincounts_shuffle_mean =  Global_flags.ChambersAB_shuffling_mean_coeff  *  mean( Ebincounts_shuffle_stack ) ;
  Ebincounts_shuffle_std = Global_flags.ChambersAB_shuffling_sigma  *  std( Ebincounts_shuffle_stack ) ;
  
  ; 
  
%    sigma = std( Ebincounts_shuffle); 
%    threshold =  Global_flags.ChambersAB_shuffling_sigma  * sigma  + Global_flags.ChambersAB_shuffling_mean_coeff  *  mean( Ebincounts_shuffle ) ;
   Delay_Stat_diff = [] ;  
   for i = 1 : length( Ebincounts_shuffle )
       threshold = Ebincounts_shuffle_mean( i ) + Ebincounts_shuffle_std( i ) ;
       if   Ebincounts0( i ) > threshold
          Delay_Stat_diff  = [ Delay_Stat_diff i ] ;  
       end
      
%       if   Ebincounts0( i ) > threshold
%           Delay_Stat_diff  = [ Delay_Stat_diff i ] ; ;
%       end
   end
   
  Significant_delays = binx(Delay_Stat_diff)  ;
  Significant_delays_percent = Ebincounts0(Delay_Stat_diff)  ;  
  
  AB_i = find( Significant_delays > 0 );
  BA_i = find( Significant_delays < 0 ); 
  A_B_evoked_burst_number_AB = length( AB_i );
  A_B_evoked_burst_number_BA = length( BA_i );
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
  Significant_delays_AB = [] ;
  if ~isempty( AB_i )
   for i=1:length( Edelays_0 )
    for j =1:length(Significant_delays_AB_i)        
     if Edelays_0( i )> Significant_delays_AB_i(j)-ChambersAB_lag_bin/2 &&...
         Edelays_0( i )<= Significant_delays_AB_i(j)+ChambersAB_lag_bin/2    
     
         AB_index_0_filt = [ AB_index_0_filt ; AB_index_0( i,:)];
         Significant_delays_AB =  [Significant_delays_AB  Edelays_0( i ) ] ; 
     end
    end
   end
  A_B_significant_delay_AB_mean = mean(  Significant_delays_AB ) ;
    if isnan( A_B_significant_delay_AB_mean ) A_B_significant_delay_AB_mean=0; end
  A_B_evoked_burst_index_AB = AB_index_0_filt ;
  A_B_evoked_burst_number_AB = size( A_B_evoked_burst_index_AB , 1 ) ;
  A_B_significant_trans_AB_percent = 100 * ( A_B_evoked_burst_number_AB / A_N ) ;
  else
      A_B_evoked_burst_index_AB = [] ;
  end
  
 AB_index_0_filt = [] ;
 Significant_delays_BA  = [] ; 
  if ~isempty( BA_i )
   for i=1:length( Edelays_0 )
    for j =1:length(Significant_delays_BA_i)        
     if Edelays_0( i )> Significant_delays_BA_i(j)-ChambersAB_lag_bin/2 &&...
         Edelays_0( i )<= Significant_delays_BA_i(j)+ChambersAB_lag_bin/2    
     
         AB_index_0_filt = [ AB_index_0_filt ; AB_index_0( i,:)];
         Significant_delays_BA =  [Significant_delays_BA  Edelays_0( i ) ] ; 
     end
    end
   end
  A_B_significant_delay_BA_mean = mean( Significant_delays_BA ) ;
    if isnan( A_B_significant_delay_BA_mean ) A_B_significant_delay_BA_mean=0; end
  A_B_evoked_burst_index_BA = AB_index_0_filt ;
  A_B_evoked_burst_number_BA = size( A_B_evoked_burst_index_BA , 1 ) ;
  A_B_significant_trans_BA_percent = 100 * ( A_B_evoked_burst_number_BA / B_N ) ;
  else
      A_B_evoked_burst_index_BA = [] ;
  end
  %------------------
  
  
  
   if ~isempty( Ebincounts )
    f=figure ;
	set(f, 'name', ChambersAB_figure_title  ,'numbertitle','off' )
    hold on
    plot( binx , Ebincounts0  , 'Linewidth' , 2 );
	plot( binx , Ebincounts_shuffle_mean  , 'r' , 'Linewidth' , 2 );
    plot( binx , Ebincounts_shuffle_mean + Ebincounts_shuffle_std  , 'r-.' , 'Linewidth' , 2 );

	plot( binx(Delay_Stat_diff) , Ebincounts0(Delay_Stat_diff) ,  'g*' ,'Linewidth' , 2);
	legend( 'Real' , 'Surrogates', 'Stat. threshold', 'Stat.different')
	xlabel( 'Delay A > B, ms')
    ylabel('Probability, %')
   end
   

ANALYZED_DATA.Chambers_A_B_delays_test_bins_x = binx ;
ANALYZED_DATA.Chambers_A_B_delays_test_bins_shuffle = Ebincounts_shuffle_mean ;
ANALYZED_DATA.Chambers_A_B_delays_test_bins = Ebincounts0 ;     

ANALYZED_DATA.Chambers_A_B_connection_exist = (A_B_evoked_burst_number_AB > 0 ) ;

ANALYZED_DATA.Chambers_A_B_evoked_number = A_B_evoked_burst_number_AB ; % [ ai -> bi ], ai - from ANALYZED_DATA_A, bi - from ANALYZED_DATA_B ;
ANALYZED_DATA.Chambers_A_B_evoked_percent = A_B_significant_trans_AB_percent ;
ANALYZED_DATA.Chambers_A_B_evoked_burst_index = A_B_evoked_burst_index_AB ; % [ ai -> bi ], ai - from ANALYZED_DATA_A, bi - from ANALYZED_DATA_B ;
ANALYZED_DATA.Chambers_A_B_evoked_delays = Significant_delays_AB ; % delays between A start and B start [ 100 150 ... ] ;
ANALYZED_DATA.Chambers_A_B_evoked_mean_delay = A_B_significant_delay_AB_mean ;

ANALYZED_DATA.Chambers_B_A_connection_exist = ( A_B_evoked_burst_number_BA > 0 ) ;

ANALYZED_DATA.Chambers_B_A_evoked_number = A_B_evoked_burst_number_BA  ;
ANALYZED_DATA.Chambers_B_A_evoked_percent = A_B_significant_trans_BA_percent ;
ANALYZED_DATA.Chambers_B_A_evoked_burst_index = A_B_evoked_burst_index_BA ; % [ ai -> bi ], ai - from ANALYZED_DATA_A, bi - from ANALYZED_DATA_B ;
ANALYZED_DATA.Chambers_B_A_evoked_delays = Significant_delays_BA ; % delays between A start and B start [ 100 150 ... ] ;
ANALYZED_DATA.Chambers_B_A_evoked_mean_delay = A_B_significant_delay_BA_mean ;
   
B_A_evoked_burst_index = A_B_evoked_burst_index_BA ;
A_B_evoked_burst_index = A_B_evoked_burst_index_AB ;

end

%   ANALYZED_DATA.A_B_evoked_burst_index = AB_index_0 ;
%   ANALYZED_DATA.A_B_evoked_burst_index_AB = A_B_evoked_burst_index_AB;
%   ANALYZED_DATA.A_B_evoked_burst_index_BA = A_B_evoked_burst_index_BA ;
%   ANALYZED_DATA.A_B_delays_test_bins_x = binx ;
%   ANALYZED_DATA.A_B_delays_test_bins_shuffle = Ebincounts_shuffle ;
%   ANALYZED_DATA.A_B_delays_test_bins = Ebincounts0 ;
%   ANALYZED_DATA.A_B_significant_delay_AB_mean = A_B_significant_delay_AB_mean ;   
%   ANALYZED_DATA.A_B_significant_delay_BA_mean = A_B_significant_delay_BA_mean ;  
%   ANALYZED_DATA.A_B_significant_trans_AB_percent = A_B_significant_trans_AB_percent ;
%   ANALYZED_DATA.A_B_significant_trans_BA_percent = A_B_significant_trans_BA_percent ;
   
   
   
 
 
 