
% Detect_art
if  Artefacts_find
    
   RUNTIME_Artefact_detecting_now = 1 
    
 %_=+++++++++++++++++++++++++++++++++++   
 %_=+++++++++++++++++++++++++++++++++++
 %_=+++++++++++++++++++++++++++++++++++
   Automatic_artefacts_scan_adjust  
%    Automatic_artefacts_scan_adjust_old
   
   
   
%_=+++++++++++++++++++++++++++++++++++
%_=+++++++++++++++++++++++++++++++++++\
%_=+++++++++++++++++++++++++++++++++++
    
 else
     if  Artefacts_find
         artefact_amps =  [] ;
         
        if ARTEFACT_threshold > 0 
            xaux = find( x(1:end- Dat  ) > ARTEFACT_threshold   ) ; 
            
        else
            xaux = find( x(1:end- Dat  ) <  ARTEFACT_threshold   ) ; 
        end 

%         xaux = find( xf_detect(1:end- Dat  ) > ARTEFACT_threshold   ) ; 
%         xaux = find( xf_detect(1:end- Dat  ) < -ARTEFACT_threshold   ) ; 
         
        
        if ~isempty( xaux )
        xaux2= xaux( 1 )  ;
        for i=2:length(xaux)
%            if   xaux( i )  -   xaux( i - 1 )  >= Dat*3
%                xaux2 = [ xaux2 xaux( i )];
%            end
           if   xaux( i )  -   xaux( i - 1 )  <= Dat*3
               if length( xaux2 ) > 1
                    xaux2( end  ) = [] ;
                    xaux2 = [ xaux2 xaux( i )];
               else
                  xaux2 = []; 
                  xaux2 =  xaux( i ) ;
               end
               
           else
              xaux2 = [ xaux2 xaux( i )]; 
           end
        end
        xaux=xaux2;
        end
%         whos xaux
        xaux0 = 0;
        for i=1:length(xaux)
            
          if ARTEFACT_threshold > 0 
                 
            if xaux(i) >= xaux0 + Dat
%              if xaux(i)<= xaux0 - Dat 
                [maxi iaux]=max( x(xaux(i):xaux(i)+floor( Dat )-1)  );    %introduces alignment 
                    nart = nart + 1;
                    artefacts(nart) = iaux + xaux(i)-1 ;
%                     artefact_amps(nart) = xf_detect( artefacts(nart) ) ;
                    xaux0 = artefacts(nart); 
            end  
            
          else                 
                  if xaux(i) <= xaux0 + Dat 
                   [maxi iaux]=min( x(xaux(i):xaux(i)+floor( Dat )-1)  );    %introduces alignment 
                    nart = nart + 1;
                    artefacts(nart) = iaux + xaux(i)-1 ;
%                     artefact_amps(nart) = xf_detect( artefacts(nart) ) ;
                    xaux0 = artefacts(nart); 
                  end
           end
        end
        artefact_amps  = x( artefacts ) ;
     end
end
    


%    if  Artefacts_find
     

 
%  if Show_any_figures
    figure
    
  hold on
        
    plot( x_diff ) ;
    
      artefact_amps_dff =  x_diff( artefacts ) ;  
      
      tx = 1:length( x_diff );   
      
 
     if  ~handles.plot_multiple_signals % analyzing only one channel
     
    if length( artefacts )> 0
          plot(  artefacts , artefact_amps_dff * 1  , 'gv' )
    end 
    plot(  [ 0 length( tx ) ] , [ ARTEFACT_threshold ARTEFACT_threshold ] , 'g--'   )
    
    hold off
    ylabel( 'signal derrivative [ mV ]')
    
    Thr_from = collect_sigma_from ;
    Thr_To =  collect_sigma_to ;
    if Thr_To > 0  
        whos artefacts
    artefacts = artefacts(  artefacts > collect_sigma_from );
    artefacts = artefacts(  artefacts < collect_sigma_to );
    whos artefacts
    end
     end
 
%  end
 
 
 artefacts ;
 
  artefact_amps  = x( artefacts ) ;  
    
 


