



% Convert 1d channel number to 2d
function [ channel_number_str , channel_number2d ]  = Meaman_electrode_num_1d_to_2d( channel_number )

% In channel_number = 1 
% Out channel_number_str = '47' 

%  channel_number = 21 ;

load( 'MEAchannel2dMap.mat');           
            
             xx =   MEA_channel_coords(channel_number).chan_X_coord  ;
             yy =  MEA_channel_coords(channel_number).chan_Y_coord;
             
  channel_number_str = [ num2str(    xx )          num2str(    yy  ) ] ;
       channel_number2d      = str2num( channel_number_str )  ;
             
             