% draw_PSTH_SPIKE_RATES_2_or_3_patterns_from_buf

% Patterns1_to_draw  and Patterns2_to_draw [Patterns3_to_draw] should be defined before

% Can be defined before:
% flags.Draw_in_parent_figure
% flags.PlotY;
% flags.PlotX;
% flags.Draw_3_patterns
%
% EXAMPLE of use
% flags.Selectivity_figure_title = 'Normal Responses' ;
% Patterns1_to_draw = Patterns1 ;
% Patterns2_to_draw = Patterns2 ;
% flags.Draw_in_parent_figure = false ;
% flags.Draw_3_patterns = false ;
% draw_PSTH_SPIKE_RATES_2_or_3_patterns_from_buf

PlotY = 3 ;
PlotX = 2 ;  
SpikeRate_lineNum = 3 ; % in which line show spikerates
Draw_3_patterns = false ;

% Draw_in_parent_figure = false ;

    Draw_in_parent_figure =flags.Draw_in_parent_figure ;
    if flags.Draw_in_parent_figure
       PlotY = flags.PlotY ;
       PlotX = flags.PlotX ;
    end
  
    if isfield( flags , 'Draw_3_patterns')
        if flags.Draw_3_patterns == true
           SpikeRate_lineNum = 4 ;
           Draw_3_patterns = true;
           
           if ~flags.Draw_in_parent_figure
                PlotY = 4 ; 
           end
           
        end    
        

    
    end 
 
    
    
if ~Draw_in_parent_figure
   figure  
end 



%--------- Psth1 -------------------
% DT_bins_number = Patterns1_to_draw.DT_bins_number ;
DT_bins_number = length( Patterns1_to_draw.TimeBin_Total_Spikes_mean ) ;
DT_step = Patterns1_to_draw.DT_bin     ;
TimeBins = 0 : DT_bins_number-1 ; 
Start_t = 0 ;

if isfield( Patterns1_to_draw , 'Poststim_interval_START' )
 Start_t = Patterns1_to_draw.Poststim_interval_START ;  
end
        TimeBins_x = Start_t + TimeBins * DT_step ;
 
Psth1 = subplot(PlotY ,PlotX ,1 );
if ~isempty( Patterns1_to_draw.TimeBin_Total_Spikes_std ) && ~isempty( Patterns1_to_draw.TimeBin_Total_Spikes_mean )
    barwitherr( Patterns1_to_draw.TimeBin_Total_Spikes_std, TimeBins_x , Patterns1_to_draw.TimeBin_Total_Spikes_mean );

    %  barwitherr( Patterns1_to_draw.TimeBin_Total_Spikes_std  , TimeBins,Patterns1_to_draw.TimeBin_Total_Spikes_mean)
         title( ['PSTH'  ', bin=' int2str( DT_step ) 'ms (' flags.Selectivity_figure_title ')' ] )
        xlabel( 'Post-stimulus time, ms')
        ylabel( 'Spikes per bin')

        
        if max( Patterns1_to_draw.TimeBin_Total_Spikes_mean )-min( Patterns1_to_draw.TimeBin_Total_Spikes_mean ) > 0
             axis( [ min( TimeBins_x )-DT_step  max( TimeBins_x )+DT_step 0 1.2 * max( Patterns1_to_draw.TimeBin_Total_Spikes_std ) ...
             + max( Patterns1_to_draw.TimeBin_Total_Spikes_mean ) ] )
        end
end
        
        
%--------- Psth2 -------------------

DT_bins_number = length( Patterns2_to_draw.TimeBin_Total_Spikes_mean ) ;
DT_step = Patterns2_to_draw.DT_bin     ;
TimeBins = 0 : DT_bins_number-1 ;  
 if isfield( Patterns2_to_draw , 'Poststim_interval_START' )
 Start_t = Patterns2_to_draw.Poststim_interval_START ;  
end
        TimeBins_x = Start_t + TimeBins * DT_step ;

 Psth2 = subplot(PlotY ,PlotX ,PlotX+1 );
 
 if ~isempty( Patterns2_to_draw.TimeBin_Total_Spikes_std ) && ~isempty( Patterns2_to_draw.TimeBin_Total_Spikes_mean )
    barwitherr(Patterns2_to_draw.TimeBin_Total_Spikes_std  , TimeBins_x , Patterns2_to_draw.TimeBin_Total_Spikes_mean);
         title( ['PSTH'  ', bin=' int2str( DT_step ) 'ms' ] )
        xlabel( 'Post-stimulus time, ms')
        ylabel( 'Spikes per bin')
        if max( Patterns2_to_draw.TimeBin_Total_Spikes_mean )-min( Patterns2_to_draw.TimeBin_Total_Spikes_mean ) > 0
            axis( [ min( TimeBins_x )-DT_step max( TimeBins_x )+DT_step 0 1.2 * max( Patterns2_to_draw.TimeBin_Total_Spikes_std ) ...
             + max( Patterns2_to_draw.TimeBin_Total_Spikes_mean ) ] )
        end
 end
        
 if Draw_3_patterns       
    %-------- Psth2 -----------------------------       
    DT_bins_number = length( Patterns3_to_draw.TimeBin_Total_Spikes_mean ) ;
    DT_step = Patterns3_to_draw.DT_bin     ;
    TimeBins = 0 : DT_bins_number-1 ; 
%      Start_t = Patterns3_to_draw.Poststim_interval_START ; 
      if isfield( Patterns3_to_draw , 'Poststim_interval_START' )
         Start_t = Patterns3_to_draw.Poststim_interval_START ;  
     end
     
            TimeBins_x = Start_t + TimeBins * DT_step ;

     Psth3 =subplot(PlotY,PlotX,PlotX*2+1);
 if ~isempty( Patterns3_to_draw.TimeBin_Total_Spikes_std ) && ~isempty( Patterns3_to_draw.TimeBin_Total_Spikes_mean )     
     barwitherr(Patterns3_to_draw.TimeBin_Total_Spikes_std  , TimeBins_x , Patterns3_to_draw.TimeBin_Total_Spikes_mean);
             title( ['PSTH'  ', bin=' int2str( DT_step ) 'ms' ] )
            xlabel( 'Post-stimulus time, ms')
            ylabel( 'Spikes per bin')
            if max( Patterns3_to_draw.TimeBin_Total_Spikes_mean )-min( Patterns3_to_draw.TimeBin_Total_Spikes_mean ) > 0
                axis( [ min( TimeBins_x )-DT_step max( TimeBins_x )+DT_step 0 1.2 * max( Patterns3_to_draw.TimeBin_Total_Spikes_std ) ...
                 + max( Patterns3_to_draw.TimeBin_Total_Spikes_mean ) ] )
            end    
 end
 end
 
 
 
 

               
        
%--------- SRall_1 -------------------         
SRall_1 = subplot(PlotY ,PlotX , 2 );         
     NNN = 10 ;
    [n,xout] = hist( Patterns1_to_draw.Spike_Rates_each_burst , NNN ) ;
    n2 = n / length( Patterns1_to_draw.Spike_Rates_each_burst )* 100 ;    
        bar(xout , n2 )
        title( 'Spikes per burst Histogram' )
%         xlabel( 'Spikes per response')   
       ylabel( 'Count, %')         
         
%--------- SRall_2 -------------------         
 SRall_2 = subplot(PlotY,PlotX ,PlotX + 2 ) ;        
     NNN = 10 ;
    [n,xout] = hist( Patterns2_to_draw.Spike_Rates_each_burst , NNN ) ;
    n2 = n / length( Patterns2_to_draw.Spike_Rates_each_burst )* 100 ;    
        bar(xout , n2 )
%         title( 'Spikes per burst Histogram' )
        xlabel( 'Spikes per response')   
       ylabel( 'Count, %')   
           
       
      %--------- SRall_3 -------------------          
      if Draw_3_patterns 
          SRall_3 =   subplot(PlotY,PlotX , PlotX*2 +2 )  ;       
                 NNN = 10 ;
                [n,xout] = hist( Patterns3_to_draw.Spike_Rates_each_burst , NNN ) ;
                n2 = n / length( Patterns3_to_draw.Spike_Rates_each_burst )* 100 ;    
                    bar(xout , n2 )
%                     title( 'Spikes per burst Histogram' )
                    xlabel( 'Spikes per response')   
                   ylabel( 'Count, %')
      end

      
      
      
   if Draw_3_patterns 
      linkaxes( [Psth1 Psth2 Psth3] ,'xy');
      linkaxes( [SRall_1 SRall_2 SRall_3] ,'xy');
  else
      linkaxes( [Psth1 Psth2] ,'xy');
      linkaxes( [SRall_1 SRall_2] ,'xy');
  end 
       
            
         

 
       
% ---------------- Spike_Rates_each_burst ----------------
   if Draw_3_patterns 
        subplot(PlotY,PlotX ,PlotX * (SpikeRate_lineNum-1) +1  : PlotX*(SpikeRate_lineNum-1)+2 )     
        hold on
       plot( Patterns1_to_draw.Spike_Rates_each_burst , '-*' )
       plot( Patterns2_to_draw.Spike_Rates_each_burst , 'r-*')
       plot( Patterns3_to_draw.Spike_Rates_each_burst , 'g-*')
       
       hold off
       legend( 'Patterns 1', 'Patterns 2', 'Patterns 3')
        title( 'Spikes in responses' )
        xlabel( 'Stimulus number')   
       ylabel( 'Spikes #')      
       
   else
        subplot(PlotY ,PlotX, PlotX * (SpikeRate_lineNum-1) +1  : PlotX*(SpikeRate_lineNum-1)+2  )     
        hold on
       plot( Patterns1_to_draw.Spike_Rates_each_burst , '-*' )
       plot( Patterns2_to_draw.Spike_Rates_each_burst , 'r-*')       
       hold off
       legend( 'Patterns 1', 'Patterns 2')
       title( 'Spikes in responses' )
       xlabel( 'Stimulus number')   
       ylabel( 'Spikes #')     
  end 
     
       
       
       
       
       
       
       
       