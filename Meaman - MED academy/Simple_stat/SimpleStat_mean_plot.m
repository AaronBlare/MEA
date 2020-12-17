
% SimpleStat_mean_plot

close all
a = [ 0 5 4 3 ; 0.2 5.3 5 3 ; 1 6 4 2] ;
a2 = [ 0 5 4 3 ; 0.2 5.3 5 3 ; 1 6 4 2] ;
a2=a2+3 ;

x = [ 1 2 3 4 ];

data_mean = mean( a , 1 )
data_mean2 = mean( a2 , 1 )

data_std = std( a ,1 ) 
data_std2 = std( a2 ,1 ) 

figure
hold on
plot( x , data_mean , 'Linewidth', 2)
errorbar( x , data_mean , data_std )


plot( x , data_mean2 , 'r' , 'Linewidth', 2)
errorbar( x , data_mean2 , data_std , 'r' )







