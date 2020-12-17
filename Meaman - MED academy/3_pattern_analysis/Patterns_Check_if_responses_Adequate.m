  %----- Patterns_Check_if_responses_Adequate
  % TimeBin_Total_Spikes -> if in average the PSTH is not falling down from
  % the beginning then all responses are bad and erase them
  % Patterns.Poststim_interval_END should be longer than 250 (300)
  % Output: All_responses_Bad = true , delete_responses_index
   
   
  
  %--- PSTH is adequate if NUmber of spikes in first ~half more than in a
  %second ------------------------------------
%   
%                fire_bins = floor((Patterns.Poststim_interval_END - Patterns.Poststim_interval_START) / Patterns.DT_bin) ; 
%              DT = Patterns.DT_bin ;
%              Nb= Patterns.Number_of_Patterns ;
%              N = Patterns.N_channels ;
%    
%                GLOBAL_CONSTANTS_load
% 
%                All_responses_Bad = false ;
%    
%                    delete_responses_index = [];
%                    fire_bins_list = Patterns.Poststim_interval_START : DT :Patterns.Poststim_interval_END -DT ;
%                    true_responses_bins = find( fire_bins_list >= Start_Significant_spikes_interval & fire_bins_list <= End_Significant_spikes_interval );
%                    false_responses_bins = find(   fire_bins_list > End_Significant_spikes_interval ); 
%                    if ~isempty( true_responses_bins ) && ~isempty( false_responses_bins ) 
%                        FirstPart_spikes_from_all_resp = [];
%                        SecondPart_spikes_from_all_resp = [];
%                        for R = 1 : Nb       
%                              FirstPart_spikes_from_all_resp =  [FirstPart_spikes_from_all_resp ...
%                                  sum(  Patterns.TimeBin_Total_Spikes( R , true_responses_bins ) ) ] ;
%                              SecondPart_spikes_from_all_resp =  [SecondPart_spikes_from_all_resp...
%                                  sum(  Patterns.TimeBin_Total_Spikes( R , false_responses_bins ) ) ] ;
% 
%                        end 
%                          if mean( FirstPart_spikes_from_all_resp ) < Ksecond_part * mean(SecondPart_spikes_from_all_resp) 
%                              delete_responses_index = 1:Nb ;
%                              All_responses_Bad = true ;
%                          end
%                    end
%------------------------------------------------------------                   
                 
  %--- PSTH is adequate if difference between lowest PSTH bar and highest is  higher than threshold------------------------------------

  % only for long responses
  
               fire_bins = floor((Patterns.Poststim_interval_END - Patterns.Poststim_interval_START) / Patterns.DT_bin) ; 
             DT = Patterns.DT_bin ;
             fire_bins_ms = (1:fire_bins) * DT ;
             Nb = Patterns.Number_of_Patterns ;
             N = Patterns.N_channels ;
   
               GLOBAL_CONSTANTS_load

               All_responses_Bad = false ;
   
                   delete_responses_index = [];
                   
       if Patterns.Poststim_interval_END > 150             
                        TimeBin_Total_Spikes_mean_in_each_bin = zeros( fire_bins , 1 ) ; 
                       for bin_i = 1 : fire_bins
                          TimeBin_Total_Spikes_mean_in_each_bin( bin_i) =  mean(  Patterns.TimeBin_Total_Spikes( : , bin_i )); 
                       end 
                       TimeBin_Total_Spikes_mean_in_each_bin_non_zers = TimeBin_Total_Spikes_mean_in_each_bin( TimeBin_Total_Spikes_mean_in_each_bin> 0 );
                       
                       % calc ( max - median )/max
                       PSTH_rel_Amp = 100*(max( TimeBin_Total_Spikes_mean_in_each_bin ) - median(TimeBin_Total_Spikes_mean_in_each_bin_non_zers))...
                           /max( TimeBin_Total_Spikes_mean_in_each_bin );
                       PSTH_rel_Amp ;
                         if PSTH_rel_Amp < GLOBAL_const.PSTH_relative_Amplitude_threshold 
                             delete_responses_index = 1:Nb ;
                             All_responses_Bad = true ;
                         end
                         
                     
                         
                     if exist( 'GLOBAL_const' , 'var' )                          
                                         
  
                                
                              if   GLOBAL_const.pause_on_cluster_figs                         
%                                  if isfield( GLOB , 'pause_on_cluster_figs' )  
%                                      if GLOB.pause_on_cluster_figs
                                         
                                         
                                 figure
                                        hold on          
                                        thr = GLOBAL_const.PSTH_relative_Amplitude_threshold ;
                                        bar( fire_bins_ms , 100 * (TimeBin_Total_Spikes_mean_in_each_bin / ...
                                              max( TimeBin_Total_Spikes_mean_in_each_bin ))  );
                                        plot( [ 0 max( fire_bins_ms )   ] ,[ PSTH_rel_Amp PSTH_rel_Amp  ] , 'r')
                                        plot( [ 0 max( fire_bins_ms )   ] ,[ thr thr  ] , 'g')
                                        hold off

                                        title(  'Adequate test, relative PSTH'   )
                                        xlabel( 'Post-stimulus time, ms')
                                        ylabel( 'Spikes per bin, spikes')
                                        legend('PSTH / max( PSTH) ' , 'Relative PSTH', 'PSTH threshold' );
                                        if max( TimeBin_Total_Spikes_mean_in_each_bin ) > 1
                                            xlim( [ 0   max( fire_bins_ms )   ...
                                                 ] )
                                        end                                         
                                         
%                                         pause 
%                                      end
%                                  end    
                              end   
                     end
%------------------------------------------------------------   
  end










