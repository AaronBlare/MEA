% Plot_multi_signals_while_working



Plot_signal_spikes = true ;

 if handles.par.Post_stim_potentials_collect
        if handles.par.Detect_spikes_when_collectingLFP 
            Plot_signal_spikes = true ;
        else
            Plot_signal_spikes = false ;
        end
 end    
        
 
 
% % whos artefacts
% % whos index
% if Plot_signal_spikes
% if Show_volt_index_art == 'y'  
    
   
    
%     if isempty( index)
% %         index = 0 ;
%     end
%     
%     y_index = [ ];
%         if ~isempty( index)
%  y_index = zeros( 1 , length( index ) );
% % y_index( index) = 0.20;
% y_index(:)  = thr ;
% y_index =  x( floor( index) ) ;
%         end
%     
        
% 
% y_artefacts= zeros( 1 , length( artefacts ) );
% % y_artefacts( artefacts) = 0.90;
% if length( y_artefacts )> 0
% y_artefacts(:)  = ARTEFACT_threshold * 2 ;
% y_artefacts   = x( floor( artefacts) ) ;
% 
% end

if ~handles.plot_multiple_signals % analyzing only one channel
%     figure 
    color = 'b' ;
    hold on
else
   color = handles.plot_multiple_signals_curr_color ; 
   hold on
end
    
tx = 1:length( x ); 
tx = tx / sr ;
%     
    
    if  ~handles.plot_multiple_signals % analyzing only one channel
        
%         plot(  tx, x * 1 , color  )
%         
%         if show_additional_par_signal 
%             if ~isempty( index)
%             plot(  index / sr , y_index * 1 , 'r*'   )
%             end
% %          plot(  [ 0 length( tx ) ] , [ -thr -thr ] , 'g--'   )
%             if length( y_artefacts )> 0
%               plot(  artefacts / sr, y_artefacts * 1  , 'gv' )
%             end 
%         legend( 'Signal' , 'Artifacts' , 'Threshold' , 'artefacts' )
%         end
%         
%         hold off
%         xlim( [ min( tx ) max(tx) ])
%         xlabel( 'Time, s' )
%         ylabel( 'Voltage, mV')
%         
%         
    else
%         plot( handles.plot_multiple_signals_handle , x, x * 1 , color  )
%         plot( handles.plot_multiple_signals_handle , index / sr , y_index * 1 , 'r*'   )
%                 plot(  x, xf_detect * 1 , color  )
%         plot(  index / sr , y_index * 1 , 'r*'   )

 if Artefacts_find 
    if handles.plot_multiple_signals_derrivative 
 
        option_data.signal =  x_diff ;
        option_data.signal_x = tx(1:end-1) ;
    else
        option_data.signal = x ;
        option_data.signal_x = tx ;
    end
        
 else
           option_data.signal = x ;
        option_data.signal_x = tx ;  
 end
    end


% end
% end

 
% figure
% hold on
% for i=1:length( index )                           %Eliminates artifacts
% 
%     plot( spikes(i,:) ) ;
%         
%  
% end 





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
