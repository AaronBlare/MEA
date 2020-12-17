

x = randn( 10 , 2 );
y = randn( 10 , 2 )+3 ;

whos x
whos y

[ Not_distinguishable_points_num , Clustering_error_precent ]= ...
    Clustering_accuracy_2clusters( x,y  )

