%--- Patterns_get_High_Low_responses ----
            % Patterns.Spike_Rates_each_burst -> High_responses_index ,
            % Low_responses_index ...
            % flags.SHOW_FIGURES_low_hi_responses should be defined before
            % Function looks for 50 ms poststim interval
            % Output :
%                 Patterns.HiLo_High_responses_index  
%                 Patterns.HiLo_Low_responses_index  
%                 Patterns.HiLo_High_Responses_number  
%                 Patterns.HiLo_Low_Responses_number  
%                 Patterns.HiLo_High_Responses_TSR_Threshold 
%                 Patterns.HiLo_High_Responses_Percent 
%                 Patterns.HiLo_Davies_Bouldin_TSR_Clustering_index  
%                 Patterns.HiLo_squared_sum_of_errors_CLUSTERING_Spike_Rates_each_burst  
%                 Patterns.HiLo_High_Responses_Spike_Rates_Relative_Range 
%                 Patterns.HiLo_High_Responses_Spike_Rates_Relative_STD 
%                 Patterns.HiLo_Low_Responses_Spike_Rates_Relative_Range        
%                 Patterns.HiLo_Low_Responses_Spike_Rates_Relative_STD              

GLOBAL_CONSTANTS_load

% 
% Global_flags.High_responses_Threshold = 700 ; %-- If some responses exceed this threshold 
%                             % then there is some such responses then we
%                             % have High reponses 
High_responses_Threshold =    Global_flags.High_responses_Threshold ;

 Use_Global_Constants = true ;
 Recalc_PostStim_Interval_responses_for_Classification = Global_flags.Recalc_PostStim_Interval_responses_for_Classification ;     
   
 if Use_Global_Constants 
     
     if exist( 'Global_flags' ,'var' )
%             Recalc_PostStim_Interval_responses_for_Classification = Recalc_PostStim_Interval_responses_for_Classification ;     
            Start_Classify = GLOBAL_const.Start_Classify ;
            End_classify = GLOBAL_const.End_classify ; 
            DT_classify = GLOBAL_const.DT_classify ;    
     else
         Use_Global_Constants = false;
     end
     
 end
  
     if ~Use_Global_Constants 
        if Recalc_PostStim_Interval_responses_for_Classification
            Start_Classify = 10 ;
            End_classify = 250; 
            DT_classify = 10 ;     
        else
            Start_Classify = Patterns.Poststim_interval_START ;
            End_classify = Patterns.Poststim_interval_END; 
            DT_classify = Patterns.DT_bin ;   
        end
     end
    

Classification_by_pattern_shape = false ;
   
    
% Davies_Bouldin_TSR_Clustering_index_Threshold = 2.58 ; %0.48 ,if its higher threshold than all responses are high
Davies_Bouldin_TSR_Clustering_index_Threshold  = Global_flags.Davies_Bouldin_TSR_Clustering_index_Threshold  ;
%% --- Default

Patterns.HiLo_High_responses_present = false ;
 
 Davies_Bouldin_TSR_Clustering_index = 0 ;
 
Patterns.HiLo_High_responses_index  =[];
Patterns.HiLo_Low_responses_index  =[];
Patterns.HiLo_High_Responses_number  =0;
Patterns.HiLo_Low_Responses_number =0;
Patterns.HiLo_High_Responses_Percent  =0 ;
 
      
                Patterns.HiLo_High_responses_index =   0 ;
                Patterns.HiLo_Low_responses_index  =   1: Patterns.Number_of_Patterns ; 
                Patterns.HiLo_High_Responses_number = 0 ;
                Patterns.HiLo_Low_Responses_number =   Patterns.Number_of_Patterns ;
                Patterns.HiLo_High_Responses_TSR_Threshold = 0 ;
                Patterns.HiLo_High_Responses_Percent= 0 ;
                Patterns.HiLo_Low_Responses_Percent= 0 ;
                Patterns.HiLo_Davies_Bouldin_TSR_Clustering_index = 0 ;
                Patterns.HiLo_squared_sum_of_errors_CLUSTERING_Spike_Rates_each_burst = 0 ;
                Patterns.HiLo_High_responses_present = 0 ;    
                Patterns.HiLo_Low_responses_present = 0 ;
                Patterns.HiLo_High_Responses_Spike_Rates_Relative_Range= 0 ;
                Patterns.HiLo_High_Responses_Spike_Rates_Relative_STD= 0 ;
                Patterns.HiLo_Low_Responses_Spike_Rates_Relative_Range= 0;        
                Patterns.HiLo_Low_Responses_Spike_Rates_Relative_STD= 0;   
        %---------------
                
                
%%  ----- If we have High patterns ----------------------
 if max( Patterns.Spike_Rates_each_burst ) > High_responses_Threshold
     Patterns.HiLo_High_responses_present = true ; 
 end
     
%% --////////////// Recalc all post stim data for 10-60 ms
     if Recalc_PostStim_Interval_responses_for_Classification
         
         Patterns_buf = Patterns ;
         Patterns.DT_bin = DT_classify  ;
         Patterns.Poststim_interval_START = Start_Classify ;
         Patterns.Poststim_interval_END = End_classify  ;
%          Patterns_buf = Patterns ;

           
                 % Patterns_get_Total_rates_Tactivation_from_bursts
                % Patterns.bursts -> Patterns.Spike_Rates Patterns.burst_activation ...
%                 Patterns_get_Total_rates_Tactivation_from_bursts
            var.simple_activation_patterns = true ;
            Patterns_get_Total_rates_Tactivation_from_bursts 

                % Patterns_get_BIN_rates_from_bursts
                 % Patterns.bursts -> Patterns.Spike_Rates_per_channel_per_bin ,
                 % Patterns.Amps_per_channel_per_bin
                  Patterns_get_BIN_rates_from_bursts


                 % Patterns_get_TimeBin_Total_Spikes
                %  Spike_Rates_per_channel_per_bin - > TimeBin_Total_Spikes
                % Amps_per_channel_per_bin -> TimeBin_Total_Amps     
%                 var.use_selected_patterns = false;
%                   Patterns_get_TimeBin_Total_Spikes
          
         
         TimeBin_Total_Spikes_after_Classification = Patterns.TimeBin_Total_Spikes ;
         Spike_Rates_each_burst_after_Classification  = Patterns.Spike_Rates_each_burst ;
         Patterns  = Patterns_buf ;
         
     else
         TimeBin_Total_Spikes_after_Classification = Patterns.TimeBin_Total_Spikes ; 
         Spike_Rates_each_burst_after_Classification  = Patterns.Spike_Rates_each_burst ;
          DT_classify = Patterns.DT_bin ;
          Start_Classify = Patterns.Poststim_interval_START;
          End_classify = Patterns.Poststim_interval_END  ;
     end
%% ---Main classification ///////////////////////////////   
  
         fire_bins = floor(( End_classify - Start_Classify ) / DT_classify ) ;  
                DT_step = DT_classify ;
           if    Patterns.HiLo_High_responses_present  
               
                
               
                if Classification_by_pattern_shape
                    [centers,clusters,errors,ind] = kmeans_clusters( TimeBin_Total_Spikes_after_Classification , 2 , 15 );
                else
                    [centers,clusters,errors,ind] = kmeans_clusters( Spike_Rates_each_burst_after_Classification , 2 , 15 );
                end
                clusters = clusters{2,1};
                clusters_last=clusters ;
                Data1= Spike_Rates_each_burst_after_Classification( clusters == 1);
                Data2= Spike_Rates_each_burst_after_Classification( clusters == 2);
                if max(Data2) > max(Data1)
                    High_Responses_TSR_Threshold = floor((max(Data1)+min(Data2))/2);
                    High_Responses_Percent = 100* length( Data2 ) / (length( Data2 ) + length( Data1 ));
                    Low_Responses_Percent = 100* length( Data1 ) / (length( Data2 ) + length( Data1 ));
                    Cluster1 = 1 ; Cluster2 = 2 ; 
                else
                    High_Responses_TSR_Threshold = floor((max(Data2)+min(Data1))/2);
                    High_Responses_Percent = 100* length( Data1 ) / (length( Data2 ) + length( Data1 )) ;
                    Low_Responses_Percent = 100* length( Data2 ) / (length( Data2 ) + length( Data1 ));
                    Cluster1 = 2 ; Cluster2 = 1 ; 
                end
             
 
                Davies_Bouldin_TSR_Clustering_index = ind(2);
                Davies_Bouldin_TSR_Clustering_index
                squared_sum_of_errors_CLUSTERING_Spike_Rates_each_burst = errors(2) /10000 ;
                squared_sum_of_errors_CLUSTERING_Spike_Rates_each_burst
                
                % if responses are not separable and highm then make all
                % responses
                if Davies_Bouldin_TSR_Clustering_index > Davies_Bouldin_TSR_Clustering_index_Threshold
                        patterns_list = 1 :  Patterns.Number_of_Patterns   ;
                    
                        HiLo_High_responses_index =   patterns_list ; 
 
                        HiLo_High_Responses_number =  length( HiLo_High_responses_index );   
                        HiLo_Low_Responses_number = 0 ;
                        HiLo_Low_responses_index = [] ;
                        High_Responses_Percent = 100 ;
                        Low_Responses_Percent = 0 ;
                        HiLo_High_Responses_Spike_Rates_Relative_Range = 0 ;
                        HiLo_High_Responses_Spike_Rates_Relative_STD = 0 ;
                        HiLo_Low_Responses_Spike_Rates_Relative_Range = 0 ;        
                        HiLo_Low_Responses_Spike_Rates_Relative_STD = 0 ;    
                        
                        
                else % if separating is good
                        patterns_list = 1 :  Patterns.Number_of_Patterns   ;

                        HiLo_High_responses_index =   patterns_list(clusters == Cluster2 );
                        HiLo_Low_responses_index  =   patterns_list(clusters == Cluster1 );


                        HiLo_High_Responses_number =  length( HiLo_High_responses_index );  
                        HiLo_Low_Responses_number  =  length(  HiLo_Low_responses_index ) ;



                        High_responses_Spike_Rates_ech_Burst = ...
                                    Spike_Rates_each_burst_after_Classification(  HiLo_High_responses_index ) ;
                        Max_High_resp =  max(High_responses_Spike_Rates_ech_Burst) ;
                        Min_High_resp =  min(High_responses_Spike_Rates_ech_Burst) ;
                        HiLo_High_Responses_Spike_Rates_Relative_Range = ( Max_High_resp - Min_High_resp ) /  ( Min_High_resp + (Max_High_resp-Min_High_resp)/2 ) ;

                        HiLo_High_Responses_Spike_Rates_Relative_Range ;

                        HiLo_High_Responses_Spike_Rates_Relative_STD = std( High_responses_Spike_Rates_ech_Burst )/...
                                    mean( High_responses_Spike_Rates_ech_Burst ) ;

                        HiLo_High_Responses_Spike_Rates_Relative_STD;                

                        Low_responses_Spike_Rates_ech_Burst = ...
                                    Spike_Rates_each_burst_after_Classification(  HiLo_Low_responses_index ) ;
                        Max_Low_resp =  max(Low_responses_Spike_Rates_ech_Burst) ;
                        Min_Low_resp =  min(Low_responses_Spike_Rates_ech_Burst) ;
                        HiLo_Low_Responses_Spike_Rates_Relative_Range = ( Max_Low_resp - Min_Low_resp ) /  ( Min_Low_resp + (Max_Low_resp-Min_Low_resp)/2 ) ;                

                        HiLo_Low_Responses_Spike_Rates_Relative_Range;

                        HiLo_Low_Responses_Spike_Rates_Relative_STD = std( Low_responses_Spike_Rates_ech_Burst )/...
                                    mean( Low_responses_Spike_Rates_ech_Burst ) ;  

                        HiLo_Low_Responses_Spike_Rates_Relative_STD ;       


                        High_Responses_TSR_Threshold
                        High_Responses_Percent
                        HiLo_High_Responses_number
                        HiLo_Low_Responses_number ;
                 
                    
                    
                end
          
      %================== MAIN OUTPUT =====================          
                Patterns.HiLo_High_responses_index =    HiLo_High_responses_index ;
                Patterns.HiLo_Low_responses_index  =    HiLo_Low_responses_index ;
                Patterns.HiLo_High_Responses_number =  HiLo_High_Responses_number ;
                Patterns.HiLo_Low_Responses_number = HiLo_Low_Responses_number ;
                Patterns.HiLo_High_Responses_TSR_Threshold = High_Responses_TSR_Threshold;
                Patterns.HiLo_High_Responses_Percent= High_Responses_Percent ;
                Patterns.HiLo_Low_Responses_Percent= Low_Responses_Percent ;
                Patterns.HiLo_Davies_Bouldin_TSR_Clustering_index = Davies_Bouldin_TSR_Clustering_index ;
                Patterns.HiLo_squared_sum_of_errors_CLUSTERING_Spike_Rates_each_burst = squared_sum_of_errors_CLUSTERING_Spike_Rates_each_burst ;
                Patterns.HiLo_High_responses_present = HiLo_High_Responses_number > 0 ;    
                Patterns.HiLo_Low_responses_present = HiLo_Low_Responses_number>0 ; 
                Patterns.HiLo_High_Responses_Spike_Rates_Relative_Range=HiLo_High_Responses_Spike_Rates_Relative_Range;
                Patterns.HiLo_High_Responses_Spike_Rates_Relative_STD=HiLo_High_Responses_Spike_Rates_Relative_STD;
                Patterns.HiLo_Low_Responses_Spike_Rates_Relative_Range=HiLo_Low_Responses_Spike_Rates_Relative_Range;        
                Patterns.HiLo_Low_Responses_Spike_Rates_Relative_STD=HiLo_Low_Responses_Spike_Rates_Relative_STD;        
      %================================================                 
           

          end
                
                
                %---- Find PSTH (TimeBin_Total_Spikes_mean) fro High
                %responses and then for low responses
                 
                 
                if flags.SHOW_FIGURES_low_hi_responses
                    
                    if Patterns.HiLo_High_responses_present 
                              HIGH_TimeBin_Total_Spikes  = TimeBin_Total_Spikes_after_Classification ;
                            
                              HIGH_TimeBin_Total_Spikes_mean=[];
                              HIGH_TimeBin_Total_Spikes_std=[];
                              
%                               HIGH_TimeBin_Total_Spikes = HIGH_TimeBin_Total_Spikes( Patterns.HiLo_High_responses_index  , : ) ;   
                               HIGH_TimeBin_Total_Spikes = TimeBin_Total_Spikes_after_Classification( Patterns.HiLo_High_responses_index  , : ) ; 
                               
                                for ti=1:fire_bins 
                                     HIGH_TimeBin_Total_Spikes_mean( ti ) = mean( HIGH_TimeBin_Total_Spikes( : , ti ));
                                     HIGH_TimeBin_Total_Spikes_std( ti ) = std( HIGH_TimeBin_Total_Spikes( : , ti ));
                                end   
                    end          
                
                
                               LOW_TimeBin_Total_Spikes = TimeBin_Total_Spikes_after_Classification  ;
                            
                               
                              LOW_TimeBin_Total_Spikes_mean=[];
                              LOW_TimeBin_Total_Spikes_std=[];
                                     
%                               LOW_TimeBin_Total_Spikes = LOW_TimeBin_Total_Spikes( Patterns.HiLo_Low_responses_index , : ) ;   
                              LOW_TimeBin_Total_Spikes = TimeBin_Total_Spikes_after_Classification( Patterns.HiLo_Low_responses_index , : ) ; 
                              
                                for ti=1:fire_bins 
                                     LOW_TimeBin_Total_Spikes_mean( ti ) = mean( LOW_TimeBin_Total_Spikes( : , ti ));
                                     LOW_TimeBin_Total_Spikes_std( ti ) = std( LOW_TimeBin_Total_Spikes( : , ti ));
                                end  
                 
                 
                        f= figure ;
                        figure_title = 'Bursts classification' ;
                    set(f, 'name',  figure_title ,'numbertitle','off' )

                     Nx = 2; Ny=2;
                            subplot(Ny,Nx,1)
                            
                            if Patterns.HiLo_High_responses_present 
                                
                                hold on 
                                    [n, xout] = hist( [ Data1 ; Data2 ] , 30 );
                                    bar( xout , n ,1 ) 
                                    bar( High_Responses_TSR_Threshold , max(n) , 0.5 , 'r')
                                    legend( 'Spikes in response', 'Response threshold')
                                    hold off
                                    title( 'Spike rates histogram')
                            else 
                                    [n, xout] = hist( Patterns.Spike_Rates_each_burst   , 30 );
                                    bar( xout , n ,1 )  
                                    legend( 'Spikes in response' ) 
                                    title( 'Spike rates histogram')
                                
                            end
                            
                            if ~Patterns.HiLo_High_responses_present 
                                Data1 =  Patterns.Spike_Rates_each_burst ;
                                Data2 = [];
                            end
                            subplot(Ny,Nx,2)
                                hold on
                                plot( Data1 )
                                plot( Data2,'r' )
                                is_DBindex_small = '';
                                if Davies_Bouldin_TSR_Clustering_index  < Davies_Bouldin_TSR_Clustering_index_Threshold
                                    is_DBindex_small = '(small)';
                                end
                                title( [ 'Clustering, DBindex = ' num2str( Davies_Bouldin_TSR_Clustering_index  ) ' ' is_DBindex_small ])
                                xlabel('Stimulus #')
                                ylabel('Spike rate')
                                hold off

                          subplot(Ny,Nx,3)
                            DT_bins_number = floor(( End_classify - Start_Classify  ) / DT_classify ) ;
                            Start_t =  Start_Classify ; 
                            TimeBins = 0 : DT_bins_number-1 ; 
                            TimeBins_x = Start_Classify + TimeBins * DT_classify ;
                            if Patterns.HiLo_High_responses_present 
                            barwitherr2( HIGH_TimeBin_Total_Spikes_std , TimeBins_x  , HIGH_TimeBin_Total_Spikes_mean );
                                 title( ['High reponses PSTH'  ', bin=' int2str( DT_classify ) 'ms' ] )
                                xlabel( 'Post-stimulus time, ms')
                                ylabel( 'Spikes per bin')
                                if max( HIGH_TimeBin_Total_Spikes_mean ) > 1
                                    axis( [ min( TimeBins_x  )- DT_classify   max( TimeBins_x ) + DT_classify   ...
                                        0 1.2 * max(   HIGH_TimeBin_Total_Spikes_std) ...
                                         + max(  HIGH_TimeBin_Total_Spikes_mean) ] )
                                end
                            end
                          subplot(Ny,Nx,4)          
%                             DT_bins_number = floor((Patterns.Poststim_interval_END - Patterns.Poststim_interval_START) / DT_classify ) ;
%                             Start_t =  Patterns.Poststim_interval_START ;
%                             TimeBins = 0 : DT_bins_number-1 ; 
%                             TimeBins_x = Start_t + TimeBins * DT_classify ;
                        if ~isempty( LOW_TimeBin_Total_Spikes_mean )
                            barwitherr2( LOW_TimeBin_Total_Spikes_std , TimeBins_x  , LOW_TimeBin_Total_Spikes_mean );
                                 title( ['Low responses PSTH'  ', bin=' int2str( DT_classify ) 'ms' ] )
                                xlabel( 'Post-stimulus time, ms')
                                ylabel( 'Spikes per bin')
                                if max( LOW_TimeBin_Total_Spikes_mean ) > 1
                                    axis( [ min( TimeBins_x  )- DT_classify   max( TimeBins_x ) + DT_classify   ...
                                        0 1.2 * max(   LOW_TimeBin_Total_Spikes_std) ...
                                         + max(  LOW_TimeBin_Total_Spikes_mean) ] )
                                end  
                                
                              if exist( 'GLOB' )                          
                                 if isfield( GLOB , 'pause_on_cluster_figs' )  
                                     if GLOB.pause_on_cluster_figs
                                        pause 
                                     end
                                 end    
                              end   
                        end
                                
                end
                
 