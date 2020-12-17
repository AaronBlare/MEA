
% electrode_sel_param = electrode_sel_param_from_string( Input_str )

Input_str = 'Start_channel=5 Channel_step=4 number_of_channels=60 stimuli=30 correct_protocol=1';

[a b c d e ]= strread( Input_str , ...
   '%*s %d %*s %d %*s %d %*s %d %*s %d', 'delimiter', '= ');

%      electrode_sel_param.stim_chan_to_extract = 4 ;
     electrode_sel_param.Start_channel = a ; % electrode selection started from
     electrode_sel_param.Stimuli_to_each_channel = d ; % stimuli to each channel
     electrode_sel_param.Channel_step = b ;
     electrode_sel_param.correct_protocol = e ;
     electrode_sel_param.Channels_number =  c ; 
     
%      electrode_sel_param
     