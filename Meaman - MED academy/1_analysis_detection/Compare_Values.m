function  CompareResult  = Compare_values( x , y , D_T )
% 
% s = 0 ;
%sizeA=size(x);
%flag=0;
%if sizeA(1,2) > 1
%    flag=1;
%    x=x';
%    x=x';
%end
% 
% if length(x) >= length(y)
%     %zero pads and reverses B
%     y=[zeros(length(x)-length(y),1); y(length(y): -1:1)];
% else
%     %zero pads A
%     x=[x;zeros(length(y)-length(x),1)];
%     %reverses B
%     y=y(length(y): -1:1);
% end
PLOT_RESULT = 'n' ;


TN = length( x );
DT = D_T ;

R = 0 ;
X_bin_events = 0 ;
Y_bin_events = 0 ;
SS = [] ;

% xx = zeros(1 , floor( TN / DT )-1 ) ;
% yy = ones(1 , floor( TN / DT )-1 ) ;
% Syn = 2*ones(1 , floor( TN / DT )-1 ) ;

for Ti = 0 : floor( TN / DT )-1
  SumX = sum( x( 1 + Ti*DT : Ti*DT + DT  ) )  ;
  SumY = sum( y(1 + Ti*DT : Ti*DT + DT ) )  ;
  if SumX > 0 
    X_bin_events = X_bin_events + 1 ;
%     xx( Ti +1) = 1 ;
  end  
  if SumY > 0  
    Y_bin_events = Y_bin_events + 1 ;
%     yy( Ti +1) = 2 ;
  end  
%  [ SumX  SumY ]
  if ( SumX > 0 )&&( SumY > 0 )
     R = R + 1 ;  
%      Syn( Ti+1 ) = 3 ;
  end       
  
%   S   = [ Ti   R SumX SumY ] ;
%   SS = [ SS ; S ] ;
end
% SS
if min( X_bin_events , Y_bin_events ) > 0
  R = R / min( X_bin_events , Y_bin_events ) ;
else
 R = 0 ;
end

% if PLOT_RESULT == 'y'
% Ti = 1 : floor( TN / DT )-1 ;
% figure
% plot( Ti , xx , Ti , yy , Ti , Syn )
% end

CompareResult = R ;





