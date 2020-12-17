
% Spike_detection_negative_script 
                                index = [] ;
                               
                                amps = [] ;
                                n_filtered = 0 ;

nspk = 0;
        if ( Thr_fragment == 'y' )
        xaux = find((x(ref+2:end-ref-2) < -thr ) & ...
                    (x(ref+2:end-ref-2) > -thrmax )) +ref+1 ;    
        else            
        xaux = find(x(ref+2:end-ref-2) < -thr) +ref+1;
        end
        xaux0 = 1;
        for i=1:length(xaux) - floor(ref )
             if xaux(i) >= xaux0 + ref
                [maxi iaux]=min((x(xaux(i):xaux(i)+floor(ref/2)-1)));    %introduces alignment

%                 floor(ref/2) - minimum interspike interval
                if   xaux(i) + iaux + floor(ref/2) < length( x )
                    point_beyond_thr = find(x(xaux(i) + iaux - floor(ref/2): ...
                                                  xaux(i) + iaux + floor(ref/2)) < -thr)  ;
%                     min_point_per_spike = floor( ref *0.3 * abs(thr / maxi ) );
%                     if min_point_per_spike < 1 min_point_per_spike = 1 ; end
                    min_point_per_spike = 1 ;
                    if  length( point_beyond_thr ) >= min_point_per_spike
%                         s1 = x(xaux(i) + iaux -floor(ref/2)) ;
%                         s2 = x(xaux(i) + iaux + floor(ref/2));                
                        s1 = max( x(xaux(i) + iaux -floor(ref/2) : xaux(i) + iaux  )) ;
                        s2 = max( x(xaux(i) + iaux : xaux(i) + iaux + floor(ref/2) )) ;  
                        if abs( maxi - s1) >= AMP_THR && abs( maxi - s2 ) >= AMP_THR 
                            new_spike_ok = true ; 
                            
                        s1 = min( x(xaux(i) + iaux -floor(ref/2) : xaux(i) + iaux  )) ;
                        s2 = min( x(xaux(i) + iaux : xaux(i) + iaux + floor(ref/2) )) ;  
                        
%                         if  ( maxi - s1) >= AMP_THR &&  ( maxi - s2 ) >= AMP_THR     
%                             new_spike_ok = false ;
%                         else
%                            new_spike_ok = true ; 
%                         end
                        
                        if  ( abs( maxi ) < abs( s2 ) )    
                            new_spike_ok = false ;
                        else
%                            new_spike_ok = true ; 
                        end
                        
                        if  ( abs( maxi ) < abs( s1 ) )    
                            new_spike_ok = false ;
                        else
%                            new_spike_ok = true ; 
                        end
                            
                            % if previous spike is close to new then check
                            % if its one spike
                            new_xaux = xaux(i) + iaux ;
%                             new_spike_ok = false ; 
                            
                            if new_xaux - xaux0 < 2 * ref 
                                xaux0 ;
                                new_xaux ;
                                length( x )  ;
                                separation = max( x(xaux0 : new_xaux ) ) ;
                                if separation > x(xaux0) && separation > x(new_xaux)  
                                   new_spike_ok = true ; 
                                else
%                                    spike_filtered = true ;
                                   new_spike_ok = false ;
                                   
                                end 
                            end
                            if ~new_spike_ok
                                n_filtered = n_filtered  + 1 ;
                            end
                            
%                             new_spike_ok = true ; 
                            
                            
                            if new_spike_ok
                                nspk = nspk + 1;
                                index(nspk) = iaux + xaux(i)-1 ;
                                xaux0 = index(nspk);
                                amps(nspk) = maxi ;
                            end
                        end                    
                    end
                end
            end
        end
        
        n_filtered ;
%         whos index
        
%         Plot_test_x
        