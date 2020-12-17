
% Six_well_processing

% Result --->>>>

    


Extract_6well_rasters

figure
hall = [] ;
       for wi = 1 : 6 
           index_r_6well = index_r_6well_all.RASTER_data( wi).index_r ; 
            Tmax = max( index_r_6well( : , 1 )/1000 ) ;
            N_check = max( index_r_6well( : , 2 )  ) ;            
            N= 9 ;
            hi = subplot( 2, 3, wi );
            hall = [ hall hi ] ;
            % set(gcf,'position');
            if ~isempty( N_check )
              
            plot( index_r_6well(:,1)/1000 , index_r_6well(:,2) , '.','MarkerEdgeColor',[.04 .52 .78] )
            axis( [ 0 (Tmax+min(index_r_6well(:,1))/1000) 0 N+1 ] )
                        xlabel( 'Time, s' )
            ylabel( 'Electrode' )
            title( [ 'Well ' num2str( wi ) ] );
            else
            plot( [] , []  )    
            end
            
       end
            
       linkaxes( hall, 'x' );
            