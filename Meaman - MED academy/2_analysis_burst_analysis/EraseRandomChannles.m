

% EraseRandomChannles
function Y = EraseRandomChannles( ZERO_CHANNELS_NUM , N )
       Y=[] ;
                    Taken=zeros( N ,1);
                    i=1;
                    while i<= ZERO_CHANNELS_NUM 
                         x=round( (N-1) * rand() ) +1 ;
                        if Taken(x)==0 
                        Y = [ Y x ];
                        Taken(x)=1; 
                        i=i+1;
                        end
                    end