% load_spikes_mat_cycle1



random_channel = 'n' ;
one_burst_part_at_all = 'n' ;
SHOW_FIGURES_CYCLE = 'n' ;
PROCESS_BOTH_REL_AND_ABS_DIST = 'n' ;
USE_RELATIVE_STEP = 'y' ;
FIRST_SPIKES_ANALYSIS = true ;
Pval_act_cycle =  'n';
if ~exist('Pval_act_cycle')    % if not defined before in ...LOAD... func
    Pval_act_cycle =  'n';
end
Show_pattern_dur_hist = 'y';
if exist('PREDEFINED_FILE_LIST') % if PREDEFINED_FILE_LIST created before, 
    % than load_spikes_mat_cycle1 was loaded by ...LOAD... function
    %  so don't need to show plots during processing many files
    Show_pattern_dur_hist='n';
end



% Cycle_P_val_process = 'n' ; % !!!!!!!!!!!!this value should be defined before this
% code


one_burst_from = 2000 ;
one_burst_to = 2300 ;

load( char( filename ) ) ;
motif = burst_activation ;
N = 60 ;

% Nstart = 15 ;
% burst_start( 1 : Nstart ) = [];
% burst_max( 1 : Nstart   )  = [];
% burst_end( 1 : Nstart  )  = [];
% 
% burst_start( 1: end - Nstart  ) = [];
% burst_max( 1: end - Nstart )  = [];
% burst_end( 1: end - Nstart )  = [];
% Nb = length( burst_start ) ;



% burst_start = burst_start * 1 ;
% burst_max = burst_max * 1;
% burst_end = burst_end * 1 ;
% burst_start(1)

% burst_start = burst_start + 100 ;



% burst_start = burst_start( 1 : floor(Nb /3) );
% burst_end = burst_end( 1 : floor(Nb /3) );
% burst_max = burst_max( 1 : floor(Nb /3) );
% Nb = floor(Nb /3) ;
% burst_start = burst_start( 1 : 3 );
% burst_end = burst_end( 1 : 3 );
% burst_max = burst_max( 1 : 3 );
% Nb = 3 ;


siz = size( motif) ;
Nb = siz(1);
N = siz(2);

% mmnn = mean(burst_max( : ) - burst_start(:) ) ;
mindur = 1*mean(burst_end( : ) - burst_start(:) ) ;


P_val = -1 ;
x = 0 ;
PP = [] ;
TT = [] ;
AE = [] ;
DIFF = [] ;
NOISE_t=[];
AVG_PATTERN_DUR = [] ;
Pairs=[];
PP_rel = [] ;
TT_rel = [] ;
AE_rel = [] ;
DIFF_rel = [] ;
AVG_PATTERN_DUR_rel = [] ;
Pairs_rel =[];

%  mindur = 0 ;
xx = [] ;
xx_rel = [] ;


I = 0 ;
% for x = 0:  floor( mindur / 30 ):floor( mindur )
TNb = Nb ;
BurstsNumber =[] ;
Pvals = [] ;
Relative_step = 0 ;

x=0;
x_rel = 0 ;
% x_last = 0 ;
x_last = 1 ;
xstep =1 ;

if Cycle_P_val_process == 'y' 
    Show_pattern_dur_hist = 'n' ;
  
    x_last = floor( mindur / 1 ) ;
    if USE_RELATIVE_STEP == 'y'
      Relative_step = 0.05 ;
      
      xstep = round(x_last *  Relative_step ) ;
%       x_last = x_last * Relative_step ;
    else
      xstep = 50 ;
      Relative_step =  xstep / x_last  ;
    end
    
end




%   ------------  Firing rate calculation ----------
%   AmpRate = [] ;
%   T1 =  0 ;
%     T2 = xstep ;
%     asdr_i=1;
%      spikes = 0 ;    
%      delays = [] ; currstep=0;
% for x = 0: xstep : x_last  
%    
%     
%     currstep
%    delays = [ delays currstep ];
%    AmpRate = [ AmpRate 0 ];
%    
%           T1 =  x;
%              T2 = T1 + xstep ; 
% %              AmpRate( t ) = 0 ;
% %              spikes = 0 ;            
%       for t = 1 : Nb        
%         for ch = 1: N         
% %         channel_index =  index_r( : , 2 ) ==  ch   ;        
%             ss = length( find (  bursts( t , ch , :  )  >  T1 &  bursts( t , ch , :  )  <=  T2 ) ) ; 
%             spikes=spikes+ss;
%            if ss > 0 
%              AmpRate( asdr_i ) =   AmpRate( asdr_i ) + ss ;    
%            end
%        end    
%            
%       end
%       currstep = currstep + Relative_step;
%       asdr_i = asdr_i + 1 ;   
% end
%   AmpRate( : )=100* AmpRate( : )/ spikes ;
%   Spiking_rate = [ delays'   AmpRate' ] ;
% %   delays'
%   figure
%   plot(delays , AmpRate )
%   
%  eval(['save  SPIKE_RATE.mat Spiking_rate -mat']); 
%   -------------------------
  

if 1> 0   
    
    
    

  for x = 0: xstep : x_last - xstep/2
       
if x_rel + Relative_step  < 1  

    xx = [ xx x ]; 
    xx_rel = [ xx_rel x_rel ] ;
   x_rel = x_rel + Relative_step ;
   
    I = I + 1 ;
    I ;
    
    
    
    
    %------------------which part of the burst we look
%     x =  1 * round(floor( mindur / 1 )  *  0.7 ) ;
    %----------------------------------------------------
    
    x
    
    P_val = -1 ;
    T_val = -1 ;
    ActEl = 0;
    avg_pattern_duration =0;
    Not_random_pairs = 0 ;       
    motif = zeros( Nb , N ) ;
    burst = zeros( Nb , N ) ;
    burst2 = zeros( Nb , N ) ;
  
 for t = 1 : Nb 
     
rand_CH = RandomArrayN( N );                   
    
  for ch = 1 : N   
        
        if random_channel == 'y'
            channel = floor( rand()*(N-1) +1);
            channel = rand_CH( ch );
        else    
            channel = ch ; % 
        end
               
%        x = 950 ;

if FIRST_SPIKES_ANALYSIS == true
    
       ss = find( bursts( t, channel , : ) >= (round(x)) ,1 ) ;       
          if isempty( ss ) ~= 1
               motif( t ,ch ) = bursts( t , channel ,ss  ) ;
          end
else
        ss = find( bursts( t, channel , : ) > (round(x))  , 1,'last' ) ;       
          if isempty( ss ) ~= 1
               motif( t ,ch ) = bursts( t , channel ,ss  ) ;
  
%               burst( t , ch ) = index_r( ss , 1) -  burst_start( t ) ;
          end
end
                        
%         for s = 1 : k
%             burst( t , ss( k - s + 1 ) , : ) = index_r( ss( k - s + 1 ) , : ) ;
%             index_r( ss( k - s + 1 ) , : ) = [] ;
%         end
    end
%     motif( t , : ) = burst( t , : ) - min( motif( t , : ) ) ;
% %  figure
%     chh = 1:64 ;
%         plot(  motif( t , :) + burst_start( t ) , chh(:) ,'.','MarkerEdgeColor' ,[.04 .52 .78] )
%     
% %         
 end    
%  figure
%   chh = 1:64 ;
%   for t = 1 : Nb 
%        burst( t , : ) =  motif( t , : )/ (max( motif( t , : ))-min( motif( t , : ))) ;
%   end
%         plot(  burst( : , :)   , chh(:) ,'.','MarkerEdgeColor' ,[.04 .52 .78] )


if Cycle_P_val_process ~= 'y' & Pval_act_cycle ~= 'y'

  figure
  chh = 1:N ;
  for t = 1 : Nb 
       burst( t , : ) =  motif( t , : )+burst_start( t );
%        burst2( t , : ) =   motif( t , : )/ (max( motif( t , : ))-min( motif( t , : ))) ;
  end
       plot(  burst( : , :)   , chh(:) ,'.','MarkerEdgeColor' ,[.04 .52 .78] )

end    
       
       
       
%        for ch = 1 : N 
%  burst_activation_mean( ch ) = mean( burst2( : , ch ));
%        end
%        
%    Plot8x8Data( burst_activation_mean )
% xlabel( 'Electrode #' )
% ylabel( 'Electrode #' )
% title( 'Average spike timimg in burst activation' )
% colorbar ;
       
       
 
%  figure
%     chh = 1:64 ;
%     x = burst( t , :);
%     y   = burst( : , :) ;
%         plot(  burst( t , :) ,  burst( : , :),'.','MarkerEdgeColor' ,[.04 .52 .78] )
%  
    
PHASE = PHASE_ON ;
if PROCESS_BOTH_REL_AND_ABS_DIST == 'y' 
   PHASE = false ; 
end


 % - Analyse Pvals of single patterns with cycle
if Cycle_P_val_process ~= 'y' 
    
   if Pval_act_cycle == 'y'
            Show_pattern_dur_hist = 'n';
    
          for NoiseAmp=0 : 2 : 300
             S_matr_3    
             P_val
           PP= [ PP P_val ]  
          DIFF = [ DIFF DIFF_i ] ;
          NOISE_t = [ NOISE_t NoiseAmp ] 
   end
  
   else
       
      
      S_matr_3 
      P_val
      PP= [ PP P_val ]  
      DIFF = [ DIFF DIFF_i ] ;
%       dur=dur / max(dur) ;
      AVG_PATTERN_DUR = [ AVG_PATTERN_DUR dur ];
      DIFF_i
   end
end
% --------------------------------


if Cycle_P_val_process == 'y' 
     S_matr_3 ; 
     P_val
AE = [ AE ActEl ] ;
PP= [ PP P_val ] ;
Pairs = [ Pairs Not_random_pairs ];
TT= [ TT T_val ] ;
AVG_PATTERN_DUR = [ AVG_PATTERN_DUR  avg_pattern_duration ];
DIFF = [ DIFF DIFF_i ] ;
Time_shift = xx' ; 
Time_shift_relative = xx_rel'   ;

if PROCESS_BOTH_REL_AND_ABS_DIST == 'y' 
   PHASE = true ;  
    P_val = -1 ;
    T_val = -1 ;
    ActEl = 0;
    avg_pattern_duration =0;
   
   S_matr_3 ;
   
AE_rel = [ AE_rel ActEl ] ;
PP_rel= [ PP_rel P_val ] ;
Pairs_rel = [ Pairs_rel Not_random_pairs ];
TT_rel = [ TT_rel T_val ] ;
AVG_PATTERN_DUR_rel = [ AVG_PATTERN_DUR_rel  avg_pattern_duration ];
DIFF_rel = [ DIFF_rel DIFF_i ] ; 
   
   
end

end

  end
 end

%  whos AVG_PATTERN_DUR












if Cycle_P_val_process == 'y' 

Time_shift = xx' ;
% Time_shift_relative = Time_shift / mindur ;
Time_shift_relative = xx_rel'   ;

Time_shift 
P_values = PP' ;
P_values 

'Timlapse'
xx'
'Active electrodes in patterns'
AE'
'Jaccard coeff'
DIFF'
'Average pattern duration'
AVG_PATTERN_DUR'

t_AE_AVFDUR_PVAL_JACC_abs = [ xx' Time_shift_relative AE' AVG_PATTERN_DUR' P_values DIFF' ];

if PROCESS_BOTH_REL_AND_ABS_DIST == 'y' 

'Active electrodes in patterns'
AE_rel'
'Jaccard coeff'
DIFF_rel'
'Average pattern duration'
AVG_PATTERN_DUR_rel'
PP_rel' 
   t_AE_AVFDUR_PVAL_JACC_rel = [ t_AE_AVFDUR_PVAL_JACC_abs AVG_PATTERN_DUR_rel' PP_rel' DIFF_rel' ];
end

save  'pvals_Jaccards_deactivation_pattern_cycle.mat'

if SHOW_FIGURES_CYCLE == 'y'
figure
plot( xx ,AE )
title( 'Average number of Electrodes per pattern' )
figure
plot( xx ,PP )
title( 'P-value' )
figure
plot( xx, TT )
title( 'T-test value, 1-significantly different distributions' )
figure
plot( xx, DIFF )
title( 'Jaccard' )
figure
% plot( xx , Pairs )
% title( 'Number of significantly similar burst pairs' )
plot( xx , AVG_PATTERN_DUR )
title( 'Average pattern duration' )
figure
plot( xx , PP ,  xx , AE , xx , DIFF )
title( 'P-value, Active electrode, Jaccard index' )

end


end

end
