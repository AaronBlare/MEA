% Compare_2_structs_of_patterns_script_2
% Compare two sets of responses
% input should be   burst_activation, Spike_Rates_each_burst... from
% ANALYZED_DATA or POST_STIM_RESPONSE and stored in "Patterns" struct.
% output - a list of output variables should be processed outside of this
% script (ex. Compare_Pattern_pairs).

  
%%----------------------------------       
              
 
% Compare_Stim_resp_3files


Apply_filtering = true ;


G_Max_y  = 0.5 ; % Maximum scale Y
 G_Min_y  = -0.5 ;  % Minimum  scale Y

Sigma_amp_filter = 2 ;

%------------------------------
  [filename1 ,PathName1 ] = uigetfile('*.*','Select file');
  fullname1 = [PathName1 filename1 ]; 
  
  [filename2 ,PathName2 ] = uigetfile('*.*','Select file');
  fullname2 = [PathName2 filename2 ]; 
  
  fullname3 =fullname2 ;
%   
%   [filename3 ,PathName3 ] = uigetfile('*.*','Select file');
%   fullname3 = [PathName3 filename3 ]; 
  
  
%   fullname1 = '_02_2018_09_19_h12_s_d28_30stim_z33_minus800_Raster_1sigma_Post_2-30ms_Stimlus_responses.mat' ;
%   fullname2 = '_11_2018_09_19_h12_s_d28_30stim_z33_minus800_Raster_1sigma_Post_2-30ms_Stimlus_responses.mat' ;
%   fullname3   = '_11_2018_09_19_h12_s_d28_30stim_z33_minus800_Raster_1sigma_Post_2-30ms_Stimlus_responses.mat' ;;
  
    if fullname1 ~= 0
        
        LFP = [] ;
        
        Patterns1 = load( char(fullname1 ) ) ;   
%         LFP0 = LFP0.Details  ;   
%         LFP = [ LFP LFP0 ] ;
        Patterns2 = load( char(fullname2 ) ) ;   
%         LFP0 = LFP0.Details   ;  
%          LFP = [ LFP LFP0 ] ;
           Patterns3 = load( char(fullname3 ) ) ;   
%         LFP0 = LFP0.Details   ;  
%          LFP = [ LFP LFP0 ] ;
        
        % Show_all_post_stim_signals_8x8   .option_data_all

%         LFP( k ).option_data_all
    end
Max_y  = 0.5 ; % Maximum scale Y
 Min_y  = -0.5 ;  % Minimum  scale Y


 
 
load( 'MEAchannel2dMap.mat');   

Ny = 8 ;
Nx = 8 ;
N = 60 ;

figures_f = [] ;
spikes_ms_all  = [] ;
spikes_amp_all = [] ;
FiI = 0 ;
figure

NFis = 2 ;






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
               
             for Fis = 1 : NFis 
    
    
                    if Fis ==1 
                    POST_STIM_RESPONSE =Patterns1.POST_STIM_RESPONSE ;
                    spikes_ms_all  = [] ;
            spikes_amp_all = [] ;
                    end


                    if Fis ==2 
                    POST_STIM_RESPONSE =Patterns2.POST_STIM_RESPONSE ;
                    spikes_ms_all  = [] ;
            spikes_amp_all = [] ;
                    end
% 

               bursts = POST_STIM_RESPONSE.bursts ;
                 Nb = POST_STIM_RESPONSE.Number_of_Patterns ;
                 for bi = 1 : Nb
                  
                    spikes_ms =  POST_STIM_RESPONSE.bursts{ bi }{ curr_channel }  ;
                    if ~isempty( spikes_ms ) 
                    spikes_amps =  POST_STIM_RESPONSE.bursts_amps{ bi }{ curr_channel } ;
                   
                   
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
    
%     x = [ spikes_ms_all( i ) ];
%     y = [ spikes_amp_all(i) ];    
     if Fis ==1 
    plot( x , y , 'k-*' )
    plot( x(1) , y(2) , 'r*' )
     end
     
     if Fis ==2 
        plot( x , -y , 'k-*' )
        plot( x(1) , -y(2) , 'g*' )
     end 
     
     
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
 end
 
  

 linkaxes( figures_f , 'x' )
%  set(figures_f,'ylimmode','auto'); 
 xlim( [ POST_STIM_RESPONSE.Poststim_interval_START   POST_STIM_RESPONSE.Poststim_interval_END  ])

 
 
 

toc




