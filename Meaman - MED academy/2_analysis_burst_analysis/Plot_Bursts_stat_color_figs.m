% Plot_Bursts_stat_color_figs

f = figure ;
if ~isempty( Anallysis_Figure_title )
    set(f, 'name', Anallysis_Figure_title ,'numbertitle','off' )
end

Ny = 2 ;
Nx = 3 ;
if Search_Params.Show_additional_profiles 
    Ny = 2  ;
    Nx = 4 ;
else
    Ny = 1 ;
    Nx = 3 ;
end

a =true ;
 if exist( 'burst_activation_3_smooth_1ms_mean' , 'var')      
         if ~isempty( burst_activation_3_smooth_1ms_mean  ) 
             a= false ;
         end
 end
 
b =true ;
 if exist( 'Spike_Rate_1ms_smooth_Max_corr_delay' , 'var')      
         if ~isempty( Spike_Rate_1ms_smooth_Max_corr_delay  ) 
             b= false ;
         end
 end
             
%  if a && b
%     Ny =1 ;
%  end
%         
%   if Global_flags.Search_Params.Chambers_Separate_analysis_AB      
% %       if exists( 'Raster_number' , 'var' )
%       if Raster_number == 3 % A-B analysis
%           Ny =2 ;
%       end
%   end
  
% subplot(Ny , Nx ,1)
subplottight(Ny , Nx ,1)
Nl = length( Total_firing_rates_each_channel )
 Plot8x8Data( Total_firing_rates_each_channel , false)
xlabel( 'Electrode #' )
ylabel( 'Electrode #' )
title( 'Firing rate, Hz' )
colorbar ;

% subplot(Ny , Nx ,2)
subplottight(Ny , Nx ,2)
 Plot8x8Data( burst_activation_mean , false)
xlabel( 'Electrode #' )
ylabel( 'Electrode #' )
title( 'Burst activation, ms' )
colorbar ;

if 1 > 2
[pathstr,name,ext,versn] = fileparts( filename ) ;
figname = [ name '_Burst_activation_' int2str(TimeBin) 'ms_TimeBin.fig' ] ;
saveas(gca,  figname ,'fig');
end

%  Plot8x8Data( burst_activation_normalized_mean )
% xlabel( 'Electrode #' )
% ylabel( 'Electrode #' )
% title( 'Average spike time in burst activation' )
% colorbar ;



% subplot(Ny , Nx ,3)
subplottight(Ny , Nx ,3)
%  Plot8x8Data( Spike_Rates_each_channel_mean , false );
  Plot8x8Data( Firing_Rates_each_channel_mean , false );
xlabel( 'Electrode #' )
ylabel( 'Electrode #' )
% title( 'Electrode spikes per burst' )
title( 'Firing rate per burst' )
colorbar ;

if 1 > 0
figname = [ name '_SpikeRate_' int2str(TimeBin) 'ms_TimeBin.fig' ] ;
% saveas(gca,  figname ,'fig');
end

fig_i = 4 ;

if exist( 'Amps_each_channel_mean' , 'var')
subplottight(Ny , Nx ,fig_i )
%  Plot8x8Data( Spike_Rates_each_channel_mean , false );
  Plot8x8Data( Amps_each_channel_mean , false );
xlabel( 'Electrode #' )
ylabel( 'Electrode #' )
% title( 'Electrode spikes per burst' )
title( 'Amp. per burst, <mV>' )
colorbar ;

fig_i = fig_i + 1 ;
end


if Search_Params.Show_additional_profiles
    if exist( 'burst_max_rate_delay_ms_mean' , 'var')

% subplot(Ny , Nx , Nx + 1 )
subplottight(Ny , Nx , fig_i  )
%  Plot8x8Data( Firing_Rates_each_channel_mean , false );
 Plot8x8Data( burst_max_rate_delay_ms_mean , false );

xlabel( 'Electrode #' )
ylabel( 'Electrode #' )
% title( 'Burst firing rate, spikes/s' )
    title( 'Burst max spike rate, ms' )

colorbar ;
fig_i = fig_i + 1 ;

end
% colormap hot

% if ~Simple_analysis  
if exist( 'burst_activation_3_smooth_1ms_mean' , 'var')
    if ~isempty( burst_activation_3_smooth_1ms_mean  ) 
%     subplot( Ny , Nx , Nx + 2 )
    subplottight(Ny , Nx ,fig_i )
    Plot8x8Data( burst_activation_3_smooth_1ms_mean   , false );
    xlabel( 'Electrode #' )
    ylabel( 'Electrode #' )
    title( 'Burst activation based on STD, ms' )
    colorbar ;
    fig_i = fig_i + 1 ;
    end
end
    
    
 if exist( 'Spike_Rate_1ms_smooth_Max_corr_delay' , 'var')      
   if ~isempty( Spike_Rate_1ms_smooth_Max_corr_delay  )
%     subplot( Ny , Nx , Nx + 3) 
    subplottight(Ny , Nx ,fig_i  )
     imagesc( 1:N, 1:N , Spike_Rate_1ms_smooth_Max_corr_delay  ); 
    xlabel( 'Electrode #' )
    ylabel( 'Electrode #' )
    title( 'Max spikerate cchannel-channel delay, ms' )
    axis square
    colorbar ;
    fig_i = fig_i + 1 ;
   end  
 end
 
end      
       
% end
% if 1 > 2
    if Search_Params.save_bursts_to_files
%         figname = [ name '_SpikePerBurst_' int2str(TimeBin) 'ms_TimeBin.fig' ] ;
        figname = [ name '_Electrode_analysis.fig' ] ;
        saveas(gca,  figname ,'fig');
    end

if 1 > 2
[pathstr,name,ext,versn] = fileparts( filename ) ;
figname = [ name '_AWSR_Bursts_' int2str(TimeBin) 'ms_TimeBin.fig' ] ;
% saveas(gcf,  figname ,'fig');
 
figname2 = [ name '_AWSR_data' int2str(TimeBin) 'ms_TimeBin.mat' ] ;
% saveas(  ,  figname2 ,'mat');
eval(['save ' char(figname2) ' AWSR -mat']); 
end
% cd( Init_dir ) ;





if Search_Params.Show_additional_profiles
% bb1 =  subplot( Ny , Nx ,[ 4  Nx+4  ] )    ;  
% bb1 =  subplot( Ny , Nx ,[ 4    ] )    ;    
bb1 =  subplottight(Ny , Nx , fig_i   ) ;

%     Spike_Rate_Signature = Spike_Rate_Signature';
if exist( 'Spike_Rate_Signature_1ms_smooth' , 'var')
    Spike_Rate_Signature = Spike_Rate_Signature_1ms_smooth' ;
    DT_step_plot= 1 ;
else
    Spike_Rate_Signature = Spike_Rate_Signature' ;
    DT_step_plot= DT_BIN_ms ;
end
%     Spike_Rate_Signature = Spike_Rate_Signature_1ms';
    
    s=size( Spike_Rate_Signature ) ;
    if s(2) == N
        Spike_Rate_Signature = Spike_Rate_Signature' ;
        s=size( Spike_Rate_Signature ) ;
    end
    x=1: s( 2) ; y = 1:N;
    imagesc(  x *DT_step_plot  , y ,  Spike_Rate_Signature  ); 
    axis square
    
    title( ['Burst profile, spikes/bin (' num2str(DT_step_plot) ' ms)'] );
    xlabel( 'Time offset, ms' )
    ylabel( 'Electrode #' )
    colorbar
    fig_i = fig_i + 1 ;
    
% bb2 = subplot( Ny , Nx ,[5   Nx+ 5  ] )   ;   
% bb2 = subplot( Ny , Nx ,[5     ] )   ;   
bb1 =  subplottight(Ny , Nx , fig_i  ) ;
    
%     Amps_Signature = Amps_Signature';

if exist( 'Spike_Rate_Signature_1ms_smooth' , 'var')
    Amps_Signature =  Amps_Signature_1ms_smooth' ;
else
    Amps_Signature = Amps_Signature' ;
end
%     Amps_Signature = Amps_Signature_1ms';
     s=size( Amps_Signature ) ;
     if s(1) ~= N
          Amps_Signature = Amps_Signature' ;
          s=size( Amps_Signature ) ;
     end
    x=1: s( 2) ; y = 1:N;
     imagesc(  x *DT_step_plot  , y ,  Amps_Signature  ); 
    axis square
     
    title( ['mV/bin (' num2str(DT_step_plot) ' ms)'] );
    xlabel( 'Time offset, ms' )
    ylabel( 'Electrode #' )
    colorbar
    fig_i = fig_i + 1 ;
    
    
    subplot( Ny, Nx, fig_i )
    
    imagesc(  1:Number_of_bursts  , 1:N ,  Spike_Rates'   );
        title( [ 'Spike Rates' ] );
        xlabel( 'Burst #' )
        ylabel( 'Electrode #' )
        colorbar
%         axis square
        fig_i = fig_i + 1 ;

        
 subplot( Ny, Nx, fig_i )
    
    imagesc(  1:Number_of_bursts  , 1:N ,  AmpRates'   );
        title( [ 'Amp Rates' ] );
        xlabel( 'Burst #' )
        ylabel( 'Electrode #' )
%         axis square
        colorbar   

    
%     linkaxes( [ bb1 bb2 ] , 'xy' )
    

  
    
    
    
end
 












