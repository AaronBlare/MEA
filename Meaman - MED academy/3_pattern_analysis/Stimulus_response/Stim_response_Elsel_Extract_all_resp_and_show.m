% Stim_response_Elsel_Extract_all_resp_and_show

Patterns0 = Patterns ;

   figure
        Nx =  electrode_sel_param.Stimulation_channels_num ;
        Ny = 3 ;
        fh = [];
        Pi = [] ;
         
        for Selected_Stimulation_channel = 1 : electrode_sel_param.Stimulation_channels_num
            Selected_Stimulation_channel
%                 electrode_sel_param.Stimuli_to_each_channel = 30 ; % stimuli to each channel
%                 electrode_sel_param.Stimulation_channels = [ 1 2 4 5 ] ; % list of stim channels = [ 1 3 43 2 .. ]
%                 electrode_sel_param.Stimulation_channels_num  = length( electrode_sel_param.Stimulation_channels ) ; % stimuli to each channel
%                 electrode_sel_param.Selected_Stimulation_channel ;
                leave_index = 1 : electrode_sel_param.Stimuli_to_each_channel ;
                leave_index = leave_index + ( Selected_Stimulation_channel - 1 )*electrode_sel_param.Stimuli_to_each_channel ;
           delete_index = 1 : length( artefacts_origin   )  ;
          delete_index( leave_index ) = [] ;
          artefacts  = artefacts_origin(leave_index) ;

            N_responses = length(artefacts) ;  
            flags.Burst_Data_Ver = Burst_Data_Ver ; 
            fire_bins = floor(( Post_stim_interval_end -  Post_stim_interval_start) /  DT_bin) ; 
             %//////////////////////////////////////////    
             [ Patterns ] = Patterns_Get_Responses_in_Interval_from_Raster( N , artefacts ,index_r ,Post_stim_interval_start , ...
               Post_stim_interval_end  , DT_bin ,flags );
              % index_r, intervals post stim -> bursts burst_activation
              % One_sigma_in_channels ... 
             %//////////////////////////////////////////
             
                             
             
            Patterns.Normalize_responses = false; 
            var.simple_activation_patterns = true ;
            Patterns_get_Total_rates_Tactivation_from_bursts 
            
            Patterns_get_BIN_rates_from_bursts
            
            %--------Erase_Prestim_artifacts_Patterns------------------------------
            if Erase_Prestim_artifacts_Patterns
                
            buf = Global_flags.Erase_Inadequate_Patterns_preStim_show_raster ;
            Global_flags.Erase_Inadequate_Patterns_preStim_show_raster = false ;
            
            Analyze_preBursts_to_stim2
                    % input: filename
                    % output: Bad_artefacts_filt
            Global_flags.Erase_Inadequate_Patterns_preStim_show_raster = buf ;
            
                    responses_index = Bad_artefacts_filt ;
                    EraseIf_tru_otherwise_put_Zero = true ;
                    % responses_index EraseIf_tru_otherwise_put_Zero=true/false shoulkd be defined
                                 % before call
                    Stimulus_responses_Delete_responses
            end
            %--------------------------------------
                   
            Patterns_get_Statistsic_all_parameters
            
            Stim_chan8x8 = zeros( N, 1 );
            Stim_chan8x8( electrode_sel_param.Stimulation_channels( Selected_Stimulation_channel ) ) = 1; 
            
            
            %-- Figures 
%             Plot8x8Data( dat , new_figure , smooth_plot , MinV , MaxV , colorbaronvar )
            subplot( Ny , Nx , Selected_Stimulation_channel ); 
                Plot8x8Data( Stim_chan8x8 , false , false , 0 , 0 , false );
                title( [ 'Stim. # '  num2str( electrode_sel_param.Stimulation_channels( Selected_Stimulation_channel )) ] );
           
             cb1 = colorbar('southoutside'); 
             
           subplot( Ny , Nx , Selected_Stimulation_channel +  electrode_sel_param.Stimulation_channels_num ); 
                Plot8x8Data( Patterns.Spike_Rates_each_channel_mean , false, false , 0 , 0 , false );
                title( [ 'Spike rate # '  num2str( Selected_Stimulation_channel ) ] );
                
                cb1 = colorbar('southoutside'); 
                
%             xlabel('Electrode #')
%             ylabel('Electrode #')
            subplot( Ny , Nx , Selected_Stimulation_channel +2* electrode_sel_param.Stimulation_channels_num ); 
                Plot8x8Data( Patterns.Amp_each_channel_mean  , false, false , 0 , 0 , false );
                title( [ 'Ampliture # '  num2str( Selected_Stimulation_channel ) ] );
                
          Pi = [ Pi Patterns ] ;
          cb1 = colorbar('southoutside'); 
          
           
        end
%         colorbar('southoutside')
        
        %-- show all signatures 
        figure
         Ny = 1;
        for Si = 1 : electrode_sel_param.Stimulation_channels_num
         h = subplot( Ny , Nx , Si  );
         fh = [ fh h ] ;
             Data_Rate_Signature1 = Pi(Si).Spike_Rates_Signature';  
            x=1: Pi(Si).DT_bins_number ; y = 1:N;
            imagesc(  x * Pi(Si).DT_bin  , y ,  Data_Rate_Signature1 ); 
            title( [ 'Stim. #'  num2str( electrode_sel_param.Stimulation_channels( Si ) ) ] );
            xlabel( 'Time, ms' )
            ylabel( 'Electrode #' )
%             colorbar
            c  = colorbar('southoutside');
            c.Label.String = 'Spike rate';
        end
        linkaxes( fh , 'xy' );
        
        
         Patterns = Patterns0 ;
        