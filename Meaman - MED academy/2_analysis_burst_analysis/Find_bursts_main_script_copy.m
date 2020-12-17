

% Find_bursts_main_script

if ~exist( 'SHOW_FIGURES' , 'var' )
    SHOW_FIGURES = Search_Params.Show_figures ;
end
        % if using 6well raster then make 6 directories with split analysis results
Cycle_rasters_num = 1 ;
        if Search_Params.use6well_raster
            name_original = name ;
            Cycle_rasters_num = 6 ;
            Extract_6well_rasters ;
            original_dir = cd ;
        end
         
        if Search_Params.Chambers_Separate_analysis_AB
            name_original = name ;
            Cycle_rasters_num = 6 ;
            Extract_rasters_chambers

            % Eaxtract rasters A B AB
            % input : RASTER_data.index_r 
            % Global_flags.Search_Params.chamber_A_electrodes
            % Global_flags.Search_Params.chamber_B_electrodes
            % output : RASTER_data.index_r RASTER_data.index_rA RASTER_data.index_rB
            original_dir = cd ;            
        end        

 %=========================================================================
 %=========================================================================
for Raster_number = 1 : Cycle_rasters_num 
Save_to_DB_local = true ;
            % extract on eacg cycle  raster form 6well raster
params.show_figures = true ;
            if Search_Params.use6well_raster
                index_r  = index_r_6well_all.RASTER_data( Raster_number ).index_r ;
                params.show_figures = false ;
                if Search_Params.save_bursts_to_files
                    New_dir = [    '6well_raster_number_'  num2str( Raster_number ) ] ;
                    cd( original_dir );
                    mkdir(  New_dir  ); 
                    cd( New_dir ); 
                     Raster_file =[Experiment_name '_Raster_well_' int2str( Raster_number )  '.txt'  ] ; 
                    fid = fopen(Raster_file , 'w');
                    fprintf(fid, '%.3f  %d  %.4f\n', index_r');
                    fclose(fid);
                end
            end
            
            
%             if Global_flags.Search_Params.Chambers_Separate_analysis_AB
            if Search_Params.Chambers_Separate_analysis_AB
                
                params.show_figures = false ;
                params.show_detection_bursts = true ;
                Search_Params.Chamber_analysis_AB = false;   
                Search_Params.Chamber_analysis_BA = false;
                Search_Params.AWSR_sig_tres_original = Search_Params.AWSR_sig_tres  ;
                Write_file_in_separate_dir = true ;
               switch (Raster_number)
                   
                   case 1 
                       index_r = Chambers.RASTER_data.index_rA ;
                       
                       Chamber_str = 'A' ;
                       Anallysis_Figure_title = Chamber_str ;
                       Write_file_in_separate_dir = true ;
                       params.show_detection_bursts = true ;
                       params.show_figures = true ;
                       Save_to_DB_local = false ;
                       
                       if Global_flags.Search_Params.Burst_threshold_separateAB
                           Search_Params.MIN_channels_per_burst = Global_flags.Search_Params.MIN_channels_per_burstA ; 
                       end
                   case 2 
                       index_r = Chambers.RASTER_data.index_rB ;
                       Chamber_str = 'B' ;
%                        N = max( index_r(:,2) );
                       Anallysis_Figure_title = Chamber_str ;
                       Write_file_in_separate_dir = true ;
                       params.show_detection_bursts = true ;
                       params.show_figures = false ;
                       Save_to_DB_local = false ; 
                       if Global_flags.Search_Params.Burst_threshold_separateAB
                           Search_Params.MIN_channels_per_burst = Global_flags.Search_Params.MIN_channels_per_burstB ; 
                       end
                       
                   case 3     % Channels
                       if Global_flags.Search_Params.Burst_threshold_separateAB
                           Search_Params.MIN_channels_per_burst = Global_flags.Search_Params.MIN_channels_per_burst_channels ; 
                       end
                       
                       params.show_detection_bursts = false ;
                       index_r = Chambers.RASTER_data.index_rChan ;
                       Save_to_DB_local = false ;
%                        N = max( index_r(:,2) ); 
                       Write_file_in_separate_dir = true ; 
                       Chamber_str = 'Channels' ;
                       Anallysis_Figure_title = 'Channels' ;
                       Search_Params.Chamber_analysis_AB = false ;
                       Search_Params.Chamber_analysis_BA = false ;
                       if isfield( Search_Params , 'Chamber_A_electrodes')
%                         Search_Params.Chamber_analysis_A_electrodes = Search_Params.Chamber_A_electrodes ;
%                         Search_Params.Chamber_analysis_B_electrodes = Search_Params.Chamber_B_electrodes ;
                       else
                           ;
                       end
%                        Search_Params.Filter_small_bursts_origin = Search_Params.Filter_small_bursts ;
%                        Search_Params.Filter_small_bursts = false ;
                       params.show_detection_bursts = true ;                       
                    case 4     % BA
                        
                        if Global_flags.Search_Params.Burst_threshold_separateAB
                            
                            % Old ver
                           Search_Params.AWSR_sig_tres = Search_Params.AWSR_sig_tres_original  ; 
                           Search_Params.MIN_channels_per_burst = Global_flags.Search_Params.MIN_channels_per_burstA ; 
                        end
                        
                        
                        
                       
                       params.show_detection_bursts = false ;
                       
                       %% ?? index_r here but not index_rB ?????????
                       index_r = Chambers.RASTER_data.index_r ;
                       Save_to_DB_local = false ;
%                        N = max( index_r(:,2) ); 
                       Write_file_in_separate_dir = true ; 
                       Chamber_str = 'BA' ;
                       Anallysis_Figure_title = 'B->A';
                       Search_Params.Chamber_analysis_AB = true ;
                       Search_Params.Chamber_analysis_BA = true ; 
                        Search_Params.Simple_analysis  = false ; %  if  params.Simple_analysis - not adjust spike times
            
                       if Global_flags.Search_Params.Burst_threshold_separateAB
                           Search_Params.MIN_channels_per_burst = Global_flags.Search_Params.MIN_channels_per_burstB ; 
                       end
                       if isfield( Search_Params , 'Chamber_A_electrodes')
%                         Search_Params.Chamber_analysis_A_electrodes = Search_Params.Chamber_A_electrodes ;
%                         Search_Params.Chamber_analysis_B_electrodes = Search_Params.Chamber_B_electrodes ;
                       else
                           ;
                       end
                       Search_Params.Filter_small_bursts_origin = Search_Params.Filter_small_bursts ;
                       Search_Params.Filter_small_bursts = false ;
                       params.show_detection_bursts = true ;
                   case 5  % A->B
                       params.show_detection_bursts = false ;
                       index_r = Chambers.RASTER_data.index_r ;
                       Save_to_DB_local = false ;
%                        N = max( index_r(:,2) ); 
                       Write_file_in_separate_dir = true ; 
                       Chamber_str = 'AB' ;
                       Anallysis_Figure_title = 'A->B' ;
                       Search_Params.Chamber_analysis_AB = true ;
                       Search_Params.Chamber_analysis_BA = false ; 
                       Search_Params.Simple_analysis  = false ; %  if  params.Simple_analysis - not adjust spike times
                       if Global_flags.Search_Params.Burst_threshold_separateAB
                           Search_Params.MIN_channels_per_burst = Global_flags.Search_Params.MIN_channels_per_burstA ; 
                       end
                       
                   case 6 % all spikes
                       Search_Params.Filter_small_bursts = Search_Params.Filter_small_bursts_origin ;
                       index_r = Chambers.RASTER_data.index_r ; 
                       N = max( index_r(:,2) );
                       Search_Params.Chamber_analysis_AB = false ;
                       Search_Params.Chamber_analysis_BA = false ; 
                       Search_Params.AWSR_sig_tres = Search_Params.AWSR_sig_tres_original ;
                       Anallysis_Figure_title = 'Normal raster' ;
                       Write_file_in_separate_dir = false ;
                       Experiment_name =  Experiment_name0 ; 
                       Save_to_DB_local = true ;
                       cd( original_dir );
               end       
                       
              if  Write_file_in_separate_dir  && Search_Params.save_bursts_to_files
                New_dir = [    'Chamber_'  Chamber_str ] ;
                cd( original_dir );
                mkdir(  New_dir  ); 
                cd( New_dir );
%                 params.show_figures = false ;
                Experiment_name = [Experiment_name0 '_Raster_' Chamber_str    ] ; 
                Raster_file =[Experiment_name '.txt'  ] ; 
                fid = fopen(Raster_file , 'w');
                fprintf(fid, '%.3f  %d  %.4f\n', index_r');
                fclose(fid);
              end
            end
%------------------------------------------









% Search_Params.SB_min_duration = 
TimeBin = Search_Params.TimeBin ;
Filter_small_bursts = Search_Params.Filter_small_bursts  ;
AWSR_sig_tres = Search_Params.AWSR_sig_tres ;
save_bursts_to_files = Search_Params.save_bursts_to_files ;

Small_bursts_filter_Davies_Bouldin_index_Thr  = ...
    Search_Params.Small_bursts_filter_Davies_Bouldin_index_Threshold; % if its higher threshold than all responses are high
Filter_small_bursts_TYPE = Search_Params.Filter_small_bursts_TYPE ; % can be 'BurstDurations' or 'Spike_Rates_each_burst'  
 
 Search_Params.Filter_Superbursts ;  
% Search_Params.use6well_raster
% params.Simple_analysis = Search_Params.Simple_analysis ;

N = 60 ;


if ready_to_analyze %------------------------------------------ 

raster_size = size ( index_r );
if raster_size(1) >1 
    
    tic
        Find_bursts_from_raster
    toc
        % input:
        % index_r
        % Search_Params.show_figures
        % Search_Params.Simple_analysis
        % Search_Params.Filter_Superbursts
        % Search_Params.Filter_small_Superbursts
        % Search_Params.Simple_analysis    
    
    if  Search_Params.Chambers_Separate_analysis_AB    
      switch (Raster_number)
        case 1  % A
           ANALYZED_DATA_A = ANALYZED_DATA ;
           ANALYZED_DATA_A.Raster_spikerate = AWSR ; 
           ANALYZED_DATA_A.bursts_absolute = [] ;
           ANALYZED_DATA_A.bursts = [] ;
           ANALYZED_DATA_A.bursts_amps = [] ;
            Chamber_str = 'A' ;
            
%              figure
%            plot( ANALYZED_DATA.TimeBin_Total_Spikes_mean )
           
        case 2  % B
           ANALYZED_DATA_B = ANALYZED_DATA ;
           ANALYZED_DATA_B.Raster_spikerate = AWSR ; 
           ANALYZED_DATA_B.bursts_absolute = [] ;
           ANALYZED_DATA_B.bursts = [] ;
           ANALYZED_DATA_B.bursts_amps = [] ;
            Chamber_str = 'B' ;
        case 3  % Chan
           ANALYZED_DATA_Chan = ANALYZED_DATA ;
           ANALYZED_DATA_Chan.Raster_spikerate = AWSR ; 
           ANALYZED_DATA_Chan.bursts_absolute = [] ;
           ANALYZED_DATA_Chan.bursts = [] ;
           ANALYZED_DATA_Chan.bursts_amps = [] ;
            Chamber_str = 'Chan' ;            
        case 4  % BA
             Chamber_str = '' ;  
             N = N_origin ; 
           ANALYZED_DATA_BA = ANALYZED_DATA ;
           ANALYZED_DATA_BA.bursts_absolute = [] ;
           ANALYZED_DATA_BA.bursts = [] ;
           ANALYZED_DATA_BA.bursts_amps = [] ;    
           
%            figure
%            plot( ANALYZED_DATA.TimeBin_Total_Spikes_mean )
        case 5  % AB
             Chamber_str = '' ;  
             N = N_origin ; 
           ANALYZED_DATA_AB = ANALYZED_DATA ;
           ANALYZED_DATA_AB.bursts_absolute = [] ;
           ANALYZED_DATA_AB.bursts = [] ;
           ANALYZED_DATA_AB.bursts_amps = [] ; 
%            figure
%            plot( ANALYZED_DATA.TimeBin_Total_Spikes_mean )
         case 6  % normal
           
           
           Chamber_str = 'AB' ;
           if Search_Params.save_bursts_to_files
                New_dir = [    'Chamber_'  Chamber_str ] ;
                cd( original_dir );
                mkdir(  New_dir  ); 
                cd( New_dir );
%                 params.show_figures = false ;
                Experiment_name = [Experiment_name0 '_Raster_' Chamber_str    ] ; 
                Raster_file =[Experiment_name '.txt'  ] ; 
                fid = fopen(Raster_file , 'w');
                s = size( index_r );
                if s(2) == 3
                    fprintf(fid, '%.3f  %d  %.4f\n', index_r');
                else % s(2)==4
                    fprintf(fid, '%.3f  %d  %.4f %.4f\n', index_r');
                end
                fclose(fid);    
                Experiment_name = Experiment_name0 ;
                cd( original_dir );
           end
           
           Chambers_A_B_analyze_and_add  
           
      end
    end
    
    if save_bursts_to_files  
         
    	if Search_Params.use6well_raster
         name =  [ name_original '_6well_number_' num2str( Raster_number ) ];
        end
       finame = [ Experiment_name '_BURSTS_spikes' int2str(TimeBin) 'ms_TimeBin.mat' ] ;
    
    
    %---- Old-school file save ----------------
%         eval(['save ' char( finame ) ...
%             ' Statistical_ANALYSIS Statistical_ANALYSIS_median_values burst_activation bursts_absolute '...
%             ' bursts burst_start burst_max burst_end InteBurstInterval'...
%            ' BurstDurations Spike_Rates_each_burst Spike_Rates_Signature DT_BINS_number' ...
%            ' DT_bin Spike_Rates Spike_Rates_each_channel_mean Spike_Rates_each_channel_std '...
%            'Firing_Rates Firing_Rates_each_channel_mean  Firing_Rates_each_channel_std  ANALYZED_DATA  -mat']); 
    %-------------------------------------------
            eval(['save ' char( finame ) ...
            ' Statistical_ANALYSIS Statistical_ANALYSIS_median_values ANALYZED_DATA Parameters Experiment_name -mat']); 
    
        if ~Search_Params.make_Burst_ANALYSIS_RESULTS_file
        finame = [ name '_Burst_ANALYSIS_RESULTS_' int2str(TimeBin) 'ms_TimeBin.mat' ] ;
        eval(['save ' char( finame ) ' Statistical_ANALYSIS Statistical_ANALYSIS_median_values '...
            '  Experiment_name InteBurstInterval BurstDurations Spike_Rates_each_burst SUPERBURSTS -mat']); 
        end
        %---- End bursts analysis of the raster -------------

   
    
 if ~Search_Params.use6well_raster   
        
        if  MED_file_raster_input  && APPEND_DATA__TO_ORIGINAL_MAT_FILE

                eval(['save ' char( filename )...
            ' ANALYZED_DATA bursts_analyzed  -mat -append ']);      

        end
        
 end
    end
         if  MED_file_raster_input 
             Sigma_threshold = RASTER_data.Sigma_threshold ;
         end
         
         
        if Arg_file.Use_meaDB_raster
            Sigma_threshold = Arg_file.Sigma_threshold ;
            Experiment_name = Arg_file.Experiment_name ;
        end
     
         
    %>>>>>>>>>>>>>>>>>>>>>>>> DB MEA >>>>>>>>>>>>>>>>>>>>>>>>    
    if Global_flags.autosave_to_DB && Save_to_DB_local
     MEA_DB_Add_analyzed_bursts_to_DB 
    end
    % Input >>> Experiment_name Sigma_threshold (may be 0) ANALYZED_DATA, Parameters
    % index_r - if only no record in DB
    %>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>    
     
    
    if  Search_Params.use6well_raster     
    
%         Plot_bursts_stats_many_graphs
    end
end
    
end
 
  
%--- FIGURES ------------------------------

if SHOW_FIGURES && raster_size(1)>1
 
    Plot_bursts_stats_many_graphs
 
    if    save_bursts_to_files
        filename_fig = [ name '_Burst_analysis_' int2str(TimeBin) 'ms_TimeBin.fig' ] ;
    saveas(gcf, filename_fig ) ;
    end
 
%  if ~Search_Params.use6well_raster
if 1 > 0
 
Plot_Bursts_stat_color_figs

 end
     cascade
end
 
end