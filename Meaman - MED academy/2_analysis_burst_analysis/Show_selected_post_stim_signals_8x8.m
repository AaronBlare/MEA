% Show_selected_post_stim_signals_8x8

% Show_all_post_stim_signals_8x8

Channels = [    35    ] ; 

Show_specific_signals = 0 ; % [ 1 : 10 ] ;
Show_specific_signals =  [ 1:10   ] ; 
Show_specific_signals =  [ 40:50   ] ; 
% Show_specific_signals = 0 ; % [ 1 : 10 ] ;

 G_Max_y  = 0.03 ; % Maximum scale Y
 G_Min_y  = -0.1 ;  % Minimum  scale Y
 
%   G_Max_y  = 0.21 ; % Maximum scale Y
%  G_Min_y  = -0.21 ;  % Minimum  scale Y
%    G_Max_y = NaN; G_Min_y = NaN ;
 
 minx = NaN; maxx = NaN ;
 minx = 0 ;
 maxx = 6  ;

start_t_min_ms = 2 ;
 
Filter_axonal_spikes = false ;
           XXX= 2.001 ;%  AxonThres = RASTER_data.Thr_one_sigma_all( CH_i ) * XXX ;


Sigma_amp_filter =  0  ;
% Sigma_amp_filter =  1.5 ;
% Sigma_amp_filter =  10 ;
 

 

Apply_artifact_suppres = false ;
Apply_filtering = true ;
Apply_artifact_suppres_after_filter = false ;
Apply_clustering = false ;
Each_plot_set_color = true  ;
show_signals_fft = false ;

hist_bins = 30 ;

if exist( 'Details' , 'var' )
    show_signals = true ;
    
   
    
else
    show_signals = false ;
end
Show_mean_signal = true ;



close all

Signals_to_show = Show_specific_signals ;      




 tic ;

for CH = 1 : length( Channels )
    
    figure 
    CH_i = Channels( CH ) ;

% CH = 60 ;
if show_signals
Nx = 1 ; Ny = 3 ;
if ~show_signals_fft
    Ny = 2 ;
end
else
    Nx = 1 ; Ny = 1 ;
end
load( 'MEAchannel2dMap.mat');   


      

       figures_f = [] ;
       
       
       
   % load spikes
   
       
            
           spikes_rate_each_stim = [] ;
            spikes_timing_each_stim = [] ;
           spikes_ms_all = []; 
                spikes_amps_all = [] ;
           spikes_ms_all_col = [] ;
           if exist( 'POST_STIM_RESPONSE' , 'var' )           
               Nsignals = POST_STIM_RESPONSE.Number_of_Patterns ; 
               Signals_to_show = [ 1 : Nsignals ]; 
           end
if Show_specific_signals > 0 
    Signals_to_show = Show_specific_signals ;
end


Nsig = length( Signals_to_show ) ;


GLOBAL_CONSTANTS_load
               sr = handles.par.sr ; 
               
               
  %--------- colors
               
                MaxT = pi ;
        MinT = 0 ; 
        T_bin = (MaxT - MinT )/   Nsig ;
%         t = 0:0.1: pi ; 
        t = MinT:T_bin : MaxT  ;
        lt = length( t ); 
        
                  redc =  ( 1 * (1 +cos(  t * 1.0 ))) / 2 ; 
            redc =  ( 1 * ( ( MaxT - t * 1.0 ))) / MaxT   ; 
            redc = redc * 1.0 + 0.0  ;
            
%             greenc =  ( 1 + sin(  t - pi/2 ) )/ 2 ; 
            greenc =  ( 0 + (  t  ) )/ MaxT ; 
             greenc(:) = 0.0  ;

            bluec =  ( 0 + (  t  ) )/ MaxT ;  
            
            bluec  = bluec * 1.0 + 0.0  ; 
            
            
%             a = 1:10 ;
%         b = sin(a/10) ;
%         b = a ; 
%         b(:)=1;
%         x = a ; 
%                 figure     
%         hold on
%         for i=1 : Nsig
%              color_i = [ redc( i ) greenc( i ) bluec( i ) ] ;
%              CG_FFT =8 ;
%             plot(   x   , b*i     , 'Color' , color_i , 'LineWidth', CG_FFT    )
% 
%         end

    %---------------------------

           
                         if exist( 'POST_STIM_RESPONSE' , 'var' )   
  for signal_i  = 1 : Nsig          

%                  y =  post_stim_signals_all( ci , : );
                 
                 

                 bursts = POST_STIM_RESPONSE.bursts ;
                 Nb = POST_STIM_RESPONSE.Number_of_Patterns ;
                 for bi = 1 : 1
                    spikes_ms = [];
                    ci = Signals_to_show( signal_i ) ;      
                    spikes_ms =  POST_STIM_RESPONSE.bursts{ ci }{ CH_i }  ;
                    
                    
                    if ~isempty( spikes_ms ) 
%                     [ ff ] = find( spikes_ms >= max( post_stim_signals_time_x_ms ) ) ;
                    
%                     signal_ms = Details.option_data_all(i).post_stim_signals_time_x_ms ;
                    spikes_amps =  POST_STIM_RESPONSE.bursts_amps{ ci }{ CH_i } ;
%                     spikes_ms( ff ) = [] ;
%                     spikes_amps( ff ) = [] ;
%                     [ dd , mins ]= min( signal_ms) ;
                    dd = 0 ;
%                     spikes_ms = spikes_ms - dd ;


                    Thr_one_sigma = abs( POST_STIM_RESPONSE.One_sigma_in_channels( CH_i )) ; 
                    spikes_sigma_all  = spikes_amps  / Thr_one_sigma ;
                    if Sigma_amp_filter > 0  
                          
                    ggg = find( abs( spikes_sigma_all ) < Sigma_amp_filter) ;
%                     spikes_sigma_all( ggg ) = [] ;
                    spikes_amps( ggg ) = [] ;
                    spikes_ms( ggg ) = [] ;
                    end
  
                    
                    spikes_frames = ( (spikes_ms - dd) * sr / 1000 ) + 1  ;
%                     spikes_frames( spikes_frames > length(y) ) = [];
                    spikes_frames( spikes_frames <= 0 ) = [];  
%                     y_s =  y( floor( spikes_frames) ) ;
                    
                    spikes_rate_each_stim = [ spikes_rate_each_stim numel( spikes_ms ) ] ;
                    spikes_ms_all = [ spikes_ms_all ; spikes_ms ];
                    spikes_amps_all = [ spikes_amps_all ; spikes_amps ] ; 
                    color_all = ones( numel( spikes_ms_all ) , 3 ) ;
                    
                    for cc = 1 : numel( spikes_ms ) 
                            timing_each_stim = [ signal_i spikes_ms( cc ) ];
                                spikes_timing_each_stim = [ spikes_timing_each_stim ; timing_each_stim ];
                    
                    end 
                    
                    color_i = [ redc( signal_i ) greenc( signal_i ) bluec( signal_i ) ] ;
                    for cc = 1 : numel( spikes_ms ) 
                        spikes_ms_all_col = [ spikes_ms_all_col ; color_i ] ;
                        
                    end
%                     color_all( : ) = color_i ;
%                     spikes_ms_all_col = [ spikes_ms_all_col ; color_all ] ;
               
                    
%                     plot( spikes_ms  ,  y_s , '*' , 'Color' , color_i  )
                    plot( spikes_ms  ,  spikes_amps , 'g*'    )
%                      plot( spikes_ms  ,  spikes_amps , '*' , 'Color' , color_i  )
                    end
                 end
                 
  end
                         end
            
  % Spikes     
       
       
       
    Fi = 0 ;    
% LFP data present       
 if show_signals
      
        title( 'All post-stim signals')
        
        maxy = 0 ; 
        miny = 0 ;
        chan_n  =numel( Details.option_data_all) ;
        curr_channel = 0 ; 
        for j = 1 :  chan_n
            if Details.option_data_all(j).channel == CH_i 
              curr_channel = j ;                 
            end            
        end
        

%   for Fx = 1 : 8   
%       for Fy = 1 : 8  
          Fi = Fi + 1  ;
%         for i = 1 : chan_n    
            i = curr_channel ;
%             curr_channel = Details.option_data_all(i).channel ;
            chan_Y = MEA_channel_coords( curr_channel ).chan_Y_coord  ;
            chan_X = MEA_channel_coords( curr_channel ).chan_X_coord  ;
%             if Fy == chan_X && Fx == chan_Y

              
               
            Title_str = [  'Post-stim signals (Ch = ' num2str( CH_i )    ]  ;

               
                post_stim_signals_all = Details.option_data_all(i).post_stim_signals_all ;
                s = size( post_stim_signals_all );
                Nsignals = s(1);
                post_stim_signals_time_x_ms = Details.option_data_all(i).post_stim_signals_time_x_ms  ;
                
                
                
  if Apply_artifact_suppres
                    
               
 
post_stim_signals_all_new = [] ;

Signals_to_show = [ 1 : Nsignals ]; 

if Show_specific_signals > 0 
    Signals_to_show = Show_specific_signals ;
end
Nsig = length( Signals_to_show ) ;
 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Fit_test1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
                   post_stim_signals_all_new =        Filt_y ;
            post_stim_signals_all = artifact_sign * post_stim_signals_all_new ;
            
            post_stim_signals_time_x_ms = tau_x ;
            
%               figure ; plot(  -post_stim_signals_all_new' ) ;
              
                    end
                 

Signals_to_show = [ 1 : Nsignals ];                 
if Show_specific_signals > 0 
    Signals_to_show = Show_specific_signals ;
end
Nsig = length( Signals_to_show ) ;
% ci = Signals_to_show( signal_i ) ; 
               
 filtered_before = false ;
 
              if Apply_filtering
               % Filtering signals
               GLOBAL_CONSTANTS_load
               sr = handles.par.sr ; 
               fmin_detect = handles.par.Post_stim_potentials_SHOW_LowFreq ;
               fmax_detect = handles.par.Post_stim_potentials_SHOW_HighFreq ;
               Filter_50Hz_of_signal = handles.par.Post_stim_potentials_SHOW_50Hz_filter ;
               Filter_50Hz_iirnotch  = handles.par.Post_stim_potentials_SHOW_50Hz_iirnotch ;
               
          Title_str = [  'Post-stim signals (Ch = ' num2str( CH_i )   '), LowF = ' num2str( fmin_detect )  ', HighF = ' num2str( fmax_detect )  ]  ;

               
               a = [];
                if fmax_detect < sr /2 & fmax_detect > 0 & fmin_detect > 0  
                [b,a]=ellip(2,0.1,40,[fmin_detect fmax_detect]*2/sr);
%                  [b,a] = butter(9,[fmin_detect fmax_detect]*2/sr);
                else
                    if fmin_detect > 0     &  fmax_detect == 0 
%                     [b,a]=ellip(2,0.1,40,[fmin_detect ]*2/sr, 'high');
%                      [b,a] = butter(9,fmin_detect/(sr/2), 'high');
                   
                    
%                     cut_f1 = 5;
%                     cut_f2 = 100;
%                     Wn = [cut_f1/(Fs/2) cut_f2/(Fs/2)];


%                     [b,a] = butter(9,fmin_detect/(sr/2), 'high');
                     [b,a]=ellip(2,0.1,40,[fmin_detect ]*2/sr, 'high');
                    
%                     [B,A] = butter(2,[1/64,63/64],'bandpass'); %construct second order all pass filter
%                         Filtered_Data = filter(B,A, Data) %filter data using butterworth filter
                    
                    else 

                    end

                    if fmax_detect < sr /2 & fmax_detect >0   &  fmin_detect == 0
                      [b,a]=ellip(2,0.1,40,[fmax_detect ]*2/sr, 'low');  
                    end

                    if fmin_detect == 0  &  fmax_detect == 0 

                    end

                end
                
                if ~isempty( a )  
                    post_stim_signals_all0 = [] ;
                    for signal_i  = 1 : Nsig   
                        ci = Signals_to_show( signal_i ) ; 
                        
                        
                        yyy = filtfilt(b,a, post_stim_signals_all( ci , : )  ) ;
%                            Smooth_window_prime =   123 ; 
% %                 post_stim_signals_all1 =  post_stim_signals_all ;  
%                yyy = smooth( yyy ,Smooth_window_prime , 'loess')'  ;
%                 
                    
                   post_stim_signals_all0 =[ post_stim_signals_all0 ; yyy   ] ;
                  
                    end
                    post_stim_signals_all = post_stim_signals_all0 ;
                    clear post_stim_signals_all0 ;
                else
%                   xf_detect= x ; 
                end

                
 filtered_before = false ;
 if ~isempty( a )  
     filtered_before = true ;
 end
     
                if Filter_50Hz_of_signal  
                Wo = 50 /(  floor( sr ) / 2);  BW = Wo/35;   
                
%                 BW = Wo/35;   
                BW = Wo/ Filter_50Hz_iirnotch ;  % 0.5
                
                  [b,a] = iirnotch(Wo,BW);  
%                  post_stim_signals_all = filter(b,a,post_stim_signals_all); 
                 
                  post_stim_signals_all0 = [] ;
                    for signal_i  = 1 : Nsig 
                        
                        if filtered_before
                            ci = signal_i ;
                        else
                            ci = Signals_to_show( signal_i ) ; 
                        end
                        
                   post_stim_signals_all0 =[ post_stim_signals_all0 ; filtfilt(b,a,post_stim_signals_all( ci , : )) ]  ;
                    end
                    post_stim_signals_all = post_stim_signals_all0 ;
                    clear post_stim_signals_all0 ;
                    
                end    
                 
                
              end
                
         
              
              if Apply_artifact_suppres_after_filter
                    
               
 
post_stim_signals_all_new = [] ;

% Signals_to_show = [ 4 : Nsignals ]; 

if Show_specific_signals > 0 
    Signals_to_show = Show_specific_signals ;
end
Nsig = length( Signals_to_show ) ;
 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   post_stim_signals_all0= [] ;
  for signal_i  = 1 : Nsig 
                        
                        if filtered_before
                            ci = signal_i ;
                        else
                            ci = Signals_to_show( signal_i ) ; 
                        end
                     
                        
                   post_stim_signals_all0 =[ post_stim_signals_all0 ; post_stim_signals_all( ci , : ) ]  ;
                     
                   
  end      
       post_stim_signals_all = post_stim_signals_all0 ;
                    clear post_stim_signals_all0 ;
filtered_before = true ;

            Fit_test2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
figure
                   post_stim_signals_all_new =        Filt_y ;
            post_stim_signals_all = artifact_sign * post_stim_signals_all_new ;
            
            post_stim_signals_time_x_ms = tau_x ;
            
%               figure ; plot(  -post_stim_signals_all_new' ) ;
              
              end     
              
         
  
              

              
              
%        figure
               f = subplot( Ny , Nx , Fi ) ; 
               figures_f = [ figures_f f ] ; 
               
               
               
               
               
               
 if Each_plot_set_color 
              
               % Set color of plot
               
%             s = size( post_stim_signals_all );
%             Nsig = s(1);
               
             % R -> B    
        MaxT = pi ;
        MinT = 0 ; 
        T_bin = (MaxT - MinT )/   Nsig ;
%         t = 0:0.1: pi ; 
        t = MinT:T_bin : MaxT  ;
        lt = length( t ); 
        
                  redc =  ( 1 * (1 +cos(  t * 1.0 ))) / 2 ; 
            redc =  ( 1 * ( ( MaxT - t * 1.0 ))) / MaxT   ; 
            redc = redc * 1.0 + 0.0  ;
            
%             greenc =  ( 1 + sin(  t - pi/2 ) )/ 2 ; 
            greenc =  ( 0 + (  t  ) )/ MaxT ; 
             greenc(:) = 0.0  ;

            bluec =  ( 0 + (  t  ) )/ MaxT ;  
            
            bluec  = bluec * 1.0 + 0.0  ; 
 
            
           hold on
           
           if Filter_axonal_spikes 
                
%            XXX= 1 ;

               means =  mean(   post_stim_signals_all  ) ;
   
               AxonThres = RASTER_data.Thr_one_sigma_all( CH_i ) * XXX ;
               
           iff = find(  abs(means) > AxonThres ) ;
           
               means(:) = 1 ;
               means( iff ) = 0 ;
                        else
                    means =  mean(   post_stim_signals_all  ) ;
                     means(:) = 1 ;
           end
               
           for signal_i  = 1 : Nsig   
               
               if  filtered_before 
                    ci = signal_i ;
               else
                    ci = Signals_to_show( signal_i ) ;             
               end
               
      
               
               
%                post_stim_signals_all( ci , : )  = post_stim_signals_all( ci , : )  - means ; 
           
               color_i = [ redc( signal_i ) greenc( signal_i ) bluec( signal_i ) ] ;
               plot( post_stim_signals_time_x_ms  ,  post_stim_signals_all( ci , : ).* means , 'Color' , color_i  )
               
                          maxy = G_Max_y  ; 
 miny = G_Min_y  ;   
 
  if ~isnan(miny) &&  ~isnan(maxy) 
      
  ylim( [ miny   ,   maxy  ] )
  end           
           end
           
           if exist( 'spikes_ms_all' , 'var' )
                  plot( spikes_ms_all  ,  spikes_amps_all , 'g*'    )
                    
                    
           end
           
%            spikes_rate_each_stim
           
               
      else
          
%                plot( Details.option_data_all(i).post_stim_signals_time_x_ms  , Details.option_data_all(i).post_stim_signals_all )
               plot( post_stim_signals_time_x_ms  ,  post_stim_signals_all )
               title( 'Post-stim signals, Red - first, Blue - last');
 end 
 
 if ~isnan(minx) &&  ~isnan(maxx) 
       xlim( [ minx   ,   maxx  ] )
 end
      
   %% ------
    Colorr =  'cyan' ;
         
    if Show_mean_signal
                   post_stim_signals_mean = mean( post_stim_signals_all ) ;
                   
              
                post_stim_signals_std =  std( post_stim_signals_all )   ;
%                 mad( post_stim_signals_all ) ;
                   
                   CG_FFT_Line_width = 2 ;
                  plot( post_stim_signals_time_x_ms , post_stim_signals_mean ,Colorr , 'LineWidth', CG_FFT_Line_width   ) 
%                    Details.option_data_all(i).post_stim_signals_all_new = []; 

%     plot( post_stim_signals_time_x_ms , post_stim_signals_std.^4 ,Colorr , 'LineWidth', CG_FFT_Line_width *2   ) 
% mad( post_stim_signals_all ) ;
              
    end      
            hold off  
           
            
            
 end
   
%         title( 'Post-stim signals mean')
         maxy = 0 ; 
        miny = 0 ;
% Fi = 0 ; 
%   for Fx = 1 : 8   
%       for Fy = 1 : 8  
          Fi = Fi + 1  ;
%         for i = 1 : chan_n   


               f = subplot( Ny , Nx , Fi ) ; 
               figures_f = [ figures_f f ] ;
               
% LFP data present       
 if show_signals
     
            curr_channel = Details.option_data_all(i).channel ;
            chan_Y = MEA_channel_coords( curr_channel ).chan_Y_coord  ;
            chan_X = MEA_channel_coords( curr_channel ).chan_X_coord  ;
%             if Fy == chan_X && Fx == chan_Y

               
                post_stim_signals_mean = mean( post_stim_signals_all ) ;
                post_stim_signals_std = std( post_stim_signals_all ) ;
                
                 
                
                Smooth_window_prime = 3 ; 
                Smooth_window = 5 ;
%                post_stim_signals_mean1 =  smooth(post_stim_signals_mean ,Smooth_window_prime/5 , 'sgolay' )' ;  % 'rloess'  
               
               
%                Smooth_window_prime = 123 ; 
%                 post_stim_signals_all1 =  post_stim_signals_all ;
%                for signal_i  = 1 : Nsig   
%                
%                post_stim_signals_all1(signal_i , :) = smooth(post_stim_signals_all(signal_i , :)   ,Smooth_window , 'moving' )  ;
%                
%                end
               
%                post_stim_signals_mean2 = mean( post_stim_signals_all1 ) ;
%                        post_stim_signals_mean = post_stim_signals_mean1 ;
                

                
                post_stim_signals_err_minus = mad( post_stim_signals_all ) ;
                post_stim_signals_err_plus  = mad( post_stim_signals_all ) ;
               
               hold on
               
               
               
%                plot( post_stim_signals_time_x_ms  , post_stim_signals_mean , '-k' )
%                 
%                 Smooth_window_prime = 4 ; 
%                 Smooth_window = 5 ;
                 
             
%                
%                Smooth_window_prime =   13     ; 
% %                  post_stim_signals_mean1 =  smooth(post_stim_signals_mean ,Smooth_window_prime/5 , 'sgolay' )';
%                  post_stim_signals_mean1 = 1*smooth(post_stim_signals_mean  ,Smooth_window_prime , 'moving' )  ;
%                  plot( post_stim_signals_time_x_ms  , post_stim_signals_mean2 , '-r')
%                  
%                  
%                  Smooth_window_prime = 1335   ; 
% %                   post_stim_signals_mean1 =  smooth(post_stim_signals_mean ,Smooth_window_prime/5 , 'sgolay' )';
%                   post_stim_signals_mean1 = smooth(post_stim_signals_mean  ,Smooth_window_prime , 'moving' )  ;
% %                  plot( post_stim_signals_time_x_ms  , post_stim_signals_mean1  , '-g')
%                   
%                   plot( post_stim_signals_time_x_ms  , post_stim_signals_mean2  , '-b' )
               plot( post_stim_signals_time_x_ms ,  post_stim_signals_mean-  post_stim_signals_err_minus , '--r' ) ;
               plot(  post_stim_signals_time_x_ms ,  post_stim_signals_mean+  post_stim_signals_err_plus , '--r' ) ;
%                



%% main mean 
plot( Details.option_data_all(i).post_stim_signals_time_x_ms  , post_stim_signals_mean )
%% main mean 


%                plot( Details.option_data_all(i).post_stim_signals_time_x_ms , Details.option_data_all(i).post_stim_signals_mean- Details.option_data_all(i).post_stim_signals_std/2 , '--r' ) ;
%                plot( Details.option_data_all(i).post_stim_signals_time_x_ms , Details.option_data_all(i).post_stim_signals_mean+ Details.option_data_all(i).post_stim_signals_std/2 , '--r' ) ;


 end
               xlabel( 'time, ms');
               
               
               if exist( 'spikes_ms_all' , 'var' )
%                   plot( spikes_ms_all  ,  spikes_amps_all , 'g*'    )
                    hold off
                    hold on
                    if exist( 'POST_STIM_RESPONSE' , 'var' )
%                     Thr_one_sigma = abs( POST_STIM_RESPONSE.One_sigma_in_channels( CH_i )) ;
%                     plot( post_stim_signals_time_x_ms  , post_stim_signals_mean  / Thr_one_sigma )
                    end
                    
               
                    
%                     spikes_sigma_all  = spikes_amps_all  / Thr_one_sigma ;
%                     if Sigma_amp_filter > 0  
%                         
%                         plot( spikes_ms_all  ,  spikes_amps_all  , '*g'    )
%                         
%                     ggg = find( abs( spikes_sigma_all ) < Sigma_amp_filter) ;
%                     spikes_sigma_all( ggg ) = [] ;
%                     spikes_ms_all( ggg ) = [] ;
%                     spikes_amps_all( ggg ) = [] ;
%                     end



    if Apply_clustering
                  
                         spike_resp_clustering 
                         hold on
               plot( post_stim_signals_time_x_ms  , post_stim_signals_mean )
    else
                         
    
                    for ci = 1 : numel( spikes_ms_all )
                        col = spikes_ms_all_col( ci , : )  ;
                        
                          plot( spikes_ms_all( ci )  ,  spikes_amps_all( ci )  , '*' ,  'Color' , col   )
%                           plot( spikes_ms_all( ci )  ,  spikes_amps_all( ci ) / Thr_one_sigma , '*' ,  'Color' , col   )
%                           plot( spikes_ms_all( ci )  ,  spikes_sigma_all( ci )  , '*' ,  'Color' , col   )
                    end
                    legend( 'red-start' , 'blue-end' )
                  ylabel( 'Sigma')
                  
                  
    end           
              
                  
               end
           
               
               hold off
               
               xlabel( 'time, ms');
               
               if exist( 'Details' , 'var' )

               maxy_i = max( max( Details.option_data_all(i).post_stim_signals_all  )) ;

                if maxy_i >  maxy 
                   maxy  = maxy_i  ;
                end
               
                min_i = min( min( Details.option_data_all(i).post_stim_signals_all  )) ;
               if min_i <  miny 
                   miny  = min_i  ;
               end
               else
                   ylim( [ min(spikes_amps_all) 0 ] ) 
               
               end
%             end
             
%         end
      
       
%       end
%   end
   
 if ~isnan(minx) &&  ~isnan(maxx) 

    xlim( [ minx   ,   maxx  ] )
 end
      %%  ------------------
                     
%                  x =  xf_detect ;
Spectrum_color = '-b' ;
%      figure
     
     ci = 1 ; 
%      ci = Signals_to_show( signal_i ) ; 


% CH = 60 ;
%% show_signals_fft
if show_signals_fft

fft_detect = post_stim_signals_all( ci , : ) ;
     L_s = length( fft_detect ) ;
     sr = 20000 ;
    Fs = sr ;                    % Sampling frequency
    T = 1/Fs;                     % Sample time
    L =  L_s ;                     % Length of signal
    t = (0:L-1)*T;                % Time vector
    % Sum of a 50 Hz sinusoid and a 120 Hz sinusoid
%     x = 0.7*sin(200*pi*50*t) + sin(2*pi*120*t); 
%     y = x + 2*randn(size(t));     % Sinusoids plus noise
%     y = x(1:L-1) ;
     
    NFFT= 2^(nextpow2(length( fft_detect ))); 

    % Take fft, padding with zeros so that length(fftx) is equal to nfft 
    fftx = fft( fft_detect ,NFFT); 

% Calculate the numberof unique points
NumUniquePts = ceil((NFFT+1)/2); 

    % FFT is symmetric, throw away second half 
    fftx = fftx(1:NumUniquePts); 
    
    
    % Take the magnitude of fft of x and scale the fft so that it is not a
    % function of the length of x
    mx = abs(fftx)/length( fft_detect ); 
    
    % Take the square of the magnitude of fft of x. 
    mx = mx.^2; 
    
     if rem(NFFT, 2) % odd nfft excludes Nyquist point
      mx(2:end) = mx(2:end)*2;
    else
      mx(2:end -1) = mx(2:end -1)*2;
     end  

    % This is an evenly spaced frequency vector with NumUniquePts points. 
    freq_fft = (0:NumUniquePts-1)*Fs/NFFT; 
     
     DF_smooth_parameter = handles.par.DF_smooth_parameter  ; 
    FFT_smooth_window = DF_smooth_parameter * NFFT  / Fs  ;
    mx = smooth( mx , FFT_smooth_window , 'loess')   ;
     mx( mx < 0) = 0 ;
    
    
    result.freq_fft = freq_fft ;
    result.fft_power = mx ;
     
%     y_filt = fft(xf_detect,NFFT)/L;
%     f = Fs/2*linspace(0,1,NFFT/2+1);

    % Plot single-sided amplitude spectrum.
    min_freq_value = handles.par.FFT_min_freq_show ; 
    max_freq_value = handles.par.FFT_max_freq_show ; 
    min_freq_value = 0 ; 
    max_freq_value = 60 ;
    
    Spectrum_color = '-r' ;
    CG_FFT_Line_width = 2 ;
               
                   
     Fi = Fi + 1  ;
%        
               f = subplot( Ny , Nx , Fi ) ; 
%                figures_f = [ figures_f f ] ;
    hold on
    
%     plot(f,2*abs(Y(1:NFFT/2+1)) , f , 2*abs(y_filt(1:NFFT/2+1))) 
       plot( result.freq_fft , result.fft_power  , Spectrum_color , 'LineWidth', CG_FFT_Line_width, 'MarkerSize',3 );  
%         xlim( [min_freq_value max_freq_value  ] )

%     plot(  f , 2*abs(Y(1:NFFT/2+1))) 
    title('Single-Sided Amplitude Spectrum of y(t)')
    xlabel('Frequency (Hz)')
     
     
      legend( 'Red - first signal' , 'Blue - last signal')
               
%                plot( Details.option_data_all(i).post_stim_signals_time_x_ms  , Details.option_data_all(i).post_stim_signals_all )
               maxy_i = max( max( Details.option_data_all(i).post_stim_signals_all  )) ;
               if maxy_i >  maxy 
                   maxy  = maxy_i  ;
               end
               
               min_i = min( min( Details.option_data_all(i).post_stim_signals_all  )) ;
               if min_i <  miny 
                   miny  = min_i  ;
               end
               
%                xlabel( 'time, ms');
%             end
            
%         end
      
       
%       end
%   end
  
  
%   linkaxes( figures_f   , 'xy' );
%   f.YLim = [ -maxy , maxy ];
%  maxy = Max_y  ; 
%         miny = Min_y  ;
        
          maxy = G_Max_y  ; 
 miny = G_Min_y  ;   
 
  if ~isnan(miny) &&  ~isnan(maxy)  
  ylim( [ miny   ,   maxy  ] )
  end

%     xlim() 
  
%   figure
% CH = 60 ;
% Nx = 8 ; Ny = 8 ;
% load( 'MEAchannel2dMap.mat');   

% chan_n  =numel( Details.option_data_mean) ;
      

%        figures_f = [] ;
 title(  Title_str  )

 
 
 
 
 
 
 
end
 
  
%   linkaxes( figures_f   , 'xy' );
   linkaxes( figures_f   , 'x' );
 
    %% Spike rates 
  s = size( spikes_rate_each_stim ) ; 
  
  if sum( s ) > 0 
    figure
    subplot( 3 ,2 ,2 )
    plot ( spikes_rate_each_stim  , '-*'  )
    title( 'Spike rate each response' )
    
    subplot( 3 ,2 ,4 )
    plot ( spikes_timing_each_stim( : , 1 ) , spikes_timing_each_stim( : , 2 )   , '-*'  )
    title( 'Spike time each response' )
    
    times_all = spikes_timing_each_stim( : , 2 ) ;
    
%     figure
    NNN = hist_bins  ;
    subplot( 3 ,2 ,1 )
      hist( times_all , NNN )
    xlabel( 'Spike timings')
    title( 'Spike time histogram' )
  
      
%       figure 
      subplot( 3 ,2 ,3 )
      hist( spikes_amps_all , NNN )
      xlabel( 'Amp')
       title( 'Amplitude histogram' )
      
%         figure 
subplot( 3 ,2 ,5 )
      hist(   spikes_amps_all  / Thr_one_sigma  , NNN ) 
      xlabel( 'Sigma')
       title( 'Sigma-amp histogram' )
    end
    
end
  
toc
  
  

