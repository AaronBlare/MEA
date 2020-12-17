% Distance_in_motif_raster_1


filename2 = 0 ;
random_channel = 'n' ;
PHASE_ON ;

one_burst_part_at_all = 'n' ;
Show_pattern_dur_hist = 'n';
one_burst_from = 2000 ;
one_burst_to = 2300 ;

cd( pathname ) ; 
% index_r = load( char( filename ) ) ;
load( char( filename ) ) ;
motif = burst_activation ;
N = 64 ;
% Tmax = max( index_r( : , 1 ) ) ;


% if filename2 ~= 0 
% cd( pathname2 ) ; 
% % index_r2 = load( char( filename2 ) ) ;
% N = 64 ;
% % Tmax2 = max( index_r2( : , 1 ) ) ;
% else
% %     burst_start2 = burst_start  ;
% % burst_max2 = burst_max  ;
% % burst_end2 = burst_end   ;
% %     index_r2 = index_r ;
% end

% Nstart = 15 ;
% burst_start( 1 : Nstart ) = [];
% burst_max( 1 : Nstart   )  = [];
% burst_end( 1 : Nstart  )  = [];

% burst_start( 1: end - Nstart  ) = [];
% burst_max( 1: end - Nstart )  = [];
% burst_end( 1: end - Nstart )  = [];
% Nb = length( burst_start ) ;

% burst_start = burst_start + 100 ;


siz = size( motif) ;
Nb = siz(1);
% Nb
N = siz(2);
% Nb = length( burst_start ) ;         % Number of bursts
% Nb2 = length( burst_start2 ) ;         % Number of bursts

% mmnn = mean(burst_max( : ) - burst_start(:) ) ;
% mindur = 1*mean(burst_end( : ) - burst_start(:) ) ;
% mmnn2 = mean(burst_max2( : ) - burst_start2(:) ) ;
% mindur2 = 1*mean(burst_end2( : ) - burst_start2(:) ) ;
% 





xx = [] ;
I = 0 ;
x=0;
x_last = 0 ;

% if Cycle_P_val_process == 'y' 
%     Show_pattern_dur_hist = 'n' ;
%     x_last = floor( mindur / 1 ) ;
% end


  for x = 0: 10 : x_last


    xx = [ xx x ];
    I = I + 1 ;
    I;
     
% 
% motif = zeros( Nb , N ) ;
% motif2 = zeros( Nb2 , N ) ;
% burst = zeros( Nb , N ) ;
% 
% for t = 1 : Nb
% %     x = 0 ; % rand() * mmnn ;  
% rand_CH = RandomArrayN( N );                   
%     
%   for ch = 1 : N           
%         if random_channel == 'y'
% %             channel = floor( rand()*(N-1) +1);
%             channel = rand_CH( ch );
%         else    
%             channel = ch ; % 
%         end
%                
%         if one_burst_part_at_all == 'y'
%             if round(x) > one_burst_from && round(x) <= one_burst_to        
%                    ss = find( index_r( : , 1 ) >= burst_start( 1 ) + round(x) & ...            
%                    index_r( : , 1 ) < burst_end( 1 ) & index_r( : , 2 ) == channel , 1 ) ;       
%                if isempty( ss ) ~= 1
%                   motif( t , ch ) = index_r( ss , 1 )  - burst_start( 1 );  
% %                   burst( t , ch ) = index_r( ss , 1)* 20-  burst_start( 1 )*20;
%                end 
%             else
%                   ss = find( index_r( : , 1 ) >= burst_start( t ) + round(x) & ...            
%                   index_r( : , 1 ) < burst_end( t ) & index_r( : , 2 ) == rand_CH( ch ) , 1 ) ;       
%                 if isempty( ss ) ~= 1
%                    motif( t , ch ) = index_r( ss , 1 )  -  burst_start( t ); 
% %                    burst( t , ch ) = index_r( ss , 1)* 20-  burst_start( t )*20;
%                end 
%             end    
%         else
%                 
%         ss = find( index_r( : , 1 ) >= (burst_start( t ) + round(x)) & ...            
%             index_r( : , 1 ) < burst_end( t ) & index_r( : , 2 ) == channel , 1 ) ;       
%           if isempty( ss ) ~= 1
%               motif( t , ch ) = index_r( ss , 1 )  -  ( burst_start( t )  + round(x) );
% %               burst( t , ch ) = index_r( ss , 1)* 20-  burst_start( t )*20;
%           end
%         
%         end
%                 
%         
% %         for s = 1 : k
% %             burst( t , ss( k - s + 1 ) , : ) = index_r( ss( k - s + 1 ) , : ) ;
% %             index_r( ss( k - s + 1 ) , : ) = [] ;
% %         end
%     end
% %     motif( t , : ) = burst( t , : ) - min( motif( t , : ) ) ;
% % 
% %     figure
% %     chh = 1:64 ;
% %         plot(  motif( t , :) , chh(:) ,'.','MarkerEdgeColor' ,[.04 .52 .78] )
% % %         
% 
% end
% 
% % /////////////////////////// 2nd set
% for t = 1 : Nb2
% %     x = 0 ; % rand() * mmnn ;  
% rand_CH = RandomArrayN( N );                   
%     
%   for ch = 1 : N   
%         
%         if random_channel == 'y'
% %             channel = floor( rand()*(N-1) +1);
%             channel = rand_CH( ch );
%         else    
%             channel = ch ; % 
%         end
%                
%         if one_burst_part_at_all == 'y'
%             if round(x) > one_burst_from && round(x) <= one_burst_to        
%                    ss = find( index_r( : , 1 ) >= burst_start( 1 ) + round(x) & ...            
%                    index_r( : , 1 ) < burst_end( 1 ) & index_r( : , 2 ) == channel , 1 ) ;       
%                if isempty( ss ) ~= 1
%                   motif( t , ch ) = index_r( ss , 1 )  - burst_start( 1 );  
% %                   burst( t , ch ) = index_r( ss , 1)* 20-  burst_start( 1 )*20;
%                end 
%             else
%                   ss = find( index_r( : , 1 ) >= burst_start( t ) + round(x) & ...            
%                   index_r( : , 1 ) < burst_end( t ) & index_r( : , 2 ) == rand_CH( ch ) , 1 ) ;       
%                 if isempty( ss ) ~= 1
%                    motif( t , ch ) = index_r( ss , 1 )  -  burst_start( t ); 
% %                    burst( t , ch ) = index_r( ss , 1)* 20-  burst_start( t )*20;
%                end 
%             end    
%         else
%                 
%         ss = find( index_r2( : , 1 ) >= (burst_start2( t ) + round(x)) & ...            
%             index_r2( : , 1 ) < burst_end2( t ) & index_r2( : , 2 ) == channel , 1 ) ;       
%           if isempty( ss ) ~= 1
%               motif2( t , ch ) = index_r2( ss , 1 )  -  ( burst_start2( t )  + round(x) );
% %               burst( t , ch ) = index_r( ss , 1)* 20-  burst_start( t )*20;
%           end
%         
%         end
%                         
% %         for s = 1 : k
% %             burst( t , ss( k - s + 1 ) , : ) = index_r( ss( k - s + 1 ) , : ) ;
% %             index_r( ss( k - s + 1 ) , : ) = [] ;
% %         end
%     end
% %     motif( t , : ) = burst( t , : ) - min( motif( t , : ) ) ;
% % 
% %     figure
% %     chh = 1:64 ;
% %         plot(  motif( t , :) , chh(:) ,'.','MarkerEdgeColor' ,[.04 .52 .78] )
% % %         
% end
% 



mR_difference_arr = [] ;
R1s = [];
R2s = [];
R3s =[] ;R4s =[] ;
ix = [];
Nb2 = Nb ;

% nbursts = 2 ;
n11 = 1 ; n12 = 1 + nbursts ;
for n21 = 1 :1: Nb2 - 1*nbursts - 1
% for n21 = Nb2 - nbursts - 1 :-1: 1
[P_val1 ,P_val2 , P_val_cross,P_val_surr_cross, mR_difference,R1,R2,R3,R4 ] = Two_sets_compare_similarity( ...
           motif , motif , n11 , n12 - 1 , n21 , n21 + 1*nbursts - 1, 'n' , PHASE_ON , ADJUST_SPIKES );
mR_difference_arr = [ mR_difference_arr mR_difference ] ;
R1s = [ R1s R1 ];R2s = [ R2s R2 ];R3s = [ R3s R3 ];R4s = [ R4s R4 ];
ix = [ ix burst_start(n21) /1000  ];
end
figure
plot( ix , mR_difference_arr )
figure
% plot(ix , R1s , ix , R2s , ix , R3s , ix , R4s )
plot(ix , R1s ,   ix , R3s )
title( 'Pattern distance to center mass' )
% set(gca,'FontSize',20)
% [P_val1 ,P_val2 , P_val_cross,P_val_surr_cross, mR_difference,R1,R2,R3 ] = Two_sets_compare_similarity( ...
%            motif , motif , 1 , round( Nb*0.1 )-1, Nb - round(Nb*0.1) , Nb , 'y' , true );   
% [P_val1 ,P_val2 , P_val_cross,P_val_surr_cross, mR_difference,R1,R2,R3 ] = Two_sets_compare_similarity( ...
%            motif , motif , 15, 20 , 35 , 40 , 'y' , PHASE_ON );
% title( 'first 10% of bursts VS last 10%' )

  end

