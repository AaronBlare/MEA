function  [Data1_new , Data2_new , total_number_of_active_channels  ,CHABBELS_ERASED] = ...
        Erase_Rare_Channels(N ,Nb ,Nb2, Data1 , Data2 ,Start_t , Pattern_length_ms , STIM_RESPONSE_BOTH_INPUTS , PRECENT_CHAN_TO_ERASE )
% if Data are 2Darray - pattern_activation -> check for activation pattern,
% otherwise it's bursts and erase all rare active channels
 
s = size( size(Data1 )) ; 
DIM = s(2) ;
total_number_of_active_channels=0;
CHABBELS_ERASED = [];  

% ERASE_RANDOM_CHANNELS = false ;
% ERASE_RANDOM_CHANNELS = true ;
PRECENT_CHAN_TO_ERASE = 0 ;
if PRECENT_CHAN_TO_ERASE > 0 
N_channels_erase = floor( (PRECENT_CHAN_TO_ERASE /100 )*64);
CHABBELS_ERASED= floor( 63*rand( N_channels_erase ,1) + 1);
% CHABBELS_ERASED=CHABBELS_ERASED';
CHABBELS_ERASED
        if DIM == 3
          Data1( : , CHABBELS_ERASED , : ) = 0 ;        
          Data2( : , CHABBELS_ERASED , :) = 0 ;
        else
          Data1( : , CHABBELS_ERASED  ) = 0 ;        
          Data2( : , CHABBELS_ERASED  ) = 0 ;  
        end
end


CHABBELS_ERASED = [];
%   for ch = 1 : N             
%  
%     ch_r =0 ;
%     for t = 1 : Nb    
%         if DIM == 3
%            si = find( Data1( t , ch ,: )> Start_t & Data1( t , ch ,: )<= Pattern_length_ms +Start_t ) ;
%            rate =length( si ) ;if isempty(  rate  )  rate= 0 ;end
%            ch_r = ch_r + H(  rate ); 
%            RSvalues_in_Channels
%         else 
%             if   Data1( t , ch  )> Start_t & Data1( t , ch   )<= Pattern_length_ms +Start_t    
%                ch_r = ch_r + 1 ;
%             end
%         end
%           
%     end
%      
%     ch_r2 =0 ;
%     for t = 1 : Nb2    
%         if DIM == 3
%           si = find( Data2( t , ch ,: )> Start_t & Data2( t , ch ,: )<= Pattern_length_ms +Start_t ) ;
%           rate =length( si ) ;if  isempty(  rate  )  rate= 0 ;end
%           ch_r2 = ch_r2 + H(  rate ) ; 
%         else
% %           ch_r2 = ch_r2 + H(  Data2(  t , ch ) ) ; 
%             if   Data2( t , ch  )> Start_t & Data2( t , ch   )<= Pattern_length_ms +Start_t    
%                ch_r2 = ch_r2 + 1 ;
%             end
%         end
%     end
%     
% %     if ch == 49
% %         ch_r
% %         ch_r2
% %     end
%     % Если есть мало успешных ответов (есть спайк после стим) на электроде
%     % то убрать электрод из анализа 
%       if ch == 49 || ch==57
% %           ch_r
% %           ch_r2
%       end 
%       
%     if  ch_r/Nb > STIM_RESPONSE_BOTH_INPUTS &  ch_r2/Nb2 > STIM_RESPONSE_BOTH_INPUTS  
%        total_number_of_active_channels = total_number_of_active_channels + 1 ;
%     else
%         CHABBELS_ERASED=[CHABBELS_ERASED ch ];
%         if DIM == 3
% %             ch_r/Nb
% %             ch_r2/Nb2
%           Data1( : , ch , : ) = 0 ;        
%           Data2( : , ch , :) = 0 ;
%         else
%           Data1( : , ch  ) = 0 ;        
%           Data2( : , ch  ) = 0 ;  
%         end
%     end
%     
%   end  
 RS_values1 = Get_RS_Values(  N, Data1, Start_t,Pattern_length_ms, [], 100000 ,   Nb ,true);
 RS_values2 = Get_RS_Values(  N,  Data2,Start_t,Pattern_length_ms, [] , 100000 , Nb2 ,true) ;
 for ch = 1 : N 
    if  RS_values1(ch) > STIM_RESPONSE_BOTH_INPUTS &  RS_values2(ch) > STIM_RESPONSE_BOTH_INPUTS 
       total_number_of_active_channels = total_number_of_active_channels + 1 ;
    else
        CHABBELS_ERASED=[CHABBELS_ERASED ch ];
        if DIM == 3
%             ch_r/Nb
%             ch_r2/Nb2
          Data1( : , ch , : ) = 0 ;        
          Data2( : , ch , :) = 0 ;
        else
          Data1( : , ch  ) = 0 ;        
          Data2( : , ch  ) = 0 ;  
        end
    end
 end
  
  
  CHABBELS_ERASED
  Data1_new = Data1;
    Data2_new = Data2;