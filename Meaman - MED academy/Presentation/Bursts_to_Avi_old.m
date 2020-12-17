
% Bursts_to_Avi
% input: ANALYZED_DATA Experiment_name

Nb_start = 1; % start burst
Nb_per_image= 1 ; % number of bursts
Durmax = 1.1 * max( ANALYZED_DATA.BurstDurations ) ; % End burst time, ms
% Durmax = 100 ;

Dt_step = 5   ; % framerate , ms
MaxSpikes = Dt_step ;
Dt_step_cycle = 1 ;
Nx = 1 ; Ny = 1 ;


close all

Write_video = true ;

if Write_video
outputVideo = VideoWriter(  [ Experiment_name '_Bursts_video.avi' ]);
outputVideo.FrameRate = 10 ;
open(outputVideo);
end
 
% N=60;
% Nb = ANALYZED_DATA.Number_of_bursts ;

Max_color_val = MaxSpikes ;  
smooth_plot_argin = true ;
N= length( ANALYZED_DATA.Total_spikes_each_channel ) ;



              %-- Plot8x8Data_quick INIT ---------
                Data = zeros(8,8);
                DIV = 8 ;

                if N == 64
                   mea_type = 1 ; % med64 type
                end
                if N == 60
                   mea_type = 2 ; % mea type
                end
                x = 1: DIV ;
                y = x ; 
                load( 'MEAchannel2dMap.mat');   
                %----------------------------
                
                
%                 var.Find_only_SpikeRate = false ; 
%          
%             var.Burst_Data_Ver =  4 ; 
%             var.N = N ;
%              [  TimeBin_Total_Spikes ,  TimeBin_Total_Spikes_mean , TimeBin_Total_Spikes_std , ...
%                Spike_Rate_Patterns ,  Spike_Rate_Signature ,  ... 
%                Spike_Rate_Signature_std , Amp_Patterns , Amps_Signature , Amps_Signature_std ]   ...
%                           = Get_Electrodes_Rates_at_TimeBins_1pattern_for_Bursts( N , Nb_per_image  , ANALYZED_DATA.bursts , ...
%                   0 ,  Durmax , Dt_step  ,  [] ,var );
%               
               
%         figure  
%         
% %         nFrames = Durmax - Dur_step ;
% %         mov(1:nFrames) = struct('cdata', [],...
% %                         'colormap', []);
% %                     k = 1 ;
%                     
%         for Ti = 1 : Dt_step : Durmax - Dur_step      
%              Progress = 100 * ( Ti /  ( (Durmax - Dur_step - 1 )    ) )
%              
%               tic
%             for Nbi = 1 : Nb_per_image 
%               for i = 1 : N
%               Pattern( i ) = sum( Spike_Rate_Patterns( Ti :  Ti + Dur_step , i , Nbi  )) ; 
%               end
%                
%               
%               h = subplot( Ny , Nx , Nbi ) ;
%               
%                 
%                 %-- Plot8x8Data_quick Proc Plot ---------
%                  
%                 Data = zeros(8,8);
%                      if   mea_type == 2 % 60 channels MEA
%                          N = 60 ;  
%                         for i = 1 : N    
%                              Data(  MEA_channel_coords(i).chan_Y_coord  , MEA_channel_coords(i).chan_X_coord ) = Pattern( i ) ;     
%                         end
%                      end  
%                  
%                      
%                 if smooth_plot_argin
%                     Data=interp2(Data,5,'cubic');
%                 end
%                 clims = [ 1 Max_color_val ]; 
%                 h_pict = imagesc( x,y, Data ,  clims );
%                  
% %                 h_pict = pcolor( x,y, Data  ); 
% %                 h_pict = imagesc( x,y, Data  ); 
%                 axis square
%                 colorbar
%                 %----------------------------               
%                  
%             end
%             
%               drawnow
%               
%               
%           if Write_video 
%                   writeVideo(outputVideo,  hardcopy( h , '-Dzbuffer', '-r0') );  
% %                 f = hardcopy( h , '-Dzbuffer', '-r0') ;  
% %                 mov(k).cdata = hardcopy( h , '-Dzbuffer', '-r0') ;  
% %                 k=k+1;
%           end
%           toc
%   
%       end
% 
%      if Write_video
%             close(outputVideo);
% %             movie2avi(mov, 'myPeaks.avi', 'compression', 'None');
%      end
%               
%       
%      
%      if Write_video
%     outputVideo = VideoWriter(fullfile( 'Bursts_activity.avi'));
%     outputVideo.FrameRate = 10 ;
%     open(outputVideo);
%     end
     
figure
 max_spikes_found = 0 ;
 Pattern = zeros( 1, N ); 
  for Ti = 1 : Dt_step_cycle : Durmax - Dt_step_cycle
      
     Progress = 100 * ( Ti /  ( (Durmax - Dt_step - 1 )    ) )
      tic
      
      for Nbi = 1 : Nb_per_image 
          Pattern(:) = 0 ;
           
          for i = 1 : N
%               ch_times = ANALYZED_DATA.bursts{ Nbi }{ i };
              ch_index = find( ANALYZED_DATA.bursts{ Nb_start -1 + Nbi }{ i } > Ti  ...
                    & ANALYZED_DATA.bursts{ Nb_start -1 + Nbi }{ i } < Ti + Dt_step  ) ;

%               ch_index =  ANALYZED_DATA.bursts{ Nbi }{ i } > Ti  ...
%                     & ANALYZED_DATA.bursts{ Nbi }{ i } < Ti + Dur_step   ;  
              Pattern( i ) = length( ch_index );
          end
           

           
          h = subplot( Ny , Nx , Nbi ) ;
          
                
                %-- Plot8x8Data_quick Proc Plot ---------
                
                Data = zeros(8,8);
                     if   mea_type == 2 % 60 channels MEA
                         N = 60 ;  
                        for i = 1 : N    
                             Data(  MEA_channel_coords(i).chan_Y_coord  , MEA_channel_coords(i).chan_X_coord ) = Pattern( i ) ;     
                        end
                     end  
                
                     
                if smooth_plot_argin
                    Data=interp2(Data,3,'cubic');
                end
                
                max_spikes_found1 = max( max( Data ));
                if max_spikes_found < max_spikes_found1
                   max_spikes_found = max_spikes_found1 ; 
                end
                
                clims = [ 1 Max_color_val ];
                h_pict = imagesc( x,y, Data ,  clims );
%                 h_pict = imagesc( x,y, Data  ); 
                axis square
                colorbar
                %----------------------------
                
                
          
%            Plot8x8Data( Pattern , false , true );
            
             
           
      end
      drawnow 
      
      if Write_video
%                 frame = getframe( h );
 
                 
                writeVideo(outputVideo,  hardcopy( h , '-Dzbuffer', '-r0') );  
                 
      end
  
      toc
  end
  
  max_spikes_found

 if Write_video
        close(outputVideo);
  end














