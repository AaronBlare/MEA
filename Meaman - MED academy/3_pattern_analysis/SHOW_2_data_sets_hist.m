


%    SHOW_2_data_sets_hist 
%  Input - BINS_NUM , Data1  , Data2 
%  figure should be created before 
                 
                 
                  

                Min_diff= min(  [ min( Data1 ) min( Data2 ) ] );
                 MMax_diff= min( [ max( Data1 ) max( Data2 ) ] );                 
                 HStep = ( MMax_diff -  Min_diff )/ BINS_NUM ;
                 
            	 xxx =  Min_diff  : HStep: MMax_diff ;
                [n,xout] = histc( Data1  ,xxx) ;
                n2 = n / length( Data1  )* 100 ;
                                    
                [n3,xout3] = histc( Data2  ,xxx) ;
                n4 = n3 / length( Data2  )* 100 ;           
                
                if numel( xxx ) > 2  && numel( n4 ) > 2 && numel( n2  ) > 2
                hold on
                    bar( xxx ,n4 ,  'r' ) 
                    bar( xxx ,n2  , 0.4 )
                hold off
                end


