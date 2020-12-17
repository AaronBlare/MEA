
% Spike_detection_positive_script

nspk = 0;
        if ( Thr_fragment == 'y' )
        xaux = find((xf_detect(ref+2:end-ref-2) > thr ) & ...
                    (xf_detect(ref+2:end-ref-2) < thrmax )) +ref+1 ;    
        else            
        xaux = find(xf_detect(ref+2:end-ref-2) > thr) +ref+1;
        end
        xaux0 = 0;
        for i=1:length(xaux) - floor(ref )
             if xaux(i) >= xaux0 + ref
                [maxi iaux]=max((xf_detect(xaux(i):xaux(i)+floor(ref/2)-1)));    %introduces alignment

%                 floor(ref/2) - minimum interspike interval
                if   xaux(i) + iaux + floor(ref/2) < length( xf_detect )
                    point_beyond_thr = find(xf_detect(xaux(i) + iaux - floor(ref/2): ...
                                                  xaux(i) + iaux + floor(ref/2)) > thr)  ;
%                     min_point_per_spike = floor( ref *0.3 * abs(thr / maxi ) );
%                     if min_point_per_spike < 1 min_point_per_spike = 1 ; end
                    min_point_per_spike = 1 ;
                    if  length( point_beyond_thr ) >= min_point_per_spike
%                         s1 = xf_detect(xaux(i) + iaux -floor(ref/2)) ;
%                         s2 = xf_detect(xaux(i) + iaux + floor(ref/2));                
                        s1 = min( xf_detect(xaux(i) + iaux -floor(ref/2) : xaux(i) + iaux  )) ;
                        s2 = min( xf_detect(xaux(i) + iaux : xaux(i) + iaux + floor(ref/2) )) ;  
                        if abs( maxi - s1) >= AMP_THR && abs( maxi - s2 ) >= AMP_THR 
                            nspk = nspk + 1;
                            index(nspk) = iaux + xaux(i)-1 ;
                            xaux0 = index(nspk);
                            amps(nspk) = maxi ;
                        end                    
                    end
                end
            end
        end