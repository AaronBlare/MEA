% SimpleStat_2graph_plot


close all
 
  amps = Amplitudes_one_channel2 ;
  amps2 = Amplitudes_one_channel1 ;
   x_hist = -0.3 : 0.001 :0  ; % mV
   histo = histc( amps , x_hist );
    histo1 = 100 * histo / length( amps );
 
   histo = histc( amps2 , x_hist );
    histo2 = 100 * histo / length( amps2 );
    
    
figure
hold on
plot( x_hist * 1000, histo1 , 'Linewidth', 2)
% errorbar( x , data_mean , data_std )


plot( x_hist * 1000 , histo2 , 'r' , 'Linewidth', 2)
% errorbar( x , data_mean2 , data_std , 'r' )








