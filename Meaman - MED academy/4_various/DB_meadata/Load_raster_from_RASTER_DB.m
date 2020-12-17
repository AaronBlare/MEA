% Load_raster_from_RASTER_DB - loads raster data from RASTER database
%            RASTER_data.Thr_one_sigma_all = Thr_one_sigma_all ;
%             RASTER_data.Thr_all =Thr_all;
%             RASTER_data.Sigma_threshold = Sigma_number_threshold;
%             RASTER_data.Raster_file=Raster_file;
%             RASTER_data.Experiment_name = Experiment_name;
%             RASTER_data.index_r = index_r;
%             RASTER_data.artefacts =artefacts_all;
%             RASTER_data.Artefacts_included =Artefacts_included;
%             RASTER_data.bursts_analyzed=bursts_analyzed;          
%             RASTER_data.N_channels=N_channels;
%             RASTER_data.Detect_info=Detect_info;
%             RASTER_data.Bursts_analyzed = false ;
%             RASTER_data.PostStim_response_analyzed = false ;


% output = Sigma_threshold_exists - which exists or closest to input Sigma_threshold
function [index_r , Raster_exists ,Raster_exists_with_other_sigma , Sigma_threshold_exists , RASTER_data , Result_MAT_path_file_DB ] = ...
       Load_raster_from_RASTER_DB( Experiment_name , Sigma_number_threshold )
 
% [pathstr,name,ext] = fileparts( Experiment_name ) ;
% Experiment_name =  name ;

Raster_exists = false ;
Raster_exists_with_other_sigma = false ;
index_r=[];
RASTER_data=[];
Sigma_threshold_exists = 0 ;
Result_MAT_path_file_DB=0;
 
%     up =userpath ; up(end)=[];
%     DB_dir_name = 'DB_meadata';
%     DB_dir = [char(up) '\' DB_dir_name ];
% GLOBAL_CONSTANTS_load
MEA_DB_parameters_load

    DB_dir = ANALYSIS_ARG.DB_dir ;
    
    DB_dir2 = 'S:\MATLAB_DB';
    
%     Result_MAT_file_DATABASE =[char(DB_dir) '\' char(Experiment_name) '.mat' ]   ;
    Result_MAT_file_DATABASE =[  char(Experiment_name) '.mat' ]   ;    
    Result_MAT_file_DATABASE_default = Result_MAT_file_DATABASE;  
    
    Result_MAT_file_DATABASE_exists = false ;
    if exist(Result_MAT_file_DATABASE,'file') > 0
        Result_MAT_file_DATABASE_exists = true;
    else
        Result_MAT_file_DATABASE_name = [ char(Experiment_name) '.mat'  ] ;
%         filenames_DB = dir2( DB_dir , Result_MAT_file_DATABASE_name );
        filenames_DB = dir2( DB_dir ,  '.mat'  );
        n_files = length( filenames_DB ) ; 
        for k= 1:n_files     
            [pathstr,name,ext] = fileparts( filenames_DB{ k } ) ;
            if strcmp( name , Experiment_name )
                Result_MAT_file_DATABASE_exists = true ;
                Result_MAT_file_DATABASE = filenames_DB{ k } ;
            end
        end           
        
        if ~Result_MAT_file_DATABASE_exists
            filenames_DB = dir2( DB_dir2 ,  '.mat'  );
            n_files = length( filenames_DB ) ; 
            for k= 1:n_files     
                [pathstr,name,ext] = fileparts( filenames_DB{ k } ) ;
                if strcmp( name , Experiment_name )
                    Result_MAT_file_DATABASE_exists = true ;
                    Result_MAT_file_DATABASE = filenames_DB{ k } ;
                end
            end           
        end
    end 
     
    
    if Result_MAT_file_DATABASE_exists  
        Result_MAT_file_DATABASE
       DB = load( Result_MAT_file_DATABASE );
       Result_MAT_path_file_DB = Result_MAT_file_DATABASE ;
       DB.rasters_number;
       if  ~isfield( DB ,'rasters_number') % NO RASTER
            % NO RASTER exists
           Sigma_threshold_exists = 0 ; 
       else
           [rasters_index_in_DB,n] = find(cat(1,DB.rasters_index.Sigma_threshold) == Sigma_number_threshold );
            if ~isempty( rasters_index_in_DB)
                %  ------------  raster exists
                rasters_index_in_DB ;
                Raster_exists = true ;
                Sigma_threshold_exists = Sigma_number_threshold ;
            else 
                 %  ------------  raster exists but with other sigma
                 %  threshold     
               Sig_diff = [];
               for i = 1 : length( DB.rasters_index )
                   Diff = abs( DB.rasters_index( i ).Sigma_threshold - Sigma_number_threshold );
                   Sig_diff=[Sig_diff Diff  ];
               end    
               [minv , min_index ] = min( Sig_diff );
               rasters_index_in_DB = min_index ;
               Raster_exists_with_other_sigma = true ;
            end
            
            if isfield( DB , 'RASTER_data' )
                RASTER_data = DB.RASTER_data( rasters_index_in_DB ) ;
                if isfield( RASTER_data( rasters_index_in_DB ) , 'index_r' )
                   index_r = DB.RASTER_data( rasters_index_in_DB ).index_r    ;
                   Sigma_threshold_exists = DB.RASTER_data( rasters_index_in_DB ).Sigma_threshold    ;
                end
            end
            
       end
    else
        Result_MAT_path_file_DB = Result_MAT_file_DATABASE_default   ;  
        
       
       
    end