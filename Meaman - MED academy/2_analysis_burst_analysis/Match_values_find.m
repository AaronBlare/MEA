function [ found_match ,mistakes,min_error] = Match_values_find( artefacts, Start_t  , end_t , CHANNEL_examined , Test_responses ,bursts)

mistakes_can_be_done = 0  ;

   found_match = false ;
   num_poststim_spikes_on_electrode = zeros( length(artefacts) ,1 );
   
    for i=1:  length( artefacts   )  
       index_after_art = find(  Start_t <= bursts(i,CHANNEL_examined,:) &  ...
                                      end_t >= bursts(i,CHANNEL_examined,:)   );
       if ~isempty( index_after_art  ) 
           num_poststim_spikes_on_electrode( i) = length( index_after_art ); 
       else 
           num_poststim_spikes_on_electrode( i) = 0 ; 
       end
    end
    mistakes =0 ;
%     xt = find( num_poststim_spikes_on_electrode == Test_responses(1) );
%     if ~isempty( xt  )
optimamp =0;
      min_error = 10000;
for xt = 1 :  length( num_poststim_spikes_on_electrode ) - length( Test_responses )
    if length( num_poststim_spikes_on_electrode ) - xt(1) + 1 >= length( Test_responses )
        match = true ;
       for ti = 1 : length( Test_responses )
           if num_poststim_spikes_on_electrode( xt(1) - 1 + ti) ~= Test_responses(ti)
               match= false ;
               mistakes=mistakes+1;
               mistake_in_which_element =ti;
%                mistake_in_which_element
           end
       end
       if match == true
           found_match = true ;
       end
       if mistakes <= mistakes_can_be_done 
           mistakes
            found_match = true ;
       end
        if min_error > mistakes 
           min_error=mistakes;
       end
    end    
end