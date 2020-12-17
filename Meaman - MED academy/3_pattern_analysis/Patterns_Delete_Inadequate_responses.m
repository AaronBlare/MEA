  %----- Patterns_Delete_Inadequate_responses
  % TimeBin_Total_Spikes -> delete_responses_index
  % Patterns.Poststim_interval_END should be longer than 250 (300)
   
   
  
  GLOBAL_CONSTANTS_load
  
  
  Show_filtering_results = Global_flags.Stim_Search_Params.Adequate_show_results ;
  if Show_filtering_results  
  Patterns_to_show = 30 ;
  
  if Patterns_to_show > Patterns.Number_of_Patterns
     Patterns_to_show = Patterns.Number_of_Patterns ;
  end
   
   Start_t = -50 ;
DT = 1 ;  
  
  Nx = floor( sqrt( Patterns_to_show ));
  Ny = Nx ;
  Patterns_to_show = Nx*Nx ;
  Patterns_to_show_half = floor(Patterns_to_show/2);
  

      figure
  end
  
               fire_bins = floor((Patterns.Poststim_interval_END - Patterns.Poststim_interval_START) / Patterns.DT_bin) ; 
               DT = Patterns.DT_bin ;
               fire_bins_ms = (1: fire_bins) * DT ;
               Nb= Patterns.Number_of_Patterns ;
               N = Patterns.N_channels ;
     
                   delete_responses_index = [];
                   fire_bins_list = Patterns.Poststim_interval_START : DT :Patterns.Poststim_interval_END -DT ;
%                    true_responses_bins = find( fire_bins_list >= Start_Significant_spikes_interval & fire_bins_list <= End_Significant_spikes_interval );
%                    false_responses_bins = find(   fire_bins_list > End_Significant_spikes_interval ); 
                   Patterns_showed_good = 0 ;
                   Patterns_showed_bad = 0 ;
%                    if ~isempty( true_responses_bins ) && ~isempty( false_responses_bins ) 
                   for R = 1 : Nb       
                        Response_is_adequate = true ;
                        Response_is_adequate_str = 'Good' ;
                        
%                          True_reponses_spikes =  sum(  Patterns.TimeBin_Total_Spikes( R , true_responses_bins ) );
%                          False_reponses_spikes =  sum(  Patterns.TimeBin_Total_Spikes( R , false_responses_bins ) );
%                          
%                          if False_reponses_spikes  > True_reponses_spikes 
%                              delete_responses_index =[delete_responses_index R];
%                              Response_is_adequate = false ;
%                              Response_is_adequate_str = 'False' ;
%                          end
                         
                         %-------
                         PSTH_rel_Amp = 100*(max( Patterns.TimeBin_Total_Spikes( R , : ) ) - median(Patterns.TimeBin_Total_Spikes( R , : )))...
                           /max( Patterns.TimeBin_Total_Spikes( R , : ) );
                       Sum_spikes = sum( Patterns.TimeBin_Total_Spikes( R , : ) ) ;
                       PSTH_rel_Amp ;
                         if isnan(  PSTH_rel_Amp ) || PSTH_rel_Amp < GLOBAL_const.PSTH_relative_Amplitude_threshold  ...
                                 || Sum_spikes < GLOBAL_const.PSTH_spikes_threshold 
                             delete_responses_index =[delete_responses_index R];
                             Response_is_adequate = false ;
                             Response_is_adequate_str = 'False' ;
                         end
                         %--------
                         
                         
                         
                           if Show_filtering_results  && Patterns_showed_good + Patterns_showed_bad < Patterns_to_show
                               show_pattern = false ;
                               if Response_is_adequate 
                                   if Patterns_showed_good <= Patterns_to_show_half
                                    Patterns_showed_good = Patterns_showed_good+1; 
                                      show_pattern = true  ; 
                                   end
                               else
                                   if Patterns_showed_bad <= Patterns_to_show_half
                                     Patterns_showed_bad = Patterns_showed_bad + 1 ;  
                                      show_pattern = true ; 
                                   end
                               end
                               
                               if show_pattern
                                   hh(R) =  subplot( Ny , Nx , Patterns_showed_good + Patterns_showed_bad ) ;
                                   bar(  fire_bins_ms ,Patterns.TimeBin_Total_Spikes( R , : ) )
                                   title( [Response_is_adequate_str ' Response # ' num2str( R )  ])  
                               end
                           end
                   end 
%                    end
               
         
  if Show_filtering_results  
  xlabel( 'Time, ms')
  ylabel( [ 'spikes per bin, ' num2str( DT ) ])
  linkaxes( hh , 'x')  
                   
  end             
                 
                 %---------------------------------