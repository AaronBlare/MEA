function  CompareResult  = Sync_coeff( x , y , D_T , X_events , Y_events );
% 
s = 0 ;
%sizeA=size(x);
%flag=0;
%if sizeA(1,2) > 1
%    flag=1;
%    x=x';
%    x=x';
%end

if length(x) >= length(y)
    %zero pads and reverses B
    y=[zeros(length(x)-length(y),1); y(length(y): -1:1)];
else
    %zero pads A
    x=[x;zeros(length(y)-length(x),1)];
    %reverses B
    y=y(length(y): -1:1);
end

TN = length( x );
DT = D_T ;

R = 0 ;
for Ti = 1 : DT  : TN - DT
  SumX = sum( x( Ti : Ti + DT ) )  ;
  SumY = sum( y( Ti : Ti + DT ) )  ;
%  [ SumX  SumY ]
  if ( SumX > 0 )& ( SumY > 0 )
     R = R + 1 ;  
  end       
end

 R = R / min( X_events , Y_events );

CompareResult = R ;





