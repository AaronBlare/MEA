% Def_bursts2



random_channel = 'n' ;
one_burst_part_at_all = 'n' ;

% Cycle_P_val_process = 'n' ; % !!!!!!!!!!!!this value should be defined before this
% code
Show_pattern_dur_hist = 'y';

one_burst_from = 2000 ;
one_burst_to = 2300 ;

index_r = load( char( filename ) ) ;
N = 64 ;
Tmax = max( index_r( : , 1 ) ) ;




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


Nb = length( burst_start ) ;         % Number of bursts

mmnn = mean(burst_max( : ) - burst_start(:) ) ;
mindur = 1*mean(burst_end( : ) - burst_start(:) ) ;

motif = zeros( Nb , N ) ;
burst = zeros( Nb , N ) ;
P_val = -1 ;
x = 0 ;
PP = [] ;
TT = [] ;
AE = [] ;
AVG_PATTERN_DUR = [] ;
Pairs=[];

%  mindur = 0 ;
xx = [] ;


I = 0 ;
% for x = 0:  floor( mindur / 30 ):floor( mindur )
TNb = Nb ;
BurstsNumber =[] ;
Pvals = [] ;

% for Nb = 3 : TNb 
% 
%     BurstsNumber = [ BurstsNumber Nb ];
% Nb

x=0;
x_last = 0 ;

if Cycle_P_val_process == 'y' 
    Show_pattern_dur_hist = 'n' ;
    x_last = floor( mindur / 1 ) ;
end


  for x = 0: 10 : x_last


    xx = [ xx x ];
    I = I + 1 ;
    I;
    
    
    P_val = -1 ;
    T_val = -1 ;
    ActEl = 0;
    avg_pattern_duration =0;
    Not_random_pairs = 0 ;   
    motif = zeros( Nb , N ) ;
for t = 1 : Nb
    x = 0 ;
%     x = rand() * mmnn ;  
        

    rand_CH = RandomArrayN( N );                    
    
  for ch = 1 : N   

        
        if random_channel == 'y'
%             channel = floor( rand()*(N-1) +1);
            channel = rand_CH( ch );
        else    
            channel = ch ; % 
        end
%                x = 800 ;
        if one_burst_part_at_all == 'y'
            if round(x) > one_burst_from && round(x) <= one_burst_to        
                   ss = find( index_r( : , 1 ) >= burst_start( 1 ) + round(x) & ...            
                   index_r( : , 1 ) < burst_end( 1 ) & index_r( : , 2 ) == channel , 1 ) ;       
               if isempty( ss ) ~= 1
                  motif( t , ch ) = index_r( ss , 1 )  - burst_start( 1 );  
%                   burst( t , ch ) = index_r( ss , 1)* 20-  burst_start( 1 )*20;
               end 
            else
                  ss = find( index_r( : , 1 ) >= burst_start( t ) + round(x) & ...            
                  index_r( : , 1 ) < burst_end( t ) & index_r( : , 2 ) == rand_CH( ch ) , 1 ) ;       
                if isempty( ss ) ~= 1
                   motif( t , ch ) = index_r( ss , 1 )  -  burst_start( t ); 
%                    burst( t , ch ) = index_r( ss , 1)* 20-  burst_start( t )*20;
               end 
            end    
        else
                
        ss = find( index_r( : , 1 ) >= (burst_start( t ) + round(x)) & ...            
            index_r( : , 1 ) < burst_end( t ) & index_r( : , 2 ) == channel , 1 ) ;       
          if isempty( ss ) ~= 1
              motif( t , ch ) = index_r( ss , 1 )  -  ( burst_start( t )  + round(x) );
%               burst( t , ch ) = index_r( ss , 1)* 20-  burst_start( t )*20;
          end
        
        end
                
        
%         for s = 1 : k
%             burst( t , ss( k - s + 1 ) , : ) = index_r( ss( k - s + 1 ) , : ) ;
%             index_r( ss( k - s + 1 ) , : ) = [] ;
%         end
    end
%     motif( t , : ) = burst( t , : ) - min( motif( t , : ) ) ;
% 
%     figure
%     chh = 1:64 ;
%         plot(  motif( t , :) , chh(:) ,'.','MarkerEdgeColor' ,[.04 .52 .78] )
% %         

end

PHASE = PHASE_ON ;

S_matr_3 ;

P_val



AE = [ AE ActEl ] ;
PP= [ PP P_val ] ;
Pairs = [ Pairs Not_random_pairs ];
TT= [ TT T_val ] ;
AVG_PATTERN_DUR = [ AVG_PATTERN_DUR  avg_pattern_duration ];




 end

%  whos AVG_PATTERN_DUR

if Cycle_P_val_process == 'y' 

Time_shift = xx' ;
Time_shift 
P_values = PP' ;
P_values 

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
% plot( xx , Pairs )
% title( 'Number of significantly similar burst pairs' )
plot( xx , AVG_PATTERN_DUR )
title( 'Average pattern duration' )




end

% save motif00

% end

% BurstsNumber'
% PP'
% figure
% plot( BurstsNumber , TT )
% title( 'T-test value, 1-significantly different distributions' )
% figure
% plot( BurstsNumber ,PP )
% 
% 
% title( 'P-value vs Number of bursts' )
