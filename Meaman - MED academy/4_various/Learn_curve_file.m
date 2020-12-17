
function Learn_curve_file( Arg_file )  

init_dir = cd ;
POST_STIM_RESPONSE_exists = false ;
Arg_file
if Arg_file.Use_meaDB_raster %----------- load raster from DB
    [index_r , Raster_exists ,Raster_exists_with_other_sigma , Sigma_threshold_exists , RASTER_data ]...
        = Load_raster_from_RASTER_DB( Arg_file.Experiment_name , Arg_file.Sigma_threshold ); 
    if  ~isfield( RASTER_data ,'artefacts') 
      
    else
      POST_STIM_RESPONSE_exists = true ;
    end
    
else     %----------- load raster from file
     [filename,pathname] = uigetfile( '*.*' , 'Select file' ) ;
    if filename ~= 0
        cd( pathname ) ;
        [pathstr,name,ext,versn] = fileparts( filename ) ;
        
        if  ext == '.mat'   
%             MED_file_raster_input = true ; 
            load( char( filename ) ) ;
%             index_r = RASTER_data.index_r ;
            artefacts = POST_STIM_RESPONSE.artefacts ;
            POST_STIM_RESPONSE_exists = true ; 
        else
%             [filename_art, pathname_art] = uigetfile('*.*','Select Raster file') ;
            POST_STIM_RESPONSE_exists = true ; 
            artefacts = load( char( filename ) ) ;
        end  
      
        
    
    end  
  
end

if POST_STIM_RESPONSE_exists %------------------- Data from experiment loaded, work next
    



Learn_curve( artefacts )  ;
 
 
 
end
 %-------------------------
 
 
 