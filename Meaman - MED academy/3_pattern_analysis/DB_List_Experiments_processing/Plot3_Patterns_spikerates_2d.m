
% Plot3_Patterns_spikerates_2d

f0 =figure ;
      figure_title= [  'Spike rate'   ];
      set(f0, 'name',  figure_title ,'numbertitle','off' )
      flags.figure_details_str = figure_title ;
      
      subplot(2,1,1)
            hold on 
               plot( 1:length( Patterns1.artefacts ) , Patterns1.Spike_Rates_each_burst , '-*' ) 
               dt = length( Patterns1.artefacts );
               plot( dt + 1: dt + length( Patterns2.artefacts ) , Patterns2.Spike_Rates_each_burst , 'r-*' );
               dt = dt + length( Patterns2.artefacts );
               plot( dt + 1: dt + length( Patterns3.artefacts ) , Patterns3.Spike_Rates_each_burst , 'g-*' );
               legend( 'Patterns 1', 'Patterns 2', 'Patterns 3')
                title( [ 'Total ' figure_title ] )
                xlabel( 'Stimulus number')   
               ylabel(  flags.figure_details_str )   
            hold off
          
     subplot(2,1,2)
      x = 1:length( Patterns1.artefacts )+length( Patterns2.artefacts )... 
              +  length( Patterns3.artefacts ) + 2;
      y = 1:Patterns1.N_channels ; 
      
      maxval = max( [max(max(Patterns1.Spike_Rates)) max(max(Patterns2.Spike_Rates)) max(max(Patterns3.Spike_Rates)) ] ); 
      delim = Patterns1.N_channels:-1:1 ; 
      delim = 1 : -1/60: 0 ; delim(end)=[];
      delim = delim * maxval ;
      SR = [ Patterns1.Spike_Rates'  delim' Patterns2.Spike_Rates'  delim' Patterns3.Spike_Rates'  ];
        bb = imagesc(  x , y ,  SR    ) ;
%         set( bb ,'alphadata',~isnan(mmm))
%         title( 'Post-stimulus spikes #' )
        title(  flags.figure_details_str)
        xlabel('Stimulus nummber')
        ylabel('Electrode #')
    colorbar