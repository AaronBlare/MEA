

function [  TimeBin_Total_Spikes_1ms , TimeBin_Total_Spikes_std_1ms , Spike_Rate_Patterns_1ms  , ...
                    Spike_Rate_Signature_1ms ,  Spike_Rate_Signature_std_1ms ,  Spike_Rate_1ms_smooth_Max_corr_delay , ...
                   Spike_Rate_Signature_1ms_smooth , Amp_Patterns_1ms , Amps_Signature_1ms  , Amps_Signature_1ms_std , Amps_Signature_1ms_smooth , ...
                   Spike_Rate_1ms_Max_corr_delay , Spike_Rate_Signature_1ms_interp , DT_bin_interp ] = ...
             SR_profile_1ms_calc( Calc_Spikerate_profile_1ms_bin ,   N  , Nb ,bursts , bursts_amps , Search_Params , Mean_Burst_Duration )

         
         Check_and_Run_matlabpool
         
         Burst_Data_Ver=1;
if iscell( bursts )
         Burst_Data_Ver = 2 ;
end

if nargin == 6
    Mean_Burst_Duration = Search_Params.Spike_Rate_Signature_1ms_max_duration ;  
end

Calc_Spikerate_profile_1ms_interp  = Search_Params.Calc_Spikerate_profile_1ms_interp  ;

show_figures = false ;
Show_test_figures = show_figures ;
Spike_Rate_Signature_1ms_interp = [] ;
DT_bin_interp = 0 ;         
TimeBin_Total_Spikes_1m=[];
TimeBin_Total_Spikes_1ms = [] ;
TimeBin_Total_Spikes_std_1ms = [] ;
Spike_Rate_Patterns_1ms = [] ; 
Spike_Rate_1ms_smooth_Max_corr_delay= [] ; 
Spike_Rate_Signature_1ms_smooth= [] ; 
Amp_Patterns_1ms= [] ; 
Amps_Signature_1ms= [] ; 
Amps_Signature_1ms_std= [] ; 
Amps_Signature_1ms_smooth= [] ; 
Spike_Rate_1ms_Max_corr_delay= [] ; 
Spike_Rate_Signature_1ms_interp= [] ;  

              if  Calc_Spikerate_profile_1ms_bin
                   tic
                
                   DT_bin_1ms = 1 ;
                   End_t_1ms = Search_Params.Spike_Rate_Signature_1ms_max_duration ; %median(ANALYZED_DATA.BurstDurations) ;
                   
                    fire_bins_x=1 : DT_bin_1ms : End_t_1ms ;
                
                    if Calc_Spikerate_profile_1ms_interp 
                      Interp_Fract = Search_Params.Calc_Spikerate_profile_1ms_interp_factor ;
                           DT_bin_interp = DT_bin_1ms / Interp_Fract ;
                           fire_bins_new = 0 : DT_bin_interp : End_t_1ms ;   
                    else
                        Interp_Fract = 0 ;
                          DT_bin_interp = DT_bin_1ms ;
                          fire_bins_new=fire_bins_x;
                    end
                                 
                   
                              fire_bins_1ms = floor((End_t_1ms - 0) / DT_bin_1ms) ;
                              DT_BINS_number_1ms =fire_bins_1ms;
                              var.Spike_Rates_each_burst = []; 
                              var.Burst_Data_Ver = Burst_Data_Ver ;
                              var.N = N ;
%                               var.Find_only_SpikeRate = true ;  
                              var.Find_only_SpikeRate = false ;  
                              
                  if Burst_Data_Ver == 1       
                              [   TimeBin_Total_Spikes_1ms ,  TimeBin_Total_Spikes_mean_1ms , TimeBin_Total_Spikes_std_1ms , ...
                               Spike_Rate_Patterns_1ms ,  Spike_Rate_Signature_1ms ,  ... 
                               Spike_Rate_Signature_std_1ms , Amp_Patterns_1ms , Amps_Signature_1ms  , Amps_Signature_1ms_std] ...
                                  = Get_Electrodes_Rates_at_TimeBins_1pattern_for_Bursts( N , Nb ...
                                  , bursts , ...
                                  0 ,  End_t_1ms  , DT_bin_1ms  , [] ,var );
                  else
                        [   TimeBin_Total_Spikes_1ms ,  TimeBin_Total_Spikes_mean_1ms , TimeBin_Total_Spikes_std_1ms , ...
                               Spike_Rate_Patterns_1ms ,  Spike_Rate_Signature_1ms ,  ... 
                               Spike_Rate_Signature_std_1ms , Amp_Patterns_1ms , Amps_Signature_1ms  , Amps_Signature_1ms_std ] ...
                                  = Get_Electrodes_Rates_at_TimeBins_1pattern_for_Bursts( N , Nb ...
                                  , bursts  , ...
                                  0 ,  End_t_1ms  , DT_bin_1ms  , bursts_amps  ,var );
                  end

                  if Calc_Spikerate_profile_1ms_interp 
                    Spike_Rate_Signature_1ms_interp = zeros( length( fire_bins_new ) , N );
                  end
                     Spike_Rate_1ms_smooth_Max_corr_delay = zeros( N , N ) ;  
                     Spike_Rate_1ms_smooth_Max_corr_strength = zeros( N , N ) ;  
                     Spike_Rate_1ms_Max_corr_delay = zeros( N , N ) ;  
                     Spike_Rate_1ms_Max_corr_strength = zeros( N , N ) ;  
                     Spike_Rate_Signature_1ms_smooth = Spike_Rate_Signature_1ms ;
                     Spike_Rate_Signature_1ms_smooth( : ) = 0 ;
                     Amps_Signature_1ms_smooth = Spike_Rate_Signature_1ms ;
                     Amps_Signature_1ms_smooth(:)= 0 ;
                    
                     %--- get smooth signatures
                     if ~isnan( Mean_Burst_Duration )
                       parfor ch_i = 1 : N 
                            data_i = Spike_Rate_Signature_1ms( :  , ch_i  );
                            smooth_prfile_channel_i = smooth( data_i , Search_Params.Spike_Rate_Signature_1ms_smooth , 'loess' );
                            smooth_prfile_channel_i( smooth_prfile_channel_i <0 ) = 0 ;
                            Spike_Rate_Signature_1ms_smooth( :  , ch_i  ) = smooth_prfile_channel_i ; 
                            
                           % Amp signature smooth 
                            amp_prfile_channel_i = smooth( Amps_Signature_1ms( :  , ch_i  ) , Search_Params.Spike_Rate_Signature_1ms_smooth , 'loess' );  
                            amp_prfile_channel_i( floor( Mean_Burst_Duration * 1000) : end ) = 0 ;
                            Amps_Signature_1ms_smooth( :  , ch_i  ) = amp_prfile_channel_i ; 
                             
                            
                         if Calc_Spikerate_profile_1ms_interp
                            smooth_interp_prfile_channel_i = interp1( 1 : length( data_i ) , data_i , fire_bins_new ,'spline' );
                            smooth_interp_prfile_channel_i = smooth( smooth_interp_prfile_channel_i  ,Search_Params.Spike_Rate_Signature_1ms_smooth * Interp_Fract , 'loess' ); 
                            smooth_interp_prfile_channel_i( smooth_interp_prfile_channel_i <0 ) = 0 ; 
                            Spike_Rate_Signature_1ms_interp( :  , ch_i  ) = smooth_interp_prfile_channel_i ; 

%                             figure
%                             hold on
% %                             plot( fire_bins_x , smooth_prfile_channel_i , fire_bins_new , smooth_interp_prfile_channel_i , 'r' )
%                             plot(  fire_bins_x ,data_i ,'o')
%                             plot( fire_bins_x , smooth_prfile_channel_i ,  'LineWidth' , 2 )
%                             plot( fire_bins_new ,smooth_interp_prfile_channel_i , 'r', 'LineWidth' , 2 )                            
%                             legend( 'Spikerate 1 ms bin' , 'Spikerate 1 ms smooth' , 'Spikerate 1 ms spline' )
%                             hold off
                         end
                     end
                     %-------------------
%                      figure
%                       s=size( Amps_Signature_1ms ) ;
%                     x=1: s( 1) ; y = 1:N;
%                      imagesc(  x *1  , y ,  Amps_Signature_1ms'  ); 
%                      
%                      figure
%                       s=size( Amps_Signature_1ms_smooth ) ;
%                     x=1: s( 1) ; y = 1:N;
%                      imagesc(  x *1  , y ,  Amps_Signature_1ms_smooth'  ); 
%                      colorbar
                     
                     parfor ch_i = 1 : N 
                       for ch_j = 1 : N  
                         if ch_i ~= ch_j  
                                 data_i = Spike_Rate_Signature_1ms( :  , ch_i  );
                                 data_j = Spike_Rate_Signature_1ms( : ,  ch_j ); 
                                 
                                                                
                                 if Calc_Spikerate_profile_1ms_interp
                                     
                                        smooth_prfile_channel_i = Spike_Rate_Signature_1ms_interp( :  , ch_i  );
                                        smooth_prfile_channel_j = Spike_Rate_Signature_1ms_interp( :  , ch_j  ) ; 
                                        DT_bin_smooth_corr =  DT_bin_interp;
    %                                  figure 
    %                                  plot(  fire_bins_x ,data_j ,'o', fire_bins_new ,values , fire_bins_x , smooth_prfile_channel_j , 'r')
%                                      smooth_prfile_channel_i = smooth_interp_prfile_channel_i ;
%                                      smooth_prfile_channel_j = smooth_interp_prfile_channel_j ;
%                                      DT_bin = DT_bin_interp ; 
                                 else
                                    smooth_prfile_channel_i = Spike_Rate_Signature_1ms_smooth( :  , ch_i  );
                                    smooth_prfile_channel_j = Spike_Rate_Signature_1ms_smooth( :  , ch_j  ) ; 
                                    DT_bin_smooth_corr = DT_bin_1ms   ; 
                                 end 
                                     
                                 
                                 emptyval = NaN ;
                                 
                                 % correlation spikerate profile smooth
                                 % ---------------------------
%                                  max_corr_lag = floor(length( smooth_prfile_channel_j) /2 ) ;
                                 if mean( smooth_prfile_channel_i )>0 && mean(smooth_prfile_channel_j )>0
                                     [c,lags] = xcorr( smooth_prfile_channel_i , smooth_prfile_channel_j , ...
                                         floor(length( smooth_prfile_channel_j) /2 ) , 'coeff' );
                                 else
                                     c = [] ; lags = [] ;
                                 end  
                                 
                                    [m,i]=max(c);
                                    if ~isempty( i )  
                                      Max_corr_delay_smooth = ( lags( i(1) ) ) * DT_bin_smooth_corr ;
                                    else
                                      Max_corr_delay_smooth =emptyval ;
                                      m = emptyval ;
                                    end    
                                 % ---------------------------  
                                 Spike_Rate_1ms_smooth_Max_corr_delay( ch_i , ch_j ) = Max_corr_delay_smooth ;   
                                 Spike_Rate_1ms_smooth_Max_corr_strength( ch_i , ch_j ) = m ;  
                                  % ---------------------------    
                                 % correlation spikerate profile smooth
                                 if  mean( data_i )>0 &&   mean( data_j ) > 0 
                                 [c,lags] = xcorr( data_i , data_j , ...
                                     floor(length( data_i ) /2 ) , 'coeff' );
                                 else
                                    c = [] ; lags = [] ; 
                                 end
                                 [m,i]=max(c);
                                    if ~isempty( i )  
                                      Max_corr_delay = ( lags( i(1) ) ) * DT_bin_1ms ;
                                    else
                                      Max_corr_delay = emptyval ;
                                      m= emptyval ;
                                    end
                                 % ---------------------------  
                                 Spike_Rate_1ms_Max_corr_delay( ch_i , ch_j ) = Max_corr_delay ;    
                                 Spike_Rate_1ms_Max_corr_strength( ch_i , ch_j ) = m ;    
                                 % ---------------------------      
                                
                         end
                       end
                     end 
                     end
                     
                     if Show_test_figures
                     figure
                     Nx =2 ; Ny = 2;
                      
                     subplot( Ny, Nx , 1)
                     imagesc( Spike_Rate_1ms_smooth_Max_corr_delay )
                     xlabel( 'Electrode #')
                     ylabel( 'Electrode #')
                     title( 'Max correlation delays')
                     colorbar
                     axis square
                     
                     subplot( Ny, Nx , 2)
                     a = reshape( Spike_Rate_1ms_smooth_Max_corr_delay ,  1 , []);
                     a( a== NaN) = [] ;
                     hist( a , 100 )
                     xlabel( 'Max correlation delay, ms')
                     
                     subplot( Ny, Nx , 3)
                     imagesc( Spike_Rate_1ms_smooth_Max_corr_strength )
                     xlabel( 'Electrode #')
                     ylabel( 'Electrode #')
                     title( 'Max correlation strength')
                     colorbar
                     axis square
                     
                     subplot( Ny, Nx , 4)
                     a = reshape( Spike_Rate_1ms_smooth_Max_corr_strength ,  1 , []);
                     a( a== NaN) = [] ;
                     hist( a , 100 )
                     xlabel( 'Max correlation strength')
                     end
                     
                     Calc_Spikerate_profile_1ms_bin_PROC_TIME = toc
               else
                   TimeBin_Total_Spikes_1ms = [] ;
                   TimeBin_Total_Spikes_mean_1ms = [];
                   TimeBin_Total_Spikes_std_1ms = [];
                   
                   Spike_Rate_Patterns_1ms = [];
                   Spike_Rate_Signature_1ms = [];
                  
                   Spike_Rate_Signature_std_1ms = [];
                   Spike_Rate_1ms_smooth_Max_corr_delay=[];
                   Spike_Rate_1ms_Max_corr_delay = [] ;
                   
                     Spike_Rate_1ms_smooth_Max_corr_delay = zeros( N , N ) ;  
                     Spike_Rate_1ms_Max_corr_delay = zeros( N , N ) ;  
                     Spike_Rate_Signature_1ms_smooth = [] ;
                     Amps_Signature_1ms_smooth = [] ;
                     Amp_Patterns_1ms = [] ; 
                     Amps_Signature_1ms = [] ;
                     Amps_Signature_1ms_std = [] ;
              end
               
               
          if show_figures     
              figure
                  Nx = 2 ; Ny = 2 ;
                 f1 = subplot( Ny , Nx , 1 );
                  
                  fire_bins_1ms = 1 : floor( Search_Params.Spike_Rate_Signature_1ms_smooth / DT_bin_1ms );
                  
                    x=1:fire_bins_1ms; y = 1:N;
                    Spike_Rate_Signature2 = Spike_Rate_Signature_1ms';
                    bb= imagesc(  x *DT_bin_1ms  , y ,  Spike_Rate_Signature2    ); 
                    title( ['Spike_Rate_Signature_1ms'] );
                    xlabel( 'Time offset, ms' )
                    ylabel( 'Electrode #' )
                    colorbar
                    
                 f2 = subplot( Ny , Nx , 2 );
                   
                    x=1:fire_bins_1ms; y = 1:N;
                    Spike_Rate_Signature2 = Spike_Rate_Signature_std_1ms';
                    bb= imagesc(  x *DT_bin_1ms  , y ,  Spike_Rate_Signature2    ); 
                    title( ['Spike_Rate_Signature_std_1ms'] );
                    xlabel( 'Time offset, ms' )
                    ylabel( 'Electrode #' )
                    colorbar                    
                    
                 f3 = subplot( Ny , Nx ,  3 );
                    x=1:fire_bins_1ms; y = 1:N;
                    Spike_Rate_Signature2 = Spike_Rate_Signature_1ms_smooth';
                    bb= imagesc(  x *DT_bin_1ms  , y ,  Spike_Rate_Signature2    ); 
                    title( ['Spike_Rate_Signature_1ms_smooth '] );
                    xlabel( 'Time offset, ms' )
                    ylabel( 'Electrode #' )
                    colorbar
                    
                f4 = subplot( Ny , Nx , 4  );
                    
                    Spike_Rate_1_chan = Spike_Rate_Signature_1ms( : , 1 ) ;
                    Spike_Rate_1_chan_smooth = Spike_Rate_Signature_1ms_smooth( : , 1 ) ;
                    hold on
                    plot( Spike_Rate_1_chan );
                    plot( Spike_Rate_1_chan_smooth , 'r' , 'LineWidth' , 2  ); 
                    hold off
                    title( ['Spike_Rate_Signature_std_1ms'] );
                    xlabel( 'Time offset, ms' ) 
                    colorbar                       
                  
                    
                    linkaxes( [ f1 f2 f3 ] , 'xy' )
          end 
              
              
              
              
              
              
              
              