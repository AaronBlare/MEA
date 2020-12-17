% Plot_test_x





        if ~isempty( index)
 y_index = zeros( 1 , length( index ) );
% y_index( index) = 0.20;
y_index(:)  = thr ;
y_index =  x( floor( index) ) ;
        end
        
        
 tx = 1:length( x );
tx = tx / sr ;       

figure
hold on
plot(  tx( 1 : floor( length( x ) / 20 ) ), x( 1 : floor( length( x ) / 20 ) ) * 1 , 'b'  )

if ~isempty( index)
        plot(  index / sr , y_index * 1 , 'r*'   )
end

plot(  [ 0 tx( end )  ] , [ -thr -thr ] , 'g--'   )
        


% xlim( [ 3.15 3.19 ] );


% xlim( [ 8.66 8.7] );


% xlim( [ 8.682 8.692 ] );
