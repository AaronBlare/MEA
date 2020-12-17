
%                     TimeBin_Total_Spikes should be defined
%                     Clustering_many_clusters_TimeBin_Total_Spikes


[centers,clusters,errors,ind] = kmeans_clusters( Patterns.TimeBin_Total_Spikes    );
%                     [centers,clusters,errors,ind] = kmeans_clusters( Spike_Rates_each_burst   );
                    
                    cs = size( clusters) ;
                    Clusters_to_take = floor( cs(1) /2 );
                    
                    
                    
                    
                    Clusters_to_take = 2;
                    
                    
                    
                    
                    clusters = clusters{ Clusters_to_take ,1};
                    n_elements_in_cluster =[];     
                    for ci = 1 :   Clusters_to_take          
                              index_elements  =  find(clusters == ci)  ;
                            index_elements_in_cluster(ci).index_elements=  index_elements ;
                            n_elements_in_cluster(ci)  =   length( index_elements ) ;            
                    end
                    
                    f=figure ;
                     set(f,'name', var.figure_title ,'numbertitle','off')
                     Nx = Clusters_to_take +2 ; Ny=2;
                            subplot(Ny,Nx,1:2)
                            hold on
                                 plot( Patterns.Spike_Rates_each_burst )
                                 plot( clusters * 50 ,'r');
                                hold off
 
 
                    for ci = 1 :   Clusters_to_take           
 
                            patterns_list = 1 : Patterns.Number_of_Patterns  ;
                            selected_patterns = patterns_list( index_elements_in_cluster(ci).index_elements );  

                             TimeBin_Total_Spikes = Patterns.TimeBin_Total_Spikes ;
                            
                              TimeBin_Total_Spikes = TimeBin_Total_Spikes( selected_patterns , : ) ; 
                                for ti=1:fire_bins 
                                     TimeBin_Total_Spikes_mean( ti ) = mean( TimeBin_Total_Spikes( : , ti ));
                                     TimeBin_Total_Spikes_std( ti ) = std( TimeBin_Total_Spikes( : , ti ));
                                end   
  
                                
                           subplot(Ny,Nx,ci+ci+1)
                           DT_step = Patterns.DT_bin ;
                            DT_bins_number = floor((Patterns.Poststim_interval_END - Patterns.Poststim_interval_START) / Patterns.DT_bin  ) ;
                            Start_t =  Patterns.Poststim_interval_START ; 
                            TimeBins = 0 : DT_bins_number-1 ; 
                            TimeBins_x = Start_t + TimeBins * DT_step ;
                            barwitherr2( TimeBin_Total_Spikes_std  , TimeBins_x  , TimeBin_Total_Spikes_mean );
                                 title( ['High reponses PSTH'  ', bin=' int2str( DT_step ) 'ms' ] )
                                xlabel( 'Post-stimulus time, ms')
                                ylabel( 'Spikes per bin')
                                if max( TimeBin_Total_Spikes_mean ) > 1
                                    axis( [ min( TimeBins_x  )- DT_step   max( TimeBins_x ) + DT_step   ...
                                        0 1.2 * max(   TimeBin_Total_Spikes_std ) ...
                                         + max(  TimeBin_Total_Spikes_mean) ] )
                                end 
                           subplot(Ny,Nx,ci+ci+2)    
                           bar( n_elements_in_cluster(ci));
                            if n_elements_in_cluster(ci) > 0
                                    axis( [ 0   2  ...
                                        0 max(n_elements_in_cluster) ] )
                            end 
                            title( [ 'Responses in cluster ¹' num2str(ci) ])

                    end    
                    
                    
                    
                    
                    
                    