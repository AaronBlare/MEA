
function chan = readChanNum( sstr ) 

% sstr = 'z24' ;  % 24 -> "17"
% sstr = 'z46' ;  % 24 -> "17"
% sstr = '2' ;
% sstr = 'z32 z65' ;  % 24 -> "17"


[ charc numc ] = strread( sstr ,  '%c%d '   )  ;



if ~strcmp( charc , 'z' )
  numc = strread( sstr ,  '%d '  ) ;  
else
    [ charc c1 c2  ] = strread( sstr ,  '%c%c%c '   )  ;
    
    x1 = str2num( c1 ) ;
    y1 = str2num( c2 ) ;
    
   load( 'MEAchannel2dMap.mat');   
   
   N = 60 ;
        for i = 1 : N    
          if  MEA_channel_coords(i).chan_Y_coord  == y1 && ...
            MEA_channel_coords(i).chan_X_coord  == x1 
                numc = i ;
          end
        end
   
end

numc;
    

chan = numc ;







