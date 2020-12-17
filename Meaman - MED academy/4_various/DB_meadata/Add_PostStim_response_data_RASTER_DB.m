% Add_PostStim_response_data_RASTER_DB  - adds post stim response to
% existed raster record in DB
function Add_PostStim_response_data_RASTER_DB( Experiment_name , Sigma_number_threshold , POST_STIM_RESPONSE)
%     Experiment_name

          
            
%     up =userpath ; up(end)=[];
%     DB_dir_name = 'DB_meadata';
%     DB_dir = [char(up) '\' DB_dir_name ];
GLOBAL_CONSTANTS_load
MEA_DB_parameters_load

    DB_dir = ANALYSIS_ARG.DB_dir ;
    Result_MAT_file_DATABASE =[char(DB_dir) '\' char(Experiment_name) '.mat' ]   ;
    
    Result_MAT_file_DATABASE 
              
    if exist(DB_dir,'dir') == 0
            mkdir(MATLAB_folder, DB_dir_name);
    end       
    Sigma_threshold = Sigma_number_threshold ;
    % c == 0 - empty RASTER_DATA
    % c == 1 - all data fine 
    % c == 2 - only index_r 
    % c == 3 - artifacts also  
%     Raster_Flags( RASTER_FLAG_all_data_included )        
    [index_r_from_DB , Raster_exists ,Raster_exists_with_other_sigma , Sigma_threshold_exists , RASTER_data , Result_MAT_file_DATABASE ] = ...
                   Load_raster_from_RASTER_DB( Experiment_name ,  Sigma_threshold );
    if Raster_exists 
%     if exist(Result_MAT_file_DATABASE,'file') > 0
       DB = load( Result_MAT_file_DATABASE );
% %        DB.rasters_number;
%        if  ~isfield( DB ,'rasters_number') 
%             % --------  NO RASTER exists
%        else
%            rasters_index_in_DB = find( DB.rasters_index(:).Sigma_threshold  == Sigma_number_threshold );
%            [rasters_index_in_DB,n] = find(cat(1,rasters_index.Sigma_threshold) == Sigma_number_threshold );
%            rasters_index_in_DB;
% %             if ~isempty( rasters_index_in_DB)
                rasters_index_in_DB = 1 ;
%                 RASTER_data  = RASTER_data_from_DB ;
% %                 rasters_index_in_DB = rasters_index_in_DB(1) ;
                % -----------   raster exists and Add to RASTER_data new data 
                DB.RASTER_data( rasters_index_in_DB ).POST_STIM_RESPONSE =   POST_STIM_RESPONSE  ;
                                
                RASTER_data = DB.RASTER_data;
                RASTER_data.Raster_Flags( RASTER_FLAG_all_data_included ) = true ;
                RASTER_data.Raster_Flags( RASTER_FLAG_Artefacts_included ) = true ;
                RASTER_data.artefacts = POST_STIM_RESPONSE.artefacts ;
                rasters_number = DB.rasters_number ;
                rasters_index = DB.rasters_index ;
                Details = DB.Details ;

                 eval(['save ' char( Result_MAT_file_DATABASE ) '  Details     ' ...
                    '  Experiment_name RASTER_data rasters_number rasters_index    -mat']);
    
% %             else
               %  ------------  raster exists but with other sigma threshold               
% %             end
%        end
       
       % --------  NO RASTER in DB exists
    else
%         RASTER_data.spikes_exist = false ;
        RASTER_data.POST_STIM_RESPONSE = POST_STIM_RESPONSE ; 
        Details= [] ;
        RASTER_data.artefacts = POST_STIM_RESPONSE.artefacts  ;
        RASTER_data.Raster_Flags( RASTER_FLAG_all_data_included ) = 0 ; 
        [Raster_exists ,Raster_exists_with_other_sigma ] = Add_new_Raster_RASTER_DB( Experiment_name , ...
        Sigma_number_threshold   ,RASTER_data , Details);
          % --------  NO RASTER exists
    end
    
 