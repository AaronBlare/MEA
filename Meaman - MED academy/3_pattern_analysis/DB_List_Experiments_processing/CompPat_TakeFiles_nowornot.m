

%-- CompPat_TakeFiles_nowornot



  % take only sequence of files /  1-2 2-3   . 4-5 5-6 6-7 .  1 2 3 . 4 5 6    
        %  mod( fi , ElSel_files_in_exeperiment )
        if strcmp(Experiment_type, 'ElSel_day_by_day') 

            Experiment_number = floor( fi / ElSel_files_in_exeperiment )+1 ;
            
           if ElSel_day_by_day_First_file_in_ex + ElSel_files_in_exeperiment <= fi
               ElSel_day_by_day_First_file_in_ex = ElSel_day_by_day_First_file_in_ex + ...
                            ElSel_files_in_exeperiment ;
           end
            if mod( fi , ElSel_files_in_exeperiment ) == 0     
                Take_files = false ;
            else
                
            end

        end

        %------ Tetanisation ----------------%------ Tetanisation
        %----------------%------ Tetanisation ----------------
        if strcmp(Experiment_type, 'Tetanisation') || strcmp(Experiment_type, 'Stim_response_compare')
            
            Experiment_number = floor( fi / Tet_files_in_exeperiment )+1 ;
            File_number_in_Experiment  = fi - (Experiment_number-1) ;
            
           if Tetanisation_First_file_in_ex + Tet_files_in_exeperiment <= fi
               Tetanisation_First_file_in_ex = Tetanisation_First_file_in_ex + ...
                            Tet_files_in_exeperiment ;
           end
            
            if mod( fi - 1 , Tet_files_in_exeperiment ) == 0     
               Take_files = true ;

            end
            
%             if File_number_in_Experiment >= Tet_files_in_exeperiment
%                Take_files = false ; 
%             end    
        end
        %------ Tetanisation ----------------%------ Tetanisation
        %----------------%------ Tetanisation ----------------
        if strcmp(Experiment_type, 'Stim_response_compare') 
            Experiment_number = fi ;
        end
        
        if strcmp(Experiment_type, 'Tetanisation') || strcmp(Experiment_type, 'ElSel_day_by_day') ...
                || strcmp(Experiment_type, 'Stim_response_compare') 
                 
                if Global_flags.ElSel_auto_load_protocol
                    electrode_sel_param_Strings_files{ Experiment_number } 
                   %--- Extract el_sel protocol from string
                       Global_flags.electrode_sel_param =...
                       electrode_sel_param_from_string( electrode_sel_param_Strings_files{ Experiment_number } )   ;   
                   %---------------------------------------
                     if  Global_flags.Electrode_selection_extract_channel 
                        Global_flags.electrode_sel_param.stim_chan_to_extract = Global_flags.ElSel_stim_chan_to_extract ;
                     end                  
                   
                end
                if ~Global_flags.Electrode_selection_extract_channel 
                    Global_flags.electrode_sel_param.stim_chan_to_extract = Global_flags.ElSel_stim_chan_to_extract  ;
                end
        end
        