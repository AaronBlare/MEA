function Xr = lin2d( X )
N = 60 - 1 ;
if mod( X , N ) == 0
                  f=1;
                else
                  f=0;
                end
                Xr = X + floor( X / (N))   -f ;