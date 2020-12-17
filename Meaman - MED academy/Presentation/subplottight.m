function h = subplottight(n,m,i)
    [c,r] = ind2sub([m n], i);
    dr = 0.026  ;
    left_p =(c-1)/m + dr ;
    bott_p = 1-(r)/n  - dr ;
    w_p= 1/m - dr ;
    h_p  = 1/n ;
    ax = subplot('Position', [ left_p , bott_p , w_p , h_p]);
    if(nargout > 0)
      h = ax;
    end