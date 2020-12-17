
% MEA_DB_BURST_file_to_DB_from_file
% Input:  pathname  filename 

filename 

           load( [ pathname0  filename ] );
               Experiment_name
            Sigma_threshold = 0 ;
            MED_file_raster_input = false ;
          	MEA_DB_Add_analyzed_bursts_to_DB % - Uses previous functions. Checks if raster is in the DB and adds Analyzed_data to          RASTER_DATA in DB           
             % Input >>> Experiment_name Sigma_threshold (may be 0) ANALYZED_DATA
             % index_r - if only no record in DB
             
             