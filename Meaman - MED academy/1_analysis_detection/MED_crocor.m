function  maxcordelay  = MED_crocor( x , y , maxlag );
% returns time delay in points where max cross-corrleation is
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
% M > 0

  %s = sum( ( x( M :N) - Mx )*( y(1:N-M+1) - My ) );

temp=zeros(maxlag,1);

% Delay < 0 - negative shift
for i=1:maxlag
    Mx = sum(  x(1:length(x)-i,1) ) / ( N - i );
    My = sum( y(1+i:end,1) ) / ( N - i );    
    sigmax = sum( ( x(1:length(x)-i,1) - Mx ).^2 ) / (N-i) ;
    sigmay = sum( ( y(1+i:end,1) - My ).^2 )  / (N-i) ;
    temp(maxlag-i+1,1)=(x(1:length(x)-i,1)' - Mx )*(y(1+i:end,1) - My );   
    if ( sigmax > 0 )&( sigmay >0 )
    temp(maxlag-i+1,1) = temp(maxlag-i+1,1) /( (N-i)* sqrt( sigmax) * sqrt( sigmay ));  
    else    
    temp(maxlag-i+1,1) = 0 ;
    end
end  

temp2=zeros(maxlag+1,1);
for i=0:maxlag
    Mx = sum( x(1+i:end,1) ) / ( N - i );
    My = sum( y(1:length(y)-i,1) ) / ( N - i );    
    sigmax = sum( ( x(1+i:end,1)' - Mx ).^2 )  / (N-i) ;
    sigmay = sum( ( y(1:length(y)-i,1) - My ).^2 )  / (N-i) ;
    temp2(i+1,1)=(x(1+i:end,1)' - Mx )*(y(1:length(y)-i,1) - My );   
    if ( sigmax > 0 )&( sigmay >0 )
    temp2(i+1,1)  = temp2(i+1,1) /( (N-i)* sqrt( sigmax) * sqrt( sigmay ));        
    else
    temp2(i+1,1) = 0 ;
    end
end    

if flag==1
    temp = temp';
    temp2 = temp2';    
end
[ cors ] = [ temp' temp2' ]' ;

[c , i] = max ( cors ) ;
i(1) = i(1) - ( maxlag + 1 ) ;
maxcordelay = i(1) ;

% plot( 1:length(cors) , cors ), grid on


  
 
