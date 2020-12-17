
%     rasterfile2details_file
function details_file = rasterfile2details_file( raster_file )
[pathstr,name,ext,versn] = fileparts( raster_file ) ;
  
file = name( 1 : strfind(   name , '_Ra') - 1  )  
details_file = [char( file ) '_Details.mat'] ;
end