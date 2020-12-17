
% Bursts_Merge_to_raster
% input ANALYZED_DATA

close all


Ni = 1 ;
ch = 1 ;
Nb = size( ANALYZED_DATA.bursts_absolute );
Nb = Nb(1);

% Nclus = 20 ;
% Nb = 45 ;

chn = 60 ;
index_r  =[];
times=[];
last_time = 0 ;
Burst_starts_new = [ 1 ] ;

for Ni = 1 : Nb
    Ni
    if Ni > 1 
        last_time =  last_time +  ANALYZED_DATA.BurstDurations( Ni-1 ) + 100  ;
        Burst_starts_new = [ Burst_starts_new last_time ] ;
    end
    for ch = 1 : chn 
        a = ANALYZED_DATA.bursts_absolute{ Ni }{ ch };
        s = numel( a );
        if Ni > 1
             
        times = a  - ANALYZED_DATA.burst_start( Ni )   +   last_time ; 
         
        else
           times = a  -  ANALYZED_DATA.burst_start( Ni ) ; 
           
        end

        ch_col = ones( s , 1 );
        
        
        index_r1 = [ times ch_col * ch ];
        index_r  = [ index_r  ; index_r1 ];
    end
end

whos index_r 




 

dlmwrite( 'Raster_Merged.txt'  , index_r  ,'delimiter','\t','precision',8,'newline','pc');
% save( 'Raster_filtered.txt' ,  'index_r0' ,  '-ascii' )
