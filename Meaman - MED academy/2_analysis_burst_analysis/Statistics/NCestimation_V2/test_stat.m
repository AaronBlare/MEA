


% test_stat

N=100 ;
DATA1=floor( 3*randn( N,1))+ 0  ;
DATA2=floor( 3*randn( N,1))+ 7  ;

figure
subplot(1,2,1)
hist( [ DATA1 ; DATA2 ] , 100 ) 

data= [ DATA1  DATA2 ]' ;
labels = [ 1* ones( N,1)   2*ones(N,1)] ;

 



