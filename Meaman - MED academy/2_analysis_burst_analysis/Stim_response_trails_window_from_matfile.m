% Stim_response_trails_window 
function Stim_response_trails_window_from_matfile( Start_t , end_t , Channel )


% CHANNEL = 1 ;
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
    N=64;
   
init_dir = cd ;
cd( pathname ) ; 
load( char( filename ) ) ;
 
artefacts = POST_STIM_RESPONSE.artefacts ;
bursts = POST_STIM_RESPONSE.bursts ;
    whos artefacts
    
    
    
%           channel_amps1 = abs( bursts_amps(:,CHANNEL_examined,:) ) ; 
%       channel_amps = channel_amps1(  channel_amps1  > 0); 
%       minAmp = min( channel_amps   );
%       minAmp1 = minAmp(1);  
%       AMP_step =    0.1840
%       NEW_amp_threshold = minAmp1 * ( 1 + AMP_step ) ; 
%       bursts( bursts_amps > -1*NEW_amp_threshold ) = 0 ;
% % %     
 
    num_poststim_spikes = -0.5 * ones( length(artefacts) ,64);
    num_poststim_spikes_on_electrode = -0.5 * ones( length(artefacts) ,1 );
    num_poststim_spikes_on_electrode_i = -0.5 * ones( length(artefacts) , N  );
    num_poststim_spikes_mean_all_electrodes = -0.5 * ones( length(artefacts) ,1 );
    
    Start_t0 = Start_t ;
    end_t0 = end_t ;
    
    for CHANNEL_i = 1 :  64
   
    chan_responsed = 0 ;        
    chan_index_after_art  = [] ;
    for i=1:  length( artefacts   )  
        
              index_after_art = find(  Start_t <= bursts(i,CHANNEL_i,:) &  ...
                                      end_t >= bursts(i,CHANNEL_i,:)   );
       if ~isempty( index_after_art  )
           chan_responsed  = chan_responsed +1 ;
            num_poststim_spikes_on_electrode_i( i , CHANNEL_i ) = length( index_after_art );
           
            num_poststim_spikes( i, CHANNEL_i )= length( index_after_art );
            if CHANNEL_i == CHANNEL_examined
                num_poststim_spikes_on_electrode( i) = length( index_after_art );
            end
       else
           num_poststim_spikes_on_electrode_i( i , CHANNEL_i ) = 0 ;
           num_poststim_spikes( i, CHANNEL_i )= 0 ;
            if CHANNEL_i == CHANNEL_examined
                num_poststim_spikes_on_electrode( i) = 0 ;
            end
       end
    end
    

    end
    %_-------------------ADJUST threshold and period------------------------
%_-------------------________________------------------------
% artefacts(40:end)=[];
    Test_responses = [8	2	32	17	37	7  ];
%      Test_responses = [ 3	3	1	2	6		1	5		5		2	3	1 ];   
%     AUTO_MATCH_RESPONSES= true ;    
    AUTO_MATCH_RESPONSES= false ;    
         AUTO_MATCH_PERIOD =false ;
         AUTO_MATCH_AMPS = false  ;
          Jittering_period_max_ms0 = 5 ; 
          AMP_step = 0.1; 
 
          %-----------------------
  [ found_match ,mistakes,min_error] = Match_values_find( artefacts, Start_t  , end_t , CHANNEL_examined , Test_responses ,bursts);
   %-----------------------
   
  mistakes
  min_error
  Start_tx = Start_t ;
        end_tx = end_t ;
          
  if found_match ~= true
   ii=0;
    %------------------------------
   if AUTO_MATCH_AMPS == true  
       
       bursts0 = bursts;
       bursts0Amps = bursts_amps ;
     
       AMP_step = 0.00 ;
       
      channel_amps1 = abs( bursts_amps(:,CHANNEL_examined,:) ) ; 
      channel_amps = channel_amps1(  channel_amps1  > 0); 
      minAmp = min( channel_amps   );
      minAmp1 = minAmp(1);  
       
      errors_dists=[];
      amps=[];
      optimamp =0;
      min_error = 100;
    while AMP_step < 0.4  & found_match==false
         
      minAmp1;
      NEW_amp_threshold = minAmp1 * ( 1 + AMP_step ) ; 
      bursts( bursts_amps > -1*NEW_amp_threshold ) = 0 ;
       %-----------------------
       [ found_match ,mistakes] = Match_values_find( artefacts, Start_tx  , end_tx , CHANNEL_examined , Test_responses ,bursts);
        %-----------------------
       errors_dists= [errors_dists  mistakes ];
       amps=[amps AMP_step];
       if min_error > mistakes
           optimamp = AMP_step;
           min_error=mistakes;
       end
      if found_match
          minAmp1
          AMP_step
      end
      if ~found_match
         bursts = bursts0;
         burstsAmps = bursts0Amps ;
      end
      AMP_step = AMP_step +  0.001 ;
    end
    figure
    plot( amps, errors_dists )
    title( 'error_dists')
    min_error
    optimamp
   end
   %------------------------------
   if AUTO_MATCH_PERIOD == true
       while ii < 10000  & found_match==false
          ii=ii+1;
          if ii < 10000 / 3
              Jittering_period_max_ms = Jittering_period_max_ms0/2;
          end
        
           Start_tx = Start_t + floor( rand()*Jittering_period_max_ms)- floor(  0.5*Jittering_period_max_ms) ;;
           end_tx = end_t + floor( rand()*Jittering_period_max_ms) - floor(  0.5*Jittering_period_max_ms) ;
            %-----------------------
         found_match = Match_values_find( artefacts, Start_tx  , end_tx , CHANNEL_examined , Test_responses ,bursts);
          %-----------------------
      
      
        end
   end
    %------------------------------
  end
  end
  Start_tx
  end_tx
  found_match
%_-------------------________________------------------------
    %_-------------------________________------------------------
    
    
    
    num_poststim_spikes_on_electrode
    
    for i=1:  length( artefacts   )  
      num_poststim_spikes_mean_all_electrodes( i ) = mean(num_poststim_spikes( i, : )); 
    end
    
    
    
    
% COLOR PLOT --------------------------------------------  
%      if length( index_after_art ) > 50
%                 num_poststim_spikes_on_electrode_i( i , CHANNEL_i ) = 15;
%      end
            
    %%!!!!!!!!!!!!!!!!!!!!!!!
%       num_poststim_spikes_on_electrode_i( num_poststim_spikes_on_electrode_i(:,:)> 5 ) = 15;
    %%!!!!!!!!!!!!!!!!!!!!!!!
            
    imax = floor( artefacts(end) / 10000 );
%     imax = 1700 ;
    mmm = zeros( imax , N );
    mmm(:,:)=NaN;
%     num_poststim_spikes_on_electrode_i=num_poststim_spikes_on_electrode_i';
 for CHANNEL_i = 1 : N 
     for i=1:  length( artefacts   )  
        mmm( floor( 1+ (artefacts( i )  / 10000) ) , CHANNEL_i )= ...
            num_poststim_spikes_on_electrode_i( i , CHANNEL_i ) ;
     end
 end
 %------------------------------------------------------
 % LEARNING CURVE----------------------------
 StartAt=artefacts(1);
  EndAt=artefacts(1);
  LearningCurve = []; %each element is cycle
     for i=1:  length( artefacts   )-1 
       if artefacts(i+1)-artefacts(i) > 50000 
           EndAt=artefacts(i);
           AdaptTime = (EndAt - StartAt )/1000;
           StartAt=artefacts(i+1);
           LearningCurve=[LearningCurve AdaptTime];
       end
     end
    EndAt=artefacts(end);
   AdaptTime = (EndAt - StartAt )/1000;
    LearningCurve=[LearningCurve AdaptTime];
 figure 
 plot(LearningCurve,'-s','MarkerEdgeColor','k')
 title( 'Learning curve, y-time to reach criteria,x-cycle' )
 LearningCurve=LearningCurve';
 LearningCurve
 
 %-------------------------
 
    mmm = mmm';
    figure
      x=1:imax ; y = 1:N ;
%        imagesc(  x  , y ,  num_poststim_spikes_on_electrode_i'  )
        bb = imagesc(  x*10  , y ,  mmm   ) ;
        set( bb ,'alphadata',~isnan(mmm))
    colorbar
% colormap hot
    
  figure  
  hold on
%     plot( artefacts/1000 , num_poststim_spikes_on_electrode  ,'-.r*',artefacts/1000 , num_poststim_spikes_mean_all_electrodes,':bs')
   
            bar( artefacts/1000 , num_poststim_spikes_on_electrode , 'BarWidth',0.8)
            bar( artefacts/1000 , num_poststim_spikes_mean_all_electrodes, 'r','BarWidth',0.3)
            bar( artefacts/1000 , -0.5*ones( 1, length(artefacts )) , 'g' ,'BarWidth',0.3 )
  hold off
  title( 'Number of spikes after each stimulus in interval' )
  hleg1 = legend('Response,spikes','Average response (all electrodes)');
     
  
  
 figure  
  hold on
    plot( artefacts/1000 , num_poststim_spikes_on_electrode  ,'-.r*',artefacts/1000 , num_poststim_spikes_mean_all_electrodes,':bs')
   
  hold off
  title( 'Number of spikes after each stimulus in interval' )
  hleg1 = legend('Response,spikes','Average response (all electrodes)');
    
  
  
  
cd( init_dir ) ;
% end

end
