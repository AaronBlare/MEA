%Extract spike rates total from all stimuli channels from 3 patterns and
%plot color plot

% Color_responses_all_stim_channels

Electrode_selection_extract_channel = true ;
%      electrode_sel_param.stim_chan_to_extract = 56 ;
%      electrode_sel_param.Start_channel = 2; % electrode selection started from
%      electrode_sel_param.Stimuli_to_each_channel = 31 ; % stimuli to each channel
%      electrode_sel_param.Channel_step = 4 ;

     last_channel = floor(60 / electrode_sel_param.Channel_step );
     N = 60 ;
     stimuli_index = 1 ;
     Data_all = zeros( N , 3*electrode_sel_param.Stimuli_to_each_channel ) ;
     for chi = 1: electrode_sel_param.Channel_step :N ;
         chi_n = chi ;
         if chi == 1
            chi_n = electrode_sel_param.Start_channel ;
         end
         art_i_start = stimuli_index  ;
         art_i_end = stimuli_index -1  + electrode_sel_param.Stimuli_to_each_channel ;
         Data1 = Patterns1.Spike_Rates_each_burst(   art_i_start : art_i_end ) ;
         Data2 = Patterns2.Spike_Rates_each_burst(   art_i_start : art_i_end ) ;
         Data3 = Patterns3.Spike_Rates_each_burst(   art_i_start : art_i_end ) ;
         Data_line = [ Data1' Data2' Data3' ] ;
                   
%          Data_all = [ Data_all ; Data_line ] ;
            for i =1:3*electrode_sel_param.Stimuli_to_each_channel
                Data_all( chi_n , i ) = Data_line( i ) ;
            end
         
         stimuli_index  = stimuli_index  + electrode_sel_param.Stimuli_to_each_channel ;
     end   
    
     
  High_thr = (Pattern_filtering_settings.High_Resp_Thr_percent /100)* max(max( Data_all( :, : ))) ;
    for chi = 1 : N ;
       ind = find( Data_all( chi , :)> High_thr );
       Data_all( chi , ind ) = 0 ;
        
    end
  
     
           
    figure
      x = 1:3*electrode_sel_param.Stimuli_to_each_channel ;
      y = 1:N ; 
      SR = Data_all ;
        bb = imagesc(  x , y ,  SR    ) ;
%         set( bb ,'alphadata',~isnan(mmm))
        title( 'Post-stimulus spikes #' )
        xlabel('Stimulus nummber')
        ylabel('Stimulation electrode #')
    colorbar
    
    
    
    
    
    
    
    