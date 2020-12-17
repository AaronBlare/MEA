
function [psth_dx , psth , psth_norm ] = PSTH_calc_channel( bursts , Nb , PSTH_bin , Total_burst_len , N , CHANNEL_i)

spikes_num = 0 ;
 PSTH_bin =5 ;
 psth_dx =[] ;
 psth = [];
  psth_sum_i =  [];
  BINS = floor( ( Total_burst_len )/ PSTH_bin );
%   psth_ALL_CHANNELS = zeros( N , BINS  );
 
  curr_bin = 1;
% for T1 = 1 : PSTH_bin : Total_burst_len - PSTH_bin 
for T1 = 0 : BINS-1
    spikes_num = 0 ;
    
        spikes_num_ch=0;
        for i=1: Nb                       
          ss = find(  bursts(i,CHANNEL_i,: ) >= T1*PSTH_bin + 1 &  bursts(i,CHANNEL_i,: ) < T1*PSTH_bin +1 + PSTH_bin  );
             if ~isempty( ss  )
                   spikes_num = spikes_num + length(ss) ;
%                    spikes_num_ch = spikes_num_ch + length(ss) ;
                   
             end
        end
%         psth_ALL_CHANNELS( CHANNEL_i , T1+1 ) = spikes_num_ch   ;
    
    spikes_num = spikes_num / Nb;
    psth_dx = [ psth_dx T1];
    psth= [ psth spikes_num ]; 
    
    curr_bin=curr_bin+1;
end
   psth_norm = psth / sum(psth);
 
   