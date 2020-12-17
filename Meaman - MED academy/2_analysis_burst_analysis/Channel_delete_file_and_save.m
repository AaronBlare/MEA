% loads raster, cuts and saves
% Edit_fromEdit_to - ms
% Edit_to == true - erase in interval, else - leave spikes there
function Channel_delete_file_and_save( filename ,pathname, Channel_to_delete , var )
 
if filename ~= 0
    currdir = cd ;
    cd( pathname )
index_r = load( char( filename ) ) ;   

whos index_r 
 
if ~var.leave_channels
    for i = 1 : length( Channel_to_delete  )
        Channel  = Channel_to_delete( i );
           ss = find( index_r( : , 2 ) == Channel ) ;
           if ~isempty( ss )
                index_r( ss , : ) = [] ;
           end 
    end
else
    N = max( index_r( : , 2 ) );
    Channels_to_delete2 = 1 : N ;
    Channels_to_delete2( Channel_to_delete ) = [];
    Channel_to_delete= Channels_to_delete2 ;
    for i = 1 : length( Channel_to_delete  )
        Channel = Channel_to_delete( i );
           ss = find( index_r( : , 2 ) == Channel ) ;
           if ~isempty( ss )
                index_r( ss , : ) = [] ;
           end 
    end
end
 
[pathstr,name,ext] = fileparts( filename ) ;
name
if length( Channel_to_delete ) > 1 
    Channel = [] ;
else
   Channel  ;
end

Raster_file = [ char(name) '_' num2str( Channel ) '_channel_erased' ext ] ;
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