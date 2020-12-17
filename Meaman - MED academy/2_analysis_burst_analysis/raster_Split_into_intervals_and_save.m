
% loads raster, cuts and saves
% Edit_fromEdit_to - ms
% Edit_to == true - erase in interval, else - leave spikes there
function file_list = raster_Split_into_intervals_and_save( filename ,pathname, N  , params)
 
if filename ~= 0
index_r0 = load( char( filename ) ) ;   

whos index_r 
split_interval=params.split_interval;
Tmax = max( index_r0( : , 1 ) ) + 2000 ;

file_list = {} ;

file_number = 1 ;
for Ti = 0 : split_interval : Tmax - split_interval ;
    Edit_from =  Ti ;
    Edit_to = Ti + split_interval ;
    file_number
    params.add_prefix = [ '_' num2str( file_number ) '_' ] ;
    ss = find( index_r0( : , 1 ) >= Edit_from & index_r0( : , 1 ) < Edit_to ) ;
    if ~isempty( ss )
        index_r = []; 
        index_r = index_r0( ss , : )  ;
        index_r0( ss , : ) = [] ;
     
    
       File_string_prefix = [ '_' num2str( file_number ) '_' ] ;
     
         
 %--save file
        str_from = num2str( Edit_from/1000 ) ;
        str_to = num2str( Edit_to/1000 ) ;
        [pathstr,name,ext] = fileparts( filename ) ;
        name
        currdir = cd ;
        
        New_filename = [ char(name) File_string_prefix str_from '-' str_to '_sec' ] ;       
        
        Raster_file = [ New_filename ext ] ;
        Raster_fullfilename = [ currdir '\'  Raster_file ]; 
        
        file_list{ file_number } =  Raster_fullfilename ;
        
         fid = fopen(Raster_file , 'w');
         [a,p] = size(index_r);

          if p == 4 
            fprintf(fid, '%.3f  %d  %.4f %.4f\n', index_r');
          end

         if p == 3 
            fprintf(fid, '%.3f  %d  %.4f\n', index_r');
         end
         if p == 2
            fprintf(fid, '%.3f  %d\n', index_r');     
         end 
         cd( pathname )
         fclose(fid);
         cd( currdir );
 
 
         file_number=file_number+1;
 %------------
         end
         


end

 
end










