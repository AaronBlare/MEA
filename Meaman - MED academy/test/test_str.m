% test_str


a=POST_STIM_RESPONSE_a.burst_activation;
b=POST_STIM_RESPONSE_b.burst_activation;

a = a* 2.2 ; 
b = b* 1.5 ;
a( a> 90 )=0;
b( b> 90 )=0;

% a=a01.burst_activation;
% a(1,:)= [] ;
% b=b01.burst_activation;
% a = at ;
% b = bt ;
% b =b*1.1 +2 ;
% 
% a(a==NaN)=0;
% b(b==NaN)=0;
% POST_STIM_RESPONSE_a.burst_activation

% a( 60 , 64 );
a=a0/ 1.5 ;
b=b0;

% figure
% imagesc( c   )
% colorbar

Nt = 15 ; as = 15 ;

chan = 17 ; % 17
c = [ a'  b' ];
c2 = [ a( as+1 :as +Nt,:)' b(1:Nt,:)' a( 30+1:30+Nt,:)' b(31:30+Nt,:)'];
a11 = [ a( as+1:as+Nt,chan)' ] ;
a12 = [ a(30+1:30+Nt,chan)' ];
a1 = [ a11 a12 ] ;
b11 = [ b( 1:Nt,chan)' ];
b12 =b(31:30+Nt,chan)' ;
b1 = [ b11 b12 ];
a10 = a1; a10( a10 == 0)=[];
b10 = b1; b10( b10 == 0)=[];
h1_if_norm = jbtest(a1)
h1_if_norm = jbtest(b1)
[ctrl_stable_0 ] = ttest( a11' , a12'  )  
[h1_if_diff ] = ttest( a1' , b1'  )  
% if h1_if_diff
%   titles = '*';
% else
%   titles = '' ;
% end

figure
imagesc( c2  )
colorbar
xlabel( 'Stimulus #')
ylabel('Electrode #')
title( 'Total spike rate, spikes/response')

figure
hold on
plot( 1: Nt ,c2( chan , 1: Nt   ) , 'Linewidth' , 1 )
plot( Nt+1:Nt+Nt , c2( chan , Nt+1:Nt+Nt ),'r', 'Linewidth' , 1 )
plot( Nt+Nt+1:Nt*3, c2( chan ,Nt+Nt+1:Nt*3 ), 'Linewidth' , 1 )
plot( Nt*3+1:Nt*4 ,c2( chan , Nt*3+1:Nt*4 ),'r', 'Linewidth' , 1 )
xlabel( 'Stimulus #')
ylabel( 'TSR, spikes')
hold off

figure
hold on
plot( a10  , 'Linewidth' , 1 )
plot( b10, 'r', 'Linewidth' , 1 ) 
xlabel( 'Stimulus #')
ylabel( 'TSR, spikes')
hold off


% a = [ 36 12 4 2.4 ]
% s = [ 8 9 6 3 ]
% barwitherr( s , [ 1 2 3 4] , a )

% figure
% Nx =1;Ny=2;
% subplot(Ny,Nx,1)
% imagesc( c )
% subplot(Ny,Nx,1)
% imagesc( c2  )
% subplot(Ny,Nx,2)
% hold on
% plot( 1:30 ,c2( chan , 1:30 ) , 'Linewidth' , 2 )
% plot( 61:90 , c2( chan , 61:90 ), 'Linewidth' , 2 )
% plot( 31:60, c2( chan , 31:60 ),'r', 'Linewidth' , 2 )
% plot( 91:120 ,c2( chan , 91:120 ),'r', 'Linewidth' , 2 )
% hold off
% subplot(Ny,Nx,3)
% hold on
% plot( a10 )
% x1 = length( a10)+1:length( a10)+length(b10) ;
% plot( x1 , b10 , 'r') 
% subplot(Ny,Nx,4)
% barwitherr(  [ std( a1) std(b1) ] ,1:2 ,[ mean( a1 ) mean(b1)  ]   );
% title( titles )




 

