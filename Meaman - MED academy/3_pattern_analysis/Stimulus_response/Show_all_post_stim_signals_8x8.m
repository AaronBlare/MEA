% Show_all_post_stim_signals_8x8
 
       tic ; 
 
       
      
            Show_specific_signals =  [ 1 :  10  ] ;
%             Show_specific_signals =  [ 40 :  50  ] ;
%              Show_specific_signals =  [ 30 :  40  ] ;
%        Show_specific_signals =   0; 
       
       
%  G_Max_y  = 0  ; % Maximum scale Y
%  G_Min_y  =  0  ;  % Minimum  scale Y
%  
%  G_Max_y  = 0.1 ; % Maximum scale Y
%  G_Min_y  = -0.2 ;  % Minimum  scale Y


  G_Max_y  = 0.05 ; % Maximum scale Y
 G_Min_y  = -0.1 ;  % Minimum  scale Y
 
prctile_show_y = 0.18 ;   % 1 - prctile
start_t_min_ms = 5 ;

 min_time  = 0 ;  
 max_time = 6 ; 
%   max_time = 0 ; 
 
  Sigma_amp_filter = 0 ;
 Show_mean_signals = false ;
 
 
  Cut_interval_after_max_time =  max_time  ; % 50 

 Cut_interval_after_max_time =  0  ; % 50 
 
 Show_spike_hist = false ;
 
 filter_low_signal  = false ;
        low_signal_thres = 0.002 ; 
   
   
 
Apply_filtering = true  ;
Apply_artefact_suppresion = false ;
%      if Apply_artefact_suppresion
%                Fit_test1
%                end
Each_plot_set_color = true ;


figure_title = [' Post-stim signals and median,' ] ;
if exist( 'handles' , 'var'  )
     if isfield( handles , 'LFP_stim_num'   )
    figure_title = [ figure_title ', stimuli=' num2str( handles.LFP_stim_num ) ] ;
     end
end

if exist( 'Arg_plus' , 'var' )
    
   if isfield( Arg_plus , 'Figure_prefix_global'   )
 
    figure_title = [ Arg_plus.Figure_prefix_global figure_title   ] ;

   end
    
end

 



f = figure ;
set(f, 'name',  figure_title ,'numbertitle','off' )

          Title_str = [  'Post-stim signals' ] ;
              
           title(  Title_str  )
Nx = 8 ; Ny = 8 ;
load( 'MEAchannel2dMap.mat');   

chan_n  =numel( Details.option_data_all) ;
      

       figures_f = [] ;
%         title( 'All post-stim signals')
         
        
        maxy = 0 ; 
        miny = 0 ;
        
       
Fi = 0 ; 

  for Fx = 1 : 8   
      for Fy = 1 : 8  
          Fi = Fi + 1  ;
        for i = 1 : chan_n    
            curr_channel = Details.option_data_all(i).channel ;
            CH_i = curr_channel ;
            chan_Y = MEA_channel_coords( curr_channel ).chan_Y_coord  ;
            chan_X = MEA_channel_coords( curr_channel ).chan_X_coord  ;
            if Fy == chan_X && Fx == chan_Y
               f = subplot( Ny , Nx , Fi ) ; 
               figures_f = [ figures_f f ] ;
               
               post_stim_signals_all = Details.option_data_all(i).post_stim_signals_all ;
           
               if Apply_artefact_suppresion
               Fit_test1
               end
               
               s = size( post_stim_signals_all );
                Nsig = s(1);
                Nsig0 = s(1);
                
                if Show_specific_signals(1)  ~=0 
                    Nsig = length( Show_specific_signals ) ;
                end
            
               new_post_stim_signals_all_new = false  ;
              if Apply_filtering
               % Filtering signals
               GLOBAL_CONSTANTS_load
               sr = handles.par.sr ;
               fmin_detect = handles.par.Post_stim_potentials_SHOW_LowFreq ;
               fmax_detect = handles.par.Post_stim_potentials_SHOW_HighFreq ;
               Filter_50Hz_of_signal = handles.par.Post_stim_potentials_SHOW_50Hz_filter ;
               Filter_50Hz_iirnotch  = handles.par.Post_stim_potentials_SHOW_50Hz_iirnotch ;
               
%                Title_str = [  'Post-stim signals, LowF = ' num2str( fmin_detect )    ]  ;
               
               a = [];
                 if fmax_detect < sr /2 & fmax_detect > 0 & fmin_detect > 0  
                [b,a]=ellip(2,0.1,40,[fmin_detect fmax_detect]*2/sr);
%                     [b,a]=butter(9,[fmin_detect fmax_detect]*2/sr);
%                 [b,a] = butter(9,fmin_detect/(sr/2), 'high');
                else
                    if fmin_detect > 0  &  fmax_detect == 0 
                    [b,a]=ellip(2,0.1,40,[fmin_detect ]*2/sr, 'high');
%                     [b,a] = butter(9,fmin_detect/(sr/2), 'high');

                    else 

                    end

                    if fmax_detect < sr /2 & fmax_detect >0   &  fmin_detect == 0
                      [b,a]=ellip(2,0.1,40,[fmax_detect ]*2/sr, 'low');  
                    end

                    if fmin_detect == 0  &  fmax_detect == 0 

                    end

                 end
                
                 if Filter_50Hz_of_signal  
                Wo = 50 /(  floor( sr ) / 2);  BW = Wo/35;   
                 BW = Wo/ Filter_50Hz_iirnotch ; %0.5;  
                 
                  [b5,a5] = iirnotch(Wo,BW);  
                  
                 end
                 
                 
                
                    post_stim_signals_all0 = [] ;
                    for ci  = 1 : Nsig0   
                         if ~isempty( a )
                            yy = filtfilt(b,a,post_stim_signals_all( ci , : ))   ;
                         end
                     
                     if Filter_50Hz_of_signal
                         if ~isempty( a )
                              yy =   filtfilt(b5,a5, yy )    ;
                         else
                             yy =   filtfilt(b5,a5,post_stim_signals_all( ci , : ))    ;
                         end
                     end
                     
                   
                        if Cut_interval_after_max_time > 0             
                                t_maxend_fr = find(  Details.option_data_all(1).post_stim_signals_time_x_ms > max_time ,1);
                               yy( t_maxend_fr : end  ) = [] ;
                        end
%                         
%                         yy1 = smooth( yy , 23 , 'moving' );
                        
%                         ff = [ yy yy1 ] ;
%                         figure ; plot( ff ) ;
                        
               
                   
                     post_stim_signals_all0 =[ post_stim_signals_all0 ; yy ] ;
                    end
                    
%                     erased = 0 ;
%                     sa = size( post_stim_signals_all0 ) ;
%                     for ti = 1 : sa(2)
%                         a = post_stim_signals_all0(:,ti) ;
% %                         a = round(a*1000)  / 1000;
% %                         [b,m1,n1] = unique(a,'first');
% %                         ff=1:Nsig ; 
% %                         ff( m1) = [];   
% 
%                          ff  = find( abs( a ) < 0.005 );
% 
%                         if ~isempty( ff )
%                             post_stim_signals_all0(m1,ti) = NaN ;
%                             erased =erased + numel( ff ) ;  
%                         end
%                              
%                     end
%                     erased
                    
                    
                    post_stim_signals_all = post_stim_signals_all0 ;
                   
                    post_stim_signals_all0;
                    
                    clear post_stim_signals_all0 ;
%                 else
%                   xf_detect= x ; 
%                 end
                
                


%                 if Filter_50Hz_of_signal  
%                 Wo = 50 /(  floor( sr ) / 2);  BW = Wo/35;   
%                  BW = Wo/ Filter_50Hz_iirnotch ; %0.5;  
%                  
%                   [b5,a5] = iirnotch(Wo,BW);  
% %                    post_stim_signals_all = filter(b,a,post_stim_signals_all); 
%                  
%                   post_stim_signals_all0 = [] ;
%                     for ci  = 1 : Nsig   
%                    post_stim_signals_all0 =[ post_stim_signals_all0 ; filtfilt(b5,a5,post_stim_signals_all( ci , : )) ]  ;
%                     end
%                     post_stim_signals_all = post_stim_signals_all0 ;
%                     clear post_stim_signals_all0 ;
%                 end 
                
                Details.option_data_all(i).post_stim_signals_all_new = post_stim_signals_all ;
                
               if Cut_interval_after_max_time > 0             
                t_maxend_fr = find(  Details.option_data_all(1).post_stim_signals_time_x_ms > max_time ,1);
                new_post_stim_signals_time_x_ms = Details.option_data_all(i).post_stim_signals_time_x_ms ;
                    new_post_stim_signals_time_x_ms( t_maxend_fr : end  ) = [] ;
                    Details.option_data_all(i).post_stim_signals_time_x_ms  = new_post_stim_signals_time_x_ms ;
                 end
                
                
                new_post_stim_signals_all_new = true ;
              end
                
         
               hold on 
               
%                 Nsig = 20 ; 
               
      if Each_plot_set_color  % from Color_gradient_many_plot.m
              
               % Set color of plot
               
            s = size( post_stim_signals_all );
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
 
            
%             t = 0:0.1:2*pi ;
%      lt = length( t );         
% 
%  ColorMax = 1 ;
 
 % RGB gradient
%         MaxT = 2*pi ;
%         MinT = 0 ; 
%         T_bin = (MaxT - MinT )/   Nsig ;
% %         t = 0:0.1:2*pi ; 
%         t = MinT:T_bin : MaxT  ;
%         lt = length( t ); 
%         
%             redc =  ( 1 * (1+cos(  t  ))) / 2 ;
%             redc( floor( lt/2) : end ) = 0  ; 
%             
%             greenc =  ( 1 + sin(  t - pi/2 ) )/ 2 ; 
% 
%             bluec = ( 1 * (1+cos(  t ))) / 2 ;
%             bluec(1 : floor( lt/2)   ) = 0  ; 
            
            
            
           
           for cci  = 1 : Nsig   
             
               cci ;
               
               
               color_i = [ redc( cci ) greenc( cci ) bluec( cci ) ]    ;
               
               ci = cci ;
              if Show_specific_signals(1) > 0
                 ci = Show_specific_signals( cci ) ;
              end 
                  ci;
               
               if ~ Show_spike_hist
%                plot( Details.option_data_all(i).post_stim_signals_time_x_ms  ,  post_stim_signals_all( ci , : ) , 'Color' , color_i  )
   
if filter_low_signal 
a= post_stim_signals_all( ci , : )  ; 
    
%     figure
%     hist( a , 100 );
    
%    f = find( abs( a ) < 0.01);
%    a( f) = NaN  ;
   a( abs( a ) < low_signal_thres ) = NaN  ;
   
        line( Details.option_data_all(i).post_stim_signals_time_x_ms  ,  a , 'Color' , color_i  )
else
    
%     xms = Details.option_data_all(i).post_stim_signals_time_x_ms  ;
%     whos xms 
%      whos post_stim_signals_all 
%      ci 
        line( Details.option_data_all(i).post_stim_signals_time_x_ms  ,  post_stim_signals_all( ci , : ) , 'Color' , color_i  )
end
               end
               spikes_ms_all = [  ] ;
                    spikes_amp_all = [  ] ;
               
               if exist( 'POST_STIM_RESPONSE' , 'var' )
                 y =  post_stim_signals_all( ci , : );
                 
                 bursts = POST_STIM_RESPONSE.bursts ;
                 Nb = POST_STIM_RESPONSE.Number_of_Patterns ;
                 for bi = 1 : Nb
                  
                    spikes_ms =  POST_STIM_RESPONSE.bursts{ bi }{ curr_channel }  ;
                    if ~isempty( spikes_ms ) 
                    signal_ms = Details.option_data_all(i).post_stim_signals_time_x_ms ;
                    spikes_amps =  POST_STIM_RESPONSE.bursts_amps{ bi }{ curr_channel } ;
                    [ dd , mins ]= min( signal_ms) ;
%                     spikes_ms = spikes_ms - dd ;
                    spikes_frames = ( (spikes_ms - dd) * sr / 1000 ) ;
                    spikes_frames( spikes_frames > length(y) ) = [];
                    spikes_frames( spikes_frames <= 0 ) = [];
                    
                   
                   Thr_one_sigma = abs( POST_STIM_RESPONSE.One_sigma_in_channels( CH_i )) ; 
                    spikes_sigma_all  = spikes_amps  / Thr_one_sigma ;
                    if Sigma_amp_filter > 0  
                          
                    ggg = find( abs( spikes_sigma_all ) < Sigma_amp_filter) ;
%                     spikes_sigma_all( ggg ) = [] ;
                    spikes_amps( ggg ) = [] ;
                    spikes_ms( ggg ) = [] ;
                    end
                    
                    spikes_ms_all = [ spikes_ms_all ; spikes_ms ] ;
                    spikes_amp_all = [ spikes_amp_all ; spikes_amps ] ;
%                     y_s =  y( floor( spikes_frames) ) ;
                    if ~Show_spike_hist
%                     plot( spikes_ms  ,  y_s , '*' , 'Color' , color_i  )
                        plot( spikes_ms  ,  spikes_amps , 'g*'    )
                    end
                    end
                 end
                 
                 
                 if  Show_spike_hist
% %                     plot( spikes_ms  ,  y_s , '*' , 'Color' , color_i  )
%                         plot( spikes_ms  ,  spikes_amps , 'g*'    )
                       hist_bins = 30 ;
                    times_all = spikes_ms_all ;

                    NNN = hist_bins  ;
%                     subplot( 3 ,2 ,1 )
                      hist( times_all , NNN )
                 end
                    
                 
               end
           end
           
           
              
      else
          
%                plot( Details.option_data_all(i).post_stim_signals_time_x_ms  , Details.option_data_all(i).post_stim_signals_all )
               plot( Details.option_data_all(i).post_stim_signals_time_x_ms  ,  post_stim_signals_all )
      end 
      
               start_t_min = find(  Details.option_data_all(1).post_stim_signals_time_x_ms > start_t_min_ms ,1);
               
               maxy_i = max( max( Details.option_data_all(i).post_stim_signals_all( start_t_min : end )  )) ;
               maxy_0 = maxy_i ;
               
               
             
               
              
               if start_t_min > 0 
                    maxy_0 = 0 ;
                for ci  = 1 : Nsig   

                  maxy_iig = max( Details.option_data_all(i).post_stim_signals_all(ci , start_t_min : end )) ;
                  if maxy_iig > maxy_0 
                      maxy_0 = maxy_iig ;
                  end
                end
                 maxy_0 ;   
               end
              
               if maxy_i >  maxy 
                   maxy  = maxy_i  ;
               end
               
               
               
               if Fx ~= 8 
                   set(gca,'XTickLabel',[]);
               end
               
               if  abs(G_Min_y) > 0 
               
              
               
               if Fy ~= 1 
                    set(gca,'YTickLabel',[]);
               end
               end
                min_i = min( min( Details.option_data_all(i).post_stim_signals_all( start_t_min : end )  )) ;
                min_0 = min_i ;
                
                

               if start_t_min  > 0 
                   min_0 = 0  ;
                for ci  = 1 : Nsig   
                  min_iig = min( Details.option_data_all(i).post_stim_signals_all(ci , start_t_min : end )) ;
                  if min_iig < min_0 
                      min_0 = min_iig ;
                  end
                end
                 min_0 ;   
               end
                
                if min_i <  miny 
                   miny  = min_i  ;
               end
               
%                xlabel( 'time, ms');


            Colorr =  'cyan' ;
            
             if ~ Show_spike_hist
              
               
            if new_post_stim_signals_all_new
%                    post_stim_signals_mean = mean( Details.option_data_all(i).post_stim_signals_all_new ) ;
                  post_stim_signals_mean = median( Details.option_data_all(i).post_stim_signals_all_new ) ; 
%                   plot( Details.option_data_all(i).post_stim_signals_time_x_ms  , post_stim_signals_mean ,Colorr , ...
%                             'Linewidth' , 2 ) 
                        
 line( Details.option_data_all(i).post_stim_signals_time_x_ms  , post_stim_signals_mean ,'Color' , Colorr , ...
                            'Linewidth' , 2 )  
                        
                       
%                    Details.option_data_all(i).post_stim_signals_all_new = []; 
               else
%                    color
                  plot( Details.option_data_all(i).post_stim_signals_time_x_ms  , ...
                      Details.option_data_all(i).post_stim_signals_mean , Colorr ) 
            end
             end
            
            hold off  
            
            if max_time > 0 
                xlim( [ min_time   ,   max_time  ] )
            end
            
             d = Details.option_data_all(i).post_stim_signals_all ;
             d = d(:) ;
             miny =   prctile(  d , prctile_show_y )  ;
             maxy =   prctile( d ,100 - prctile_show_y )  ;
            
%             ylim( [ miny   ,   maxy  ] )
% maxy_0
% min_0
% maxy_0
 [ min_0 , maxy_0    ] ;
 if ~isempty( min_0)
            ylim( [ min_0 , maxy_0    ] )
 end
             
             
               
            
            
            
            
            
            
            
            end
            
            
            
               
            
        end
      
       
      end
  end
  
  if G_Max_y~=0 && G_Min_y~= 0 
      linkaxes( figures_f   , 'xy' );
  else
    linkaxes( figures_f   , 'x' );
  end
  
  
%   figures_f.EraseMode 
      


%   linkaxes( figures_f   , 'x' );
%   f.YLim = [ -maxy , maxy ];
%  maxy = Max_y  ; 
%  miny = Min_y  ;
 
   maxy = G_Max_y  ; 
 miny = G_Min_y  ;     
 
 

%  maxy = 0.05 ;
%  miny = -0.05 ;
if miny ~= 0 && maxy ~= 0 
  ylim( [ miny   ,   maxy  ] )
end
  
  if Show_mean_signals 
  
f =   figure ; 

set(f, 'name',  figure_title ,'numbertitle','off' )


CH = 60 ;
Nx = 8 ; Ny = 8 ;
% load( 'MEAchannel2dMap.mat');   

% chan_n  =numel( Details.option_data_mean) ;
      

       figures_f = [] ;
        title( 'Post-stim signals mean')
         maxy = 0 ; 
        miny = 0 ;
Fi = 0 ; 
  for Fx = 1 : 8   
      for Fy = 1 : 8  
          Fi = Fi + 1  ;
        for i = 1 : chan_n    
            curr_channel = Details.option_data_all(i).channel ;
            chan_Y = MEA_channel_coords( curr_channel ).chan_Y_coord  ;
            chan_X = MEA_channel_coords( curr_channel ).chan_X_coord  ;
            if Fy == chan_X && Fx == chan_Y
               f = subplot( Ny , Nx , Fi ) ; 
               figures_f = [ figures_f f ] ;
               
               if new_post_stim_signals_all_new
                   post_stim_signals_mean = mean( Details.option_data_all(i).post_stim_signals_all_new ) ;
                   post_stim_signals_med = median( Details.option_data_all(i).post_stim_signals_all_new ) ;
                   
                   hold on
%                    plot( Details.option_data_all(i).post_stim_signals_time_x_ms  , post_stim_signals_med , 'Color', [0.17 0.17 0.17] ) 
                  plot( Details.option_data_all(i).post_stim_signals_time_x_ms  , post_stim_signals_mean ) 
                  
                  hold off
                   Details.option_data_all(i).post_stim_signals_all_new = []; 
               else
                   
                  plot( Details.option_data_all(i).post_stim_signals_time_x_ms  , Details.option_data_all(i).post_stim_signals_mean ) 
               end
%                
%                 post_stim_signals_std = std( post_stim_signals_all ) ; 
%                
%                plot( Details.option_data_all(i).post_stim_signals_time_x_ms  ,  post_stim_signals_mean )
               
%                plot( Details.option_data_all(i).post_stim_signals_time_x_ms  , Details.option_data_all(i).post_stim_signals_mean )
%                xlabel( 'time, ms');

  if Fx ~= 8 
                   set(gca,'XTickLabel',[]);
               end
               if Fy ~= 1 
                    set(gca,'YTickLabel',[]);
               end

               maxy_i = max( max( Details.option_data_all(i).post_stim_signals_all  )) ;

                if maxy_i >  maxy 
                   maxy  = maxy_i  ;
                end
               
                min_i = min( min( Details.option_data_all(i).post_stim_signals_all  )) ;
               if min_i <  miny 
                   miny  = min_i  ;
               end
            end
            
        end
      
       
      end
  end
  
%   t2 = toc ; 
  
%   t2
%  maxy = 0.05 ;
%  miny = -0.05 ;
%   ylim( [ miny   ,   maxy  ] )
  if miny ~= 0 && maxy ~= 0 
  ylim( [ miny   ,   maxy  ] )
  end
  
  linkaxes( figures_f   , 'xy' );
  
% if miny ~= 0 && maxy ~= 0 
%    linkaxes( figures_f   , 'x' );
% else
%   linkaxes( figures_f   , 'xy' );
% %     ylim( [ miny   ,   maxy  ] )
% end
  end
  
  
  

toc 
