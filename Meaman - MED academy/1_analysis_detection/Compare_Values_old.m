function  CompareResult  = Compare_values( x , y  );
% 
s = 0 ;
sizeA=size(x);
flag=0;
if sizeA(1,2) > 1
    flag=1;
    x=x';
    x=x';
end

if length(x) >= length(y)
    %zero pads and reverses B
    y=[zeros(length(x)-length(y),1); y(length(y): -1:1)];
else
    %zero pads A
    x=[x;zeros(length(y)-length(x),1)];
    %reverses B
    y=y(length(y): -1:1);
end

N = length( x );

    Mx = sum(  x(1:length(x),1) ) / ( N  );
    My = sum( y(1:end,1) ) / ( N );    
    sigmax = sum( ( x(1:length(x),1) - Mx ).^2 ) / (N) ;
    sigmay = sum( ( y(1:end,1) - My ).^2 )  / (N) ;
    C = ( x(1:length(x),1)' - Mx )*(y(1:end,1) - My );   
    Corr = xcorr(x,y,0,'coeff') ;
    if ( sigmax > 0 )&( sigmay >0 )
    R = C /( (N)* sqrt( sigmax) * sqrt( sigmay ));  
    else    
    R = 0 ;
    end

CompareResult = Corr ;