% Find_artifact_times_from_raster_script 
   % Find artifact times using 1 ms bin AWSR of raster  
   % output: artefacts

BIN = 1 ;
Min_inter_artifact_time_ms = 100 ;

         artefacts_new = artefacts ;
         params.show_figures = false ;
         AWSR = AWSR_from_index_r( index_r  , BIN  ,params  );
         AWSR_0 = AWSR   ;
%          figure 
%          plot( AWSR);
%          figure
%          plot( artefacts , ones( 1,length( artefacts)) , 'r*' );
         
         last_spike_time = max( index_r( : , 1 ) ) ;
         
%          GLOBAL_CONSTANTS_load  
         
         max_awsr = max( AWSR ) ;
         Threshold = max_awsr * ( GLOBAL_const.Artifact_threshold_from_max / 100 );
         
%          index = find( AWSR(:) <= Threshold ) ;
         AWSR( AWSR(:) <= Threshold ) = 0 ;

            nspk = 0 ;
            index = [] ;
            index_max = [] ;
            index_end = [] ; 
            Nt = length( AWSR ) ;
            for t = 1 : Nt - 1

                if (( AWSR( t ) == 0 )&&( AWSR( t+1 ) > 0  ))
                    do_next = true ;
                     
                    if nspk > 0 
                    if  t - index_max( nspk ) < Min_inter_artifact_time_ms
                       do_next = false ;
                    end
                    end
                    
                    if do_next
                     nspk = nspk + 1 ;
                     index(nspk) = t  ;
                       s = find(  AWSR( t+1:end ) == 0 );
                       if length(s) > 0
                       right = s(1) + t  ;
                       else
                        right = Nt ;   
                       end 
                       index_end(nspk) = right ;
                       [maxi iaux]=max(  AWSR( t : right ) ); 
                       index_max(nspk) = iaux(1) + t - 1 ; 
                    end
                end
          end

           
        artefacts = index_max  ;
        
         figure 
         hold on
         plot( AWSR_0 , 'g' )
         plot( AWSR); 
         plot( artefacts , max(AWSR) * ones( 1,length( artefacts)) , 'r*' );
         legend( 'Spikerate original' , 'filtered' , 'artifacts' )
         hold off
        
        
        
        
        
        