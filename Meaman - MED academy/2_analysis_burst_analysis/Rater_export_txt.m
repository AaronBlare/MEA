
% Rater_export_txt.m


Ni = 1 ;
ch = 1 ;
Nb = size( RASTER_data.ANALYZED_DATA.bursts_absolute );
Nb = Nb(1);

chn = 60 ;
index_r0=[];

for Ni = 1 : Nb
    for ch = 1 : chn 
        a = RASTER_data.ANALYZED_DATA.bursts_absolute{ Ni }{ ch };
        s = numel( a );
        times = a;

        ch_col = ones( s , 1 );

        index_r = [ times ch_col * ch ];
        index_r0 = [ index_r0 ; index_r ];
    end
end

dlmwrite( 'Raster_filtered.txt'  , index_r0 ,'delimiter','\t','precision',8,'newline','pc');
% save( 'Raster_filtered.txt' ,  'index_r0' ,  '-ascii' )






