% loads raster, cuts and saves
% Edit_fromEdit_to - ms
% Edit_to == true - erase in interval, else - leave spikes there
function raster_cut_file_and_save( filename ,pathname, N ,Edit_from , Edit_to , erase_or_live , params)
 
if filename ~= 0
index_r = load( char( [ pathname filename ] ) ) ;   

whos index_r 

% min_t = min( index_r( : , 1 )) ;
 mint = min( index_r(:,1) );
 maxt = max(  index_r(:,1) );
 if maxt - mint < mint 
    index_r(:,1) = index_r(:,1) - mint + 100 ;  
 end
% index_r( : , 1 )=index_r( : , 1 )-min_t ;

if erase_or_live
       ss = find( index_r( : , 1 ) >= Edit_from & index_r( : , 1 ) < Edit_to ) ;
       if ~isempty( ss )
            index_r( ss , : ) = [] ;
       end 
       File_string_prefix = '_Deleted_' ;
else
     ss = find( index_r( : , 1 ) < Edit_from );
       if ~isempty( ss )
            index_r( ss , : ) = [] ;
       end 
     ss = find( index_r( : , 1 ) >= Edit_to );
       if ~isempty( ss )
            index_r( ss , : ) = [] ;
       end    
       File_string_prefix = '_';
end

if nargin == 7
  File_string_prefix = [  params.add_prefix File_string_prefix ];
end

 
str_from = num2str( Edit_from/1000 ) ;
str_to = num2str( Edit_to/1000 ) ;
[pathstr,name,ext] = fileparts( filename ) ;
name
currdir = cd ;
Raster_file = [ char(name) File_string_prefix str_from '-' str_to '_sec' ext ] ;
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

end