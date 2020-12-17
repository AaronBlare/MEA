% draw_PSTH_SPIKE_RATES_2_patterns

figure
subplot(3,2,1);
barwitherr(Patterns1.TimeBin_Total_Spikes_std,TimeBins * DT_step , Patterns1.TimeBin_Total_Spikes_mean );
%  barwitherr( Patterns1.TimeBin_Total_Spikes_std  , TimeBins,Patterns1.TimeBin_Total_Spikes_mean)
         title( ['PSTH'  ', bin=' int2str( DT_step ) 'ms' ] )
        xlabel( 'Post-stimulus time, ms')
        ylabel( 'Spikes per bin')
        
        if max( Patterns1.TimeBin_Total_Spikes_mean )-min( Patterns1.TimeBin_Total_Spikes_mean ) > 0
             axis( [ min(TimeBins * DT_step) max(TimeBins * DT_step) 0 1.2 * max( Patterns1.TimeBin_Total_Spikes_std ) ...
             + max( Patterns1.TimeBin_Total_Spikes_mean ) ] )
        end
         
subplot(3,2,2)         
     NNN = 10 ;
    [n,xout] = hist( Patterns1.Spike_Rates_each_burst , NNN ) ;
    n2 = n / length( Patterns1.Spike_Rates_each_burst )* 100 ;    
        bar(xout , n2 )
        title( 'Spikes per burst Histogram' )
        xlabel( 'Spikes per response')   
       ylabel( 'Count, %')         
         

DT_step = Patterns2.DT_bin     ;
DT_bins_number = Patterns2.DT_bins_number ;
TimeBins = 1 : DT_bins_number ;

 subplot(3,2,3)
 barwitherr(Patterns2.TimeBin_Total_Spikes_std  ,TimeBins * DT_step , Patterns2.TimeBin_Total_Spikes_mean);
         title( ['PSTH'  ', bin=' int2str( DT_step ) 'ms' ] )
        xlabel( 'Post-stimulus time, ms')
        ylabel( 'Spikes per bin')
        if max( Patterns2.TimeBin_Total_Spikes_mean )-min( Patterns2.TimeBin_Total_Spikes_mean ) > 0
            axis( [ min(TimeBins * DT_step) max(TimeBins * DT_step) 0 1.2 * max( Patterns2.TimeBin_Total_Spikes_std ) ...
             + max( Patterns2.TimeBin_Total_Spikes_mean ) ] )
        end
         
 subplot(3,2,4)         
     NNN = 10 ;
    [n,xout] = hist( Patterns2.Spike_Rates_each_burst , NNN ) ;
    n2 = n / length( Patterns2.Spike_Rates_each_burst )* 100 ;    
        bar(xout , n2 )
        title( 'Spikes per burst Histogram' )
        xlabel( 'Spikes per response')   
       ylabel( 'Count, %')   
       
       
 subplot(3,2,5:6)     
        hold on
       plot( Patterns1.Spike_Rates_each_burst , '-*' )
       plot( Patterns2.Spike_Rates_each_burst , 'r-*')
       
       hold off
       legend( 'Patterns 1', 'Patterns 2')
        title( 'Spikes in responses' )
        xlabel( 'Stimulus number')   
       ylabel( 'Spikes #')          
       
       
       
       
       
       
       
       