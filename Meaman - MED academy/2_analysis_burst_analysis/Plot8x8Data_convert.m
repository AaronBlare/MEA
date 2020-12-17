%  Plot8x8Data
function Data2d = Plot8x8Data_convert( dat   )


Nchan = length( dat ) ;
Data = zeros(8,8);
DIV = 8 ;

Nchan ;


%    N = 60 ;
%      load( 'MEAchannel2dMap.mat');   
%      Electrode_map1d2d = [] ;
%     % MEA_channel_coords(i).chan_X_coord , i=1..60
%     %     MEA_channel_coords(i).chan_Y_coord
%         for i = 1 : N    
%            y_i =  MEA_channel_coords(i).chan_Y_coord ;
%            x_i =  MEA_channel_coords(i).chan_X_coord  ; 
%            num_str = [ int2str( x_i )  int2str( y_i ) ] ;
%            Num2d_i = str2num( num_str ) ;
%            Electrode_map1d2d = [ Electrode_map1d2d ; [ i  Num2d_i ] ] ;
%            
%         end
%        
% Electrode_map1d2d


if nargin == 1 
    new_figure = true ;
end
    
if Nchan == 64
   mea_type = 1 ; % med64 type
end
if Nchan == 60
   mea_type = 2 ; % mea type
end

%  mea_type = 1 ;
%  dat = reshape( dat , 1,[]);
%  dat = [ dat   0  0  0  0 ];

if mea_type == 1  % Med64 MEA 64 channels
    

    N = 64;
    x1 = 0 ; x2 = 0 ; y1 = 1 ; y2 = 0 ;
    for i = 1 : N    
      if x1 < DIV x1=x1+1 ; else x1=1 ; y1=y1+1 ; end  

         Data(    y1 , x1) = dat( i ) ;     

    end
    
else 
     if   mea_type == 2 % 60 channels MEA
         N = 60 ;
     load( 'MEAchannel2dMap.mat');   
    % MEA_channel_coords(i).chan_X_coord , i=1..60
    %     MEA_channel_coords(i).chan_Y_coord
        for i = 1 : N    
             Data(  MEA_channel_coords(i).chan_Y_coord  , MEA_channel_coords(i).chan_X_coord ) = dat( i ) ;     
        end
     end  
end

Data2d = Data ;











