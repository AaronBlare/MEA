
function [Connectiv_data ,Analysis_data_cell ,Analysis_data_cell_field_names ] =  ...
            DB_load_or_recalc_Analyzed_Data_from_RASTER_data( RASTER_data , Global_flags , filename )
% Connectiv_data                                         
%  Analysis_data_cell_field_names 
%  Analysis_data_cell


%     %--- Burst analysis parameters --------------------
%     Find_bursts_GUI_input
%     %     Search_Params.SsuperBurst_scale_sec  
%     %     Search_Params.TimeBin  
%     %     Search_Params.AWSR_sig_tres 
%     %     Search_Params.save_bursts_to_files  
%     %     Search_Params.List_files2 
%     %     Search_Params.Arg_file 
%     %---------------------------------------------------
GLOBAL_CONSTANTS_load
Search_Params = Global_flags.Find_bursts_GUI_input_Search_Params ;

Reanalyze_bursts = false ;
%-- if Re-analyze bursts ----------- 

filename


                          if Global_flags.Force_Reanalyze_bursts_connectiv || Global_flags.Auto_upgrade_bursts_connectiv ...
                                  || Global_flags.Force_Reanalyze_only_bursts
                               
                              
                              if isfield( RASTER_data.ANALYZED_DATA , 'Burst_Data_Ver' )
                                Burst_Data_Ver_curr_file = RASTER_data.ANALYZED_DATA.Burst_Data_Ver ;
                              else
                                Burst_Data_Ver_curr_file = 1 ;
                              end
                              
                              Reanalyze_bursts = true ;
                              Bursts_old_version = true ;
                              if Burst_Data_Ver_curr_file >= Burst_Data_Ver
                                 Bursts_old_version  = false ;
                              end
                              Bursts_old_version
                              
                              if Global_flags.Auto_upgrade_bursts_connectiv  &&  ~Bursts_old_version   
                                Reanalyze_bursts = false ;
                                Bursts_updated = false ;
                              end
                              
                              if Global_flags.Force_Reanalyze_bursts_connectiv 
                                 Reanalyze_bursts = true ; 
                              end
                              if Global_flags.Force_Reanalyze_only_bursts 
                                 Reanalyze_bursts = true ; 
                              end
                              
        
                              if  Reanalyze_bursts && ~Global_flags.Split_raster_into_intervals_and_analyze 
                                  Search_Params.Analyze_Connectiv  = false ;
                                  params.show_figures = true ;
                                  Data_type = 'spontaneous' ;
                                  
                                  index_r = RASTER_data.index_r ;
                                  clear RASTER_data ;
                                  
                                  TimeBin = Search_Params.TimeBin ;
                                  
                                    Find_bursts_from_raster
                                    % input:
                                    % index_r
                                    % Search_Params.show_figures
                                    % Search_Params.Simple_analysis
                                    % Search_Params.Filter_Superbursts
                                    % Search_Params.Filter_small_Superbursts
                                    % Search_Params.Simple_analysis    
                                
                                    Plot_bursts_stats_many_graphs
                                    
%                                   output - ANALYZED_DATA ;
                                    Bursts_updated = true 
                              else
                                  ANALYZED_DATA =  RASTER_data.ANALYZED_DATA ; 
                              end 
                          else
                              if isfield(  RASTER_data , 'ANALYZED_DATA')
    %                            [index_r , Raster_exists ,Raster_exists_with_other_sigma , Sigma_threshold_exists , RASTER_data ]...
    %                                 = Load_raster_from_RASTER_DB(  filename , 0 ); 
    %                            if Raster_exists
                                   ANALYZED_DATA =  RASTER_data.ANALYZED_DATA ;
                                   Data_type = 'spontaneous' ;
%                                    clear RASTER_data ;
                              end
                          end
                          %-----------------------------------
                           
                          
                           
                             % split raster from DB
                              % %-----------------------------------
                              if Global_flags.Split_raster_into_intervals_and_analyze     
                                  Global_flags.Burst_Data_Ver =  Burst_Data_Ver ;
                                [ Analysis_data_cell_buf , Connectiv_data_buf , Analysis_data_cell_field_names ]  = ...
                                        Split_raster_into_periods_and_analyze( RASTER_data , Global_flags );
                              end
                              %-----------------------------------
                              
                              
                            Reanalyze_connectiv = false ;   
                              
%                            if ~isfield(  ANALYZED_DATA  , 'Connectiv_data' ) || Global_flags.Force_Reanalyze_bursts_connectiv
                           if  Global_flags.Force_Reanalyze_bursts_connectiv || Global_flags.Auto_upgrade_bursts_connectiv  || ...
                                    Global_flags.Force_Reanalyze_only_connectiv
                                if ~Global_flags.Split_raster_into_intervals_and_analyze
                                   %-- 
                                   Reanalyze_connectiv = true ;
                                   GLOBAL_CONSTANTS_load
                                   
                                   if Global_flags.Auto_upgrade_bursts_connectiv
                                   if Bursts_updated == false
                                      if isfield( ANALYZED_DATA ,'Connectiv_data' )
                                          if ANALYZED_DATA.Connectiv_data.params.Analysis_ver >=  GLOBAL_const.Connectiv_Analysis_ver
                                              Reanalyze_connectiv = false ;
                                          end
                                      end
                                   end
                                   end
                                   
                                   if Reanalyze_connectiv
                                       bursts_absolute = ANALYZED_DATA.bursts_absolute ;
                                       bursts = ANALYZED_DATA.bursts ;
    %                                    bursts  = ANALYZED_DATA.bursts ;
                                       Spike_Rates = ANALYZED_DATA.Spike_Rates ;
                                       Firing_Rates_each_channel_mean = ANALYZED_DATA.Firing_Rates_each_channel_mean ;
                                       Spike_Rates_each_channel_mean = ANALYZED_DATA.Spike_Rates_each_channel_mean ;
                                       Nb = ANALYZED_DATA.Number_of_Patterns ;
                                       s = size( ANALYZED_DATA.Spike_Rates ) ;
                                       N = s( 2 ) ;

                                       if isfield( ANALYZED_DATA , 'Burst_Data_Ver' )
                                        Burst_Data_Ver = ANALYZED_DATA.Burst_Data_Ver ;
                                       end

                                        Patterns_analysis_connectivity 
                                        % >>> Input: bursts or bursts_absolute , Spike_Rates  
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

                                            ANALYZED_DATA.Connectiv_data = Connectiv_data ; 
                                            
                                   end
                                end
                           end
                           %-----------------------------------------------
                           %-----------------------------------------------
                           
                           if  Reanalyze_bursts || Reanalyze_connectiv 
                               if ~Global_flags.Split_raster_into_intervals_and_analyze
                               
                                            if strcmp( Data_type , 'stimulus response')
                                                Add_PostStim_response_data_RASTER_DB( filename , 0 , ANALYZED_DATA );
                                            end
                                            if strcmp( Data_type , 'spontaneous' )
    %                                             ANALYZED_DATA = ANALYZED_DATA  ;
                                                Sigma_threshold = 0 ;
                                                MED_file_raster_input = false ;
                                                Experiment_name = filename ;
                                                MEA_DB_Add_analyzed_bursts_to_DB % - Uses previous functions. Checks if raster is in the DB and adds Analyzed_data to          RASTER_DATA in DB           
                                                 % Input >>> Experiment_name Sigma_threshold (may be 0) ANALYZED_DATA
                                                 % index_r - if only no record in DB
                                            end
%                                            Connectiv_data = ANALYZED_DATA.Connectiv_data ;
%                                            ANALYZED_DATA_1 = ANALYZED_DATA ;
%                                            clear ANALYZED_DATA ;
                               end
                           end
                           

                              
                           if ~Global_flags.Split_raster_into_intervals_and_analyze   
                                       ANALYZED_DATA_1 = ANALYZED_DATA ;
                                       if isfield( ANALYZED_DATA , 'Connectiv_data' )
                                           Connectiv_data = ANALYZED_DATA.Connectiv_data ;%
                                       else
                                           Connectiv_data = [] ;
                                       end
                                       Analysis_data_cell_field_names = ANALYZED_DATA.Analysis_data_cell_field_names ;
                                       Analysis_data_cell = ANALYZED_DATA.Analysis_data_cell ;     
                           else
                               Connectiv_data = Connectiv_data_buf ;%                                        
                               Analysis_data_cell_field_names = Analysis_data_cell_field_names ;
                               Analysis_data_cell = Analysis_data_cell_buf ;   
                           end
                                       
                           if exist( 'RASTER_data' , 'var')
                               clear RASTER_data
                           end
                           
%                                        Analysis_data_cell= [ Analysis_data_cell Analysis_data_cell ];
%                                        Connectiv_data = [ Connectiv_data Connectiv_data ] ;
                                       clear ANALYZED_DATA ;
                           %-----------------------------------------------
                           %-----------------------------------------------
                           %
