
% test delay between each event in set 1 (E1) with max lag of max_lag
function [ Edelays , AB_index ] = Events_2sets_delays2( E1 ,E1_d , E2 ,E2_d ,  max_lag )
% E1 = starts of the events set 1
% E2 = starts of the events set 2
% Edelays - delay between each E1 and E2 

% Test sequence 
% E1 = [ 2 10 20 30 ];
% E2 = [ 1 50 13 23 33 ];
% E_dur = 3 ;
% E1_d = E1 ;
% E2_d = E2 ;
% E1_d( :) = E_dur ; 
% E2_d( :) = E_dur ; 
% max_lag = 4 ; 
% 
% 
% [ Edelays , AB_index ] = Events_2sets_delays( E1 ,E1_d , E2 ,E2_d ,  max_lag )

% Result :
% AB_index = [ 1 1 ; 2 3 ; 3 4 ; 4 5 ]

One_burst_evoke_only_one = true ;

Edelays =[]; 
last = E1(end) ;
AB_index = [] ;

AB_index_pos = [] ; % fro A > B transfer
Edelays_pos = []; 
AB_index_neg = [] ; % fro B > A transfer
Edelays_neg = []; 

for i = 1 : length( E1 )
                 
%     found_rand_place = false ;
     delay_neg_found = false ;
     delay_pos_found = false ;
     delays_buf_pos   = [] ;
     delays_buf_pos_js = [] ; 
     delays_buf_neg   = [] ;
     delays_buf_neg_js = [] ;
     
     for j = 1 : length( E2 )
        delay = E2( j) - E1(i) ;
%         append_burst_pair = false ;
        
        if One_burst_evoke_only_one
          
          if abs( delay  )< max_lag && abs( delay  ) > 0
              
    % [ A > B ] - delay > 0 = E1(i) < E2( j)
              if delay > 0 
                  if E1(i) + E1_d(i) >= E2( j) % Aend < Bstart 
                      delays_buf_pos  = [ delays_buf_pos  delay ] ; % delays_buf_pos = [ delays ] for each j to current i 
                      delays_buf_pos_js = [ delays_buf_pos_js j ] ; % delays_buf_pos_js = all j's for current i
                      delays_buf_pos;
                  end
              end
              
     % [ B > A ] - delay < 0 = E2( j) < E1(i)          
              if delay < 0
                  if E2(j) + E2_d(j) >= E1( i) % Bend < Astart 
                      delays_buf_neg  = [ delays_buf_neg  delay ] ; % delays_buf_neg = [ delays ] for each j to current i 
                      delays_buf_neg_js = [ delays_buf_neg_js j ] ; % delays_buf_neg_js = all j's for current i
                      delays_buf_neg;
                  end
              end
              
%               if delay > 0 && ~delay_pos_found % A->B
%                  if E1(i) + E1_d(i) < E2( j) % Aend < Bstart 
%                     delay_pos_found = true ; 
%                     Edelays = [ Edelays delay ] ;          
%                     AB_index = [ AB_index ; i j ] ;
%                  end   
%               else
%                   if  delay < 0 && ~delay_neg_found % B->A
%                       if E2(j) + E2_d(j) < E1( i) % Bend < Astart 
%                         delay_neg_found = true ; 
%                         Edelays = [ Edelays delay ] ;          
%                         AB_index = [ AB_index ; i j ] ;
%                      end  
%                       
%                   end
%               end
              
              
%               delays_buf_pos = [ delays_buf_pos delay ] ;     
          end     
            
        else
            if abs( delay  )< max_lag && abs( delay  ) > 0
                
                    Edelays = [ Edelays delay ] ;          
                    AB_index = [ AB_index ; i j ] ;
                
            end
        end
     end
     
       if One_burst_evoke_only_one
           
          % A -> B 
          % delays_buf_pos = [ delays ] for each j to current i
          % delays_buf_pos_js = all j's for current i
           [ min_delay , min_j ] = min( delays_buf_pos );  
           min_delay_j = delays_buf_pos_js( min_j) ; % min_delay_j - current j which is closer ot i 
           if ~isempty( min_delay_j )
               ff = [] ; 
               
               if ~isempty( AB_index_pos )
               prev_foind_j_all  = AB_index_pos( : , 2 ) ;               
               ff =find( prev_foind_j_all == min_delay_j ) ;
               end
               % if previously j-th bursts was not added
               if isempty( ff ) 
%                    i - current A burst
%                    min_delay_j = j - current B burst that was found A->B
%                   if E1(i) + E1_d(i) < E2( min_delay_j) % Aend < Bstart 
                      Edelays_pos = [ Edelays_pos min_delay ] ;     
                      AB_index_pos = [ AB_index_pos ; i min_delay_j] ; 
%                   end
               end
           end
 

          % B -> A  ( delays_buf_neg - all negative delays - B>A
          % delays_buf_neg = [ delays ] for each j to current i 
          % delays_buf_neg_js = all j's for current i
          [ min_delay , closest_j ] = max( delays_buf_neg ); 
           min_delay_j = delays_buf_neg_js( closest_j) ; 
           if ~isempty( min_delay_j )
                ff = [] ; 
                
                if ~isempty( AB_index_neg )
                   prev_foind_j_all  = AB_index_neg( : , 2 ) ;               
                   ff =find( prev_foind_j_all == min_delay_j ) ;
               end
               % if previously i-th bursts was not added
                if isempty( ff )
                    
%                       i - current A burst
%                    min_delay_j = j - current B burst that B->A
%                   if E2( min_delay_j ) + E2_d( min_delay_j ) < E1( i) % Bend < Astart 
                      Edelays_neg = [ Edelays_neg min_delay ] ;     
                      AB_index_neg = [ AB_index_neg ; i min_delay_j] ; 
%                   end
                end
           end
% if  ~isempty( delays_buf_neg )
% Edelays = [ Edelays delays_buf_neg ] ;  
%     for g = 1 : length( delays_buf_neg_js )
%     AB_index = [ AB_index ; i delays_buf_neg_js(g) ] ;   
%     end               
% end
       else
           
           
       end
                    
end

AB_index =  [AB_index_pos ; AB_index_neg ];
Edelays =  [Edelays_pos   Edelays_neg ];





 
% Edelays( abs( Edelays  )> max_lag ) = [] ;
% Edelays( Edelays ==0 ) = [] ;
