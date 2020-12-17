

function image_h =  plot_burst_signature( Spike_Rate_Signature  , DT_step )

 Spike_Rate_Signature = Spike_Rate_Signature';
    s=size( Spike_Rate_Signature ) ;
    x=1: s( 2) ; y = 1: s(1) ;
    image_h = imagesc(  x *DT_step  , y ,  Spike_Rate_Signature  ); 
    title( ['Burst profile, spikes/bin (' num2str(DT_step) ' ms)'] );
    xlabel( 'Time offset, ms' )
    ylabel( 'Electrode #' )
    colorbar