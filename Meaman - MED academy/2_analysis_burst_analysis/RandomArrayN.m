

% RandomArrayN
function Y = RandomArrayN( N )

                Y=zeros( N ,1);
                    Taken=zeros( N ,1);
                    i=1;
                    while i<=N
                         x=round( (N-1) * rand() ) +1 ;
                        if Taken(x)==0 
                        Y(i)=x;
                        Taken(x)=1; 
                        i=i+1;
                        end
                    end