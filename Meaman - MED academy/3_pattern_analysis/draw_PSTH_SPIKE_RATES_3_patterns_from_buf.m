% draw_PSTH_SPIKE_RATES_3_patterns_from_buf

% Patterns1_to_draw   and Patterns2_to_draw  Patterns3_to_draw  should be defined before

PlotY =  4 ;
DT_bins_number = Patterns1_to_draw.DT_bins_number ;
DT_step = Patterns1_to_draw.DT_bin     ;
TimeBins = 0 : DT_bins_number-1 ; 
 Start_t = Patterns1_to_draw.Poststim_interval_START ;
 Ent_t = Patterns1_to_draw.Poststim_interval_END ; 
        TimeBins_x = Start_t + TimeBins * DT_step ;

figure
%-------- Patterns 1 -----------------------------
subplot(PlotY,2,1);
barwitherr(Patterns1_to_draw.TimeBin_Total_Spikes_std, TimeBins_x  , Patterns1_to_draw.TimeBin_Total_Spikes_mean );
%  barwitherr( Patterns1_to_draw.TimeBin_Total_Spikes_std  , TimeBins,Patterns1_to_draw.TimeBin_Total_Spikes_mean)
         title( ['PSTH'  ', bin=' int2str( DT_step ) 'ms (' flags.Selectivity_figure_title ')' ] )
        xlabel( 'Post-stimulus time, ms')
        ylabel( 'Spikes per bin')
        
        if max( Patterns1_to_draw.TimeBin_Total_Spikes_mean )-min( Patterns1_to_draw.TimeBin_Total_Spikes_mean ) > 0
            axis( [ min( TimeBins_x )-DT_step  max( TimeBins_x )+DT_step 0 1.2 * max( Patterns1_to_draw.TimeBin_Total_Spikes_std ) ...
             + max( Patterns1_to_draw.TimeBin_Total_Spikes_mean ) ] )
        end
         
subplot(PlotY,2,2)         
     NNN = 10 ;
    [n,xout] = hist( Patterns1_to_draw.Spike_Rates_each_burst , NNN ) ;
    n2 = n / length( Patterns1_to_draw.Spike_Rates_each_burst )* 100 ;    
        bar(xout , n2 )
        title( 'Spikes per burst Histogram' )
        xlabel( 'Spikes per response')   
       ylabel( 'Count, %')         
         
%-------- Patterns 2 -----------------------------
DT_bins_number = Patterns2_to_draw.DT_bins_number ;
DT_step = Patterns2_to_draw.DT_bin     ;
TimeBins = 0 : DT_bins_number-1 ; 
 Start_t = Patterns2_to_draw.Poststim_interval_START ; 
        TimeBins_x = Start_t + TimeBins * DT_step ;
        
 subplot(PlotY,2,3)
 barwitherr(Patterns2_to_draw.TimeBin_Total_Spikes_std  , TimeBins_x , Patterns2_to_draw.TimeBin_Total_Spikes_mean);
         title( ['PSTH'  ', bin=' int2str( DT_step ) 'ms' ] )
        xlabel( 'Post-stimulus time, ms')
        ylabel( 'Spikes per bin')
        if max( Patterns2_to_draw.TimeBin_Total_Spikes_mean )-min( Patterns2_to_draw.TimeBin_Total_Spikes_mean ) > 0
            axis( [ min( TimeBins_x )-DT_step max( TimeBins_x )+DT_step 0 1.2 * max( Patterns2_to_draw.TimeBin_Total_Spikes_std ) ...
             + max( Patterns2_to_draw.TimeBin_Total_Spikes_mean ) ] )
        end
         
 subplot(PlotY,2,4)         
     NNN = 10 ;
    [n,xout] = hist( Patterns2_to_draw.Spike_Rates_each_burst , NNN ) ;
    n2 = n / length( Patterns2_to_draw.Spike_Rates_each_burst )* 100 ;    
        bar(xout , n2 )
        title( 'Spikes per burst Histogram' )
        xlabel( 'Spikes per response')   
       ylabel( 'Count, %')   
       
%-------- Patterns 3 -----------------------------       
DT_bins_number = Patterns3_to_draw.DT_bins_number ;
DT_step = Patterns3_to_draw.DT_bin     ;
TimeBins = 0 : DT_bins_number-1 ; 
 Start_t = Patterns3_to_draw.Poststim_interval_START ; 
        TimeBins_x = Start_t + TimeBins * DT_step ;

 subplot(PlotY,2,5)
 barwitherr(Patterns3_to_draw.TimeBin_Total_Spikes_std  , TimeBins_x , Patterns3_to_draw.TimeBin_Total_Spikes_mean);
         title( ['PSTH'  ', bin=' int2str( DT_step ) 'ms' ] )
        xlabel( 'Post-stimulus time, ms')
        ylabel( 'Spikes per bin')
        if max( Patterns3_to_draw.TimeBin_Total_Spikes_mean )-min( Patterns3_to_draw.TimeBin_Total_Spikes_mean ) > 0
            axis( [ min( TimeBins_x )-DT_step max( TimeBins_x )+DT_step 0 1.2 * max( Patterns3_to_draw.TimeBin_Total_Spikes_std ) ...
             + max( Patterns3_to_draw.TimeBin_Total_Spikes_mean ) ] )
        end
         
 subplot(PlotY,2,6)         
     NNN = 10 ;
    [n,xout] = hist( Patterns3_to_draw.Spike_Rates_each_burst , NNN ) ;
    n2 = n / length( Patterns3_to_draw.Spike_Rates_each_burst )* 100 ;    
        bar(xout , n2 )
        title( 'Spikes per burst Histogram' )
        xlabel( 'Spikes per response')   
       ylabel( 'Count, %')       
       
       
 subplot(PlotY,2,7:8)     
        hold on
       plot( Patterns1_to_draw.Spike_Rates_each_burst , '-*' )
       plot( Patterns2_to_draw.Spike_Rates_each_burst , 'r-*')
       plot( Patterns3_to_draw.Spike_Rates_each_burst , 'g-*')
       
       hold off
       legend( 'Patterns 1', 'Patterns 2', 'Patterns 3')
        title( 'Spikes in responses' )
        xlabel( 'Stimulus number')   
       ylabel( 'Spikes #')          
       
       
       
       
       
       
       
       