   %-------- MEA_DB_Add_analyzed_bursts_to_DB 
    % Input >>> Experiment_name Sigma_threshold (may be 0) ANALYZED_DATA
    
    if exist(  'Buffer_file' , 'var')   
%       Buffer_file.Write_Buffer_file
%       Write_Buffer.Path_filename
      Buffer_file.Parameters = Parameters ;
    else
      Buffer_file.Write_Buffer_file = false;
      Buffer_file.write_index_r_to_DB = false ;
      if exist( 'Parameters', 'var')
        Buffer_file.Parameters = Parameters ;
      else
         Buffer_file.Parameters = [] ; 
      end
%       Write_Buffer.Path_filename
    end
    
           [index_r_from_DB , Raster_exists ,Raster_exists_with_other_sigma , Sigma_threshold_exists , RASTER_data ] = ...
                   Load_raster_from_RASTER_DB( Experiment_name ,  Sigma_threshold );
             if Raster_exists  
                clear  index_r_from_DB ;
%                 RASTER_data  = RASTER_data_from_DB ;
%                 clear RASTER_data_from_DB ;

                % add also raster (index_r) that was just analyzed
                if exist( 'index_r')
                    Buffer_file.index_r = index_r ;
                    Buffer_file.write_index_r_to_DB = true ;
                end
                Add_Analyzed_data_RASTER_DB( Experiment_name , RASTER_data.Sigma_threshold , ANALYZED_DATA , Buffer_file )
             else
                 RASTER_data.Parameters = Buffer_file.Parameters ;
                 if  MED_file_raster_input
                     [Raster_exists ,Raster_exists_with_other_sigma ] = Add_new_Raster_RASTER_DB( Experiment_name , ...
                    RASTER_data.Sigma_threshold , RASTER_data);
                    Add_Analyzed_data_RASTER_DB( Experiment_name , RASTER_data.Sigma_threshold , ANALYZED_DATA );
                 else
                     RASTER_data.index_r = index_r;
                     RASTER_data.Raster_Flags = zeros( 40 , 1 ) ; 
                     RASTER_data.Raster_Flags( RASTER_FLAG_Artefacts_included ) = false ;
                     if exist( 'Original_filename', 'var')
                        RASTER_data.Original_filename = Original_filename ;
                     end
                                 % c == 0 - empty RASTER_DATA
                                 % c == 1 - all data fine 
                                 % c == 2 - only index_r 
                                 % c == 3 - artifacts also 
                                 RASTER_data.Raster_Flags( RASTER_FLAG_all_data_included ) = 2 ;
                     
                     [Raster_exists ,Raster_exists_with_other_sigma ] = Add_new_Raster_RASTER_DB( Experiment_name , ...
                        0 , RASTER_data);
                     Add_Analyzed_data_RASTER_DB( Experiment_name , 0 , ANALYZED_DATA , Buffer_file );    
                 end
             end
   %----------------------------