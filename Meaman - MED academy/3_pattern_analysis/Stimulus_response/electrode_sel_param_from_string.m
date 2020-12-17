
function electrode_sel_param = electrode_sel_param_from_string( Input_str )
% Input - Input_str 
% Output -      
%      electrode_sel_param.Start_channel 
%      electrode_sel_param.Stimuli_to_each_channel  
%      electrode_sel_param.Channel_step 
%      electrode_sel_param.correct_protocol  
%      electrode_sel_param.Channels_number   

% Input_str = 'Cycle Start=5 Step=4 Last=60 Stimuli=30 Correct_protocol=1 Tet1=16 Tet2=18' ;
% Input_str = 'List Stimuli=30 Channels=1 3 43 2 12 53' ;

 a = strread( Input_str ,  '%s' ) ;
 
 electrode_sel_param = [] ;
 
 if strcmp( a{ 1 } , 'Cycle' )

[a b c d e f g]= strread( Input_str , ...
   '%*s %d %*s %d %*s %d %*s %d %*s %d %*s %d %*s %d' , 'delimiter', '= ');
 
%      electrode_sel_param.stim_chan_to_extract = 4 ;
     electrode_sel_param.Start_channel = a ; % electrode selection started from
     electrode_sel_param.Stimuli_to_each_channel = d ; % stimuli to each channel
     electrode_sel_param.Channel_step = b ;
     electrode_sel_param.correct_protocol = e ;
     electrode_sel_param.Last_channel = c ;
     electrode_sel_param.Tet1 = f ;
     electrode_sel_param.Tet2 = g ;
%      electrode_sel_param.Channels_number =  c ;
 electrode_sel_param.type = 'Cycle'  ;  
 
%                 electrode_sel_param.Tet1_linear_num = ( (electrode_sel_param.Tet1 - Start_chan) / electrode_sel_param.Channel_step  +1 )  ;
%                 electrode_sel_param.Tet2_linear_num = ( (electrode_sel_param.Tet2 - Start_chan) / electrode_sel_param.Channel_step  +1 )    ;
             if  electrode_sel_param.correct_protocol 
                  electrode_sel_param.Channels_number = floor( (  electrode_sel_param.Last_channel ...
                            -  electrode_sel_param.Start_channel )/  electrode_sel_param.Channel_step ) ; 
             else
                  electrode_sel_param.Channels_number = floor(   electrode_sel_param.Last_channel ...
                            /  electrode_sel_param.Channel_step ) + 1 ; 
             end     
                 Start_chan=0;
                 if  electrode_sel_param.correct_protocol 
                     Start_chan =  electrode_sel_param.Start_channel ;
                 end
             electrode_sel_param.Channels_number = floor( ( electrode_sel_param.Last_channel ...
                            - Start_chan  )/ electrode_sel_param.Channel_step ) ;
                        
                        
             if electrode_sel_param.Tet1 ~= electrode_sel_param.Start_channel
                 electrode_sel_param.Tet1_linear_num = ( (electrode_sel_param.Tet1 - Start_chan) / electrode_sel_param.Channel_step  +1 )  ;
             else
                 electrode_sel_param.Tet1_linear_num = 1 ;
             end
             if electrode_sel_param.Tet2 ~= electrode_sel_param.Start_channel
                electrode_sel_param.Tet2_linear_num = ( (electrode_sel_param.Tet2 - Start_chan) / electrode_sel_param.Channel_step  +1 )    ;
             else
                 electrode_sel_param.Tet2_linear_num = 1 ;
             end  
 end
 
 if strcmp( a{ 1 } , 'List' )
    % Input_str = 'List Stimuli=30 Channels=1 3 43 2 12 53' ;
    b = a{2} ;
    d = strread( b ,  '%*s  %d  ' , 'delimiter', '= ') ;
%     [a  ]= strread( Input_str ,  '%*s %*s %d %*s %d' , 'delimiter', '= ') ;
    Chan_k = strfind( Input_str , '=' );
    Input_str_Chan = Input_str( Chan_k(2)+1 : length( Input_str )  ) ;
    e = strread( Input_str_Chan ,  ' %d  '  ) ;
    
    electrode_sel_param.type = 'List'  ;  
    electrode_sel_param.Stimuli_to_each_channel = d ; % stimuli to each channel
    electrode_sel_param.Stimulation_channels = e ; % list of stim channels = [ 1 3 43 2 .. ]
    electrode_sel_param.Stimulation_channels_num  = length( e ) ; % stimuli to each channel
    electrode_sel_param.Channels_number= length( e ) ;
    electrode_sel_param.Tet1 = 1 ; % should be corrected if tetanized more than 2
    electrode_sel_param.Tet2 = 2 ;
     electrode_sel_param.Tet1_linear_num = 1 ;
     electrode_sel_param.Tet2_linear_num = 2 ;
 end
                
                
% Input_str
 
 
% correct protocol:     2 5 8 11 14
% not correct protocol: 2 3 6  9 12
%      electrode_sel_param
     