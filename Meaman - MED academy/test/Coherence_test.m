% Coherence_test

Fs = 3000 ;
t = 0: 1/Fs : 2-1/Fs;
Nx = 2 ; Ny = 1 ; 

x  = 1*cos(2*pi*  8  * t)+  3  * sin(2*pi*  19   *t)+ 0.01 *randn(size(t));  
y  = 2*cos(2*pi*  8  * t)+  3  * sin(2*pi*  12   *t)+ 0.01 *randn(size(t)); 

figure
subplot( Ny , Nx , 1 )
hold on
plot( t,x)
plot( t , y , 'r')

hold off
 
win =  tukeywin( 700  , 0.25 ); 
 [Pxy,F] = mscohere( x ,y  , win , 20  , 100000  , Fs ); 
 
 subplot( Ny , Nx , 2 )
 plot(F,Pxy,'linewidth',2); title('Magnitude-squared Coherence');
  xlabel('Hz');  
  axis( [0 20  0 max( Pxy ) ] )

  
  
  

wname  = 'cgau2';
scales = 1:512;
ntw = 21;
t  = linspace(0,1,2048);
x = sin(16*pi*t)+0.25*randn(size(t));
y = sin(16*pi*t+pi/4)+0.25*randn(size(t));
wcoher(x,y,scales,wname,'ntw',ntw,'plot','cwt');

