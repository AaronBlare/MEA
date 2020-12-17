
% test delay between each event in set 1 (E1) with max lag of max_lag
function [ Edelays , AB_index ] = Events_2sets_delays_old( E1 ,E1_d , E2 ,E2_d ,  max_lag )
% E1 = starts of the events set 1
% E2 = starts of the events set 2
% Edelays - delay between each E1 and E2 

One_burst_evoke_only_one = true ;

Edelays =[]; 
last = E1(end) ;
AB_index = [] ;

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
              
              if delay > 0
              delays_buf_pos  = [ delays_buf_pos  delay ] ;
              delays_buf_pos_js = [ delays_buf_pos_js j ] ;
              end
              
              if delay < 0
              delays_buf_neg  = [ delays_buf_neg  delay ] ;
              delays_buf_neg_js = [ delays_buf_neg_js j ] ;
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
           [ min_delay , min_j ] = min( delays_buf_pos ); 
           min_delay_j = delays_buf_pos_js( min_j) ; 
           if ~isempty( min_delay_j )
          Edelays = [ Edelays min_delay ] ;     
          AB_index = [ AB_index ; i min_delay_j] ;             
           end

% if  ~isempty( delays_buf_pos )
% Edelays = [ Edelays delays_buf_pos ] ;   
%     for g = 1 : length( delays_buf_pos_js )
%     AB_index = [ AB_index ; i delays_buf_pos_js(g) ] ;   
%     end
% end

          % B -> A 
          [ min_delay , min_j ] = max( delays_buf_neg ); 
           min_delay_j = delays_buf_neg_js( min_j) ; 
           if ~isempty( min_delay_j )
          Edelays = [ Edelays min_delay ] ;     
          AB_index = [ AB_index ; i min_delay_j] ; 
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
 
% Edelays( abs( Edelays  )> max_lag ) = [] ;
% Edelays( Edelays ==0 ) = [] ;
