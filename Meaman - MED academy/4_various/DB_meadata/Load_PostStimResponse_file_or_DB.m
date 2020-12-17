% loads Poststim response by filename input
% if input without pathname - it is in DB
function [ POST_STIM_RESPONSE , POST_STIM_RESPONSE_exists ] = Load_PostStimResponse_file_or_DB( filename )

Arg_file.Sigma_threshold = 8 ;
[pathstr,name,ext] = fileparts( filename ) ;
if isempty( pathstr )
    Arg_file.Use_meaDB_raster = true  ;
    Arg_file.Experiment_name = filename ;    
else 
    Arg_file.Use_meaDB_raster =  false ;
    Arg_file.Experiment_name = '0';
end
POST_STIM_RESPONSE_exists = false ;
    
init_dir = cd ;
if Arg_file.Use_meaDB_raster %----------- load raster from DB
    [index_r , Raster_exists ,Raster_exists_with_other_sigma , Sigma_threshold_exists , RASTER_data ]...
        = Load_raster_from_RASTER_DB( Arg_file.Experiment_name , Arg_file.Sigma_threshold ); 
    
        if isfield(RASTER_data, 'POST_STIM_RESPONSE') 
            POST_STIM_RESPONSE = RASTER_data.POST_STIM_RESPONSE ;
            POST_STIM_RESPONSE.Flags = RASTER_data.Raster_Flags ;
            POST_STIM_RESPONSE_exists = true ;
        else
            POST_STIM_RESPONSE = [] ;
        end
        
else     %----------- load raster from file
% [filename, pathname] = uigetfile('*.*','Select file') ;    
filename

[pathstr,name,ext ] = fileparts( filename ) ; 

   if  ext == '.mat' 
        load( char( filename  ) ) ;  
        if isfield(RASTER_data, 'POST_STIM_RESPONSE') 
            POST_STIM_RESPONSE = RASTER_data.POST_STIM_RESPONSE ;
            POST_STIM_RESPONSE.Flags = RASTER_data.Raster_Flags ;
            POST_STIM_RESPONSE_exists = true ;
        else
            POST_STIM_RESPONSE = [] ;
        end
   else % if just txt file
     filename
     POST_STIM_RESPONSE = [] ;
   end 
% cd( pathname ) ; 
end
  

