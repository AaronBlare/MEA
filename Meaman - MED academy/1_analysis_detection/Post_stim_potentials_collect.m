

   % Post_stim_potentials_collect

 


%% Post_stim_potentials_collect
   if  handles.par.Post_stim_potentials_collect  % take all artifacts and collect post sti signals to matrix
       
       
       RUNTIME_LFP_collecting_now = 1  
       
       post_stim_signals_all = [] ;
       DA_s = handles.par.Post_stim_potentials_start_interval * sr / 1000 ; 
       DA_p = handles.par.Post_stim_potentials_end_interval * sr / 1000 ; 
       post_interv_ms = handles.par.Post_stim_potentials_end_interval - handles.par.Post_stim_potentials_start_interval ; 
       
%        fmin_detect = handles.par.Post_stim_potentials_LowFreq ;
%         fmax_detect = handles.par.Post_stim_potentials_HighFreq ;
%        Filter_50Hz_of_signal = handles.par.Post_stim_potentials_50Hz_filter ;
%                
%        if  handles.par.Detect_spikes_when_collectingLFP
%         fmin_detect =  handles.par.Post_stim_potentials_SHOW_LowFreq ;
%        end
       
       if use_signal_copy_LFP
          x =  xf_detect ;
       end
               
 
%        if numel(  artefacts ) > 0 
%            for i=1:  length( artefacts   )
%               if artefacts(i) + DA_p  < length( xf_detect )
%                post_stim = xf_detect( artefacts(i) + DA_s : artefacts(i) + DA_p ) ;
%                post_stim_signals_all = [ post_stim_signals_all  ; post_stim ] ;
%               end
%            end

        if handles.par.Post_stim_potentials_Filter_during_collect 
            fmin_detect = handles.par.Post_stim_potentials_LowFreq ;
            fmax_detect = handles.par.Post_stim_potentials_HighFreq ;
           Filter_50Hz_of_signal = handles.par.Post_stim_potentials_50Hz_filter ;
           Filter_50Hz_iirnotch =  handles.par.Post_stim_potentials_50Hz_filter ;
               
%               xf_detect=zeros(length(x),1);
                a = [];
                if fmax_detect < sr /2  && fmax_detect >0  && fmin_detect > 0  
                [b,a]=ellip(2,0.1,40,[fmin_detect fmax_detect]*2/sr);
%                 [b,a] = butter(9,[fmin_detect fmax_detect]*2/sr);
                else
                    if fmin_detect > 0  &&  fmax_detect == 0 
                    [b,a]=ellip(2,0.1,40,[fmin_detect ]*2/sr, 'high');
%                     [b,a] = butter(9,fmin_detect/(sr/2), 'high');
                    else 

                    end

                    if fmax_detect < sr /2 && fmax_detect >0   &&  fmin_detect == 0
%                       [b,a]=ellip(2,0.1,40,[fmax_detect ]*2/sr, 'low');  
                      [b,a]=ellip(2,0.1,40,[fmax_detect ]*2/sr, 'low');  
                    end

                    if fmin_detect == 0  &&  fmax_detect == 0 

                    end

                end 
                if ~isempty( a )  
%                    xf_detect=filtfilt(b,a,x);
                    x=filtfilt(b,a,x);
                else
%                   xf_detect= x ; 
                end


                if Filter_50Hz_of_signal  && ~Artefacts_find
                Wo = 50 /(  floor( sr ) / 2);  BW = Wo/ Filter_50Hz_iirnotch_sig ;   
%                 BW = 0.99 ;
 ;   

                BW = Wo/ Filter_50Hz_iirnotch ;  
                  [b,a] = iirnotch(Wo,BW  );  
%                   x0=filtfilt(b,a,x);
%                   figure ; plot( x0(1:10000) )
%                   
%                  xf_detect = filter(b,a,xf_detect); 
%                  x=filtfilt(b,a,x);
                 
%                  deg = 3 ;%filter deg
%                     Wn = [45*2/sr,60*2/sr];
%                     [b,a]  = butter(deg,Wn,'stop'); 

                  x=filtfilt(b,a,x);

                 
                end  
           
        else
%              x =  xf_detect ;    
             ;
        end
           
spikes_ms_all = []; 
spikes_amps_all = [] ;

artefacts = fix( artefacts );

LFP_stim_num = handles.LFP_stim_num ;
if ~isempty(   LFP_stim_num )
if       LFP_stim_num(1) ~=0
  artefacts=  artefacts(   LFP_stim_num )  ;
end
end

       if numel(  artefacts ) > 0 
           for i=1:  length( artefacts   )
              if artefacts(i) + DA_p  < length( x )
               post_stim = x( artefacts(i) + DA_s : artefacts(i) + DA_p ) ;
               post_stim_signals_all = [ post_stim_signals_all  ; post_stim ] ;
               
               if  handles.par.Detect_spikes_when_collectingLFP
               index_art = find( index >= artefacts(i) + DA_s & index < artefacts(i) + DA_p );
               spikes_ms = index( index_art ) - artefacts(i)+1 ; 
               spikes_ms = (spikes_ms * ( 1e3/handles.par.sr)) ;
               spikes_amps = amps( index_art ) ;  
               spikes_ms_all = [ spikes_ms_all spikes_ms ];
               spikes_amps_all = [ spikes_amps_all  spikes_amps ] ;
               end
              end
           end           
         
       p_i = numel( post_stim );
       post_x = ((1:p_i)/ p_i )* post_interv_ms + handles.par.Post_stim_potentials_start_interval ;
        post_stim_signals_mean = mean( post_stim_signals_all ) ;
       post_stim_signals_std = std( post_stim_signals_all ) ;
      
       
%        if   strcmp(  handles.par.Post_stim_potentials_external_artifact_file , '' )
% 
%             Nx = 1 ; Ny = 2 ;
%             if  handles.par.Detect_spikes_when_collectingLFP
%                  Ny = 2 ;
%             end
%             figures_f = [] ;
%             figure
%             Fi = 0 ;  
%           Fi = Fi + 1  ;
%           f = subplot( Ny , Nx , Fi ) ; 
%                figures_f = [ figures_f f ] ;
%             
% %        if Each_plot_set_color 
% %               
% %                % Set color of plot
% %                
% %             s = size( post_stim_signals_all );
% %             Nsig = s(1);
% %                
% %              % RGB gradient
% %         MaxT = 2*pi ;
% %         MinT = 0 ; 
% %         T_bin = (MaxT - MinT )/   Nsig ;
% % %         t = 0:0.1:2*pi ; 
% %         t = MinT:T_bin : MaxT  ;
% %         lt = length( t ); 
% %         
% %             redc =  ( 1 * (1+cos(  t  ))) / 2 ;
% %             redc( floor( lt/2) : end ) = 0  ; 
% %             
% %             greenc =  ( 1 + sin(  t - pi/2 ) )/ 2 ; 
% % 
% %             bluec = ( 1 * (1+cos(  t ))) / 2 ;
% %             bluec(1 : floor( lt/2)   ) = 0  ; 
% %             
% %              % R -> G     
% %         MaxT = pi ;
% %         MinT = 0 ; 
% %         T_bin = (MaxT - MinT )/   Nsig ;
% % %         t = 0:0.1: pi ; 
% %         t = MinT:T_bin : MaxT  ;
% %         lt = length( t );  
% %             
% %             %             redc =  ( 1 * (1 +cos(  t * 1.0 ))) / 2 ; 
% %             redc =  ( 1 * ( ( MaxT - t * 1.0 ))) / MaxT   ; 
% %             redc = redc * 1.0 + 0.0  ;
% %             
% % %             greenc =  ( 1 + sin(  t - pi/2 ) )/ 2 ; 
% %             greenc =  ( 0 + (  t  ) )/ MaxT ; 
% %             greenc = greenc * 0.99 + 0.0  ;   
% % 
% %             bluec = ( 1 + sin(  t - pi/2 ) )/ 2 ;  
% %             
% %             bluec(:) = 0.0 ;
% %             
% %             
% %              Nsig = s(1);
% %                
% %              % R -> B    
% %         MaxT = pi ;
% %         MinT = 0 ; 
% %         T_bin = (MaxT - MinT )/   Nsig ;
% % %         t = 0:0.1: pi ; 
% %         t = MinT:T_bin : MaxT  ;
% %         lt = length( t ); 
% %         
% %                   redc =  ( 1 * (1 +cos(  t * 1.0 ))) / 2 ; 
% %             redc =  ( 1 * ( ( MaxT - t * 1.0 ))) / MaxT   ; 
% %             redc = redc * 1.0 + 0.0  ;
% %             
% % %             greenc =  ( 1 + sin(  t - pi/2 ) )/ 2 ; 
% %             greenc =  ( 0 + (  t  ) )/ MaxT ; 
% %              greenc(:) = 0.0  ;
% % 
% %             bluec =  ( 0 + (  t  ) )/ MaxT ;  
% %             
% %             bluec  = bluec * 1.0 + 0.0  ; 
% %  
% % %             figure
% %            hold on
% %            for ci  = 1 : Nsig              
% %                
% %                color_i = [ redc( ci ) greenc( ci ) bluec( ci ) ] ;
% %                plot( post_x  ,  post_stim_signals_all( ci , : ) , 'Color' , color_i  )
% %            end
% %            
% %            plot( spikes_ms_all  ,  spikes_amps_all , 'g*'    )
% %            
% %            legend( 'Red - first signal' , 'Blue - last signal')
% %             hold off    
% %       else
% % %           figure
% % %              title( 'All post-stim signals')
% %            plot( post_x , post_stim_signals_all )
% % %            xlabel( 'time, ms');
% %       end 
%             
% %             
% % if handles.par.Post_stim_spike_response 
% %      
% %                 flags.Burst_Data_Ver = handles.flags.Burst_Data_Ver ; 
% %                 Post_stim_interval_end = 50 ;
% %                 Post_stim_interval_start= 5 ;
% %                 DT_bin = 1 ;
% %                 N = 60 ;
% %                 
% %                     fire_bins = floor(( Post_stim_interval_end -  Post_stim_interval_start) /  DT_bin) ; 
% %                          %//////////////////////////////////////////    
% %                          [ Patterns ] = Patterns_Get_Responses_in_Interval_from_Raster( N , artefacts ,handles.index_r ,Post_stim_interval_start , ...
% %                            Post_stim_interval_end  , DT_bin ,flags );
% %                           % index_r, intervals post stim -> bursts burst_activation
% %                           % One_sigma_in_channels ... 
% %                          d=0; 
% %                          
% %                   POST_STIM_RESPONSE =    Patterns ;
% %                  Nb = POST_STIM_RESPONSE.Number_of_Patterns ;
% %                  CH_i = handles.par.channel ;
% %                  hold on
% %                  for bi = 1 : Nb
% %                     spikes_ms = [];
% %                     spikes_ms =  POST_STIM_RESPONSE.bursts{ bi }{ CH_i }  ;
% %                     if ~isempty( spikes_ms ) 
% % %                     signal_ms = Details.option_data_all(i).post_stim_signals_time_x_ms ;
% %                     spikes_amps =  POST_STIM_RESPONSE.bursts_amps{ bi }{ CH_i } ;
% % %                     [ dd , mins ]= min( signal_ms) ;
% % %                     spikes_ms = spikes_ms - dd ;
% % %                     spikes_frames = ( (spikes_ms - dd) * sr / 1000 ) ;
% % %                     y_s =  y( floor( spikes_frames) ) ;
% %                     
% % %                     plot( spikes_ms  ,  y_s , '*' , 'Color' , color_i  )
% %                     plot( spikes_ms  ,  spikes_amps , 'g*'    )
% %                     end
% %                  end
% %                   hold off  
% % end
%             
% %        figure
% %        title( 'All post-stim signals')
% %        plot( post_x , post_stim_signals_all )
% %        xlabel( 'time, ms');
%        
%       
%        
% %        figure
% Fi = Fi + 1  ;
% f = subplot( Ny , Nx , Fi ) ; 
%       figures_f = [ figures_f f ] ;
% 
%        
%        hold on
%        plot( post_x , post_stim_signals_mean ) 
%        plot( post_x , post_stim_signals_mean- post_stim_signals_std/2 , '--r' ) ;
%        plot( post_x , post_stim_signals_mean+ post_stim_signals_std/2 , '--r' ) ;
%        xlabel( 'time, ms');
%        title( 'mean and std post-stim signals')
%        
%        plot( spikes_ms_all  ,  spikes_amps_all , '*' )
% %       xlabel( 'time, ms');
% %        ylabel( 'Spike amplitude');
% 
% linkaxes( figures_f   , 'xy' );   
%          
%       end
      
       option_data.post_stim_signals_all = post_stim_signals_all ;
       option_data.post_stim_signals_time_x_ms = post_x ;
       option_data.post_stim_signals_mean = post_stim_signals_mean ;
       option_data.post_stim_signals_std = post_stim_signals_std ;
       
          
       end
       
       if  handles.par.Detect_spikes_when_collectingLFP
%            Fi = Fi + 1  ;
%        f = subplot( Ny , Nx , Fi ) ; 
% %        figures_f = [ figures_f f ] ;
%                figures_f = [ figures_f f ] ;
%                plot( spikes_ms_all  ,  spikes_amps_all , '*' )
%                      xlabel( 'time, ms');
%                      ylabel( 'Spike amplitude');
%        title( 'Spike smplitudes')
       
       end
            
               
   end
%% -----------
  



