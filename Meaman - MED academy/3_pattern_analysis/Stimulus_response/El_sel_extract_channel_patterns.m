 % El_sel_extract_channel_patterns
% input: stim_chan_to_extract
% delete_index = 1 : Nb ;
% ... El_sel_extract_channel_patterns ...
% delete_index( leave_index ) = [] ;


 if strcmp( electrode_sel_param.type , 'Cycle' )
     
     
stim_chan_to_extract  = electrode_sel_param.stim_chan_to_extract ;
Start_channel = electrode_sel_param.Start_channel ; % electrode selection started from
Stimuli_to_each_channel  = electrode_sel_param.Stimuli_to_each_channel ; % stimuli to each channel
Channel_step = electrode_sel_param.Channel_step ;

Stimuli_to_each_channel=Stimuli_to_each_channel+1;

    % delete_index = 1 : Nb ;
    if stim_chan_to_extract == Start_channel
        leave_index = 1 : Stimuli_to_each_channel ;
    else
        if Start_channel == 1
            Start_channel = 0;
        end
        Start_chan=0;
        Step_fix = 0  ;
        if electrode_sel_param.correct_protocol 
           Start_chan= Start_channel ;
           Step_fix = 1 ;
           Start_chan = electrode_sel_param.Start_channel ;
        end
        stim_seq_num = ( stim_chan_to_extract - Start_chan  )/ Channel_step    ;
        leave_index = ( stim_seq_num ) * Stimuli_to_each_channel + 1 : ...
                  ( stim_seq_num ) * Stimuli_to_each_channel + Stimuli_to_each_channel ;

    end 
 end
 
 if strcmp(  electrode_sel_param.type , 'List' ) 
     Stimuli_to_each_channel = electrode_sel_param.Selected_Stimulation_channel ;
      leave_index = 1 :  electrode_sel_param.Stimuli_to_each_channel ;
      leave_index = leave_index + ( Stimuli_to_each_channel - 1 )*  electrode_sel_param.Stimuli_to_each_channel ; 
 end
 


% delete_index( leave_index ) = [] ;