% Add_new_Raster_RASTER_DB - add new raster record in DB or creates new
% record if not exists. All raster data should be in  RASTER_data
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

%     Details.Sample_rate = Sample_rate;
%     Details.Trace_Lenght_pionts = Trace_Lenght_pionts ;
%     Details.Trace_length_sec= Trace_length_sec ;
%     Details.Detect_info = Detect_info ;
%     Details.N_channels = N_channels   ; 
%     Details.MEA_type     = DATA_TYPE       ;

function [Raster_exists ,Raster_exists_with_other_sigma ] = Add_new_Raster_RASTER_DB( Experiment_name , ...
        Sigma_number_threshold   ,RASTER_data , Details )

    %Default Details 
    if nargin < 4
        N  = max( RASTER_data.index_r( :,2) ); %Number of channels  
            Details.Sample_rate = 0 ;
            Details.Trace_Lenght_pionts = 0 ;
            Details.Trace_length_sec= 0 ;
            Details.Detect_info = [] ;
            Details.N_channels = N   ; 
            Details.MEA_type     = 'Unknown' ;
            Details.Experiment_comment = '' ;        
    end
    
    
    % c == 0 - empty RASTER_DATA
    % c == 1 - all data fine 
    % c == 2 - only index_r 
    % c == 3 - artifacts also 
    
    % if only index_r in RASTER_data
   if   RASTER_data.Raster_Flags( RASTER_FLAG_all_data_included ) == 2 
       N  = max( RASTER_data.index_r( :,2) ); %Number of channels  
            RASTER_data.Thr_one_sigma_all = zeros( N , 1 ) ;
            RASTER_data.Thr_all = zeros( N , 1 );
            RASTER_data.Sigma_threshold = Sigma_number_threshold;
%             RASTER_data.Raster_file = Raster_file ;
            RASTER_data.Experiment_name = Experiment_name;
            RASTER_data.Exp_date_label = Get_exp_details_from_filename( Experiment_name );

%             RASTER_data.index_r = index_r;
            if ~isfield( RASTER_data ,'artefacts') 
                RASTER_data.artefacts = [] ; 
                RASTER_data.Raster_Flags( RASTER_FLAG_Artefacts_included ) = false ;
            else
                RASTER_data.Raster_Flags( RASTER_FLAG_Artefacts_included ) = true  ;
            end
            RASTER_data.N_channels= N ;
            RASTER_data.Detect_info= [] ;  
            RASTER_data.spikes_exist = true ; 
            RASTER_data.Raster_Flags( RASTER_FLAG_all_data_included ) = 1 ;
   end
RASTER_data.Raster_Flags( RASTER_FLAG_all_data_included ) = 1 ;     
Raster_exists = false ;
Raster_exists_with_other_sigma = false ;

%     up =userpath ; up(end)=[];
%     DB_dir_name = 'DB_meadata';
%     DB_dir = [char(up) '\' DB_dir_name ];
% GLOBAL_CONSTANTS_load
MEA_DB_parameters_load

    DB_dir = ANALYSIS_ARG.DB_dir ;
    Result_MAT_file_DATABASE =[char(DB_dir) '\' char(Experiment_name) '.mat' ]   ;
    
    
    Result_MAT_file_DATABASE;
              
    if exist(DB_dir,'dir') == 0
            mkdir( MATLAB_folder , DB_dir_name);
    end       
            
   
    if exist(Result_MAT_file_DATABASE,'file') > 0
       DB = load( Result_MAT_file_DATABASE );
%        DB.rasters_number;
       if  ~isfield( DB ,'rasters_number') 
            % --------  NO RASTER exists
            DB.rasters_index.Sigma_threshold = Sigma_number_threshold;
            DB.rasters_index.index_of_raster = 1;
            DB.rasters_number=1;
            DB.RASTER_data = RASTER_data;
       else
%            rasters_index_in_DB = find( DB.rasters_index(:).Sigma_threshold  == Sigma_number_threshold );
           [rasters_index_in_DB,n] = find(cat(1,DB.rasters_index.Sigma_threshold) == Sigma_number_threshold );
%            rasters_index_in_DB;
            if ~isempty( rasters_index_in_DB)
                %  ------------  raster exists
                Raster_exists = true ;
            else
                %  ------------  raster exists but with other sigma threshold  
               DB.rasters_number= DB.rasters_number+1; 
               DB.rasters_index( DB.rasters_number ).Sigma_threshold = Sigma_number_threshold;
               DB.rasters_index( DB.rasters_number).index_of_raster = DB.rasters_number ;
               DB.RASTER_data = [ DB.RASTER_data RASTER_data ];      
               Raster_exists_with_other_sigma = true ;
            end
       end
    else
         % --------  NO RASTER exists
         DB.rasters_index.Sigma_threshold = Sigma_number_threshold;
            DB.rasters_index.index_of_raster = 1;
            DB.rasters_number=1;
            DB.RASTER_data =RASTER_data;
    end
    
    RASTER_data = DB.RASTER_data;
    rasters_number = DB.rasters_number ;
    rasters_index = DB.rasters_index ;  
    
    
    
    eval(['save ' char( Result_MAT_file_DATABASE ) '  Details   Experiment_name  ' ...
        '   RASTER_data rasters_number rasters_index    -mat']);
     
    