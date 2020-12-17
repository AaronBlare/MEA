
% Returns RSvalues - response to stimulus factor - how many responses
% followed by stimulus, Data - bursts (3d matrix) or pattern activations
% (2d matrix)
function [ RS_values  SpikesNum SpikesFreq RS_current ]  = Get_RS_Values(  N, Data1 , ...
            Start_t,Pattern_length_ms, artefacts , Max_pause_for_RSreset_ms , Nb , is_BINARY_RESPONSE )
% RS_values - total RS values at all stimuli
% SpikesNum - number of spikes after each stimuli on each electrode
% SpikesFreq - same as SpikesNum but devided on time interval (spikes/ms)
% RS_current - RS values for each response

MIN_RATE_PER_RESPONSE_per_electrode = 2 ;
 


s = size( size(Data1 )) ;
DIM = s(2) ;

RS_values=zeros(N,1);
RS_window= 10 ;
 
SpikesNum = zeros( Nb , N  );
SpikesFreq =  zeros( Nb , N  );
RS_current = zeros( Nb , N  );



for ch = 1 : N             
 First_stim_after_pause = 0 ;
Curr_stim_after_reset = 0 ;


    ch_r =0 ;
    for t = 1 : Nb    
        if DIM == 3
           if t>1
               if ~isempty( artefacts )    
                       if  artefacts( t ) - artefacts( t-1) >Max_pause_for_RSreset_ms
                           First_stim_after_pause = t ;
                           First_stim_after_pause ;
                       end
               end
           end
            
           si = find( Data1{ t }{ ch } >= Start_t & Data1{ t }{ ch } < Pattern_length_ms +Start_t ) ;
           rate =length( si ) ;if isempty(  rate  )  rate= 0 ;end
           
           if is_BINARY_RESPONSE
             ch_r = ch_r + H(  rate-MIN_RATE_PER_RESPONSE_per_electrode+1 ); 
           else
             ch_r = ch_r + rate ; 
           end
           
           SpikesNum( t , ch )= rate ;
           
           if First_stim_after_pause > 0
               Curr_stim_after_reset = t - First_stim_after_pause + 1;
%                Curr_stim_after_reset
           end
               
           if Curr_stim_after_reset >0
             
               if Curr_stim_after_reset < RS_window
                  RS_current( t , ch ) = sum( SpikesNum( First_stim_after_pause : t  , ch ))/RS_window  ; 
               else
                  RS_current( t , ch ) = sum( SpikesNum( t-RS_window + 1 : t  , ch ))/RS_window  ;
               end
             
           else           
               if t < RS_window
                  RS_current( t , ch ) = sum( SpikesNum( 1:t , ch ))/RS_window ;
               else
                  RS_current( t , ch ) = sum( SpikesNum( t-RS_window + 1 : t  , ch ))/RS_window  ;
               end
           end
           
        else 
            if   Data1{ t }{ ch }>= Start_t && Data1{ t }{ ch }<= Pattern_length_ms +Start_t    
               ch_r = ch_r + 1 ;
            end
        end
          
    end
    
    RS_values(ch)=ch_r/Nb ;
    
end

SpikesFreq = SpikesNum / ( Pattern_length_ms - Start_t );