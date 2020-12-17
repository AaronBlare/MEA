% Stim_response_trails_window 
function Stim_response_trails_window( Start_t , end_t , Channel )


CHANNEL = 1 ;
CHANNEL_examined = Channel ;
CHANNEL_art = 9 ;
N = 64 ;
NNN = 60 ;
BBB = 2 ;
XXX = 0.250 ;
prcnt_resp = 0.9 ;
%  Diap_ms  = 190 ;
MAX_RESPONSE_DUR = 1000; 
 
 
[filename, pathname] = uigetfile('*.*','Select file') ;
if filename ~= 0 
    
init_dir = cd ;
cd( pathname ) ;

 index_r = load( char( filename ) ) ;  
   [filename_art, pathname_art] = uigetfile('*.*','Select file') ;
if filename_art ~= 0 
    art_s = load( char( filename_art ) ) ;  
    
     extract_channel_index = find( art_s( : , 2 ) == CHANNEL_art ) ;
      artefacts =  art_s( extract_channel_index , 1 ) ;
    whos artefacts
    a= diff( artefacts ) ;
    min_Artefact_interval_ms = min( a) ;
    min_Artefact_interval_ms
    
    
%     FFF = 5;
%     artefacts( FFF : end ) = [];
% artefacts( 1 : FFF ) = [];
% %     artefacts( FFF : end ) = [];
%     artefacts( 300 : end ) = [];
    
%    artefacts(:) = artefacts(:) - artefacts(1) + 1 ;
%  artefacts(:) = artefacts(:) + artefacts( end )  ;

%     Diap_ms = Diap_ms * floor( 20000 / 1000 ) ;    




    
    extract_channel_index = find( index_r( : , 2 ) == CHANNEL_examined ) ;
    channel_index_i =  index_r( extract_channel_index , 1 )  ;  
    whos channel_index_i
    
    Show_volt_index_art = 'n' ;
    
if Show_volt_index_art == 'y'
y_index = zeros( 1 , max(channel_index_i)  );
y_index( floor(channel_index_i)) = -0.20;
y_artefacts= zeros( 1 , max(channel_index_i) );
y_artefacts( floor(artefacts) ) = 0.90;
y_artefacts_d= zeros( 1 , max(channel_index_i) );
y_artefacts_d( floor(artefacts(:)) ) = 0.10;
y_artefacts_d( floor(artefacts(:)+Diap_ms) ) = 0.10;
figure
x =1 : max(channel_index_i) ;
% plot(  x , y_index , x , y_artefacts , x , y_artefacts_d)
end
    
    all_index_after_art = [] ;
    index_after_art = [] ;
    
     burst_activation=zeros( length(artefacts) ,64);
    bursts_absolute=zeros( length(artefacts) ,64, 1000);
    bursts=zeros( length(artefacts) ,64, 1000);
    burst_start = artefacts ;
    burst_end = artefacts + 0 ;
    
    num_poststim_spikes = -0.5 * ones( length(artefacts) ,64);
    num_poststim_spikes_on_electrode = -0.5 * ones( length(artefacts) ,1 );
    num_poststim_spikes_mean_all_electrodes = -0.5 * ones( length(artefacts) ,1 );
    
    
    
    for CHANNEL_i = 1 :  64
        
            extract_channel_index = find( index_r( : , 2 ) == CHANNEL_i ) ;
            channel_index_i =  index_r( extract_channel_index , 1 )   ;  
            channel_index_i;
        
            
    chan_responsed = 0 ;        
    chan_index_after_art  = [] ;
    for i=1:  length( artefacts   )  
            index_after_art = find( artefacts(i)+Start_t <= channel_index_i(:) & artefacts(i) + end_t >= channel_index_i(:)  );
           
       if ~isempty( index_after_art  )
           chan_responsed  = chan_responsed +1 ;
            s = channel_index_i( index_after_art ) - artefacts(i) ;
            chan_index_after_art  = [ chan_index_after_art  ; s ] ;        
            num_poststim_spikes( i, CHANNEL_i )= length( index_after_art );
            if CHANNEL_i == CHANNEL_examined
                num_poststim_spikes_on_electrode( i) = length( index_after_art );
            end
       end
        
%        ss = find( artefacts(i) + Diap_ms < channel_index_i(:) & artefacts(i) + MAX_RESPONSE_DUR > channel_index_i(:)  );
%        if ~isempty( ss  )
%        bursts_absolute(i,CHANNEL_i,1:length(ss)) = channel_index_i( ss ) ;
%        bursts(i,CHANNEL_i,1:length(ss)) = channel_index_i( ss ) -  artefacts(i) ;
%        burst_end(i) = channel_index_i( ss(end) ) ;
%        end
%        ss = find( artefacts(i) + Diap_ms < channel_index_i(:) & artefacts(i) + MAX_RESPONSE_DUR > channel_index_i(:) ,1  );
%        if ~isempty( ss  )       
%        burst_activation(i,CHANNEL_i) = channel_index_i( ss ) - artefacts(i)   ;
%        end
      
       
%     end    
%     XX = chan_responsed /  length( artefacts   )  ;
%     if XX > XXX
            all_index_after_art  = [ all_index_after_art  ; chan_index_after_art   ] ;             
%             figure   
%             [n,xout] = hist( chan_index_after_art , NNN ) ;
%              bar(xout , n )
%     end
    
    end
    
    end
    
    for i=1:  length( artefacts   )  
      num_poststim_spikes_mean_all_electrodes( i ) = mean(num_poststim_spikes( i, : )); 
    end
    
%     
%     index_r=[];
%     for CHANNEL_i = 1 :  64        
%     index_ms = bursts_absolute(:,CHANNEL_i,1 );
%     index_ms = index_ms' ;
%     chan = ( CHANNEL_i  ) * ones( 1 , length( index_ms ) )  ;
%     index_vs_ch = [ index_ms ; chan ]' ;
%     index_r = [ index_r ; index_vs_ch ];
%     end
%     
%     [pathstr,name,ext,versn] = fileparts( filename_art ) ;
%     Raster_file =[char(name) '_Post_' int2str(Diap_ms) '_stim_spikes_raster.txt' ] ;
%     %dlmwrite(Raster_file , index_r ,'delimiter', '\t',  'precision', '%.3f' )
%         %dlmwrite(Raster_file , index_r , ' ')
%         fid = fopen(Raster_file , 'w');
%     fprintf(fid, '%.3f  %d\n', index_r');
%     fclose(fid); 
%     
  figure  
  hold on
    plot( artefacts/1000 , num_poststim_spikes_on_electrode  ,'-.r*')
    plot(  artefacts/1000 , num_poststim_spikes_mean_all_electrodes,':bs')
 hold off
  title( 'Number of spikes after each stimulus in interval' )
    
% 
%      [pathstr,name,ext,versn] = fileparts( filename_art ) ;
% finame = [ name '_Post_' int2str(Diap_ms) 'ms_Stimlus_responses.mat' ] ;
% cd( pathname_art ) ;
% eval(['save ' char( finame ) ' burst_activation bursts_absolute bursts burst_start burst_end  -mat']); 
% for CHANNEL_i = 1 :  64 
% burst_activation_mean( CHANNEL_i ) = mean(burst_activation(:,CHANNEL_i ) ) ; 
% end
% figure
% stairs( burst_activation_mean )
% title( 'First spikes after stimulus' )
% 
% f = find( burst_activation_mean == 0 );
% burst_activation_mean(f) = median( burst_activation_mean );
%   Plot8x8Data( burst_activation_mean )
% xlabel( 'Electrode #' )
% ylabel( 'Electrode #' )
% title( 'First spikes after stimulus' )
% colorbar ;




     
%     
%     figure
% %     hist( all_index_after_art ,20 ) ;    
%     [n,xout] = hist( all_index_after_art , NNN ) ;
%     n(1: BBB ) = 0 ;
%     mean_spikes_per_bin_after_stimul = mean( n );
%     mean_spikes_per_bin_after_stimul
%     
%     n2 = n / length( all_index_after_art ) ;
% %     n2 = n ;
% 
%         bar(xout , n2 )
%     figure
%     [ n3 ,xout] = hist( n ,20 ) ; 
%     bar(xout ,n3  ) 
   
    
cd( init_dir ) ;
end

end
