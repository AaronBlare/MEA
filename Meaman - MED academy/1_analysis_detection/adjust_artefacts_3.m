


% adjust_artefacts_3 

method_old = false ;
% method_old = true ;
Min_inter_art_sec = 0.1 ;
Min_inter_art_points = Min_inter_art_sec * sr ; 
% Min_inter_art_points =  100 ; 
DDDT = 30 ;
xaux2 = [ ] ; 
Nxx = length(xaux) ;
Xnx = length( xaux) ;
% new_art_times = zeros( Nxx , 1 ) ;
new_art_times = [ ] ;
% Nxx = 10 ; 
       for i=1: Nxx
             
            diff_a = abs( xaux(  i+1 : Xnx  ) - xaux( i ) ) ;
            d = find( diff_a < Min_inter_art_points ) ; 
            d = d + i ;
            check_is = [ i d ]  ;
            xaux(  check_is );
%             local_amps = xf_detect( xaux(  check_is ) ) ;

if method_old
         local_amps = x( xaux(  check_is ) ) ;
else
         local_amps = x_diff( xaux(  check_is ) ) ;
end
          
            [ min_amp, min_i ] = min( local_amps ) ;
            X1 = xaux( check_is( min_i ) ) - DDDT ;
            X2 =  xaux( check_is( min_i ) ) + DDDT ;
            if X1 >=1 && X2 < length( x )
                
                if method_old
                    art_sig = x( X1  : X2 );
                else
                    art_sig = x_diff( X1  : X2 );
                end
            
%             figure 
%             plot( abs( art_sig ) )

            if ARTEFACT_threshold < 0 
%                  xaux = find( x_diff <  ARTEFACT_threshold   ) ; 
                  [ ap , art_peak_i ] = min( ( art_sig )) ;
            else
                 [ ap , art_peak_i ] = max( ( art_sig )) ;
            end 
%             [ ap , art_peak_i ] = max( abs( art_sig )) ;
%             ap
            new_art_i = xaux( check_is( min_i ) ) - DDDT + art_peak_i - 1   ; 
%             ap_check = x( new_art_i ) 
%             ap_check = x( new_art_i -4 : new_art_i +4  ) 
%             new_art_i_ms = new_art_i * ( 1e3/handles.par.sr)  
%             amp_curr =   abs(  xf_detect(  xaux(  i )  ) ) ; 
         if numel ( new_art_times ) > 0 
             if   abs( xaux( i )  -  new_art_times( end)) > Min_inter_art_points   
                 new_art_times = [ new_art_times  new_art_i ] ;
             else
                ;
%                 xaux2 = [ xaux2 xaux( i )];  
             end
         else
            new_art_times =  new_art_i  ; 
         end
            end 
       end 
xaux2 = new_art_times ;

%         artefacts_ms_diff = diff(  new_art_times*( 1e3/handles.par.sr)  ) ;
%              figure   
%              plot(  artefacts_ms_diff )
                       



