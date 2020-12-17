% Connectivity_from_given_file
% input: pathname0 filename 
% may be pos-stim response file or BURSTS.. file or meaDB file



            Analyze_only_one_pair = true ;
            Analyze_only_one_pair = false;             
               One_pair_i = 36 ;
               One_pair_j  = 54 ;


[pathname,name,ext] = fileparts( filename ) ;
  
       if ext == '.mat' 
           
           Experiment_name = name ;
           Opened_DB_file = false ; 
           filename
           if exist( [ pathname0 filename ] , 'file')
                 load( [ pathname0 filename ] ) 
           else 
               [index_r , Raster_exists ,Raster_exists_with_other_sigma , Sigma_threshold_exists , RASTER_data ]...
                                    = Load_raster_from_RASTER_DB(  Experiment_name , 0 );
           end
            
           filetype = '';
           if exist(  'POST_STIM_RESPONSE' )
               filetype = 'POST_STIM_RESPONSE' ;

               bursts_absolute = POST_STIM_RESPONSE.bursts_absolute ;
               bursts  = POST_STIM_RESPONSE.bursts ;
               Spike_Rates = POST_STIM_RESPONSE.Spike_Rates ;        
               
           end
           
               if exist( 'RASTER_data' )
                   if isfield( RASTER_data , 'POST_STIM_RESPONSE')
                      filetype = 'POST_STIM_RESPONSE' ;
                      Opened_DB_file = true ; 
                      POST_STIM_RESPONSE = RASTER_data.POST_STIM_RESPONSE ;
                      bursts_absolute = POST_STIM_RESPONSE.bursts_absolute ;
                      bursts  = POST_STIM_RESPONSE.bursts ;
                      Spike_Rates = POST_STIM_RESPONSE.Spike_Rates ;   
                   end
               end
           
               if exist( 'RASTER_data' )
                   if isfield( RASTER_data , 'ANALYZED_DATA')
                      filetype = 'ANALYZED_DATA' ;
                      Opened_DB_file = true ; 
                      ANALYZED_DATA = RASTER_data.ANALYZED_DATA ;                    
                   end
               end
               
               if exist(  'ANALYZED_DATA' )
                   filetype = 'ANALYZED_DATA' ;
                   bursts_absolute = ANALYZED_DATA.bursts_absolute ;
                   bursts  = ANALYZED_DATA.bursts ;
                   Spike_Rates = ANALYZED_DATA.Spike_Rates ;
                   Firing_Rates_each_channel_mean = ANALYZED_DATA.Firing_Rates_each_channel_mean ;
                   Nb = ANALYZED_DATA.Number_of_bursts
                   Spike_Rates_each_channel_mean= ANALYZED_DATA.Spike_Rates_each_channel_mean ;
                   if isfield( ANALYZED_DATA , 'SpikeRate_burst_profile_1ms' )
                       SpikeRate_burst_profile_1ms = ANALYZED_DATA.SpikeRate_burst_profile_1ms ;
                   end
               end
           
               
           

               Nb = ANALYZED_DATA.Number_of_bursts ;
               s= size( ANALYZED_DATA.Spike_Rates ) ;
               N = s(2) ;
               if isfield( ANALYZED_DATA ,'Burst_Data_Ver' )==0
                   Burst_Data_Ver = 1 ;
               else
                 Burst_Data_Ver = ANALYZED_DATA.Burst_Data_Ver;
               end
               
            Patterns_analysis_connectivity 
            % >>> Input: bursts or bursts_absolute , Spike_Rates  , Nb , N ,
            % Burst_Data_Ver , [ Analyze_only_one_pair , One_pair_i , One_pair_j ]
            % Output >>>: 
            % Connectiv_data struct :
            % Connectiv_matrix_M_on_tau ( N x N x Connectiv_data.params.tau_number ) 
            % Connectiv_matrix_max_M (NxN) , 
            % Connectiv_matrix_tau_of_max_M ( NxN )
            % max_M - Maximum % of spikes transferred , tau - delay of max_M
            % Connectiv_matrix_tau_of_max_M_vector 
            % Connectiv_matrix_tau_of_max_M_vector_non_zeros
            % Connectiv_matrix_max_M_vector
            % Connectiv_matrix_max_M_vector_non_zeros
            % Connectiv_data.params
            %   [ One_pair.M_on_tau_not_fitted  ( One_pair_i ,One_pair_j , :);
            %     One_pair.M_on_tau_One_pair ( One_pair_i ,One_pair_j , :);
            %     One_pair.max_M - strength
            %     One_pair.tau_of_max_M - delay
            
%             if Analyze_only_one_pair 
           
            
%            filename = [ name '_MEA_DB' ];
           Path_filename = [ pathname0 filename ] ;
    %       save( [ pathname0 filename ] , 'ANALYZED_DATA'  );

           Buffer_file.Write_Buffer_file = false; 
           Buffer_file.Path_filename = Path_filename ;
                
                
            if strcmp(  filetype , 'ANALYZED_DATA' )
                if ~Opened_DB_file 
                ANALYZED_DATA.Connectiv_data = Connectiv_data ;    
                save( [ pathname0 filename ] , 'ANALYZED_DATA' , '-append' );
                end
             
                Sigma_threshold = 0 ;
                MED_file_raster_input = false ;
                filename = Experiment_name ;
                MEA_DB_Add_analyzed_bursts_to_DB % - Uses previous functions. Checks if raster is in the DB and adds Analyzed_data to          RASTER_DATA in DB           
                 % Input >>> Experiment_name Sigma_threshold (may be 0) ANALYZED_DATA
                 % index_r - if only no record in DB 
            end
            
            
            if strcmp(  filetype , 'POST_STIM_RESPONSE' )
                POST_STIM_RESPONSE.Connectiv_data = Connectiv_data ;    
                
             
                if Opened_DB_file 
                    Sigma_threshold = 0 ;
                    MED_file_raster_input = false ;
                    Add_PostStim_response_data_RASTER_DB( Experiment_name , 0 , POST_STIM_RESPONSE );   % - Uses previous functions. Checks if raster is in the DB and adds Analyzed_data to          RASTER_DATA in DB           
                     % Input >>> Experiment_name Sigma_threshold (may be 0) ANALYZED_DATA
                     % index_r - if only no record in DB 
                     
                     [index_r_from_DB , Raster_exists ,Raster_exists_with_other_sigma , Sigma_threshold_exists , RASTER_data , Result_MAT_path_file_DB] = ...
                       Load_raster_from_RASTER_DB( Experiment_name ,  0 );
     
                     if Result_MAT_path_file_DB ~= 0
                         [DBpathstr,DBname,DBext] = fileparts( Result_MAT_path_file_DB ) ;  
                         copyfile(Result_MAT_path_file_DB , [ DBname '.mat' ] );
                     end
                else
                   save( [ pathname0 filename ] , 'POST_STIM_RESPONSE'  ); 
                    
                end
            end
            
           
           
       end 