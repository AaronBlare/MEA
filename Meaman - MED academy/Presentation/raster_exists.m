%  raster_exists

function [ exists , filename ] = raster_exists( raster_name )

details_file = raster2details_file( raster_name );
exists = exist( details_file , 'file' ) ;
if (exists >0 )
    eval(['load ' char( a )]);
    Raster_file
else
   filename = ''; 
end
    
end