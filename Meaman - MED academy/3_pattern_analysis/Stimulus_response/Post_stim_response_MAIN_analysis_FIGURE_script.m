% Post_stim_response_MAIN_analysis_FIGURE_script
% Show main figure of the responses 
% POST_STIM_RESPONSE should be loaded before script

load( 'MEAchannel2dMap.mat');   

Ny = 8 ;
Nx = 8 ;

figures_f = [] ;
spikes_ms_all  = [] ;
spikes_amp_all = [] ;
FiI = 0 ;
figure
 for Fx = 1 : 8   
      for Fy = 1 : 8  
          FiI = FiI + 1  ;
        for i = 1 : N    
            spikes_ms_all  = [] ;
            spikes_amp_all = [] ;
            curr_channel = i ;
            CH_i = curr_channel ;
            chan_Y = MEA_channel_coords( curr_channel ).chan_Y_coord  ;
            chan_X = MEA_channel_coords( curr_channel ).chan_X_coord  ;
            if Fy == chan_X && Fx == chan_Y
               f = subplot( Ny , Nx , FiI ) ; 
               figures_f = [ figures_f f ] ;
               
              
               bursts = POST_STIM_RESPONSE.bursts ;
                 Nb = POST_STIM_RESPONSE.Number_of_Patterns ;
                 for bi = 1 : Nb
                  
                    spikes_ms =  POST_STIM_RESPONSE.bursts{ bi }{ curr_channel }  ;
                    if ~isempty( spikes_ms ) 
                    spikes_amps =  POST_STIM_RESPONSE.bursts_amps{ bi }{ curr_channel } ;
                   
                   
                   Thr_one_sigma = abs( POST_STIM_RESPONSE.One_sigma_in_channels( CH_i )) ; 
                    spikes_sigma_all  = spikes_amps  / Thr_one_sigma ;
%                     if Sigma_amp_filter > 0  
%                           
%                     ggg = find( abs( spikes_sigma_all ) < Sigma_amp_filter) ;
% %                     spikes_sigma_all( ggg ) = [] ;
%                     spikes_amps( ggg ) = [] ;
%                     spikes_ms( ggg ) = [] ;
%                     end
                    
                    spikes_ms_all = [ spikes_ms_all ; spikes_ms ] ;
                    spikes_amp_all = [ spikes_amp_all ; spikes_amps ] ;
%                     y_s =  y( floor( spikes_frames) ) ;
               
                    end
                 end
                  
                    hist_bins = 30 ;
                    times_all = spikes_ms_all ;
                    
%                     POST_STIM_RESPONSE.Poststim_interval_START
%                     POST_STIM_RESPONSE.Poststim_interval_END
%                     POST_STIM_RESPONSE.DT_bin
                    xx = POST_STIM_RESPONSE.Poststim_interval_START : POST_STIM_RESPONSE.DT_bin : ...
                        POST_STIM_RESPONSE.Poststim_interval_END ; 

                     NNN = hist_bins  ;
%                     subplot( 3 ,2 ,1 )
%                       hist( times_all , xx )

hold on
for i = 1 : numel(spikes_ms_all )
    x = [ spikes_ms_all( i ) spikes_ms_all( i ) ];
    y = [ 0 spikes_amp_all(i) ];
    plot( x , y , '-*' )
end
                      


%                         plot( spikes_ms_all , spikes_amp_all , '*' )
                      ylim auto
                      if Fx == 8 
                          xlabel( 'time, ms') 
                      end
                      
                      if Fy == 1 
                         ylabel( 'Spikes') 
                      end
                   
               
            end
        end
      end
 end
 linkaxes( figures_f , 'x' )
%  set(figures_f,'ylimmode','auto'); 
 xlim( [ POST_STIM_RESPONSE.Poststim_interval_START   POST_STIM_RESPONSE.Poststim_interval_END  ])


Post_stim_interval_str = [ int2str( POST_STIM_RESPONSE.Poststim_interval_START) '-' int2str( POST_STIM_RESPONSE.Poststim_interval_END) ' ms'] ;   

 f = figure ;
 
 if exist( 'Anallysis_Figure_title' , 'var' )
 if ~isempty( Anallysis_Figure_title )
    set(f, 'name', Anallysis_Figure_title ,'numbertitle','off' )
 end
 end

 Nx = 3 ;
 Ny = 4 ;
 


         subplot( Ny , Nx , 1 );    
    Plot8x8Data( POST_STIM_RESPONSE.Spike_Rates_each_channel_mean , false);
    xlabel('Electrode #')
    ylabel('Electrode #')
          title( ['Mean spike rate in ' Post_stim_interval_str ] )

         subplot( Ny , Nx , Nx + 1 );    
    Plot8x8Data( POST_STIM_RESPONSE.Amp_each_channel_mean , false);
    xlabel('Electrode #')
    ylabel('Electrode #')
          title( ['Mean Amplitude in ' Post_stim_interval_str ] )
          
          
           subplot( Ny , Nx , [2*Nx +  1]);
f = find( POST_STIM_RESPONSE.burst_activation_mean == 0 );
POST_STIM_RESPONSE.burst_activation_mean(f) = median( POST_STIM_RESPONSE.burst_activation_mean );
  Plot8x8Data( POST_STIM_RESPONSE.burst_activation_mean , false );
xlabel( 'Electrode #' )
ylabel( 'Electrode #' )
title( 'First spikes after stimulus' )
colorbar ;

%  subplot( 4 , 2 , [2 4]  );    
 subplot(  Ny , Nx ,  [ 2  1*Nx +  2] );  
 if isfield( POST_STIM_RESPONSE , 'Spike_Rates_Signature_1ms_smooth'  )
    Data_Rate_Signature1 =  POST_STIM_RESPONSE.Spike_Rates_Signature_1ms_smooth' ;
else
    Data_Rate_Signature1 = POST_STIM_RESPONSE.Spike_Rates_Signature';
end
%      Data_Rate_Signature1 = POST_STIM_RESPONSE.Spike_Rates_Signature'; 
                                              
    x=1: POST_STIM_RESPONSE.DT_bins_number ; y = 1:N;
    bb= imagesc(  x * POST_STIM_RESPONSE.DT_bin  , y ,  Data_Rate_Signature1 ); 
    title( ['Response profile, spikes/bin (' num2str( POST_STIM_RESPONSE.DT_bin ) ' ms)'] );
    xlabel( 'Post-stimulus time, ms' )
    ylabel( 'Electrode #' )
    colorbar
    
 subplot(  Ny , Nx ,  [ 3  1*Nx +  3] );  
 
  if isfield( POST_STIM_RESPONSE , 'Amps_Signature_1ms_smooth'  )
    Data_Rate_Signature1 =  POST_STIM_RESPONSE.Amps_Signature_1ms_smooth' ;
else
    Data_Rate_Signature1 = POST_STIM_RESPONSE.Amps_Signature';
  end

%      Data_Rate_Signature1 = POST_STIM_RESPONSE.Spike_Rates_Signature'; 
                                              
    x=1: POST_STIM_RESPONSE.DT_bins_number ; y = 1:N;
    bb= imagesc(  x * POST_STIM_RESPONSE.DT_bin  , y ,  Data_Rate_Signature1 ); 
    title( ['Response profile, uV/bin (' num2str( POST_STIM_RESPONSE.DT_bin ) ' ms)'] );
    xlabel( 'Post-stimulus time, ms' )
    ylabel( 'Electrode #' )
    colorbar


     subplot( Ny , Nx , [Nx*2 + 2  ]);
     TimeBins = 1 : POST_STIM_RESPONSE.DT_bins_number  ;   
         %------- Spikes per response histogram
%         figure   
        
        NNN = 10 ;
    [n,xout] = hist( POST_STIM_RESPONSE.Spike_Rates_each_burst , NNN ) ;
    n2 = n / length( POST_STIM_RESPONSE.Spike_Rates_each_burst )* 100 ;    
        bar(xout , n2 )
        title( 'Spikes per burst Histogram' )
        xlabel( 'Spikes per response')   
       ylabel( 'Count, %')
          
       subplot(  Ny , Nx , [Nx*2 + 3   ] ); 
            DT_step= POST_STIM_RESPONSE.DT_bin ;
               DT_bins_number=  POST_STIM_RESPONSE.DT_bins_number  ;
                Start_t =  POST_STIM_RESPONSE.Poststim_interval_START ;  
                TimeBins = 0 : DT_bins_number-1 ;  
                   TimeBins_x = Start_t + TimeBins * DT_step ;
                 TimeBins_x =   Patterns.TimeBins_x ;
%         barwitherr(TimeBin_Total_Spikes_std, TimeBin_Total_Spikes_mean ,TimeBins * DT_step);
%         barwitherr(TimeBin_Total_Spikes_std, TimeBin_Total_Spikes_mean );
 barwitherr2( POST_STIM_RESPONSE.TimeBin_Total_Spikes_std , TimeBins_x  , POST_STIM_RESPONSE.TimeBin_Total_Spikes_mean );
         title( ['PSTH'  ', bin=' int2str( POST_STIM_RESPONSE.DT_bin ) 'ms' ] )
        xlabel( 'Post-stimulus time, ms')
        ylabel( 'Spikes per bin')
        if length( TimeBins ) > 1
            axis( [ min( TimeBins_x  )- DT_step   max( TimeBins_x ) + DT_step   ...
                0 1.2 * max( POST_STIM_RESPONSE.TimeBin_Total_Spikes_std) ...
                 + max( POST_STIM_RESPONSE.TimeBin_Total_Spikes_mean) ] )
        end
        
%         subplot(4,2,[ 7 8 ])
%        subplot(Ny , Nx , [ Nx*4 + 1 Nx*4 + 2 ])  
       subplot(  Ny , Nx , [Nx*3 + 1  Nx*3 + Nx ] ); 
plot(  POST_STIM_RESPONSE.artefacts / 1000 , POST_STIM_RESPONSE.Spike_Rates_each_burst  , '-*')
title( 'Number of post-stimulus spikes')
xlabel( 'Stimulus time, s')
ylabel('Spikes #')




% COLOR PLOT, post stim spikes all channels all artefacts, RS -"--"--  --------------------------------------------   
%     imax = floor( POST_STIM_RESPONSE.artefacts(end) / 1000 ); 
%     mmm = zeros( imax , POST_STIM_RESPONSE.N_channels );
%     mmm(:,:)=NaN; 
%  for CHANNEL_i = 1 : POST_STIM_RESPONSE.N_channels 
%      for i=1:  length( POST_STIM_RESPONSE.artefacts   )  
%         mmm( floor( 1+ ( POST_STIM_RESPONSE.artefacts( i )  / 1000) ) , CHANNEL_i )= ...
%             POST_STIM_RESPONSE.Spike_Rates( i , CHANNEL_i ) ;
%      end
%  end
%      mmm = mmm';



    figure
%      subplot(1,2,1)
      x = 1:length( POST_STIM_RESPONSE.artefacts   ) ;
      y = 1:POST_STIM_RESPONSE.N_channels ;
%        imagesc(  x  , y ,  num_poststim_spikes_on_electrode_i'  )
        bb = imagesc(  x , y ,  POST_STIM_RESPONSE.Spike_Rates'   ) ;
%         set( bb ,'alphadata',~isnan(mmm))
        title( 'Post-stimulus spikes #' )
        xlabel('Stimulus nummber')
        ylabel('Electrode #')
    colorbar

if Global_flags.Stim_response_show_Signature_SignatureSTD_fig

    
    figure
    h1 = subplot( 1 , 2 , 1  );    
     Data_Rate_Signature1 = POST_STIM_RESPONSE.Spike_Rates_Signature';

    x=1: POST_STIM_RESPONSE.DT_bins_number ; y = 1:N;
    bb= imagesc(  x * POST_STIM_RESPONSE.DT_bin  , y ,  Data_Rate_Signature1 ); 
    title( ['Response profile, spikes/bin (' num2str( POST_STIM_RESPONSE.DT_bin ) ' ms)'] );
    xlabel( 'Post-stimulus time, ms' )
    ylabel( 'Electrode #' )
    colorbar

    
    
    h2 = subplot( 1 , 2 , 2  );    
     Data_Rate_Signature1_std = POST_STIM_RESPONSE.Spike_Rate_Signature_std';

    x=1: POST_STIM_RESPONSE.DT_bins_number ; y = 1:N;
    bb= imagesc(  x * POST_STIM_RESPONSE.DT_bin  , y ,  Data_Rate_Signature1_std ); 
    title( ['Response STD profile, spikes/bin (' num2str( POST_STIM_RESPONSE.DT_bin ) ' ms)'] );
    xlabel( 'Post-stimulus time, ms' )
    ylabel( 'Electrode #' )
    colorbar
end
