
function sigma = rastername2sigma( raster_name )
    file = raster_name( 1 : strfind(   raster_name , 'sigma') - 1  ) ;
    file2 = file( strfind(   file , 'Raster_') + 7 : end  );
    c = str2num( file2 );
    if length( c) == 0
        c = 0 ;
    end
    
end