function Compare_3_patterns_signatures_figure( Patterns1 , Patterns2 , Patterns3 , var)


    Spike_Rate_Signature_diff =  Patterns2.Spike_Rates_Signature - Patterns1.Spike_Rates_Signature  ;
    Spike_Rate_Signature_diff2 =  Patterns3.Spike_Rates_Signature - Patterns2.Spike_Rates_Signature  ;

Spike_Rate_Signature_1ms_smooth_diff = [] ;
if isfield( Patterns1 , 'Spike_Rate_Signature_1ms_smooth' ) && isfield( Patterns2 , 'Spike_Rate_Signature_1ms_smooth' )
    Spike_Rate_Signature_1ms_smooth_diff =  Patterns2.Spike_Rate_Signature_1ms_smooth - Patterns1.Spike_Rate_Signature_1ms_smooth  ;
end

Spike_Rate_1ms_smooth_Max_corr_delay_diff = [] ;
if isfield( Patterns1 , 'Spike_Rate_1ms_smooth_Max_corr_delay' ) && isfield( Patterns2 , 'Spike_Rate_1ms_smooth_Max_corr_delay' )
    Spike_Rate_1ms_smooth_Max_corr_delay_diff =  Patterns2.Spike_Rate_1ms_smooth_Max_corr_delay - Patterns1.Spike_Rate_1ms_smooth_Max_corr_delay  ;
end

%--- 3 patterns show stats --------------
%     Ny = 1;
%     Nx= 3 ;
%     figure
% 
%  subplot( Ny , Nx ,1)
%         Plot8x8Data( Patterns1.burst_activation_mean , false)
%         title( 'Activation #1')
%     subplot( Ny , Nx ,2)
%     	 Plot8x8Data( Patterns2.burst_activation_mean  , false)
%         title( 'Activation #2')
%     subplot( Ny , Nx ,3)
%          Plot8x8Data( Patterns3.burst_activation_mean  , false)
%         title( 'Activation #3')

    Ny = 3;
    Nx= 3 ;
    smooth = false ;
    figure
    
     minV = min( [Patterns1.Spike_Rates_each_channel_mean ; Patterns2.Spike_Rates_each_channel_mean ...
        ; Patterns3.Spike_Rates_each_channel_mean ] )  ;
     maxV = max( [Patterns1.Spike_Rates_each_channel_mean  ; Patterns2.Spike_Rates_each_channel_mean ; ...
         Patterns3.Spike_Rates_each_channel_mean ])       ; 
    subplot( Ny , Nx ,1);
        Plot8x8Data( Patterns1.Spike_Rates_each_channel_mean , false , smooth , minV , maxV )
        title( 'SR Profile #1')
    subplot( Ny , Nx ,2);
    	 Plot8x8Data( Patterns2.Spike_Rates_each_channel_mean  , false ,smooth , minV , maxV  )
        title( 'SR Profile #2')
    subplot( Ny , Nx ,3);
         Plot8x8Data( Patterns3.Spike_Rates_each_channel_mean  , false , smooth , minV , maxV )
        title( 'SR Profile #3')
 
        
    image_h1 =  subplot( Ny , Nx ,4);
     plot_burst_signature(  Patterns1.Spike_Rates_Signature  ,  Patterns1.DT_bin );
    title( 'Profile #1')
    image_h2 = subplot( Ny , Nx ,5);
     plot_burst_signature(  Patterns2.Spike_Rates_Signature  ,  Patterns1.DT_bin );
    title( 'Profile #2')
    image_h3 =  subplot( Ny , Nx ,6);
         plot_burst_signature(  Patterns3.Spike_Rates_Signature  ,  Patterns1.DT_bin );
        title( 'Profile #3')
   image_h4 =  subplot( Ny , Nx ,7)    ;
         plot_burst_signature(  Spike_Rate_Signature_diff  ,  Patterns1.DT_bin );
        title( 'Profile #2-#1')
     image_h5 =  subplot( Ny , Nx ,8)   ; 
        plot_burst_signature(  Spike_Rate_Signature_diff2  ,  Patterns1.DT_bin );
        title( 'Profile #3-#2')
        
        linkaxes( [ image_h1 image_h2 image_h3 image_h4 image_h5 ] , 'xy' )
     
     if isfield( var   , 'EL_SEL_stim_chan_to_extract' ) && var.EL_SEL_stim_chan_to_extract > 0 
         N = length( Patterns1.Spike_Rates_each_channel_mean  );

        Stim_chan_marker = zeros( 1,N);
        Stim_chan_marker(  var.EL_SEL_stim_chan_to_extract ) = 1 ;
        subplot( Ny , Nx ,9)
         Plot8x8Data( Stim_chan_marker  , false)
        title( 'Stimulation channel')
        
     end
     
     
 %------------------------------------ 