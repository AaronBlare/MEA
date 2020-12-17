
% Learn_curve_Find_by_RS
% POST_STIM_RESPONSE. ...
% Arg_file.RS_threshold_percent  - RS threshold [ % ]
% Arg_file.Channel_num_for_Learn_curve - which channel was (will) be
% trained

% N=64 ;
N = POST_STIM_RESPONSE.N_channels ;
Selected_channel = Arg_file.Channel_num_for_Learn_curve ;
RS_thrshold_percent = Arg_file.RS_threshold_percent ;  
Channel_artefacts = 1 ;
InterTrialPeriod = 50000 ; 
artifacts_num = length( artefacts) ; 



CYCLE_loop_var = false ;
CYCLE_loop_var = true ;
CYCLE_loop_var = Arg_file.Loop_curves ;


RS_threshold_value_all = [];
Learning_curve_all = []; 
if CYCLE_loop_var
    for RS_thrshold_percent = 5 : 5 : 40
        Learning_curve_from_RS_thresh_percent
        Learning_curve_all = [ Learning_curve_all Learning_curve ];
        RS_threshold_value_all=[RS_threshold_value_all RS_threshold_value ];
        
    end
    Learning_curve_all
    RS_threshold_value_all
    eval(['save ' name '_RSpercent_5_to_40.mat RS_threshold_value_all Learning_curve_all -mat']); 
else
    
 Learning_curve_from_RS_thresh_percent
 
end

 
 
 %++++++++++++++ Figures +++++++++++++
 %++++++++++++++++++++++++++++++++++++
 
% COLOR PLOT, post stim spikes all channels all artefacts, RS -"--"--  --------------------------------------------   
    imax = floor( artefacts(end) / 1000 ); 
    mmm = zeros( imax , N );
    mmm(:,:)=NaN; 
 for CHANNEL_i = 1 : N 
     for i=1:  length( artefacts   )  
        mmm( floor( 1+ (artefacts( i )  / 1000) ) , CHANNEL_i )= ...
            POST_STIM_RESPONSE.Spike_Rates( i , CHANNEL_i ) ;
     end
 end
     mmm = mmm';
    figure
     subplot(1,2,1)
      x = 1:length( artefacts   ) ;
      y = 1:N ;
%        imagesc(  x  , y ,  num_poststim_spikes_on_electrode_i'  )
        bb = imagesc(  x , y ,  POST_STIM_RESPONSE.Spike_Rates'   ) ;
%         set( bb ,'alphadata',~isnan(mmm))
        title( 'Post-stimulus spikes #' )
        xlabel('Stimulus nummber')
        ylabel('Electrode #')
    colorbar
    
    
imax = floor( artefacts(end) / 1000 ); 
    mmm = zeros( imax , N );
    mmm(:,:)=NaN; 
 for CHANNEL_i = 1 : N 
     for i=1:  length( artefacts   )  
        mmm( floor( 1+ (artefacts( i )  / 1000) ) , CHANNEL_i )= ...
            POST_STIM_RESPONSE.RS_all_channels_all_responses  ( i , CHANNEL_i ) ;
     end
 end
     mmm = mmm';
%     figure
     subplot(1,2,2)
      x = 1:length( artefacts   ) ; y = 1:N ;
%        imagesc(  x  , y ,  num_poststim_spikes_on_electrode_i'  )
        bb = imagesc(  x   , y ,  POST_STIM_RESPONSE.RS_all_channels_all_responses'   ) ;
%         set( bb ,'alphadata',~isnan(mmm))
        title( 'RS values' )
         xlabel('Stimulus nummber')
         ylabel('Electrode #')
    colorbar
    
 %------------------------------------------------------
    
 %------ RS on selected channel ----------------
 figure
subplot( 2 , 1 ,1 ) 
hold on
plot( POST_STIM_RESPONSE.RS_all_channels_all_responses( : , Selected_channel))
% trial starts marker
for tri= 1 : Trials_num
plot( [  Trial_Starts_Ends_nums( Start_trial_artfefact_nums, (tri))  ...
         Trial_Starts_Ends_nums( Start_trial_artfefact_nums, (tri))  ], ...
    [ 0 max(POST_STIM_RESPONSE.RS_all_channels_all_responses( : , Selected_channel)) ] , 'r')
end
title( 'RS values in selected channel');
hold off
subplot( 2 , 1 ,2 )
hist( POST_STIM_RESPONSE.RS_all_channels_all_responses( : , Selected_channel) )
title( 'RS values histogram');
 %---------------------------------------
 
 
 %- LEarning curves
 Learning_curve
 
 figure
subplot( 2, 1 ,1)
plot(Learning_curve)
xlabel( 'Trial number' )
ylabel( 'Adaptation time, s' )
title( 'Learning curve')


subplot( 2, 1 ,2)
plot(Learning_curve_artefacts_num)
xlabel( 'Trial number' )
ylabel( 'Adaptation time, stimuli #' )
title( 'Learning curve')
 
 
 



