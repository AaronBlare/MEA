% adjust spike times to average spike time in pattern
function [A, dur ] = center_mass( N1_s, N1_e,  motif )

N=64 ;
center_mass = zeros(N,1);
mot_mass = zeros(N,1);
c_mass = zeros(N,1);
mot= zeros(N1_e - N1_s + 1  ,N);

for nncm = 1 : N1_e - N1_s  
  mot(nncm , :) = motif( N1_s -1 + nncm , : );
end
    
for k = 1 : N
    hh = 0 ; 
    for nncm = N1_s : N1_e  
        hh = hh + H( motif( nncm  , k ) ) ;       
    end
    if hh > 0 mot_mass( k ) = 1 ; end
%     mot_mass( k )
c_mass( k )  =  median( motif( : , k ) ) ;
end
 mint =  min( c_mass( : )  ) ;
for k = 1 : N
center_mass( k ) =  c_mass( k ) - mint + 1 ;
end
A = center_mass ;
% [center_mass, dur_mass ] = PatternsAdjustSpikes( c_mass) ;
dur = max( center_mass( : )) - min( center_mass( : ) ) ;
