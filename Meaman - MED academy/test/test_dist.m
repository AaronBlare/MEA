

% test_dist

close all

d1 = [] ;
d2 = [] ;
s0 = 1 ;
s1 = 10 ;
for i = s0 : s1 
    a=rand(10,1) ;
    b=rand(10,1)+i ;
    
    dist1 = rms( [ a - b ] );
    d1 = [ d1 dist1 ] ;
    
    dist2 = pdist( [ a'; b' ] );
    
    d2 = [ d2 dist2 ] ;

end

figure
plot( [ d1' d2' ] )
legend( 'rms' , 'pdist' )



















