     
% Show_figure_2clusters_separation
% input :
% var.figure_title = 'Small bursts filtering' ;
%   var.xlabel_defined   ;
%   var.xlabel
%   var.Davies_Bouldin_Clustering_index
% Data1 Data2 Data_classify_thresh Classification_data High_values_data_number



                            f=figure ;
                             set(f, 'name', var.figure_title ,'numbertitle','off' )

                               Nx = 2; Ny=1;
                                subplot(Ny,Nx,1)

                                if High_values_data_number > 0  
 
%                                         [n, xout] = hist( [ Data1 ; Data2 ] , 30 ); 
                                        
                                             Number_of_bars = 20 ;
                                             HStep =   max( Classification_data ) / Number_of_bars ; 
                                             diap = max( Classification_data ) - min(  Classification_data ) ;
                                             xxx =  0 : HStep: max(Classification_data) ; 
                                             [bar_y,xout] = histc( [ Data1 ; Data2 ]  ,xxx) ;
                                             xout = xxx ;
                                             
                                        hold on 
                                            fig =bar( xout , bar_y ); 
                                            bar( Data_classify_thresh , max( bar_y ) , 1  , 'r')
                                        hold off      
                                       
                                       axis( [   min( xout )-0.1*diap max( xout )+0.1*diap 0 1.2 * max( bar_y  ) ] )
                                       legend( 'Data', 'Threshold')
                                       title( 'Data histogram')
                                             h = findobj(fig,'Type','patch');
                                             set(h,'FaceColor',[.04 .52 .78])
                                             
                                             
                                else 
                                        [n, xout] = hist( Classification_data   , 30 );
                                        bar( xout , n ,1 )  
                                        legend( 'Data' ) 
                                        title( 'Data histogram')

                                end
                                ylabel('Count #')
                                if var.xlabel_defined
                                         xlabel( var.xlabel  ) 
                                    else
                                         xlabel('Data value')
                                end
                                    

                                if High_values_data_number == 0 
                                    Data1 =  Classification_data ;
                                    Data2 = [];
                                end
                                subplot(Ny,Nx,2)
                                    hold on
                                    plot( Data1 )
                                    plot( Data2,'r' )
%                                     plot( Classification_data )

                                    title( ['Separated data, DB_i_n_d_e_x=' num2str( var.Davies_Bouldin_Clustering_index ) ] )
                                    xlabel('Data number')
                                    if var.xlabel_defined
                                         ylabel( var.xlabel  ) 
                                    else
                                         ylabel('Data value')
                                    end
                                    hold off
                                    legend( 'Cluster 1' , 'Cluster 2')
                                    
                                    
                                    
                                    
                                    
          