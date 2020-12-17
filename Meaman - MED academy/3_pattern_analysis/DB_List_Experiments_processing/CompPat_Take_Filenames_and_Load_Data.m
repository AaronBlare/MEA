
%--- CompPat_Take_Filenames_and_Load_Data


%              Analyze_2nd_file = true ;                      
             Analyze_2nd_file = false ;  

%++++++++++++ Decide which files we take for analysis +++++++++++++++++++++++
    if ANALYSIS_ARG.Select_pair_of_files 
        %++++ Load pair of files - sets of patterns
        [filename, pathname] = uigetfile('*.*','Select file') ;
        [filename2, pathname2] = uigetfile('*.*','Select file') ; 
        if ANALYSIS_ARG.Use_3_files
           [filename3 , pathname3 ] = uigetfile('*.*','Select file') ;  
        end
    end

    if ANALYSIS_ARG.FILE_LIST_PROCESS
  
         filename = file_list{ fi}  ;
         [pathname,filename] =  fileparts( filename ) ; 
         if ~Global_flags.Force_Reanalyze_bursts_connectiv && Analyze_2nd_file
             filename2=0;
             if fi+1 <= n_files
             filename2 = file_list{ fi+1 }  ;
             [pathname2 ,filename2 ] =  fileparts( filename2 ) ; 
             end
         end
         if ANALYSIS_ARG.Use_3_files
              filename3 = file_list{ fi+2 }  ;
             [pathname3 ,filename3 ] =  fileparts( filename3 ) ;   
         end
         
         if strcmp(Experiment_type, 'ElSel_day_by_day') 
                 filename = file_list{ ElSel_day_by_day_First_file_in_ex }  ;
                 [pathname,filename] =  fileparts( filename ) ; 
                 filename2 = file_list{ fi+1 }  ;
                 [pathname2 ,filename2 ] =  fileparts( filename2 ) ;  
            
         end
         
         if strcmp(Experiment_type, 'Tetanisation') 
                 filename = file_list{ ElSel_day_by_day_First_file_in_ex }  ;
                 [pathname,filename] =  fileparts( filename ) ; 
                 filename2 = file_list{ fi+1 }  ;
                 [pathname2 ,filename2 ] =  fileparts( filename2 ) ;  
            
         end         
         
         if strcmp(Experiment_type, 'Connectivity_compare') 
             if Global_flags.Comp_sequence_pairs
                 filename = file_list{ fi  }  ;
             else
                 filename = file_list{  1 }  ;
             end
                 [pathname,filename] =  fileparts( filename ) ; 
                 
                 if ~ Global_flags.Force_Reanalyze_bursts_connectiv && Analyze_2nd_file
                     if fi+1 <= n_files
                         filename2 = file_list{ fi+1 }  ;
                         [pathname2 ,filename2 ] =  fileparts( filename2 ) ;  
                     end
                 end
                 
                 if ANALYSIS_ARG.Use_3_files
                      filename3 = file_list{ fi+2 }  ;
                     [pathname3 ,filename3 ] =  fileparts( filename3 ) ;
                 end                 
            
         end   
         filename
         if ~ Global_flags.Force_Reanalyze_bursts_connectiv  && Analyze_2nd_file
         filename2
         end
          if ANALYSIS_ARG.Use_3_files
               filename3
          end
          
          
          %//////////////////////////////////////////////////////////////
          if strcmp(Experiment_type, 'Stim_response_compare') 
             
%               filename = file_list{ ElSel_day_by_day_First_file_in_ex }  ;
%                  [pathname,filename] =  fileparts( filename ) ; 
%                  filename2 = file_list{ fi+1 }  ;
%                  [pathname2 ,filename2 ] =  fileparts( filename2 ) ;  
              
%                  filename = file_list{ fi  }  ; 
%                  [pathname,filename,ext] =  filepart s( filename ) ; 
%                  
%                  
%                      if fi+1 <= n_files
%                          filename2 = file_list{ fi+1 }  ;
%                          [pathname2 ,filename2 ,ext] =  fileparts( filename2 ) ;  
%                      end
%              [ Patterns1 , POST_STIM_RESPONSE_exists ] = Load_PostStimResponse_file_or_DB( [pathname filename] );
%              [ Patterns2 , POST_STIM_RESPONSE_exists ] = Load_PostStimResponse_file_or_DB( [pathname2 filename2] );
              
            
         end 
         %////////////////////////////////////////////////////////////// 
    end
%-----------------------------------------------------    

%++++++++++++ Load files +++++++++++++++++++++++
        if strcmp(Experiment_type, 'ElSel_day_by_day')  ||  strcmp(Experiment_type, 'Tetanisation') 
             [ Patterns1 , POST_STIM_RESPONSE_exists ] = Load_PostStimResponse_file_or_DB( [pathname filename] );
             [ Patterns2 , POST_STIM_RESPONSE_exists ] = Load_PostStimResponse_file_or_DB( [pathname2 filename2] );

             if ANALYSIS_ARG.Use_3_files
                 [ Patterns3 , POST_STIM_RESPONSE_exists ] = Load_PostStimResponse_file_or_DB( [pathname3 filename3] );  
             end
         
%         if ~isempty( pathname )
%             cd( pathname ) ;
%         end
            [pathstr,name,ext] = fileparts ( filename ) ;
            File_name_x =name;
        end
        
        %----------------- AStim response load --------------------------------------        
        if strcmp(Experiment_type, 'Stim_response_compare') ||  strcmp(Experiment_type, 'Analyze_one_file_ElSel') 
            tic
             [ Patterns1 , POST_STIM_RESPONSE_exists ] = Load_PostStimResponse_file_or_DB( [pathname filename] ); 
            LoadFile_time_ms = toc
%             whos Patterns1
             
%         if ~isempty( pathname )
%             cd( pathname ) ;
%         end
            [pathstr,name,ext] = fileparts ( filename ) ;
            File_name_x =name;
        end        
        
%----------------- Analyzed_data_compare --------------------------------------        
        if strcmp( Experiment_type , 'Analyzed_data_compare' )
              [index_r , Raster_exists ,Raster_exists_with_other_sigma , Sigma_threshold_exists , RASTER_data ]...
                                = Load_raster_from_RASTER_DB(  filename , 0 );
                            
                    file_is_DB = false;          
                     if Raster_exists                           
                           Data_type = '' ;
                           Data_OK_for_analysis = false ;
                            if isfield(  RASTER_data , 'ANALYZED_DATA')
    %                            [index_r , Raster_exists ,Raster_exists_with_other_sigma , Sigma_threshold_exists , RASTER_data ]...
    %                                 = Load_raster_from_RASTER_DB(  filename , 0 ); 
    %                            if Raster_exists
                                   ANALYZED_DATA =  RASTER_data.ANALYZED_DATA ;
                                   Data_type = 'spontaneous' ;
                                   file_is_DB = true ; 
                                   
                                   Data_OK_for_analysis = true ;
                            end                        
                          Bursts_updated = false ;                           
                         
                     else
                        load( filename );
                        if exist( 'ANALYZED_DATA' ,'var' )
                            Data_OK_for_analysis = true ;
                        end
                     end
                     
                     Data_OK_for_analysis  
                 %=== Analyze next only if data is not Stimulus response                         
                     if Data_OK_for_analysis
                          if isfield( ANALYZED_DATA , 'Burst_Data_Ver' )
                                Burst_Data_Ver_curr_file = ANALYZED_DATA.Burst_Data_Ver ;
                              else
                                Burst_Data_Ver_curr_file = 1 ;
                              end
                              
                              Reanalyze_bursts = false ;
                              Reanalyze_bursts_from_origin = false ;
                              Bursts_old_version = true ;
                              if Burst_Data_Ver_curr_file >= Burst_Data_Ver
                                 Bursts_old_version  = false ;
                              end
                              Bursts_old_version
                              
                              if Burst_Data_Ver_curr_file <= Burst_Data_Ver_original_file_reanalyze
                                  Reanalyze_bursts_from_origin = true ;
                              end
                              
                              if Global_flags.Auto_upgrade_bursts_connectiv  &&   Bursts_old_version   
                                Reanalyze_bursts = true ;
                                Bursts_updated = false ;
                              end
                              
                              if Global_flags.Analyze_bursts_parameters_from_Gui 
                                  Search_Params = Global_flags.Find_bursts_GUI_input_Search_Params ;
                              else
                                  if isfield( RASTER_data , 'Parameters')
                                    Search_Params = RASTER_data.Parameters.Search_Params ;  
                                  else
                                    Search_Params = RASTER_data.ANALYZED_DATA.Flags{3}.Search_Params ;                                  
                                  end
                              end
                              
                              if Global_flags.Force_Reanalyze_only_bursts   
                                Reanalyze_bursts = true ;
                                Bursts_updated = false ;
                              end
                              
                              
                              Search_Params.Analyze_Connectiv  = false ;
                              params.show_figures = true ;
                              Data_type = 'spontaneous' ;
                              
                              
                              if Reanalyze_bursts_from_origin 
                                  Result_TXT_file_exists = false ;
                                  filenames_DB = dir2( MEA_DATA_folder ,  '.txt'  );
                                    n_files = length( filenames_DB ) ; 
                                    for k= 1:n_files     
                                        [pathstr,name,ext] = fileparts( filenames_DB{ k } ) ;
                                        if strcmp( name ,  RASTER_data.Experiment_name )
                                            Result_TXT_file_exists = true ;
                                            Result_TXT_file = filenames_DB{ k } ;
                                        end
                                    end  
                                  if Result_TXT_file_exists   
                                         RASTER_data.index_r = load( char( Result_TXT_file ) ) ; 
                                         Result_TXT_file
                                  end
                              end
                              
                              if  Reanalyze_bursts && file_is_DB
                                  Experiment_name0 = filename ;
                                  ready_to_analyze = true ;
                                  MED_file_raster_input  =false;
                                  Arg_file.Sigma_threshold = RASTER_data.Sigma_threshold   ;
                                  Arg_file.Experiment_name = RASTER_data.Experiment_name   ;
                                  Sigma_threshold = Arg_file.Sigma_threshold ;
                                  Experiment_name = Arg_file.Experiment_name ;
                                  Search_Params.save_bursts_to_files = false ;
                                    SHOW_FIGURES = Search_Params.Show_figures ;
                                    
                                    
                                  if  isfield( ANALYZED_DATA , 'ANALYZED_DATA_A')
                                      Search_Params.Chambers_Separate_analysis_AB = true ;
                                  end
                                    
                                  index_r = RASTER_data.index_r ;
                                  clear RASTER_data ;
                                  clear ANALYZED_DATA
                                  close all;
                                  
                                  Find_bursts_main_script
%                                     Find_bursts_from_raster
                                    % input:
                                    % index_r
                                    % Search_Params.show_figures
                                    % Search_Params.Simple_analysis
                                    % Search_Params.Filter_Superbursts
                                    % Search_Params.Filter_small_Superbursts
                                    % Search_Params.Simple_analysis    
                                
%                                   output - ANALYZED_DATA ;
                                    Bursts_updated = true 
                                    if strcmp( Data_type , 'spontaneous' ) 
    %                                             ANALYZED_DATA = ANALYZED_DATA  ;
                                                Sigma_threshold = 0 ;
                                                MED_file_raster_input = false ;
                                                Experiment_name = filename ;
%                                                 MEA_DB_Add_analyzed_bursts_to_DB % - Uses previous functions. Checks if raster is in the DB and adds Analyzed_data to          RASTER_DATA in DB           
                                                 % Input >>> Experiment_name Sigma_threshold (may be 0) ANALYZED_DATA
                                                 % index_r - if only no record in DB
                                    end
                                     if strcmp( Data_type , 'spontaneous' ) && ~file_is_DB
                                        MED_AWSR_Find_Bursts( filename ,  Search_Params)
                                     end
                              end
                     end
        end
%-----------------        
        
        
        
        
        
        if strcmp(Experiment_type,  'Connectivity_compare' )         
            
%----------------- Load 1st file --------------------------------------
%
%                    filename
                   if ~ANALYSIS_ARG.FILE_LIST_PROCESS
                        load( [ pathname  filename ] ); 
                   else
                       

                       [index_r , Raster_exists ,Raster_exists_with_other_sigma , Sigma_threshold_exists , RASTER_data ]...
                                = Load_raster_from_RASTER_DB(  filename , 0 );
                       filename_loaded1 = filename ;     
                       if Raster_exists
                           
                           Data_type = '' ;
                           Data_OK_for_analysis = true ;
                           if isfield(  RASTER_data , 'POST_STIM_RESPONSE')
%                            [ Patterns1 , POST_STIM_RESPONSE_exists ] = Load_PostStimResponse_file_or_DB(   filename  );
                               RASTER_data.ANALYZED_DATA = RASTER_data.POST_STIM_RESPONSE ;
%                                clear RASTER_data ;
                                Data_type = 'stimulus response' ;
                                Data_OK_for_analysis = false ;
                           end
                           
                          Bursts_updated = false ; 
                          
                        Data_OK_for_analysis  
                    %=== Analyze next only if data is not Stimulus response                         
                     if Data_OK_for_analysis
                                                           
                        [Connectiv_data ,Analysis_data_cell ,Analysis_data_cell_field_names ] =  ...
                                    DB_load_or_recalc_Analyzed_Data_from_RASTER_data( RASTER_data , Global_flags , filename );
                        % Connectiv_data                                         
                        %  Analysis_data_cell_field_names 
                        %  Analysis_data_cell
                          
                     end   %=== Analyze next only if da ....
                          
                       end
                       
                   end
               
%               if  Global_flags.Force_Reanalyze_bursts_connectiv && Data_OK_for_analysis
%                   clear Connectiv_data ;    
% %                   clear ANALYZED_DATA_1 ;
%               end
%               if Global_flags.Force_Reanalyze_only_connectiv && Data_OK_for_analysis
%                   clear Connectiv_data ;    
% %                   clear ANALYZED_DATA_1 ;
%               end

              
  
             
              if  Global_flags.Force_Reanalyze_bursts_connectiv  
                  Analyze_2nd_file = false ;
              end
              
              if   Global_flags.Force_Reanalyze_only_connectiv
                  Analyze_2nd_file = false ;
              end
                  
              if Analyze_2nd_file     
                   Connectiv_data1 =  Connectiv_data ;
                   Connectiv_data1_0 =  Connectiv_data ;

                   
                   if Global_flags.Show_compare_figure
%                        Connectiv_data = Connectiv_data1  ;
                       s = size( Connectiv_data.Connectiv_matrix_tau_of_max_M  );
                       N = s(1) ;
                       Connectiv_matrix_statistics_figures
                   end
                   
%----------------- Load 2nd file --------------------------------------                     
%                    filename2
                   if ~ANALYSIS_ARG.FILE_LIST_PROCESS
                        load( [ pathname2  filename2 ] );
                   else
                      [index_r , Raster_exists ,Raster_exists_with_other_sigma , Sigma_threshold_exists , RASTER_data ]...
                                = Load_raster_from_RASTER_DB(  filename2 , 0 );
                            
                        if Raster_exists
                           Data_type = '' ;
                           Data_OK_for_analysis = true ;
                           if isfield(  RASTER_data , 'POST_STIM_RESPONSE')
%                            [ Patterns1 , POST_STIM_RESPONSE_exists ] = Load_PostStimResponse_file_or_DB(   filename  );
                               RASTER_data.ANALYZED_DATA = RASTER_data.POST_STIM_RESPONSE ;
%                                clear RASTER_data ;
                                Data_type = 'stimulus response';
                                Data_OK_for_analysis = false ;
                           end
                           
                           
                          Bursts_updated = false ;  
                      
                  if Data_OK_for_analysis     
                            %-----------------------------------------------
                           %-----------------------------------------------                          
                            [Connectiv_data ,Analysis_data_cell2 ,Analysis_data_cell_field_names ] =  ...
                                    DB_load_or_recalc_Analyzed_Data_from_RASTER_data( RASTER_data , Global_flags , filename2);
                            % Connectiv_data                                         
                            %  Analysis_data_cell_field_names 
                            %  Analysis_data_cell
                         
%                                        Connectiv_data = ANALYZED_DATA.Connectiv_data ;
%                                        ANALYZED_DATA_2 = ANALYZED_DATA ;
%                                        clear ANALYZED_DATA ;
                           %-----------------------------------------------
                           %-----------------------------------------------                                       
                            
                  end     
%                           clear RASTER_data ;
                        end
                       
                   end
                   Connectiv_data2 =  Connectiv_data ;
                   Connectiv_data2_0 =  Connectiv_data ;

                   if Global_flags.Show_compare_figure
                       Connectiv_data = Connectiv_data2  ;
                       Connectiv_matrix_statistics_figures
                   end
%               end
              end
              
              %-----------------------------------------------
              %-----------------------------------------------
              
              
              
              
              
              
              
             if ANALYSIS_ARG.Use_3_files  
                   filename3
                   if ~ANALYSIS_ARG.FILE_LIST_PROCESS
                         load( [ pathname3  filename3 ] );    
                   else
                       [index_r , Raster_exists ,Raster_exists_with_other_sigma , Sigma_threshold_exists , RASTER_data ]...
                            = Load_raster_from_RASTER_DB(  filename3 , 0 ); 
                       if Raster_exists
                           ANALYZED_DATA =  RASTER_data.ANALYZED_DATA ;
                       end         
                   end
                           
                   Connectiv_data3 =  ANALYZED_DATA.Connectiv_data ;
                   Connectiv_data3_0 =  ANALYZED_DATA.Connectiv_data ;

                   Connectiv_data = Connectiv_data3  ;
                   Connectiv_matrix_statistics_figures 
             end
                   
        end