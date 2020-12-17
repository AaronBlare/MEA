  
% if patterns contain responses from stim of sequence of electrodes
function Patterns_out = EL_SEL_Extract_responses_from_stim_channel( Patterns , electrode_sel_param ) 

%% following parameters should be defined before
% stim_chan_to_extract  = electrode_sel_param.stim_chan_to_extract ;
% Start_channel = electrode_sel_param.Start_channel ; % electrode selection started from
% Stimuli_to_each_channel  = electrode_sel_param.Stimuli_to_each_channel  ; % stimuli to each channel
% Channel_step = electrode_sel_param.Channel_step ;
% example start =1, stimuli = 3 step = 5 : 1 1 1 5 5 5 10 10 10 15 15 15
% example start =3 , stimuli = 4 step = 5 : 3 3 3 3 8 8 8 8 13 13 13 13  
%----------
Nb = Patterns.Number_of_Patterns  ;

El_sel_extract_channel_patterns
delete_index = 1 : Nb ;
% ... El_sel_extract_channel_patterns ...
% delete_index( leave_index ) = [] ;


% leave_index = 1 : 30 ;
leave_index';
delete_index';
Patterns
if ~isempty( leave_index )
    if length( leave_index ) <  length( delete_index ) 
    delete_index( leave_index ) = [] ;
    else
        delete_index = [] ;
    end
end

% Patterns_out  = Erase_Some_Patterns( Patterns  , delete_index );

EraseIf_tru_otherwise_put_Zero = true ;
responses_index = delete_index ; 

Stimulus_responses_Delete_responses

Patterns_out = Patterns ;


