function  [Data1_new , Data2_new] = Erase_Specified_Channels( Data1 , Data2 ,  CHANNELS )
 
s = size( size(Data1 )) ; 
DIM = s(2) ; 
  for ch = 1 : length(CHANNELS)             
      
 chan = CHANNELS(ch) ; 
       if DIM == 3
          Data1( : , chan , : ) = 0 ;        
          Data2( : , chan , :) = 0 ;
        else
          Data1( : , chan  ) = 0 ;        
          Data2( : , chan  ) = 0 ;  
        end
  end
  
  Data1_new = Data1;
  Data2_new = Data2;