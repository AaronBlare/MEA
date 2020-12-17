

%---------= CompPat_filelistprocess


if ANALYSIS_ARG.FILE_LIST_PROCESS  
    
 if ANALYSIS_ARG.FILE_LIST_list_files
filename = 0 ;
  if ANALYSIS_ARG.FILE_LIST_PROCESS_defined  
      filename = ANALYSIS_ARG.FILE_LIST_PROCESS_filename ;
      [PathName,filename,ext] =  fileparts( filename ) ; 
      PathName = [ PathName '\' ] ;
      filename = [ filename ext ] ;     
  else
    [filename,PathName] = uigetfile('*.*','Select file');
  end

  

  
    if ~isempty( filename ) || ANALYSIS_ARG.Take_all_DB_matfiles
       
        
            if  ~isempty( filename )
                fullname = [PathName filename ];  
                file_list = dataread('file', fullname , '%s', 'delimiter', '\n');
        %         filename = [ filenames_med filenames_mcd ];
                n_files = length(file_list ) ;
            end

        
        %---------- Load All mat files from DB ----------------
          if ANALYSIS_ARG.Take_all_DB_matfiles 
              if  ~strcmp(Experiment_type, 'Tetanisation') 
                  if ~strcmp(Experiment_type, 'ElSel_day_by_day')

        %      ANALYSIS_ARG.Path_with_DB_matfiles
               file_list0 = dir2( ANALYSIS_ARG.Path_with_DB_matfiles  ,'.mat');

                file_list = {} ;
                n_files = length( file_list0 ) ;
%                 n_files = 0 ;
                for k= 1:n_files         
                    [pathstr,name,ext] = fileparts( file_list0{ k } ) ;
                    pathstr;
                    if strcmp( ext , '.mat' )
                        file_list{ k } = name ;
                        n_files = n_files + 1 ;
                    end
                end 
                file_list = file_list' ;
                file_lists = file_list ;
                  end
              end
          end
         
    end        
        %------------------------------------------------------------
   end %  FILE_LIST_list_files    
        
if strcmp(Experiment_type, 'Connectivity_compare')  || strcmp(Experiment_type, 'Analyzed_data_compare')  || ...
                  strcmp(Experiment_type, 'Connectivity_Experiments_average' )...
                  || strcmp( Experiment_type, 'Analyzed_Experiments_average')    
              if ANALYSIS_ARG.FILE_LIST_PROCESS_ask_2file_sets
                file_lists = [] ;
                path_lists = [] ;
%                  usr = userpath ;
%                   usr(end) = [];
%                   usr = [ usr '\DB_meadata' ];
                  if ~isempty( ANALYSIS_ARG.Path_with_DB_matfiles )
                    cd( ANALYSIS_ARG.Path_with_DB_matfiles );
                  end

                    list_files =  uipickfiles ;
 

                    if length( list_files) > 0 
                        init_dir = cd ;
                        list_files{:};
                        n_files = length(list_files ) ;
                    end 
                    c_file  = char( list_files{ 1, end } ) ;
                     [pathstr, name, ext ] = fileparts(c_file)   ;
                     
                    file_lists(1).n_files = n_files ;
                    file_lists(1).file_list = list_files ;
                        
                    cd( pathstr )
                    n_files2 = 0 ;
                    
                    list_files2 = uipickfiles ;    
                    if length( list_files2 ) > 0    
                        list_files2{:};
                        n_files2 = length(list_files2 ) ;

                        for i = 1 :n_files2
                            list_files(end + 1) = list_files2( i ) ;
                        end

                        list_files{:}

%                         if strcmp( Experiment_type , 'Connectivity_compare' )
                            Global_flags.file_number_of_change = n_files ; 
%                         end
                        
                        file_lists(2).n_files = n_files2 ;
                        file_lists(2).file_list = list_files2 ;
                    end    
                    
                    file_list = list_files ;
                    for k= 1:length( file_list ) %---------------------------------------------------

                       c_file  = char( file_list{ 1, k } ) ;
                       [pathstr, name, ext ] = fileparts(c_file)   ;
                       file_list2{k} = [ name ext ] ;
                       path_lists2{k} = pathstr ;
                    end
                    file_list = file_list2';
                    
                    [file_list ,INDEX] = sort_nat( file_list );
                    
                    for k= 1:length( file_list ) %--------------------------------------------------- 
                     path_lists{ k } = path_lists2{ INDEX(k) };

                    end
                    
                    % for k= 1:n_files %---------------------------------------------------
                    %      
                    % c_file = char( list_files{ 1, k } ) 
              end
             

             
            files_step = 1 ;
            n_files= length(file_list  );
            
            if strcmp( Experiment_type , 'Connectivity_compare' )
%                 if Global_flags.Force_Reanalyze_bursts_connectiv
%                    n_files= size(file_list  );  
%                 else
                   n_files= size(file_list ) ;  
%                 end
            end
            
            if Global_flags.Files_in_exeperiment == 0 ;
                Global_flags.Files_in_exeperiment = n_files(1) ;
            end
            ANALYSIS_ARG.Select_pair_of_files = false ;
            ANALYSIS_ARG.Use_3_files = false ;
            ANALYSIS_ARG.file_lists = file_lists ;
            Global_flags.cycle_all_electrodes = false ;
        end  
        
   %--------- If info string in the filelist with some info (el-sel) -------     
%         if Global_flags.ElSel_auto_load_protocol 
        if strcmp(Experiment_type, 'Tetanisation') || strcmp(Experiment_type, 'ElSel_day_by_day')|| ...
            strcmp(Experiment_type, 'Stim_response_compare') 
            file_list_new = {} ;
             electrode_sel_param_Strings_files = {};
            fi_n = 0 ;
            fi_n_eslsel = 0 ;
            
             if strcmp(Experiment_type, 'Tetanisation')  || strcmp(Experiment_type, 'Stim_response_compare') 
                    for fi= 1 : n_files(1)  
                              %--- If fi - is a string with el-sel data
                              if mod( fi , Tet_files_in_exeperiment+1 ) == 0  
                                  fi_n_eslsel=fi_n_eslsel+1;
                                  electrode_sel_param_Strings_files( fi_n_eslsel ) =  file_list(fi) ;
                %                    Global_flags.electrode_sel_param = electrode_sel_param_from_string( file_list{fi} )   ;     
                                    % Input - Input_str 
                                    % Output -      
                                    %      electrode_sel_param.Start_channel 
                                    %      electrode_sel_param.Stimuli_to_each_channel  
                                    %      electrode_sel_param.Channel_step 
                                    %      electrode_sel_param.correct_protocol  
                                    %      electrode_sel_param.Channels_number         
                              else
                                  fi_n=fi_n+1;
                                 file_list_new(fi_n) =  file_list(fi)  ; 
                              end  
                    end
                   Global_flags.electrode_sel_param_Strings_files =electrode_sel_param_Strings_files ;
             end
             
             if strcmp(Experiment_type, 'ElSel_day_by_day') 
                    for fi= 1 : n_files(1)  
                              %--- If fi - is a string with el-sel data
                              if mod( fi , ElSel_files_in_exeperiment+1 ) == 0  
                                  fi_n_eslsel=fi_n_eslsel+1;
                                  electrode_sel_param_Strings_files( fi_n_eslsel ) =  file_list(fi) ;
                %                    Global_flags.electrode_sel_param = electrode_sel_param_from_string( file_list{fi} )   ;     
                                    % Input - Input_str 
                                    % Output -      
                                    %      electrode_sel_param.Start_channel 
                                    %      electrode_sel_param.Stimuli_to_each_channel  
                                    %      electrode_sel_param.Channel_step 
                                    %      electrode_sel_param.correct_protocol  
                                    %      electrode_sel_param.Channels_number         
                              else
                                  fi_n=fi_n+1;
                                 file_list_new(fi_n) =  file_list(fi)  ; 
                              end  
                    end
             end
            
            file_list = file_list_new ;
            
            % 1 2 3 , 4 5 6, 7 8 9, 10 11 12
            n_files = fi_n  ;
        else             
            n_files = n_files(1);
        end
%         end
       %--------- If info string in the filelist with some info (el-sel) -------         
       %-----------------------------------------------------------------------
       
%        Nexp = n_files(1)  ;
        Nexp=1;
        
        if strcmp(Experiment_type, 'Analyzed_data_compare')
               Nexp=  n_files(1)   ;
        end
        
        if strcmp(Experiment_type, 'Connectivity_compare')
            if Global_flags.Files_in_exeperiment == 0 
            Nexp = 1;
            else
               Nexp=  n_files(1) / Global_flags.Files_in_exeperiment  ;
            end
        end
       
       if strcmp(Experiment_type, 'Tetanisation') || strcmp(Experiment_type, 'ElSel_day_by_day')
            if ANALYSIS_ARG.Use_3_files 
                Nexp = n_files(1)/3 ;
            else
                Nexp = n_files(1)/2 ;
            end
       end
            if strcmp(Experiment_type, 'Tetanisation')
                Nexp = floor( n_files(1) / Tet_files_in_exeperiment )  ;
            end        

            if strcmp(Experiment_type, 'ElSel_day_by_day')
                Nexp = n_files(1)/ElSel_files_in_exeperiment ;
            end

    
   
else % Filelist ----

  [filename,pathname] = uigetfile('*.*','Select file');
        if  ANALYSIS_ARG.Analyze_one_file 
           if ~isempty( filename )
            fullname = [pathname filename ];
            n_files = 1 ;
           end 
        end

end





