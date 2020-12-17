
% Spike_detection_negative_script_simple

nspk = 0;
        if ( Thr_fragment == 'y' )
        xaux = find((xf_detect(ref+2:end-ref-2) < -thr ) & ...
                    (xf_detect(ref+2:end-ref-2) > -thrmax )) +ref+1 ;    
        else            
        xaux = find(xf_detect(ref+2:end-ref-2) < -thr) +ref+1;
        end
        xaux0 = 0;
        for i=1:length(xaux) - floor(ref )
             if xaux(i) >= xaux0 + ref
                [maxi iaux]=min((xf_detect(xaux(i):xaux(i)+floor(ref/2)-1)));    %introduces alignment

%                 floor(ref/2) - minimum interspike interval
                if   xaux(i) + iaux + floor(ref/2) < length( xf_detect )
            
                            nspk = nspk + 1;
                            index(nspk) = iaux + xaux(i)-1 ;
                            xaux0 = index(nspk);
                            amps(nspk) = maxi ;
                 
                end
            end
        end
        
        