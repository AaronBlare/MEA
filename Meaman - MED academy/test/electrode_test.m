% electrode_test


load( 'MEAchannel2dMap.mat');           
            empty_electrodes = [ 1 1 ; 1 8 ; 8 1 ; 8 8 ] ;
            burst_acts = [] ; 
            a = [];
            for ch = 1 : N 
             xx = find( MEA_channel_coords(ch).chan_X_coord == empty_electrodes( :,1) );
             yy = find( MEA_channel_coords(ch).chan_Y_coord == empty_electrodes( :,2) );
             x =MEA_channel_coords(ch).chan_X_coord;
             y = MEA_channel_coords(ch).chan_Y_coord;
              
             a = [ a ; [ x y ] ] ;
             if length( xx ) * length( yy ) == 0 
                 burst_acts = [burst_acts burst_activation( t ,  ch ) ]  ;
             else
                 
                 ch
             end
            end
            a
            whos burst_acts
            min_sp = min( burst_acts ) 