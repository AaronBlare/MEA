
% Bursts_to_Avi_interval 
% input:   Time_start Time_end MaxSpikes Dt_step_cycle

Nb_start = 1; % start burst
Nb_per_image= 1 ; % number of bursts
% Durmax = 1.1 * max( ANALYZED_DATA.BurstDurations ) ; % End burst time, ms
% Durmax = 100 ;

Dt_step = MaxSpikes   ; % framerate , ms
% MaxSpikes = Dt_step ;
% Dt_step_cycle = 1 ;
Nx = 1 ; Ny = 1 ;


 Time_end =  Time_end * 1000   ; 
Time_start = Time_start * 1000  ;
smooth_plot_argin = false ;

% -- LOAD DATA --------------------------------------------------------
%  if AskFileInput
    [filename, pathname] = uigetfile('*.*','Select file') ;
%  else
%     [pathname,name,ext] = fileparts( filename ) ;
%  end
    
 
if filename ~= 0
      
    [pathstr,name,ext] = fileparts( filename ) ;
    FILENAME = name ;
    ext   
 init_dir = cd ;
 if length( pathname ) > 0
   cd( pathname ) ;
 end
 Full_File_name = [ pathname filename ];
Full_File_name
 
 



 Full_File_name = [ pathname filename ];
    [pathstr,name,ext] = fileparts( filename ) ;
%     Raster_file =[char(name) '_Post_' int2str(Post_stim_interval_start) '_stim_spikes_raster.txt' ] ;
     Experiment_name = name ;
% --/////// LOAD DATA -------------------------------------------------
 
index_r = load( Full_File_name ) ;

Write_video = true ;

if Write_video
outputVideo = VideoWriter(  [ Experiment_name '_Bursts_video.avi' ]);
outputVideo.FrameRate = 10 ;
open(outputVideo);
end
 
% N=60;
% Nb = ANALYZED_DATA.Number_of_bursts ;

Max_color_val = MaxSpikes ;  
% N= length( ANALYZED_DATA.Total_spikes_each_channel ) ;

N = max( index_r( :,2));

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
                
     
figure
 max_spikes_found = 0 ;
 Pattern = zeros( 1, N ); 
  for Ti = Time_start : Dt_step_cycle : Time_end - Dt_step_cycle
       
      tic
       
          Pattern(:) = 0 ;
          ch_index_all = find( index_r( :,1) > Ti  ...
                    & index_r( :,1) < Ti + Dt_step  ) ;
                
          for i = 1 : N 
             ch_index = find(  index_r( ch_index_all , 2 ) == i ) ; 
             Pattern( i ) = length( ch_index );
          end 
          h = subplot( Ny , Nx , 1 ) ;
          
                
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
                
                clims = [ 0 Max_color_val ];
                h_pict = imagesc( x,y, Data ,  clims );
%                 h_pict = imagesc( x,y, Data  ); 
                axis square
                colorbar
                %---------------------------- 
%            Plot8x8Data( Pattern , false , true ); 
           
%       end
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
 

end



