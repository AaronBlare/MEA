   
         
        function meaDB_CompareResults_save(   ANALYSIS_ARG ,ANALYSIS_cell, ALL_cell , Global_flags , var)
        %input var.filename_defined, var.result_filename
        %
        filename_defined = false ;
        if isfield( var , 'filename_defined' )
            filename_defined = var.filename_defined ; 
        end
        
        if ~filename_defined 
        S = ALL_cell.filenames{ 1 } ;        
        k = strfind(S, '-');
        Exp_name = S ;
        if length( k ) > 1 
           Exp_name= S(1:k(2)-1) 
        end
        
        if  Global_flags.Split_raster_into_intervals_and_analyze  % split raster from DB 
            Exp_name= [ Exp_name '_' num2str(Global_flags.Split_raster_period_min ) 'min_split' ] ; 
        end
        Filename_Analysis_ANALYSIS_cell_name = [ 'Compare_analysis_AA__' Exp_name   ] 
        Filename_Analysis_ANALYSIS_cell_file = [ Filename_Analysis_ANALYSIS_cell_name  '.mat' ] ;
        Filename_Analysis_ANALYSIS_cell  = [ ANALYSIS_ARG.DB_dir '\' Filename_Analysis_ANALYSIS_cell_file ]
        
        % if AA files reanalyzing
        if Global_flags.All_ExpContaires_reanalyze && isfield( Global_flags , 'original_AA_file' ) && ...
                    ~Global_flags.Split_raster_into_intervals_and_analyze 
            
           Filename_Analysis_ANALYSIS_cell_file = Global_flags.original_AA_file ;
           [pathstr,name,ext] = fileparts( Filename_Analysis_ANALYSIS_cell_file ) ;
          Filename_Analysis_ANALYSIS_cell_name = name ;
            
                up =userpath ; up(end)=[];
                   DB_dir_name = ANALYSIS_ARG.DB_dir ;
                DB_dir = [DB_dir_name ]; 
                Result_MAT_file_DATABASE =[ ANALYSIS_ARG.DB_dir '\' char(Filename_Analysis_ANALYSIS_cell_name)  '.mat' ]   ;    
                Result_MAT_file_DATABASE_default = Result_MAT_file_DATABASE;  

                Result_MAT_file_DATABASE_exists = false ;
                if exist(Result_MAT_file_DATABASE,'file') > 0
                    Result_MAT_file_DATABASE_exists = true; 
                else
%                     Result_MAT_file_DATABASE_name = [ char(Filename_Analysis_ANALYSIS_cell) ] ;
            %         filenames_DB = dir2( DB_dir , Result_MAT_file_DATABASE_name );
                    filenames_DB = dir2( DB_dir ,  '.mat'  );
                    n_files = length( filenames_DB ) ; 
                    for k= 1:n_files     
                        [pathstr,name,ext] = fileparts( filenames_DB{ k } ) ;
                        if strcmp( name , Filename_Analysis_ANALYSIS_cell_name )
                            Result_MAT_file_DATABASE_exists = true ;
                            Result_MAT_file_DATABASE = filenames_DB{ k } ;
                        end
                    end   
                end
                    
             if       Result_MAT_file_DATABASE_exists 
                         Filename_Analysis_ANALYSIS_cell =   Result_MAT_file_DATABASE ;
             end
        end
        
        if  isfield( Global_flags , 'original_AA_file' ) && ...
                   Global_flags.Split_raster_into_intervals_and_analyze  
                 
           original_file = Global_flags.original_AA_file ;
           [pathstr,original_name,ext] = fileparts( original_file ) ; 
          
           Result_MAT_file_DATABASE_exists = false ;   
            DB_dir_name = ANALYSIS_ARG.DB_dir ;
            DB_dir = [DB_dir_name ]; 
           filenames_DB = dir2( DB_dir ,  '.mat'  );
           n_files = length( filenames_DB ) ; 
                    for k= 1:n_files     
                        [pathstr,name,ext] = fileparts( filenames_DB{ k } ) ;
                        if strcmp( name  , original_name )
                            Result_MAT_file_DATABASE_exists = true ;
                            Result_MAT_file_DATABASE = filenames_DB{ k } ;
                        end
                    end 
          if Result_MAT_file_DATABASE_exists       
               [pathstr,name,ext] = fileparts( Result_MAT_file_DATABASE ) ;   
           Filename_Analysis_ANALYSIS_cell = [ pathstr '\' Filename_Analysis_ANALYSIS_cell_file ] ;
          end
        end
        
        else
            Filename_Analysis_ANALYSIS_cell = [ ANALYSIS_ARG.DB_dir '\' var.result_filename '.mat' ] ;
        end
        
        DateTime_created.Analysis_TimeAndDateAsVector = clock ;
        DateTime_created.Analysis_DateAsString = date ;
        Global_flags.DateTime_file_created = DateTime_created ;
        ALL_cell.Global_flags = Global_flags ;
        
        Filename_Analysis_ANALYSIS_cell
        
       Init_dir = cd ;
        up =userpath ; up(end)=[];
        cd(  up  )  
        Filename_Analysis_FULL_RESULT_ALL = 'ANAlYSIS_List_files_compare_connectivity.mat' ;  
        eval(['save ' Filename_Analysis_FULL_RESULT_ALL ' ANALYSIS_cell    Global_flags -mat']); 
        eval(['save ' Filename_Analysis_ANALYSIS_cell ' ALL_cell ANALYSIS_cell  Global_flags    -mat']); 
        cd( Init_dir )