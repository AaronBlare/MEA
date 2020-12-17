% Adjust_artifact_times_script
% if artifacts were written as rounded times - 10 ms instead of 10.123
% Uses AWSR diagram for correction
   % Adjusts artifact times using 1 ms bin AWSR of raster -> finds max of
   % AWSR around each artifact time +- 1000 ms.


BIN = 1 ;
        artefacts_new = artefacts ;
         params.show_figures = false ;
         awsr = AWSR_from_index_r( index_r  , BIN  ,params  );
         awsr = awsr   ;
%          figure 
%          plot( awsr);
%          figure
%          plot( artefacts , ones( 1,length( artefacts)) , 'r*' );
         
         last_spike_time = max( index_r( : , 1 ) ) ;
         
         art_index_before_ratr_end = find( artefacts(:) >= last_spike_time + BIN*2);
         
         if ~isempty( art_index_before_ratr_end )
              artefacts( art_index_before_ratr_end(1)  : end)=[];
         end
         
         for i=1:  length( artefacts   )  
%          for i=1: 3
%             i
%             artefacts(i)
            i_1 = floor(  artefacts(i) /BIN) - 1000/BIN ;
            i_2 = floor(  artefacts(i) /BIN)  + 1000/BIN   ;
            i_1 = i_1 * H( i_1 ) + H( -i_1 );
            if i_2 > length( awsr )
                i_2 = length( awsr ) ;
            end
%             i_1
            awsr_buf = awsr( i_1 : i_2 );
%             figure 
%             plot( awsr_buf) ;
            i_1 = floor(  (artefacts(i)  - 1000)/BIN);
            i_2 = floor(  (artefacts(i)  + 1000)/BIN)  ;
            i_1 = i_1 * H( i_1 ) + H( -i_1 );
             if i_2 > length( awsr )
                i_2 = length( awsr ) ;
            end
            [max_awsr , max_awsr_i ]=max(awsr( i_1  ...
                    :i_2 ) ) ;
            new_artefact= floor(artefacts(i))  - 1000 ;
            new_artefact = new_artefact * H( new_artefact ) + H( -new_artefact );
            new_artefact=  new_artefact  + (max_awsr_i-1) * BIN; 
            artefacts_new( i ) = new_artefact ;
%             artefacts(i);
         end
        artefacts = artefacts_new  ;