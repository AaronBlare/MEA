
function Raster_Plot_from_index_r_func( index_r)

h1 =  tight_subplot(2, 1, 0.008, 0.07 , 0.07);
                 h1 = subplot( 2 , 1 , 1 );

                     % build spike rate diagram from raster
                     params.show_figures = true;
                     params.new_figure = false ;
                     params.x_label = false;
%                      if isfield( Search_Params, 'TimeBin' )
%                          TimeBin = Search_Params.TimeBin ;
%                      else
                          TimeBin = 5 ;
%                      end
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
                h2 = subplot( 2 , 1 , 2 );
                % set(gcf,'position');
 
                    vertHexX=[  0 0     ] ;
                    vertHexY=[  0 0.5       ] ; 
                    plotCustMark(  index_r(:,1)/1000  , index_r(:,2) ,vertHexX,vertHexY, 1.5);
              

%                 axis( [ 0 (Tmax+min(index_r(:,1))/1000) 0 N+1 ] )
                xlabel( 'Time, s' )
                ylabel( 'Electrode' )

%                 if params_raster.awsr_raster_on_single_plot
%                     set( h1( 1:2) ,'XTickLabel',[0 : max( (index_r(:,1))/1000 ) ])
%                     linkaxes( [ h1 ] ,  'x');
                        linkaxes( [ h1  h2] ,  'x');
%                 end 