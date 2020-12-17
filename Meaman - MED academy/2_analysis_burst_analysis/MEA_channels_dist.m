 function dist = MEA_channels_dist( i , j )
                
                load( 'MEAchannel2dMap.mat');  
                xstart = MEA_channel_coords( i ).chan_X_coord  ;  
                  ystart =  MEA_channel_coords( i ).chan_Y_coord ;    
                  
                  xend = MEA_channel_coords( j ).chan_X_coord   ;    
                  yend = MEA_channel_coords( j ).chan_Y_coord  ;  
                  
                  [th,dist  ] = cart2pol( [  xend - xstart ],[  yend - ystart ]);