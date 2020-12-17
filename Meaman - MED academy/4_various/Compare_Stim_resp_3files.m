
% Compare_Stim_resp_3files


Apply_filtering = true ;


G_Max_y  = 0.5 ; % Maximum scale Y
 G_Min_y  = -0.5 ;  % Minimum  scale Y



%------------------------------
  [filename1 ,PathName1 ] = uigetfile('*.*','Select file');
  fullname1 = [PathName1 filename1 ]; 
  
  [filename2 ,PathName2 ] = uigetfile('*.*','Select file');
  fullname2 = [PathName2 filename2 ]; 
  
  [filename3 ,PathName3 ] = uigetfile('*.*','Select file');
  fullname3 = [PathName3 filename3 ]; 
  
  
  
    if filename1 ~= 0
        
        LFP = [] ;
        
        LFP0 = load( char(fullname1 ) ) ;   
%         LFP0 = LFP0.Details  ;   
        LFP = [ LFP LFP0 ] ;
        LFP0 = load( char(fullname2 ) ) ;   
        LFP0 = LFP0.Details   ;  
         LFP = [ LFP LFP0 ] ;
        LFP0 = load( char(fullname3 ) ) ;   
        LFP0 = LFP0.Details   ;  
         LFP = [ LFP LFP0 ] ;
        
        % Show_all_post_stim_signals_8x8   .option_data_all

%         LFP( k ).option_data_all

Max_y  = 0.5 ; % Maximum scale Y
 Min_y  = -0.5 ;  % Minimum  scale Y



figure
CH = 60 ;
Nx = 8 ; Ny = 8 ;
load( 'MEAchannel2dMap.mat');   

  k = 1 ;   
chan_n  =numel( LFP( k ).option_data_all ) ;
      

       figures_f = [] ;
        title( 'All post-stim signals')
        
        maxy = 0 ; 
        miny = 0 ;
        
        
        
  
  colors = [ 'r' 'g' 'b' ] ;
Fi = 0 ; 
  for Fx = 1 : 8   
      for Fy = 1 : 8  
          Fi = Fi + 1  ;
        for i = 1 : chan_n    
            curr_channel = LFP( k ).option_data_all(i).channel ;
            chan_Y = MEA_channel_coords( curr_channel ).chan_Y_coord  ;
            chan_X = MEA_channel_coords( curr_channel ).chan_X_coord  ;
            if Fy == chan_X && Fx == chan_Y
               f = subplot( Ny , Nx , Fi ) ; 
               figures_f = [ figures_f f ] ;
               hold on
               
                for k = 1 : 3
               post_stim_signals_all = LFP( k ).option_data_all(i).post_stim_signals_all  ;
               
               s = size( post_stim_signals_all );
                Nsig = s(1);
            
               new_post_stim_signals_all_new = false  ;
              if Apply_filtering
               % Filtering signals
               GLOBAL_CONSTANTS_load
               sr = handles.par.sr ;
               fmin_detect = handles.par.Post_stim_potentials_SHOW_LowFreq ;
               fmax_detect = handles.par.Post_stim_potentials_SHOW_HighFreq ;
               Filter_50Hz_of_signal = handles.par.Post_stim_potentials_SHOW_50Hz_filter ;
               
%                Title_str = [  'Post-stim signals, LowF = ' num2str( fmin_detect )    ]  ;
               
               a = [];
                 if fmax_detect < sr /2 & fmax_detect > 0 & fmin_detect > 0  
                [b,a]=ellip(2,0.1,40,[fmin_detect fmax_detect]*2/sr);
                else
                    if fmin_detect > 0  &  fmax_detect == 0 
                    [b,a]=ellip(2,0.1,40,[fmin_detect ]*2/sr, 'high');
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
                    for ci  = 1 : Nsig   
                   post_stim_signals_all0 =[ post_stim_signals_all0 ; filtfilt(b,a,post_stim_signals_all( ci , : )) ]  ;
                    end
                    post_stim_signals_all = post_stim_signals_all0 ;
                    clear post_stim_signals_all0 ;
                else
%                   xf_detect= x ; 
                end 
                if Filter_50Hz_of_signal  
                Wo = 50 /(  floor( sr ) / 2);  BW = Wo/35;   
                  [b,a] = iirnotch(Wo,BW);  
%                    post_stim_signals_all = filter(b,a,post_stim_signals_all); 
                 
                  post_stim_signals_all0 = [] ;
                    for ci  = 1 : Nsig   
                   post_stim_signals_all0 =[ post_stim_signals_all0 ; filtfilt(b,a,post_stim_signals_all( ci , : )) ]  ;
                    end
                    post_stim_signals_all = post_stim_signals_all0 ;
                    clear post_stim_signals_all0 ;
                end 
                LFP( k ).option_data_all(i).post_stim_signals_all_new   = post_stim_signals_all ;
%                 Details.option_data_all(i).post_stim_signals_all_new = post_stim_signals_all ;
                new_post_stim_signals_all_new = true ;
              end
               
                hold on
           for ci  = 1 : Nsig              
               
               color_i = colors( k ) ;
               plot( LFP( k ).option_data_all(i).post_stim_signals_time_x_ms ,  post_stim_signals_all( ci , : ) , 'Color' , color_i  )
           end
               
%                    plot( LFP( k ).option_data_all(i).post_stim_signals_time_x_ms  , LFP( k ).option_data_all(i).post_stim_signals_all , colors( k )  )
               end
               
               
               
%                for k = 1 : 3
%                    plot( LFP( k ).option_data_all(i).post_stim_signals_time_x_ms  , LFP( k ).option_data_all(i).post_stim_signals_all , colors( k )  )
%                end
               hold off
               maxy_i = max( max( LFP( k ).option_data_all(i).post_stim_signals_all  )) ;
               if maxy_i >  maxy 
                   maxy  = maxy_i  ;
               end
               
               min_i = min( min( LFP( k ).option_data_all(i).post_stim_signals_all  )) ;
               if min_i <  miny 
                   miny  = min_i  ;
               end
               
%                xlabel( 'time, ms');
            end
            
        end
      
       
      end
  end
  
  
  linkaxes( figures_f   , 'xy' );
%   f.YLim = [ -maxy , maxy ];
%  maxy = Max_y  ; 
%         miny = Min_y  ;
        
  maxy = G_Max_y  ; 
 miny = G_Min_y  ;       
        
  ylim( [ miny   ,   maxy  ] )
  
  figure
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
            curr_channel =  LFP( k ).option_data_all(i).channel ;
            chan_Y = MEA_channel_coords( curr_channel ).chan_Y_coord  ;
            chan_X = MEA_channel_coords( curr_channel ).chan_X_coord  ;
            if Fy == chan_X && Fx == chan_Y
               f = subplot( Ny , Nx , Fi ) ; 
               figures_f = [ figures_f f ] ;
               
               
                hold on
               for k = 1 : 3
                   if new_post_stim_signals_all_new
                       post_stim_signals_mean = mean( LFP( k ).option_data_all(i).post_stim_signals_all_new ) ;

                      plot( LFP( k ).option_data_all(i).post_stim_signals_time_x_ms  , post_stim_signals_mean , colors( k ))  
                      LFP( k ).option_data_all(i).post_stim_signals_all_new = []; 
                   else

                      plot( LFP( k ).option_data_all(i).post_stim_signals_time_x_ms  , Details.option_data_all(i).post_stim_signals_mean , colors( k )) 
                   end
               end
               hold off
               
               
%                hold on
%                for k = 1 : 3
%                    plot( LFP( k ).option_data_all(i).post_stim_signals_time_x_ms  , LFP( k ).option_data_all(i).post_stim_signals_mean , colors( k )  )
%                end
%                hold off
%                plot( Details.option_data_all(i).post_stim_signals_time_x_ms  , Details.option_data_all(i).post_stim_signals_mean )
%                xlabel( 'time, ms');

               maxy_i = max( max(   LFP( k ).option_data_all(i).post_stim_signals_all  )) ;

                if maxy_i >  maxy 
                   maxy  = maxy_i  ;
                end
               
                min_i = min( min(  LFP( k ).option_data_all(i).post_stim_signals_all  )) ;
               if min_i <  miny 
                   miny  = min_i  ;
               end
            end
            
        end
      
       
      end
  end
  
  linkaxes( figures_f   , 'xy' );
%     ylim( [ miny   ,   maxy  ] )
  
        
        
    end
      



