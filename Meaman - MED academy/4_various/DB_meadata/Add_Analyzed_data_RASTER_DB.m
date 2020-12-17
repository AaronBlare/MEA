% Add_Analyzed_data_RASTER_DB  - adds burst analysis data to
% existed raster record in DB
function Add_Analyzed_data_RASTER_DB( Experiment_name , Sigma_number_threshold , ANALYZED_DATA , Buffer_file )
%     Experiment_name

   if nargin < 4
      Write_Buffer_file = false ;
   else
      Write_Buffer_file = Buffer_file.Write_Buffer_file ; 
%       Buffer_file.Write_Buffer_file
%       Write_Buffer.Path_filename
   end
            
%     up =userpath ; up(end)=[];
%     DB_dir_name = 'DB_meadata';
%     DB_dir = [char(up) '\' DB_dir_name ];
% GLOBAL_CONSTANTS_load
MEA_DB_parameters_load

    DB_dir = ANALYSIS_ARG.DB_dir ;
    Result_MAT_file_DATABASE =[char(DB_dir) '\' char(Experiment_name) '.mat' ]   ;
    
    Result_MAT_file_DATABASE 
              
    if exist(DB_dir,'dir') == 0
            mkdir(MATLAB_folder, DB_dir_name);
    end       
     Sigma_threshold =       Sigma_number_threshold ;
              [index_r_from_DB , Raster_exists ,Raster_exists_with_other_sigma , Sigma_threshold_exists , RASTER_data_from_DB...
                  Result_MAT_file_DATABASE ] = ...
                   Load_raster_from_RASTER_DB( Experiment_name ,  Sigma_threshold );
             if Raster_exists  
                 clear index_r_from_DB ;
                 clear RASTER_data_from_DB ;
%     if exist(Result_MAT_file_DATABASE,'file') > 0
                 DB = load( Result_MAT_file_DATABASE );
% %        DB.rasters_number;
%        if  ~isfield( DB ,'rasters_number') 
%             % --------  NO RASTER exists
%        else
% %            rasters_index_in_DB = find( DB.rasters_index(:).Sigma_threshold  == Sigma_number_threshold );
%            [rasters_index_in_DB,n] = find(cat(1,DB.rasters_index.Sigma_threshold) == Sigma_number_threshold );
% %            rasters_index_in_DB;
%             if ~isempty( rasters_index_in_DB)
%                 rasters_index_in_DB = rasters_index_in_DB(1) ;
                % -----------   raster exists and Add to RASTER_data new data
                                 % c == 0 - empty RASTER_DATA
                                 % c == 1 - all data fine 
                                 % c == 2 - only index_r 
                                 % c == 3 - artifacts also 
                rasters_index_in_DB  = 1 ;
                DB.RASTER_data( rasters_index_in_DB ).Raster_Flags( RASTER_FLAG_all_data_included ) = 1 ;
                DB.RASTER_data( rasters_index_in_DB ).Raster_Flags( RASTER_FLAG_bursts_analyzed ) = true ; 
                DB.RASTER_data( rasters_index_in_DB ).ANALYZED_DATA = ANALYZED_DATA  ;
                if isfield( Buffer_file , 'Parameters' )
                    DB.RASTER_data( rasters_index_in_DB ).Parameters = Buffer_file.Parameters ;
                end
                if Buffer_file.write_index_r_to_DB
                   DB.RASTER_data( rasters_index_in_DB ).index_r = Buffer_file.index_r ; 
                end
                                
                RASTER_data = DB.RASTER_data;
                rasters_number = DB.rasters_number ;
                rasters_index = DB.rasters_index ;
                Details = DB.Details ;

                RASTER_data.Raster_Flags = DB.RASTER_data( rasters_index_in_DB ).Raster_Flags ;
                 eval(['save ' char( Result_MAT_file_DATABASE ) '  Details     ' ...
                    '  Experiment_name RASTER_data rasters_number rasters_index    -mat']);

                if Write_Buffer_file
                 eval(['save ' char( Buffer_file.Path_filename ) '  Details     ' ...
                    '  Experiment_name RASTER_data rasters_number rasters_index    -mat']);                    
                end
                                 
%             else
%                %  ------------  raster exists but with other sigma threshold               
            end
%        end
%     else
          % --------  NO RASTER exists
%     end