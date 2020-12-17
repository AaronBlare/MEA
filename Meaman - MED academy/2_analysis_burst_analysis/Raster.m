% Raster
 
% if  Arg_file.Use_meaDB_raster   
%     Raster_file( 0,0 , Arg_file );
% else
%     [filename,pathname] = uigetfile( '*.*' , 'Select file' ) ;
%     if filename ~= 0
%     Raster_file( filename,pathname , Arg_file );
%     end
% 
% end

params_raster.Search_Params = Search_Params ; 
Raster_file( 0,0 , Arg_file , params_raster );
