% adjust spike times to average spike time in pattern
function [  center_mass  , dur , mot_mass ] = center_mass_calc( N1_s, N1_e,  motif , adjust_min )

s = size( motif ) ;
N= s(2)  ;
center_mass = zeros(N,1);
mot_mass = zeros(N,1);
c_mass = zeros(N,1);
SIGNIFICANT_SPIKES_FRAC = 0.2 ;
% mot= zeros(N1_e - N1_s + 1  ,N);
% 
% for nncm = 1 : N1_e - N1_s + 1 
%   mot(nncm , :) = motif( N1_s -1 + nncm , : );
% end


for k = 1 : N
    delays = [] ;
    hh = 0 ; 
    for nncm = N1_s : N1_e  
        hh = hh + H( motif( nncm  , k ) ) ;
        if H( motif( nncm  , k ) ) > 0
        delays = [ delays motif( nncm , k ) ] ;
        end
    end
    if hh / (N1_e - N1_s + 1) > SIGNIFICANT_SPIKES_FRAC 
        mot_mass( k ) = 1 ; end
%     mot_mass( k )
% c_mass( k )  =  median( motif( : , k ) ) ;
% delays
if isempty( delays ) ~= 1
   c_mass( k )  =  mean( delays ) ;
else
   c_mass( k ) = 0 ;  
end
   
end 
% c_mass
if adjust_min == true
    in =  c_mass > 0 ; 
    ix = c_mass( in );
 mint =  min( ix  )  ;
else 
 mint = 0 ;
end

for k = 1 : N
    if c_mass( k ) >0 
        center_mass( k ) =  c_mass( k ) - mint + 1;
    end
end
% A = center_mass ;
% [center_mass, dur_mass ] = PatternsAdjustSpikes( c_mass) ;
if adjust_min == true
 dur = max( center_mass( : )) - min( center_mass( : ) ) ;
else 
 dur = max( center_mass( : )) ;
end

end