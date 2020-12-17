
function [ SpikeNum ] = Spikes_in_bursts( bursts , Nb ,T1 ,  Total_burst_len , N )

spikes_num = 0 ;
SpikeNum = [] ;
  
   
    for i=1: Nb 
         spikes_num = 0 ;
        for CHANNEL_i= 1: N                       
          ss = find(  bursts{ i }{ CHANNEL_i }  >= T1 &  bursts{ i }{ CHANNEL_i } < Total_burst_len );
             if ~isempty( ss  )
                   spikes_num = spikes_num + length(ss) ;
             end
        end
        SpikeNum = [ SpikeNum spikes_num ];
    end   