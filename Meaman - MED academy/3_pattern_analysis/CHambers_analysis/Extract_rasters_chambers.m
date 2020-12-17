% Extract_rasters_chambers

% Eaxtract rasters A B AB
% input : RASTER_data.index_r 
% Global_flags.Search_Params.chamber_A_electrodes
% Global_flags.Search_Params.chamber_B_electrodes
% output : RASTER_data.index_r RASTER_data.index_rA RASTER_data.index_rB

if isfield( Search_Params , 'Chamber_analysis_A_electrodes')
     Search_Params.Chamber_A_electrodes = Search_Params.Chamber_analysis_A_electrodes ;
     Search_Params.Chamber_B_electrodes = Search_Params.Chamber_analysis_B_electrodes ;
     Search_Params.Chamber_channels_electrodes = Search_Params.Chamber_channels_electrodes  ;
end

index_r_6well_all = [];
index_r_6well_all.RASTER_data = [];
Chambers.RASTER_data.index_r = index_r ;

% index_rA ----------------
    index_r_chamber = [];
    for ci = 1 : length(  Search_Params.Chamber_A_electrodes )
           chan_num_1i =   Search_Params.Chamber_A_electrodes( ci ) ;
          chan_index = find(  index_r( : , 2 ) == chan_num_1i );
           
           raster_1d =   index_r( chan_index , 1 ) ;
           raster_1d_amp =   index_r( chan_index , 3 ) ;
           raster_1d = [ raster_1d   chan_num_1i * ones( length( raster_1d ),1)  raster_1d_amp ];
%            raster_1d = [ raster_1d   chan_num_1i * ones( length( raster_1d ),1)  raster_1d_amp ];
        
           
           index_r_chamber = [ index_r_chamber ; raster_1d ];
           spikes_num = length(chan_index);
     end     
         Chambers.RASTER_data.index_rA = index_r_chamber ;
       
% index_rB ----------------      
     index_r_chamber = [];
    for ci = 1 : length(  Search_Params.Chamber_B_electrodes )
           chan_num_1i =   Search_Params.Chamber_B_electrodes( ci ) ;
          chan_index = find(  index_r( : , 2 ) == chan_num_1i );
           
           raster_1d =   index_r( chan_index , 1 ) ;
           raster_1d_amp =   index_r( chan_index , 3 ) ;
           raster_1d = [ raster_1d   chan_num_1i * ones( length( raster_1d ),1)  raster_1d_amp ];
%            raster_1d = [ raster_1d   chan_num_1i * ones( length( raster_1d ),1)  raster_1d_amp ];
        
           
           index_r_chamber = [ index_r_chamber ; raster_1d ];
           spikes_num = length(chan_index);
    end     
         Chambers.RASTER_data.index_rB = index_r_chamber ;   
    
         
% index_rChan ----------------

   index_r_chamber = [];
    Chamber_channels_electrodes_all = reshape( Search_Params.Chamber_channels_electrodes , 1, []);
    for ci = 1 : length(  Chamber_channels_electrodes_all  )
           chan_num_1i =   Chamber_channels_electrodes_all( ci ) ;
          chan_index = find(  index_r( : , 2 ) == chan_num_1i );
           
           raster_1d =   index_r( chan_index , 1 ) ;
           raster_1d_amp =   index_r( chan_index , 3 ) ;
           raster_1d = [ raster_1d   chan_num_1i * ones( length( raster_1d ),1)  raster_1d_amp ];
%            raster_1d = [ raster_1d   chan_num_1i * ones( length( raster_1d ),1)  raster_1d_amp ];
        
           
           index_r_chamber = [ index_r_chamber ; raster_1d ];
           spikes_num = length(chan_index);
    end     
         Chambers.RASTER_data.index_rChan = index_r_chamber ;   



         
         
         