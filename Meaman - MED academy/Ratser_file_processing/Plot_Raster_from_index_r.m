   


% Plot_Raster_from_index_r 

Ny = 3 ;
            %-------- AWSR------------------------
%                if params_raster.awsr_raster_on_single_plot
        %           h1 = subplot( 2 , 1 , 1 ) ;
        %         h1 =  tight_subplot(2, 1, 0.005, 0.1 , 0.07);
        
%                 h1 =  tight_subplot(2, 1, 0.008, 0.07 , 0.07);
                 h1 = subplot( Ny , 1 , 1 );

                     % build spike rate diagram from raster
                     params.show_figures = true;
                     params.new_figure = false ;
                     params.x_label = false;
                     if isfield( Search_Params, 'TimeBin' )
                         TimeBin = Search_Params.TimeBin ;
                     else
                          TimeBin = 5 ;
                     end
                     AWSR_from_index_r( index_r  ,   TimeBin , params ) ;
                    % Input - index_r , TimeBin , params.show_figures , params.new_figure ,
                    % params.x_label
                     ylabel(['TSR, spikes per ' num2str(  TimeBin) ' ms']) 
        %             set(h1(1),'XTick',[])
                      xlabel( 'Time, s' )
%                end
 


            %-------- RASTER ------------------------ 
                % N = 64 ;
                Tmax = max( index_r( : , 1 )/1000 ) ;
                N = max( index_r( : , 2 )  ) ;
                h2 = subplot( Ny , 1 , [ 2 3 ] );
                % set(gcf,'position');

                if Old_school_raster_presentation
                    plot( index_r(:,1)/1000 , index_r(:,2) , '.','MarkerEdgeColor',[.04 .52 .78] );
                else
                    
                    if ~Raster_show_color_amplitudes
                    vertHexX=[  0 0     ] ;
                    vertHexY=[  0 0.5       ] ; 
                    plotCustMark(  index_r(:,1)/1000  , index_r(:,2) ,vertHexX,vertHexY, 1.5);
                    
                    else
                     scatter( index_r( : , 1 )/1000 , index_r( : , 2 )  , 3, index_r( : , 3 ) ,'s' );
                     maxAmp = -0.0 ;
                     minAmp = min( index_r( : , 3 ) ) ;
                     minAmp = -0.3 ;
                     minAmp = Raster_show_color_amplitudes_minAmp ;
                     caxis( [ minAmp maxAmp ] )
                     colorbar 
                    end
      
                end 

%                 axis( [ 0 (Tmax+min(index_r(:,1))/1000) 0 N+1 ] )
                xlabel( 'Time, s' )
                ylabel( 'Electrode' )

%                 if params_raster.awsr_raster_on_single_plot
%                     set( h1( 1:2) ,'XTickLabel',[0 : max( (index_r(:,1))/1000 ) ])
%                     linkaxes( [ h1 ] ,  'x');
                        linkaxes( [ h1  h2] ,  'x');
%                 end 
    

            if  Raster_show_color_amplitudes 
                figure 
                     Number_of_bars = 100 ;
                     HStep =   min( index_r( : , 3 ) ) / Number_of_bars ;
                      xxx =   min(index_r( : , 3 ))  : abs(HStep): max(index_r( : , 3 )) ;
                     [bar_y,xout] = histc( index_r( : , 3 ) ,xxx) ;
                     xout = xxx ;
                     bar_y = 100 * bar_y / length( index_r( : , 3 ) ); 
                      
                      fig = bar( xout , bar_y );  
                      xlabel( 'Ampliture, mV');
                      ylabel( 'Count, %')
                      title( 'Amplitude histogram')



            end




         