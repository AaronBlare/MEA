function channel_i = Elsel_get_channel_number( stim_channel ,Global_flags)

if strcmp( Global_flags.electrode_sel_param.type , 'Cycle' )
                % get number of real channels from sequence of stim
                % electrodes ( Global_flags.electrode_sel_param )
                if stim_channel == 1
                    channel_i = Global_flags.electrode_sel_param.Start_channel ;
                else
                        Start_chan=0;
                        if Global_flags.electrode_sel_param.correct_protocol 
                           Start_chan= Global_flags.electrode_sel_param.Start_channel ;
                        end
                    channel_i = ( (stim_channel - 1) * Global_flags.electrode_sel_param.Channel_step + Start_chan  )  ;
                end 
end

if strcmp( Global_flags.electrode_sel_param.type , 'List' )
  channel_i =  Global_flags.electrode_sel_param.Stimulation_channels( stim_channel ); 
    
end

