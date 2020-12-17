


% Conenctiv_Extract_Results_from_DB
% input: Arg_file.Experiment_name

% Connectiv_Analyze_connection_burst_profiles = true ;

GLOBAL_CONSTANTS_load

[index_r , Raster_exists ,Raster_exists_with_other_sigma , Sigma_threshold_exists , RASTER_data ]...
                                = Load_raster_from_RASTER_DB(  Arg_file.Experiment_name , 0 ); 
  if Raster_exists
      if isfield( RASTER_data , 'ANALYZED_DATA') 
          Connectiv_data  =  RASTER_data.ANALYZED_DATA.Connectiv_data ;
          s = size( Connectiv_data.Connectiv_matrix_tau_of_max_M  );
         N = s(1) ;
         
         
         ANALYZED_DATA = RASTER_data.ANALYZED_DATA ;
         DT_bin = 5  ;
         End_t = 200 ; %median(ANALYZED_DATA.BurstDurations) ;
          fire_bins = floor((End_t - 0) / DT_bin) ;
          DT_BINS_number =fire_bins;
          var.Spike_Rates_each_burst = []; 
          if ~isfield( ANALYZED_DATA , 'Burst_Data_Ver' )
             Burst_Data_Ver = 1 ;  
          else
            Burst_Data_Ver = ANALYZED_DATA.Burst_Data_Ver ;
          end
          var.Burst_Data_Ver = Burst_Data_Ver ;
          var.N = N ; 
          Nb = ANALYZED_DATA.Number_of_bursts ;
  
          
          
          
          
          
figure
Ny = 2 ;
Nx = 3 ;


subplot(Ny , Nx ,1)
 Plot8x8Data( ANALYZED_DATA.burst_activation_mean , false)
xlabel( 'Electrode #' )
ylabel( 'Electrode #' )
title( 'Burst activation, ms' )
colorbar ; 
 
subplot(Ny , Nx ,2)
 Plot8x8Data( ANALYZED_DATA.Spike_Rates_each_channel_mean , false );
xlabel( 'Electrode #' )
ylabel( 'Electrode #' )
title( 'Electrode spikes per burst' )
colorbar ; 

subplot(Ny , Nx , 3)
%  Plot8x8Data( Firing_Rates_each_channel_mean , false );
 Plot8x8Data( ANALYZED_DATA.burst_max_rate_delay_ms_mean , false );
xlabel( 'Electrode #' )
ylabel( 'Electrode #' )
% title( 'Burst firing rate, spikes/s' )
    title( 'Burst max spike rate, ms' )

colorbar ;
% colormap hot

% if ~Simple_analysis 
    if ~isempty( ANALYZED_DATA.burst_activation_3_smooth_1ms_mean  )
    subplot( Ny , Nx ,4)
    Plot8x8Data( ANALYZED_DATA.burst_activation_3_smooth_1ms_mean   , false );
    xlabel( 'Electrode #' )
    ylabel( 'Electrode #' )
    title( 'Burst activation based on STD, ms' )
    colorbar ;
    end 
       
   if ~isempty( ANALYZED_DATA.Spike_Rate_1ms_smooth_Max_corr_delay  )
    subplot( Ny , Nx ,5) 
     imagesc( 1:N, 1:N , ANALYZED_DATA.Spike_Rate_1ms_smooth_Max_corr_delay  ); 
    xlabel( 'Electrode #' )
    ylabel( 'Electrode #' )
    title( 'Max spikerate cchannel-channel delay, ms' )
    axis square
    colorbar ;
   end  
    

     if ~isempty( ANALYZED_DATA.Spike_Rate_1ms_smooth_Max_corr_delay  )
      
         burst_activation_amps_mean  = zeros( N,1); 
      for ch = 1 : N   
            burst_activation_amps_mean( ch  ) = mea_Mean_defined( ANALYZED_DATA.burst_activation_amps( : , ch ));   
      end 
      
    subplot( Ny , Nx ,6)  
      Plot8x8Data( burst_activation_amps_mean , false );

    xlabel( 'Electrode #' )
    ylabel( 'Electrode #' )
    title( 'burst_activation_amps_mean, ms' )
    axis square
    colorbar ;
   end          
          
          Connectiv_matrix_statistics_figures
          
          if Connectiv_figure_from_DB_Show_burst_profile
          
          [   TimeBin_Total_Spikes ,  TimeBin_Total_Spikes_mean , TimeBin_Total_Spikes_std , ...
           Data_Rate_Patterns1 ,  Data_Rate_Signature1 ,  ... 
           Data_Rate_Signature1_std ] ...
              = Get_Electrodes_Rates_at_TimeBins_1pattern_for_Bursts( N ,ANALYZED_DATA.Number_of_bursts  ,ANALYZED_DATA.bursts , ...
              0 ,  End_t  , DT_bin  ,ANALYZED_DATA.bursts_amps ,var );
          
          
%             subplot( 3,3,[ 3 6 9 ] )      
            figure
            x=1: DT_BINS_number; y = 1:N;
            Data_Rate_Signature1 = Data_Rate_Signature1';
            bb= imagesc(  x * DT_bin  , y ,  Data_Rate_Signature1  ); 
            title( ['Burst profile, spikes/bin (' num2str( DT_bin) ' ms)'] );
            xlabel( 'Time offset, ms' )
            ylabel( 'Electrode #' )
            colorbar
          
          
          end  
          
          
          
          
          
         
         
         
%              Simple_calc = SimpleCalc_Conns( N ,Connectiv_data , Connectiv_data.Connectiv_matrix_M_on_tau_not_fitted , ...
%              Connectiv_data.Total_Spike_Rates , Connectiv_data.Spike_Rates ) ;
%              Connectiv_data = Simple_calc ;
%           Connectiv_matrix_statistics_figures         



        if GLOBAL_const.Connectiv_Analyze_connection_burst_profiles
               One_pair_i = 42 ;
               One_pair_j  = 3 ;
               
               % burst figure
               DT_bin = 1 ;
               DT_bin0 = DT_bin;
               End_t = 300 ; %median(ANALYZED_DATA.BurstDurations) ;
                fire_bins_x=1:DT_bin:End_t ;
                
                    Interepolate_spike_rate_profile = true;
                                 Interp_Fract = 4 ;
                                 DT_bin_interp = DT_bin / Interp_Fract ;
                                 fire_bins_new = 1 : DT_bin / Interp_Fract : End_t ; 
                                 
               
               Nb = ANALYZED_DATA.Number_of_bursts ;
               s= size( ANALYZED_DATA.Spike_Rates ) ;
               burst_activation_mean = ANALYZED_DATA.burst_activation_mean ; 
               
               N = s(2) ;
%                Burst_Data_Ver = ANALYZED_DATA.Burst_Data_Ver;
            
%               One_pair.tau_of_max_M;
%               M_of_tau =  One_pair.M_on_tau_One_pair ;
                [One_pair_i,One_pair_j] = find(Connectiv_data.Connectiv_matrix_tau_of_max_M >= 3) ;
                One_pair_i = One_pair_i(1);
                One_pair_j = One_pair_j(1) ;

                x = Connectiv_data.Connectiv_matrix_M_on_tau( One_pair_i ,One_pair_j , :);
                M_of_tau = reshape( x , [] , 1 ) ;
                tau_max = Connectiv_data.Connectiv_matrix_tau_of_max_M( One_pair_i ,One_pair_j ) ;
                
               
                
                Ny =2 ; Nx = 3 ; 

                         
                         N=60  ;
                       
                              fire_bins = floor((End_t - 0) / DT_bin) ;
                              DT_BINS_number =fire_bins;
                              var.Spike_Rates_each_burst = []; 
                              var.Burst_Data_Ver = Burst_Data_Ver ;
                              var.N = N ;
                              var.Find_only_SpikeRate = true ;
                              
                              [   TimeBin_Total_Spikes1 ,  TimeBin_Total_Spikes_mean1 , TimeBin_Total_Spikes_std1 , ...
                               Data_Rate_Patterns1 ,  Data_Rate_Signature1 ,  ... 
                               Data_Rate_Signature1_std ] ...
                                  = Get_Electrodes_Rates_at_TimeBins_1pattern_for_Bursts( N ,ANALYZED_DATA.Number_of_bursts ...
                                  ,ANALYZED_DATA.bursts , ...
                                  0 ,  End_t  , DT_bin  ,ANALYZED_DATA.bursts_amps ,var );
                                                       
%                          [ TimeBin_Total_Spikes_1ms , TimeBin_Total_Spikes_mean_1ms , TimeBin_Total_Spikes_std_1ms , Spike_Rate_Patterns_1ms ...
%                    Spike_Rate_Signature_1ms , Spike_Rate_Signature_std_1ms , Spike_Rate_1ms_smooth_Max_corr_delay , ...
%                    Spike_Rate_Signature_1ms_smooth , Amp_Patterns_1ms , Amps_Signature_1ms  , Amps_Signature_1ms_std] = ...
%              SR_profile_1ms_calc( Calc_Spikerate_profile_1ms_bin ,  N , Nb ,bursts_cell_Nb_N , bursts_cell_amps_Nb_N , GLOBAL_const ) ;
           
                     Only_conn_profile_max_diff = zeros( N*N ,1 ) ;
                     Only_conn_connect_tau_pairs = zeros( N*N ,1 ) ;
                     Only_conn_max_corr_delays = zeros( N*N ,1 ) ;
                     Only_Tact_diff = zeros( N*N ) ;
                     All_pairs_max_corr_delays = zeros( N*N ,1) ;
                     All_pairs_max_corr_delays_real = zeros( N ,N ) ;
                     Matrix_rofile_max_diff = zeros( N , N ,1)  ;
                     N_active_pairs = 0 ;
                     pi = 0 ;
                     pi2=0;
                     max_corr_lag=0;
                     for ch_i = 1 : N 
                       for ch_j = 1 : N  
                         if ch_i ~= ch_j 
    %                               Connectiv_data.Connectiv_matrix_tau_of_max_M( ch_i , ch_j )> 0
    %                         ch_i = One_pair_i ;
    %                         ch_j = One_pair_j ;
                                 data_i = Data_Rate_Signature1( :  , ch_i  );
                                 data_j = Data_Rate_Signature1( : ,  ch_j );
        
    
                                 smooth_prfile_channel_i = smooth( data_i , GLOBAL_const.Spike_Rate_Signature_1ms_smooth  , 'loess' );
                                 smooth_prfile_channel_j = smooth( data_j  ,GLOBAL_const.Spike_Rate_Signature_1ms_smooth  , 'loess' ); 
                                 
                                 if Interepolate_spike_rate_profile
                                     smooth_interp_prfile_channel_j = interp1( 1 : length( data_j ) , data_j , fire_bins_new ,'spline' );
                                     smooth_interp_prfile_channel_j = smooth( smooth_interp_prfile_channel_j  ,GLOBAL_const.Spike_Rate_Signature_1ms_smooth * Interp_Fract , 'loess' ); 

                                     smooth_interp_prfile_channel_i = interp1(1 : length( data_i ) , data_i , fire_bins_new ,'spline' );
                                     smooth_interp_prfile_channel_i = smooth( smooth_interp_prfile_channel_i  ,GLOBAL_const.Spike_Rate_Signature_1ms_smooth * Interp_Fract , 'loess' );
%                                      figure 
%                                      plot(  fire_bins_x ,data_j ,'o', fire_bins_new ,smooth_interp_prfile_channel_j , fire_bins_x , smooth_prfile_channel_j , 'r')
%                                      smooth_prfile_channel_i = smooth_interp_prfile_channel_i ;
%                                      smooth_prfile_channel_j = smooth_interp_prfile_channel_j ;
%                                      DT_bin = DT_bin_interp ; 
                                 end
                                 
                                 [c , mi ] = max(smooth_prfile_channel_i );
                                 mi = mi* DT_bin ; 
                                 [c , mj ] = max(smooth_prfile_channel_j );
                                 mj  = mj* DT_bin ;
                                 
                                
                                 max_corr_lag = floor(length( smooth_prfile_channel_j) /2 ) ;
                                 if mean( smooth_prfile_channel_i )>0 && mean(smooth_prfile_channel_j )>0
                                     [c,lags] = xcorr( smooth_prfile_channel_i , smooth_prfile_channel_j , ...
                                         floor(length( smooth_prfile_channel_j) /2 ) , 'coeff' );
                                 else
                                     c = [] ; lags = [] ;
                                 end
                                  
                                 
                                    [m,i]=max(c);
                                    if ~isempty( i )
                                      Max_corr_delay2 =  lags( i(1) )  * DT_bin ;
                                      Max_corr_delay = abs( lags( i(1) ) ) * DT_bin ;
                                    else
                                      Max_corr_delay =0 ;
                                      Max_corr_delay2 =0 ;
                                    end
                                    
                                 tau_diff_maxs = abs( mi   - mj  );
                                 
                                 if ch_i > ch_j 
                                     pi = pi + 1 ;
                                    All_pairs_max_corr_delays( pi ) = Max_corr_delay ;
                                 end
                                    pi2 = pi2 + 1 ;
                                    All_pairs_max_corr_delays_real( ch_i , ch_j  ) = Max_corr_delay2 ;
                                 
                                if Connectiv_data.Connectiv_matrix_tau_of_max_M( ch_i , ch_j )> 0   
                                 if tau_diff_maxs > 0
                                     N_active_pairs = N_active_pairs + 1 ;
                                     Only_conn_profile_max_diff( N_active_pairs ) = tau_diff_maxs  ;
                                     Matrix_rofile_max_diff( ch_i , ch_j ) = tau_diff_maxs ;

                                     conn_tau_max = Connectiv_data.Connectiv_matrix_tau_of_max_M( ch_i , ch_j ) ;
                                     Only_conn_connect_tau_pairs( N_active_pairs ) = conn_tau_max ;
                                     Only_conn_max_corr_delays( N_active_pairs ) = Max_corr_delay ;
                                     Only_Tact_diff( N_active_pairs ) = burst_activation_mean( ch_j ) - ...
                                        burst_activation_mean( ch_i ) ;
                                 end
                               end
                         end
                       end
                     end
                     
                     All_pairs_max_corr_delays_real2d = All_pairs_max_corr_delays_real ;
                     All_pairs_max_corr_delays_real = reshape( All_pairs_max_corr_delays_real , 1 , [] );
       
                     All_pairs_max_corr_delays( pi +1 : end ) = [];
                     Only_conn_connect_tau_pairs( N_active_pairs +1 : end ) = [];
                     Only_conn_profile_max_diff( N_active_pairs +1 : end ) = [];
                     Only_conn_max_corr_delays( N_active_pairs +1 : end ) = [];
                     Only_Tact_diff( N_active_pairs +1 : end ) = [];
                     
                     hx = 0 : 1 : max( Only_conn_connect_tau_pairs );
                     Only_conn_connect_tau_pairs( Only_conn_connect_tau_pairs == 0 ) = [] ;
                     [h,x] = histc( Only_conn_connect_tau_pairs  ,hx) ;
                     h = 100* ( h / length( Only_conn_connect_tau_pairs ) );
                     h(1) = 0 ;
                     
                      
                     
                     hx2 = 0  : 1 : max( Only_conn_max_corr_delays );
%                      All_pairs_max_corr_delays( All_pairs_max_corr_delays == 0 ) = [] ;
                     [h2,x2] = histc( Only_conn_max_corr_delays  ,hx2 ) ;
                     h2 = 100* ( h2 / length( Only_conn_max_corr_delays ) );
                     
                     All_pairs_max_corr_delays(All_pairs_max_corr_delays==0)= [];
                     hx3 = 0 : 1 : max( All_pairs_max_corr_delays );
                     All_pairs_max_corr_delays( All_pairs_max_corr_delays == max_corr_lag ) = [] ;
                     [h3,x3] = histc( All_pairs_max_corr_delays  ,hx3 ) ;
                     h3 = 100* ( h3 / length( All_pairs_max_corr_delays ) );
                     
                     hx4 = 0 : 1 : max( Only_conn_profile_max_diff );
%                      All_pairs_max_corr_delays( All_pairs_max_corr_delays == max_corr_lag ) = [] ;
                     [h4,x4] = histc( Only_conn_profile_max_diff  ,hx4 ) ;
                     h4 = 100* ( h4 / length( Only_conn_profile_max_diff ) );
                     
              figure
%              subplot( Ny , Nx , 1 )
%                  x=  0 : Connectiv_data.params.tau_delta : Connectiv_data.params.tau_max ; %  delays for fitting ;
%                  plot(  x , M_of_tau , 'r' , 'LineWidth',3 )   
%                                  xlabel( 'Connectivity delay, ms')
%                                  ylabel( 'Spikes transferred, fraction')                 
%                      	 title( ['Spike transferred from ' num2str( One_pair_i ) ' to ' num2str( One_pair_j ) ',delay=' num2str(tau_max) ] );
                                              
%                               figure
                        subplot( Ny , Nx , 1 )
                                x = 1: DT_BINS_number; 
                                y = 1:N;
%                                 Data_Rate_Signature1 = zeros( fire_bins  , N );  
                                Data_Rate_Signature1 = Data_Rate_Signature1';
                                bb= imagesc(  x * DT_bin  , y ,  Data_Rate_Signature1  ); 
                                title( ['Burst profile, spikes/bin (' num2str( DT_bin) ' ms)'] );
                                xlabel( 'Time offset, ms' )
                                ylabel( 'Electrode #' )
                                colorbar
                                
                                x0=x;
                     One_pair_i   ;
                     One_pair_j   ;   
                     
%                         figure
                    subplot( Ny , Nx , 2 )
                    
                        x=  0 : Connectiv_data.params.tau_delta : Connectiv_data.params.tau_max ; %  delays for fitting ;
                         plot(  x , M_of_tau * 100  , 'g' , 'LineWidth',2 )   
                    xlabel( 'Offset, ms')
                     ylabel( 'Spike transferred, %')
                     
                     
                    subplot( Ny , Nx , 3 )
                        hold on
                        
                        plot( x0 * DT_bin0 , Data_Rate_Signature1(  One_pair_i , : ) , 'r'  )   
                        plot( x0 * DT_bin0 ,Data_Rate_Signature1(  One_pair_j , : )  )
                        
                        
                         
                         plot(  smooth( Data_Rate_Signature1(  One_pair_i , : ) ,GLOBAL_const.Spike_Rate_Signature_1ms_smooth , 'loess' ) , 'r' , 'LineWidth',2  )   
                        plot(  smooth( Data_Rate_Signature1(  One_pair_j , : ) , GLOBAL_const.Spike_Rate_Signature_1ms_smooth  , 'loess' ) , 'LineWidth',2  )   
                         
                        hold off
                        ylabel( 'Spikes per bin')
                        xlabel( 'Time offset, ms' )
                        legend( [ 'Profile Channel '  num2str( One_pair_i ) ] , [ 'Profile Channel '  num2str( One_pair_j )] , ...
                            [ 'Spike transferred' ] ); 
                        title( ['Single channel burst profiles , max delay=' num2str( Matrix_rofile_max_diff( One_pair_i , One_pair_j ) ) ' ms, & Spike transferred'] );
                     
%                      subplot( Ny , Nx , 3 )
%                      hold on
%                      plot( Only_conn_connect_tau_pairs , Only_conn_profile_max_diff ,'*' );
%                      
%                      hold off
%                      xlabel( 'Connection delay, ms')
%                      ylabel( 'SR profile max delay, ms')
%                      axis square
%                      maxv= max( max(Only_conn_connect_tau_pairs), max(Only_conn_profile_max_diff ) ) ;
%                      axis( [ 0  maxv  0    maxv     ] )
                     
                     subplot( Ny , Nx , 4 )
                     hold on
                     plot( Only_conn_connect_tau_pairs , Only_conn_max_corr_delays ,'*' );
%                      plot( hx , h / max( Only_conn_profile_max_diff )  , 'r'  , 'LineWidth',3  );
                     hold off
                     xlabel( 'Spike transfer delay, ms')
                     ylabel( 'Pair ptofile correlation, ms')
                     axis square
                     maxv= max( max(Only_conn_connect_tau_pairs), max(Only_conn_max_corr_delays ) ) ;
                     axis( [ 0  maxv  0    maxv     ] )
                     
                     subplot( Ny , Nx , 5 )
                     hold on
                     plot( Only_conn_connect_tau_pairs , Only_Tact_diff ,'*' );
%                      plot( hx , h / max( Only_conn_profile_max_diff )  , 'r'  , 'LineWidth',3  );
                     hold off
                     xlabel( 'Spike transfer delay, ms')
                     ylabel( 'Activation time delta, ms')
                     axis square
                     maxv= max( max(Only_Tact_diff), max(Only_Tact_diff ) ) ;
                     axis( [ 0  maxv  0    maxv     ] )
                     
                     
                     subplot( Ny , Nx , 6  )
                     hold on 
                     
                     plot( hx , h    , 'r'  , 'LineWidth',2  );                     
                     plot( hx2 , h2    , 'g'  , 'LineWidth',2  );    
%                      plot( hx4 , h4    , 'b'  , 'LineWidth',3  ); 
                     plot( hx3 , h3    , 'k'  , 'LineWidth',2  );  
                       legend( 'Connectivity delays' , 'Profile cross-correlation' , 'cross-correlation all')
%                      legend( 'Connectivity delays' , 'Profile cross-correlation' , 'Profile max diff' , 'cross-correlation all')
                     
                     hold off
                     xlabel( 'delay, ms')
                     ylabel( '%')
                     
                     
                     
                     
                     
                     
                     
           x = Only_conn_connect_tau_pairs ;
           y = Only_conn_max_corr_delays ;
           [x , ix ] =sort(x) ;
           y = y( ix ); 
           
%            x = 1:100;
%            y= x + 3* randn(1,100); 
           P1 = polyfit(x,y, 1 )
           yhat = polyval(P1,x)  ;
           
           [R,P]=corrcoef( x , y ) ;
           R = R(2)
           p_val = P(2)
           
           [p,err] = polyfit(x,y,1);   % First order polynomial
           y_fit = polyval(p,x,err);   % Values on a line
            y_dif = y - y_fit;          % y value difference (residuals)
            SSdif = sum(y_dif.^2);      % Sum square of difference
            SStot = (length(y)-1)*std(y)*std(y);   % Sum square of y taken from variance
            rsq = 1-SSdif/SStot;        % Correlation 'r' value. If 1.0 the correlelation is perfec
            rsq
             
           figure
           hold on
            plot(x,y,'b*')
            plot( x,yhat,'r-', 'Linewidth' , 2)
            hold off
            xlabel X
            ylabel Y
            grid on
%             title( 'Linear polynomial fit')
%             axis( [ 0 max_val  0 max_val ] )
            xlabel( 'Spike train correlation, ms' )
           ylabel( 'Profile correlation delay, ms')

%                   
            end








      end

       if isfield( RASTER_data , 'POST_STIM_RESPONSE') 
         Connectiv_data  =  RASTER_data.POST_STIM_RESPONSE.Connectiv_data ;
         s = size( Connectiv_data.Connectiv_matrix_tau_of_max_M  );
         N = s(1) ;
         Connectiv_matrix_statistics_figures
%              Simple_calc = SimpleCalc_Conns( N ,Connectiv_data , Connectiv_data.Connectiv_matrix_M_on_tau_not_fitted , ...
%                  Connectiv_data.Total_Spike_Rates , Connectiv_data.Spike_Rates ) ;
%              Connectiv_data = Simple_calc ;
%           Connectiv_matrix_statistics_figures
      end        
         
  end
                           








